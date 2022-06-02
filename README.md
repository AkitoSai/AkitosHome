# AkitosHome 1.0.0


# 主頁面
- MainViewController：  
主頁面，包含了1個按鈕，按下後可切換至 SportKujiViewController 。


# スポーツくじ功能頁面
- SportKujiViewController  
自建的 class (SportKujiRequestUnitView) 抓取日本スポーツくじ的 API (spkuji_api)，實現抓取後並顯示當期開獎數字 。

- SportKujiRequestUnitView  
自建的 class、透過 Http 的 get 方式向 spkuji_api 請求響應，再用 SportKujiRequestUnitViewDelegate 的 protocol 來回傳結果給 delegate 。


# 音樂播放器
- AudioPlayer  
使用了 AVFoundation 以及 AudioToolbox 的一些功能來播放背景音樂(BGM)以及效果音(SE) 。  

====================================  
Read Me  
Created by 蔡 易達 on 2022/5/31.  
Copyright © 2022年 蔡 易達. All rights reserved.
