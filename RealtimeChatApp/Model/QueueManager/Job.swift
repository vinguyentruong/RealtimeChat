//
//  BaseJob.swift
//  KeepSafe
//
//  Created by Tran Van Tuat on 7/4/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation

public enum JobPriority: Int {

    case low = 0, medium, high
    
}

public protocol JobLifecycle {
    
    func onStart()
    
    func onRun() throws
    
    func onStop()
    
    func onError(_ error: Error)
    
}

public typealias JobClosure = ((Error?) -> ())

open class Job: NSObject {
    
    // MARK: Property
    
    public let id = UUID().uuidString
    public var priority: JobPriority
    public private(set) var isRunning = false
    
    public var closure: JobClosure?
    
    // MARK: Constructor
    
    public init(priority: JobPriority = JobPriority.medium) {
        self.priority = priority
    }
    
    // MARK: Public method
    
    open func start() {
        isRunning = true
        onStart()
        
        do {
            try onRun()
        } catch {
            onError(error)
        }
    }
    
    open func stop() {
        isRunning = false
        
        closure?(nil)
        
        onStop()
    }
    
}

// MARK: JobLifecycle implementation

extension Job: JobLifecycle {
    
    @objc
    open func onStart() {
        
    }
    
    @objc
    open func onRun() throws {
        
    }
    
    @objc
    open func onStop() {
    }
    
    @objc
    open func onError(_ error: Error) {
        isRunning = false
        onStop()
        
        closure?(error)
    }
    
}

// MARK: Comparable implementation

extension Job: Comparable {
    
    public typealias `Self` = Job
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.priority.rawValue < rhs.priority.rawValue
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than or equal to that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.priority.rawValue <= rhs.priority.rawValue
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than or equal to that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.priority.rawValue >= rhs.priority.rawValue
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.priority.rawValue > rhs.priority.rawValue
    }
    
}
