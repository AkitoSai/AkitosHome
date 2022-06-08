//
//  LeaderboardUnitView.swift
//  AkitosHome
//
//  Created by akito on 2022/6/2.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

import UIKit

// 存放獲得排行榜的響應的 struct
struct LeaderboardResults: Codable {
    
    //上傳是否成功
    let upload:String
    
    // 單一筆排行資訊
    let results: [LeaderboardResult]
}

// 存放單一筆排行資訊的 struct
struct LeaderboardResult: Codable {
    
    // 玩家名稱
    let name:String
    
    // 得分
    let score: Int
    
    // 建立時間
    let datetime: String
    
}

class LeaderboardUnitView:UIView,UITextFieldDelegate,UIScrollViewDelegate {
    
    
    // View 縮放的比例 預設為 iPhone X 寬度 375.0 為基準
    var zoomSize:Double = 1.0
    
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
    
    // 目前 Request 的編號
    var requestNumber:Int = 0
    
    // 目前是否為執行中
    var isLoading:Bool = false
    
    // 目前是否為 Jason decode中
    var isJsonDecoding:Bool = false
    
    //目前遊戲分數
    var score:Double! = 0.0

    // leaderboard_api 接口 Url
    let leaderboard_api_url:String! = "http://34.84.150.189/pirates_leaderboard/get.php?name="
    
    // 展示讀取狀態的 UIActivityIndicatorView
    var myLoadActivityIndicatorView:UIActivityIndicatorView!
    
    // Request 用的 URLSessionDataTask
    var myURLSessionDataTask:URLSessionDataTask?
    
    // 標題 Label
    var myTitleLabel:UILabel!
    
    // 輸入玩家名字的 UITextField
    var nameTextField:UITextField!
    
    // 放入排行榜名單的 ScrollView
    var myLeaderboardDrawScrollView:UIScrollView!
    
    // 排行榜名單 LeaderboardDrawView
    var myLeaderboardDrawView:LeaderboardDrawView!
    
    // 存放獲得的響應的 LeaderboardResults struct
    var myLeaderboardResults:LeaderboardResults?
    
    
    //=====================================================//
    // 初始化 init
    //=====================================================//
    init(frame:CGRect,zoom:Double){
        
        super.init(frame: frame)
        
        // 設定縮放的比例
        zoomSize = zoom
        
        
        //======== 標題 Label ========//
        myTitleLabel = UILabel(frame: CGRect(x:15*zoomSize, y: 20*zoomSize, width: frame.width-30*zoomSize, height: 40*zoomSize))
        //myTitleLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 100/255)
        myTitleLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 32 * zoomSize)
        myTitleLabel.textColor = UIColor.white
        myTitleLabel.textAlignment = .center
        myTitleLabel.text = ""
        self.addSubview(myTitleLabel)
        //=====================================================//
        
        
        
        //======== 建立輸入玩家名字的 UITextField ========//
        nameTextField = UITextField(frame: CGRect(x:15*zoomSize, y: 80*zoomSize, width: frame.width-30*zoomSize, height: 50*zoomSize))
        nameTextField.layer.masksToBounds = true
        nameTextField.font = UIFont(name: "Arial Rounded MT Bold", size: 24 * zoomSize)
        nameTextField.layer.cornerRadius = 15.0
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.keyboardType = .emailAddress
        nameTextField.returnKeyType = .done
        nameTextField.textColor = UIColor.white
        nameTextField.backgroundColor = UIColor.lightGray
        nameTextField.keyboardAppearance = .dark
        nameTextField.returnKeyType = .send
        nameTextField.keyboardType = .asciiCapable
        nameTextField.delegate = self
        nameTextField.isHidden = true
        self.addSubview(nameTextField)
        //=====================================================//
        
        
        //======== 建立放入排行榜名單的 ScrollView ========//
        myLeaderboardDrawScrollView = UIScrollView()
        // 設置可見視圖範圍
        myLeaderboardDrawScrollView.frame = CGRect(x:15*zoomSize, y: 80*zoomSize, width: frame.width-30*zoomSize, height: (frame.height-80-15)*zoomSize)
        myLeaderboardDrawScrollView.backgroundColor = UIColor.darkGray
        // 設置實際視圖範圍
        myLeaderboardDrawScrollView.contentSize = CGSize(width: myLeaderboardDrawScrollView.frame.width,height: myLeaderboardDrawScrollView.frame.height+100)
        myLeaderboardDrawScrollView.layer.masksToBounds = true
        myLeaderboardDrawScrollView.layer.cornerRadius = 15.0
        myLeaderboardDrawScrollView.showsHorizontalScrollIndicator = false
        myLeaderboardDrawScrollView.showsVerticalScrollIndicator = true
        myLeaderboardDrawScrollView.indicatorStyle = .black
        myLeaderboardDrawScrollView.isScrollEnabled = true
        myLeaderboardDrawScrollView.scrollsToTop = false
        myLeaderboardDrawScrollView.isDirectionalLockEnabled = true
        myLeaderboardDrawScrollView.bounces = true
        myLeaderboardDrawScrollView.zoomScale = 1.0
        myLeaderboardDrawScrollView.minimumZoomScale = 0.5
        myLeaderboardDrawScrollView.maximumZoomScale = 2.0
        myLeaderboardDrawScrollView.bouncesZoom = true
        myLeaderboardDrawScrollView.delegate = self
        // 起始的可見視圖偏移量 預設為 (0, 0)會將原點滑動至這個點起始
        myLeaderboardDrawScrollView.contentOffset = CGPoint(x: 0.0 * zoomSize, y: 0.0 * zoomSize)
        myLeaderboardDrawScrollView.isPagingEnabled = false
        myLeaderboardDrawScrollView.isHidden = false
        self.addSubview(myLeaderboardDrawScrollView)
        //=====================================================//
        
        
        //======== 初始化排行榜名單 ========//
        myLeaderboardDrawView = LeaderboardDrawView(frame: CGRect(x:0*zoomSize, y: 0*zoomSize, width: myLeaderboardDrawScrollView.frame.width, height: myLeaderboardDrawScrollView.frame.height), zoom: zoomSize)
        
        // 重繪完成後呼叫的Closure
        myLeaderboardDrawView.didReDraw = {[unowned self] scrollViewContentHeight in
            
            if let leaderboardDrawScrollView = self.myLeaderboardDrawScrollView{
            
                //更改myLeaderboardDrawScrollView實際視圖範圍
                leaderboardDrawScrollView.contentSize = CGSize(width: myLeaderboardDrawScrollView.frame.width,height: scrollViewContentHeight)
                
                //自動跳回頂部
                leaderboardDrawScrollView.contentOffset.y = 0
            }
            
        }
        
        myLeaderboardDrawView!.backgroundColor = UIColor.white
        //myLeaderboardDrawView.isHidden = true
        myLeaderboardDrawScrollView.addSubview(myLeaderboardDrawView)
        //=====================================================//
        
        
        //======== 建立讀讀取狀態標示 ========//
        myLoadActivityIndicatorView = UIActivityIndicatorView()
        myLoadActivityIndicatorView.frame = CGRect(x: 0, y: 0, width: 30*zoomSize, height: 30*zoomSize)
        myLoadActivityIndicatorView.style = UIActivityIndicatorView.Style.whiteLarge
        myLoadActivityIndicatorView.color = .black
        myLoadActivityIndicatorView.center = self.center
        myLoadActivityIndicatorView.isHidden = true
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
    // 關閉
    //=====================================================//
    func close(){
        
        self.isHidden = true
        
        //關掉舊的 URLSessionDataTask
        if let urlSessionDataTask = myURLSessionDataTask{
             urlSessionDataTask.cancel()
        }
        myURLSessionDataTask = nil
        
        // 更改標題為""
        if let titleLabel = myTitleLabel {
            titleLabel.text = ""
            titleLabel.textColor = UIColor.white
        }
        
        // 隱藏輸入框跟鍵盤
        if let textField = nameTextField {
            textField.isHidden = true
            textField.resignFirstResponder()
        }
        
        // 隱藏排行榜名單的ScrollView
        if let leaderboardDrawScrollView = myLeaderboardDrawScrollView {
            leaderboardDrawScrollView.isHidden = true
        }
        
        // 不顯示讀取進度標示
        setLoadingStatus(isLoading:false)
        
    }
    
    
    //=====================================================//
    // 讓玩家輸入姓名
    //=====================================================//
    func inputName(newScore:Double){
        
        // 更新分數
        score = newScore
        
        // 若沒有接網路則不顯示
        if Reachability(hostName: "www.apple.com").currentReachabilityStatus().rawValue == 0 {
            print("No Internet Connection.")
            
            return
            
        }else {
            print("Internet Connected Successfully.")
        }
        
        
        // 更改標題為"Input Your Name"
        if let titleLabel = myTitleLabel {
            titleLabel.text = "Input Your Name"
            titleLabel.textColor = UIColor.yellow
        }
        
        
        // 顯示輸入框跟鍵盤
        if let textField = nameTextField {
            textField.isHidden = false
            textField.becomeFirstResponder()
        }
        
        
        // 隱藏排行榜名單的ScrollView
        if let leaderboardDrawScrollView = myLeaderboardDrawScrollView {
            leaderboardDrawScrollView.isHidden = true
        }
        
        self.isHidden = false
        
    }
    
    
    //=====================================================//
    // 向 leaderboard_api 發出 Request
    //=====================================================//
    func doNewRequest() {
        
        // 更改標題為"Loading..."
        if let titleLabel = myTitleLabel {
            titleLabel.text = "Loading..."
            titleLabel.textColor = UIColor.white
        }
        
        // 判斷若非執行中狀態則開始執行新的 Request
        if(isLoading){
            return
        }
        

        // 若沒有接網路則不顯示
        if Reachability(hostName: "www.apple.com").currentReachabilityStatus().rawValue == 0 {
            print("No Internet Connection.")
            
            return
            
        }else {
            print("Internet Connected Successfully.")
        }
        
        
        var usernameString = ""
        if let textField = nameTextField {
            
            usernameString = "\(textField.text!)"
            
        }
        
        // 顯示排行榜名單的ScrollView
        if let leaderboardDrawScrollView = myLeaderboardDrawScrollView {
            leaderboardDrawScrollView.isHidden = false
        }
        
        // 不顯示讀取進度標示
        setLoadingStatus(isLoading:true)
        
        
        // 把玩家姓名跟分數放盡url的GET參數
        let urlString = "\(leaderboard_api_url!)\(usernameString)&score=\(Int(score))";
        
        print("urlString：\(urlString)")
        
        if let request_url = URL(string: urlString) {
            
            
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
                                                myLeaderboardResults = try JSONDecoder().decode(LeaderboardResults.self,from: data_0)
                                                
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
                            
                            
                            //進行leaderboardDrawView的重新描繪
                            if let leaderboardDrawView =  myLeaderboardDrawView{
                                
                                if let leaderboardResults =  myLeaderboardResults{
                                    
                                    leaderboardDrawView.reDraw(leaderboardResults: leaderboardResults)
                                    
                                }
                                
                                // 更改標題為"WANTED"
                                if let titleLabel = myTitleLabel {
                                    titleLabel.text = "WANTED"
                                    titleLabel.textColor = UIColor.red
                                }
                            }
                            
                            //print("statusCode：\(statusCodeMessage)")
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
                //self.isHidden = false
                self.isLoading = true
                
            }else{
                
                loadActivityIndicatorView.stopAnimating()
                //self.isHidden = true
                self.isLoading = false
                
            }
        }
    }
    
    
    //=====================================================//
    // 執行 UITextFieldDelegate: 按下Done則收鍵盤上傳
    //=====================================================//
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 收起鍵盤
        textField.resignFirstResponder()
        
        // 開始送出請求
        doNewRequest()
        
        return true
        
    }
    
    
    //=====================================================//
    // 執行 UITextFieldDelegate: 判斷輸入字數以及一些限制
    //=====================================================//
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //限制只能輸入10字
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
            let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        
        if(newString.length <= maxLength){
            
            /*
            //限制不能输入特殊字符
            if(newString.contains(" ") || newString.contains("?") || newString.contains("=") || newString.contains("&")){
                return false
            }
            */
            
            let length = string.lengthOfBytes(using: String.Encoding.utf8)

            for loopIndex in 0..<length {
                
                let char = (string as NSString).character(at: loopIndex)
                
                /*
                if ((char == 32) || char == 38) || (char == 61) || (char == 63){
                    
                    //32    (space) (space)
                    //38    &
                    //61    =
                    //63    ?
                    //這3個字元禁止使用
                    return false
                }
                */
                
                if (char >= 48) && (char <= 57){//數字
                    return true
                }else if (char >= 65) && (char <= 90){//入A~Z
                    return true
                }else if (char >= 97) && (char <= 122){// a~z
                    return true
                }else{
                    return false
                }
                
             }
            
        }else{
            
            return false
            
        }
        
        return true
        
    }
    
}
