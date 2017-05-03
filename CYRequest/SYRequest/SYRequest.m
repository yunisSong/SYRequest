//
//  SYRequest.m
//  C06Demo
//
//  Created by Yunis on 17/4/21.
//  Copyright © 2017年 Yunis. All rights reserved.
//

#import "SYRequest.h"
#import "SYRequestManager.h"
#import "NSDictionary+MKNKAdditions.h"
@interface SYRequest()

@property  SYHTTPMethod requestHttpMethod;
@property  SYParameterEncoding parameterEncoding;

@property (nonatomic,copy) NSString *apiAddress;
@property (nonatomic,strong) NSMutableDictionary *headDic;
@property (nonatomic,strong) NSMutableDictionary *paramsDic;
@property (nonatomic,strong) NSData *body;

@end

@implementation SYRequest
#pragma mark - Life Cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.headDic = [NSMutableDictionary new];
        self.paramsDic = [NSMutableDictionary new];
        
    }
    return self;
}

#pragma mark - Public Method
//外部方法

+ (apiAddress )requestURLString
{
    return ^(NSString *apiAddress){
        SYRequest *request = [[SYRequest alloc] init];
        request.requestURLString(apiAddress);
        return request;
    };
}
+ (apiAddress)Get
{
    return ^(NSString *apiAddress){
        SYRequest *request = [[SYRequest alloc] init];
        request.Get(apiAddress);
        return request;
    };
}
+ (apiAddress)Post
{
    return ^(NSString *apiAddress){
        SYRequest *request = [[SYRequest alloc] init];
        request.Post(apiAddress);
        return request;
    };
}
-(apiAddress)requestURLString
{
    return ^(NSString *apiAddress){
        self.apiAddress = apiAddress;
        return self;
    };
    
}
- (apiAddress)Get
{
    return ^(NSString *apiAddress){
        self.requestHttpMethod = SYHTTPMethod_GET;
        self.apiAddress = apiAddress;
        return self;
    };
}
- (apiAddress)Post
{
    return ^(NSString *apiAddress) {
        self.requestHttpMethod = SYHTTPMethod_Post;
        self.apiAddress = apiAddress;
        return self;
    };
}
-(head)addHeadersy
{
    return ^(NSDictionary *head){
        [self.headDic addEntriesFromDictionary:head];
        return self;
    };
}
-(params)addParameters
{
    return ^(NSDictionary *body){
        [self.paramsDic addEntriesFromDictionary:body];
        return self;
    };
}
- (body)addBody
{
    return ^(NSData *body)
    {
        self.body = body;
        return self;
    };
}
-(httpMethod)httpMethod
{
    return ^(SYHTTPMethod method){
        self.requestHttpMethod = method;
        return self;
    };
}
- (parameterEncoding)addParameterEncoding
{
    return ^(SYParameterEncoding parameterEncoding){
        self.parameterEncoding = parameterEncoding;
        return self;
    };
}
- (startRequest)start
{
    return ^(void(^comm)(BOOL sucess,id responseData,NSError *error)){
        self.completeCallback = comm;
        [self creastRequestRun];
        return self;
    };
}
-(cancelRequest) cancel
{
    return ^()
    {
        [[SYRequestManager sharedInstance] removeSYRequest:self];
        //弹框。。。
        //隐藏。。。
        //清除数据
        return self;
    };
}
- (suspendRequest)suspend
{
    return ^()
    {
        [[SYRequestManager sharedInstance] suspendSYRequest:self];
        return self;
    };
}
- (resumeRequest)resume
{
    return ^()
    {
        [[SYRequestManager sharedInstance] resumeSYRequest:self];
        return self;
    };
}
- (response)response
{
    return ^(void(^comm)(BOOL sucess,NSDictionary *resoutDic,NSError *error)){
        self.completeCallback = comm;
        return self;
    };
}

- (void)clearCompletionBlock {
    self.completeCallback = nil;
}

#pragma mark - Private Method
//本类方法

- (void)creastRequestRun
{
    NSURL *url = [self baseURL];
    
    NSMutableURLRequest *createdRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *httpMethod = @"";
    switch (self.requestHttpMethod) {
        case SYHTTPMethod_Post:
        {
            httpMethod = @"POST";
            [createdRequest setHTTPMethod:@"POST"];
            break;
        }
        case SYHTTPMethod_GET:
        {
            httpMethod = @"GET";
            
            [createdRequest setHTTPMethod:@"GET"];
            break;
        }
        default:
            break;
    }
    if (self.headDic) {
        [createdRequest setAllHTTPHeaderFields:self.headDic];

    }

    if (self.paramsDic) {
        [self handelRequestParamsWith:createdRequest httpMethod:httpMethod];

    }
    
    if (self.body) {
        [createdRequest setHTTPBody:self.body];

    }
    
    self.request = createdRequest;
    
    [[SYRequestManager sharedInstance] addSYRequest:self];
    
    
}
- (void)handelRequestParamsWith:(NSMutableURLRequest *)createdRequest httpMethod:(NSString *)httpMethod
{
    NSString *bodyStringFromParameters = nil;
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    switch (self.parameterEncoding) {
            
        case SYNKParameterEncodingURL: {
            [createdRequest setValue:
             [NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset]
                  forHTTPHeaderField:@"Content-Type"];
            bodyStringFromParameters = [self.paramsDic urlEncodedKeyValueString];
        }
            break;
        case SYNKParameterEncodingJSON: {
            [createdRequest setValue:
             [NSString stringWithFormat:@"application/json; charset=%@", charset]
                  forHTTPHeaderField:@"Content-Type"];
            bodyStringFromParameters = [self.paramsDic jsonEncodedKeyValueString];
        }
            break;
        case SYNKParameterEncodingPlist: {
            [createdRequest setValue:
             [NSString stringWithFormat:@"application/x-plist; charset=%@", charset]
                  forHTTPHeaderField:@"Content-Type"];
            bodyStringFromParameters = [self.paramsDic plistEncodedKeyValueString];
        }
    }
    
    if (!([ httpMethod isEqualToString:@"GET"] ||
          [ httpMethod isEqualToString:@"DELETE"] ||
          [ httpMethod isEqualToString:@"HEAD"])) {
        
        [createdRequest setHTTPBody:[bodyStringFromParameters dataUsingEncoding:NSUTF8StringEncoding]];
    }
}
- (NSURL *)baseURL
{
    NSURL *url = nil;
    switch (self.requestHttpMethod) {
        case SYHTTPMethod_GET:
        {
            if (self.paramsDic.count > 0) {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", self.apiAddress,
                                            [self.paramsDic urlEncodedKeyValueString]]];
            }else
            {
                url = [NSURL URLWithString:self.apiAddress];

            }
            break;
        }
        case SYHTTPMethod_Post:
        {
            url = [NSURL URLWithString:self.apiAddress];
            
            break;
        }
        default:
            break;
    }
    
    
    if(url == nil) {
        
        NSAssert(@"Unable to create request  %@ with parameters %@",
                 self.apiAddress, self.headDic);
    }
    
    NSLog(@"URl = %@",url);
    return url;
}
#pragma mark - Delegate
//代理方法

#pragma mark - Event Response
//点击响应事件



#pragma mark - getters and setters
//初始化页面
@end
