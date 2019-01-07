//
//  NetworkManager.m
//  LoggerTech
//
//  Created by MeetLucky on 2017/4/16.
//  Copyright © 2017年 杭州互办网络科技有限公司. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

#pragma mark    实例化网络管理单例
+ (instancetype)sharedManager {
    static NetworkManager *instance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[NetworkManager alloc] init];
    });
    
    
    return instance;
}


- (void)netGet:(NSString *)url data:(NSMutableDictionary *)data success:(SuccessBlock)success failure:(void(^)(NSString *message))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    manager.requestSerializer  = [AFJSONRequestSerializer  serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer.cachePolicy     = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.requestSerializer.timeoutInterval = 60;
    
#if DEBUG
    NSLog(@"接口地址:%@", url);
    NSLog(@"请求参数:%@", data);
#endif
    
    
    [manager GET:url parameters:data progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ( success ) {
            success( responseObject );
        }
#if DEBUG
        NSLog(@"接口返回:%@", responseObject);
#endif
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ( failure ) {
            failure( error.localizedDescription );
        }
    }];
}


- (void)netPost:(NSString *)url data:(NSMutableDictionary *)data success:(SuccessBlock)success failure:(void(^)(NSString *message))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer  = [AFHTTPRequestSerializer  serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.requestSerializer.timeoutInterval = 60;
    
#if DEBUG
    NSLog(@"接口地址:%@", url);
    NSLog(@"请求参数:%@", data);
#endif
    
    [manager POST:url parameters:data progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject == nil) {
            if ( success ) {
                success( responseObject );
            }
        }else{
            if ( [responseObject isEqual:[NSNull null]] ) {
                if ( success ) {
                    success( responseObject );
                }
            } else {
                if ( [responseObject isKindOfClass:[NSDictionary class]] ) {
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    NSArray *keys = dic.allKeys;
                    
                    if ( [keys containsObject:@"message"] ) {
                        NSString *msg = [dic objectForKey:@"message"];
                        
                        if ( ![msg isEqualToString:@"参数错误"] ) {
                            if ( success ) {
                                success( responseObject );
                            }
                        }
                    }
                }
            }
        }
        
#if DEBUG
        NSLog(@"接口返回:%@", responseObject);
#endif
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ( failure ) {
            failure( error.localizedDescription );
        }
    }];
}

- (void)netReplyPost:(NSString *)url data:(NSMutableDictionary *)data success:(SuccessBlock)success failure:(void(^)(NSString *message))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer  = [AFHTTPRequestSerializer  serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.requestSerializer.timeoutInterval = 60;
    
#if DEBUG
    NSLog(@"接口地址:%@", url);
    NSLog(@"请求参数:%@", data);
#endif
    
    [manager POST:url parameters:data progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject == nil) {
            if ( success ) {
                success( responseObject );
            }
        }else{
            if ( [responseObject isEqual:[NSNull null]] ) {
                if ( success ) {
                    success( responseObject );
                }
            } else {
                if ( [responseObject isKindOfClass:[NSDictionary class]] ) {
                    
                    
                    
                    if ( success ) {
                        success( responseObject );
                    }
                    
                    
                }
            }
        }
        
#if DEBUG
        NSLog(@"接口返回:%@", responseObject);
#endif
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ( failure ) {
            failure( error.localizedDescription );
        }
    }];
}


- (void)netPost1:(NSString *)url submit:(NSMutableDictionary *)submit success:(SuccessBlock)success failure:(void(^)(NSString *message))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer  = [AFHTTPRequestSerializer  serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.requestSerializer.timeoutInterval = 60;
    
    
    
    [manager POST:url parameters:submit progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ( success ) {
            success( responseObject );
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ( failure ) {
            failure( error.localizedDescription );
        }
    }];
}

- (void)netBody:(NSString *)url submit:(NSMutableDictionary *)submit success:(SuccessBlock)success failure:(void(^)(NSString *message))failure {
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer  = [AFHTTPRequestSerializer  serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
//    manager.requestSerializer.timeoutInterval = 60;
//
//
//
//    [manager POST:url parameters:submit progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if ( success ) {
//            success( responseObject );
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if ( failure ) {
//            failure( error.localizedDescription );
//        }
//    }];
    
    
    
    
//    NSDictionary *body = @{@"UI_NAME":@"FSEAFNSEFN"};
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:submit options:0 error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if ( success ) {
                success( responseObject );
            }
        }else{
            if ( failure ) {
                failure( error.localizedDescription );
            }
        }
    }] resume];
   
}

@end
