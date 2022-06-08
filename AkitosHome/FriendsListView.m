//
//  FriendsListView.m
//  AkitosHome
//
//  Created by akito on 2022/6/3.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

#import "FriendsListView.h"

#import "UIFriendsTableViewCell.h"

#import "Reachability.h"

//(2) 好友列表1
#define URL_1 @"http://34.84.150.189/union/friend1.php"

//(3) 好友列表2
#define URL_2 @"http://34.84.150.189/union/friend2.php"

//(4) 好友列表含邀請列表
#define URL_3 @"http://34.84.150.189/union/friend3.php"

//(5) 無資料邀請/好友列表
#define URL_4 @"http://34.84.150.189/union/friend4.php"

//(6) 好友列表5 18位好友 8位邀請名單
#define URL_5 @"http://34.84.150.189/union/friend5.php"

@implementation FriendsListView

@synthesize myObjCViewController = _myObjCViewController;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    
    // 取得螢幕的尺寸
    CGSize fullSize = [[UIScreen mainScreen] bounds].size;
    
    // 計算畫面縮放的比例 以寬度375為基準
    zoomSize = fullSize.width/375.0;

    // 是否正在輸入收尋關鍵字(展開searchTextField)
    isInputingKeyword = NO;
    
    // 原本的Y座標偏移
    originKeywordOffsetY = frame.origin.y;
    
    // 搜尋時的Y座標偏移
    inputingKeywordOffsetY = 45*zoomSize;
    
    //請求種類判斷用
    activeType = 0;
    
    // 下拉自動更新的偏移值 超過就更新
    reloadScrollOffsetY = -80*zoomSize;
    
    // invitationViewHeight的高度
    invitationViewHeight = 0*zoomSize;
    
    // 頂端topImageView的高度
    topImageViewHeight = 35*zoomSize;
    
    // mySearchTextFieldBackViewHeight的高度
    mySearchTextFieldBackViewHeight = 55*zoomSize;
    
    // myUITableViewHeight的高度
    myUITableViewHeight = self.frame.size.height-mySearchTextFieldBackViewHeight;
    
    // 每一格cell的高度
    cellRowHeight = 90*zoomSize;
    
    
    
    //======== 放置topImageView searchTextField myfriendsTableView的主要View ========//
    friendsListMainView = [[UIView alloc] initWithFrame:CGRectMake( 0.0*zoomSize, 0, self.frame.size.width, 0)];
    friendsListMainView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    friendsListMainView.layer.masksToBounds = YES;
    friendsListMainView.layer.cornerRadius = 12.0*zoomSize;
    friendsListMainView.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    friendsListMainView.layer.borderWidth = 2.0;
    
    [self addSubview:friendsListMainView];
    //=====================================================//
    

    //======== 初始化讀取進度條 ===============//
    myActView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(100*zoomSize, 100*zoomSize, 300*zoomSize, 100*zoomSize)];
    [myActView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    myActView.color = [UIColor blackColor];
    [myActView setCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2)];
       
    [self addSubview:myActView];
    //=====================================================//
    
    
    //======== 設置 好友&聊天切換標題的ImageView ========//
    NSString *topImagPpath = [[NSBundle mainBundle] pathForResource:@"Image/top_img_0" ofType:@"png"];
    //UIImage *topImage = [UIImage imageWithContentsOfFile:topImagPpath];
    UIImageView *topImageView=[[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:topImagPpath]];
    topImageView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:0.0];
    [topImageView setFrame:CGRectMake( 0, invitationViewHeight, self.frame.size.width, topImageViewHeight*2-0.5*zoomSize)];
    //topImageView.backgroundColor = UIColor.grayColor;
    [friendsListMainView addSubview:topImageView];
    topImageView = nil;
    //=====================================================//
    
    
    //======== 設置 無好友名單時顯示的 ImageView ========//
    NSString *midImagPpath = [[NSBundle mainBundle] pathForResource:@"Image/img_union_2" ofType:@"png"];
    //midImagPpath *midImage = [UIImage imageWithContentsOfFile:midImagPpath];
    midImageView=[[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:midImagPpath]];
    
    [midImageView setFrame:CGRectMake( 0, 80*zoomSize, self.frame.size.width, self.frame.size.width)];
    //midImageView.backgroundColor = UIColor.grayColor;
    midImageView.hidden = NO;
    [friendsListMainView addSubview:midImageView];
    //=====================================================//
    
    
    //======== 設置 關鍵字輸入框被景View ========//
    UIView *mySearchTextFieldBackView = [[UIView alloc] initWithFrame:CGRectMake( 0, topImageViewHeight, self.frame.size.width, mySearchTextFieldBackViewHeight)];
    mySearchTextFieldBackView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    [friendsListMainView addSubview:mySearchTextFieldBackView];
    
    
    //======== 搜尋好友關鍵字輸入 TextField ========//
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10*zoomSize, 10*zoomSize, self.frame.size.width-20*zoomSize, 35*zoomSize)];
    searchTextField.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    searchTextField.layer.masksToBounds = YES;
    searchTextField.layer.cornerRadius = 12.0*zoomSize;
    //searchTextField.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    //searchTextField.layer.borderWidth = 2.0;
    
    searchTextField.borderStyle = UITextBorderStyleNone;  //設定UITextBorderStyleNone樣式自由度更高
    searchTextField.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20.0f];  //字體的大小以及字型
    //searchTextField.placeholder = @"Search？";  //設置提示的字
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Search" attributes:
        @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0],
                     NSFontAttributeName:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20.0f]
             }];
    searchTextField.attributedPlaceholder = attrString;
    
    searchTextField.textColor =[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchTextField.returnKeyType = UIReturnKeyDone;
    searchTextField.delegate=self;
    
    //UIImageView *searchTextFieldImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_img_2"]];//初始化UIImageView的物件，並設置圖片
    //searchTextField.leftView=searchTextFieldImage;
    //searchTextField.leftViewMode = UITextFieldViewModeAlways;//圖片出現的時機
    //searchTextFieldImage = nil;
    //searchTextField.background=[UIImage imageNamed:@"back.png"];
    [mySearchTextFieldBackView addSubview:searchTextField];//加入至view中
    //=====================================================//

    
    mySearchTextFieldBackView = nil; //釋放關鍵字輸入框被景View
    //=====================================================//
    
    
    //======== 顯示"放開手指進行更新" 的Label ========//
    reloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0*zoomSize,invitationViewHeight+ topImageViewHeight+mySearchTextFieldBackViewHeight+zoomSize, frame.size.width, 90*zoomSize)];
    //reloadLabel.backgroundColor = [UIColor blackColor];
    //reloadLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.6 blue:0.0 alpha:1.0];
    reloadLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    reloadLabel.text = @"Refresh?";
    reloadLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20.0f];//字體的大小以及字型
    reloadLabel.textAlignment = NSTextAlignmentCenter;
    /*
    if (@available(iOS 14.0, *)) {
        
    } else {

    }*/
    reloadLabel.hidden = YES;
    [friendsListMainView addSubview:reloadLabel];
    //=====================================================//
    
    
    //======== 初期化並放置展示好友名單用的 TableView========//
    myFriendsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, invitationViewHeight+topImageViewHeight+mySearchTextFieldBackViewHeight, self.frame.size.width, myUITableViewHeight)];
    [myFriendsTableView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]];
     
    // 初始化cell的樣式及名稱，告訴UITableView每個cell顯示的樣式，這裡指定只顯示預設(一行文字)
    UIFriendsTableViewCell *friendsTableViewCell = [[UIFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyFriendCell"];
    // 設定Cell名稱、樣式
    [myFriendsTableView registerClass:friendsTableViewCell.class forCellReuseIdentifier:friendsTableViewCell.reuseIdentifier];
     
    myFriendsTableView.rowHeight = cellRowHeight;
    
    // DataSource 設定self，必需寫好對應的function才能取得正確資料
    myFriendsTableView.dataSource = self;
     
    // Delegate 設定self，必需寫好對應的delegate function才能取得正確資訊
    myFriendsTableView.delegate = self;
    myFriendsTableView.allowsSelection = YES;
    myFriendsTableView.hidden = YES;
    myFriendsTableView.tag = 0;
    
    myFriendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 將建立好的tableview加入原先的View
    [friendsListMainView addSubview:myFriendsTableView];
    //=====================================================//
    
    //======== 初期化並放置展示邀請列表用的 TableView ========//
    myInvitationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, myUITableViewHeight)];
    [myInvitationTableView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    myInvitationTableView.layer.masksToBounds = YES;
    myInvitationTableView.layer.cornerRadius = 13.0*zoomSize;
    //myInvitationTableView.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    //myInvitationTableView.layer.borderWidth = 2.0*zoomSize;
    
    // 初始化cell的樣式及名稱，告訴UITableView每個cell顯示的樣式，這裡指定只顯示預設(一行文字)
    UIInvitationTableViewCell *invitationtableViewCell = [[UIInvitationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyInvitationCell"];
    // 設定Cell名稱、樣式
    [myInvitationTableView registerClass:invitationtableViewCell.class forCellReuseIdentifier:invitationtableViewCell.reuseIdentifier];
     
    myInvitationTableView.rowHeight = cellRowHeight;
    
    // DataSource 設定self，必需寫好對應的function才能取得正確資料
    myInvitationTableView.dataSource = self;
     
    // Delegate 設定self，必需寫好對應的delegate function才能取得正確資訊
    myInvitationTableView.delegate = self;
    myInvitationTableView.allowsSelection = NO;
    myInvitationTableView.hidden = NO;
    myInvitationTableView.tag = 1;
    
    myInvitationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:myInvitationTableView];
    //=====================================================//
    
    
    
    //======== 設置邀請列表用的開合控制Button ========//
    myInvitationTableViewOpenButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110*zoomSize, 26*zoomSize)];
    myInvitationTableViewOpenButton.backgroundColor =[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    //myInvitationTableViewOpenButton.layer.masksToBounds = YES;
    myInvitationTableViewOpenButton.layer.cornerRadius = 13.0*zoomSize;
    myInvitationTableViewOpenButton.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    myInvitationTableViewOpenButton.layer.borderWidth = 2.0*zoomSize;
    
    [myInvitationTableViewOpenButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    myInvitationTableViewOpenButton.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:15.0] ;
    [myInvitationTableViewOpenButton setTitle:@"↓ OPEN ↓" forState: UIControlStateNormal];
    [myInvitationTableViewOpenButton setTitleColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0] forState:UIControlStateNormal];
    //[myInvitationTableViewOpenButton setTitle:@"^OPEN^" forState: UIControlStateHighlighted];
    //[myInvitationTableViewOpenButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    myInvitationTableViewOpenButton.center = CGPointMake(self.frame.size.width/2, 0.0 * zoomSize);
    //myInvitationTableViewOpenButton.layer.position = CGPointMake(self.view.frame.size.width/2, 100);
    myInvitationTableViewOpenButton.tag = 0;
    myInvitationTableViewOpenButton.showsTouchWhenHighlighted = YES;
    [myInvitationTableViewOpenButton addTarget:self action:@selector(openCloseMyInvitationTableView:) forControlEvents:UIControlEventTouchUpInside];
    myInvitationTableViewOpenButton.hidden = YES;
    [self addSubview:myInvitationTableViewOpenButton];
    //myInvitationTableViewOpenButton = nil;
    //=====================================================//
    
    
    // 初期化儲存邀請列表用用的 Array
    invitationArray = [[NSMutableArray alloc] init];
    
    // 初期化儲存好友名單用的 Array
    friendsArray = [[NSMutableArray alloc] init];
    
    
    // 初期化放入連線用 DataRequestUnit 的 DataRequestUnitsArray
    dataRequestUnitsArray = [[NSMutableArray alloc] init];
    for(int i=0;i<2;i++){
        DataRequestUnit *dataRequestUnit = [[DataRequestUnit alloc] init];
        
        dataRequestUnit.delegate = self;
        
        [dataRequestUnitsArray addObject:dataRequestUnit];
        
        dataRequestUnit = nil;
    }
    
    return self;
}


//=====================================================//
//  myInvitationTableViewOpenButton 按下時執行的切換狀態函式
//=====================================================//
- (IBAction)openCloseMyInvitationTableView:(id)sender {
    
    if(myInvitationTableViewOpenButton.tag == 0){
        [self changeMyInvitationTableViewOpenButtonStatus:1];
    }else{
        [self changeMyInvitationTableViewOpenButtonStatus:0];
    }
    
    [self reSize];
    
}

//=====================================================//
// 切換縮合邀請列表
//=====================================================//
- (void)changeMyInvitationTableViewOpenButtonStatus:(int)status {
    
    if(status == 1){
        [myInvitationTableViewOpenButton setTitle:@"↑ CLOSE ↑" forState: UIControlStateNormal];
        myInvitationTableViewOpenButton.tag = 1;
    }else{
        [myInvitationTableViewOpenButton setTitle:@"↓ OPEN ↓" forState: UIControlStateNormal];
        myInvitationTableViewOpenButton.tag = 0;
    }
    
    [self reSize];
    
}

//=====================================================//
// 調整版面size
// 邀請列表支援縮合操作
//=====================================================//
- (void)reSize{
    
    
    if(invitationArray !=nil && friendsArray != nil){
        if(invitationArray.count<=0 && friendsArray.count <= 0){
            
            //好友名單跟邀請列表用都沒有人,則顯示無好友名單時顯示的 ImageView
            if(midImageView != nil){
                midImageView.hidden = NO;
            }
            
            
            if(searchTextField != nil){
                searchTextField.hidden = YES;
            }
            
            if(myFriendsTableView != nil){
                myFriendsTableView.hidden = YES;
            }
            
            if(myInvitationTableView != nil){
                myInvitationTableView.hidden = YES;
            }
            
        }else{
            
            //好友名單或邀請列表有人,則隱藏無好友名單時顯示的 ImageView
            if(midImageView != nil){
                midImageView.hidden = YES;
            }
            
            if(invitationArray>0){
                
                if(myInvitationTableView != nil){
                    myInvitationTableView.hidden = NO;
                }
                
            }
            
            if(friendsArray>0){
                
                if(searchTextField != nil){
                    searchTextField.hidden = NO;
                }
                
                if(myFriendsTableView != nil){
                    myFriendsTableView.hidden = NO;
                }
                
            }
        }
    }

    //先計油是否有等待邀請的名單算出myInvitationTableView的展開高度
    double myInvitationTableViewHeight = 0.0;
    myInvitationTableViewOpenButton.hidden = YES;
    myInvitationTableView.hidden = YES;
    if(invitationArray !=nil){
        
        if(!isInputingKeyword){
            
            [myInvitationTableView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
            myInvitationTableView.hidden = NO;
            
            if(invitationArray.count > 2){
                
                //邀請列表超過3人時,展開會影響好友列表的輸入搜尋框用戶體驗,試做蓋屏方式的全銀幕展開方式加上收合鍵
                if(myInvitationTableViewOpenButton.tag == 0){
                    //縮起來的模式
                    myInvitationTableViewHeight = cellRowHeight*1;
                    
                    if(myInvitationTableView != nil){
                        [myInvitationTableView setFrame:CGRectMake(myInvitationTableView.frame.origin.x,0, myInvitationTableView.frame.size.width, myInvitationTableViewHeight)];
                    }
                    
                }else{
                    
                    //蓋掉全屏幕
                    [myInvitationTableView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]];
                    
                    //展開的模式
                    myInvitationTableViewHeight = cellRowHeight*(int)invitationArray.count;
                    
                    if(myInvitationTableViewHeight > self.frame.size.height){
                        myInvitationTableViewHeight = self.frame.size.height;
                    }
                    
                    if(myInvitationTableView != nil){
                        [myInvitationTableView setFrame:CGRectMake(myInvitationTableView.frame.origin.x,0, myInvitationTableView.frame.size.width, self.frame.size.height)];
                    }
                    
                }
                
                myInvitationTableViewOpenButton.hidden = NO;
                
            }else if(invitationArray.count > 1){
                
                //邀請列表小於3人時,展開採採用將好友列表往下方推的模式實現
                
                if(myInvitationTableViewOpenButton.tag == 0){
                    //縮起來的模式
                    myInvitationTableViewHeight = cellRowHeight*1;
                    
                }else{
                    //展開的模式
                    myInvitationTableViewHeight = cellRowHeight*(int)invitationArray.count;
                }
                
                if(myInvitationTableView != nil){
                    [myInvitationTableView setFrame:CGRectMake(myInvitationTableView.frame.origin.x,0, myInvitationTableView.frame.size.width, myInvitationTableViewHeight)];
                }
                
                myInvitationTableViewOpenButton.hidden = NO;
                
            }else if(invitationArray.count > 0){
                
                //邀請列表只有1人時,無縮合模式,隱藏縮合按鈕
                
                myInvitationTableViewHeight = cellRowHeight*(int)invitationArray.count;
                
                if(myInvitationTableView != nil){
                    [myInvitationTableView setFrame:CGRectMake(myInvitationTableView.frame.origin.x,0, myInvitationTableView.frame.size.width, myInvitationTableViewHeight)];
                }
                
            }else{
                
                myInvitationTableView.hidden = YES;
                
            }
            
            myInvitationTableViewOpenButton.center = CGPointMake(myInvitationTableViewOpenButton.center.x, myInvitationTableViewHeight-8*zoomSize);
            
            
        }else{
            
            //輸入狀態則隱藏邀請列表
            
        }
        
    }
    
    
    if(friendsListMainView != nil){
        
        double friendsListMainViewHeight = self.frame.size.height - myInvitationTableViewHeight;
        
        [friendsListMainView setFrame:CGRectMake(friendsListMainView.frame.origin.x,myInvitationTableViewHeight, friendsListMainView.frame.size.width, friendsListMainViewHeight)];
        
        
        // 調整 myFriendsTableView 的高度
        double myFriendsTableViewHeight = friendsListMainView.frame.size.height - invitationViewHeight-topImageViewHeight-mySearchTextFieldBackViewHeight;
        if(myFriendsTableViewHeight < 0){
            myFriendsTableViewHeight = 0;
        }
        if(myFriendsTableView != nil){
            [myFriendsTableView setFrame:CGRectMake(0,myFriendsTableView.frame.origin.y, myFriendsTableView.frame.size.width, myFriendsTableViewHeight)];
        }
        
    }
    
    
}


//=====================================================//
// 請求時需執行的動作
//=====================================================//
- (void)doRequestWithType:(int)_type{
    
    //先停止讀取進度條
    if(myActView != nil){
        [myActView stopAnimating];
    }
    
    //確認網路連線狀態
    if(![Reachability reachabilityWithHostName:@"www.apple.com"].currentReachabilityStatus){
        if(_myObjCViewController != nil){
            [_myObjCViewController showAlertWithMessage:@"請確認網路連線狀態"];
        }
        return;
    }
    
    if((_type >= 0) & (_type < 4)){
        
        // 清空儲存好友名單用的 Array 準備請求新的
        if(friendsArray != nil){
            @synchronized (friendsArray) {
                [friendsArray removeAllObjects];
            }
        }
        
        // 清空儲存邀請列表用的 Array 準備請求新的
        if(invitationArray != nil){
            @synchronized (invitationArray) {
                [invitationArray removeAllObjects];
            }
        }
        
        // 初期化放入連線用 DataRequestUnit 的 DataRequestUnitsArray
        if(dataRequestUnitsArray != nil){
        
            for(int i=0;i<dataRequestUnitsArray.count;i++){
                
                DataRequestUnit *dataRequestUnit = [dataRequestUnitsArray objectAtIndex:i];
                
                if(dataRequestUnit != nil){
                    
                    if(myActView != nil){
                        [myActView startAnimating];
                    }
                    
                    if(i==0){
                        if(_type == 0){
                            //(4) - (3) 好友列表含邀請:request API 2-(4)
                            [dataRequestUnit doRequestWithUel: URL_3];
                        }else if(_type == 1){
                            //(4)- (2) 只有好友列表:request API 2-(2)
                            [dataRequestUnit doRequestWithUel: URL_1];
                            
                        }else if(_type == 2){
                            //(4)- (1) 無好友畫面:request API 2-(5)
                            [dataRequestUnit doRequestWithUel: URL_4];
                            
                        }else if(_type == 3){
                            //(4)- (1) 無好友畫面:request API 2-(5)
                            [dataRequestUnit doRequestWithUel: URL_5];
                            
                        }
                            
                    }else{
                        if(i==1 &&_type == 1){
                            //(4)- (2) 只有好友列表:request API 2-(3)
                            [dataRequestUnit doRequestWithUel: URL_2];
                        }else{
                            [dataRequestUnit reset];
                        }
                    }
                    
                    dataRequestUnit = nil;
                    
                }
                
            }
                
        }
        
        activeType = _type;
            
    }else{
        
        activeType = -1;
        
        
    }
    
    
}

 

#pragma mark DataRequestUnitDelegate
//=====================================================//
// DataRequestUnit完成請求或請求失敗 後執行
//=====================================================//
-(void)dataRequestTask:(NSData *)data task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
    if(myActView != nil){
        [myActView stopAnimating];
    }
    

    
    
    NSString *errorMessagr = @"";
    
    if(error != nil){
        
        errorMessagr = @"連線發生錯誤";
        
    }else{
        
        //從data解析出JSON字串
        NSString *json_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *utf8data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
        
        json_str = nil;
        
        NSError *jsonDecoeError=nil;
        // JSON Data分析成Dictionary
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:utf8data options:NSJSONReadingAllowFragments error:&jsonDecoeError];
        
       if (!jsonObject) {
           
           //jsonObject解析錯誤
           errorMessagr = @"JSON解析錯誤";
           
       } else {
           
           //jsonObject解析正確
           
           if(jsonObject.count >=0){
               
               NSArray *items = [jsonObject objectForKey:@"response"];
               
               if(items != nil){
                   
                   
                   if(friendsArray != nil){
                       
                       for(NSDictionary *item in items) {
                           
                           if(item != nil){
                               
                               // 儲存比對後是否要追加的bool值,同樣pid日期新的則追加
                               bool addF = YES;
                               
                               for(int i=0;i<friendsArray.count;i++){
                                   
                                   NSDictionary *friendDictionary = [friendsArray objectAtIndex:i];
                                   
                                   if(friendDictionary != nil){
                                       
                                       //同時request兩個資料,將兩個資料源整合為列表,若重覆pid資料則取updateDate較新的那一筆
                                       if([item objectForKey:@"pid"] == [friendDictionary objectForKey:@"pid"]){
                                           
                                           NSLog(@"item pid= %@,%@",[item objectForKey:@"pid"],[friendDictionary objectForKey:@"pid"]);
                                           NSLog(@"item samesame= %@,%@",[item objectForKey:@"name"],[friendDictionary objectForKey:@"name"]);
                                           NSLog(@"item samesame= %@,%@",[item objectForKey:@"updateDate"],[friendDictionary objectForKey:@"updateDate"]);
                                           
                                           NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                                               //获取字符串中的数字
                                               
                                           NSString *updateDateString = [[[friendDictionary objectForKey:@"updateDate"] componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
                                           NSString *newUpdateDateString = [[[item objectForKey:@"updateDate"] componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
                                           NSLog(@"newUpdateDateString= %@,updateDateString= %@",newUpdateDateString,updateDateString);
                                           
                                           
                                           
                                           NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                                           [formatter setDateFormat:@"yyyyMMdd"];
                                           //NSString转NSDate
                                           NSDate *updateDate=[formatter dateFromString:updateDateString];
                                           NSDate *newUpdateDate=[formatter dateFromString:newUpdateDateString];
                                           
                                           
                                           NSComparisonResult result = [newUpdateDate compare:updateDate];
                                            
                                               if (result == NSOrderedDescending) {
                                                   
                                                   //若新的一筆的時間比較晚 則先刪掉舊的(加入新的
                                                   NSLog(@"change newUpdateDateString= %@,updateDateString= %@",newUpdateDateString,updateDateString);
                                                   
                                                   @synchronized (friendsArray) {
                                                       [friendsArray removeObjectAtIndex:i];
                                                   }
                                                   
                                                   i -= 1;
                                                   addF = YES;
                                                   
                                                   NSLog(@"YES Add");
                                               }else{
                                                   
                                                   NSLog(@"NO Add");
                                                   addF = NO;
                                               }
                                           
                                       }
                                       
                                       friendDictionary = nil;
                                       
                                   }
                                   
                               }
                               
                               if(addF){
                                   
                                   // 判定為追加則增加一筆新的
                                   @synchronized (friendsArray) {
                                       [friendsArray addObject:item];
                                   }
                               }
                           }
                           
                       }
                           

                   }
                   
               
               }
           }
           
       }
    }
    
    
       
    if(friendsArray != nil && invitationArray != nil){
        
        @synchronized (invitationArray) {
            [invitationArray removeAllObjects];
        }
        
        for(int i=0;i<friendsArray.count;i++){
            
            NSDictionary *friendDictionary = [friendsArray objectAtIndex:i];
            
            if(friendDictionary != nil){
                
                NSString *statusString = [NSString stringWithString: [friendDictionary objectForKey:@"status"]];
                
                int statusInt = [statusString intValue];
                
                if(statusInt == 2){//對方送邀請給使用者
                    
                    @synchronized (friendsArray) {
                        [friendsArray removeObjectAtIndex:i];
                    }
                    @synchronized (invitationArray){
                        [invitationArray addObject:friendDictionary];
                    }
                    
                    i -= 1;
                }
                
                friendDictionary = nil;
           
            }
        }
    }
    
    
    if(myFriendsTableView != nil){
        
        //搜尋關鍵字並從朋友名單中查找並重新整理 myFriendsTableView
        [self checkKeywordAndReloadDataMyFriendsTableView];
    
    }

    if(_myObjCViewController != nil && errorMessagr != nil){
        if(errorMessagr.length >0){
            [_myObjCViewController showAlertWithMessage:errorMessagr];
        }
    }
    
}


//=====================================================//
// 搜尋關鍵字並從朋友名單中查找並重新整理 myFriendsTableView
//=====================================================//
- (void)checkKeywordAndReloadDataMyFriendsTableView{

    if(friendsArray != nil && searchTextField != nil){
        
        int insertIndex = 0;
        for(int i=0;i<friendsArray.count;i++){
            
            NSDictionary *friendDictionary = [friendsArray objectAtIndex:i];
            
            if(friendDictionary != nil){
                
                NSString *userNameString = [NSString stringWithString:[friendDictionary objectForKey:@"name"]];
                
                if ([userNameString rangeOfString:searchTextField.text].location != NSNotFound) {
                        NSLog(@"%@包含 %@",userNameString,searchTextField.text);
                    
                    //找到包含的關鍵字則往前擺放
                    @synchronized (friendsArray) {
                        [friendsArray removeObjectAtIndex:i];
                        [friendsArray insertObject:friendDictionary atIndex:insertIndex];
                    }
                    
                    insertIndex += 1;
                    
                } else {
                        NSLog(@"%@不包含 %@",userNameString,searchTextField.text);
                }
                
                friendDictionary= nil;
            }
        }
        
        
        if(myFriendsTableView != nil){
            
            //重新做myFriendsTableView 的 reloadData
            [myFriendsTableView reloadData];
            
            /*
            //子線程
            dispatch_queue_t delayQueue = dispatch_queue_create("rx.queue.delay", nil);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)),
                delayQueue, ^{
                    [self->myFriendsTableView reloadData];
                });
            */
            /*
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0/2 * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        //[self delayAction];
                        [self->myFriendsTableView reloadData];
                    });
             */
            
            //搜尋關鍵字有結果 則重新讀取myUITableView
            if(insertIndex >0){
                
                [myFriendsTableView setContentOffset:CGPointMake(0 * zoomSize, 0 * zoomSize)  animated:NO];
                   
            }
        }
        
        if(myInvitationTableView != nil){
            
            //重新做myInvitationTableView 的 reloadData
            [myInvitationTableView reloadData];
            
        }
        
    }
    
    // 調整版面size
    [self reSize];

}

#pragma mark UIInvitationTableViewCellDelegate
//=====================================================//
// UIInvitationTableViewCell回傳  0:追加至好友名單 1:刪除
//=====================================================//
-(void)clickButtonWithIndex:(int)_index withPid:(NSString *)pidString{
    
    if((_index<0) || (_index>1)){
        return;
    }
    
    NSLog(@"index %d",_index);
    
    if(invitationArray != nil){
        
        for(int i=0;i<invitationArray.count;i++){
            
            NSDictionary *invitationDictionary = [invitationArray objectAtIndex:i];
            
            if(invitationDictionary != nil){
                
                if(pidString == [invitationDictionary objectForKey:@"pid"]){
                    
                    NSLog(@"item samesame= %@,%@",pidString,[invitationDictionary objectForKey:@"pid"]);
                
                    [invitationArray removeObjectAtIndex:i];
                    
                    if(_index == 0){
                        
                        //_index = 0:追加至好友名單
                        if(friendsArray != nil){
                            [friendsArray insertObject:invitationDictionary atIndex:0];
                        }
                    }
                    
                    i -= 1;
                    
                }
                
                invitationDictionary = nil;
                  
            }
            
            
        }
        
    }
    
    // 搜尋關鍵字並從朋友名單中查找
    [self checkKeywordAndReloadDataMyFriendsTableView];
    
}
#pragma mark UITableViewDelegate
//點選cell後會呼叫此function告知哪個cell已經被選擇(0開始)
//=====================================================//
// UITableViewDelegate:     didSelectRowAtIndexPath
//=====================================================//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}
 
//返回總共有多少cell筆數
//=====================================================//
// UITableViewDelegate:     numberOfRowsInSection
//=====================================================//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView.tag == 0){
        
        //0: 好友名單 tableView
        
        myFriendsTableView.hidden = YES;
        //self.hidden = YES;
        
        if(friendsArray != nil){
            
            if(friendsArray.count > 0){
                
                myFriendsTableView.hidden = NO;
                //self.hidden = NO;
                return friendsArray.count;
                
            }else{
                
            }
            
        }
        
    }else  if(tableView.tag == 1){
        
        //1: 邀請列表 tableView
        
        myInvitationTableView.hidden = YES;
        //self.hidden = YES;
        
        if(invitationArray != nil){
            
            if(invitationArray.count > 0){
                
                myInvitationTableView.hidden = NO;
                //self.hidden = NO;
                return invitationArray.count;
                
            }else{
                
            }
            
        }
    }
    
    return 0;
}
 
//根據cellForRowAtIndexPath來取得目前TableView需要哪個cell的資料
//=====================================================//
// UITableViewDelegate:     UITableViewDelegate
//=====================================================//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    if(tableView.tag == 0){
        
        //0: 好友名單 tableView
        
        // 取得tableView目前使用的cell
        UIFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyFriendCell" forIndexPath: indexPath];
     
        // 將指定資料顯示於tableview提供的text
        
        if(friendsArray != nil){
            
            if(indexPath.row < friendsArray.count){
                
                NSDictionary *friendDictionary = [friendsArray objectAtIndex:indexPath.row];
                
                if(friendDictionary != nil){
                    
                    NSString *nameString = [NSString stringWithString: [friendDictionary objectForKey:@"name"]];
                    NSString *statusString = [NSString stringWithString: [friendDictionary objectForKey:@"status"]];
                    NSString *isTopString = [NSString stringWithString: [friendDictionary objectForKey:@"isTop"]];
                    
                    
                    [cell setName:nameString status:[statusString intValue] isTop:[isTopString intValue] setSearch:searchTextField.text];
                    
                    friendDictionary = nil;
                      
                }
                
            }
            
        }
        
        return cell;
     
    }else if(tableView.tag == 1){
        
        //1: 邀請列表 tableView
        
        // 取得tableView目前使用的cell
        UIInvitationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInvitationCell" forIndexPath: indexPath];
        cell.delegate = self;
        
        if(invitationArray != nil){
            
            if(indexPath.row < invitationArray.count){
                
                NSDictionary *invitationDictionary = [invitationArray objectAtIndex:indexPath.row];
                
                if(invitationDictionary != nil){
                    
                    NSString *nameString = [NSString stringWithString: [invitationDictionary objectForKey:@"name"]];
                    NSString *pidString = [NSString stringWithString: [invitationDictionary objectForKey:@"pid"]];
                    //NSString *isTopString = [NSString stringWithString: [invitationDictionary objectForKey:@"isTop"]];
                    
                    [cell setName:nameString withPid:pidString];
                    
                     invitationDictionary = nil;
                      
                }
                
                
            }
            
        }
        
        return cell;
        
    }
     
    
    return nil;
}


#pragma mark UITextFieldDelegate
//按下textField會觸發
//=====================================================
// UITextFieldDelegate:     textFieldDidBeginEditing
//=====================================================//
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    isInputingKeyword = YES;
    [self reSize];
    
    //搜尋時的Y座標偏移跳回最上方
    [myFriendsTableView setContentOffset:CGPointMake(0, 0)  animated:NO];
    

}

//按下"clearButtonMode"的按鈕會觸發
//=====================================================//
// UITextFieldDelegate:     textFieldShouldClear
//=====================================================//
- (BOOL)textFieldShouldClear:(UITextField *)textField{

   NSLog(@"clear");

   return YES;

}

//結束編輯時會觸發，傳回BOOL值，可在編輯模式中確定是否要離開編輯模式
//=====================================================//
// UITextFieldDelegate:     textFieldShouldEndEditing
//=====================================================//
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    return YES; //return NO 就會一直在編輯模式

}

//按下Return鍵的反應
//=====================================================//
// UITextFieldDelegate:     textFieldShouldReturn
//=====================================================//
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    
    isInputingKeyword = NO;
    [self reSize];
    [self setFrame:CGRectMake( self.frame.origin.x, originKeywordOffsetY, self.frame.size.width, self.frame.size.height)];
    
    
    //搜尋時的Y座標偏移跳回最上方
    [myFriendsTableView setContentOffset:CGPointMake(0, 0)  animated:YES];
    
    //縮起鍵盤
    [textField resignFirstResponder];
    
   return YES;

}

//傳回BOOL值，指定是否循序內文字段編輯
//=====================================================//
// UITextFieldDelegate:     textFieldShouldBeginEditing
//=====================================================//
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    return YES;

}


//=====================================================//
// UITextFieldDelegate:     shouldChangeCharactersInRange
//=====================================================//
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    /*
    //限制使用者只能輸入的字串
   NSCharacterSet *cs;

    //cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum]invertedSet];//kAlphaNum要先定義才能使用，限定可出現的字符

    //NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@"="];//不再限定範圍內又可以出現的字符

    //BOOL canChange = [string isEqualToString:filtered];

    //return canChange;
    return YES;
    */
    
    //限制使用者能輸入的總數
    //可限定哪些字元可超過 return YES 就是可以輸入文字
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];//取得輸入框內容 用於計算輸入框的總數

    NSLog(@"over(9%@",toBeString);
    if ([toBeString length] > 10) { //限制10個字

        //your_textfield_1 = [toBeString substringToIndex:10];

            
        return NO;
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                // 搜尋關鍵字並從朋友名單中查找
                [self checkKeywordAndReloadDataMyFriendsTableView];
                
            });

    return YES;

}



#pragma mark UIScrollViewDelegate
//=====================================================//
// UIScrollViewDelegate scrollViewDidScroll
//=====================================================//
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //NSLog(@" scrollViewDidScroll tag = %d",scrollView.tag);
    
    if(myFriendsTableView.contentOffset.y < reloadScrollOffsetY){
        reloadLabel.hidden = NO;
    }else{
        reloadLabel.hidden = YES;
    }
    
    /*
    if (scrollView.frame.origin.y == 0) {
        _isShowImageView = NO;
    }else if (scrollView.frame.origin.y == 300){
        _isShowImageView = YES;
    }
    CGRect tempRect = scrollView.frame;
    if (_isShowImageView) {
        //向上滑還是向下滑
        if (scrollView.contentOffset.y > _orientation) {
            _isMoveWithContentSize = YES;
        }else{
            //只要tableView的位置在0-300之間就跟着contentSize滑動
            if (scrollView.frame.origin.y < 0 || scrollView.frame.origin.y > 300) {
                _isMoveWithContentSize = NO;
            }
        }
    }else{
        if (scrollView.contentOffset.y > _orientation || scrollView.contentOffset.y > 0) {
            if (scrollView.frame.origin.y < 0 || scrollView.frame.origin.y > 300) {
                _isMoveWithContentSize = NO;
            }
        }else{
                _isMoveWithContentSize = YES;
        }
    }
    if (_isDownInertia) {
        _isMoveWithContentSize = NO;
    }
    //根據contentSize的改變來改變scollView的frame,同時將contentSize置爲0(感覺滑動整個scrollView)
    if (_isMoveWithContentSize) {
        tempRect.origin.y = scrollView.frame.origin.y - scrollView.contentOffset.y;
        scrollView.frame = tempRect;
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    */
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    reloadLabel.hidden = YES;
    if(myFriendsTableView.contentOffset.y < reloadScrollOffsetY){
        [self doRequestWithType:activeType];
    }
    /*
    //velocity:(慣性)速度，有正負，可以判斷向上向下滑動
    NSLog(@"~~~~~~%@",NSStringFromCGPoint(velocity));
    NSLog(@"---%@ +++%@",NSStringFromCGPoint(scrollView.contentOffset),NSStringFromCGPoint(*targetContentOffset));
    if (!_isShowImageView && velocity.y < 0) {
        _isDownInertia = YES;
    }
    if (_isShowImageView && velocity.y > 0) {
        //防止慣性滑動
        *targetContentOffset = scrollView.contentOffset;
    }
    __block CGRect rect = scrollView.frame;
    [UIView transitionWithView:scrollView duration:0.2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (_isShowImageView) {
            if (scrollView.frame.origin.y < _startFrame.origin.y * 0.9) {
                //tableView移動到頂部
                rect.origin.y = 0.0;
                scrollView.frame = rect;
            }else{
                //tableView回到原位置(即顯示背景圖片的位置)
                rect.origin.y = _startFrame.origin.y;
                scrollView.frame = rect;
            }
        }else{
            if (scrollView.frame.origin.y < _startFrame.origin.y * 0.1) {
                //tableView移動到頂部
                rect.origin.y = 0.0;
                scrollView.frame = rect;
            }else{
                //tableView回到原位置(即顯示背景圖片的位置)
                rect.origin.y = _startFrame.origin.y;
                scrollView.frame = rect;
            }
        }
    }
     */
}

//=====================================================//
// dealloc
//=====================================================//
- (void)dealloc {
    
    
    // 釋放 myInvitationTableViewOpenButton
    if(myInvitationTableViewOpenButton != nil){
        [myInvitationTableViewOpenButton removeFromSuperview];
        myInvitationTableViewOpenButton = nil;
    }
    
    // 釋放 myActView
    if(myActView != nil){
        [myActView stopAnimating];
        [myActView removeFromSuperview];
        myActView = nil;
    }
    
    // 釋放 myInvitationTableView
    if(myInvitationTableView != nil){
        [myInvitationTableView removeFromSuperview];
        myInvitationTableView = nil;
    }
    
    // 釋放 searchTextField
    if(searchTextField != nil){
        [searchTextField removeFromSuperview];
        searchTextField = nil;
    }
    
    // 釋放 reloadLabel
    if(reloadLabel != nil){
        [reloadLabel removeFromSuperview];
        reloadLabel = nil;
    }
    
    // 釋放 myFriendsTableView
    if(myFriendsTableView != nil){
        [myFriendsTableView removeFromSuperview];
        myFriendsTableView = nil;
    }
    
    // 釋放 midImageView
    if(midImageView != nil){
        [midImageView removeFromSuperview];
        midImageView = nil;
    }
    
    // 釋放 friendsListMainView
    if(friendsListMainView != nil){
        [friendsListMainView removeFromSuperview];
        friendsListMainView = nil;
    }
    
    // 釋放 放入連線用 DataRequestUnit 的 DataRequestUnitsArray
    if(dataRequestUnitsArray != nil){
    
        for(int i=0;i<dataRequestUnitsArray.count;i++){
            DataRequestUnit *dataRequestUnit = [dataRequestUnitsArray objectAtIndex:i];
            
            if(dataRequestUnit != nil){
                [dataRequestUnit reset];
                dataRequestUnit = nil;
            }
        }
        [dataRequestUnitsArray removeAllObjects];
        dataRequestUnitsArray = nil;
    }
    
    // 釋放 invitationArray
    if(invitationArray != nil){
        [invitationArray removeAllObjects];
        invitationArray = nil;
    }

    // 釋放 friendsArray
    if(friendsArray != nil){
        [friendsArray removeAllObjects];
        friendsArray = nil;
    }
    
}

@end
