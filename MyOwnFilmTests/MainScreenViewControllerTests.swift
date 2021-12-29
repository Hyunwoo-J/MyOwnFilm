//
//  MainScreenViewControllerTests.swift
//  MyOwnFilmTests
//
//  Created by Hyunwoo Jang on 2021/12/24.
//

import XCTest
@testable import MyOwnFilm


class MainScreenViewControllerTests: XCTestCase {

    var tabBar: UITabBarController!
    var sut: MainScreenViewController!
    
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tabBar = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        sut = tabBar.children[0] as! MainScreenViewController
        sut.loadViewIfNeeded()
    }

    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    
    func testOutletConnection() {
        // then
        XCTAssertNotNil(sut.mainScreenTableView)
        XCTAssertNotNil(sut.nowPlayingView)
    }
    
    
    func testStatusBarColor_IsLightContent() {
        // then
        XCTAssertEqual(sut.preferredStatusBarStyle, .lightContent)
    }
    
    
    func testTabBarItem_tabBarControllerIsNotNil() {
        // then
        XCTAssertNotNil(sut.tabBarController)
    }
    
}
