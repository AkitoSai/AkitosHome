//
//  PirateMainGameCenter.swift
//  AkitosHome
//
//  Created by akito on 2022/6/1.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

import UIKit
import AudioToolbox

//=====================================================//
// 遊戲狀態 enum
//=====================================================//
enum GameStatus{
    
    case ready //預備
    case prestart  //準備開始
    case run  //進行中
    case end  //結束
    
}

class PirateMainGameCenterView:UIView {
    
    //總共?個敵人單位View的數目
    let ENEMY_VIEW_NUMS:Int! = 20
    
    
    //總共?個效果單位View的數目
    let EFFECT_VIEW_NUMS:Int! = 20
    
    //計時器執行間隔秒數
    let TIMER_INTERVAL:Double! = 0.012
    
    //一場遊戲的總秒數
    let LIMIT_SECOND:Double! = 70.0 //70.0
    
    // View 縮放的比例 預設為 iPhone X 寬度 375.0 為基準
    var zoomSize:Double = 1.0
    
    // Enemy View的大小
    var enemySizeWidth:Double = 70.0
    var enemySizeHeigth:Double = 70.0
    
    // Enemy單位觸發事件的Y偏移值
    var enemyTouchOffsetY:Double = -30.0
    
    // Enemy單位觸發事件的長寬
    var enemyTouchWidth:Double = 70.0
    var enemyTouchHeight:Double = 70.0
    
    // Enemy 起始位置X的偏移跟亂數範圍
    var enemyOffsetX:Double = -10.0
    var enemyRangeX:Double = 325.0
    
    // Enemy 起始位置Y的偏移
    var enemyOffsetY:Double = 0.0
    
    // enemy 終點位置Y
    var enemyEndY:Double = 0.0
    
    // 主遊戲畫面計時器
    var gam: Timer?
    
    //目前遊戲狀態
    //初始狀態:-1
    var gameStatus:Int! = -1
    
    //目前遊戲的秒數
    var nowSeconds:Double! = 0.0
    
    //目前遊戲分數
    var score:Double! = 0.0
    
    //遊戲起始速度
    var startSeed:Double! = -0.8
    
    //目前遊戲速度
    var speed:Double! = 0.0
    
    //現在操作的座標位置
    var nowTouchX = -1.0
    var nowTouchY = -1.0
    
    //目前遊戲加速度單位
    var addSpeed:Double! = -0.0004
    
    // 主遊戲畫面計時器
    var mainTimer: Timer?
    
    // 主遊戲畫面
    var myMainView:UIView?
    
    // 顯示剩餘時間的 Label
    var myTimeLabel:UILabel!
    
    // 顯示分數的 Label
    var myScoreLabel:UILabel!
    
    // 向 api 上傳分數及取得排行榜的 LeaderboardUnitView
    var myLaderboardUnitView:LeaderboardUnitView!
    
    // 前方訊息的 Label
    var myFrontMessageLabel:UILabel!
    
    // 敵人單位Array
    var enemyViewsArray:[EnemyUnitView] = []
    
    // 遊戲效果單位Array
    var effectViewsArray:[EffectUnitView] = []
    
    // 代理
    var delegate: PirateMainGameCenterViewDelegate?
    
    
    //=====================================================//
    // 初始化 init
    // frame: View的尺寸
    // zoom:  View 縮放的比例
    // pirateGameViewController
    //=====================================================//
    init(frame:CGRect,zoom:Double){
        
        super.init(frame: frame)
        
        // 設定縮放的比例
        zoomSize = zoom
        
        // 算出Enemy單位觸發事件的長寬
        enemyTouchWidth *= zoomSize
        enemyTouchHeight *= zoomSize
        
        // 算出Enemy 起始位置X的偏移跟亂數範圍
        enemyOffsetX *= zoomSize
        enemyRangeX *= zoomSize
        
        // 算出Enemy單位觸發事件的Y偏移值
        enemyTouchOffsetY *= zoomSize
        
        // 算出Enemy View的大小
        enemySizeWidth *= zoomSize
        enemySizeHeigth *= zoomSize
        
        // enemy 起始位置Y設為銀幕高度(初期隱藏在銀幕下方外)
        enemyOffsetY = frame.height
        
        // enemy 終點位置Y設為0.0再減掉一格銀幕高度(銀幕外上方以外)
        enemyEndY -= enemySizeHeigth
        
        //遊戲初始速度為
        startSeed *= zoomSize
        
        //遊戲剛開始速度設為初始速度
        speed = startSeed
        
        //現在操作的座標位置
        nowTouchX = -1.0
        nowTouchY = -1.0
        
        //算出遊戲加速度單位
        addSpeed *= zoomSize
        
        
        //======== 初始化主遊戲畫面 ========//
        myMainView = UIView(frame: frame)
        myMainView!.backgroundColor = UIColor.black
        self.addSubview(myMainView!)
        //=====================================================//
        
        //======== 初始化主遊戲背景畫面並加入主遊戲畫面 ========//
        let myBackgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        myBackgroundImageView.image = UIImage(named: "Image/img_game_back.jpg")
        myBackgroundImageView.alpha = 0.8
        myMainView!.addSubview(myBackgroundImageView)
        //=====================================================//
        
        //======== 初始化 敵人單位 EnemyUnitView 並放入 enemyViewsArray ========//
        for i in 0..<ENEMY_VIEW_NUMS{
            
           let enemyUnitView:EnemyUnitView = EnemyUnitView(frame: CGRect(x: 0, y: 0, width: Int(enemySizeWidth), height: Int(enemySizeHeigth)))
            
            // 設定判斷為擊殺敵人後做的處理Closure
            enemyUnitView.killed = {[unowned self] in
                
                
                // 顯示一個效果單位 0: 泡泡破掉
                for i in 0..<Int(self.effectViewsArray.count){
                    
                    let effectUnitView:EffectUnitView = effectViewsArray[i]
                        
                    if(effectUnitView.animeCnt <= 0){
                        // 設定effectUnitView跟被kill的enemyUnitView相同位置
                        let effectStartX = enemyUnitView.frame.origin.x
                        let effectStartY = enemyUnitView.frame.origin.y
                        effectUnitView.frame.origin = CGPoint(x: effectStartX, y:effectStartY)
                    
                        effectUnitView.start()
                    
                        break
                    }
                    
                }
                
                
                //打中敵人增加分數
                self.score -= Double(enemyUnitView.value)*self.speed
                
                // 重新產生起始位置開始下一次出場循環
                let ememyStartX = Int(self.enemyOffsetX) + Int.random(in: 0...Int(self.enemyRangeX))
                let ememyStartY = Int(self.enemyOffsetY)
                enemyUnitView.frame.origin = CGPoint(x: ememyStartX, y: ememyStartY)
                
                enemyUnitView.reset()
                
                //播放效果音
                self.plyaySe(index:enemyUnitView.kind)
                
                
            }
            
            //設定敵人種類
            // 0: 紫色章魚兵 17隻
            var enemyKind:Int = 0
            if(i >= 19){
                // 2: 綠色胖章魚王 1隻
                enemyKind = 2
            }else if(i >= 17){
                // 1: 紅色快章魚將軍 1隻
                enemyKind = 1
            }
            enemyUnitView.reset(newKind: enemyKind)
            myMainView!.addSubview(enemyUnitView)
            enemyViewsArray.append(enemyUnitView)
            
        }
        //=====================================================//
        
        
        //======== 初始化 遊戲效果單位 EffectUnitView 並放入 effectViewsArray ========//
        for i in 0..<EFFECT_VIEW_NUMS{
            
            let effectUnitView:EffectUnitView = EffectUnitView(frame: CGRect(x: 0, y: 0, width: Int(enemySizeWidth), height: Int(enemySizeHeigth)))
            
            //設定特效種類
            var effectKind:Int = 0
            if(i < EFFECT_VIEW_NUMS){ //目前只有一種
                // 0: 泡泡破掉
                effectKind = 0
            }
            
            effectUnitView.reset(newKind: effectKind)
            myMainView!.addSubview(effectUnitView)
            effectViewsArray.append(effectUnitView)
        }
        //=====================================================//
        
        
        //======== 前方訊息的 Label ========//
        myFrontMessageLabel = UILabel(frame: CGRect(x: 0, y: frame.height/2 - 60*zoomSize, width: frame.width, height: 120 * zoomSize))
        myFrontMessageLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 100/255)
        myFrontMessageLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 60)
        myFrontMessageLabel.textColor = UIColor.yellow
        myFrontMessageLabel.textAlignment = .center
        myFrontMessageLabel.text = ""
        myMainView!.addSubview(myFrontMessageLabel)
        //=====================================================//
        
        
        //======== 設置向 api 上傳分數及取得排行榜的 LaderboardUnitView ========//
        myLaderboardUnitView = LeaderboardUnitView(frame: CGRect(x: 0, y: 0, width: 300 * zoomSize, height: 450 * zoomSize),zoom: zoomSize)
        myLaderboardUnitView.layer.masksToBounds = true
        myLaderboardUnitView.layer.cornerRadius = 15.0
        myLaderboardUnitView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 255/255)
        myLaderboardUnitView.center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        //myLeaderboardUnitVIew.delegate = self
        myMainView!.addSubview(myLaderboardUnitView)
        myLaderboardUnitView.isHidden = true
        //=====================================================//
        
        
        //======== 設置自定義最下方的 BottomBarView ========//
        let myBottomBarView = UIView(frame: CGRect(x: 0, y: frame.height - 58*zoomSize, width: frame.width, height: 58*zoomSize))
        myBottomBarView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 210/255)
        myMainView!.addSubview(myBottomBarView)
        //=====================================================//
        
        
        //======== 初始化分數標題的 Label ========//
        let myScoreTitileLabel = UILabel(frame: CGRect(x: 160*zoomSize, y: 35 * zoomSize, width: 210 * zoomSize, height: 25 * zoomSize))
        //myScoreTitileLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 100/255)
        myScoreTitileLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 24 * zoomSize)
        myScoreTitileLabel.textColor = UIColor.yellow
        myScoreTitileLabel.textAlignment = .left
        myScoreTitileLabel.text = "Score:"
        myMainView!.addSubview(myScoreTitileLabel)
        //=====================================================//
        
        //======== 初始化顯示分數的 Label ========//
        myScoreLabel = UILabel(frame: CGRect(x: 160*zoomSize, y: 35 * zoomSize, width: 200 * zoomSize, height: 25 * zoomSize))
        //myScoreLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 100/255)
        myScoreLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 24 * zoomSize)
        myScoreLabel.textColor = UIColor.yellow
        myScoreLabel.textAlignment = .right
        myScoreLabel.text = ""
        myMainView!.addSubview(myScoreLabel)
        //=====================================================//
        
        
        //======== 初始化顯剩餘時間的示的 Label ========//
        myTimeLabel = UILabel(frame: CGRect(x: 160*zoomSize, y: frame.height - 45 * zoomSize, width: 210 * zoomSize, height: 25 * zoomSize))
        //myTimeLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 100/255)
        myTimeLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 24 * zoomSize)
        myTimeLabel.textColor = UIColor.white
        myTimeLabel.textAlignment = .right
        myTimeLabel.text = ""
        myMainView!.addSubview(myTimeLabel)
        //=====================================================//
        
        
    }
    
    
    //=====================================================//
    // 初始化 init?
    //=====================================================//
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    
    //=====================================================//
    // 重新開始一場遊戲
    //=====================================================//
    func restart(){
        
        //重置遊戲狀態 gameStatus:-1   預備 ready
        changeGeameStatus(nexStatus: GameStatus.ready)
        
    }
    
    //=====================================================//
    // 重設遊戲數值
    //=====================================================//
    func reset(){
        
        //重置遊戲速度為初始速度
        speed = startSeed
        
        //現在操作的座標位置
        nowTouchX = -1.0
        nowTouchY = -1.0
        
        //重置遊戲秒數
        nowSeconds = 0.0
        myTimeLabel.text = ""
        
        //重置遊戲分數
        score = 0
        myScoreLabel.text = "\(Int(score))"
        
        //重置前方訊息
        myFrontMessageLabel.text = ""
    
        // 重設敵人起始位置以及狀態
        for i in 0..<Int(enemyViewsArray.count){
            
            let enemyUnitView:EnemyUnitView = enemyViewsArray[i]
                
            // enemyOffsetX搭配亂數算出敵人起始位置的x值
            let ememyStartX = Int(enemyOffsetX) + Int.random(in: 0...Int(enemyRangeX))
            let ememyStartY = Int(enemyOffsetY) + i*Int(enemySizeHeigth)
            enemyUnitView.frame.origin = CGPoint(x: ememyStartX, y:ememyStartY)
            
            enemyUnitView.reset()
            
        }
        
        // 重設效果單位起始位置以及狀態
        for i in 0..<Int(effectViewsArray.count){
            
            let effectUnitView:EffectUnitView = effectViewsArray[i]
                
            // effectUnitView全都移至銀幕外
            let effectStartX = frame.width
            let effectStartY = frame.height
            effectUnitView.frame.origin = CGPoint(x: effectStartX, y:effectStartY)
            
            effectUnitView.reset()
            
        }
        
        // LaderboardUnitView 設置為關
        if let laderboardUnitView = myLaderboardUnitView{
            laderboardUnitView.close()
        }
        
    }
    
    //=====================================================//
    // 切換下一個遊戲狀態
    //=====================================================//
    func changeGeameStatus(nexStatus:GameStatus){
        
        switch nexStatus{
            
        case .ready: //預備
            
            gameStatus = -1
            
            //還原遊戲起始值
            reset()
            
            // 照告知 delegate 狀態改變
            if let _delegate = delegate {
                _delegate.changeGeameStatus(pirateMainGameCenterView: self)
            }
            
            // 結束之前的timer
            if(mainTimer != nil){
                mainTimer?.invalidate()
                mainTimer = nil
            }
            //前方訊息顯示"Ready"
            myFrontMessageLabel.isHidden = false;
            myFrontMessageLabel.text = "Ready"
            
            //播放效果音 10:號角
            self.plyaySe(index:10)
            
            
            //交給 主執行緒 main 的 Queue　處理
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {[unowned self] in
                
                myFrontMessageLabel.isHidden = false;
                myFrontMessageLabel.text = "Aim"
                
                //播放效果音 10:號角
                self.plyaySe(index:10)
                
            }
            
            
            //交給 主執行緒 main 的 Queue　處理
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {[unowned self] in
                
                //設置遊戲狀態 gameStatus:0   預備 prestart
                self.changeGeameStatus(nexStatus: GameStatus.prestart)
                
            }
            
            return
            
        case .prestart: //準備開始
            
            if(gameStatus == -1){
                
                gameStatus = 0
                
                //前方訊息顯示"Start"
                myFrontMessageLabel.isHidden = false;
                myFrontMessageLabel.text = "Fire"
                
                //播放效果音 10:號角
                self.plyaySe(index:10)
                
                //交給 主執行緒 main 的 Queue　處理
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[unowned self] in
                    
                    
                    //播放效果音 10:號角
                    self.plyaySe(index:10)
                    
                    //設置遊戲狀態 gameStatus:1   進行 run
                    self.changeGeameStatus(nexStatus: GameStatus.run)
                    
                }
                
            }
            
        case .run: //進行
            if(gameStatus == 0){
                
                gameStatus = 1
                
                // 若之前有mainTimer則結束之前的timer並設為nil
                if(mainTimer != nil){
                    mainTimer?.invalidate()
                    mainTimer = nil
                }
                //前方訊息顯示"Ready"
                myFrontMessageLabel.isHidden = true;
                myFrontMessageLabel.text = ""
                
                // 開啟新的timer
                mainTimer = Timer.scheduledTimer(
                    timeInterval: TIMER_INTERVAL,
                    target: self,
                    selector: #selector(gameloopGlobal(timer:)),
                    userInfo: nil,
                    repeats: true)
                
            }case .end: //結束
                if(gameStatus == 1){
                
                gameStatus = 2
                    
                    
                //前方訊息顯示"Ready"
                myFrontMessageLabel.isHidden = false;
                myFrontMessageLabel.text = "End"
                    
                //交給 主執行緒 main 的 Queue　處理
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[unowned self] in
                        

                    if let laderboardUnitView = myLaderboardUnitView{
                        
                        laderboardUnitView.inputName(newScore:score)
                    }
                        
                }
                
            }
            
        }
    }
    
    
    //=====================================================//
    //遊戲主要loop
    //=====================================================//
    @objc func gameloopGlobal(timer: Timer) {
        
        if(gameStatus == 1 || gameStatus == 2){
        }else{
            //非遊戲進行狀態或結束看動畫狀態則停掉mainTimer
            self.mainTimer!.invalidate()
            self.mainTimer = nil
            return
        }
        
        //print("gameloop：\(self.nowSeconds)")
        if(gameStatus == 1){
            
            //增加速度
            self.speed += self.addSpeed
            
            //計算秒數
            self.nowSeconds += self.TIMER_INTERVAL
            
            if self.nowSeconds >= self.LIMIT_SECOND {
                
                //設置遊戲狀態 gameStatus:2   結束 run
                self.changeGeameStatus(nexStatus: GameStatus.end)
                
            }
            
            //執行觸控操作判斷出的結果
            checkTouchEvent(touchX:nowTouchX,touchY:nowTouchY)
            
        }
        
        
        //遊戲執行交給 global 的 Queue　處理
        //DispatchQueue.global(qos: .userInitiated).async {[unowned self] in
            
            //改變UI交由交給 主執行緒 main 的 Queue　處理
            DispatchQueue.main.async {[unowned self] in
            
                
                //更新敵人 enemyUnitView 位置以及執行動畫
                for enemyUnitView in self.enemyViewsArray{
                    
                    if(self.gameStatus == 1){
                        
                        //遊戲進行中敵人會執行移動
                        enemyUnitView.doMove(speedY: self.speed, startY: self.enemyOffsetY, endY: self.enemyEndY)
    
                        
                    }else if(self.gameStatus == 2){
                        
                        //遊戲結束敵人只執行動畫
                        enemyUnitView.countAnime()
                    }
                    
                }
                
                //更新效果 effectUnitView 位置以及執行動畫
                for effectUnitView in self.effectViewsArray{
                    
                    if(effectUnitView.animeCnt > 0){
                        
                        if(self.gameStatus == 1){
                            
                            //遊戲進行中效果會執行動畫
                            effectUnitView.doMove(speedY: self.speed, endY: self.enemyEndY)
        
                            
                        }else if(self.gameStatus == 2){
                            
                            //遊戲結束敵人只執行動畫
                            //enemyUnitView.countAnime()
                        }
                        
                    }
                    
                }
                
                
                //更新分數以及時間 Label 內容
                self.myScoreLabel.text = "\(Int(self.score)) pt"
                self.myTimeLabel.text = "Time　\(Int(self.LIMIT_SECOND-self.nowSeconds))s"
            }
            
        //}
        
    }
    
    //=====================================================//
    //播放效果音(SE)用
    //=====================================================//
    func plyaySe(index:Int){
        
        //index
        //0: 前往下個頁面
        //1: 返回上個頁面
        
        var resourceString = ""
        var soundID = SystemSoundID(index)
        
        if index < 0{
            return
        }else if(index <= 9){
            resourceString = "Audio/SE/se_game_00"
        }else{
            resourceString = "Audio/SE/se_game_0"
        }
        
        if let path = Bundle.main.path(forResource: "\(resourceString)\(index)", ofType: "wav"){
            
            let baseURL = NSURL(fileURLWithPath: path)
            
            // 赋值
            AudioServicesCreateSystemSoundID(baseURL, &soundID)
            
            // 遊戲音效用 SystemSound 播放(不帶震動)
            AudioServicesPlaySystemSound(soundID)
            
            // 初始化 UIImpactFeedbackGenerator
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            // 觸發回饋
            generator.impactOccurred()
            
        }else{
            
            //SE播放失敗
            
        }
        
    }
    
    //=====================================================//
    // 判斷操作銀幕觸碰事件座標並執行相應的動作
    //=====================================================//
    func checkTouchEvent(touchX:Double,touchY:Double){
          
        
        // 操作座標於銀幕外 不觸發操作判斷
        if((nowTouchX<0.0) || (nowTouchY<0.0)){
            return
        }
        
        for enemyUnitView in enemyViewsArray{
            
            let rect_left:Double = enemyUnitView.frame.origin.x
            let rect_top:Double = Double(enemyTouchOffsetY + enemyUnitView.frame.origin.y)
            
            //判斷是否有效擊中
            enemyUnitView.isHit(touchX: touchX, touchY: touchY, hitTop: rect_top, hitBottom: rect_top+enemyTouchHeight-enemyTouchOffsetY, hitLeft: rect_left, hitRight: rect_left+enemyTouchWidth)
        }
           
        
    }
    
    //=====================================================//
    // 獲取銀幕 touchesBegan 事件
    //=====================================================//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            
            //設為現在操作的座標位置
            nowTouchX = t.location(in: self).x
            nowTouchY = t.location(in: self).y
            
        }
        
    }
    
    //=====================================================//
    // 獲取銀幕 touchesEnded 事件
    //=====================================================//
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            
            //設為現在操作的座標位置
            nowTouchX = t.location(in: self).x
            nowTouchY = t.location(in: self).y
            
        }
        
    }
    
    //=====================================================//
    // 獲取銀幕 touchesEnded 事件
    //=====================================================//
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //將座標設置於銀幕外 則不會觸發操作判斷
        nowTouchX = -1.0
        nowTouchY = -1.0
        
    }
    
}


//=====================================================//
// PirateMainGameCenterViewDelegate
//=====================================================//
protocol PirateMainGameCenterViewDelegate{

    // 回傳下一個遊戲進行狀態 給 delegate
    func changeGeameStatus(pirateMainGameCenterView: PirateMainGameCenterView)
    
}

