//
//  ItemCollectionViewCell.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/13.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "ItemCollectionViewCell.h"

@interface ItemCollectionViewCell() 
@property (weak, nonatomic) IBOutlet UIImageView *contenView;
@property (weak, nonatomic) IBOutlet UIImageView *seletedView;
@property (weak, nonatomic) IBOutlet UIImageView *markView;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end

@implementation ItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

#pragma mark - 数据
-(void)setCellData:(NSDictionary *)cellData {
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWidth:) name:@"refreshWidth" object:nil];
//
//    [self layoutIfNeeded];
    
    //    if (![[cellData objectForKey:@"title"] isKindOfClass:[NSNull class]]) {
    //        self.lableTitle.text   = [cellData objectForKey:@"title"];
    //    }
    NSInteger data =[[cellData objectForKey:@"data"] integerValue];
    if (data > 0 && data < 7) {
        self.contenView.image = [UIImage imageNamed:[NSString stringWithFormat:@"number-%ld", data]];
    }else if(data > 10){
        self.contenView.image = [UIImage imageNamed:[NSString stringWithFormat:@"row-%ld", data - 10]];
    }else {
        self.contenView.image = nil;

    }
    
    if ([[cellData objectForKey:@"background"] boolValue]) {
        self.bgView.hidden = NO;
    }else {
        self.bgView.hidden = YES;
    }
    
    if ([[cellData objectForKey:@"mark"] boolValue]) {
        self.markView.hidden = NO;
    }else {
        self.markView.hidden = YES;
    }
    
    if ([[cellData objectForKey:@"seleted"] boolValue]) {
        self.seletedView.hidden = NO;
    }else {
        self.seletedView.hidden = YES;
    }
    
    if (self.isCenter) {
        if (data > 0 && data < 7) {
            self.contenView.image = [UIImage imageNamed:[NSString stringWithFormat:@"char-%ld", data]];
        }else {
            self.contenView.image = nil;
            
        }
    }
    
}

//- (void)refreshWidth:(NSNotification *)noti {
//    [self layoutIfNeeded];
//}
@end
