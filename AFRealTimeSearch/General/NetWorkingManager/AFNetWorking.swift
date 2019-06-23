//
//  AFNetWorking.swift
//  AFRealTimeSearch
//
//  Created by fa on 2019/6/21.
//  Copyright © 2019 af. All rights reserved.
//

import Foundation

/*
 *  MARK: - 网络请求结果回调
 */
public typealias requestSuccessBlock = (_ value: Any?) -> ()
public typealias requestFailureBlock = (_ error: String?) -> ()

open class AFNetWorking: NSObject {
    /*
     *  MARK: - 变量
     */
    // 单例
    public static let manager: AFNetWorking = AFNetWorking()
    
    
    /**
     *  MARK: - GET请求
     *
     *  - Parameters:
     *      - urlString: 请求的路径
     *      - successBlock: 成功回调
     *      - failureBlock: 失败回调
     **/
    func getRequest(_ urlString: String, success successBlock: requestSuccessBlock? = nil, failure failureBlock: requestFailureBlock? = nil) {
        
        // URL
        let url = URL(string: urlString)
        guard let tempUrl = url else {
            return
        }
        
        // 请求对象、会话、任务
        var request = URLRequest(url: tempUrl, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            // 请求结果处理
            if data == nil || response == nil  {
                self.failureHandle(error: "请求失败", failure: failureBlock)
                return
            }
            
            let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            guard let tempResult = result else {
                self.failureHandle(error: "请求失败", failure: failureBlock)
                return
            }
            
            // 请求结果成功回调
            self.successHandle(value: tempResult, success: successBlock)
        }
        dataTask.resume()
    }
    
    
    /**
     *  MARK: - 请求成功结果处理
     *
     *  - Paramters:
     *      - successBlock: 成功结果回调
     **/
    fileprivate func successHandle(value: Any?, success successBlock: requestSuccessBlock? = nil){
        // 请求结果数据格式转换
        let dictionaryValue = value
        // 成功回调
        if let tempSuccessBlock = successBlock {
            tempSuccessBlock(dictionaryValue)
        }
    }
    
    /**
     *  MARK: - 请求失败结果处理
     *
     *  - Paramters:
     *      - failureBlock: 失败结果回调
     **/
    fileprivate func failureHandle(error: String, failure failureBlock: requestFailureBlock? = nil){
        // 失败回调
        if let tempFailureBlock = failureBlock {
            tempFailureBlock(error)
        }
    }
}
