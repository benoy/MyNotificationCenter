//
//  MyNotificationCenter.swift
//  MyNotificationCenter
//
//  Created by Binoy Vijayan on 02/06/24.
//

import Foundation

class MyNotificationCenter {
    
    static let shared = MyNotificationCenter()
    private var observers: [String: [(AnyObject, Selector)]]
    let queue: DispatchQueue
    
    
        
    private init() {
        self.observers = [:]
        self.queue = DispatchQueue(label: "com.mynotificationcenter.queue", attributes: .concurrent)
        
    }
    
    func addObserver(object: AnyObject, name: String, selector: Selector) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.observers[name, default: [(AnyObject, Selector)]()].append((object, selector))
        }
    }
    
    
    func post(name: String, userInfo: [AnyHashable: Any]? = nil) {
            
        queue.async { [weak self] in
            guard let self = self else { return }
            if let targetActionList = self.observers[name] {
               for targetAction in targetActionList {
                   _ = targetAction.0.perform(targetAction.1, with: userInfo)
               }
           }
       }
    }

    
    func removeObserver(object: AnyObject) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.observers = self.observers.filter { !($0.value.contains { $0.0 === object })}
        }
    }
    
    func hasObserver(object: AnyObject) -> Bool {
        return observers.filter { !($0.value.contains { $0.0 === object })}.isEmpty
    }
    
}
