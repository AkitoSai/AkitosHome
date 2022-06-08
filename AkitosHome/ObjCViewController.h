//
//  ObjCViewController.h
//  AkitosHome
//
//  Created by akito on 2022/6/3.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserUnitView.h"
#import "FriendsListView.h"

NS_ASSUME_NONNULL_BEGIN

@class MainViewController;
@class FriendsListView;
@class UserUnitView;

@interface ObjCViewController : UIViewController{
    
    
    // View 縮放的比例 預設為 iPhone X 寬度 375.0 為基準
    double zoomSize;
    
    // 從畫面頂端偏移的Y的高度
    double viewTopOffsetY ;
    
    // 頂端topBarImageView的高度
    double topBarImageViewHeight;
    
    // myUserUnitView的高度
    double myUserUnitViewHeight;
    
    // 底端topImageView的高度
    double bottomImageViewHeight;
    
    // myUserUnitView
    UserUnitView *myUserUnitView;
    
    // myFriendsListView
    FriendsListView *myFriendsListView;

    //mySegmentedControl
    UISegmentedControl * mySegmentedControl;
    
    // 顯示提醒的 的AlertController
    UIAlertController *myAlertController;
    
}
    
// 上層主頁面 MainViewController
@property(weak,nonatomic) MainViewController *myMainViewController;

// 打開頁面時需執行的動作
- (void)open;

// 顯示提醒標語
- (void)showAlertWithMessage:(NSString*)messageString;

@end

NS_ASSUME_NONNULL_END
