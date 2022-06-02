//
//  AudioPlayer.swift
//  AkitosHome
//
//  自定義的音效播放器
//
//  Created by akito on 2022/5/3`.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

import AVFoundation
import AudioToolbox

enum AudioType{
    
    case bgm //背景音樂
    case se  //效果音
    
}
class AudioPlayer {
    
    //總共?首背景音樂 BGM
    let BGM_NUMS:Int = 3
    
    //首背景音樂 BGM 是否播放中
    var isBgmPlaying:Int = -1
    
    //背景音樂 BGM AVAudioPlayer 存放的Array
    var myBgmPlayers:[AVAudioPlayer] = []
    
    init(){
        
        // 建立 BGM 播放器
        
        for i in 0..<BGM_NUMS{
            
            var resourceString = "Audio/BGM/bgm_00"
            if(i>9){
                resourceString = "Audio/BGM/bgm_0"
            }
            
            if let bgm_path = Bundle.main.path(forResource: "\(resourceString)\(i)", ofType: "mp3"){
            
                do {

                    let bgmPlayer = try AVAudioPlayer(contentsOf: NSURL.fileURL(withPath: bgm_path))
                    
                    // 重複播放次數 設為 -1 無限次循環
                    bgmPlayer.numberOfLoops = -1
                    
                    myBgmPlayers.append(bgmPlayer)

                } catch {
                    print("error")
                }
            }
            
        }
        
    }
    
    //播放背景音樂 BGM 用
    func plyayBgm(index:Int,delay:Double){
        

        if(isBgmPlaying >= 0 && isBgmPlaying<myBgmPlayers.count){
            //先檢查是否有播放中的BGM, 有的話就先停掉
            let bgmPlayer = myBgmPlayers[isBgmPlaying]
            bgmPlayer.stop()
        }
        
        isBgmPlaying = -1;
        
        if (index >= 0 && index < myBgmPlayers.count){
            
            if(delay<0.0){
                
                //播放指定的BGM
                let bgmPlayer:AVAudioPlayer = myBgmPlayers[index]
                
                //從頭播放
                bgmPlayer.currentTime = 0
    
                bgmPlayer.play()
                
                isBgmPlaying = index
                
            }else{
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {[unowned self] in
                    self.plyayBgm(index:index,delay:-1.0)
                }
                
            }
        }

    }
    
    //播放效果音 SE 用
    func plyaySe(index:Int){
        
        //index
        //0: 點擊
        //1: 返回
        //2: Error
        //3: 開獎
        
        var resourceString = ""
        var soundID = SystemSoundID(index)
        
        if index < 0{
            return
        }else if(index <= 9){
            resourceString = "Audio/SE/se_00"
        }else{
            resourceString = "Audio/SE/se_0"
        }
        
        if let path = Bundle.main.path(forResource: "\(resourceString)\(index)", ofType: "wav"){
            
            let baseURL = NSURL(fileURLWithPath: path)
            
            //赋值
            AudioServicesCreateSystemSoundID(baseURL, &soundID)

            //播放SystemSound
            AudioServicesPlaySystemSound(soundID)
            
            //主音效用 AlertSound 播放(帶震動)
            //AudioServicesPlayAlertSound(soundID)
            
        }else{
            
            //SE播放失敗
            
        }
        
        
    }
    
}
