//
//  UIColor+ReadBank.h
//  ReadBank
//
//  Created by MeetLucky on 2017/6/27.
//  Copyright © 2017年 杭州互办网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ReadBank)

/// 让原来的颜色变暗
- (instancetype)darken;


#pragma mark    根据色相创建颜色
/**
 根据色相创建颜色
 
 @param some 色相值
 @return 颜色
 */
+ (instancetype)colorWithSome:(CGFloat)some;


#pragma mark    快速设置颜色
/**
 快速设置颜色
 
 @param red   红色色相
 @param green 绿色色相
 @param blue  蓝色色相
 @return 颜色
 */
+ (instancetype)colorWithQuick:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;


/// 默认颜色设置
+ (instancetype)defaultColor;


/// 默认颜色加深一点
+ (instancetype)darkenColor;


/// UITableViewCell 选择的背景色
+ (instancetype)selectedColor;


/// UITableView 的空白处背景颜色
+ (instancetype)sectionColor;


/// 分割线颜色
+ (instancetype)lineColor;


/// 警告提示颜色
+ (instancetype)confirmColor;


/// 禁用颜色
+ (instancetype)disableColor;

@end
