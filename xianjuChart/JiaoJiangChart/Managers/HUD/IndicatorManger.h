//
//  IndicatorManger.h
//  ReadBank
//
//  Created by leilei on 2017/6/20.
//  Copyright © 2017年 杭州互办网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

#define Hud     IndicatorManger


@interface IndicatorManger : NSObject




/// 在窗口上显示提示文字, 1 秒后消失
+ (void)showMessage:(NSString *)message;


/// 在窗口上显示成功提示, 1 秒后消失
+ (void)showSuccess:(NSString *)message;


/// 在窗口上上显示失败提示, 1 秒后消失
+ (void)showFailure:(NSString *)message;



/// 在窗口上上显示提示文字并有灰色背景遮罩, 1 秒后消失
+ (void)showDimMessage:(NSString *)message;


/// 在窗口上上显示成功提示并有灰色背景遮罩, 1 秒后消失
+ (void)showDimSuccess:(NSString *)message;


/// 在窗口上上显示失败提示并有灰色背景遮罩, 1 秒后消失
+ (void)showDimFailure:(NSString *)message;



/// 在视图上显示提示文字, 1 秒后消失
+ (void)showMessage:(NSString *)message inView:(UIView *)view;


/// 在视图上显示成功文字, 1 秒后消失
+ (void)showSuccess:(NSString *)message inView:(UIView *)view;


/// 在视图上显示失败文字, 1 秒后消失
+ (void)showFailure:(NSString *)message inView:(UIView *)view;



/// 在窗口上上显示操作提示,在未来某一个时间手动调用消失
+ (void)showOperateBegin:(NSString *)message;


/// 在窗口上上显示上传进度,在未来某一个时间手动调用消失
+ (void)showOperateBar:(NSString *)message;


/// 继续显示上传进度
+ (void)showOperateContinue:(NSString *)message;


/// 在窗口上上显示上传进度,在未来某一个时间手动调用消失
+ (void)showOperateProgress:(CGFloat)progress;


/// 显示等待压缩完成
+ (void)showOperateDelay:(NSString *)messag;


/// 把窗口上上显示操作提示立即消失掉
+ (void)showOperateEnd;


/// 更改操作提示文字
+ (void)showOperateState:(NSString *)message;


/// 提示操作成功提示,并在 1 秒后消失
+ (void)showOperateSuccess:(NSString *)message;


/// 显示操作失败提示文字,并在 1 秒后消失
+ (void)showOperateFailure:(NSString *)message;


/// 在窗口上上显示操作提示
+ (void)showOperateBegin:(NSString *)message detail:(NSString *)detail;


/// 更改操作提示文字
+ (void)showOperateState:(NSString *)message detail:(NSString *)detail;



@end
