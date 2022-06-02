//
//  PirateGameViewController.swift
//  AkitosHome
//
//  Created by akito on 2022/6/1.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

import UIKit

class PirateGameViewController: UIViewController,PirateMainGameCenterViewDelegate {
    
    // 取得螢幕的尺寸
    let fullSize = UIScreen.main.bounds.size
    
    // View 縮放的比例 預設為 iPhone X 寬度 375.0 為基準
    var zoomSize = 1.0
    
    // 上層主頁面 MainViewController
    unowned var myMainViewController:MainViewController!
    
    // 主遊戲遊戲控制中心
    var myPirateMainGameCenterView:PirateMainGameCenterView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 計算 View 縮放的比例
        zoomSize = Double(fullSize.width)/375.0
        
        // 設置底色
        self.view.backgroundColor = UIColor.black
        
        
        //======== 初始化主遊戲遊戲控制中心 ========//
        myPirateMainGameCenterView = PirateMainGameCenterView(frame: CGRect(x: 0, y: 0, width: fullSize.width, height:fullSize.height - 0),zoom:zoomSize)
        myPirateMainGameCenterView.delegate = self
        self.view.addSubview(myPirateMainGameCenterView)
        //=====================================================//
        
        
        //======== 設置左下方返回主頁面的 backMainViewButton ========//
        let backMainViewButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70*zoomSize, height: 36*zoomSize))
        
        let borderColor00 : UIColor = UIColor( red: 1.0, green: 1.0, blue:1.0, alpha: 1.0 )
        backMainViewButton.layer.cornerRadius = 12.0
        backMainViewButton.layer.borderColor = borderColor00.cgColor
        backMainViewButton.layer.borderWidth = 2.0
        
        backMainViewButton.layer.masksToBounds = true
        backMainViewButton.layer.cornerRadius = 12.0
        backMainViewButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 255/255)
        backMainViewButton.setTitleColor(UIColor.white, for: .normal)
        backMainViewButton.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 15)
        backMainViewButton.setTitle("^Home^", for: .normal)
        backMainViewButton.addTarget(nil, action: #selector(self.backToMainViewController), for: .touchUpInside)
        backMainViewButton.center = CGPoint(x: 50.0 * zoomSize, y: fullSize.height - (30.0 * zoomSize))
        self.view.addSubview(backMainViewButton)
        //=====================================================//
        
        
        // 重新開始一場遊戲
        myPirateMainGameCenterView.restart()
        
        print("viewDidLoad: PirateGameViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear: PirateGameViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewDidAppear: PirateGameViewController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear: PirateGameViewController")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("viewDidDisappear: PirateGameViewController")
    }
    
    //=====================================================//
    // 打開頁面時需執行的動作
    //=====================================================//
    func open() {
        
        if let pirateMainGameCenterView = myPirateMainGameCenterView{
            
            // 讓遊戲控制中心重新啟動新的一場遊戲
            pirateMainGameCenterView.restart()
            
        }
        
    }
    
    
    //=====================================================//
    // 返回 myMainViewController 頁面的函式
    //=====================================================//
    @objc func backToMainViewController() {
        
        //播放效果音 SE:1
        if let mainViewController = myMainViewController {
            
            //播放效果音 SE:1
            mainViewController.playAudio(type: .se, index: 1)
            
            //播放背景音樂 BGM:0
            mainViewController.playAudio(type:.bgm,index:0,delay: 0.5)
            
        }
        
        
        // 設定換頁動畫為下往上
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        self.navigationController!.popViewController(animated: true)
        

    }
    
    //=====================================================//
    // 執行 PirateMainGameCenterViewDelegate：接收下一個遊戲進行狀態
    // 1:成功 更新 sportKujiTableView
    // 不成功則用 Alert 顯示不成功狀態碼
    //=====================================================//
    func changeGeameStatus(pirateMainGameCenterView:PirateMainGameCenterView) {
        
        
        if(pirateMainGameCenterView.gameStatus == -1){//預備
            
            if let mainViewController = myMainViewController {
                
                //播放背景音樂 BGM:02
                mainViewController.playAudio(type:.bgm,index:2,delay: 0.1)
                
            }
            
        }
        
    }
    
    //=====================================================//
    // 隱藏 HomeIndicator (不影響遊戲)
    //=====================================================//
    override var prefersHomeIndicatorAutoHidden: Bool {
        //return self.indicatorAutoHidden
        return true
    }

}
