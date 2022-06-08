//
//  DataRequestUnit.h
//  AkitosHome
//
//  Created by akito on 2022/6/7.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


// DataRequestUnitDelegate協議定義
@protocol DataRequestUnitDelegate <NSObject>

@required
// DataRequestUnit完成請求或請求失敗 後執行
-(void)dataRequestTask:(NSData *)data task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;

@end

@interface DataRequestUnit : NSObject<NSURLSessionDataDelegate>{
    
    //delegate
    id<DataRequestUnitDelegate> _delegate;

    
    // 連線用的 NSURLSessionDataTask
    NSURLSessionDataTask *dataTask;
    
    // 接受連線資料用的 NSMutableData
    NSMutableData *requestHogeData;
    
}

//DataRequestUnitDelegate
@property (nonatomic, strong) id delegate;

// 重設時需執行的動作
- (void)reset;

// 請求時需執行的動作
- (void)doRequestWithUel:(NSString*)_urlString;


@end

NS_ASSUME_NONNULL_END

