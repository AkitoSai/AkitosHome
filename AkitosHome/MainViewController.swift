//
//  MainViewController.swift
//  Daniel
//
//  Created by 蔡 易達 on 2022/5/31.
//  Copyright © 2022年 蔡 易達. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController,URLSessionDelegate {
    
    // 取得螢幕的尺寸
    let fullSize = UIScreen.main.bounds.size
    
    // View 縮放的比例 預設為 iPhone X 寬度 375.0 為基準
    var zoomSize = 1.0
    
    // 全體音效播放器 AudioPlayer
    var myAudioPlayer:AudioPlayer?
    
    // スポーツくじ開獎頁面的 ViewController
    var mySportKujiViewController:SportKujiViewController?
    
    //海賊遊戲頁面的 ViewController
    var myPirateGameViewController:PirateGameViewController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 計算畫面縮放的比例 以寬度375為基準
        zoomSize = Double(fullSize.width)/375.0
        
        print("fullSize.width:\(fullSize.width),fullSize.height:\(fullSize.height)")
        print("zoomSize:\(zoomSize)")
        
        
        // 設置底色
        self.view.backgroundColor = UIColor.white
        
        
        //======== 設置自定義最上方的 TitleBarView ========//
        // 設置背景圖片 myImageView
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
        myImageView.image = UIImage(named: "Image/img_main_back.jpg")
        self.view.addSubview(myImageView)
        //=====================================================//
        
        
        //======== 初始化全體音效播放器 myAudioPlayer ========//
        let myTitleLabel = UILabel(frame: CGRect(x: 0, y: 110 * zoomSize, width: fullSize.width, height: 80 * zoomSize))
        //myTitleLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 100/255)
        myTitleLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 47)
        myTitleLabel.textColor = UIColor.white
        myTitleLabel.textAlignment = .center
        myTitleLabel.text = "Akito's Home"
        self.view.addSubview(myTitleLabel)
        //=====================================================//

        
        //======== 建立前往 mySportKujiViewController 頁面的 UIButton ========//
        let goToSportKujiButton = UIButton(frame: CGRect(x: 0, y: 0, width: 305*zoomSize, height: 72*zoomSize))
        goToSportKujiButton.layer.masksToBounds = true
        goToSportKujiButton.layer.cornerRadius = 15.0
        goToSportKujiButton.setImage(UIImage(named: "Image/img_main_button_00.png"), for: .normal)
        //goToKujiButton.setTitle("スポーツくじ", for: .normal)
        goToSportKujiButton.addTarget(nil, action: #selector(self.goToSportKujiViewController), for: .touchUpInside)
        goToSportKujiButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.65)
        self.view.addSubview(goToSportKujiButton)
        //=====================================================//
        
        
        //======== 建立前往 myPirateGameViewController 頁面的 UIButton ========//
        let goToPirateGameButton = UIButton(frame: CGRect(x: 0, y: 0, width: 305*zoomSize, height: 72*zoomSize))
        //goToPirateGameButton.layer.masksToBounds = true
        goToPirateGameButton.layer.cornerRadius = 15.0
        goToPirateGameButton.setImage(UIImage(named: "Image/img_main_button_01.png"), for: .normal)
        //goToPirateGameButton.setTitle("Kill Pirates", for: .normal)
        //goToPirateGameButton.setTitleColor(UIColor.yellow, for: .normal)
        //goToPirateGameButton.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 15)
        goToPirateGameButton.addTarget(nil, action: #selector(self.goToMyPirateGameViewController), for: .touchUpInside)
        goToPirateGameButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.77)
        self.view.addSubview(goToPirateGameButton)
        //=====================================================//
        
        
        //======== 初始化全體音效播放器 myAudioPlayer ========//
        myAudioPlayer = AudioPlayer()
        //=====================================================//
        
        
        //播放背景音樂 BGM:0
        playAudio(type:.bgm,index:0)
        
        
        
        print("viewDidLoad: MainViewController")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear: MainViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        print("viewDidAppear: MainViewController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear: MainViewController")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("viewDidDisappear: MainViewController")
    }
    

    //=====================================================//
    // 前往 mySportKujiViewController 頁面的函式
    //=====================================================//
    @objc func goToSportKujiViewController() {
        
        //播放效果音 SE:0
        playAudio(type:.se,index:0)
        //播放背景音樂 BGM:1
        playAudio(type:.bgm,index:1,delay: 0.3)
        
        //判斷 navigationController 中最頂端的是否是自己(mainViewController)
        if(self.navigationController?.topViewController?.isKind(of:MainViewController.self))!{
            
            //判斷mySportKujiViewController是否已存在
            if let sportKujiViewController = mySportKujiViewController{
                
                //若已建立 mySportKujiViewController 則直接 push 進navigationController
                navigationController!.pushViewController(sportKujiViewController, animated: true)
                
                sportKujiViewController.open()
                
            }else{
                
                //若還未建立 mySportKujiViewController 則新建立
                mySportKujiViewController = SportKujiViewController()
                mySportKujiViewController!.myMainViewController = self
                
                //然後再 push 進navigationController
                navigationController!.pushViewController(mySportKujiViewController!, animated: true)
                
                
            }
            
        }
        
    }
    
    
    //=====================================================//
    // 前往 myPirateGameViewController 頁面的函式
    //=====================================================//
    @objc func goToMyPirateGameViewController() {
        
        //播放效果音 SE:0
        playAudio(type:.se,index:0)
        
        //判斷 navigationController 中最頂端的是否是自己(mainViewController)
        if(self.navigationController?.topViewController?.isKind(of:MainViewController.self))!{
            
            // 設定換頁動畫為上往下
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromTop
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            view.window?.layer.add(transition, forKey: kCATransition)
            
            
            //判斷myPirateGameViewController是否已建立存在
            if let pirateGameViewController = myPirateGameViewController{
                
                //若已建立 myPirateGameViewController 則直接 push 進navigationController
                navigationController!.pushViewController(pirateGameViewController, animated: true)
                
                myPirateGameViewController!.open()
                
            }else{
                
                //若還未建立 myKujiViewController 則新建立
                myPirateGameViewController = PirateGameViewController()
                myPirateGameViewController!.myMainViewController = self
                
                //然後再 push 進navigationController
                navigationController!.pushViewController(myPirateGameViewController!, animated: true)

                
            }
            
            /*
            if #available(iOS 11.0, *) {
                
              // iOS 11.0以上隱藏 HomeIndicator
                //self.shouldHideHomeIndicator = true
                self.setNeedsUpdateOfHomeIndicatorAutoHidden()
            }
             */
            
        }
        
    }
    
    
    //=====================================================//
    // 音樂開始播放控制
    // 延遲時間默認設置為不延遲(-1.0)
    //=====================================================//
    func playAudio(type:AudioType , index:Int , delay: Double = -1.0) {
        
        
        switch type{
            
        case .bgm:
            
            if let audioPlayer:AudioPlayer = myAudioPlayer {
                audioPlayer.plyayBgm(index:index,delay: delay)
            }
            
        case .se:
            
            if let audioPlayer:AudioPlayer = myAudioPlayer {
                audioPlayer.plyaySe(index:index)
            }
            
        }

    }
    
}

