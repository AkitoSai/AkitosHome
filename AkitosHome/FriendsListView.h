//
//  FriendsListView.h
//  AkitosHome
//
//  Created by akito on 2022/6/3.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ObjCViewController.h"
#import "DataRequestUnit.h"
#import "UIInvitationTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ObjCViewController;

@interface FriendsListView : UIView<UIInvitationTableViewCellDelegate,NSURLSessionDataDelegate,DataRequestUnitDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    
    // View 縮放的比例 預設為 iPhone X 寬度 375.0 為基準
    double zoomSize;
    
    NSString *nowRequestUrlString;
    
    // 展示邀請列表用的 TableView
    UITableView *myInvitationTableView;
    
    // 邀請列表用的開合控制 Button
    UIButton *myInvitationTableViewOpenButton;
    
    // 放置topImageView searchTextField myfriendsTableView的主要View
    UIView *friendsListMainView;
    
    // 搜尋好友關鍵字輸入 TextField
    UITextField *searchTextField;
    
    // 無好友名單時顯示的 ImageView
    UIImageView *midImageView;
    
    // 展示好友名單的 TableView
    UITableView *myFriendsTableView;

    // 顯示"放開手指進行更新" 的Label
    UILabel *reloadLabel;
    
    // 讀取進度條
    UIActivityIndicatorView *myActView;
    
    // 儲存邀請列表用的 Array
    NSMutableArray *invitationArray;

    // 儲存好友名單用的 Array
    NSMutableArray *friendsArray;
    
    // 放入連線用 DataRequestUnit 的 DataRequestUnitsArray
    NSMutableArray *dataRequestUnitsArray;
    
    // 是否正在輸入收尋關鍵字(展開searchTextField)
    bool isInputingKeyword;
    
    // 原本的Y座標偏移
    double originKeywordOffsetY;
    
    // 搜尋時的Y座標偏移
    double inputingKeywordOffsetY;

    // 請求種類判斷用
    int activeType;

    // 下拉自動更新的偏移值 超過就更新
    int reloadScrollOffsetY;
    
    // invitationView 的高度
    double invitationViewHeight;
    
    // 頂端 topImageView 的高度
    double topImageViewHeight;
    
    // mySearchTextFieldBackView 的高度
    double mySearchTextFieldBackViewHeight;
    
    // myUITableView 的高度
    int myUITableViewHeight;

    // 每一格cell的高度
    int cellRowHeight;
    
}

// 上層ViewController
@property (nonatomic, weak) ObjCViewController *myObjCViewController;

// 請求時需執行的動作
- (void)doRequestWithType:(int)_type;

@end

NS_ASSUME_NONNULL_END
