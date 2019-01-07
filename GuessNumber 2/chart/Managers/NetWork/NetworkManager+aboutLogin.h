//
//  NetworkManager+aboutLogin.h
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/10/7.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "NetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager (aboutLogin)

// 登录
- (void)submitLoginWithVcode:(NSString *)vcode udid:(NSString *)udid appbag:(NSString *)appbag devicetype:(NSString *)devicetype ossystem:(NSString *)ossystem version:(NSString *)version success:(SuccessBlock)success failure:(FailureBlock)failure;

// 验证
- (void)getVcodeTypeWithCcode:(NSString *)vcode success:(SuccessBlock)success failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
