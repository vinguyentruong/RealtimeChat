//
//  SocketHelper.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import EventBusSwift
import SocketIO
import SwiftyJSON
import Reachability

public typealias SocketStatus = SocketIOStatus

struct SocketIO {
    
    public static let Post              = "post"
    public static let Put               = "put"
    public static let Get               = "get"
    public static let Delete            = "delete"
    public static let Url               = "url"
    public static let Data              = "data"
    public static let Body              = "body"
    public static let Authorization     = "authorization"
    
}

class SocketHelper: NSObject {
    
    // MARK: Property
    
    private let timeOut: Double = 30
    private let baseUrl: String
    private let oauthProtocol: OAuthProtocol?
    
    private let socketManager: SocketManager
    private let socket: SocketIOClient
    private let reachability: Reachability
    
    internal var isConnected: Bool {
        return socketManager.status == .connected
    }
    
    internal var isConnecting: Bool {
        return socketManager.status == .connecting
    }
    
    private var defaultHeaders: [String: String] {
        var headers = [String: String]()
        headers[SocketIO.Authorization] = "Bearer \(OAuthToken.default.accessToken)"
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            headers["deviceId"] = deviceId
        }
        return headers
    }
    
    private var noInternetError: NSError {
        return NSError(
            domain  : "",
            code    : 0,
            userInfo: [NSLocalizedDescriptionKey: "No Internet Connection"]
        )
    }
    
    private var timeOutError: NSError {
        return NSError(
            domain  : "",
            code    : 0,
            userInfo: [NSLocalizedDescriptionKey: "Request timeout. Please try again!"]
        )
    }
    
    // MARK: Constructor
    
    init(baseUrl: String, namespace: String = "/", oauthProtocol: OAuthProtocol? = nil) {
        self.baseUrl = baseUrl
        self.oauthProtocol = oauthProtocol
        
        socketManager = SocketManager(
            socketURL: URL(string: baseUrl)!,
            config: [.log(false),
                     .reconnects(true),
                     .forceNew(true),
                     .forceWebsockets(true),
                     .compress]
        )
        socket = socketManager.socket(forNamespace: namespace)
        reachability = Reachability.init()!
        
        super.init()
        
        startReachability()
    }
    
    deinit {
        stopReachability()
        disconnect()
    }
    
    // MARK: Public method
    
     func connect(timeoutAfter: Double = 0.0, withHandler handler: (() -> ())? = nil) {
        if !isConnected, !isConnecting, reachability.isReachable {
            authenticate({ (error) in
                guard !OAuthToken.default.isExpired else {
                    return
                }
                self.socketManager.config.insert(.extraHeaders(self.defaultHeaders), replacing: true)
                self.socket.on(clientEvent: .statusChange) { (data, ack) in
                    guard let status = data.first as? SocketStatus else {
                        return
                    }
                    EventBus.shared.post(name: .StatusChange, object: status)
                }
                self.socketManager.nsps[self.socket.nsp] = self.socket
                self.socket.connect(timeoutAfter: timeoutAfter, withHandler: handler)
            })
        } else {
            handler?()
        }
    }
    
    internal func disconnect() {
        socket.off(clientEvent: .statusChange)
        socket.disconnect()
        socketManager.disconnect()
    }
    
    internal func on(event: String, responseHandler: ResponseHandler? = nil) {
        socket.on(event) { (data, ack) in
            guard let hasData = data.first else {
                return
            }
            let json = JSON(hasData)
            responseHandler?(json, nil)
        }
    }
    
    internal func off(event: String) {
        socket.off(event)
    }
    
    // MARK: Private method
    
    private func authenticate(_ responseHandler: @escaping (Error?) -> Void) {
        guard
            let oauthProtocol = oauthProtocol,
            OAuthToken.default.isExpired else {
                responseHandler(nil)
                return
        }
        oauthProtocol.oauthRefreshToken({ (response) in
            if let data = response.data {
                OAuthToken.default.update(oauthToken: data)
                responseHandler(nil)
            } else if let error = response.error, (error as NSError).code == 401 {
                NotificationCenter.default.post(name: .OAuthExpiredEvent, object: nil)
            } else {
                responseHandler(response.error)
            }
        })
    }
    
    private func startReachability() {
        reachability.whenReachable = { [weak self] (reachability) in
            guard let sSelf = self else { return }
            
            if reachability.connection != .none {
                sSelf.connect()
            }
        }
        reachability.whenUnreachable = { [weak self] (reachability) in
            guard let sSelf = self else { return }
            
            if reachability.connection == .none {
                sSelf.disconnect()
                EventBus.shared.post(name: .StatusChange, object: SocketStatus.disconnected)
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func stopReachability() {
        reachability.whenReachable = nil
        reachability.whenUnreachable = nil
        reachability.stopNotifier()
    }
    
    private func getPackage(url: String, parameters: Parameters? = nil) -> SocketData {
        var package = [String: Any]()
        package[SocketIO.Url] = url
        package[SocketIO.Data] = parameters
        package[SocketIO.Authorization] = "Bearer \(OAuthToken.default.accessToken)"
        return package
    }
    
    private func getPackage(url: String, parameters: Any? = nil) -> SocketData {
        var package = [String: Any]()
        package[SocketIO.Url] = url
        package[SocketIO.Data] = parameters
        package[SocketIO.Authorization] = "Bearer \(OAuthToken.default.accessToken)"
        return package
    }
    
    private func handleData(data: [Any], responseHandler: ResponseHandler?) {
        if let error = data.first as? String, !error.isEmpty {
            responseHandler?(nil, NSError(
                domain  : "",
                code    : 0,
                userInfo: [NSLocalizedDescriptionKey: error]
            ))
            return
        }
        if let data = data.last {
            let json = JSON(data)
            responseHandler?(json, nil)
        } else {
            responseHandler?(nil, timeOutError)
        }
    }
    
    private func request(method: String, url: String, socketData: SocketData, responseHandler: ResponseHandler? = nil) {
        guard isConnected else {
            responseHandler?(nil, noInternetError)
            return
        }
        socket.emitWithAck(method, socketData)
            .timingOut(after: self.timeOut) { (data) in
                self.handleData(data: data, responseHandler: responseHandler)
        }
    }
    
    private func request(method: String, url: String, parameters: Parameters? = nil, responseHandler: ResponseHandler? = nil) {
        authenticate { (error) in
            if let error = error {
                responseHandler?(nil, error)
            } else {
                self.request(
                    method          : method,
                    url             : url,
                    socketData      : self.getPackage(url: url, parameters: parameters),
                    responseHandler : responseHandler
                )
            }
        }
    }
    
    private func request(method: String, url: String, parameters: Any? = nil, responseHandler: ResponseHandler? = nil) {
        authenticate { (error) in
            if let error = error {
                responseHandler?(nil, error)
            } else {
                self.request(
                    method          : method,
                    url             : url,
                    socketData      : self.getPackage(url: url, parameters: parameters),
                    responseHandler : responseHandler
                )
            }
        }
    }
    
}

// MARK: REST Standard

extension SocketHelper {
    
    internal func get(_ url: String, parameters: Parameters? = nil, responseHandler: ResponseHandler? = nil) {
        request(method: SocketIO.Get, url: url, parameters: parameters, responseHandler: responseHandler)
    }
    
    internal func post(_ url: String, parameters: Parameters? = nil, responseHandler: ResponseHandler? = nil) {
        request(method: SocketIO.Post, url: url, parameters: parameters, responseHandler: responseHandler)
    }
    
    internal func post(_ url: String, parameters: Any? = nil, responseHandler: ResponseHandler? = nil) {
        request(method: SocketIO.Post, url: url, parameters: parameters, responseHandler: responseHandler)
    }
    
    internal func put(_ url: String, parameters: Parameters? = nil, responseHandler: ResponseHandler? = nil) {
        request(method: SocketIO.Put, url: url, parameters: parameters, responseHandler: responseHandler)
    }
    
    internal func put(_ url: String, parameters: Any? = nil, responseHandler: ResponseHandler? = nil) {
        request(method: SocketIO.Put, url: url, parameters: parameters, responseHandler: responseHandler)
    }
    
    internal func delete(_ url: String, parameters: Parameters? = nil, responseHandler: ResponseHandler? = nil) {
        request(method: SocketIO.Delete, url: url, parameters: parameters, responseHandler: responseHandler)
    }
    
}

