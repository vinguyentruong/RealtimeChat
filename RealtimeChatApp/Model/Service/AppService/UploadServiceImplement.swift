//
//  UploadServiceImplement.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class UploadServiceImplement: RestService {
    
}

extension UploadServiceImplement: UploadService {
    
    func uploadFile(url             : URL,
                    progressHandler : @escaping Request.ProgressHandler,
                    responseHandler : @escaping ResponseHandler) {
        let parameters = ["file": url]
        self.apiHelper.upload (
            url                 : "\(Configuration.BaseUrl)/api/users/upload-avatar",
            parameters          : parameters,
            headerHander        : nil,
            progressHandler     : { (progress) in
                print(progress.fractionCompleted)
                progressHandler(progress)
        },
            responseHandler     : { (json, error) in
                responseHandler(json,error)
        },
            requestIdentifier   : nil
        )
    }
}
