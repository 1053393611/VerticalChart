//
//  ListModel.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/17.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

+ (ListModel *)modelWithListId:(NSString *)listId total:(NSString *)total course:(NSInteger)course no:(NSInteger)no input:(NSString *)input result:(NSString *)result thisAll:(NSString *)thisAll{
    ListModel *model = [[ListModel alloc] init];
    model.listId = listId;
    model.total = total;
    model.course = course;
    model.no = no;
    model.input = input;
    model.result = result;
    model.thisAll = thisAll;
    model.hidden = 0;
    
    return model;
}

+ (ListModel *)listModelWithFMResultSet:(FMResultSet *)rs{
    ListModel *model = [[ListModel alloc] init];
    model.listId = [rs stringForColumn:@"listId"];
    model.total = [rs stringForColumn:@"total"];
    model.course = [rs longForColumn:@"course"];
    model.no = [rs longForColumn:@"no"];
    model.input = [rs stringForColumn:@"input"];
    model.result = [rs stringForColumn:@"result"];
    model.thisAll = [rs stringForColumn:@"thisAll"];
    model.hidden = [rs longForColumn:@"hidden"];

    return model;
}

+ (NSDictionary *)dictionaryWithListModel:(ListModel *)model{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:model.listId forKey:@"listId"];
    [dic setObject:model.total forKey:@"total"];
    [dic setObject:@(model.course) forKey:@"course"];
    [dic setObject:@(model.no) forKey:@"no"];
    [dic setObject:model.input forKey:@"input"];
    [dic setObject:model.result forKey:@"result"];
    [dic setObject:model.thisAll forKey:@"thisAll"];
    [dic setObject:@(model.hidden) forKey:@"hidden"];

    return dic;
}


+ (ListModel *)listModelWithDictionary:(NSDictionary *)dic{
    ListModel *model = [[ListModel alloc] init];
    model.listId = [dic objectForKey:@"listId"];
    model.total = [dic objectForKey:@"total"];
    model.course = [[dic objectForKey:@"course"] integerValue];
    model.no = [[dic objectForKey:@"no"] integerValue];
    model.input = [dic objectForKey:@"input"];
    model.result = [dic objectForKey:@"result"];
    model.thisAll = [dic objectForKey:@"thisAll"];
    model.hidden = [[dic objectForKey:@"hidden"] integerValue];
    
    return model;
}


@end
