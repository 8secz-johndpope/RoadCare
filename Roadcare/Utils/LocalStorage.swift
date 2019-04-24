//
//  LocalStorage.swift
//  PABoards
//
//  Created by admin_user on 4/25/17.
//  Copyright © 2017 GMService. All rights reserved.
//

import Foundation

public extension UserDefaults {
    class Proxy {
        fileprivate let defaults: UserDefaults
        fileprivate let key: String
        
        fileprivate init(_ defaults: UserDefaults, _ key: String) {
            self.defaults = defaults
            self.key = key
        }
        
        // MARK: Getters
        
        public var object: Any? {
            return defaults.object(forKey: key)
        }
        
        public var string: String? {
            return defaults.string(forKey: key)
        }
        
        public var array: [Any]? {
            return defaults.array(forKey: key)
        }
        
        public var dictionary: [String: Any]? {
            return defaults.dictionary(forKey: key)
        }
        
        public var data: Data? {
            return defaults.data(forKey: key)
        }
        
        public var date: Date? {
            return object as? Date
        }
        
        public var number: NSNumber? {
            return defaults.numberForKey(key)
        }
        
        public var int: Int? {
            return number?.intValue
        }
        
        public var double: Double? {
            return number?.doubleValue
        }
        
        public var bool: Bool? {
            return number?.boolValue
        }
        
        // MARK: Non-Optional Getters
        
        public var stringValue: String {
            return string ?? ""
        }
        
        public var arrayValue: [Any] {
            return array ?? []
        }
        
        public var dictionaryValue: [String: Any] {
            return dictionary ?? [:]
        }
        
        public var dataValue: Data {
            return data ?? Data()
        }
        
        public var numberValue: NSNumber {
            return number ?? 0
        }
        
        public var intValue: Int {
            return int ?? 0
        }
        
        public var doubleValue: Double {
            return double ?? 0
        }
        
        public var boolValue: Bool {
            return bool ?? false
        }
    }
    
    /// `NSNumber` representation of a user default
    
    func numberForKey(_ key: String) -> NSNumber? {
        return object(forKey: key) as? NSNumber
    }
    
    /// Returns getter proxy for `key`
    
    public subscript(key: String) -> Proxy {
        return Proxy(self, key)
    }
    
    /// Sets value for `key`
    
    public subscript(key: String) -> Any? {
        get {
            // return untyped Proxy
            // (make sure we don't fall into infinite loop)
            let proxy: Proxy = self[key]
            return proxy
        }
        set {
            
            guard let newValue = newValue else {
                removeObject(forKey: key)
                return
            }
            
            switch newValue {
                // @warning This should always be on top of Int because a cast
            // from Double to Int will always succeed.
            case let v as Double: self.set(v, forKey: key)
            case let v as Int: self.set(v, forKey: key)
            case let v as Bool: self.set(v, forKey: key)
            case let v as URL: self.set(v, forKey: key)
            default: self.set(newValue, forKey: key)
            }
        }
    }
    
    /// Returns `true` if `key` exists
    
    public func hasKey(_ key: String) -> Bool {
        return object(forKey: key) != nil
    }
    
    /// Removes value for `key`
    
    public func remove(_ key: String) {
        removeObject(forKey: key)
    }
    
    /// Removes all keys and values from user defaults
    /// Use with caution!
    /// - Note: This method only removes keys on the receiver `UserDefaults` object.
    ///         System-defined keys will still be present afterwards.
    
    public func removeAll() {
        for (key, _) in dictionaryRepresentation() {
            removeObject(forKey: key)
        }
    }
}

public let LocalStorage = UserDefaults.standard





