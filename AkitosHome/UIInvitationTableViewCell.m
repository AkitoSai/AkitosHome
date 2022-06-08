//
//  UIInvitationTableViewCell.m
//  AkitosHome
//
//  Created by akito on 2022/6/7.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

#import "UIInvitationTableViewCell.h"

@implementation UIInvitationTableViewCell

@synthesize delegate = _delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        // 取得螢幕的尺寸
        CGSize fullSize = [[UIScreen mainScreen] bounds].size;
        
        // 計算畫面縮放的比例 以寬度375為基準
        zoomSize = fullSize.width/375.0;
        
        // 設定背景色
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
        
        
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
        
        // 自訂cell所有的VIew元件都放進cell的contentView中
        
        //======== 照片UIImageView ========//
        photoImageView =[[UIImageView alloc] initWithFrame:CGRectMake(40*zoomSize, 22*zoomSize, 44*zoomSize, 44*zoomSize)];
        photoImageView.backgroundColor = [UIColor grayColor];
        //photoImageView.backgroundColor = [UIColor colorWithRed:0.9 green:0.6 blue:0.0 alpha:1.0];
        photoImageView.layer.masksToBounds = YES;
        photoImageView.layer.cornerRadius = 22*zoomSize;
        photoImageView.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
        photoImageView.layer.borderWidth = 1.0*zoomSize;
        photoImageView.hidden = NO;
        [self.contentView addSubview:photoImageView];
        //=====================================================//
        
        //======== 姓名Label ========//
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(95*zoomSize, 23*zoomSize, 200*zoomSize, 20*zoomSize)];
        //nameLabel.backgroundColor = [UIColor blackColor];
        //nameLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.6 blue:0.0 alpha:1.0];
        nameLabel.textColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.0];
        nameLabel.text = @"";
        nameLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:18.0f];//字體的大小以及字型
        nameLabel.hidden = NO;
        [self.contentView addSubview:nameLabel];
        //=====================================================//
        
        //======== 邀請中Label ========//
        invitationLabel = [[UILabel alloc] initWithFrame:CGRectMake(95*zoomSize, 43*zoomSize, 200*zoomSize, 30*zoomSize)];
        
        invitationLabel.textColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0];
        invitationLabel.text = @"Could I friend You ? :)";
        invitationLabel.font = [UIFont fontWithName:@"Arial" size:13.0f];//字體的大小以及字型
        invitationLabel.textAlignment = NSTextAlignmentLeft;
        invitationLabel.hidden = NO;
        [self.contentView addSubview:invitationLabel];
        //=====================================================//
        
        //======== 同意加好友 Button ========//
        UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake( 235*zoomSize, 27*zoomSize, 32*zoomSize, 32*zoomSize)];
        agreeButton.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        agreeButton.layer.masksToBounds = YES;
        agreeButton.layer.cornerRadius = 16*zoomSize;
        agreeButton.layer.borderColor =  [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
        agreeButton.layer.borderWidth = 1.5*zoomSize;
        
        agreeButton.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:17.0] ;
        [agreeButton setTitle:@"V" forState: UIControlStateNormal];
        [agreeButton setTitleColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        //agreeButton.center = CGPointMake(50.0 * zoomSize, fullSize.height - (80.0 * zoomSize));
        //agreeButton.layer.position = CGPointMake(self.view.frame.size.width/2, 100);
        agreeButton.tag = 0;
        agreeButton.showsTouchWhenHighlighted = YES;
        [agreeButton addTarget:self action:@selector(agreeInvitation:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:agreeButton];
        agreeButton = nil;
        //=====================================================//
        
        
        //======== 拒絕加好友Button ========//
        UIButton *rejectButton = [[UIButton alloc] initWithFrame:CGRectMake( 280*zoomSize, 27*zoomSize, 32*zoomSize, 32*zoomSize)];
        rejectButton.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        rejectButton.layer.masksToBounds = YES;
        rejectButton.layer.cornerRadius = 16*zoomSize;
        rejectButton.layer.borderColor =  [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0].CGColor;
        rejectButton.layer.borderWidth = 1.5*zoomSize;
        
        rejectButton.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:17.0] ;
        [rejectButton setTitle:@"X" forState: UIControlStateNormal];
        [rejectButton setTitleColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0] forState:UIControlStateNormal];
        //rejectButton.center = CGPointMake(50.0 * zoomSize, fullSize.height - (80.0 * zoomSize));
        //rejectButton.layer.position = CGPointMake(self.view.frame.size.width/2, 100);
        rejectButton.tag = 1;
        rejectButton.showsTouchWhenHighlighted = YES;
        [rejectButton addTarget:self action:@selector(rejectInvitation:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:rejectButton];
        rejectButton = nil;
        //=====================================================//
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    
    return self;
}

//=====================================================//
// 帶入數據
//=====================================================//
- (void)setName:(NSString *)nameString withPid:(NSString *)pidString{
    
    nameLabel.text = nameString;
    
    myPidString = [NSString stringWithString:pidString];
}

//=====================================================//
// 同意成為好友
//=====================================================//
- (IBAction)agreeInvitation:(id)sender {
    [self clickButtonWithIndex:0];
    
}

//=====================================================//
// 不同意成為好友
//=====================================================//
- (IBAction)rejectInvitation:(id)sender {
    [self clickButtonWithIndex:1];
    
}

//=====================================================//
// 點擊按扭
//=====================================================//
-(void)clickButtonWithIndex:(int)_index{
    
    
    if(_delegate != nil){
        
        [_delegate clickButtonWithIndex:(int)_index withPid:myPidString];
        
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
    
    // 釋放 _delegate
    if(_delegate != nil){
        _delegate = nil;
    }
    
}
@end
