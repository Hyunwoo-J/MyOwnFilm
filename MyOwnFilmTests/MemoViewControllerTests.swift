//
//  MemoViewControllerTests.swift
//  MyOwnFilmTests
//
//  Created by Hyunwoo Jang on 2021/12/25.
//

import XCTest
@testable import MyOwnFilm


class MemoViewControllerTests: XCTestCase {
    
    var sut: MemoViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MemoViewController") as! MemoViewController
        vc.loadViewIfNeeded()
        
        sut = vc
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    
    func testOutletConnection() {
        // then
        XCTAssertNotNil(sut.memoTextView)
        XCTAssertNotNil(sut.memoPlaceholderLabel)
    }
    
    
    func testStatusBarColor_IsLightContent() {
        // then
        XCTAssertEqual(sut.preferredStatusBarStyle, .lightContent)
    }
}
