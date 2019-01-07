//
//  FMDBManager.m
//  ifeiluContact
//
//  Created by iFeiLu on 15/12/31.
//  Copyright © 2015年 luyue.com. All rights reserved.
//

#import "FMDBManager.h"
#import "FileManager.h"

@implementation FMDBManager

+ (instancetype)sharedManager {
    static FMDBManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
        instance.master = [FMDatabaseQueue databaseQueueWithPath:[FileManager databaseForMasterPath]];
//        instance.queue  = [FMDatabaseQueue databaseQueueWithPath:[FileManager databaseForUserPath]];
    });
    
    return instance;
}

- (BOOL)checkBehaviorTableExist:(FMDatabase *)db {
    BOOL result = YES;
    
    if ( ![db open] ) {
        return NO;
    }
    
    result = result && [self checkTableListExist:db];
    result = result && [self checkDetailExist:db];
    
    [db close];
    
    NSLog(@"\n行为数据库路径:%@",[FileManager databaseForMasterPath]);
    
    return result;
}

//- (BOOL)checkUserTableExist:(FMDatabase *)db {
//    BOOL result = YES;
//    
//    if ( ![db  open] ) {
//        return NO;
//    }
//    
//    result = result && [self checkCompanyExist:db];
//    result = result && [self checkCompanySettingExist:db];
//    result = result && [self checkCardExist:db];
//    result = result && [self checkGroupExist:db];
//    result = result && [self checkMemberExist:db];
//    result = result && [self checkWhiteListExist:db];
//    result = result && [self checkBulltinExist:db];
//    result = result && [self checkCoterieExist:db];
//    
//    [db close];
//    
//    NSLog(@"\n用户数据库路径:%@",[FileManager databaseForUserPath]);
//    
//    return result;
//}


@end
