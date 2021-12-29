//
//  MyOwnFilmUITests.swift
//  MyOwnFilmUITests
//
//  Created by Hyunwoo Jang on 2021/12/29.
//

import XCTest

class MyOwnFilmUITests: XCTestCase {

    var app: XCUIApplication!
    
    lazy var profileButton = app.buttons["Profile_Button"]
    
    lazy var loginButton = app.buttons["Login"]
    
    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
        
        givenEmailLoginAction()
    }
    
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    
    func givenMembershipWithdrawalButtonTappedActon() {
        profileButton.tap()
        
        let membershipWithdrawalButton = app.buttons["회원 탈퇴"]
        membershipWithdrawalButton.tap()
    }
    
    
    func givenLogoutButtonTappedAction() {
        profileButton.tap()
        
        let logoutButton = app.buttons["로그아웃"]
        logoutButton.tap()
    }
    
    
    func givenTableViewCellTappedAction() {
        let tableView = app.tables.firstMatch
        let tableViewCell = tableView.cells.firstMatch
        
        tableViewCell.tap()
    }
    
    
    func givenMemoButtonTappedAction() {
        givenWriteReviewButtonTappedAction()
        
        let memoButton = app.buttons["Memo"]
        memoButton.tap()
    }
    
    
    func givenWriteReviewButtonTappedAction() {
        givenTableViewCellTappedAction()
        
        let reviewButton = app.buttons["Write_Review"]
        reviewButton.tap()
    }
    
    
    func givenEmailLoginAction() {
        if loginButton.exists {
            loginButton.tap()
            
            let detailLoginButton = app.buttons["Detail_Login"]
            detailLoginButton.tap()
        }
    }
    
    
    func testMainScreenViewController_whenMembershipWithdrawalButtonTapped_showsAlert() {
        givenMembershipWithdrawalButtonTappedActon()
        
        let alert = app.alerts["회원 탈퇴"]
        
        Thread.sleep(forTimeInterval: 0.5)
        
        XCTAssert(alert.exists)
    }
    
    
    func testMainScreenViewController_whenLogoutButtonTapped_showsAlert() {
        givenLogoutButtonTappedAction()
        
        let alert = app.alerts["로그아웃"]
        
        Thread.sleep(forTimeInterval: 0.5)
        
        XCTAssert(alert.exists)
    }
    
    
    func testMainScreenViewController_whenMembershipWithdrawalOkButtonTapped_goToLoginScreen() {
        givenMembershipWithdrawalButtonTappedActon()
        
        app.buttons["회원 탈퇴"].tap()
        
        Thread.sleep(forTimeInterval: 0.5)
        
        XCTAssertTrue(loginButton.exists)
    }
    
    
    func testMainScreenViewController_whenLogoutOkButtonTapped_goToLoginScreen() {
        givenLogoutButtonTappedAction()
        
        app.buttons["로그아웃"].tap()
        
        Thread.sleep(forTimeInterval: 0.5)
        
        XCTAssertTrue(loginButton.exists)
    }
    
    
    func testMainScreenViewController_whenSwipeUp_profileButtonHidden() {
        app.swipeUp()
        
        XCTAssertFalse(profileButton.exists)
    }
    
    
    func testMovieDetailViewController_whenCancelButtonTapped_dismissNormally() {
        givenTableViewCellTappedAction()
        
        let cancelButton = app.buttons["Detail_Cancel"]
        cancelButton.tap()
        
        XCTAssertFalse(cancelButton.exists)
    }
    
    
    func testReviewViewController_whenCancelButtonTapped_dismissNormally() {
        givenWriteReviewButtonTappedAction()
        
        let cancelButton = app.buttons["Review_Cancel"]
        cancelButton.tap()
        
        XCTAssertFalse(cancelButton.exists)
    }
    
    
    func testReviewViewController_whenMemoButtonTapped_PresentsMemoScreen() {
        givenMemoButtonTappedAction()
        
        XCTAssertTrue(app.textViews["Memo_TextView"].exists)
    }
    
    
    func testMemoViewController_whenCancelButtonTapped_dismissNormally() {
        givenMemoButtonTappedAction()
        
        let cancelButton = app.buttons["Memo_Cancel"]
        cancelButton.tap()
        
        XCTAssertFalse(cancelButton.exists)
    }
    
    
    func testMemoViewController_whenWriteMemoAndOkButtonTapped_passTextToPreviousScreen() {
        givenMemoButtonTappedAction()
        
        let textView = app.textViews.firstMatch
        let text = "Lorem ipsum"
        textView.typeText(text)
        
        let okButton = app.buttons["Memo_Ok"]
        okButton.tap()
        
        let reviewTextView = app.textViews["Review_TextView"]
        let reviewText = reviewTextView.value as! String
        
        
        XCTAssertEqual(reviewText, text)
    }
}
