//
//  UIFriendsTableViewCell.m
//  AkitosHome
//
//  Created by akito on 2022/6/4.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

#import "UIFriendsTableViewCell.h"

@implementation UIFriendsTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        // 取得螢幕的尺寸
        CGSize fullSize = [[UIScreen mainScreen] bounds].size;
        
        // 計算畫面縮放的比例 以寬度375為基準
        zoomSize = fullSize.width/375.0;
        
        
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        
        
        // 自訂cell所有的VIew元件都放進cell的contentView中
        
        
        //======== 背景圓角框 backBoardView ========//
        UIView *backBoardView =[[UIView alloc] initWithFrame:CGRectMake(10*zoomSize, 10*zoomSize, 315*zoomSize, 70*zoomSize)];
        //backBoardView.backgroundColor = [UIColor grayColor];
        backBoardView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        //backBoardView.layer.masksToBounds = YES;
        backBoardView.layer.cornerRadius = 10*zoomSize;
        backBoardView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0].CGColor;
        backBoardView.layer.borderWidth = 0.0*zoomSize;
        
        backBoardView.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4].CGColor;
        backBoardView.layer.shadowRadius = 2*zoomSize;
        backBoardView.layer.shadowOffset = CGSizeMake(2*zoomSize, 2*zoomSize);
        backBoardView.layer.shadowOpacity = 30.0*zoomSize;
        
        backBoardView.hidden = NO;
        [self.contentView addSubview:backBoardView];
        backBoardView = nil;
        //=====================================================//
        
        //======== 設置照片UIImageView ========//
        photoImageView =[[UIImageView alloc] initWithFrame:CGRectMake(50*zoomSize, 20*zoomSize, 44*zoomSize, 44*zoomSize)];
        //_photoImageView.backgroundColor = [UIColor grayColor];
        photoImageView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        photoImageView.layer.cornerRadius = 22*zoomSize;
        photoImageView.layer.borderColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.6].CGColor;
        photoImageView.layer.borderWidth = 1.0*zoomSize;
        photoImageView.hidden = NO;
        [self.contentView addSubview:photoImageView];
        //=====================================================//
        
        
        //======== 設置星星UIImageView ========//
        isTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27*zoomSize, 37*zoomSize, 12*zoomSize, 12*zoomSize)];
        isTopImageView.backgroundColor = [UIColor yellowColor];
        //isTopImageView.backgroundColor = [UIColor colorWithRed:0.9 green:0.6 blue:0.0 alpha:1.0];
        isTopImageView.layer.masksToBounds = YES;
        isTopImageView.layer.cornerRadius = 6*zoomSize;
        isTopImageView.layer.borderColor = [UIColor blackColor].CGColor;
        isTopImageView.layer.borderWidth = 1.5*zoomSize;
        isTopImageView.hidden = YES;
        [self.contentView addSubview:isTopImageView];
        //=====================================================//
        
        
        //======== 設置姓名Label ========//
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110*zoomSize, 32*zoomSize, 200*zoomSize, 20*zoomSize)];
        //nameLabel.backgroundColor = [UIColor blackColor];
        //nameLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.6 blue:0.0 alpha:1.0];
        nameLabel.textColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.0];
        nameLabel.text = @"";
        nameLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:18.0f];//字體的大小以及字型
        nameLabel.hidden = NO;
        [self.contentView addSubview:nameLabel];
        //=====================================================//
        
        
        
        //======== 設置邀請中Label ========//
        invitationLabel = [[UILabel alloc] initWithFrame:CGRectMake(235*zoomSize, 29*zoomSize, 70*zoomSize, 30*zoomSize)];
        //invitationLabel.backgroundColor = [UIColor blackColor];
        //invitationLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.6 blue:0.0 alpha:1.0];
        
        invitationLabel.layer.masksToBounds = YES;
        //invitationLabel.layer.cornerRadius = 12.0;
        invitationLabel.layer.borderColor =  [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1.0].CGColor;
        invitationLabel.layer.borderWidth = 1.0;
        
        invitationLabel.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1.0];
        invitationLabel.text = @"";
        invitationLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:13.0f*zoomSize];//字體的大小以及字型
        invitationLabel.textAlignment = NSTextAlignmentCenter;
        invitationLabel.hidden = NO;
        [self.contentView addSubview:invitationLabel];
        //=====================================================//
        
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    
    return self;
}


//=====================================================//
// 設定各項 Label內容
//=====================================================//
- (void)setName:(NSString *)nameString status:(int)statusInt isTop:(int)isTopInt setSearch:(NSString *)searchString{
    
    //設置姓名
    nameLabel.text = nameString;
    
    
    //若搜尋文字串與姓名內容部分相符,則進行上色
    if(searchString.length > 0){
        
        NSRange range = [nameString rangeOfString:searchString];
        NSUInteger start = range.location;
        NSUInteger end = start + range.length;
        //NSLog(@"over%i",end);
        
        if (end>0) {
            
            NSDictionary *attributesDictionary = @{
                NSFontAttributeName:[UIFont fontWithName:@"Arial Rounded MT Bold" size:18.0f],
                NSForegroundColorAttributeName:[UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.0],
                NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)
            };
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:nameString attributes:attributesDictionary];

             

              [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor colorWithRed:0.4 green:0.71 blue:0.05 alpha:1.0]
                                     range:range];
            nameLabel.attributedText = attributedString;
            
        }
    }
    
    // 判斷是否出現星星
    isTopImageView.hidden = YES;
    if(isTopInt == 1){// isTopInt = 1:出現星星
        
        isTopImageView.hidden = NO;
        
    }
    
    if(statusInt == 0){//使用者送邀請給對方
        
        invitationLabel.layer.borderWidth = 1.5;
        invitationLabel.text = @"Invitation";
        invitationLabel.hidden = NO;
        
    }else if(statusInt == 1){//使用者已跟對方是好友
        
        invitationLabel.layer.borderWidth = 0.0;
        invitationLabel.text = @"···";
        invitationLabel.hidden = NO;
        
    }
    
}


//=====================================================//
// dealloc
//=====================================================//
- (void)dealloc {
    
    // 釋放 photoImageView
    if(photoImageView != nil){
        [photoImageView removeFromSuperview];
        photoImageView = nil;
    }
    
    // 釋放 isTopImageView
    if(isTopImageView != nil){
        [isTopImageView removeFromSuperview];
        isTopImageView = nil;
    }
    
    // 釋放 nameLabel
    if(nameLabel != nil){
        [nameLabel removeFromSuperview];
        nameLabel = nil;
    }
    
    // 釋放 invitationLabel
    if(invitationLabel != nil){
        [invitationLabel removeFromSuperview];
        invitationLabel = nil;
    }
}
@end
