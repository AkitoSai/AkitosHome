//
//  UIInvitationTableViewCell.h
//  AkitosHome
//
//  Created by akito on 2022/6/7.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// UIInvitationTableViewCellDelegate協議定義
@protocol UIInvitationTableViewCellDelegate <NSObject>

@required
// 點擊按扭
-(void)clickButtonWithIndex:(int)_index withPid:(NSString *)pidString;

@end


@interface UIInvitationTableViewCell : UITableViewCell{

    //delegate
    id<UIInvitationTableViewCellDelegate> _delegate;

    // View 縮放的比例 預設為 iPhone X 寬度 375.0 為基準
    double zoomSize;
    
    
    // 照片UIImageView
    UIImageView *photoImageView;

    // 姓名Label
    UILabel *nameLabel;
    
    // 邀請中Label
    UILabel *invitationLabel;
    
    // 儲存pid的字串
    NSString *myPidString;
}

//DataRequestUnitDelegate
@property (nonatomic, strong) id delegate;

// 帶入數據
- (void)setName:(NSString *)nameString withPid:(NSString *)pidString;
 

@end

NS_ASSUME_NONNULL_END
