//
//  AllTableViewCell.m
//  chart
//
//  Created by 钟程 on 2018/10/19.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "AllTableViewCell.h"
#import "TableViewCell.h"

@interface AllTableViewCell(){
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

@implementation AllTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInput:) name:@"refreshInputAll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshResult:) name:@"refreshResultAll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateResult:) name:@"updateResultAll" object:nil];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - 通知
// 投入
- (void)refreshInput:(NSNotification *)noti {

    float all = 0;
    NSArray *dataArray = [[DataManager defaultManager] getData];
    for (int i = 1; i < cellMax; i++) {
        NSString *str = [dataArray[i] objectForKey:@"input"];
        float thisAll = 0;
        NSArray *array = [str componentsSeparatedByString:@"\n"];
        for (NSString *string in array) {
            if ([string containsString:@"/"]) {
                NSArray *a = [string componentsSeparatedByString:@"/"];
                NSString *s = a.lastObject;
                thisAll += [s floatValue];
                if (a.count == 3) {
                    NSString *s = a[1];
                    thisAll += [s floatValue];
                }
            }
        }
        all += thisAll;
    }
    
    self.inputLabel.text = [self getInputStringWithNumber:all/10];
    
    [dataDic setObject:self.inputLabel.text forKey:@"input"];
    
    [[DataManager defaultManager] updateDataWithDictionary:dataDic];
    ListModel *model = [ListModel listModelWithDictionary:dataDic];
    [FMDB updateTableList:model];
    
    [self inputCount];
}


// 开牌结果
- (void)refreshResult:(NSNotification *)noti {
    NSInteger resultNumber = [[noti object] integerValue];
    if (resultNumber == 0) {
        // 未开
        self.resultLabel.text = @"未开";
    }else {
        // 结果
        self.resultLabel.text = [NSString stringWithFormat:@"开%ld", resultNumber];
    }
    
    NSArray *dataArray = [[DataManager defaultManager] getData];
    float thisAll = 0;
    for (int i = 1; i < cellMax; i++) {
        NSString *result = [dataArray[i] objectForKey:@"thisAll"];
        NSString *update = [dataArray[i] objectForKey:@"update"];
        thisAll += [result floatValue];
        thisAll += [update floatValue];
        
    }
    self.thisLabel.text = [self getStringWithNumber:thisAll];
    if (thisAll >= 0) {
        self.thisLabel.backgroundColor = [UIColor colorWithQuick:62 green:131 blue:148];
    }else {
        self.thisLabel.backgroundColor = [UIColor colorWithQuick:170 green:38 blue:28];
    }
    
    float all = 0;
    for (int i = 1; i < cellMax; i++) {
        NSString *allStr = [dataArray[i] objectForKey:@"total"];
        all += [allStr floatValue];
        
    }
    self.allLabel.text = [self getStringWithNumber:all];
    if (all >= 0) {
        self.allLabel.backgroundColor = [UIColor colorWithQuick:62 green:131 blue:148];
    }else {
        self.allLabel.backgroundColor = [UIColor colorWithQuick:170 green:38 blue:28];
    }
    [self getPositivieAndNegative];
    
    [dataDic setObject:self.allLabel.text forKey:@"total"];
    [dataDic setObject:self.resultLabel.text forKey:@"result"];
    [dataDic setObject:self.thisLabel.text forKey:@"thisAll"];
    
    [[DataManager defaultManager] updateDataWithDictionary:dataDic];
    ListModel *model = [ListModel listModelWithDictionary:dataDic];
    [FMDB updateTableList:model];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshLabel" object:nil];
}
// 更新
- (void)updateResult:(NSNotification *)noti {
    NSArray *dataArray = [[DataManager defaultManager] getData];
    float thisAll = 0;
    for (int i = 1; i < cellMax; i++) {
        NSString *result = [dataArray[i] objectForKey:@"thisAll"];
        NSString *update = [dataArray[i] objectForKey:@"update"];
        thisAll += [result floatValue];
        thisAll += [update floatValue];
        
    }
    self.thisLabel.text = [self getStringWithNumber:thisAll];
    if (thisAll >= 0) {
        self.thisLabel.backgroundColor = [UIColor colorWithQuick:62 green:131 blue:148];
    }else {
        self.thisLabel.backgroundColor = [UIColor colorWithQuick:170 green:38 blue:28];
    }
    
    float all = 0;
    for (int i = 1; i < cellMax; i++) {
        NSString *allStr = [dataArray[i] objectForKey:@"total"];
        all += [allStr floatValue];
    }
    self.allLabel.text = [self getStringWithNumber:all];
    if (all >= 0) {
        self.allLabel.backgroundColor = [UIColor colorWithQuick:62 green:131 blue:148];
    }else {
        self.allLabel.backgroundColor = [UIColor colorWithQuick:170 green:38 blue:28];
    }
    [self getPositivieAndNegative];
    [dataDic setObject:self.allLabel.text forKey:@"total"];
    [dataDic setObject:self.thisLabel.text forKey:@"thisAll"];
    
    [[DataManager defaultManager] updateDataWithDictionary:dataDic];
    ListModel *model = [ListModel listModelWithDictionary:dataDic];
    [FMDB updateTableList:model];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshLabel" object:nil];
}

//上筒下面 本筒 正的值和负的值的统计
- (void)getPositivieAndNegative {
    NSArray *dataArray = [[DataManager defaultManager] getData];
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
- (void)inputCount {
    NSInteger all = 0;
    NSArray *dataArray = [[DataManager defaultManager] getData];
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

- (NSString *)getInputStringWithNumber:(float)number {
    int decimalNum = 2; //保留的小数位数
    
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    
    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [nFormat setMaximumFractionDigits:decimalNum];
    
    NSString *string = [nFormat stringFromNumber:@(number)];
    return string;
}


#pragma mark - 数据
- (void)setCellData:(NSDictionary *)cellData {
    dataDic = [NSMutableDictionary dictionaryWithDictionary:cellData];
    self.allLabel.text = [cellData objectForKey:@"total"];
    if ([[cellData objectForKey:@"total"] floatValue] >= 0) {
        self.allLabel.backgroundColor = [UIColor colorWithQuick:62 green:131 blue:148];
    }else {
        self.allLabel.backgroundColor = [UIColor colorWithQuick:170 green:38 blue:28];
    }
    NSString *name = [NSString stringWithFormat:@"#%ld-%ld",[[cellData objectForKey:@"course"] integerValue], [[cellData objectForKey:@"no"] integerValue]];
    self.nameLabel.text = name;
    self.inputLabel.text = [cellData objectForKey:@"input"];
    self.resultLabel.text = [cellData objectForKey:@"result"];
    self.thisLabel.text = [cellData objectForKey:@"thisAll"];
    if ([[cellData objectForKey:@"thisAll"] floatValue] >= 0) {
        self.thisLabel.backgroundColor = [UIColor colorWithQuick:62 green:131 blue:148];
    }else {
        self.thisLabel.backgroundColor = [UIColor colorWithQuick:170 green:38 blue:28];
    }
    [self getPositivieAndNegative];
    [self inputCount];
}

@end
