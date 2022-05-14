//
//  AccountBookTests.swift
//  AccountBookTests
//
//  Created by 김동준 on 2022/05/14.
//

import XCTest
@testable import AccountBook

class AccountBookTests: XCTestCase {
    var timerUsable: TimerUsable?
    var googleLoginable: GoogleLoginable?
    
    
    func testSplashTimer() throws {
        var isSuccess = false
        let expectation = self.expectation(description: "Timer")
        timerUsable = Timer.init(timerSec: 3)
        timerUsable?.timerStart { result in
            switch result{
            case .success(_):
                isSuccess = true
            case .failure(_):
                XCTAssertTrue(false)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(isSuccess, true)
    }
    

    func testReadBooksFromFirebase() throws {
        let expectation = self.expectation(description: "FirebaseRead")
        var isSuccess = false
        var firebaseReadable: FirebaseReadable?
        firebaseReadable = FirebaseReadRepository()
        firebaseReadable?.readBookInfo(completion: { result in
            switch result{
            case .success(_):
                isSuccess = true
            case .failure(_):
                XCTAssertTrue(false)
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(isSuccess, true)
    }

    func testWriteBooksFromFirebase() throws {
        let expectation = self.expectation(description: "FirebaseWrite")
        var isSuccess = false
        var firebaseWriteable: FirebaseWriteable?
        firebaseWriteable = FirebaseWriteRepository()
        firebaseWriteable?.writeBookInfo(bookInfo: BookInfo(), completion: { result in
            switch result{
            case .success(_):
                isSuccess = true
            case .failure(_):
                XCTAssertTrue(false)
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(isSuccess, true)
    }
}
