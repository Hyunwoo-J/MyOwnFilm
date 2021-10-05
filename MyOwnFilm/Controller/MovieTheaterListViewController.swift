//
//  MovieTheaterListViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/05.
//

import UIKit


extension Notification.Name {
    /// 테이블뷰 셀이 선택되면 보낼 노티피케이션
    static let movieTheaterTableViewCellDidTapped = Notification.Name(rawValue: "movieTheaterTableViewCellDidTapped")
}



/// 영화관 목록 화면
class MovieTheaterListViewController: UIViewController {
    
    /// 영화관 목록
    var theaterList = [Theater]()
    
    /// 기초 단체 목록
    ///
    /// 중복된 데이터를 제거하기 위해 Set을 사용했습니다.
    var basicOrganizationSetList: Set<String> = []
    
    /// 기초 단체 목록
    ///
    /// 중복 데이터를 제거한 Set 리스트를 다시 Array에 넣습니다.
    var basicOrganizationList = [String]()
    
    
    /// 영화관 목록을 가져옵니다.
    func loadMovieTheaterList() {
        guard let data = NSDataAsset(name: "Seoul_MovieTheaterInformation")?.data else {
            return
        }
        
        guard let source = String(data: data, encoding: .utf8) else { return }
        
        let lines = source.components(separatedBy: CharacterSet.newlines).dropFirst()
        
        for line in lines {
            let values = line.components(separatedBy: ",")
            guard values.count == 3 else { continue }
            
            let metropolitanCouncil = values[0].trimmingCharacters(in: .whitespaces)
            let basicOrganization = values[1].trimmingCharacters(in: .whitespaces)
            let name = values[2].trimmingCharacters(in: .whitespaces)
            theaterList.append(Theater(metropolitanCouncil: metropolitanCouncil, basicOrganization: basicOrganization, name: name))
            
            basicOrganizationSetList.insert(basicOrganization)
            
            for basicOrganization in basicOrganizationSetList {
                if !basicOrganizationList.contains(basicOrganization) {
                    basicOrganizationList.append(basicOrganization)
                }
            }
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMovieTheaterList()
    }
}



/// 영화관 목록 테이블뷰 데이터 관리
extension MovieTheaterListViewController: UITableViewDataSource {
    
    /// 섹션 행의 수를 리턴합니다.
    ///
    /// 섹션 이름과 동일한 데이터 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 영화 목록 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션 행의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredBasicOrganization = theaterList.filter { theater in
            theater.basicOrganization == basicOrganizationList[section]
        }
        
        return filteredBasicOrganization.count
    }
    
    
    /// 섹션 이름으로 필터링된 기초 단체 데이터로 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 영화 목록 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 필터링된 기초 단체 데이터 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let target = theaterList.filter { $0.basicOrganization == basicOrganizationList[indexPath.section]}[indexPath.row]
        cell.textLabel?.text = target.name
        
        return cell
    }
    
    
    /// 섹션의 수를 리턴합니다.
    /// - Parameter tableView: 영화 목록 테이블뷰
    /// - Returns: 기초 단체 목록의 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return basicOrganizationList.count
    }
    
    
    /// 기초 단체 이름을 리턴합니다.
    /// - Parameters:
    ///   - tableView: 영화 목록 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 기초 단체 이름
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return basicOrganizationList[section]
    }
}



/// 영화관 목록 테이블뷰와 관련된 사용자 동작을 처리
extension MovieTheaterListViewController: UITableViewDelegate {
    
    /// 섹션 헤더의 높이를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 영화 목록 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션 헤더의 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    
    /// 셀을 선택하면 이전 화면에 노티피케이션을 보냅니다.
    ///
    /// 선택한 셀에 출력된 기초 단체 이름을 이전 화면에 보내고 화면을 닫습니다.
    /// - Parameters:
    ///   - tableView: 영화 목록 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let target = theaterList.filter { $0.basicOrganization == basicOrganizationList[indexPath.section]}[indexPath.row].name
        
        NotificationCenter.default.post(name: .movieTheaterTableViewCellDidTapped, object: nil, userInfo: ["theater": target])
        
        dismiss(animated: true, completion: nil)
    }
}
