//
//  DataRequestUnit.m
//  AkitosHome
//
//  Created by akito on 2022/6/7.
//  Copyright © 2022 蔡 易達. All rights reserved.
//

#import "DataRequestUnit.h"

@implementation DataRequestUnit

@synthesize delegate = _delegate;

-(id) init;
{
    self = [super init];
    
    // 初期化接受連線資料用的 NSMutableData
    requestHogeData = [[NSMutableData alloc] initWithCapacity:0];
    
    return  self;
}

//=====================================================//
// 重設時需執行的動作
//=====================================================//
- (void)reset{
    
    // 清空 dataTask
    if(dataTask != nil){
        [dataTask cancel];
        dataTask = nil;
    }
    
    // 清除 requestHogeData
    if(requestHogeData != nil){
        [requestHogeData setLength:0];
    }
    
}
//=====================================================//
// 請求時需執行的動作
//=====================================================//
- (void)doRequestWithUel:(NSString*)_urlString{
    
    [self reset];
    
    // 透過代理發出請求
    NSURL *url = [NSURL URLWithString:_urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"GET";
        //NSString *username = @"";
        //NSString *password = @"";
        //NSString *bodyStr = [NSString stringWithFormat:@"username=%@&password=%@",username,password];
        //request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        
        //自定义会话对象设置代理，
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];//设置代理方法在哪个线程执行
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
        [dataTask resume];
    
}
    
    
    
#pragma mark NSURLConnectionDataDelegate
//=====================================================//
// 收到 response 後執行
//=====================================================//
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    
    [requestHogeData setLength:0];
    
    //通過調用 completionHandler 告訴系統如何處理響應後數據
    completionHandler(NSURLSessionResponseAllow);//NSURLSessionResponseAllow表示接收返回的数据
    
}
 
//=====================================================//
// 收到 data 後執行
//=====================================================//
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{//接收到服务器响应数据的时候会调用，该方法可能调用多次
    
    [requestHogeData appendData:data];
}

//=====================================================//
// 完成請求或請求失敗 後執行
//=====================================================//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(_delegate != nil){
        [_delegate dataRequestTask:requestHogeData task:task didCompleteWithError:error];
    }
    
}

//=====================================================//
// dealloc
//=====================================================//
- (void)dealloc {
    
    // 清空 _delegate
    _delegate = nil;
    
    // 清空 dataTask
    if(dataTask != nil){
        [dataTask cancel];
        dataTask = nil;
    }
    
    // 釋放 requestHogeData
    if(requestHogeData != nil){
        [requestHogeData setLength:0];
        requestHogeData= nil;
    }
}


@end
