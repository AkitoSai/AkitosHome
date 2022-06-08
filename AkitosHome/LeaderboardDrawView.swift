//
//  LeaderboardDrawView.swift
//  AkitosHome
//
//  Created by akito on 2022/6/2.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

import UIKit
class LeaderboardDrawView: UIView {
    
    // View 縮放的比例 預設為 iPhone X 寬度 375.0 為基準
    var zoomSize:Double = 1.0
    
    // 一行的高度
    var cellHeight:Int = 25
    
    // 存放獲得的響應的 LeaderboardResults struct
    var myLeaderboardResults:LeaderboardResults?

    // 重繪完成後呼叫的Closure
    var didReDraw: ((Double) -> Void)?
    
    //=====================================================//
    // 初始化 init
    //=====================================================//
    init(frame:CGRect,zoom:Double){
        
        super.init(frame: frame)
        
        // 設定縮放的比例
        zoomSize = zoom
        
        // 一行的高度
        cellHeight = 25*Int(zoomSize)
        
    }
    
    
    //=====================================================//
    // 初始化 init?
    //=====================================================//
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    
    //=====================================================//
    // 重繪制 reDraw
    //=====================================================//
    func reDraw(leaderboardResults:LeaderboardResults){

        myLeaderboardResults = leaderboardResults
        
        // 計算字自己frame的新高度
        let viewFrameHeight:Double = Double(cellHeight * myLeaderboardResults!.results.count)
        
        // 依照結果對應行數調整繪圖範圍
        self.frame = CGRect(x:0*zoomSize, y: 0*zoomSize, width: self.frame.width, height:viewFrameHeight)
        
        // 重新繪製
        self.setNeedsDisplay()
        
        // 重繪完成後呼叫的Closure
        didReDraw!(viewFrameHeight)
    }
    
    
    //=====================================================//
    // 自行繪製 draw
    //=====================================================//
    override func draw(_ rect: CGRect) {
        
        
        if let leaderboardResults = myLeaderboardResults {
            
            //計算排名用
            var rankNum = 0
            
            //比對同分用
            var preScore:Int = 0
            
            
            for i in 0..<leaderboardResults.results.count {
             
                let leaderboardResult:LeaderboardResult = leaderboardResults.results[i]
                
                let nowScore:Int = Int(leaderboardResult.score)
                
                
                // 判斷是否同分 同分名次要顯示相同的
                if(i == 0){
                    
                    //第一筆設定為第一名
                    rankNum = 1
                    
                    preScore = nowScore;
                    
                }else{
                    
                    if(preScore > nowScore){
                        
                        preScore = nowScore;
                        
                        rankNum = i+1
                        
                    }
                }
                
                
                // 描繪玩家名字
                let nameTextBackgroundColor = UIColor.white
                let nameTextRect = CGRect(x: 5*Int(zoomSize), y: Int(i*cellHeight), width: Int(self.frame.width), height: cellHeight)
                let paraStyle = NSMutableParagraphStyle()
                    paraStyle.alignment = .left

                let nameTextAttrs = [
                    NSAttributedString.Key.paragraphStyle: paraStyle,
                    NSAttributedString.Key.backgroundColor:nameTextBackgroundColor,
                    NSAttributedString.Key.baselineOffset: NSNumber(floatLiteral: 0.0),
                    NSAttributedString.Key.font:UIFont(name: "Arial Rounded MT Bold", size: 18*zoomSize)
                ]
                let nameTextContent = "\(rankNum).\(leaderboardResult.name)"
                let nameText = NSAttributedString(string: nameTextContent, attributes: nameTextAttrs as [NSAttributedString.Key : Any])
                nameText.draw(in: nameTextRect)
                
                
                
                // 描繪分數
                let scoreTextBackgroundColor = UIColor.white
                let scoreTextRect = CGRect(x: 0, y: Int(i*cellHeight), width: Int(self.frame.width-5*zoomSize), height: cellHeight)
                let scoreTextParaStyle = NSMutableParagraphStyle()
                scoreTextParaStyle.alignment = .right

                let scoreTextAttrs = [
                    NSAttributedString.Key.paragraphStyle: scoreTextParaStyle,
                    NSAttributedString.Key.backgroundColor:scoreTextBackgroundColor,
                    NSAttributedString.Key.baselineOffset: NSNumber(floatLiteral: 0.0),
                    NSAttributedString.Key.font:UIFont(name: "Arial Rounded MT Bold", size: 18*zoomSize)
                ]
                let scoreTextContent = "\(Int(leaderboardResult.score))pt"
                let scoreText = NSAttributedString(string: scoreTextContent, attributes: scoreTextAttrs as [NSAttributedString.Key : Any])
                
                scoreText.draw(in: scoreTextRect)
                
                
                
                // 描繪分數
                let path = UIBezierPath()
                // 一格的高度
               //設定填色
                UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 100/255).setFill()
                //勾勒顏色
                UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 100/255).setStroke()
                //路徑寬度
                path.lineWidth = CGFloat(1*zoomSize)
                var point = CGPoint(x: 0, y: Int(i*cellHeight))
                path.move(to: point)
                point = CGPoint(x: Int(self.frame.width), y: Int(i*cellHeight))
                path.addLine(to: point)
                path.fill()
                path.stroke()
                
            }
            
        }
        
    }
    
}
