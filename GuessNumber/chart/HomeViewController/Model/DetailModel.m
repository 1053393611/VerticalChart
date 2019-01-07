//
//  DetailModel.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/17.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

+ (DetailModel *)modelWithDetailId:(NSString *)detailId row:(NSInteger)row total:(NSString *)total name:(NSString *)name input:(NSString *)input result:(NSString *)result update:(NSString *)update thisAll:(NSString *)thisAll previous:(NSString *)previous{
    DetailModel *model = [[DetailModel alloc] init];
    model.detailId = detailId;
    model.row = row;
    model.total = total;
    model.name = name;
    model.input = input;
    model.result = result;
    model.update = update;
    model.thisAll = thisAll;
    model.previous = previous;
    model.updateAll = @"";
    
    return model;
}


+ (DetailModel *)detailModelWithFMResultSet:(FMResultSet *)rs{
    DetailModel *model = [[DetailModel alloc] init];
    model.detailId = [rs stringForColumn:@"detailId"];
    model.row = [rs longForColumn:@"row"];
    model.total = [rs stringForColumn:@"total"];
    model.name = [rs stringForColumn:@"name"];
    model.input = [rs stringForColumn:@"input"];
    model.result = [rs stringForColumn:@"result"];
    model.update = [rs stringForColumn:@"updateRow"];
    model.thisAll = [rs stringForColumn:@"thisAll"];
    model.previous = [rs stringForColumn:@"previous"];
    model.updateAll = [rs stringForColumn:@"updateAll"];

    return model;
}

+ (NSDictionary *)dictionaryWithDetailModel:(DetailModel *)model{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:model.detailId forKey:@"detailId"];
    [dic setObject:@(model.row) forKey:@"row"];
    [dic setObject:model.total forKey:@"total"];
    [dic setObject:model.name forKey:@"name"];
    [dic setObject:model.input forKey:@"input"];
    [dic setObject:model.result forKey:@"result"];
    [dic setObject:model.update forKey:@"update"];
    [dic setObject:model.thisAll forKey:@"thisAll"];
    [dic setObject:model.previous forKey:@"previous"];
    [dic setObject:model.updateAll forKey:@"updateAll"];

    return dic;
}

+ (DetailModel *)detailModelWithDictionary:(NSDictionary *)dic{
    DetailModel *model = [[DetailModel alloc] init];
    model.detailId = [dic objectForKey:@"detailId"];
    model.row = [[dic objectForKey:@"row"] integerValue];
    model.total = [dic objectForKey:@"total"] ;
    model.name = [dic objectForKey:@"name"];
    model.input = [dic objectForKey:@"input"];
    model.result = [dic objectForKey:@"result"];
    model.update = [dic objectForKey:@"update"];
    model.thisAll = [dic objectForKey:@"thisAll"];
    model.previous = [dic objectForKey:@"previous"];
    model.updateAll = [dic objectForKey:@"updateAll"];
    
    return model;

}


@end
