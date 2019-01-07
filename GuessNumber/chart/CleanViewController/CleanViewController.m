//
//  CleanViewController.m
//  chart
//
//  Created by 钟程 on 2018/10/12.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "CleanViewController.h"

@interface CleanViewController (){
    NSInteger _matchIndex;
}
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UIButton *cleanButton;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dataConstraint;
@property (strong, nonatomic) NSMutableArray *randonArray;

@end

@implementation CleanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customUI];
    
    
    _matchIndex = 0;
    [self getRandomNumber];

    
}

#pragma mark - customUI
- (void)customUI {
    if (self.isCleanAll) {
        self.label1.hidden = NO;
        self.label2.hidden = NO;
        self.dataConstraint.priority = UILayoutPriorityDefaultLow;
        [self.cleanButton setTitle:@"不要清空数据" forState:UIControlStateNormal];
    }else {
        self.label1.hidden = YES;
        self.label2.hidden = YES;
        self.dataConstraint.priority = UILayoutPriorityRequired;
        [self.cleanButton setTitle:@"继续修改本场" forState:UIControlStateNormal];
    }
    
    
}


#pragma mark - numberButton

- (IBAction)numberAction:(UIButton *)sender {
    
    NSInteger index = sender.tag - 100;
//    NSLog(@"%ld", index);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:self.dataLabel.attributedText];
    if (index == [self.randonArray[_matchIndex] integerValue]) {
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,_matchIndex + 1)];
        _matchIndex ++;
        if (_matchIndex == 3) {
            _matchIndex = 0;
            [self complete];
        }
    }else {
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSome:230] range:NSMakeRange(3,_matchIndex + 1)];
        _matchIndex = 0;
    }
    
    
    self.dataLabel.attributedText = str;
    
}




#pragma mark - 随机生成三个数
- (void)getRandomNumber {
    
    self.randonArray = [NSMutableArray array];
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9)]];
    for (int i = 0; i < 3; i ++) {
        int j = arc4random() % ( 9 - i );
        [self.randonArray addObject:array[j]];
        [array removeObjectAtIndex:j];
    }
    self.dataLabel.attributedText = [self getString];
}

- (NSAttributedString *)getString {
    
    NSMutableAttributedString *str;
    if (self.isCleanAll) {
        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"请输入%@%@%@以继续清空", self.randonArray[0],self.randonArray[1], self.randonArray[2]]];
    }else {
        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"请输入%@%@%@来结束本场", self.randonArray[0],self.randonArray[1], self.randonArray[2]]];
    }
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSome:230] range:NSMakeRange(3,3)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:35 weight:2] range:NSMakeRange(3,3)];
    [str addAttribute:NSStrokeWidthAttributeName value:@-3 range:NSMakeRange(3,3)];
    [str addAttribute:NSStrokeColorAttributeName value:[UIColor colorWithSome:50] range:NSMakeRange(3,3)];
    [str addAttribute:NSKernAttributeName value:@5 range:NSMakeRange(2,4)];

    return str;
}


#pragma mark - 完成处理
- (void)complete{
    
    if (self.isCleanAll) {
        // 清空所有
        [self deleteAll];
    }else {
        // 结束本场
        [self finish];
    }
    if ([_delegate respondsToSelector:@selector(reloadTableView)]) {
        [_delegate reloadTableView];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 返回
- (IBAction)backAction:(UIButton *)sender {
//    [self getRandomNumber];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 清空所有
- (void)deleteAll {
    [FMDB deleteTableList];
    [FMDB deleteDetail];
    NSString *listId = [[DataManager defaultManager] getNowTimeTimestamp];
    NSArray *dataArray = [[DataManager defaultManager] getData];
    
    ListModel *listModel = [ListModel modelWithListId:listId total:@"0" course:1 no:1 input:@"0.00" result:@"未开" thisAll:@"0"];
    [FMDB insertTableList:listModel];
    
    NSArray *nameArray = [dataArray valueForKeyPath:@"name"];
    [FMDB initDetail:listId name:nameArray];
    
    [[DataManager defaultManager] updateDataFromDatabase];
}

#pragma mark - 结束本场
- (void)finish {
    NSString *listId = [[DataManager defaultManager] getNowTimeTimestamp];
    NSArray *dataArray = [[DataManager defaultManager] getData];
    NSInteger course = [[dataArray.firstObject objectForKey:@"course"] integerValue] + 1;
    ListModel *listModel = [ListModel modelWithListId:listId total:@"0" course:course no:1 input:@"0.00" result:@"未开" thisAll:@"0"];
    [FMDB insertTableList:listModel];
    
    NSArray *nameArray = [dataArray valueForKeyPath:@"name"];
    [FMDB initDetail:listId name:nameArray];
    
    [[DataManager defaultManager] updateDataFromDatabase];
}


@end
