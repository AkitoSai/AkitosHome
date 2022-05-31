# AkitosHome
Read Me
AkitosHome.xcodeproj
Created by 蔡 易達 on 2022/5/31.
Copyright © 2022年 蔡 易達. All rights reserved.


//====================AkitosHome.xcodeproj====================//
主頁面MainViewController:
包含了一個按鈕、按下後可切換至SportKujiViewController

SportKujiViewController:
自建的class(SportKujiRequestUnitView)抓取日本スポーツくじ的API(spkuji_api)、實現抓取後並顯示當期開獎數字

SportKujiRequestUnitView:
自建的class、透過Http的get方式向spkuji_api請求響應再用SportKujiRequestUnitViewDelegate的protocol來回傳結果給delegate。

AudioPlayer:
使用了AVFoundation以及AudioToolbox的一些功能來播放背景音樂(BGM)以及效果音(SE)
====================AkitosHome.xcodeproj====================//


