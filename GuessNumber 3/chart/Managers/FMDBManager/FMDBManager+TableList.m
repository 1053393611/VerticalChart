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
    NSString *sql = @"create table if not exists 'tbl_List' ('listId' VARCHAR PRIMARY KEY,'total' VARCHAR,'course' INTEGER,'no' INTEGER,'input' VARCHAR,'result' VARCHAR,'thisAll' VARCHAR,'hidden' INTEGER)";
    
    BOOL result = [db executeUpdate:sql];
    
    return result;
}


- (BOOL)insertTableList:(ListModel *)listModel{
    __block BOOL result = NO;
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"insert into tbl_List (listId,total,course,no,input,result,thisAll,hidden) values ('%@','%@',%ld,%ld,'%@','%@','%@',%ld)", listModel.listId, listModel.total, listModel.course, listModel.no, listModel.input, listModel.result, listModel.thisAll, listModel.hidden];
//        NSString *sql = [NSString stringWithFormat:@"insert into tbl_List(all) values ('1')"];
        
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
        NSString *sql = [NSString stringWithFormat:@"update tbl_List set total = '%@',course = %ld,no = %ld,input = '%@',result = '%@',thisAll = '%@',hidden = %ld where listId = '%@'", listModel.total, listModel.course, listModel.no, listModel.input, listModel.result, listModel.thisAll, listModel.hidden, listModel.listId];
        
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

- (BOOL)deleteTableList {
    __block BOOL result = NO;
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"delete from tbl_List"];
        
        BOOL result = [db executeUpdate:sql];
        if ( !result ) {
            *rollback = YES;
        }
    }];
    return result;
    
}

- (NSMutableArray *)selectTableList {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString *sql = @"select * from tbl_List order by course desc, no desc";
    
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:sql];
        
        while ( [rs next] ) {
            ListModel *model = [ListModel listModelWithFMResultSet:rs];
            NSDictionary *dic = [ListModel dictionaryWithListModel:model];
            [list addObject:dic];
        }
        
        [rs close];
    }];
    
    return list;
}

- (NSMutableArray *)selectTableList:(NSInteger)course {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"select * from tbl_List where course = %ld order by no desc", course];
    
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:sql];
        
        while ( [rs next] ) {
            ListModel *model = [ListModel listModelWithFMResultSet:rs];
            NSDictionary *dic = [ListModel dictionaryWithListModel:model];
            [list addObject:dic];
        }
        
        [rs close];
    }];
    
    return list;
}

- (NSMutableArray *)selectTableList:(NSInteger)course no:(NSInteger)no {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"select * from tbl_List where course = %ld and no < %ld order by no desc", course, no];
    
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:sql];
        
        while ( [rs next] ) {
            ListModel *model = [ListModel listModelWithFMResultSet:rs];
            NSDictionary *dic = [ListModel dictionaryWithListModel:model];
            [list addObject:dic];
        }
        
        [rs close];
    }];
    
    return list;
}

- (NSMutableArray *)selectTableListResult{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString *sql = @"select * from tbl_List GROUP BY course order by course,no desc";
    
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:sql];
        
        while ( [rs next] ) {
            ListModel *model = [ListModel listModelWithFMResultSet:rs];
            NSDictionary *dic = [ListModel dictionaryWithListModel:model];
            [list addObject:dic];
        }
        
        [rs close];
    }];
    
    return list;
}



@end
