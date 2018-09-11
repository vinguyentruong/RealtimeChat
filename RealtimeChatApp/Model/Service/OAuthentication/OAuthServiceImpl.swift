//
//  OAuthServiceImpl.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import SwiftyJSON
import Alamofire
import RxSwift

class OAuthServiceImpl: NSObject {
    
    private func request(_ url           : String,
                         method          : Alamofire.HTTPMethod,
                         parameters      : Parameters?,
                         encoding        : ParameterEncoding,
                         headerHander    : HeaderHandler?,
                         responseHandler : ResponseHandler?) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let fullUrl = url.hasPrefix("http") ? url : "\(Configuration.BaseUrl)\(url)"
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
    }
    
    private func handleResponse(_ response: DataResponse<Any>, responseHandler: ResponseHandler?) {
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            if json["error"].exists() {
                let code = json["error"]["code"].intValue
                let message = json["error"]["message"].stringValue
                responseHandler?(nil, NSError(domain    : "",
                                              code      : code,
                                              userInfo  : [NSLocalizedDescriptionKey: message]))
                return
            }
            responseHandler?(json, nil)
        case .failure(let error):
            if let data = response.data {
                let json = JSON(data)
                print(json)
                if json["error"].exists() {
                    let code = json["error"]["code"].intValue
                    let message = json["error"]["message"].stringValue
                    responseHandler?(nil, NSError(domain    : "",
                                                  code      : code,
                                                  userInfo  : [NSLocalizedDescriptionKey: message]))
                    return
                }
            }
            responseHandler?(nil, NSError(domain    : "",
                                          code      : (error as NSError).code,
                                          userInfo  : [NSLocalizedDescriptionKey: "something_went_wrong_error".localized()]))
            
        }
    }
}

// MARK: OAuthProtocol implementation

extension OAuthServiceImpl: OAuthProtocol {
    
    func logout() -> Observable<Bool> {
        return Observable.create({ (e) -> Disposable in
            self.request(
                "\(Configuration.BaseUrl)/api/auth/logout",
                method: .post,
                parameters: nil,
                encoding: JSONEncoding.default,
                headerHander: {
                    var headers = HTTPHeaders()
                    headers["Authorization"] = "Bearer \(OAuthToken.default.accessToken)"
                    return headers
            }) { (json, error) in
                if let err = error {
                    e.on(.error(err))
                } else if let check = json?["data"].boolValue {
                    e.on(.next(check))
                }
                e.on(.completed)
            }
            return Disposables.create()
        })
    }
    
    
    func login(email    : String,
               password : String) -> Observable<OAuthToken> {
        
        let parameters = ["username": email, "password": password]
        return Observable.create({ (e) -> Disposable in
            self.request(
                "\(Configuration.BaseUrl)/api/auth/login",
                method      : .post,
                parameters  : parameters,
                encoding    : JSONEncoding.default,
                headerHander: nil) { (json, error) in
                    if let error = error {
                        e.on(.error(error))
                    } else if let json = json?["data"] {
                        let auth = OAuthToken(json: json)
                        e.on(.next(auth))
                        e.on(.completed)
                    }
            }
            return Disposables.create()
        })
    }
    
    func resgister(displayName  : String,
                   email        : String,
                   password     : String,
                   imageURL     : String?) -> Observable<User> {
        let parameters: [String: Any?] = ["username": email, "displayName": displayName, "password": password, "avatar": imageURL]
        return Observable.create({ (e) -> Disposable in
            self.request(
                "\(Configuration.BaseUrl)/api/auth/signup",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headerHander: nil,
                responseHandler: { (json, error) in
                    if let error = error {
                        e.on(.error(error))
                    } else if let json = json?["data"] {
                        let user = User(json: json)
                        e.on(.next(user))
                        e.on(.completed)
                    }
            }
            )
            return Disposables.create()
        })
    }
    
    func oauthRefreshToken(_ responseHandler: @escaping (ApiResponse<OAuthToken>) -> Void) {
        
    }
}
