//
//  TableViewCell.h
//  chart
//
//  Created by 钟程 on 2018/10/10.
//  Copyright © 2018 钟程. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell

@property (copy, nonatomic) NSDictionary *cellData;

@property (copy, nonatomic) NSString *text;

@end

NS_ASSUME_NONNULL_END
