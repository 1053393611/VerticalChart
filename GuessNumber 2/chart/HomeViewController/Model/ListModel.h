//
//  ListModel.h
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/17.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject

@property (nonatomic , copy) NSString              * listId;
@property (nonatomic , assign) NSInteger              course;   // 场次
@property (nonatomic , assign) NSInteger              no;       // 第几筒
@property (nonatomic , copy) NSString              * result;    // 开牌结果
@property (nonatomic , copy) NSString              * total;       // 本场总账
@property (nonatomic , copy) NSString              * thisAll;   // 本筒
@property (nonatomic , copy) NSString              * input;     // 投入金额
@property (nonatomic , assign) NSInteger              hidden;   // 查看总账 是否排除

+ (ListModel *)modelWithListId:(NSString *)listId total:(NSString *)total course:(NSInteger)course no:(NSInteger)no input:(NSString *)input result:(NSString *)result thisAll:(NSString *)thisAll;

+ (ListModel *)listModelWithFMResultSet:(FMResultSet *)rs;

+ (NSDictionary *)dictionaryWithListModel:(ListModel *)model;

+ (ListModel *)listModelWithDictionary:(NSDictionary *)dic;

@end
