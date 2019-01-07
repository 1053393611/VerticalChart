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
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , assign) NSInteger             row;
@property (nonatomic , assign) NSInteger             skip;



+ (ListModel *)listModelWithFMResultSet:(FMResultSet *)rs;

+ (NSDictionary *)dictionaryWithListModel:(ListModel *)model;

@end
