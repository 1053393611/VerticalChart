//
//  DetailModel.h
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/17.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property (nonatomic , copy) NSString              * detailId;
@property (nonatomic , assign) NSInteger           row;       // 行
@property (nonatomic , assign) NSInteger           column;    // 列
@property (nonatomic , assign) NSInteger           mark;      // 半圆标志
@property (nonatomic , assign) NSInteger           data;      // 数字
@property (nonatomic , assign) NSInteger           background;      // 蓝色背景
@property (nonatomic , assign) NSInteger           seleted;      // 红色虚线框

+ (DetailModel *)initWithDetailId:(NSString *)detailId row:(NSInteger)row column:(NSInteger)column mark:(NSInteger)mark data:(NSInteger)data background:(NSInteger)background seleted:(NSInteger)seleted;


+ (DetailModel *)detailModelWithFMResultSet:(FMResultSet *)rs;

+ (NSDictionary *)dictionaryWithDetailModel:(DetailModel *)model;

+ (DetailModel *)detailModelWithDictionary:(NSDictionary *)dic;

@end
