//
//  MoneyResult.m
//  chart
//
//  Created by 钟程 on 2018/10/20.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "MoneyResult.h"

static MoneyResult* _instance = nil;

@implementation MoneyResult

+(instancetype) defaultInit
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance ;
}

-(CGFloat)getResultWithString:(NSString *)string number:(NSInteger)number{
    
    CGFloat result = 0;
    NSArray *array = [string componentsSeparatedByString:@"/"];
    
    NSString *guessString = array.firstObject;
    NSString *moneyString = array.lastObject;
    CGFloat money = [moneyString floatValue]/10;
    result = -money;
    
    if ([guessString containsString:@"."]) {
        // 有.
        CGFloat re = 0;
        if(array.count == 3){
            re = -money;
            NSString *guess = [guessString stringByReplacingOccurrencesOfString:@"." withString:@""];
            if (guess.length == 2){
                // 有两个数
                NSString *f = [guess substringToIndex:1];
                NSString *s = [guess substringFromIndex:1];
                if ([f integerValue] == number || [s integerValue] == number) {
                    if (number == 1) {
                        // 猜中1
                        re = money * 1.5;
                    }else {
                        // 猜中其他数（2-6）
                        re = money * 2;
                    }
                }
                
            }else {
                // 有三个数
                NSString *f = [guess substringToIndex:1];
                NSString *s = [guess substringWithRange:NSMakeRange(1, 1)];
                NSString *t = [guess substringFromIndex:2];
                if ([f integerValue] == number || [s integerValue] == number || [t integerValue] == number) {
                    if (number == 1) {
                        // 猜中1
                        re = money * 0.7;
                    }else {
                        // 猜中其他数（2-6）
                        re = money * 1;
                    }
                }
                
            }
            moneyString = array[1];
            money = [moneyString floatValue]/10;
            result = - money;
        }
        
        NSArray *a = [guessString componentsSeparatedByString:@"."];
        NSString *first = a.firstObject;
        NSString *last = a.lastObject;
        if (last.length == 1) {
            // 小数点后只有一个数
            if ([first integerValue] == number) {
                // 猜中.前面的数
                if ([first integerValue] == 1) {
                    // 1在.前面
                    result = money * 3.2;
                }else if ([last integerValue] == 1){
                    // 1在.后面
                    result = money * 3.8;
                }else {
                    // 没有1
                    result = money * 4;
                }
            }else if ([last integerValue] == number){
                // 猜中.后面的数
                result = 0;
            }
            
        }else {
            // 小数点后有两个数
            NSString *f = [last substringToIndex:1];
            NSString *s = [last substringFromIndex:1];
            if ([first integerValue] == number) {
                // 猜中.前面的数
                if ([first integerValue] == 1) {
                    // 1在.前面
                    result = money * 2.4;
                }else if ([f integerValue] == 1 || [s integerValue] == 1){
                    // 1在.后面
                    result = money * 2.8;
                }else {
                    // 没有1
                    result = money * 3;
                }
            }else if ([f integerValue] == number || [s integerValue] == number){
                // 猜中.后面的数
                result = 0;
            }
            
        }
        result = result + re;
        
    }else if ([guessString containsString:@">"]){
        // 有>
        CGFloat re = 0;
        if(array.count == 3){
            re = -money;
            NSString *guess = [guessString stringByReplacingOccurrencesOfString:@">" withString:@""];
            if (guess.length == 2){
                // 有两个数
                NSString *f = [guess substringToIndex:1];
                NSString *s = [guess substringFromIndex:1];
                if ([f integerValue] == number || [s integerValue] == number) {
                    if (number == 1) {
                        // 猜中1
                        re = money * 1.5;
                    }else {
                        // 猜中其他数（2-6）
                        re = money * 2;
                    }
                }
                
            }else {
                // 有三个数
                NSString *f = [guess substringToIndex:1];
                NSString *s = [guess substringWithRange:NSMakeRange(1, 1)];
                NSString *t = [guess substringFromIndex:2];
                if ([f integerValue] == number || [s integerValue] == number || [t integerValue] == number) {
                    if (number == 1) {
                        // 猜中1
                        re = money * 0.7;
                    }else {
                        // 猜中其他数（2-6）
                        re = money * 1;
                    }
                }
                
            }
            moneyString = array[1];
            money = [moneyString floatValue]/10;
            result = - money;
        }
        
        NSArray *a = [guessString componentsSeparatedByString:@">"];
        NSString *first = a.firstObject;
        NSString *last = a.lastObject;
        if ([first integerValue] == number) {
            // 猜中>前面的数
            if ([first integerValue] == 1) {
                // 1在>前面
                result = money * 2.4;
            }else if ([last integerValue] == 1){
                // 1在>后面
                result = money * 2.6;
            }else {
                // 没有1
                result = money * 3;
            }
        }else if ([last integerValue] == number){
            // 猜中>后面的数
            result = money * 1;
        }
        result = result + re;
    }else {
        // 只有数字
        if (guessString.length == 1) {
            // 只有一个数
            if ([guessString integerValue] == number) {
                if (number == 1) {
                    // 猜中1
                    result = money * 4;
                }else {
                    // 猜中其他数（2-6）
                    result = money * 5;
                }
            }
            
        }else if (guessString.length == 2){
            // 有两个数
            NSString *f = [guessString substringToIndex:1];
            NSString *s = [guessString substringFromIndex:1];
            if ([f integerValue] == number || [s integerValue] == number) {
                if (number == 1) {
                    // 猜中1
                    result = money * 1.5;
                }else {
                    // 猜中其他数（2-6）
                    result = money * 2;
                }
            }
            
        }else {
            // 有三个数
            NSString *f = [guessString substringToIndex:1];
            NSString *s = [guessString substringWithRange:NSMakeRange(1, 1)];
            NSString *t = [guessString substringFromIndex:2];
            if ([f integerValue] == number || [s integerValue] == number || [t integerValue] == number) {
                if (number == 1) {
                    // 猜中1
                    result = money * 0.7;
                }else {
                    // 猜中其他数（2-6）
                    result = money * 1;
                }
            }
            
        }
        
    }
    NSString *str =[NSString stringWithFormat:@"%.5f", result];
    if ([str containsString:@"."] &&![str containsString:@"-"]) {
        NSArray *array = [str componentsSeparatedByString:@"."];
        NSString *s = [array.lastObject substringWithRange:NSMakeRange(3, 1)];
        
        if ([s isEqualToString:@"1"] || [s isEqualToString:@"2"] || [s isEqualToString:@"3"] || [s isEqualToString:@"4"]) {
            result = result + 0.001;
        }
    }
    
    return result;
    
}


@end
