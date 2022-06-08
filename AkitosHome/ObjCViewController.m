//
//  ObjCViewController.m
//  AkitosHome
//
//  Created by akito on 2022/6/3.
//  Copyright © 2022 蔡 易達. All rights reserved.
//
#import "AkitosHome-Swift.h"

#import "ObjCViewController.h"


@implementation ObjCViewController

@synthesize myMainViewController = _myMainViewController;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    // 取得螢幕的尺寸
    CGSize fullSize = [[UIScreen mainScreen] bounds].size;
    
    // 計算畫面縮放的比例 以寬度375為基準
    zoomSize = fullSize.width/375.0;
    
    // 設定背景色
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    
    // 從畫面頂端偏移的Y的高度
    viewTopOffsetY = 0*zoomSize;
    
    // 頂端topBarImageViewHeight的高度
    topBarImageViewHeight = 85*zoomSize;
    
    // myUserUnitView的高度
    myUserUnitViewHeight = 80*zoomSize;
    
    // 底端topImageView的高度
    bottomImageViewHeight = 75*zoomSize;
    

    //======== 設置 backImageView ========//
    NSString *backImagePpath = [[NSBundle mainBundle] pathForResource:@"Image/img_union_back" ofType:@"jpeg"];
    //UIImage *topBarImagPpath = [UIImage imageWithContentsOfFile:backImagePpath];
    UIImageView *backImageView=[[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:backImagePpath]];
    [backImageView setFrame:CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    [self.view addSubview:backImageView];
    backImageView = nil;
    //=====================================================//
    
    //======== 設置 myUserUnitView ========//
    myUserUnitView = [[UserUnitView alloc] initWithFrame:CGRectMake( 0, viewTopOffsetY+topBarImageViewHeight, self.view.frame.size.width, myUserUnitViewHeight)];
    myUserUnitView.myObjCViewController = self;
    [self.view addSubview:myUserUnitView];
    //=====================================================//
    
    //======== 設置  myFriendsListView ========//
    myFriendsListView = [[FriendsListView alloc] initWithFrame:CGRectMake( 20*zoomSize, viewTopOffsetY+topBarImageViewHeight+myUserUnitViewHeight, myUserUnitView.frame.size.width-40*zoomSize, self.view.frame.size.height-viewTopOffsetY-topBarImageViewHeight-myUserUnitViewHeight-bottomImageViewHeight+15*zoomSize)];
    //myFriendsListView.backgroundColor = [UIColor yellowColor];
    myFriendsListView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    myFriendsListView.myObjCViewController = self;
    [self.view addSubview:myFriendsListView];
    //=====================================================//
    /*
    //======== 設置 topBarImageView ========//
    NSString *topBarImagePpath = [[NSBundle mainBundle] pathForResource:@"Image/img_union_1" ofType:@"png"];
    //UIImage *topBarImage = [UIImage imageWithContentsOfFile:topBarImagePpath];
    UIImageView *topBarImageView=[[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:topBarImagePpath]];
    [topBarImageView setFrame:CGRectMake( 0, viewTopOffsetY, self.view.frame.size.width, topBarImageViewHeight)];
    topBarImageView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    topBarImageView.hidden = YES;
    [self.view addSubview:topBarImageView];
    topBarImageView = nil;
    //=====================================================//
    */
    /*
    //======== 設置 bottomImageView ========//
    NSString *bottomImagePpath = [[NSBundle mainBundle] pathForResource:@"Image/img_union_0" ofType:@"png"];
    //UIImage *bottomImage = [UIImage imageWithContentsOfFile:bottomImagePpath];
    UIImageView *bottomImageView=[[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:bottomImagePpath]];
    [bottomImageView setFrame:CGRectMake( 0, self.view.frame.size.height - bottomImageViewHeight, self.view.frame.size.width, bottomImageViewHeight)];
    //bottomImageView.backgroundColor = UIColor.grayColor;
    [self.view addSubview:bottomImageView];
    bottomImageView = nil;
    //=====================================================//
    */
    
    
    //======== 設置左下方返回主頁面的 backMainViewButton ========//
    UIButton *backMainViewButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70*zoomSize, 36*zoomSize)];
    backMainViewButton.backgroundColor = [UIColor blackColor];
    backMainViewButton.layer.masksToBounds = YES;
    backMainViewButton.layer.cornerRadius = 12.0;
    backMainViewButton.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
    backMainViewButton.layer.borderWidth = 2.0;
    
    [backMainViewButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    backMainViewButton.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:15.0] ;
    [backMainViewButton setTitle:@"<<Home" forState: UIControlStateNormal];
    [backMainViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backMainViewButton setTitle:@"按下" forState: UIControlStateHighlighted];
    [backMainViewButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    backMainViewButton.center = CGPointMake(50.0 * zoomSize, 60.0 * zoomSize);
    //backMainViewButton.layer.position = CGPointMake(self.view.frame.size.width/2, 100);
    backMainViewButton.tag = 1;
    backMainViewButton.showsTouchWhenHighlighted = YES;
    [backMainViewButton addTarget:self action:@selector(backToMainViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backMainViewButton];
    backMainViewButton = nil;
    //=====================================================//
    
    
    //======== 設置mySegmented Control ========//
    mySegmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0*zoomSize, 0*zoomSize,200*zoomSize, 36*zoomSize)];
    mySegmentedControl.backgroundColor =[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    [mySegmentedControl insertSegmentWithTitle:@"1" atIndex:0 animated:YES];
    [mySegmentedControl insertSegmentWithTitle:@"2" atIndex:1 animated:YES];
    [mySegmentedControl insertSegmentWithTitle:@"3" atIndex:2 animated:YES];
    [mySegmentedControl insertSegmentWithTitle:@"4" atIndex:3 animated:YES];
    //mySegmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
    mySegmentedControl.tintColor = [UIColor redColor];
    mySegmentedControl.center = CGPointMake(250.0 * zoomSize, 60.0 * zoomSize);
    mySegmentedControl.selectedSegmentIndex = 0;
    //mySegmentedControl.momentary = YES;
    mySegmentedControl.apportionsSegmentWidthsByContent = YES;
    [mySegmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    [mySegmentedControl setCenter:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-35*zoomSize)];
    [self.view addSubview:mySegmentedControl];
    //=====================================================//
    
    
    
    
    // 打開頁面時需執行的動作
    [self open];
    
    NSLog(@"ObjCViewController - viewDidLoad");
}


//=====================================================//
// 打開頁面時需執行的動作
//=====================================================//
 - (void)open{
     
     if(myUserUnitView != nil){
         [myUserUnitView doRequest];
     }
     if(myFriendsListView != nil && mySegmentedControl !=nil){
         [myFriendsListView doRequestWithType:(int)mySegmentedControl.selectedSegmentIndex];
     }
     
 }


//=====================================================//
// 顯示提醒標語
//=====================================================//
- (void)showAlertWithMessage:(NSString*)messageString{
    
    UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"錯誤"
                                    message:messageString
                                    preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction
                           actionWithTitle:@"確認"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [alert dismissViewControllerAnimated:NO completion:nil];
                               // do something
                           }];
    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];
    
}


//=====================================================//
// 返回 mainViewController 頁面的函式
//=====================================================//
- (IBAction)backToMainViewController:(id)sender {
    
    //[self doRequest];
    /*
    [UIView beginAnimations:@"fadeout" context:[[NSNumber numberWithFloat:self.layer.opacity] retain]];
       [UIView setAnimationDuration:0.3];
       [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
       [UIView setAnimationDelegate:self];
       self.layer.opacity = 0;
       [UIView commitAnimations];
    */
    
    if (_myMainViewController != nil) {
        
        //播放效果音 SE:1
        [_myMainViewController playAudioWithType:AudioTypeSe index:1 delay:-1.0];
        
        //播放背景音樂 BGM:0
        [_myMainViewController playAudioWithType:AudioTypeBgm index:0 delay:0.5];
        
    }
    
        
    [self.navigationController popViewControllerAnimated:YES];

}


//=====================================================//
// doSomethingInSegment
//=====================================================//
-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    
    mySegmentedControl.selectedSegmentIndex = Index;
    if(myFriendsListView != nil){
        [myFriendsListView doRequestWithType:(int)mySegmentedControl.selectedSegmentIndex];
    }
}


//=====================================================//
// dealloc
//=====================================================//
- (void)dealloc {
    
    // myUserUnitView
    myUserUnitView = nil;
    
    // myFriendsListView
    myFriendsListView = nil;

    //mySegmentedControl
    mySegmentedControl = nil;
    
}

//=====================================================//
// 收到記憶體錯誤的動作
//=====================================================//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && [self.view window] == nil) {
              self.view = nil;
    }
}

@end
