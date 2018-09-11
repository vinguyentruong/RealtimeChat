//
//  FileManager+ViewModel.swift
//  KeepSafe
//
//  Created by Tran Van Tuat on 7/5/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

extension FileManager {
    
    public static let rootDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    public static let todoDirectory = rootDirectory.appendingPathComponent("TodoApp")
    
    internal func createDocument(from url: URL, name: String) -> URL? {
        do {
            if !fileExists(atPath: FileManager.todoDirectory.path) {
                try? createDirectory(at: FileManager.todoDirectory, withIntermediateDirectories: false)
            }
            let newUrl = FileManager.todoDirectory.appendingPathComponent(name)
            try copyItem(at: url, to: newUrl)
            return newUrl
        } catch {
        }
        
        return nil
    }
    
    internal func createDocument(from data: Data, name: String) -> URL? {
        do {
            if !fileExists(atPath: FileManager.todoDirectory.path) {
                try? createDirectory(at: FileManager.todoDirectory, withIntermediateDirectories: false)
            }
            let newUrl = FileManager.todoDirectory.appendingPathComponent(name)
            try data.write(to: newUrl, options: .atomic)
            return newUrl
        } catch {
        }
        
        return nil
    }
    
    internal func saveImage(from data: Data, name: String) -> URL? {
        do {
            if !fileExists(atPath: FileManager.todoDirectory.path) {
                try? createDirectory(at: FileManager.todoDirectory, withIntermediateDirectories: false)
            }
            let newUrl = FileManager.todoDirectory.appendingPathComponent(name)
            try data.write(to: newUrl, options: .atomic)
            return newUrl
        } catch {
        }
        
        return nil
    }
    
    public func saveImage(from image: UIImage, name: String) -> URL? {
        do {
            if !fileExists(atPath: FileManager.todoDirectory.path) {
                try? createDirectory(at: FileManager.todoDirectory, withIntermediateDirectories: false)
            }
            let url = FileManager.todoDirectory.appendingPathComponent(name)
            let data = UIImageJPEGRepresentation(image, 1)
            try data?.write(to: url, options: .atomic)
            
            return url
        } catch { }
        
        return nil
    }
    
}
