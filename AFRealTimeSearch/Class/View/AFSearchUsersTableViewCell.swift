//
//  AFSearchUsersTableViewCell.swift
//  AFRealTimeSearch
//
//  Created by fa on 2019/6/22.
//  Copyright © 2019 af. All rights reserved.
//

import UIKit
import SDWebImage

class AFSearchUsersTableViewCell: UITableViewCell {
    /*
     *  MARK: - 定义变量
     */
    // 控件
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLanguage: UILabel!
    
    // 数据源
    var cellDataSource: UsersModel? {
        didSet {
            // cell view赋值
            userImage.sd_setImage(with: URL(string: cellDataSource?.avatar_url ?? ""), completed: nil)
            userName.text = cellDataSource?.login
            userLanguage.text = cellDataSource?.userLanguage
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        // 获取到使用最多的语言后刷新列表
        NotificationCenter.default.addObserver(self, selector: #selector(referTable), name: Notification.Name.Task.UserUseMostLanguage, object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Task.UserUseMostLanguage, object: nil)
    }
}

/*
 *  MARK: - 事件处理
 */
extension AFSearchUsersTableViewCell {
    /**
     *  MARK: - 通知：刷新UI
     **/
    @objc func referTable() {
        if Thread.isMainThread {
            userLanguage.text = cellDataSource?.userLanguage
        } else {
            DispatchQueue.main.sync(execute: {
                userLanguage.text = cellDataSource?.userLanguage
            })
        }
    }
}

