//
//  NetworkManager.h
//  LoggerTech
//
//  Created by MeetLucky on 2017/4/16.
//  Copyright © 2017年 杭州互办网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

// 本地
//#define HOSTHOME        @"http://192.168.31.230:8088/huban-admin"
// 服务器
#define HOSTHOME        @"http://47.92.141.218:8080/huban-admin"

#define NetWork     [NetworkManager sharedManager]

/// 网络管理
@interface NetworkManager : NSObject

typedef void(^SuccessBlock)(NSDictionary *response); // 成功回调
typedef void(^FailureBlock)(NSString     *message);  // 失败回调


/// 网络管理
+ (instancetype)sharedManager;

- (void)netGet:(NSString *)url data:(NSMutableDictionary *)data success:(SuccessBlock)success failure:(FailureBlock)failure;

- (void)netPost:(NSString *)url data:(NSMutableDictionary *)data success:(SuccessBlock)success failure:(FailureBlock)failure;

- (void)netPost1:(NSString *)url submit:(NSMutableDictionary *)submit success:(SuccessBlock)success failure:(void(^)(NSString *message))failure;

//针对学生反馈回复。 只返回了一个key 为Status 的字典
- (void)netReplyPost:(NSString *)url data:(NSMutableDictionary *)data success:(SuccessBlock)success failure:(void(^)(NSString *message))failure;


- (void)netBody:(NSString *)url submit:(NSMutableDictionary *)submit success:(SuccessBlock)success failure:(void(^)(NSString *message))failure;

@end
