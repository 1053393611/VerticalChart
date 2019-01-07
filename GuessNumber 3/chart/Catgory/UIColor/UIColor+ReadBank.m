//
//  UIColor+ReadBank.m
//  ReadBank
//
//  Created by MeetLucky on 2017/6/27.
//  Copyright © 2017年 杭州互办网络科技有限公司. All rights reserved.
//

#import "UIColor+ReadBank.h"

@implementation UIColor (ReadBank)

#pragma mark -  让颜色变暗
- (instancetype)darken {
    CGFloat components[4];
    
    [self components:components forColor:self];
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    r *= 0.95;
    g *= 0.95;
    b *= 0.95;
    
    UIColor *result = [UIColor colorWithQuick:r green:g blue:b];
    
    return result;
    
}

//  根据颜色获取颜色的三原色数据值
- (void)components:(CGFloat [4])components forColor:(UIColor *)color {
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    unsigned char   pixel[4];
    CGContextRef    context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, space, kCGImageAlphaNoneSkipLast);
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    CGContextRelease(context);
    CGColorSpaceRelease(space);
    
    for ( int component = 0; component < 4; component++ ) {
        components[component] = pixel[component];
    }
}


#pragma mark -  根据色相创建颜色
+ (instancetype)colorWithSome:(CGFloat)some {
    UIColor *result = [UIColor colorWithRed:some / 255.0 green:some / 255.0 blue:some / 255.0 alpha:1.0];
    return result;
}


#pragma mark    快速设置颜色
+ (instancetype)colorWithQuick:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    UIColor *result = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
    return result;
}


#pragma mark -  默认颜色设置
+ (instancetype)defaultColor {
    UIColor *result = [UIColor colorWithQuick:50 green:47 blue:73];
    return result;
}


+ (instancetype)sectionColor {
    UIColor *result = [UIColor colorWithSome:250];
    return result;
}

#pragma mark    默认深一点颜色
+ (instancetype)darkenColor {
    UIColor *result = [[UIColor defaultColor] darken];
    return result;
}


#pragma mark    UITableViewCell 选择的背景色
+ (instancetype)selectedColor {
    UIColor *result = [UIColor colorWithWhite:0.96 alpha:1];
    return result;
}




#pragma mark    分割线颜色
+ (instancetype)lineColor {
    UIColor *result = [UIColor colorWithWhite:0.8 alpha:0.5];
    return result;
}


#pragma mark    警告确认颜色
+ (instancetype)confirmColor {
    UIColor *result = [UIColor colorWithQuick:255 green:102 blue:118];
    
    return result;
}


#pragma mark    禁用颜色
+ (instancetype)disableColor {
    UIColor *result = [UIColor colorWithSome:181];
    return result;
}



@end
