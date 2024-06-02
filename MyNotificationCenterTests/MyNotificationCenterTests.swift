//
//  MyNotificationCenterTests.swift
//  MyNotificationCenterTests
//
//  Created by Binoy Vijayan on 02/06/24.
//

import XCTest

class TestObserver: NSObject {
    var notificationReceived = false
    var receivedUserInfo: [AnyHashable: Any]?

    @objc func handleNotification(_ userInfo: [AnyHashable: Any]?) {
        notificationReceived = true
        receivedUserInfo = userInfo
    }
}

final class MyNotificationCenterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddObserver() {
        let notificationCenter = MyNotificationCenter.shared
        let observer = TestObserver()
        
        notificationCenter.addObserver(object: observer, name: "TestNotification", selector: #selector(observer.handleNotification(_:)))
        XCTAssertTrue(notificationCenter.hasObserver(object: observer))
    }

    func testPostNotification() {
        let notificationCenter = MyNotificationCenter.shared
        let observer = TestObserver()
        notificationCenter.addObserver(object: observer, name: "TestNotification", selector: #selector(observer.handleNotification(_:)))
        
        notificationCenter.post(name: "TestNotification", userInfo: ["key": "value"])
        
        let expectation = XCTestExpectation(description: "Notification received")
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if observer.notificationReceived {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertTrue(observer.notificationReceived)
        XCTAssertEqual(observer.receivedUserInfo?["key"] as? String, "value")
    }

    func testRemoveObserverObject() {
        let notificationCenter = MyNotificationCenter.shared
        let observer = TestObserver()
        notificationCenter.addObserver(object: observer, name: "TestNotification", selector: #selector(observer.handleNotification(_:)))
        
        notificationCenter.removeObserver(object: observer)
    
        XCTAssertFalse(notificationCenter.hasObserver(object: observer))
    }
        
    func testMultipleObservers() {
        let notificationCenter = MyNotificationCenter.shared
        let observer1 = TestObserver()
        let observer2 = TestObserver()
        
        notificationCenter.addObserver(object: observer1, name: "TestNotification", selector: #selector(observer1.handleNotification(_:)))
        notificationCenter.addObserver(object: observer2, name: "TestNotification", selector: #selector(observer2.handleNotification(_:)))
        
        notificationCenter.post(name: "TestNotification")
        
        let expectation1 = XCTestExpectation(description: "Observer 1 notification received")
        let expectation2 = XCTestExpectation(description: "Observer 2 notification received")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if observer1.notificationReceived {
                expectation1.fulfill()
            }
            if observer2.notificationReceived {
                expectation2.fulfill()
            }
        }
        wait(for: [expectation1, expectation2], timeout: 2.0)
        
        XCTAssertTrue(observer1.notificationReceived)
        XCTAssertTrue(observer2.notificationReceived)
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
