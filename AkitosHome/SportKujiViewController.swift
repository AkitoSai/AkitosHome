//
//  SportKujiViewController.swift
//  AkitosHome
//
//  Created by akito on 2022/5/31.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

import UIKit

class SportKujiViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SportKujiRequestUnitViewDelegate {
    
    // 取得螢幕的尺寸
    let fullSize = UIScreen.main.bounds.size
    
    // View 縮放的比例 預設為 iPhone X 寬度 375.0 為基準
    var zoomSize = 1.0
    
    //上層主頁面 MainViewController
    unowned var myMainViewController:MainViewController!
    
    // 頁面標題 TitleLabel
    var myTitleLabel:UILabel!
    
    // 顯示 Sport Kuji 結果的 TableView
    var mySportKujiTableView:UITableView!
    
    // 向 api 請求使用的 SportKujiRequestUnitView
    var mySportKujiRequestUnitView:SportKujiRequestUnitView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // 計算畫面縮放的比例 以寬度375為基準
        zoomSize = Double(fullSize.width)/375.0
        
        
        // 設置底色
        self.view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 255/255)
        
        
        //======== 設置背景畫面 ========//
        let myBackgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
        myBackgroundImageView.image = UIImage(named: "Image/img_spkuji_back.jpg")
        myBackgroundImageView.alpha = 0.8
        self.view.addSubview(myBackgroundImageView)
        //=====================================================//
        
        
        //======== 設置 mySportKujiTableView ========//
        mySportKujiTableView = UITableView(frame: CGRect(
            x: 0, y: 85 * zoomSize,
            width: fullSize.width,
            height: fullSize.height - 85*zoomSize),
                                           style: .plain)
        
        mySportKujiTableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 200/255)
        // 設置 myKujiTableView cell 註冊
        mySportKujiTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // 設置 myKujiTableView 代理對象
        mySportKujiTableView.delegate = self
        mySportKujiTableView.dataSource = self
        
        // 設置 myKujiTableView 行間高度
        mySportKujiTableView.rowHeight = CGFloat(150.0*zoomSize)
        
        // 設置 myKujiTableView 分隔線樣式
        mySportKujiTableView.separatorStyle = .singleLine
        
        // 設置 myKujiTableView 分隔線的間距
        mySportKujiTableView.separatorInset =
            UIEdgeInsets.init(
                top: 0, left: 20, bottom: 0, right: 20)
        
        // 設置 myKujiTableView cell 是否可以點選
        mySportKujiTableView.allowsSelection = false
        
        // 設置 myKujiTableView cell 是否可以多選
        mySportKujiTableView.allowsMultipleSelection = false
        
        // 加入 myKujiTableView 到畫面中
        self.view.addSubview(mySportKujiTableView)
        
        // myKujiTableView 還沒有讀取到資料時預設隱藏
        mySportKujiTableView.isHidden = true
        //=====================================================//
        
        
        //======== 設置自定義最上方的 TitleBarView ========//
        let myTitleBarView = UIView(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: 85 * zoomSize))
        myTitleBarView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 255/255)
        myTitleBarView.backgroundColor = UIColor.white
        self.view.addSubview(myTitleBarView)
        //=====================================================//
        
        //======== 設置 mySportKujiRequestUnitView ========//
        // 設置頁面標題 TitleLabel
        myTitleLabel = UILabel(frame: CGRect(x: 0, y: 20 * zoomSize, width: fullSize.width, height: 80 * zoomSize))
        //myTitleLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 100/255)
        myTitleLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 21)
        myTitleLabel.textColor = UIColor.black
        myTitleLabel.textAlignment = .center
        myTitleLabel.text = "Sport KuJi"
        self.view.addSubview(myTitleLabel)
        //=====================================================//
        
        
        //======== 設置 mySportKujiRequestUnitView ========//
        mySportKujiRequestUnitView = SportKujiRequestUnitView(frame: CGRect(x: 0, y: 0, width: 200 * zoomSize, height: 160 * zoomSize))
        mySportKujiRequestUnitView.layer.masksToBounds = true
        mySportKujiRequestUnitView.layer.cornerRadius = 15.0
        mySportKujiRequestUnitView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 200/255)
        mySportKujiRequestUnitView.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.5)
        mySportKujiRequestUnitView.delegate = self
        self.view.addSubview(mySportKujiRequestUnitView)
        //=====================================================//
        
        
        //======== 設置自定義最上方左邊返回主頁面的 backMainViewButton ========//
        // 設置自定義最上方左邊返回主頁面的 backMainViewButton
        let backMainViewButton = UIButton(frame: CGRect(x: 0, y: 0, width: 75*zoomSize, height: 36*zoomSize))
        //backMainViewButton.setImage(UIImage(named: "Image/img_main_button_00.jpg"), for: .normal)

        let borderColor00 : UIColor = UIColor( red: 0.0, green: 0.0, blue:0.0, alpha: 1.0 )
        backMainViewButton.layer.cornerRadius = 12.0
        backMainViewButton.layer.borderColor = borderColor00.cgColor
        backMainViewButton.layer.borderWidth = 2.0
       
        backMainViewButton.backgroundColor = UIColor.red
        //backMainViewButton.backgroundColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 255/255)
        
        backMainViewButton.layer.shadowColor = UIColor.black.cgColor
        backMainViewButton.layer.shadowRadius = 2
        backMainViewButton.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        backMainViewButton.layer.shadowOpacity = 0.6

        backMainViewButton.setTitleColor(UIColor.white, for: .normal)
        backMainViewButton.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        backMainViewButton.titleLabel?.layer.shadowRadius = 2
        backMainViewButton.titleLabel?.layer.shadowOffset = CGSize(width: 1, height: 1)
        backMainViewButton.titleLabel?.layer.shadowOpacity = 1.0
        backMainViewButton.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 15)
        backMainViewButton.setTitle("<< Home", for: .normal)
        backMainViewButton.addTarget(nil, action: #selector(self.backToMainViewController), for: .touchUpInside)
        backMainViewButton.center = CGPoint(x: 47.0 * zoomSize, y: 60.0 * zoomSize)
        self.view.addSubview(backMainViewButton)
        //=====================================================//
        
        
        // 打開頁面時需執行的動作函式
        open()
        
        
        print("viewDidLoad: SportKujiViewController")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear: SportKujiViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewDidAppear: SportKujiViewController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear: SportKujiViewController")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("viewDidDisappear: SportKujiViewController")
    }
    
    
    //=====================================================//
    // 打開頁面時需執行的動作
    //=====================================================//
    func open() {
        
        // 透過 mySportKujiRequestUnitView 開始向Api 發出請求
        if let sportKujiRequestUnitView = mySportKujiRequestUnitView{
            
            if let sportKujiTableView = mySportKujiTableView {
                
                sportKujiTableView.isHidden = true
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                sportKujiRequestUnitView.doNewRequest()
            }
            
        }
        
    }
    
    
    //=====================================================//
    // 返回 mainViewController 頁面的函式
    //=====================================================//
    @objc func backToMainViewController() {
        

        if let mainViewController = myMainViewController {
            
            //播放效果音 SE:1
            mainViewController.playAudio(type: .se, index: 1)
            
            //播放背景音樂 BGM:0
            mainViewController.playAudio(type:.bgm,index:0,delay: 0.5)
            
        }
        
        self.navigationController!.popViewController(animated: true)

    }
    
    
    //=====================================================//
    // 連線結果 alert
    //=====================================================//
    func showRequesAlert(status:Int) {
        
        if(status == -1){ // -1: 無網路連連線
            // 連線結果 alert
            let controller = UIAlertController(title: "", message: "No Internet Connection? ", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }else{
            // 連線結果 alert
            
            let controller = UIAlertController(title: "Error :\(status)", message: "status code", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            
        }
        
    }
    
    
    //=====================================================//
    // 執行 SportKujiRequestUnitViewDelegate：接收回傳響應狀態碼
    // 1:成功 更新 sportKujiTableView
    // 不成功則用 Alert 顯示不成功狀態碼
    //=====================================================//
    func requestSuccess(statusCode:Int) {
        
        if(statusCode == 1){
            
            if let sportKujiTableView = mySportKujiTableView {
                
                sportKujiTableView.reloadData()
                sportKujiTableView.isHidden = false
                
                
                if let mainViewController = myMainViewController {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        //播放效果音 SE:3
                        mainViewController.playAudio(type: .se, index: 3)
                    }
                    
                    
                }
            }
            
        }else{
            
            if let mainViewController = myMainViewController {
                
                //播放效果音 SE:2
                mainViewController.playAudio(type: .se, index: 2)
                
                
            }
            
            // 用 Alert 顯示不成功狀態碼
            showRequesAlert(status: statusCode)
            
        }
        
    }
    
    
    //=====================================================//
    // 執行 UITableViewDelegate：每一組有幾個 cell
    //=====================================================//
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        var cellNums = 0
        
        // 從 mySportKujiRequestUnitView 裡的 mySportKujiResults 找出響應回傳的結果筆數
        if let sportKujiRequestUnitView = mySportKujiRequestUnitView {
            
            if let sportKujiResults = sportKujiRequestUnitView.mySportKujiResults {
                
                if(sportKujiResults.results.count>0){
                    cellNums = sportKujiResults.results.count
                }
                
            }
            
        }
        
        return cellNums
    }
    
    
    //=====================================================//
    // 執行 UITableViewDelegate：每個 cell 的顯示內容
    //=====================================================//
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        
        // 取得 tableView 目前使用的 cell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as UITableViewCell
        
        
        if let sportKujiRequestUnitView = mySportKujiRequestUnitView {
            
            if let sportKujiResults = sportKujiRequestUnitView.mySportKujiResults {
                
                if let titleLabel = myTitleLabel{
                    titleLabel.text = "\(sportKujiResults.title)"
                }
                
                if(sportKujiResults.results.count > indexPath.row){
                    
                    let sportKujiResult:SportKujiResult = sportKujiResults.results[indexPath.row]
                    
                    cell.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0/255)
                    
                    //用 sportKujiResult.imgurl 抓取圖片讀入 cell.imageView
                    if let cellImageView = cell.imageView {
                        
                        //原始圖片 寬:117 高:37
                        cellImageView.translatesAutoresizingMaskIntoConstraints = false
                        cellImageView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 15 * zoomSize).isActive = true
                        cellImageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -90 * zoomSize).isActive = true
                        cellImageView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 80 * zoomSize).isActive = true
                        cellImageView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -80 * zoomSize).isActive = true
                        //cellImageView.widthAnchor.constraint(equalTo: cell.widthAnchor, constant: 140).isActive = true
                        let imgurlString:String = sportKujiResult.imgurl
                        let url = URL(string:imgurlString)
                        
                        let data = try! Data(contentsOf: url!)
                        cellImageView.image = UIImage(data: data)
                        
                    }
                    
                    //將獎項名稱 sportKujiResult.subtitle 寫入 cell.detailTextLabel
                    if let detailTextLabel = cell.detailTextLabel {
                        //detailTextLabel.backgroundColor = UIColor.red
                        detailTextLabel.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 220/255)
                        detailTextLabel.translatesAutoresizingMaskIntoConstraints = false
                        detailTextLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 70 * zoomSize).isActive = true
                        detailTextLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0).isActive = true
                        detailTextLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
                        detailTextLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 15 * zoomSize)
                        //detailTextLabel.font = UIFont.systemFont(ofSize: CGFloat(15 * zoomSize))
                        detailTextLabel.textAlignment = NSTextAlignment.center
                        detailTextLabel.text = "\(sportKujiResult.subtitle)"
                    }
                    
                    //將得獎號碼 sportKujiResult.numbers 寫入 cell.textLabel
                    if let cellTextLabel = cell.textLabel {
                        cellTextLabel.textColor = UIColor.white
                        cellTextLabel.translatesAutoresizingMaskIntoConstraints = false
                        cellTextLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 85 * zoomSize).isActive = true
                        cellTextLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0).isActive = true
                        cellTextLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
                        cellTextLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 35 * zoomSize)
                        //cellTextLabel.font = UIFont.systemFont(ofSize: CGFloat(35 * zoomSize))
                        cellTextLabel.textAlignment = NSTextAlignment.center
                        cellTextLabel.text = "\(sportKujiResult.numbers)"
                    }
                    
                }
                
            }
            
        }
        
        return cell
    }
    
}
