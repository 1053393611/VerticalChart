//
//  PreTableViewCell.m
//  chart
//
//  Created by 钟程 on 2018/11/7.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "PreTableViewCell.h"

@interface PreTableViewCell(){
    NSMutableDictionary *dataDic;
}
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *thisLabel;
@property (weak, nonatomic) IBOutlet UILabel *positiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *negativeLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputCountLabel;

@end

@implementation PreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//上筒下面 本筒 正的值和负的值的统计
- (void)getPositivieAndNegative:(NSArray *)dataArray {
  
    float positive = 0;
    float negative = 0;
    for (int i = 1; i < cellMax; i++) {
        NSString *result = [dataArray[i] objectForKey:@"result"];
        NSString *update = [dataArray[i] objectForKey:@"update"];
        if ([update floatValue] > 0) {
            positive += [update floatValue];
        }else if ([update floatValue] < 0){
            negative += [update floatValue];
        }
        
        NSArray *array = [result componentsSeparatedByString:@"\n"];
        for (NSString *str in array) {
            if (![str isEqualToString:@"X"]) {
                if ([str floatValue] > 0) {
                    positive += [str floatValue];
                }else if ([str floatValue] < 0){
                    negative += [str floatValue];
                }
            }
        }
        
        
    }
    self.positiveLabel.text = [self getStringWithNumber:positive];
    self.negativeLabel.text = [self getStringWithNumber:negative];
}

// 计算注数
- (void)inputCount:(NSArray *)dataArray {
    NSInteger all = 0;
    for (int i = 1; i < cellMax; i++) {
        NSString *str = [dataArray[i] objectForKey:@"input"];
        NSInteger thisAll = 0;
        NSArray *array = [str componentsSeparatedByString:@"\n"];
        for (NSString *string in array) {
            if ([string containsString:@"/"]) {
                NSArray *a = [string componentsSeparatedByString:@"/"];
                if (a.count == 3) {
                    thisAll += 2;
                }else{
                    thisAll += 1;
                }
            }
        }
        all += thisAll;
    }
    self.inputCountLabel.text = [NSString stringWithFormat:@"注%ld", (long)all];
    
}

#pragma mark - 数据
- (void)setCellData:(NSArray *)cellData {
    dataDic = cellData[0];
    self.allLabel.text = [dataDic objectForKey:@"total"];
    if ([[dataDic objectForKey:@"total"] floatValue] >= 0) {
        self.allLabel.backgroundColor = [UIColor colorWithQuick:62 green:131 blue:148];
    }else {
        self.allLabel.backgroundColor = [UIColor colorWithQuick:170 green:38 blue:28];
    }
    NSString *name = [NSString stringWithFormat:@"#%ld-%ld",[[dataDic objectForKey:@"course"] integerValue], [[dataDic objectForKey:@"no"] integerValue]];
    self.nameLabel.text = name;
    self.inputLabel.text = [dataDic objectForKey:@"input"];
    self.resultLabel.text = [dataDic objectForKey:@"result"];
    self.thisLabel.text = [dataDic objectForKey:@"thisAll"];
    if ([[dataDic objectForKey:@"thisAll"] floatValue] >= 0) {
        self.thisLabel.backgroundColor = [UIColor colorWithQuick:62 green:131 blue:148];
    }else {
        self.thisLabel.backgroundColor = [UIColor colorWithQuick:170 green:38 blue:28];
    }
    [self getPositivieAndNegative:cellData];
    [self inputCount:cellData];
}

#pragma mark - 数字显示
- (NSString *)getStringWithNumber:(float)number {
    int decimalNum = 3; //保留的小数位数
    
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    
    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [nFormat setMaximumFractionDigits:decimalNum];
    
    NSString *string = [nFormat stringFromNumber:@(number)];
    if (number > 0) {
        string = [NSString stringWithFormat:@"+%@", string];
    }
    return string;
}


@end
