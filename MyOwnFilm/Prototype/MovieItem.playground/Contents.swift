import UIKit

struct MovieData: Codable {
    struct Results: Codable {
        let backdrop_path: String
        let genre_ids: [Int]

        let overview: String
        let release_date: String
        let title: String
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            backdrop_path = (try? values.decode(String.self, forKey: .backdrop_path)) ?? ""
            genre_ids = (try? values.decode(Array<Int>.self, forKey: .genre_ids)) ?? []
            overview = (try? values.decode(String.self, forKey: .overview)) ?? ""
            release_date = (try? values.decode(String.self, forKey: .release_date)) ?? "날짜를 불러올 수 없습니다."
            title = (try? values.decode(String.self, forKey: .title)) ?? ""
        }
    }
    
    let results: [Results]
    
}

let urlStr = "https://api.themoviedb.org/3/movie/popular?api_key=f8fe112d01a08bb8e4e39895d7d71c61&language=ko-KR"

let url = URL(string: urlStr)!

let session = URLSession.shared

let task = session.dataTask(with: url) { data, response, error in
    if let error = error {
        print(error)
    }
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        return
    }
    
    guard let data = data else {
        return
    }
    
    do {
        let decoder = JSONDecoder()
        let movieData = try decoder.decode(MovieData.self, from: data)
        
        dump(movieData)
    } catch {
        print(error)
    }

}
task.resume()
