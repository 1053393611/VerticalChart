//
//  ListModel.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/17.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel


+ (ListModel *)listModelWithFMResultSet:(FMResultSet *)rs{
    ListModel *model = [[ListModel alloc] init];
    model.listId = [rs stringForColumn:@"listId"];
    model.title = [rs stringForColumn:@"title"];
    model.createTime = [rs stringForColumn:@"createTime"];
    model.updateTime = [rs stringForColumn:@"updateTime"];
    model.row = [rs longForColumn:@"row"];
    model.skip = [rs longForColumn:@"skip"];

    return model;
}

+ (NSDictionary *)dictionaryWithListModel:(ListModel *)model{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:model.listId forKey:@"listId"];
    [dic setObject:model.title forKey:@"title"];
    [dic setObject:model.createTime forKey:@"createTime"];
    [dic setObject:model.updateTime forKey:@"updateTime"];
    [dic setObject:@(model.row) forKey:@"row"];
    [dic setObject:@(model.skip) forKey:@"skip"];

    return dic;
}



@end
