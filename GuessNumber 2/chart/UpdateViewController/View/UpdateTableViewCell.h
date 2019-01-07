//
//  UpdateTableViewCell.h
//  chart
//
//  Created by 钟程 on 2018/11/9.
//  Copyright © 2018 钟程. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdateTableViewCell : UITableViewCell

@property (copy, nonatomic) NSString *cellData;
@property (nonatomic, strong) void(^deleteHandler)(NSInteger);



@end

NS_ASSUME_NONNULL_END
