//
//  ResponseHandlerProtocol.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Alamofire
import SwiftyJSON

public protocol ResponseHandlerProtocol {
    
    func onResponse(_ response: DataResponse<Any>, responseHandler: ResponseHandler?)
}
