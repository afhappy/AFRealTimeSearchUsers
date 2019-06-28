//
//  ViewController.swift
//  AFRealTimeSearch
//
//  Created by fa on 2019/6/21.
//  Copyright © 2019 af. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    /*
     *  MARK: - 定义变量
     */
    // 顶部栏高度
    fileprivate let searchViewHeight: CGFloat = AFStatusBarHeight > 20.0 ? 88.0 : 64.0
    // cell identifier
    fileprivate static let cellIdentifier = "AFSearchUsersTableViewCell"
    // 数据源
    fileprivate var dataItem: AFSearchUsersModel? = nil
    fileprivate var dataSource: [UsersModel] = []
    // 控件
    fileprivate var tableView: UITableView? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 注册通知，用于接收搜索关键字
        NotificationCenter.default.addObserver(self, selector: #selector(getKeyword(noti:)), name: Notification.Name.Task.SearchUsersKeyword, object: nil)
        
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Task.SearchUsersKeyword, object: nil)
    }

}

/*
 *  MARK: - 初始化
 */
extension ViewController {
    /**
     *  MARK: - 初始化UI
     **/
    fileprivate func setupUI() {
        // 搜索框
        let searchView = AFSearchBarView.init(frame: CGRect(x: 0.0, y: 0.0, width: AFScreenWidth, height: searchViewHeight))
        self.view.addSubview(searchView)

        // 添加tableview
        searchResultView()
    }
    
    /**
     *  MARK: - 搜索结果view
     **/
    func searchResultView(){
        tableView = UITableView(frame: CGRect(x: 0, y: searchViewHeight, width: AFScreenWidth, height: AFScreenHeight - searchViewHeight), style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = .none
        tableView?.register(UINib(nibName: "AFSearchUsersTableViewCell", bundle: nil), forCellReuseIdentifier: ViewController.cellIdentifier)
        self.view.addSubview(tableView!)
        
    }
    
    /**
     *  MARK: - 刷新UI
     **/
    func refreshUI() {
        if Thread.isMainThread {
            self.tableView?.reloadData()
        } else {
            DispatchQueue.main.sync(execute: {
                self.tableView?.reloadData()
            })
        }
    }
    
}
/*
 * MARK: - 获取数据
 */
extension ViewController {
    func getData(userName: String?) {
        //        处理请求结果
        let searchUsersViewModel = AFSearchUsersViewModel()
        searchUsersViewModel.requestUserData(userName: userName) { (result) in
            self.dataSource = result ?? []
            // 刷新UI
            self.refreshUI()
        }
    }
}

/*
 *  MARK: - 事件处理
 */
extension ViewController {
    /*
     *  MARK: - 通知事件处理
     */
    @objc func getKeyword(noti: Notification) {
        // 获取搜索关键字请求数据
        let keyword = noti.object as! String
        getData(userName: keyword)
    }
}

/*
 *  MARK: - UITableView Delegate, UITableView DataSource
 */
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AFSearchUsersTableViewCell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellIdentifier) as! AFSearchUsersTableViewCell
        cell.cellDataSource = self.dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
