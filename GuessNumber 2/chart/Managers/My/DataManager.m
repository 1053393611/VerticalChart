//
//  DataManager.m
//  chart
//
//  Created by 钟程 on 2018/10/23.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "DataManager.h"


@interface DataManager ()

@property (strong, nonatomic) NSMutableArray *dataArray;

@end


static DataManager* _instance = nil;

@implementation DataManager

+(instancetype) defaultManager
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    }) ;
    return _instance ;
}

#pragma mark - 字典和数组转换成json字符串
-(NSString *)stringTOjson:(id)temps
{
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:temps
                                                      options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc] initWithData:jsonData
                                        encoding:NSUTF8StringEncoding];
    return str;
    
}

- (NSArray *)stringFromJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                return tmp;
            } else if([tmp isKindOfClass:[NSString class]] || [tmp isKindOfClass:[NSDictionary class]]) {
                return [NSArray arrayWithObject:tmp];
            } else {
                return nil;
            }
        }else {
            return nil;
        }
        
    } else {
        return nil;
    }
}

#pragma mark - 获取时间戳 用于作为表的主键值
-(NSString *)getNowTimeTimestamp{
    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}


#pragma mark - 数据获取，存储，修改
-(NSMutableArray *)getDataFromDatabase{
    
    _dataArray = [NSMutableArray array];
    NSArray *firstArray = [FMDB selectTableList];
    [_dataArray addObject:firstArray.firstObject];
    NSString *listId = [firstArray.firstObject objectForKey:@"listId"];
    
    NSArray *sArray = [FMDB selectDetail:listId];
    [_dataArray addObjectsFromArray:sArray];
    return _dataArray;
    
}

-(NSMutableArray *)updateDataFromDatabase{
    
    [_dataArray removeAllObjects];
    NSArray *firstArray = [FMDB selectTableList];
    [_dataArray addObject:firstArray.firstObject];
    NSString *listId = [firstArray.firstObject objectForKey:@"listId"];
    
    NSArray *sArray = [FMDB selectDetail:listId];
    [_dataArray addObjectsFromArray:sArray];
    return _dataArray;
    
}

-(void)updateDataWithDictionary:(NSDictionary *)dic{
    
    if ([[dic allKeys] containsObject:@"listId"]) {
        [_dataArray replaceObjectAtIndex:0 withObject:dic];
    }else {
        NSInteger row = [[dic objectForKey:@"row"] integerValue];
        [_dataArray replaceObjectAtIndex:row withObject:dic];
    }
    
}

-(NSArray *)getData{
    return _dataArray;
}




@end
