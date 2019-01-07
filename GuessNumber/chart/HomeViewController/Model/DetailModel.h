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
@property (nonatomic , copy) NSString              * result;       // 结果
@property (nonatomic , assign) NSInteger              row;         // 行数
@property (nonatomic , copy) NSString              * thisAll;      // 本筒金额
@property (nonatomic , copy) NSString              * update;       // 更新
@property (nonatomic , copy) NSString              * previous;     // 上一筒
@property (nonatomic , copy) NSString              * total;          // 本场总和
@property (nonatomic , copy) NSString              * name;         // 名称
@property (nonatomic , copy) NSString              * input;        // 投入
@property (nonatomic , copy) NSString              * updateAll;    // 查看总账更新

+ (DetailModel *)modelWithDetailId:(NSString *)detailId row:(NSInteger)row total:(NSString *)total name:(NSString *)name input:(NSString *)input result:(NSString *)result update:(NSString *)update thisAll:(NSString *)thisAll previous:(NSString *)previous;


+ (DetailModel *)detailModelWithFMResultSet:(FMResultSet *)rs;

+ (NSDictionary *)dictionaryWithDetailModel:(DetailModel *)model;

+ (DetailModel *)detailModelWithDictionary:(NSDictionary *)dic;

@end
