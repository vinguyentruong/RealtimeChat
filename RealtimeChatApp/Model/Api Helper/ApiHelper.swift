//
//  ApiHelper.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias Parameters = [String: Any?]
public typealias ResponseHandler = (JSON?, Error?) -> ()
public typealias HeaderHandler = () -> HTTPHeaders?

class ApiHelper: NSObject {
    
    // MARK: Property
    
    private let oauthProtocol: OAuthProtocol?
    private let handlerProtocol: ResponseHandlerProtocol
    private let baseUrl: String
    
    // MARK: Constructor
    
    init(baseUrl: String,
         oauthProtocol: OAuthProtocol? = nil,
         handlerProtocol: ResponseHandlerProtocol = DefaultResponseHandler()) {
        
        self.baseUrl = baseUrl
        self.oauthProtocol = oauthProtocol
        self.handlerProtocol = handlerProtocol
        super.init()
    }
    
    // MARK: Private method
    
    private func authenticate(_ handler: @escaping (Error?) -> Void) {
        //        handler(nil)
        //        return
        guard
            let oauthProtocol = oauthProtocol,
            OAuthToken.default.isExpired else {
                handler(nil)
                return
        }
        oauthProtocol.oauthRefreshToken({ (response) in
            if let data = response.data {
                OAuthToken.default.update(oauthToken: data)
                handler(nil)
            } else if let error = response.error, (error as NSError).code == 401 || (error as NSError).code == 400 {
                NotificationCenter.default.post(name: .OAuthExpiredEvent, object: nil)
            } else {
                handler(response.error)
            }
        })
    }
    
    private func request(_ url           : String,
                         method          : Alamofire.HTTPMethod,
                         parameters      : Parameters?,
                         encoding        : ParameterEncoding,
                         headerHander    : HeaderHandler?,
                         responseHandler : ResponseHandler?) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let fullUrl = url.hasPrefix("http") ? url : "\(baseUrl)\(url)"
        authenticate({ (error) in
            if let error = error {
                responseHandler?(nil, error)
                return
            }
            Alamofire.request(fullUrl,
                              method      : method,
                              parameters  : parameters,
                              encoding    : encoding,
                              headers     : headerHander?())
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.handleResponse(response, responseHandler: responseHandler)
            }
        })
    }
    
    private func handleResponse(_ response: DataResponse<Any>, responseHandler: ResponseHandler? = nil) {
        handlerProtocol.onResponse(response, responseHandler: responseHandler)
    }
    
}

// MARK: REST Standard

extension ApiHelper {
    
    public func get(url             : String,
                    parameters      : Parameters?       = nil,
                    headerHander    : HeaderHandler?   = nil,
                    responseHandler : ResponseHandler?  = nil) {
        request(url,
                method          : .get,
                parameters      : parameters,
                encoding        : URLEncoding.default,
                headerHander    : headerHander,
                responseHandler : responseHandler)
    }
    
    public func post(url             : String,
                     parameters      : Parameters?       = nil,
                     encoding        : ParameterEncoding = URLEncoding.default,
                     headerHander    : HeaderHandler?   = nil,
                     responseHandler : ResponseHandler?  = nil) {
        
        request(url,
                method          : .post,
                parameters      : parameters,
                encoding        : encoding,
                headerHander    : headerHander,
                responseHandler : responseHandler)
    }
    
    public func put(url             : String,
                    parameters      : Parameters?       = nil,
                    encoding        : ParameterEncoding = URLEncoding.default,
                    headerHander    : HeaderHandler?   = nil,
                    responseHandler : ResponseHandler?  = nil) {
        
        request(url,
                method          : .put,
                parameters      : parameters,
                encoding        : encoding,
                headerHander    : headerHander,
                responseHandler : responseHandler)
    }
    
    public func delete(url             : String,
                       parameters      : Parameters?       = nil,
                       encoding        : ParameterEncoding = URLEncoding.default,
                       headerHander    : HeaderHandler?   = nil,
                       responseHandler : ResponseHandler?  = nil) {
        
        request(url,
                method          : .delete,
                parameters      : parameters,
                encoding        : encoding,
                headerHander    : headerHander,
                responseHandler : responseHandler)
    }
    
    public func patch(url             : String,
                      parameters      : Parameters?       = nil,
                      encoding        : ParameterEncoding = URLEncoding.default,
                      headerHander    : HeaderHandler?   = nil,
                      responseHandler : ResponseHandler?  = nil) {
        
        request(url,
                method          : .patch,
                parameters      : parameters,
                encoding        : encoding,
                headerHander    : headerHander,
                responseHandler : responseHandler)
    }
    
    public func upload(url             : String,
                       parameters      : Parameters?       = nil,
                       headerHander    : HeaderHandler?   = nil,
                       responseHandler : ResponseHandler?  = nil) {
        
        let fullUrl = url.hasPrefix("http") ? url : "\(baseUrl)\(url)"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        authenticate { (error) in
            if let error = error {
                responseHandler?(nil, error)
                return
            }
            Alamofire.upload(multipartFormData: { (formData) in
                
                if let hasParam = parameters {
                    for (key, value) in hasParam {
                        if let url = value as? URL {
                            formData.append(url, withName: key)
                        } else {
                            formData.append("\(value)".data(using: .utf8)!, withName: key)
                        }
                    }
                }
            }, to: fullUrl, headers: headerHander?()) { (completion) in
                switch completion {
                case .success(let request, _, _):
                    request
                        .validate(statusCode: 200..<300)
                        .responseJSON { (response) in
                            
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self.handleResponse(response, responseHandler: responseHandler)
                    }
                case .failure(let error):
                    responseHandler?(nil, error)
                }
            }
        }
    }
    
    public func upload(url                : String,
                       parameters         : Parameters?       = nil,
                       headerHander       : HeaderHandler?   = nil,
                       progressHandler    : @escaping Request.ProgressHandler,
                       responseHandler    : ResponseHandler?  = nil,
                       requestIdentifier  : ((UploadRequest) -> Void)? = nil ) {
        
        let fullUrl = url.hasPrefix("http") ? url : "\(baseUrl)\(url)"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        authenticate { (error) in
            if let error = error {
                responseHandler?(nil, error)
                return
            }
            Alamofire.upload(
                multipartFormData: { (formData) in
                    if let hasParam = parameters {
                        for (key, value) in hasParam {
                            if let url = value as? URL {
                                formData.append(url, withName: key)
                            } else {
                                formData.append("\(value)".data(using: .utf8)!, withName: key)
                            }
                        }
                    }
            }, to : fullUrl, headers: headerHander?()) { (completion) in
                switch completion {
                case .success(let request, _, _):
                    requestIdentifier?(request)
                    request
                        .uploadProgress(closure: progressHandler)
                        .validate(statusCode: 200..<300)
                        .responseJSON { response in
                            
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self.handleResponse(response, responseHandler: responseHandler)
                    }
                case .failure(let error):
                    responseHandler?(nil, error)
                }
            }
        }
    }
}
