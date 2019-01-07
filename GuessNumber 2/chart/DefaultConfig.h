//
//  DefaultConfig.h
//  SmartSchool
//
//  Created by leilei on 2018/5/4.
//  Copyright © 2018年 杭州互办网络科技有限公司. All rights reserved.
//

#ifndef DefaultConfig_h
#define DefaultConfig_h
//  控制器快速初始化
#define HBALLOCOBJ(value) [[value alloc]init]

//  弱引用定义
#define HBWeakSelf(object)      __weak   typeof(object) weak##object = object;

//  强引用定义
#define HBStrongSelf(object)     __strong typeof(object) object = weak##object;


//  屏幕大小
#define HBScreenBound           [UIScreen mainScreen].bounds
#define HBScreenWidth           [UIScreen mainScreen].bounds.size.width
#define HBScreenHeight          [UIScreen mainScreen].bounds.size.height
#define HBScreenScale           [UIScreen mainScreen].scale

#define SPACE 15
// 默认创建列数
#define rowMax 2

//  应用程序
#define HBApplication           [UIApplication sharedApplication]

//  状态栏
#define HBStatusHeight          [HBApplication statusBarFrame].size.height

//  导航栏
#define HBNavBarHeight          self.navigationController.navigationBar.frame.size.height

//  视图高
#define HBViewHeight            ( HBScreenHeight - HBStatusHeight - HBNavBarHeight )
#define HBLandscapeViewHeight   ( HBScreenWidth - HBStatusHeight - HBNavBarHeight )


//  当前设备是否是 iPhoneX
#define iPhoneX                 ( HBScreenHeight == 812.f )

#define Font(float) [UIFont fontWithName:@"Helvetica" size:float]
#define BoldFont(float) [UIFont boldSystemFontOfSize:float]


#define DefaultBackColor [UIColor colorWithQuick:240 green:240 blue:240]
#define NavBgColor [UIColor colorWithQuick:3 green:111 blue:232]
//  手机系统版本
#define HBSystemVersion         [[[UIDevice currentDevice] systemVersion] floatValue]

// 字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref)isEqualToString:@""]))

//本地保存
#define USERDEFAULT [NSUserDefaults standardUserDefaults]


#define ISLOGIN [USERDEFAULT boolForKey:keyIsLogin]

#define ISAUDIT [USERDEFAULT boolForKey:keyIsPublish]


//  网络连接

#define HBNetwork               [AFNetworkReachabilityManager sharedManager]
#define HBNetConnState          HBNetwork.networkReachabilityStatus
#define HBNetConnection         ( HBNetConnState < 1 )


#define NSSystemBundle          [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue]


#endif /* DefaultConfig_h */






//-(void)setWebViewShow {
//    self.wkWebView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 20, HBScreenWidth, HBScreenHeight-20-49)];
//    self.wkWebView.backgroundColor=[UIColor whiteColor];
//    self.wkWebView.navigationDelegate = self;
//    self.wkWebView.UIDelegate  = self;
////    self.wkWebView.delegate = self;
//
////    NSString *str = [NSString stringWithFormat:@"http://www.baidu.com"];
//
//    NSString *str = [NSString stringWithFormat:@"%@/main_index.html?user=%@&token=%@", URLHOME, USERID, USERTOKEN];
//    NSURL*  url = [NSURL URLWithString:str];
//    NSLog(@"=========%@", url);
//    NSURLRequest * request = [NSURLRequest requestWithURL:url];
//    [self.wkWebView loadRequest:request];
//    [self.view addSubview:self.wkWebView];
//}
//
//
//
//-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
//    NSLog(@"=========%@", navigationAction.request.URL.absoluteString);
//
//    //smart://switchuser?url=https://huban.oss-cn-hangzhou.aliyuncs.com/Pictures/2018-05-07/018da5ac-4c67-417d-ab26-e5f02e10bb8b/897108ec-cf8f-4e4e-9cc2-88a930ba295b.jpg.JPG
//    //smart://switchuser?id=988737152800264192
//    NSArray *arrStr = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"="];
//    NSString *value = arrStr[1];//值  是 用户id或者是图片url
//    NSArray *arrStrType = [arrStr[0] componentsSeparatedByString:@"?"];
//
//
//    if ([arrStrType[1] isEqualToString:@"url"]) {//看图片
//        PYPhotoBrowseView *borweView = HBALLOCOBJ(PYPhotoBrowseView);
//        NSArray *arrIURL = @[value];
//        borweView.imagesURL = arrIURL;
//        [borweView show];
//    }else if ([arrStrType[1] isEqualToString:@"id"]){//切换学生
//        if (![USERID isEqualToString:arrStr[1]]) {//点击的学生跟现在学生不是同一个人 就要更换数据
//
//            //userID换掉
//            [USERDEFAULT setObject:value forKey:keyUserId];
//
//            //将用户信息换掉
//            UserInfoModel *userModel = [UserInfoModel sharedUserrInfo];
//            for (NSInteger index = 0; index < self.childsData.count; index ++) {
//                NSDictionary *userInfo = [self.childsData objectAtIndex:index];
//                NSString *userId = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"pkid"]];//这个用户的userid
//                if ([userId isEqualToString:value]) {//这个用户的id == 点击的用户id
//                    [userModel setValuesForKeysWithDictionary:userInfo];
//                    break;
//                }
//            }
//
//
//        }
//    }
//
//    //允许跳转
//    decisionHandler(WKNavigationActionPolicyAllow);
//}

