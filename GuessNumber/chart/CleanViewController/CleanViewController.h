//
//  CleanViewController.h
//  chart
//
//  Created by 钟程 on 2018/10/12.
//  Copyright © 2018 钟程. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CleanDelegate <NSObject>
- (void)reloadTableView; //声明协议方法
@end

@interface CleanViewController : UIViewController

@property (assign, nonatomic) BOOL isCleanAll;           // YES:清空全部数据 NO:结束本场
@property (nonatomic, weak)id<CleanDelegate> delegate; //声明协议变量

@end

NS_ASSUME_NONNULL_END
