//
//  ItemCollectionViewCell.h
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/13.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *partLine;

@property (strong, nonatomic)NSDictionary *cellData;
@property (assign, nonatomic)BOOL isCenter;


@end
