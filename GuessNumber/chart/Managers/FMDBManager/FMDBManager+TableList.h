//
//  FMDBManager+TableList.h
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/17.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "FMDBManager.h"

@interface FMDBManager (TableList)

// 创建表
- (BOOL)checkTableListExist:(FMDatabase *)db;

// 插入
- (BOOL)insertTableList:(ListModel *)listModel;

// 更新
- (BOOL)updateTableList:(ListModel *)listModel;

// 删除
- (BOOL)deleteTableList:(ListModel *)listModel;

- (BOOL)deleteTableList;

// 选择
- (NSMutableArray *)selectTableList;

- (NSMutableArray *)selectTableList:(NSInteger)course;

- (NSMutableArray *)selectTableList:(NSInteger)course no:(NSInteger)no;

// 每一场的结果
- (NSMutableArray *)selectTableListResult;

@end
