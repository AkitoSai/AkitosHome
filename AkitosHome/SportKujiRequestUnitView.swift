//
//  SportKujiRequestUnitView.swift
//  AkitosHome
//
//  Created by akito on 2022/5/31.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

import UIKit

// 存放獲得的響應的 struct
struct SportKujiResults: Codable {
    
    // 主標題
    var title:String
    
    // 單一筆得獎資訊
    let results: [SportKujiResult]
}

// 存放單一筆得獎資訊的 struct
struct SportKujiResult: Codable {
    
    // 獎項名稱
    let subtitle:String
    
    // 得獎號碼
    let numbers: String
    
    // 獎項標題圖片URL
    let imgurl: String
    
}


class SportKujiRequestUnitView:UIView {
    
    // 請求結果狀態訊息代碼
    // -1: 無網路連連線
    // 0: 初始狀態
    // 1: 正常完成
    // 2: JSON decode 同時間衝突無法執行
    // 11: 響應 data 有誤
    // 12: 響應data的json解析發生錯誤
    // 20: 有響應但 data 為空
    // 30: 請求沒有響應
    // 40: 請求發生Error
    // 100 以上則為 Response 的Http狀態碼 https://zh.wikipedia.org/zh-tw/HTTP%E7%8A%B6%E6%80%81%E7%A0%81
    //var statusCodeMessage = 0
    
    // 目前 Request 的編號
    var requestNumber:Int = 0
    
    // 目前是否為執行中
    var isLoading:Bool = false
    
    // 目前是否為 Jason decode中
    var isJsonDecoding:Bool = false
    
    // api 接口 Url
    let spkuji_api_url:String! = "http://35.200.24.201:5000/spkuji_api/get"
    
    // 展示讀取狀態的 UIActivityIndicatorView
    var myLoadActivityIndicatorView:UIActivityIndicatorView!
    
    // Request 用的 URLSessionDataTask
    var myURLSessionDataTask:URLSessionDataTask?
    
    // 存放獲得的響應的 SportKujiResults struct
    var mySportKujiResults:SportKujiResults?
    
    // 代理
    var delegate: SportKujiRequestUnitViewDelegate?
    
    
    //=====================================================//
    // 初始化 init
    //=====================================================//
    override init(frame:CGRect){
        
        super.init(frame: frame)
        
        // 初始狀態為非執行狀態
        setLoadingStatus(isLoading: false)
        
        
        //======== 建立讀讀取狀態標示 ========//
        myLoadActivityIndicatorView = UIActivityIndicatorView()
        myLoadActivityIndicatorView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        myLoadActivityIndicatorView.style = UIActivityIndicatorView.Style.whiteLarge
        myLoadActivityIndicatorView.color = .black
        myLoadActivityIndicatorView.center = self.center
        self.addSubview(myLoadActivityIndicatorView)
        //=====================================================//
        
        
    }
    
    //=====================================================//
    // 初始化 init?
    //=====================================================//
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    
    //=====================================================//
    // 向 spkuji_api 發出 Request
    //=====================================================//
    func doNewRequest() {
        
        
        // 判斷若非執行中狀態則開始執行新的 Request
        if(isLoading){
            return
        }
        
        //let reachability = Reachability(hostName: "www.apple.com")

        if Reachability(hostName: "www.apple.com").currentReachabilityStatus().rawValue == 0 {
            print("No Internet Connection.")
            
            // 回傳Requess 響應狀態碼(-1 無網路連線) 給 delegate
            if let nowDelegate = delegate{
                nowDelegate.requestSuccess(statusCode:-1)
            }
            return
            
        }else {
            print("Internet Connected Successfully.")
        }
        
        
        
        if let request_url = URL(string: spkuji_api_url) {
            
            
            // 建立一個請求秒數為10秒的URLRequest
            var urlRequest = URLRequest(url:request_url)
            urlRequest.timeoutInterval = 10
        
            //關掉舊的 URLSessionDataTask
            if let urlSessionDataTask = myURLSessionDataTask{
                 urlSessionDataTask.cancel()
            }
            myURLSessionDataTask = nil
            
            // +1設新的請求編號
            requestNumber += 1
            
            let nowRequestNumber = requestNumber
            
            //let task = URLSession.shared.dataTask(
            myURLSessionDataTask = URLSession.shared.dataTask(
                with: urlRequest,
                completionHandler:{ [unowned self] (data, response, error) in
                    
                    //設定請求結果狀態訊息代碼為 0:初始狀態
                    var statusCodeMessage = 0
                    
                    if(nowRequestNumber != requestNumber){
                        
                        //設定請求結果狀態訊息代碼為 50: 已經是舊的Request 不做解析
                        statusCodeMessage = 50
                        
                    }else{
                        
                        if error != nil{ //請求發生 Error
                            
                            let code = (error! as NSError).code
                            
                            print("Error Code：\(code)")
                            
                            //設定請求結果狀態訊息代碼為 40:請求發生Error
                            statusCodeMessage = 40
                            
                        }else if response != nil{ //請求得到響應
                            
                            //有響應的狀態,設定請求結果狀態訊息代碼為 .statusCode
                            statusCodeMessage = (response as! HTTPURLResponse).statusCode
                           
                            print("Response Code：\(statusCodeMessage)")
                            
                            if statusCodeMessage == 200 { //響應Http狀態碼為 200 OK
                                
                                if data != nil { //請求得到的資料data
                                    
                                    if let data_0 = data {
                                        
                                        do {
                                            
                                            if(!isJsonDecoding){
                                                
                                                isJsonDecoding = true
                                                
                                                //解析JSON資料放進 mySportKujiResults
                                                mySportKujiResults = try JSONDecoder().decode(SportKujiResults.self,from: data_0)
                                                
                                                isJsonDecoding = false
                                                
                                                //設定請求結果狀態訊息代碼為 1: 正常完成
                                                statusCodeMessage = 1
                                                
                                            }else{
                                                //設定請求結果狀態訊息代碼為 2: JSON decode 同時間衝突無法執行
                                                statusCodeMessage = 2
                                            }
                                            
                                            
                                            
                                            //1: 正常完成
                                            statusCodeMessage = 1
                                            
                                        } catch {
                                            
                                            print("JSONDecoder Error:\(error)")
                                            
                                            //設定請求結果狀態訊息代碼為 12: 響應data的json解析發生錯誤
                                            statusCodeMessage = 12
                                        }
                                        
                                    }else{
                                        //設定請求結果狀態訊息代碼為  11: 響應 data 有誤
                                        statusCodeMessage = 11
                                    }
                                    
                                }else{  //請求沒有得到資料data
                                    
                                    //設定請求結果狀態訊息代碼為 20: 有響應但 data 為空
                                    statusCodeMessage = 20
                                    
                                }
                                
                            }
                            
                        }else{ //請求沒有響應
                            
                            //設定請求結果狀態訊息代碼為 30: 請求沒有響應
                            statusCodeMessage = 30
                            
                        }
                        
                        
                        DispatchQueue.main.async {[unowned self] in
                            
                            //停止讀取進度標示
                            //self.showLoadActivityIndicatorView(show:false)
                        
                            //刷新頁面
                            //self.isLoading = false
                            
                            // 回傳Requess 響應狀態碼 給 delegate
                            if let nowDelegate = delegate{
                                print("statusCode：\(statusCodeMessage)")
                                nowDelegate.requestSuccess(statusCode:statusCodeMessage)
                            }
                            
                            // 更改狀態為非執行中
                            setLoadingStatus(isLoading: false)
                            
                        }
                        
                    }
                    
                    
            })
            
            if let urlSessionDataTask = myURLSessionDataTask {
                
                //self.isLoading = true
                
                // 更改狀態為執行中
                setLoadingStatus(isLoading: true)
                
                //遊戲執行交給 global 的 Queue　處理
                DispatchQueue.global(qos: .userInitiated).async {
                    urlSessionDataTask.resume()
                }
        
                
            }else{
                
                //self.isLoading = false
                
            }
            
            
        }
        
    }
    
    //=====================================================//
    // 是否顯示讀取進度標示?
    //=====================================================//
    func setLoadingStatus(isLoading:Bool) {
        
        if let loadActivityIndicatorView = myLoadActivityIndicatorView {
            
            if(isLoading){
                
                loadActivityIndicatorView.startAnimating()
                self.isHidden = false
                self.isLoading = true
                
            }else{
                
                loadActivityIndicatorView.stopAnimating()
                self.isHidden = true
                self.isLoading = false
                
            }
        }
    }
    
}

//=====================================================//
// SportKujiRequestUnitViewDelegate
//=====================================================//
protocol SportKujiRequestUnitViewDelegate{
    
    // 回傳響應狀態碼 給 delegate
    func requestSuccess(statusCode:Int)
    
}
