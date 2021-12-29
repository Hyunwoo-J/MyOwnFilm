//
//  MainScreenFirstSectionTableViewCellTests.swift
//  MyOwnFilmTests
//
//  Created by Hyunwoo Jang on 2021/12/22.
//

import XCTest
@testable import MyOwnFilm


class MainScreenFirstSectionTableViewCellTests: XCTestCase {

    var sut: MainScreenFirstSectionTableViewCell!
    
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
        vc.loadViewIfNeeded()
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        sut = vc.mainScreenTableView.dequeueReusableCell(withIdentifier: "MainScreenFirstSectionTableViewCell", for: indexPath) as! MainScreenFirstSectionTableViewCell
    }

    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    
    func testOutletConnection() {
        // then
        XCTAssertNotNil(sut.firstSectionCollectionView)
    }
}
