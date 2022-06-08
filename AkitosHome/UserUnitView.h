//
//  UserUnitView.h
//  AkitosHome
//
//  Created by akito on 2022/6/3.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ObjCViewController.h"

#import "DataRequestUnit.h"

NS_ASSUME_NONNULL_BEGIN

@class ObjCViewController;

@interface UserUnitView : UIView<DataRequestUnitDelegate>{
    
    // View 縮放的比例 預設為 iPhone X 寬度 375.0 為基準
    double zoomSize;

    // 連線用 DataRequestUnit
    DataRequestUnit *dataRequestUnit;

    // 儲存用戶資料 Dictionary
    NSDictionary *userDictionary;

    // 用戶名 Label
    UILabel *userNameLabel;

    // 用戶ID Label
    UILabel *userIDLabel;
    
}

// 上層ViewController
@property (nonatomic, weak) ObjCViewController *myObjCViewController;

// 請求時需執行的動作
- (void)doRequest;

@end

NS_ASSUME_NONNULL_END
