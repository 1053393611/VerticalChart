//
//  UpdateViewController.h
//  chart
//
//  Created by 钟程 on 2018/11/8.
//  Copyright © 2018 钟程. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdateViewController : UIViewController

@property (assign, nonatomic) NSInteger rowNo;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) void(^reloadTheVC)(void);
@end

NS_ASSUME_NONNULL_END
