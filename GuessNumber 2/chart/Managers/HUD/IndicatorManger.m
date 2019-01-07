//
//  IndicatorManger.m
//  ReadBank
//
//  Created by leilei on 2017/6/20.
//  Copyright © 2017年 杭州互办网络科技有限公司. All rights reserved.
//

#import "IndicatorManger.h"

@implementation IndicatorManger


#pragma mark    在窗口上显示提示文字, 1 秒后消失
+ (void)showMessage:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode                       = MBProgressHUDModeText;
    hud.margin                     = 20;
    hud.minSize                    = CGSizeMake((120), (60));
    hud.removeFromSuperViewOnHide = YES;
    
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    
    [hud hideAnimated:YES afterDelay:1];
}



#pragma mark    在窗口上显示成功提示, 1 秒后消失
+ (void)showSuccess:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode                      = MBProgressHUDModeCustomView;
    hud.margin                    = (20);
    hud.minSize                   = CGSizeMake((100), (100));
    hud.customView                = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_ok"]];
    hud.removeFromSuperViewOnHide = YES;
    
    hud.label.text          = message;
    hud.label.numberOfLines = 0;
    
    [hud hideAnimated:YES afterDelay:1];
}



#pragma mark    在窗口上上显示失败提示, 1 秒后消失
+ (void)showFailure:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode                      = MBProgressHUDModeCustomView;
    hud.margin                    = (20);
    hud.minSize                   = CGSizeMake((100), (100));
    hud.customView                = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_no"]];
    hud.removeFromSuperViewOnHide = YES;
    
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    
    [hud hideAnimated:YES afterDelay:1];
}



#pragma mark -  在窗口上上显示提示文字并有灰色背景遮罩, 1 秒后消失
+ (void)showDimMessage:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode                      = MBProgressHUDModeText;
    hud.margin                    = (20);
    hud.minSize                   = CGSizeMake((100), (100));
    hud.removeFromSuperViewOnHide = YES;
    
    hud.label.text          = message;
    hud.label.numberOfLines = 0;
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    [hud hideAnimated:YES afterDelay:1];
}



#pragma mark    在窗口上上显示成功提示并有灰色背景遮罩, 1 秒后消失
+ (void)showDimSuccess:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode                      = MBProgressHUDModeCustomView;
    hud.margin                    = (20);
    hud.minSize                   = CGSizeMake((100), (100));
    hud.customView                = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_no"]];
    hud.removeFromSuperViewOnHide = YES;
    
    hud.label.text          = message;
    hud.label.numberOfLines = 0;
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    [hud hideAnimated:YES afterDelay:1];
}



#pragma mark    在窗口上上显示失败提示并有灰色背景遮罩, 1 秒后消失
+ (void)showDimFailure:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode                      = MBProgressHUDModeCustomView;
    hud.margin                    = (20);
    hud.minSize                   = CGSizeMake((100), (100));
    hud.customView                = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_no"]];
    hud.removeFromSuperViewOnHide = YES;
    
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    [hud hideAnimated:YES afterDelay:1];
}



#pragma mark -  在视图上显示提示文字, 1 秒后消失
+ (void)showMessage:(NSString *)message inView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode                      = MBProgressHUDModeText;
    hud.margin                    = (20);
    hud.minSize                   = CGSizeMake((120), (60));
    hud.removeFromSuperViewOnHide = YES;
    
    hud.label.text          = message;
    hud.label.numberOfLines = 0;
    
    [hud hideAnimated:YES afterDelay:1];
}



#pragma mark    在视图上显示成功文字, 1 秒后消失
+ (void)showSuccess:(NSString *)message inView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode                      = MBProgressHUDModeCustomView;
    hud.margin                    = (20);
    hud.minSize                   = CGSizeMake((100), (100));
    hud.customView                = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_ok"]];
    hud.removeFromSuperViewOnHide = YES;
    
    hud.label.text          = message;
    hud.label.numberOfLines = 0;
    
    [hud hideAnimated:YES afterDelay:1];
}



#pragma mark    在视图上显示失败文字, 1 秒后消失
+ (void)showFailure:(NSString *)message inView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode                      = MBProgressHUDModeCustomView;
    hud.margin                    = (20);
    hud.minSize                   = CGSizeMake((100), (100));
    hud.customView                = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_no"]];
    hud.removeFromSuperViewOnHide = YES;
    
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    
    [hud hideAnimated:YES afterDelay:1];
}



#pragma mark -  在窗口上上显示操作提示,在未来某一个时间手动调用消失
+ (void)showOperateBegin:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.margin                    = (20);
    hud.minSize                   = CGSizeMake((100), (100));
    hud.removeFromSuperViewOnHide = YES;
    
    hud.label.text          = message;
    hud.label.numberOfLines = 0;
    
    [hud showAnimated:YES];
}



#pragma mark    在窗口上上显示操作提示
+ (void)showOperateBegin:(NSString *)message detail:(NSString *)detail {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.margin                    = (20);
    hud.minSize                   = CGSizeMake((100), (100));
    hud.removeFromSuperViewOnHide = YES;
    
    hud.label.text          = message;
    hud.label.numberOfLines = 0;
    
    hud.detailsLabel.text = detail;
    
    [hud showAnimated:YES];
}



#pragma mark    在窗口上上显示上传进度,在未来某一个时间手动调用消失
+ (void)showOperateBar:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode   = MBProgressHUDModeDeterminateHorizontalBar;
    hud.margin = (20);
    
    hud.label.text          = message;
    hud.label.numberOfLines = 0;
    
    [hud showAnimated:YES];
}



#pragma mark    继续显示上传进度
+ (void)showOperateContinue:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    for ( UIView *view in window.subviews ) {
        if ( [view isKindOfClass:[MBProgressHUD class]] ) {
            MBProgressHUD *hud = (MBProgressHUD *)view;
            hud.mode   = MBProgressHUDModeDeterminateHorizontalBar;
            hud.margin = (20);
            
            hud.label.text          = message;
            hud.label.numberOfLines = 0;
            
            break;
        }
    }
}



#pragma mark    在窗口上上显示上传进度,在未来某一个时间手动调用消失
+ (void)showOperateProgress:(CGFloat)progress {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    for ( UIView *view in window.subviews ) {
        if ( [view isKindOfClass:[MBProgressHUD class]] ) {
            MBProgressHUD *hud = (MBProgressHUD *)view;
            hud.progress = progress;
            
            break;
        }
    }
}



#pragma mark    把窗口上上显示操作提示立即消失掉
+ (void)showOperateEnd {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    for ( UIView *view in window.subviews ) {
        if ( [view isKindOfClass:[MBProgressHUD class]] ) {
            MBProgressHUD *hud = (MBProgressHUD *)view;
            [hud hideAnimated:YES afterDelay:0];
        }
    }
}



#pragma mark    更改操作提示文字
+ (void)showOperateState:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    for ( UIView *view in window.subviews ) {
        if ( [view isKindOfClass:[MBProgressHUD class]] ) {
            MBProgressHUD *hud = (MBProgressHUD *)view;
            hud.label.text          = message;
            hud.label.numberOfLines = 0;
            
            break;
        }
    }
}



#pragma mark    更改操作提示文字
+ (void)showOperateDelay:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    for ( UIView *view in window.subviews ) {
        if ( [view isKindOfClass:[MBProgressHUD class]] ) {
            MBProgressHUD *hud = (MBProgressHUD *)view;
            hud.mode = MBProgressHUDModeIndeterminate;
            
            hud.label.text          = message;
            hud.label.numberOfLines = 0;
            
            break;
        }
    }
}



#pragma mark    更改操作提示文字
+ (void)showOperateState:(NSString *)message detail:(NSString *)detail {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    for ( UIView *view in window.subviews ) {
        if ( [view isKindOfClass:[MBProgressHUD class]] ) {
            MBProgressHUD *hud = (MBProgressHUD *)view;
            hud.label.text          = message;
            hud.label.numberOfLines = 0;
            
            hud.detailsLabel.text          = detail;
            hud.detailsLabel.numberOfLines = 0;
            
            break;
        }
    }
}



#pragma mark    提示操作成功提示,并在 1 秒后消失
+ (void)showOperateSuccess:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    for ( UIView *view in window.subviews ) {
        if ( [view isKindOfClass:[MBProgressHUD class]] ) {
            MBProgressHUD *hud = (MBProgressHUD *)view;
            hud.mode       = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_ok"]];
            
            hud.label.text  = message;
            
            [hud hideAnimated:YES afterDelay:1];
        }
    }
}



#pragma mark    显示操作失败提示文字,并在 1 秒后消失
+ (void)showOperateFailure:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    for ( UIView *view in window.subviews ) {
        if ( [view isKindOfClass:[MBProgressHUD class]] ) {
            MBProgressHUD *hud = (MBProgressHUD *)view;
            hud.mode       = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_no"]];
            
            hud.label.text          = message;
            hud.label.numberOfLines = 0;
            
            [hud hideAnimated:YES afterDelay:1];
        }
    }
}





@end
