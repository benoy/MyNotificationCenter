//
//  main.swift
//  MyNotificationCenter
//
//  Created by Binoy Vijayan on 02/06/24.
//

import Foundation

 

class MyNotificationObserver: Observable {
    
    init() {
        MyNotificationCenter.shared.addObserver(object: self,
                                                name: "MyNotification",
                                                selector: #selector(notificationSelector))
    }
    
    @objc func notificationSelector(_ userInfo: [AnyHashable: Any]?) {
        print("\(userInfo ?? [:])")
    }
    
    deinit {
        MyNotificationCenter.shared.removeObserver(object: self)
    }
    
}

var  customNotificationObserver = MyNotificationObserver()


func postNotification() {
    MyNotificationCenter.shared.post(name: "MyNotification", userInfo: ["NotificationThorugh": "CustomNotificationCenter"])
}


postNotification()

usleep(2000)

