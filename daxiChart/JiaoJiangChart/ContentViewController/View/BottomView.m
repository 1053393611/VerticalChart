//
//  BottomView.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/14.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "BottomView.h"

@interface BottomView()

@end

@implementation BottomView

- (void)setButtonGray:(NSInteger)index{
    UIButton *button = [self viewWithTag:100 + index];
    button.enabled = NO;
    button.backgroundColor = [UIColor clearColor];
}

- (void)setButtonWhiter:(NSInteger)index{
    UIButton *button = [self viewWithTag:100 + index];
    button.enabled = YES;
    button.backgroundColor = [UIColor whiteColor];
}


- (void)setAllButtonGreen{
    for (int i = 1; i < 7; i++) {
        UIButton *button = [self viewWithTag:100 + i];
        button.enabled = YES;
        button.backgroundColor = [UIColor colorWithQuick:220 green:250 blue:220];
    }
}

- (void)setAllButtonWhiter{
    for (int i = 1; i < 7; i++) {
        UIButton *button = [self viewWithTag:100 + i];
        button.enabled = YES;
        button.backgroundColor = [UIColor whiteColor];
    }
}



@end
