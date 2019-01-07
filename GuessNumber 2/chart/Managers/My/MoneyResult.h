//
//  MoneyResult.h
//  chart
//
//  Created by 钟程 on 2018/10/20.
//  Copyright © 2018 钟程. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoneyResult : NSObject

+(instancetype) defaultInit;

-(CGFloat)getResultWithString:(NSString *)string number:(NSInteger)number;

@end

NS_ASSUME_NONNULL_END
