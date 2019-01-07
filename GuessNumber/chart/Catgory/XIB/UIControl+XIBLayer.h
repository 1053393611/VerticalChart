//
//  UIControl+XIBLayer.h
//  testIBInspectable
//
//  Created by 胡泽超 on 2018/1/17.
//  Copyright © 2018年 胡泽超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (XIBLayer)

@property (nonatomic, assign) IBInspectable CGFloat cornerRadious;
@property (nonatomic, assign) IBInspectable BOOL masksToBounds;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

@end
