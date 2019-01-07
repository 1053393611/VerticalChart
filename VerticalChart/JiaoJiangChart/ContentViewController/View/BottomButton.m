//
//  BottomButton.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/14.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "BottomButton.h"

@implementation BottomButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect rect = CGRectMake(5, 5, contentRect.size.width - 10, contentRect.size.height - 10);
    return rect;
    
}

@end
