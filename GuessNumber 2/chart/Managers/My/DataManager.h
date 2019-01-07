//
//  DataManager.h
//  chart
//
//  Created by 钟程 on 2018/10/23.
//  Copyright © 2018 钟程. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

+(instancetype) defaultManager;

-(NSString *)stringTOjson:(id)temps;
-(NSArray *)stringFromJSON:(NSString *)jsonStr;

-(NSString *)getNowTimeTimestamp;


// 从数据库获取数据
-(NSMutableArray *)getDataFromDatabase;

-(NSMutableArray *)updateDataFromDatabase;

// 更新数据
-(void)updateDataWithDictionary:(NSDictionary *)dic;

// 得到数据
-(NSArray *)getData;

@end

NS_ASSUME_NONNULL_END
