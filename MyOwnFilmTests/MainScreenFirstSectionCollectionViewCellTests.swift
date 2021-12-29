//
//  MainScreenFirstSectionCollectionViewCellTests.swift
//  MyOwnFilmTests
//
//  Created by Hyunwoo Jang on 2021/12/22.
//

import XCTest
@testable import MyOwnFilm


class MainScreenFirstSectionCollectionViewCellTests: XCTestCase {

    var sut: MainScreenFirstSectionCollectionViewCell!
    
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
        vc.loadViewIfNeeded()
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        let mainScreenFirstSectionTableViewCell = vc.mainScreenTableView.dequeueReusableCell(withIdentifier: "MainScreenFirstSectionTableViewCell", for: indexPath) as! MainScreenFirstSectionTableViewCell
        
        sut = mainScreenFirstSectionTableViewCell.firstSectionCollectionView.dequeueReusableCell(withReuseIdentifier: "MainScreenFirstSectionCollectionViewCell", for: indexPath) as! MainScreenFirstSectionCollectionViewCell
    }

    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    
    func testOutletConnection() {
        // then
        XCTAssertNotNil(sut.firstSectionImageView)
        XCTAssertNotNil(sut.movieTitleLabel)
        XCTAssertNotNil(sut.releaseDateLabel)
    }
    
    
    func testAwakeFromNib_setsProperValue() {
        // then
        XCTAssertEqual(sut.firstSectionImageView.layer.cornerRadius, 16)
    }
    
    
    func testConfigure_setsProperValue() {
        // given
        let id = Int.random(in: 1...100)
        let backdrop_path = "backdrop_path"
        let genre_ids = [Int.random(in: 1...100), Int.random(in: 1...100)]
        let overview = "overview"
        let release_date = Date().releaseDate
        let title = "스파이더맨"
        let poster_path = "poster_path"
        
        
        let data = MovieData.Result(id: id, backdrop_Path: backdrop_path, genre_ids: genre_ids, overview: overview, release_date: release_date, title: title, poster_path: poster_path)
        
        // when
        sut.configure(with: data)
        
        // then
        XCTAssertEqual(sut.movieTitleLabel.text, data.titleStr)
        XCTAssertEqual(sut.releaseDateLabel.text, data.releaseDate.toManagerDate()!.toUserDateStringForMovieData())
    }
}
