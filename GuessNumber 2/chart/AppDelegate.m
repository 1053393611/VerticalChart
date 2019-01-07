//
//  AppDelegate.m
//  chart
//
//  Created by 钟程 on 2018/10/10.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LoginViewController.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [WXApi registerApp:@"wxc1ae8bcbf84e97d0" enableMTA:YES];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[FileManager databaseForMasterPath]];
    [FMDB checkBehaviorTableExist:db];
    NSArray *array = [FMDB selectTableList];
    if (array.count == 0) {
        NSString *listId = [[DataManager defaultManager] getNowTimeTimestamp];
        ListModel *listModel = [ListModel modelWithListId:listId total:@"0" course:1 no:1 input:@"0.00" result:@"未开" thisAll:@"0"];
        [FMDB insertTableList:listModel];
        [FMDB initDetail:listId];
        
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    BOOL isLogin = [[USERDEFAULT objectForKey:@"isLogin"] boolValue];
    if ( isLogin ) { // 用户是登录状态
        ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle: nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        self.window.rootViewController = vc;
        [self getVcodeType];
    } else { // 用户未登录状态
        LoginViewController *vc = HBALLOCOBJ(LoginViewController);
        self.window.rootViewController = vc;
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    return [WXApi handleOpenURL:url delegate:self];
}

//从微信分享过后点击返回应用的时候调用
- (void)onResp:(BaseResp *)resp {
    
    //把返回的类型转换成与发送时相对于的返回类型,这里为SendMessageToWXResp
    //    SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
    //
    //    //使用UIAlertView 显示回调信息
    //    NSString *str = [NSString stringWithFormat:@"%d",sendResp.errCode];
    //    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"回调信息" message:str delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    //    [alertview show];
    /*
     WXSuccess           = 0,     成功
     WXErrCodeCommon     = -1,    普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,    发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,    微信不支持
     */
}

#pragma mark - 获取验证码状态

- (void)getVcodeType {
    NSString *vcode = [USERDEFAULT objectForKey:@"vcode"];
    [NetWork getVcodeTypeWithCcode:vcode success:^(NSDictionary *response) {
        NSLog(@"%@", response);
        if ([response[@"code"] integerValue] == 0) {
            
        }else {
            LoginViewController *vc = HBALLOCOBJ(LoginViewController);
            self.window.rootViewController = vc;
            JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:response[@"msg"]];
            [alert addButtonWithTitle:@"确定" type:JCButtonTypeNormal clicked:nil];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            [USERDEFAULT removeObjectForKey:@"isLogin"];
            [USERDEFAULT removeObjectForKey:@"vcode"];
        }
    } failure:^(NSString *message) {
        NSLog(@"%@", message);
        //        JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:message];
        //        [alert addButtonWithTitle:@"确定" type:JCButtonTypeNormal clicked:nil];
        //        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
}

@end
