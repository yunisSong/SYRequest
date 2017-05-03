//
//  ViewController.m
//  CYRequest
//
//  Created by Yunis on 17/5/3.
//  Copyright © 2017年 Yunis. All rights reserved.
//

#import "ViewController.h"
#import "SYRequest.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    SYRequest *requset = [[SYRequest alloc] init];
    requset.requestURLString(@"https://www.metaweather.com/api/location/search/")
            .httpMethod(SYHTTPMethod_GET)
            .addParameters(@{@"query":@"sa"})
            .start(^(BOOL sucess,id responseData,NSError *error){
                
                NSLog(@"responseData = %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                if (responseData) {
                    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                    NSLog(@"jsonDic = %@",jsonDic);
                }

            });
    
    SYRequest *test = [[SYRequest alloc] init];

    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:@"23" forKey:@"api"];
    [dic1 setObject:@"w-ios-440x480" forKey:@"p"];
    [dic1 setObject:@"春节" forKey:@"searchContent"];
    [dic1 setObject:@"3" forKey:@"type"];
    [dic1 setObject:@"2" forKey:@"offset"];
    [dic1 setObject:@"10" forKey:@"range"];
    
    
    test.requestURLString(@"http://218.207.208.46/shanshow_web/cy/getSearchList")
    .httpMethod(SYHTTPMethod_GET)
    .addParameters(dic1)
    .start(^(BOOL sucess,id responseData,NSError *error)
           {
               NSLog(@"resoutDic = %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
               
           });
//
//    SYRequest.requestURLString(@"https://www.metaweather.com/api/location/search/")
//    .httpMethod(SYHTTPMethod_GET)
//    .addParameters(@{@"query":@"sa"})
//    .start(^(BOOL sucess,id responseData,NSError *error){
//        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
//        NSLog(@"jsonDic = %@",jsonDic);
//    });

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
