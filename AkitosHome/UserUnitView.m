//
//  UserUnitView.m
//  AkitosHome
//
//  Created by akito on 2022/6/3.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

#import "UserUnitView.h"

#import "Reachability.h"

#define URL_USER @"http://34.84.150.189/union/user.php"

@implementation UserUnitView

@synthesize myObjCViewController = _myObjCViewController;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    // 取得螢幕的尺寸
    CGSize fullSize = [[UIScreen mainScreen] bounds].size;
    
    // 計算畫面縮放的比例 以寬度375為基準
    zoomSize = fullSize.width/375.0;
    
    
    //======== 設置用戶名 Label ========//
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 31*zoomSize, 20*zoomSize, self.frame.size.width, 20*zoomSize)];
    [userNameLabel setTextColor:[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1.0]];
    userNameLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:17.0*zoomSize] ;
    //userNameLabel.text = [NSString stringwithstring:@""];
    [self addSubview:userNameLabel];
    //=====================================================//
    
    //======== 設置用戶ID Label ========//
    userIDLabel = [[UILabel alloc] initWithFrame:CGRectMake( 31*zoomSize, 45*zoomSize, self.frame.size.width, 20*zoomSize)];
    [userIDLabel setTextColor:[UIColor colorWithRed:0.32 green:0.32 blue:0.32 alpha:1.0]];
    userIDLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:13.0*zoomSize] ;
    //userIDLabel.text = [NSString stringwithstring:@""];
    [self addSubview:userIDLabel];
    //=====================================================//
    

    //======== 設置用戶大頭照 Button ========//
    UIButton *setPhotoButton  = [[UIButton alloc] initWithFrame:CGRectMake( 295*zoomSize, 18*zoomSize, 44*zoomSize, 44*zoomSize)];
    setPhotoButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    setPhotoButton.layer.masksToBounds = YES;
    setPhotoButton.layer.cornerRadius = 22*zoomSize;
    setPhotoButton.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    setPhotoButton.layer.borderWidth = 1.0*zoomSize;
    
    [setPhotoButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    setPhotoButton.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:15.0] ;
    [setPhotoButton setTitle:@"" forState: UIControlStateNormal];
    [setPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //setPhotoButton.center = CGPointMake(50.0 * zoomSize, fullSize.height - (80.0 * zoomSize));
    //setPhotoButton.layer.position = CGPointMake(self.view.frame.size.width/2, 100);
    setPhotoButton.tag = 0;
    setPhotoButton.showsTouchWhenHighlighted = YES;
    //[setPhotoButton addTarget:self action:@selector(setMyPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:setPhotoButton];
    setPhotoButton = nil;
    //=====================================================//
    
    
    
    // 初期化放入連線用 DataRequestUnit 的 DataRequestUnitsArray
    dataRequestUnit = [[DataRequestUnit alloc] init];
    dataRequestUnit.delegate = self;
    
    
    return self;
}


//=====================================================//
// 請求時需執行的動作
//=====================================================
- (void)doRequest{
    
    //確認網路連線狀態
    if(![Reachability reachabilityWithHostName:@"www.apple.com"].currentReachabilityStatus){
        if(_myObjCViewController != nil){
            [_myObjCViewController showAlertWithMessage:@"請確認網路連線狀態"];
        }
        return;
    }
    
    
    if(dataRequestUnit != nil){
        [dataRequestUnit doRequestWithUel: URL_USER];
    }
    
 }

#pragma mark DataRequestUnitDelegate
//=====================================================//
// DataRequestUnit完成請求或請求失敗 後執行
//=====================================================//
-(void)dataRequestTask:(NSData *)data task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
    
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
            
            if(jsonObject.count >=0){
                
                NSArray *items = [jsonObject objectForKey:@"response"];
                
                if(items != nil){
                    
                    for(NSDictionary *item in items) {
                        
                        @synchronized (userDictionary) {
                            
                            if(userDictionary != nil){
                                userDictionary = nil;
                            }
                        
                            userDictionary = item;
                        }
                        
                    }
                }
            }
            
            if(userDictionary != nil){
                
                NSString *userNameDtring = [NSString stringWithString:[userDictionary objectForKey:@"name"]];
                userNameLabel.text = [NSString stringWithString:userNameDtring];
                
                NSString *userIDDtring = [NSString stringWithString:[userDictionary objectForKey:@"pid"]];
                if(userIDDtring.length <= 0){
                    userIDLabel.text =@"Set Name >";
                }else{
                    userIDLabel.text = [NSString stringWithFormat:@"Pirate ID：%@",userIDDtring];
                    
                }
                    
            }
            
        }
        
    }
    
    if(_myObjCViewController != nil && errorMessagr != nil){
        if(errorMessagr.length >0){
            [_myObjCViewController showAlertWithMessage:errorMessagr];
        }
    }
}


//=====================================================//
// dealloc
//=====================================================//
- (void)dealloc {
    
    // 釋放 userNameLabel
    if(userNameLabel != nil){
        [userNameLabel removeFromSuperview];
        userNameLabel = nil;
    }
    
    // 釋放 userIDLabel
    if(userIDLabel != nil){
        [userIDLabel removeFromSuperview];
        userIDLabel = nil;
    }
    
    // 釋放 連線用 DataRequestUnit
    if(dataRequestUnit != nil){
    
        [dataRequestUnit reset];
        dataRequestUnit = nil;
    }
    
    // 釋放 userDictionary
    if(userDictionary != nil){
        userDictionary = nil;
    }
}
@end
