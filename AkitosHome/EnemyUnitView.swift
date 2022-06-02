//
//  EnemyUnitView.swift
//  AkitosHome
//
//  Created by akito on 2022/6/1.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

import UIKit

class EnemyUnitView:UIImageView {
    
    // 編號
    var number:Int! = -1
    
    // 種類數目
    let allKindNums:Int! = 3
    // 0: 紫色章魚兵
    // 1: 紅色快章魚將軍
    // 2: 綠色胖章魚王
    var kind:Int! = 0
    
    // 需要被擊殺的次數
    var killNeedTimes:Int! = 1
    
    // 目前被擊殺的次數
    var killTimes:Int! = 0
    
    //兩次被擊殺間的不可攻擊性的倒數Cnt
    var killIntervalCnt:Int! = 0
    
    // 速度基礎值
    var speed:Double! = 0.0
    
    // 價值(換算得分用)
    var value:Int! = 0
    
    //動畫狀態
    var animeStatusNums:Int! = 12
    var animeStatus:Int! = 0
    
    //動畫狀態方向 1:左 -1:右
    var animeDir:Int! = 1
    
    //動畫變更用計數器
    var animeCntMax:Int! = 5
    var animeCnt:Int! = 0
    
    // 判斷為擊殺敵人後做的處理Closure
    var killed: (() -> Void)?
    
    
    //=====================================================//
    // 初始化 init
    //=====================================================//
    override init(frame:CGRect){
        
        super.init(frame: frame)
    
        
    }
    
    
    //=====================================================//
    // 初始化 init?
    //=====================================================//
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    //=====================================================//
    // 重設(含種類設定)
    //=====================================================//
    func reset(newKind:Int){
        
        if ((newKind >= 0) && (newKind < allKindNums)){
            
            // 設定種類
            self.image = UIImage(named: "Image/enemy_0\(newKind)_00.png")
            kind = newKind
            
            
            //設定價值
            switch kind{
                
            case 0: // 0: 紫色章魚兵 價值10
                value = 10
                speed = 1.0
                killNeedTimes = 1
                
            case 1: //1: 紅色快章魚將軍 價值100
                value = 200
                speed = 2.0
                killNeedTimes = 1
                
            case 2: //2: 綠色胖章魚王 價值500
                value = 500
                speed = 0.5
                killNeedTimes = 2
                
            default:
                value = 0
            }
            
        }
        
        //基本重設
        reset()
        
    }
    
    //=====================================================//
    // 基本重設
    //=====================================================//
    func reset(){
        
        // 需要被擊殺的次數
        killTimes = killNeedTimes
        
        //兩次被擊殺間的不可攻擊性的倒數Cnt
        killIntervalCnt = 0
        
        
        //亂數重設動畫狀態
        animeStatus = Int.random(in: 0...1)
        
        
        //亂數重設動畫變更用計數器
        animeCnt = Int.random(in: 0...animeCntMax)
        
            
        //亂數重設動畫狀態方向 1:左 -1:右
        animeDir = Int.random(in: 0...1)
        if(animeDir == 0){
            animeDir = -1
        }
        self.transform = CGAffineTransform(scaleX: CGFloat(animeDir), y: 1)

        self.alpha = 1.0
        self.isHidden = false
        
    }
    
    
    //=====================================================//
    // 判斷有效的擊中的處理
    // hitTop: 有效的擊中範圍最上方Y座標
    // hitBottom: 有效的擊中範圍最下方Y座標
    // hitLeft: 有效的擊中範圍最上方Y座標
    // hitRight: 有效的擊中範圍最下方Y座標
    //=====================================================//
    func isHit(touchX:Double,touchY:Double,hitTop:Double,hitBottom:Double,hitLeft:Double,hitRight:Double){
        
        if(touchY > hitTop){
            if(touchY < hitBottom){
                if(touchX > hitLeft){
                    if(touchX < hitRight){
                
                        //在範圍內判定擊中 且 兩次被擊殺間的不可攻擊的倒數Cnt為0
                        if(killIntervalCnt == 0){
                            killTimes -= 1
                        }
                        
                        if(killTimes <= 0){
                            
                            // 達到需要擊中次數判斷為擊殺執行Closure讓控制中心處理
                            self.killed!()
                            
                        }else{
                            
                            //不可攻擊的倒數Cnt設為80
                            killIntervalCnt = 80
                            
                        }
                     }
                 }
            }
                
        }

    }
    //=====================================================//
    // 移動處理
    // speedY: Y方向的速度
    // startY: Y方向的起點
    // endY: Y方向的終點
    //=====================================================//
    func doMove(speedY:Double,startY:Double,endY:Double){
        
        //遊戲中敵人會執行移動 目前只有向上移動所以是走Y方向
        let ememyNextX:Double = self.frame.origin.x
        var ememyNextY:Double = self.frame.origin.y + self.speed*speedY
        
        //超過終點的話則重新放回起點繼續下一輪出線
        if(ememyNextY <= endY){
            ememyNextY = startY
        }
        self.frame.origin = CGPoint(x: ememyNextX, y: ememyNextY)
        
        //執行動畫
        self.countAnime()
        
    }
    //=====================================================//
    // 動畫處理
    //=====================================================//
    func countAnime(){
        
        animeCnt += 1
        
        //動畫計數到達切換動畫的數目後則切換下一張動畫
        if(animeCnt >= animeCntMax){
            
            animeCnt = 0
            
            animeStatus+=1
            
            if(animeStatus >= animeStatusNums){
                
                
                animeStatus=0
                
            }
            
            // 一些動畫參數
            if(animeStatus == 1){
                self.transform = CGAffineTransform(scaleX: 0.94*CGFloat(animeDir), y: 0.96)
            }else if(animeStatus == 2){
                self.transform = CGAffineTransform(scaleX: 0.96*CGFloat(animeDir), y: 0.94)
            }else if(animeStatus == 3){
                self.transform = CGAffineTransform(scaleX: 0.98*CGFloat(animeDir), y: 0.92)
            }else if(animeStatus == 4){
                self.transform = CGAffineTransform(scaleX: 1.0*CGFloat(animeDir), y: 0.90)
            }else if(animeStatus == 5){
                self.transform = CGAffineTransform(scaleX: 1.02*CGFloat(animeDir), y: 0.88)
            }else if(animeStatus == 6){
                self.transform = CGAffineTransform(scaleX: 1.04*CGFloat(animeDir), y: 0.86)
            }else{
                self.transform = CGAffineTransform(scaleX: 0.90*CGFloat(animeDir), y: 1.03)
            }
        }
        
        //兩次被擊殺間的不可攻擊的倒數Cnt減1
        if(killIntervalCnt > 0){
            
            killIntervalCnt -= 1
            
            //每10個cnt切換isHidden製造閃爍效果
            let isHiddenAnime = Int((killIntervalCnt/10)%2)
            if(isHiddenAnime == 0){
                self.isHidden = false
            }else{
                self.isHidden = true
            }
            
            //不可攻擊狀態時的alpha
            self.alpha = 0.7
                
            
        }else{
            
            //可攻擊狀態時的alpha
            self.alpha = 1.0
        }
        
    }
    
}
