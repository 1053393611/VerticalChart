//
//  FileManager.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/17.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

#pragma mark     返回系统数据库路径
+ (NSString *)databaseForMasterPath {
    //    [FileManager databaseDirectory];    //  创建数据库目录
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ifeiluContact.sqlite"];
}


@end
