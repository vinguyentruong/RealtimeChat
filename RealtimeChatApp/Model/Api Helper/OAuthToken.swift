//
//  OAuthToken.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import SwiftyJSON
import KeychainSwift

public class OAuthToken: NSObject {
    
    // MARK: Property
    
    public static let `default` = OAuthToken()
    
    public var accessToken: String
    public var expiresIn: Double
    public var expiredAt: Double
    public var refreshToken: String
    
    public var isExpired: Bool {
        return false
        //        let currentTime = Date().timeIntervalSince1970
        //        let diffTime = abs(expiredAt - currentTime)
        //        return currentTime >= expiredAt || diffTime > expiresIn
    }
    
    // MARK: Constructor
    
    public override init() {
        let keychain = KeychainSwift()
        if let stringJson = keychain.get("oauthToken"), !stringJson.isEmpty {
            let json = JSON(parseJSON: stringJson)
            accessToken = json["access_token"].stringValue
            expiresIn = json["expire_in"].doubleValue
            refreshToken = json["refresh_token"].stringValue
            expiredAt = json["expired_at"].doubleValue
        } else {
            accessToken = ""
            expiresIn = 0
            expiredAt = 0
            refreshToken = ""
        }
        super.init()
    }
    
    public init(json: JSON) {
        accessToken = json["access_token"].stringValue
        expiresIn = json["expire_in"].doubleValue - 120
        refreshToken = json["refresh_token"].stringValue
        expiredAt = expiresIn + Date().timeIntervalSince1970
    }
    
    public convenience init(stringJson: String) {
        let json = JSON(parseJSON: stringJson)
        
        self.init(json: json)
    }
    
    // MARK: Public method
    
    public func update(json: JSON) {
        accessToken = json["access_token"].stringValue
        expiresIn = json["expire_in"].doubleValue
        if json["refresh_token"].exists() {
            refreshToken = json["refresh_token"].stringValue
        }
        
        let keychain = KeychainSwift()
        keychain.set(toString(), forKey: "oauthToken")
    }
    
    public func update(oauthToken: OAuthToken) {
        accessToken = oauthToken.accessToken
        expiresIn = oauthToken.expiresIn
        expiredAt = oauthToken.expiredAt
        if !oauthToken.refreshToken.isEmpty {
            refreshToken = oauthToken.refreshToken
        }
        
        let keychain = KeychainSwift()
        keychain.set(toString(), forKey: "oauthToken")
    }
    
    public func clear() {
        let keychain = KeychainSwift()
        keychain.delete("oauthToken")
        
        accessToken = ""
        refreshToken = ""
        expiresIn = 0
        expiredAt = 0
    }
    
    public func toString() -> String {
        let dictionary: [String: Any] =
            ["access_token"  : accessToken,
             "expire_in"    : expiresIn,
             "expired_at"    : expiredAt,
             "refresh_token" : refreshToken]
        guard
            let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted),
            let dataString = String(data: data, encoding: .utf8) else {
                return ""
        }
        return dataString
    }
    
}
