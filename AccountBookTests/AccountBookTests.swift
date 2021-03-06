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
    
    func testGetGoogleLogin() throws {
        let expectation = self.expectation(description: "FirebaseRead")
        var isSuccess = false
        let googleLoginable: GoogleLoginable = GoogleLoginStub(isSuccess: true)
        googleLoginable.getGoogleToken(completion: { result in
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
    
    func testReadBooksFromFirebase() throws {
        let expectation = self.expectation(description: "FirebaseRead")
        var isSuccess = false
        let firebaseReadable: FirebaseReadable = FirebaseReadRepositoryStub(isSuccess: true)
        firebaseReadable.readBookInfo(completion: { result in
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
        var firebaseWriteable: FirebaseWriteable = FirebaseWriteRepositoryStub(isSuccess: true)
        firebaseWriteable.writeBookInfo(bookInfo: BookInfo(), completion: { result in
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
    
    func testIsPriceExpression() throws {
        var expressionCheckable: WriteExpressionCheckable?
        expressionCheckable = RegularExpression()
        guard let result = expressionCheckable?.checkPrice(price: "2134987234893721894") else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertTrue(result)
    }
}


