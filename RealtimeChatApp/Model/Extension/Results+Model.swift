//
//  Results+Model.swift
//  KeepSafe
//
//  Created by Tran Van Tuat on 7/4/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

extension Results {
    
    func asObservable() -> Observable<Results<Element>> {
        return Observable.create { observer in
            let token = self.observe({ (changes) in
                switch changes {
                case .initial(let result):
                    observer.on(.next(result))
                case .update(let result, _, _, _) :
                    observer.on(.next(result))
                case .error(let err):
                    observer.onError(err)
                }
                observer.on(.completed)
            })
            return Disposables.create {
                token.invalidate()
            }
        }
    }
    
    func asObservableArray(page: Int? = nil, limit: Int? = nil) -> Observable<[Element]> {
        return Observable.create { observer in
            let token = self.observe({ (changes) in
                switch changes {
                case .initial(let result):
                    if let (startIndex, endIndex) = self.getIndex(page: page, limit: limit, total: result.count) {
                        if startIndex > endIndex {
                            observer.on(.error(NSError(
                                domain  : "",
                                code    : 0,
                                userInfo: [NSLocalizedDescriptionKey: "Pagination is invalid"]
                            )))
                        } else {
                            var elements = [Element]()
                            for i in startIndex ..< endIndex {
                                elements.append(result[i])
                            }
                            observer.on(.next(elements))
                        }
                    } else {
                        observer.on(.next(Array(result)))
                    }
                case .update(let result, _, _, _) :
                    if let (startIndex, endIndex) = self.getIndex(page: page, limit: limit, total: result.count) {
                        if startIndex > endIndex {
                            observer.on(.error(NSError(
                                domain  : "",
                                code    : 0,
                                userInfo: [NSLocalizedDescriptionKey: "Pagination is invalid"]
                            )))
                        } else {
                            var elements = [Element]()
                            for i in startIndex ..< endIndex {
                                elements.append(result[i])
                            }
                            observer.on(.next(elements))
                        }
                    } else {
                        observer.on(.next(Array(result)))
                    }
                case .error(let err):
                    observer.onError(err)
                }
                observer.on(.completed)
            })
            
            return Disposables.create {
                token.invalidate()
            }
        }
    }
    
    private func getIndex(page: Int?, limit: Int?, total: Int) -> (Int, Int)? {
        guard let page = page, let limit = limit else { return nil }
        
        let startIndex = page * limit
        let endIndex = startIndex + limit
        if endIndex <= total {
            return (startIndex, endIndex)
        }
        return (startIndex, total)
    }
}
