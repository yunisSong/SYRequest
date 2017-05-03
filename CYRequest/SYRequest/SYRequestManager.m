//
//  SYRequestManage.m
//  C06Demo
//
//  Created by Yunis on 17/4/24.
//  Copyright © 2017年 Yunis. All rights reserved.
//

#import "SYRequestManager.h"
@interface SYRequestManager()<NSURLSessionDelegate>
@property (nonatomic, strong) NSMutableDictionary *requestQueue;

@end
@implementation SYRequestManager


#define CY_TimeoutInterval 60
#define CY_MaxConcurrentRequestCount 1


#pragma mark - Life Cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static SYRequestManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SYRequestManager alloc] init];
    });
    
    return sharedInstance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
        configure.HTTPMaximumConnectionsPerHost = CY_MaxConcurrentRequestCount;
        self.requestQueue = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Public Method
//外部方法
- (void)addSYRequest:(SYRequest *)syBaseRequest
{
    NSURLRequest *request = syBaseRequest.request;
    NSLog(@"request = %@ %@",request,syBaseRequest);
    
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:Nil];
    
    
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                             {
                                                 [self handleReponseResult:syBaseRequest.task response:data error:error];
                                                 
                                             }];
    syBaseRequest.task = sessionDataTask;
    [self addRequest:syBaseRequest];
    [sessionDataTask resume];
    
//    [session finishTasksAndInvalidate];

}

- (void)removeSYRequest:(SYRequest *)syBaseRequest
{
    [syBaseRequest.task cancel];
    [self removeRequest:syBaseRequest.task];
    [syBaseRequest clearCompletionBlock];
}
- (void)suspendSYRequest:(SYRequest *)syBaseRequest
{
    [syBaseRequest.task suspend];

}
- (void)resumeSYRequest:(SYRequest *)syBaseRequest
{
    [syBaseRequest.task resume];
}
- (void)removeAllRequests
{
    for (NSString *key in self.requestQueue) {
        SYRequest *request = self.requestQueue[key];
        [self removeSYRequest:request];
    }
}
- (NSURLSessionTaskState)stateOfSYRequest:(SYRequest *)syBaseRequest
{
    return [syBaseRequest.task state];
}
#pragma mark - Private Method
//本类方法
- (void)handleReponseResult:(NSURLSessionDataTask *)task response:(id)responseObject error:(NSError *)error
{
    //find task
    NSString *key = [self taskHashKey:task];
    SYRequest *request = self.requestQueue[key];
    
    //要不要判断用户是否取消操作。
    
    if (request.completeCallback) {
        if (error)
        {
            request.completeCallback(NO,nil,error);
        }else
        {
            // 返回数据
            request.completeCallback(YES,responseObject,nil);
        }
    }

    // 请求成功后移除此次请求
    [request clearCompletionBlock];
    [self removeRequest:task];
}

- (void)addRequest:(SYRequest *)request {
    if (request.task) {
        NSString *key = [self taskHashKey:request.task];
        @synchronized(self) {
            [self.requestQueue setValue:request forKey:key];
            if (self.requestQueue.count > 0)
            {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            }
        }
    }
}
- (void)removeRequest:(NSURLSessionDataTask *)task {
    NSString *key = [self taskHashKey:task];
    @synchronized(self) {
        [self.requestQueue removeObjectForKey:key];
        if (self.requestQueue.count <= 0)
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }
}

- (NSString *)taskHashKey:(NSURLSessionDataTask *)task {
    return [NSString stringWithFormat:@"%lu", (unsigned long)[task hash]];
}
#pragma mark - Delegate
//代理方法
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        //        if([challenge.protectionSpace.host isEqualToString:@"recvapi.log.dtstack.com"]){
        //            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        //            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        //        } else {
        //            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        //        }
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        
    }
}

@end
