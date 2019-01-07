//
//  FMDBManager+Detail.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/17.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "FMDBManager+Detail.h"

@implementation FMDBManager (Detail)


- (BOOL)checkDetailExist:(FMDatabase *)db {
    NSString *sql = @"create table if not exists 'tbl_Detail' ('detailId' VARCHAR,'row' INTEGER,'total' VARCHAR,'name' VARCHAR,'input' VARCHAR,'result' VARCHAR,'updateRow' VARCHAR,'thisAll' VARCHAR,'previous' VARCHAR,'updateAll' VARCHAR)";
    
    BOOL result = [db executeUpdate:sql];
    
    return result;
}

- (BOOL)initDetail:(NSString *)detailId{
    __block BOOL result = NO;
    
    for (int i = 1; i < cellMax; i++) {
       
        [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"insert into tbl_Detail (detailId,row,total,name,input,result,updateRow,thisAll,previous,updateAll) values ('%@',%d,'','','','','','','','')", detailId, i];
            
            BOOL result = [db executeUpdate:sql];
            if ( !result ) {
                *rollback = YES;
            }
        }];
        
    }
    
    
    return result;
}

- (BOOL)initDetail:(NSString *)detailId name:(NSArray *)nameArray{
    __block BOOL result = NO;
    
    for (int i = 1; i < cellMax; i++) {
        
        [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"insert into tbl_Detail (detailId,row,total,name,input,result,updateRow,thisAll,previous,updateAll) values ('%@',%d,'','%@','','','','','','')", detailId, i, nameArray[i]];
            
            BOOL result = [db executeUpdate:sql];
            if ( !result ) {
                *rollback = YES;
            }
        }];
        
    }
    
    
    return result;
}

- (BOOL)initDetail:(NSString *)detailId all:(NSArray *)allArray name:(NSArray *)nameArray pre:(NSArray *)preArray{
    __block BOOL result = NO;
    
    for (int i = 1; i < cellMax; i++) {
        
        [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"insert into tbl_Detail (detailId,row,total,name,input,result,updateRow,thisAll,previous,updateAll) values ('%@',%d,'%@','%@','','','','','%@','')", detailId, i,allArray[i],nameArray[i], preArray[i]];
            
            BOOL result = [db executeUpdate:sql];
            if ( !result ) {
                *rollback = YES;
            }
        }];
        
    }
    
    
    return result;
}



- (BOOL)updateDetail:(DetailModel *)model{
    __block BOOL result = NO;
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"update tbl_Detail set total = '%@',name = '%@',input = '%@',result = '%@',updateRow = '%@',thisAll = '%@',previous = '%@',updateAll = '%@' where detailId = '%@' and row = %ld", model.total, model.name, model.input, model.result, model.update, model.thisAll, model.previous, model.updateAll, model.detailId, (long)model.row];
        
        BOOL result = [db executeUpdate:sql];
        if ( !result ) {
            *rollback = YES;
        }
    }];
    return result;
    
}

- (BOOL)updateDetailAboutName:(DetailModel *)model{
    __block BOOL result = NO;
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"update tbl_Detail set name = '%@' where row = %ld", model.name,(long)model.row];
        
        BOOL result = [db executeUpdate:sql];
        if ( !result ) {
            *rollback = YES;
        }
    }];
    return result;
    
}

- (BOOL)ExchangeDetail:(NSInteger)row and:(NSInteger)index{
    __block BOOL result = NO;
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"update tbl_Detail set row = -1 where row = %ld", (long)row];
        
        BOOL result = [db executeUpdate:sql];
        if ( !result ) {
            *rollback = YES;
        }
    }];
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"update tbl_Detail set row = %ld where row = %ld", (long)row, (long)index];
        
        BOOL result = [db executeUpdate:sql];
        if ( !result ) {
            *rollback = YES;
        }
    }];
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"update tbl_Detail set row = %ld where row = -1", (long)index];
        
        BOOL result = [db executeUpdate:sql];
        if ( !result ) {
            *rollback = YES;
        }
    }];
    return result;
}

- (BOOL)deleteDetail:(NSString *)detailId{
    __block BOOL result = NO;
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"delete from tbl_Detail where detailId = '%@'", detailId];
        
        BOOL result = [db executeUpdate:sql];
        if ( !result ) {
            *rollback = YES;
        }
    }];
    return result;
    
}

- (BOOL)deleteDetail{
    __block BOOL result = NO;
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"delete from tbl_Detail"];
        
        BOOL result = [db executeUpdate:sql];
        if ( !result ) {
            *rollback = YES;
        }
    }];
    return result;
    
}

- (NSMutableArray *)selectDetail:(NSString *)detailId{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"select * from tbl_Detail where detailId = '%@' order by row asc", detailId];
    
    
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:sql];
        
        while ( [rs next] ) {
            DetailModel *model = [DetailModel detailModelWithFMResultSet:rs];
            NSDictionary *dic = [DetailModel dictionaryWithDetailModel:model];
            [list addObject:dic];
        }
        
        [rs close];
    }];
    
    return list;
}





@end
