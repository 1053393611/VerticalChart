//
//  FMDBManager+TableList.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/17.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "FMDBManager+TableList.h"

@implementation FMDBManager (TableList)

- (BOOL)checkTableListExist:(FMDatabase *)db {
    NSString *sql = @"create table if not exists 'tbl_List' ('listId' VARCHAR PRIMARY KEY,'title' VARCHAR,'createTime' VARCHAR,'updateTime' VARCHAR,'row' INTEGER,'skip' INTEGER)";
    
    BOOL result = [db executeUpdate:sql];
    
    return result;
}


- (BOOL)insertTableList:(ListModel *)listModel{
    __block BOOL result = NO;
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"insert into tbl_List (listId,title,createTime,updateTime,row,skip) values ('%@','%@','%@','%@',%ld,%ld)", listModel.listId, listModel.title, listModel.createTime, listModel.updateTime, listModel.row, listModel.skip];
        
        BOOL result = [db executeUpdate:sql];
        if ( !result ) {
            *rollback = YES;
        }
    }];
    return result;

}

- (BOOL)updateTableList:(ListModel *)listModel {
    __block BOOL result = NO;
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"update tbl_List set title = '%@',createTime = '%@',updateTime = '%@',row = %ld,skip = %ld where listId = '%@'", listModel.title, listModel.createTime, listModel.updateTime, listModel.row, listModel.skip, listModel.listId];
        
        BOOL result = [db executeUpdate:sql];
        if ( !result ) {
            *rollback = YES;
        }
    }];
    return result;

}

- (BOOL)deleteTableList:(ListModel *)listModel {
    __block BOOL result = NO;
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"delete from tbl_List where listId = '%@'", listModel.listId];
        
        BOOL result = [db executeUpdate:sql];
        if ( !result ) {
            *rollback = YES;
        }
    }];
    return result;
    
}

- (NSMutableArray *)selectTableList:(NSString *)selectStr {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString *sql;
    if ([selectStr isEqualToString:@"title"]) {
        sql = [NSString stringWithFormat:@"select * from tbl_List order by %@ asc", selectStr];
    }else{
        sql = [NSString stringWithFormat:@"select * from tbl_List order by %@ desc", selectStr];
    }
    
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:sql];
        
        while ( [rs next] ) {
            ListModel *model = [ListModel listModelWithFMResultSet:rs];
            [list addObject:model];
        }
        
        [rs close];
    }];
    
    return list;
}




@end
