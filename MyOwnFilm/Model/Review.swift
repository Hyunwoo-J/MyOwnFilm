//
//  Review.swift
//  Review
//
//  Created by Hyunwoo Jang on 2021/09/13.
//

import Foundation

struct MovieReview {
    let reviewId: UUID
    let movieTitle: String
    let posterPath: String
    let backdropPath: String
    let releaseDate: Date
    let starPoint: Double
    let date: Date
    let place: String
    let friend: String
    let memo: String
    
    static var movieReviewList = [MovieReview]()
    static var recentlyMovieReviewList = [MovieReview]()
}
