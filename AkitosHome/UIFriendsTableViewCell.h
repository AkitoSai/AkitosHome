//
//  UIFriendsTableViewCell.h
//  AkitosHome
//
//  Created by akito on 2022/6/4.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFriendsTableViewCell : UITableViewCell{

// View 縮放的比例 預設為 iPhone X 寬度 375.0 為基準
double zoomSize;
    
    // 照片UIImageView
    UIImageView *photoImageView;

    // 星星IImageView
    UIImageView *isTopImageView;

    // 姓名Label
    UILabel *nameLabel;
    
    // 邀請中Label
    UILabel *invitationLabel;
    
}

// 帶入數據
- (void)setName:(NSString *)nameString status:(int)statusInt isTop:(int)isTopInt setSearch:(NSString *)searchString;
 

@end

NS_ASSUME_NONNULL_END
