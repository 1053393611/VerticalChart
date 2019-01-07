//
//  KeyboardView.h
//  chart
//
//  Created by 钟程 on 2018/10/15.
//  Copyright © 2018 钟程. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyboardView : UIView

@property (copy, nonatomic) NSDictionary *cellData;

// 初始化键盘状态
- (void)customKeyboardView:(NSString *)string;
//- (void)moneyStatus:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
