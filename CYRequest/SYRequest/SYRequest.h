//
//  SYRequest.h
//  C06Demo
//
//  Created by Yunis on 17/4/21.
//  Copyright © 2017年 Yunis. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,SYHTTPMethod) {
    SYHTTPMethod_Post,
    SYHTTPMethod_GET
};
typedef NS_ENUM(NSInteger,SYParameterEncoding) {
    SYNKParameterEncodingURL = 0, // default
    SYNKParameterEncodingJSON,
    SYNKParameterEncodingPlist
};

@class SYRequest;

typedef void(^completionHandler) (BOOL sucess,id responseData,NSError *error);

//参数设置

typedef SYRequest * (^apiAddress) (NSString *apiAddress);
typedef SYRequest * (^httpMethod) (SYHTTPMethod method);
typedef SYRequest * (^parameterEncoding) (SYParameterEncoding parameterEncoding);
typedef SYRequest * (^head) (NSDictionary *head);
typedef SYRequest * (^params) (NSDictionary *params);
typedef SYRequest * (^body) (NSData *body);

//操作处理
typedef SYRequest * (^startRequest) (completionHandler);
typedef SYRequest * (^cancelRequest) ();
typedef SYRequest * (^suspendRequest) ();
typedef SYRequest * (^resumeRequest) ();

typedef SYRequest * (^response)(completionHandler);

//显示弹框。
typedef SYRequest * (^showLoadingView) (NSString *loadingTitle);
typedef SYRequest * (^stopLoading) ();
//弹框样式。


@interface SYRequest : NSObject
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic,strong) NSMutableURLRequest *request;
@property (nonatomic,copy) completionHandler completeCallback;


+ (apiAddress )requestURLString;
+ (apiAddress)Get;
+ (apiAddress)Post;
- (apiAddress )requestURLString;
- (apiAddress)Get;
- (apiAddress)Post;

- (head)addHeadersy;
- (params)addParameters;
- (body)addBody;
- (httpMethod)httpMethod;
- (parameterEncoding)addParameterEncoding;

- (startRequest)start;
- (cancelRequest)cancel;
- (suspendRequest)suspend;
- (resumeRequest)resume;


- (response)response;


- (void)clearCompletionBlock;

@end
