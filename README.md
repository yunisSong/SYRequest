# SYRequest

SYRequest 是 学习 [链式语法](https://yunissong.github.io/2017/04/25/%E9%93%BE%E5%BC%8F%E8%AF%AD%E6%B3%95%E5%AD%A6%E4%B9%A0/)  的过程中，写的一个通讯类，有些简陋，简单的通讯可以用一下。

具体使用如下：

```
 SYRequest *requset = [[SYRequest alloc] init];
    requset.requestURLString(@"https://www.metaweather.com/api/location/search/")
            .httpMethod(SYHTTPMethod_GET)
            .addParameters(@{@"query":@"sa"})
            .start(^(BOOL sucess,id responseData,NSError *error){
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                NSLog(@"jsonDic = %@",jsonDic);
            });
```

或者：

```
    SYRequest.requestURLString(@"https://www.metaweather.com/api/location/search/")
    .httpMethod(SYHTTPMethod_GET)
    .addParameters(@{@"query":@"sa"})
    .start(^(BOOL sucess,id responseData,NSError *error){
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        NSLog(@"jsonDic = %@",jsonDic);
    });
```

