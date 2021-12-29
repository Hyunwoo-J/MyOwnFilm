//
//  SearchViewControllerTests.swift
//  MyOwnFilmTests
//
//  Created by Hyunwoo Jang on 2021/12/27.
//

import XCTest
@testable import MyOwnFilm


class SearchViewControllerTests: XCTestCase {

    var sut: SearchViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "SearchScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.loadViewIfNeeded()
        
        sut = vc
    }
    
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    
    func testOutletConnection() {
        // then
        XCTAssertNotNil(sut.searchBar)
        XCTAssertNotNil(sut.searchMovieTableView)
    }
    
    
    func testStatusBarColor_IsLightContent() {
        // then
        XCTAssertEqual(sut.preferredStatusBarStyle, .lightContent)
    }
}
