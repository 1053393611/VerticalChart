//
//  NetworkManager+aboutLogin.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/10/7.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "NetworkManager+aboutLogin.h"

@implementation NetworkManager (aboutLogin)

- (void)submitLoginWithVcode:(NSString *)vcode udid:(NSString *)udid appbag:(NSString *)appbag devicetype:(NSString *)devicetype ossystem:(NSString *)ossystem version:(NSString *)version success:(SuccessBlock)success failure:(FailureBlock)failure;{
    NSString *url = [NSString stringWithFormat:@"%@/app/ykdevice/login", HOSTHOME];
    NSMutableDictionary *submit = [NSMutableDictionary dictionary];
    
    [submit setObject:vcode forKey:@"vcode"];
    [submit setObject:udid forKey:@"udid"];
    [submit setObject:appbag forKey:@"appbag"];
    [submit setObject:devicetype forKey:@"devicetype"];
    [submit setObject:ossystem forKey:@"ossystem"];
    [submit setObject:version forKey:@"version"];
    
//    NSString *str = [NSString stringWithFormat:@"{\"vcode\":\"%@\",\"udid\":\"%@\",\"appbag\":\"%@\",\"devicetype\":\"%@\",\"ossystem\":\"%@\",\"version\":\"%@\"}", vcode, udid, appbag, devicetype, ossystem, version];

    [self netBody:url submit:submit success:^(NSDictionary *response) {
        if ( success ) {
            success( response );
        }
    } failure:^(NSString *message) {
        if ( failure ) {
            failure( message );
        }
    }];
    
    
//    [self netPost:url data:submit success:^(NSDictionary *response) {
//        if ( success ) {
//            success( response );
//        }
//    } failure:^(NSString *message) {
//        if ( failure ) {
//            failure( message );
//        }
//    }];
}

- (void)getVcodeTypeWithCcode:(NSString *)vcode success:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *url = [NSString stringWithFormat:@"%@/app/ykverifyrecord/check", HOSTHOME];
    NSMutableDictionary *submit = [NSMutableDictionary dictionary];
    
    [submit setObject:vcode forKey:@"checknumber"];
    
    [self netBody:url submit:submit success:^(NSDictionary *response) {
        if ( success ) {
            success( response );
        }
    } failure:^(NSString *message) {
        if ( failure ) {
            failure( message );
        }
    }];
}

@end
