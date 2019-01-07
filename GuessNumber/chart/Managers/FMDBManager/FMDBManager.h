//
//  FMDBManager.h
//  ifeiluContact
//
//  Created by iFeiLu on 15/12/31.
//  Copyright © 2015年 luyue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FMDB    [FMDBManager sharedManager]

@interface FMDBManager : NSObject

@property (strong, nonatomic) FMDatabaseQueue *master;
//@property (strong, nonatomic) FMDatabaseQueue *queue;

+ (instancetype)sharedManager;

- (BOOL)checkBehaviorTableExist:(FMDatabase *)db;
//- (BOOL)checkUserTableExist:(FMDatabase *)db;

@end
