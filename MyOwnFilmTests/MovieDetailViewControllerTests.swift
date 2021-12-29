//
//  MovieDetailViewControllerTests.swift
//  MyOwnFilmTests
//
//  Created by Hyunwoo Jang on 2021/12/24.
//

import XCTest
@testable import MyOwnFilm


class MovieDetailViewControllerTests: XCTestCase {

    var sut: MovieDetailViewController!
    
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        vc.loadViewIfNeeded()
        
        sut = vc
    }
    
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    
    func testOutletConnection() {
        // then
        XCTAssertNotNil(sut.backgroundmovieImageView)
        XCTAssertNotNil(sut.storyLabel)
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertNotNil(sut.dateLabel)
    }
    
    
    func testStatusBarColor_IsLightContent() {
        // then
        XCTAssertEqual(sut.preferredStatusBarStyle, .lightContent)
    }
}
