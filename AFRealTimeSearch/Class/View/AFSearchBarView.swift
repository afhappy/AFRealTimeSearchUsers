//
//  AFSearchBarView.swift
//  AFRealTimeSearch
//
//  Created by fa on 2019/6/21.
//  Copyright © 2019 af. All rights reserved.
//

import UIKit

class AFSearchBarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
 *  MARK: - 初始化
 */
extension AFSearchBarView {
    /**
     *  MARK: - 初始化UI
     **/
    private func setupUI() {
        // 背景
        self.backgroundColor = UIColor.init(red: 248 / 255.0, green: 248 / 255.0, blue: 248 / 255.0, alpha: 1)
        
        // 搜索图标
        let searchImgView = UIView(frame: CGRect(x: 0, y: 0, width: 23, height: 30))
        self.addSubview(searchImgView)
        let searchImg = UIImageView(image: UIImage(named: "searchImg"))
        searchImg.frame = CGRect(x: 6, y: 6, width: 17, height: 17)
        searchImgView.addSubview(searchImg)
        
        let searchViewHeight = self.bounds.size.height
        // 搜索框
        let searchTextField = UITextField(frame: CGRect(x: 8, y: searchViewHeight - 30 - 8, width: AFScreenWidth - 8 * 2, height: 30))
        self.addSubview(searchTextField)
        searchTextField.leftView = searchImgView
        searchTextField.leftViewMode = .always
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.returnKeyType = .search
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = UIColor.init(red: 225 / 255.0, green: 228 / 255.0, blue: 229 / 255.0, alpha: 1)
        searchTextField.delegate = self
        
        // 底部分割线
        let bottomViewLine = UIView(frame: CGRect(x: 0, y: searchViewHeight - 1, width: AFScreenWidth, height: 1))
        self.addSubview(bottomViewLine)
        bottomViewLine.backgroundColor = UIColor.init(red: 192 / 255.0, green: 192 / 255.0, blue: 192 / 255.0, alpha: 1)
    }
}

/*
 *  MARK: - UITextField Delegate
 */
extension AFSearchBarView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // 文本拼接
        let allStr = appendTextFieldString(range: range, textFieldStr: textField.text!, inputString: string)
        // 文本改变发送通知
        NotificationCenter.default.post(name: Notification.Name.Task.SearchUsersKeyword, object: allStr)

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     * MARK: - 文本拼接
     *
     *  - Paramters:
     *      - range: 编辑位置
     *      - textFieldStr: textfield原有内容
     *      - inputString: textfield现输入内容
     *  - Returns:
     *      - 拼接之后的完整内容
     **/
    func appendTextFieldString(range: NSRange, textFieldStr: String, inputString: String) -> String {
        // 根据输入文本长度判断，插入/删除
        if range.length == 0 {
            let tempStr: NSMutableString = NSMutableString(string: textFieldStr)
            tempStr.insert(inputString, at: range.location)
            return String.init(tempStr)
        }else {
            let tempStr: NSMutableString = NSMutableString(string: textFieldStr)
            tempStr.deleteCharacters(in: range)
            tempStr.insert(inputString, at: range.location)
            return String.init(tempStr)
        }
    }
}
