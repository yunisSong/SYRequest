//
//  SYRequestManage.h
//  C06Demo
//
//  Created by Yunis on 17/4/24.
//  Copyright © 2017年 Yunis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SYRequest.h"
@interface SYRequestManager : NSObject
+ (instancetype)sharedInstance;
- (void)addSYRequest:(SYRequest *)syBaseRequest;
- (void)removeSYRequest:(SYRequest *)syBaseRequest;
- (void)suspendSYRequest:(SYRequest *)syBaseRequest;
- (void)resumeSYRequest:(SYRequest *)syBaseRequest;
- (void)removeAllRequests;
- (NSURLSessionTaskState)stateOfSYRequest:(SYRequest *)syBaseRequest;
@end
