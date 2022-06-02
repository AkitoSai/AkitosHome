//
//  EffectUnitView.swift
//  AkitosHome
//
//  Created by akito on 2022/6/1.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

import Foundation

import UIKit

class EffectUnitView:UIImageView {
    
    
    // 種類數目
    let allKindNums:Int! = 1
    // 0: 泡泡破掉
    var kind:Int! = 0
    
    
    //動畫狀態方向 1:左 -1:右
    var animeDir:Int! = 1
    
    //動畫變更用計數器
    var animeCntMax:Int! = 300
    var animeCnt:Int! = 0
    
    
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
            self.image = UIImage(named: "Image/effect_0\(newKind)_00.png")
            kind = newKind
            
            
        }
        
        //基本重設
        reset()
        
        
    }
    
    //=====================================================//
    // 基本重設
    //=====================================================//
    func reset(){
        
        //動畫變更用計數器設0
        animeCnt = 0
        
            
        //亂數重設動畫狀態方向 1:左 -1:右
        animeDir = Int.random(in: 0...1)
        if(animeDir == 0){
            animeDir = -1
        }
        self.transform = CGAffineTransform(scaleX: CGFloat(animeDir), y: 1)

        self.isHidden = true
        self.alpha = 0.6
    }
    
    //=====================================================//
    // 開始動畫
    //=====================================================//
    func start(){
        
        //基本重設
        reset()
        
        //動畫變更用計數器設為上限值
        animeCnt = animeCntMax
        
        self.isHidden = false
        
    }
    
    //=====================================================//
    // 移動處理
    // speedY: Y方向的速度
    // endY: Y方向的終點
    //=====================================================//
    func doMove(speedY:Double,endY:Double){
        
        countAnime()
        
        //遊戲中敵人會執行移動 目前只有向上移動所以是走Y方向
        let effectNextX:Double = self.frame.origin.x
        let effectNextY:Double = self.frame.origin.y + 5.0*speedY
        
        //超過終點的話則重新放回起點繼續下一輪出線
        if(effectNextY <= endY){
            
            //結束效果週期
            animeCnt = 0
            self.isHidden = true
            
        }
        self.frame.origin = CGPoint(x: effectNextX, y: effectNextY)
        
        //執行動畫
        self.countAnime()
        
    }
    
    //=====================================================//
    // 動畫處理
    //=====================================================//
    func countAnime(){
        
        
        animeCnt -= 1
        
        //動畫計數到達切換動畫的數目後則切換下一張動畫
        if(animeCnt <= 0){
            
            //結束效果週期
            animeCnt = 0
            self.isHidden = true
            
        }else{
            
            let scale:Double = Double(animeCnt)/Double(animeCntMax)
            self.transform = CGAffineTransform(scaleX: scale*CGFloat(animeDir), y: scale)
            
        }
    }
    
}
