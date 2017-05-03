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
//  query=shanghai
    
    SYRequest *requset = [[SYRequest alloc] init];
    requset.requestURLString(@"https://www.metaweather.com/api/location/search/")
            .httpMethod(SYHTTPMethod_GET)
            .addParameters(@{@"query":@"sa"})
            .start(^(BOOL sucess,id responseData,NSError *error){
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                NSLog(@"jsonDic = %@",jsonDic);
            });
    
    
    SYRequest.requestURLString(@"https://www.metaweather.com/api/location/search/")
    .httpMethod(SYHTTPMethod_GET)
    .addParameters(@{@"query":@"sa"})
    .start(^(BOOL sucess,id responseData,NSError *error){
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        NSLog(@"jsonDic = %@",jsonDic);
    });
}




//    SYRequest *requset = [[SYRequest alloc] init];
//    requset.requestURLString(@"https://www.metaweather.com/api/location/search/?query=shanghai")
//    .httpMethod(SYHTTPMethod_GET)
//    .start(^(BOOL sucess,id responseData,NSError *error){
//        
//        
//        NSLog(@"response = %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
//    });
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
