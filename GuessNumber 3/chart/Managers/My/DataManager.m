//
//  DataManager.m
//  chart
//
//  Created by 钟程 on 2018/10/23.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "DataManager.h"

#define cellHeight 45

@interface DataManager ()

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *textArray;
@property (strong, nonatomic) NSMutableArray *heightArray;


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
    
    // 文字
    _textArray = [NSMutableArray array];
    for (int i = 0; i < cellMax; i ++) {
        if (i > 0) {
            NSString *str = [_dataArray[i] objectForKey:@"input"];
            if ([str containsString:@"\n"]) {
               NSString *text = [self textForString:str];
                [_textArray addObject:text];
            }else{
                [_textArray addObject:str];
            }
            
        }else{
            [_textArray addObject:@""];
        }
    }
    
    // 高度
    _heightArray = [NSMutableArray array];
    for (int i = 0; i < cellMax; i++) {
        if (i > 0) {
            NSString *text = _textArray[i];
            if ([text containsString:@"\n"]) {
                CGFloat inputHeight = [self heightForText:text];
                if (inputHeight > cellHeight) {
                    [_heightArray addObject:@(inputHeight)];
                }else{
                    [_heightArray addObject:@(cellHeight)];
                }
            }else{
                [_heightArray addObject:@(cellHeight)];
            }
        }else{
            [_heightArray addObject:@(cellHeight)];
        }
    }
    return _dataArray;
    
}

-(NSMutableArray *)updateDataFromDatabase{
    
    [_dataArray removeAllObjects];
    NSArray *firstArray = [FMDB selectTableList];
    [_dataArray addObject:firstArray.firstObject];
    NSString *listId = [firstArray.firstObject objectForKey:@"listId"];
    
    NSArray *sArray = [FMDB selectDetail:listId];
    [_dataArray addObjectsFromArray:sArray];
    
    // 文字
    [_textArray removeAllObjects];
    for (int i = 0; i < cellMax; i ++) {
        if (i > 0) {
            NSString *str = [_dataArray[i] objectForKey:@"input"];
            if ([str containsString:@"\n"]) {
                NSString *text = [self textForString:str];
                [_textArray addObject:text];
            }else{
                [_textArray addObject:str];
            }
            
        }else{
            [_textArray addObject:@""];
        }
    }
    
    // 高度
    [_heightArray removeAllObjects];
    for (int i = 0; i < cellMax; i++) {
        if (i > 0) {
            NSString *text = _textArray[i];
            if ([text containsString:@"\n"]) {
                CGFloat inputHeight = [self heightForText:text];
                if (inputHeight > cellHeight) {
                    [_heightArray addObject:@(inputHeight)];
                }else{
                    [_heightArray addObject:@(cellHeight)];
                }
            }else{
                [_heightArray addObject:@(cellHeight)];
            }
        }else{
            [_heightArray addObject:@(cellHeight)];
        }
    }
    return _dataArray;
    
}

-(void)updateDataWithDictionary:(NSDictionary *)dic{
    
    if ([[dic allKeys] containsObject:@"listId"]) {
        [_dataArray replaceObjectAtIndex:0 withObject:dic];
    }else {
        NSInteger row = [[dic objectForKey:@"row"] integerValue];
        [_dataArray replaceObjectAtIndex:row withObject:dic];
        
        // 文字
        NSString *str = [dic objectForKey:@"input"];
        if ([str containsString:@"\n"]) {
            NSString *text = [self textForString:str];
            [_textArray replaceObjectAtIndex:row withObject:text];
        }else{
            [_textArray replaceObjectAtIndex:row withObject:str];
        }
        
        NSString *text = _textArray[row];
        if ([text containsString:@"\n"]) {
            CGFloat inputHeight = [self heightForText:text];
            if (inputHeight > cellHeight) {
                [_heightArray replaceObjectAtIndex:row withObject:@(inputHeight)];
            }else{
                [_heightArray replaceObjectAtIndex:row withObject:@(cellHeight)];
            }
        }else{
            [_heightArray replaceObjectAtIndex:row withObject:@(cellHeight)];
        }
    }
    
}

-(NSMutableArray *)getData{
    return _dataArray;
}

-(NSMutableArray *)getHeight{
    return _heightArray;
}

-(NSMutableArray *)getText{
    return _textArray;
}

#pragma mark - 计算高度
- (CGFloat)heightForText:(NSString *)str{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    //    CGFloat width;
    CGFloat width = HBScreenWidth * 169 / 560.f + 30;
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} context:nil];
    
    CGFloat realHeight = ceilf(rect.size.height);
    return realHeight + 20;
}

#pragma mark - text
- (NSString *)textForString:(NSString *)string {
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    NSString *text = @"";
    for (int i = 0; i < array.count; i++) {
        if (i == array.count - 1) {
            text = [text stringByAppendingString:[NSString stringWithFormat:@"%@",array[i]]];
        }else {
            if ((i + 1) % 3 == 0) {
                text = [text stringByAppendingString:[NSString stringWithFormat:@"%@\n",array[i]]];
            }else{
                NSString *str = array[i];
                text = [text stringByAppendingString:str];
                if (str.length < 5) {
                    for (int j = 0; j <5; j++) {
                        text = [text stringByAppendingString:@" "];
                    }
                }
                if (str.length < 10) {
                    if (str.length > 7) {
                        if ([str containsString:@"."]) {
                            for (int j = 0; j <15 - str.length; j++) {
                                text = [text stringByAppendingString:@" "];
                            }
                        }else{
                            for (int j = 0; j <10 - str.length; j++) {
                                text = [text stringByAppendingString:@" "];
                            }
                        }
                       
                    }else{
                        for (int j = 0; j <15 - str.length; j++) {
                            text = [text stringByAppendingString:@" "];
                        }
                    }
                }
//                NSLog(@"%@,%ld",text,text.length);
                text = [text stringByAppendingString:@"\t"];
            }
        }
    }
    return text;
}


@end
