//
//  ReviewViewControllerTests.swift
//  MyOwnFilmTests
//
//  Created by Hyunwoo Jang on 2021/12/24.
//

import XCTest
@testable import MyOwnFilm


class ReviewViewControllerTests: XCTestCase {
    
    var sut: ReviewViewController!
    
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        vc.loadViewIfNeeded()
        
        sut = vc
    }

    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    
    func testOutletConnection() {
        // then
        XCTAssertNotNil(sut.memoView)
        XCTAssertNotNil(sut.memoBackdropImageView)
        XCTAssertNotNil(sut.dateLabel)
        XCTAssertNotNil(sut.dateButton)
        XCTAssertNotNil(sut.placeLabel)
        XCTAssertNotNil(sut.placeButton)
        XCTAssertNotNil(sut.friendTextField)
        XCTAssertNotNil(sut.memoTextView)
        XCTAssertNotNil(sut.memoViewTopConstraint)
        XCTAssertNotNil(sut.memoViewBottomConstraint)
    }
    
    
    func testStatusBarColor_IsLightContent() {
        // then
        XCTAssertEqual(sut.preferredStatusBarStyle, .lightContent)
    }
    
    
    func testTextField_setsDelegate() {
        // given
        sut.viewDidLoad()
        
        // then
        XCTAssertIdentical(sut.friendTextField.delegate, sut)
        XCTAssertTrue(sut.friendTextField.delegate === sut)
    }
    
    
    func testDateButtonAndPlaceButtonBorder_setsProperValue() {
        // given
        let dateButton = sut.dateButton
        let placeButton = sut.placeButton
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(dateButton?.layer.borderWidth, 1)
        XCTAssertEqual(dateButton?.layer.borderColor, UIColor.white.cgColor)
        XCTAssertEqual(placeButton?.layer.borderWidth, 1)
        XCTAssertEqual(placeButton?.layer.borderColor, UIColor.white.cgColor)
    }
    
    
    func testFriendTextFieldBorder_setsProperValue() {
        // given
        let friendTextField = sut.friendTextField
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(friendTextField?.layer.borderWidth, 1)
        XCTAssertEqual(friendTextField?.layer.borderColor, UIColor.white.cgColor)
    }
    
    
    func testSetMemoViewFunction_setsProperValue() {
        // given
        let memoView = sut.memoView
        sut.setMemoView()
        
        // then
        XCTAssertEqual(memoView?.layer.cornerRadius, 8)
        XCTAssertEqual(memoView?.layer.shadowColor, UIColor(named: "backgroundColor")?.cgColor)
        XCTAssertEqual(memoView?.layer.shadowRadius, 1)
        XCTAssertEqual(memoView?.layer.shadowOpacity, 0.3)
        XCTAssertEqual(memoView?.layer.masksToBounds, true)
    }
    
    
    func testSetTextViewFunction_setsProperValue() {
        // given
        let memoTextView = sut.memoTextView
        sut.setTextView()
        
        // then
        XCTAssertEqual(memoTextView?.layer.cornerRadius, 8)
        XCTAssertEqual(memoTextView?.layer.borderWidth, 1)
        XCTAssertEqual(memoTextView?.layer.borderColor, UIColor.lightGray.cgColor)
    }
}
