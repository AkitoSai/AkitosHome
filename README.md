# AkitosHome 1.2.0


# 主頁面(Swift)
- MainViewController：  
主頁面，包含了2個按鈕，按下後可切換至 SportKujiViewController 以及 PirateGameViewController 。


# スポーツくじ功能頁面(Swift)
- SportKujiViewController  
自建的 class (SportKujiRequestUnitView) 抓取日本スポーツくじ的 API (spkuji_api)，實現抓取後並顯示當期開獎號碼。

- SportKujiRequestUnitView  
透過 Http 的 get 方式向 spkuji_api 請求響應，再用 SportKujiRequestUnitViewDelegate 的 protocol 來回傳結果給 delegate 的方式實現的 class 。

# 打海賊遊戲功能頁面(Swift)
- PirateGameViewController  
遊戲的ViewController ，負責跟主頁面之間的切換以及音樂播放，放入遊戲主要控制中心 PirateMainGameCenter 執行遊戲。

- PirateMainGameCenter  
遊戲主要控制中心、遊戲的控制流程以及透過 mainTimer 管理進行流程、操作判斷、計時、計分...等，敵人以及遊戲效果則是分別交由 EnemyUnitView 以及 EffectUnitView 執行。  

- EnemyUnitView  
自建敵人的物件class、管理敵人的移動、動畫、是否被擊殺...等動作狀態，敵人被擊殺時，由於之前Http請求功能時已經使用過 delegate 方式了，這邊嘗試使用 Closure 方式 ”var killed: (() -> Void)?“ 實現與遊戲主要控制中心的溝通。

- EffectUnitView  
遊戲效果的物件class，處理例如敵人被擊殺後變成泡泡的動畫功能。  

- LeaderboardUnitView  
透過 Http 的 get 方式向 pirates_leaderboard api 請求響應，將遊戲的成績以 GET 方式上傳玩家名稱(name)以及得分(score)兩項數據，再由接口接收前50筆分數最高的家成績，透過 LeaderboardDrawView 繪製出排行榜。

- LeaderboardDrawView  
使用直接繪製View的方式代替TableVIew實現多行的排行榜成績展示功能，以 Closure 方式在繪製完成後依照行數的變更改變上層放置的 ScrollView 的可視內容範圍的高度。

# 海賊工會功能頁面(Objective - C)
- ObjCViewController  
工會ViewController，採 Objective - C 混編方式與Swift編寫的主頁面 MainViewController 進行頁面切換及溝通。

- FriendsListView  
工會主架構，其中放置了處理使用者資訊的 UserUnitView、好友列表以及邀請列表的 FriendsListView。

- DataRequestUnit  
實現非同期通訊請求的單元，請求結果可經由 protocol 來回傳結果給 delegate 。

- UIFriendsTableViewCell  
自定義的TableViewCell，用來顯示好友資料 。

- UIInvitationTableViewCell  
自定義的TableViewCell，用來顯示向使用者發出交友邀請的名單，包含了同意以及拒絕按鈕，按鈕的結果可經由 protocol 來回傳結果給 delegate 執行追加或刪除。

# 音樂播放器(Swift)
- AudioPlayer:  
使用了 AVFoundation 以及 AudioToolbox 的一些功能來播放背景音樂(BGM)以及效果音(SE) 。

====================================  
Read Me  
Created by 蔡 易達 on 2022/6/8.  
Copyright © 2022年 蔡 易達. All rights reserved.
