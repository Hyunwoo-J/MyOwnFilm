//
//  SettingTableViewCell.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2022/03/18.
//

import UIKit


/// 설정 화면 셀
class SettingTableViewCell: UITableViewCell {
    
    /// 로그아웃 뷰
    @IBOutlet weak var logoutContainerView: RoundedView!
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 뷰 외곽선을 깎습니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logoutContainerView.layer.cornerRadius = logoutContainerView.frame.height / 3.5
    }
}
