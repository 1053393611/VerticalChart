//
//  PreViewController.h
//  chart
//
//  Created by 钟程 on 2018/10/30.
//  Copyright © 2018 钟程. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreViewController : UIViewController

@property (assign, nonatomic) NSInteger course;
@property (assign, nonatomic) NSInteger no;
@property (nonatomic, strong) void(^reloadTheVC)(void);
@end

NS_ASSUME_NONNULL_END
