//
//  DetailModel.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/17.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

+ (DetailModel *)initWithDetailId:(NSString *)detailId row:(NSInteger)row column:(NSInteger)column mark:(NSInteger)mark data:(NSInteger)data background:(NSInteger)background seleted:(NSInteger)seleted{
    DetailModel *model = [[DetailModel alloc] init];
    model.detailId = detailId;
    model.row = row;
    model.column = column;
    model.mark = mark;
    model.data = data;
    model.background = background;
    model.seleted = seleted;
    
    return model;
}


+ (DetailModel *)detailModelWithFMResultSet:(FMResultSet *)rs{
    DetailModel *model = [[DetailModel alloc] init];
    model.detailId = [rs stringForColumn:@"detailId"];
    model.row = [rs longForColumn:@"row"];
    model.column = [rs longForColumn:@"column"];
    model.mark = [rs longForColumn:@"mark"];
    model.data = [rs longForColumn:@"data"];
    model.background = [rs longForColumn:@"background"];
    model.seleted = [rs longForColumn:@"seleted"];
    
    return model;
}

+ (NSDictionary *)dictionaryWithDetailModel:(DetailModel *)model{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:model.detailId forKey:@"detailId"];
    [dic setObject:@(model.row) forKey:@"row"];
    [dic setObject:@(model.column) forKey:@"column"];
    [dic setObject:@(model.mark) forKey:@"mark"];
    [dic setObject:@(model.data) forKey:@"data"];
    [dic setObject:@(model.background) forKey:@"background"];
    [dic setObject:@(model.seleted) forKey:@"seleted"];

    return dic;
}

+ (DetailModel *)detailModelWithDictionary:(NSDictionary *)dic{
    DetailModel *model = [[DetailModel alloc] init];
    model.detailId = [dic objectForKey:@"detailId"];
    model.row = [[dic objectForKey:@"row"] integerValue];
    model.column = [[dic objectForKey:@"column"] integerValue];
    model.mark = [[dic objectForKey:@"mark"] integerValue];
    model.data = [[dic objectForKey:@"data"] integerValue];
    model.background = [[dic objectForKey:@"background"] integerValue];
    model.seleted = [[dic objectForKey:@"seleted"] integerValue];
    
    return model;

}


@end
