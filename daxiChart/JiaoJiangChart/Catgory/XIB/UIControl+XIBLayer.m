//
//  UIControl+XIBLayer.m
//  testIBInspectable
//
//  Created by 胡泽超 on 2018/1/17.
//  Copyright © 2018年 胡泽超. All rights reserved.
//

#import "UIControl+XIBLayer.h"

@implementation UIControl (XIBLayer)
- (CGFloat)cornerRadious {
    return self.layer.cornerRadius;
}

- (void)setCornerRadious:(CGFloat)cornerRadious {
    self.layer.cornerRadius = cornerRadious;
}

- (BOOL)masksToBounds {
    return self.layer.masksToBounds;
}

- (void)setMasksToBounds:(BOOL)masksToBounds {
    self.layer.masksToBounds = masksToBounds;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

-(CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

@end
