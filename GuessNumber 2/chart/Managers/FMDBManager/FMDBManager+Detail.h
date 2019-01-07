//
//  FMDBManager+Detail.h
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/17.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "FMDBManager.h"

@interface FMDBManager (Detail)

// 创建表
- (BOOL)checkDetailExist:(FMDatabase *)db;

// 初始化数据
- (BOOL)initDetail:(NSString *)detailId;

- (BOOL)initDetail:(NSString *)detailId name:(NSArray *)nameArray;

- (BOOL)initDetail:(NSString *)detailId all:(NSArray *)allArray name:(NSArray *)nameArray pre:(NSArray *)preArray;

// 更新
- (BOOL)updateDetail:(DetailModel *)model;

- (BOOL)updateDetailAboutName:(DetailModel *)model;

- (BOOL)ExchangeDetail:(NSInteger)row and:(NSInteger)index;

// 删除全部
- (BOOL)deleteDetail:(NSString *)detailId;

- (BOOL)deleteDetail;

// 选择
- (NSMutableArray *)selectDetail:(NSString *)detailId;

@end
