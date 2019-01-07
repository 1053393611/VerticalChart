//
//  KeyboardView.m
//  chart
//
//  Created by 钟程 on 2018/10/15.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "KeyboardView.h"
#import "ControlView.h"
#import <AudioToolbox/AudioToolbox.h>

#define SOUNDID 1306
#define lableBGColor [UIColor colorWithQuick:244 green:197 blue:196]

@interface KeyboardView(){
    NSInteger index;
    UITableView *tableView;
    NSMutableArray *dataArray;
    NSString *stringData;
    NSMutableArray *strArray;
    NSMutableDictionary *dataDic;
    ControlView *controlView;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stringLabel;


@end



@implementation KeyboardView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
    [self setAllButtonGray];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化键盘
- (void)customKeyboardView:(NSString *)string {
    [self setAllButtonWhiter];
    if ([string containsString:@"/"]) {
        // 有/的情况
        NSArray *strArray = [string componentsSeparatedByString:@"/"];
        NSString *firstStr = strArray.firstObject;
        NSString *lastStr = strArray.lastObject;
        [self moneyStatus:lastStr first:firstStr count:strArray.count];
    
    }else {
        [self guessStatus:string];
    }
    
}

- (void)guessStatus:(NSString *)string {
    if (string.length == 0) {
        // 没有任何字符
        self.stringLabel.backgroundColor = [UIColor colorWithSome:220];
        if (strArray.count > 1) {
            [self setAllButtonGray:@[@0,@7,@8,@9,@10,@12,@13,@14]];
        }else{
            [self setAllButtonGray:@[@0,@7,@8,@9,@10,@11,@12,@13,@14]];
        }
        
    }else{
        self.stringLabel.backgroundColor = lableBGColor;
        if ([string containsString:@">"]) {
            // >的状态
            string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
            if (string.length == 1) {
                [self setAllButtonGray:@[@0,@7,@8,@9,string,@10,@12,@13,@14]];
            }else{
                [self setAllButtonGray:@[@0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@12,@13]];
            }
        }else if ([string containsString:@"."]){
            // .的状态
            string = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
            if (string.length == 1) {
                [self setAllButtonGray:@[@0,@7,@8,@9,string,@10,@12,@13,@14]];
            }else if (string.length == 2) {
                NSString *firstStr = [string substringToIndex:1];
                NSString *lastStr = [string substringFromIndex:1];
                [self setAllButtonGray:@[@0,@7,@8,@9,firstStr,lastStr,@10,@12,@13]];
            }else{
                [self setAllButtonGray:@[@0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@12,@13]];
            }
        }else {
            // 纯数字
            if (string.length == 1) {
                [self setAllButtonGray:@[@0,@7,@8,@9,string,@12]];
            }else if (string.length == 2){
                NSString *firstStr = [string substringToIndex:1];
                NSString *lastStr = [string substringFromIndex:1];
                [self setAllButtonGray:@[@0,@7,@8,@9,firstStr,lastStr,@10,@12,@13]];
            }else {
                [self setAllButtonGray:@[@0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@12,@13]];
            }
        }
    }
}


- (void)moneyStatus:(NSString *)string first:(NSString *)first count:(NSInteger)count{
    [self setButtonGray:13];
    [self setButtonGray:14];
    if ([string isEqualToString:@""]) {
        // /在末尾
        self.stringLabel.backgroundColor = lableBGColor;
        [self setButtonGray:12];
    }else{
        // /在中间
        if ([string containsString:@"."]) {
            [self setButtonGray:10];
            if ([string hasSuffix:@"."] && ([string hasPrefix:@"."] || [string hasPrefix:@"0"])  ) {
                [self setButtonGray:0];
            }
            
            string = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
        
        if (string.length >= 4) {
//            [self setButtonWhiter:12];
            [self setAllButtonGray:@[@0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10]];
            [self setButtonWhiter:11];

        }
        
        if (string.length == 0) {
            self.stringLabel.backgroundColor = lableBGColor;
        }else {
            self.stringLabel.backgroundColor = [UIColor colorWithSome:220];
        }
        
        if (string.length >= 0) {
            if ([first containsString:@"."]) {
                if (count <= 2) {
                    [self setButtonWhiter:14];
                }
            }
        }
        
        if (string.length >= 0) {
            if ([first containsString:@">"]) {
                if (count <= 2) {
                    [self setButtonWhiter:14];
                }
            }
        }
        
    }
    
}


#pragma mark - 按钮处理
// 按键声音
- (IBAction)buttonPress:(UIButton *)sender {
    AudioServicesPlaySystemSound(SOUNDID);
}

- (IBAction)buttonAction:(UIButton *)sender {
    NSInteger index = sender.tag - 200;
    if (index >=0 && index < 10) {
        if (CGColorEqualToColor(sender.titleLabel.textColor.CGColor, [UIColor redColor].CGColor)) {
            // 开牌情况
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshResult" object:@(index)];
            [self refreshResult:index];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTextView" object:nil];
            });
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //刷新完成，执行后续代码
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTextView" object:nil];
//            });
            self.stringLabel.text = [NSString stringWithFormat:@"  %ld",index];
            [self judgeFinishThisBtn];
            return;
        }else{
            // 正常情况
            stringData = [NSMutableString stringWithFormat:@"%@%ld", stringData, index];
            [strArray replaceObjectAtIndex:strArray.count - 1 withObject:stringData];
        }
    }else{
        switch (index) {
            case 10:
                stringData = [NSString stringWithFormat:@"%@.", stringData];
                [strArray replaceObjectAtIndex:strArray.count - 1 withObject:stringData];
                break;
            case 13:
                stringData = [NSString stringWithFormat:@"%@>", stringData];
                [strArray replaceObjectAtIndex:strArray.count - 1 withObject:stringData];
                break;
            case 14:
                stringData = [NSString stringWithFormat:@"%@/", stringData];
                [strArray replaceObjectAtIndex:strArray.count - 1 withObject:stringData];
                break;
            case 11:
                if (CGColorEqualToColor(sender.titleLabel.textColor.CGColor, [UIColor redColor].CGColor)) {
                    // 开牌情况
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshResult" object:@(0)];
                    
                    [self refreshResult:0];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTextView" object:nil];
                    });
                    self.stringLabel.text = @"";
                    [self judgeFinishThisBtn];
                    return;
                }else{
                    // 正常情况
                    if ([stringData isEqualToString:@""] && strArray.count > 1) {
                        [strArray removeLastObject];
                        stringData = strArray.lastObject;
                    }else {
                        stringData = [stringData substringToIndex:stringData.length-1];
                        [strArray replaceObjectAtIndex:strArray.count - 1 withObject:stringData];
                    }
                }
                break;
            case 12:
                [strArray addObject:@""];
                stringData = strArray.lastObject;
                break;
            default:
                break;
        }
    }
    self.stringLabel.text = [@"  " stringByAppendingString:stringData];
    
    // 将整个字符串发出
    NSString *string = [NSString string];
    for (NSString *str in strArray) {
        if ([string isEqualToString:@""]) {
            string = str;
        }else {
            string = [string stringByAppendingFormat:@"\n%@", str];
        }
        
    }
    
    [self refreshInput:string];
    
    
    
    NSString *resultAll = [dataArray.firstObject objectForKey:@"result"];
    if (![resultAll isEqualToString:@"未开"]) {
        NSInteger resultNumber = [[resultAll substringFromIndex:1] integerValue];
        [self refreshResult:resultNumber];
    }
    
    [self customKeyboardView:stringData];
    
    // 判断 结束本场按钮 继续修改按钮
    [self judgeFinishBtn];
}




#pragma mark - 数据
- (void)setCellData:(NSDictionary *)cellData{
    controlView = [cellData objectForKey:@"controlView"];
    index = [[cellData objectForKey:@"index"] integerValue];
    tableView = [cellData objectForKey:@"tableView"];
    dataArray = [cellData objectForKey:@"dataArray"];
    if (index != 0) {
        dataDic = [NSMutableDictionary dictionaryWithDictionary:dataArray[index]];
        strArray = [NSMutableArray arrayWithArray:[[dataDic objectForKey:@"input"]   componentsSeparatedByString:@"\n"]];
        stringData = strArray.lastObject;
        self.stringLabel.text = [@"  " stringByAppendingString:stringData];;
        [self customKeyboardView:stringData];
        
        self.nameLabel.text = [dataArray[index] objectForKey:@"name"];
    }
    
}


#pragma mark - input,result
- (void)refreshInput:(NSString *)string {

    NSArray *array = [string componentsSeparatedByString:@"\n"];
    NSString *s = array.lastObject;
    
    NSString *resultString = [NSString string];
    for (int i = 0; i < array.count- 1; i++) {
        resultString = [resultString stringByAppendingString:@"\n"];
    }
    if ([s containsString:@"/"]) {
        NSArray *a = [s componentsSeparatedByString:@"/"];
        NSString *str = a.lastObject;
        if ([str containsString:@"."]) {
            str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
        if (str.length == 0) {
            resultString = [resultString stringByAppendingString:@"X"];
        }
    }else{
        if (s.length != 0) {
            resultString = [resultString stringByAppendingString:@"X"];
        }
    }
    [dataDic setObject:string forKey:@"input"];
    [dataDic setObject:resultString forKey:@"result"];
    
    [[DataManager defaultManager] updateDataWithDictionary:dataDic];
    NSIndexPath *path = [tableView indexPathForSelectedRow];
    [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    [tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    DetailModel *model = [DetailModel detailModelWithDictionary:dataDic];
    [FMDB updateDetail:model];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInput" object:string];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInputAll" object:nil];
}

- (void)refreshResult:(NSInteger)resultNumber{
    for (int i = 1; i < cellMax; i++) {
        NSMutableDictionary *dic = dataArray[i];
        if ([[dic objectForKey:@"input"] isEqualToString:@""]) {
            continue;
        }
        NSString *thisAllStr;
        NSString *allStr;
        NSString *resultString = [NSString string];
       
        if (resultNumber != 0) {
            // 数字
            NSString *string = [dic objectForKey:@"input"];
            NSArray *array = [string componentsSeparatedByString:@"\n"];
            NSString *s = array.lastObject;

            float thisAll = 0;
            for (int i = 0; i < array.count- 1; i++) {
                float f =[[self getStringWithNumber:[[MoneyResult defaultInit] getResultWithString:array[i] number:resultNumber]] floatValue] ;
                resultString = [resultString stringByAppendingFormat:@"%@\n",[self getStringWithNumber:f]];
                thisAll += f;
            }
            if ([s containsString:@"/"]) {
                NSArray *a = [s componentsSeparatedByString:@"/"];
                NSString *str = a.lastObject;
                if ([str containsString:@"."]) {
                    str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
                }
                if (str.length == 0) {
                    resultString = [resultString stringByAppendingString:@"X"];
                }else {
                    float f = [[self getStringWithNumber:[[MoneyResult defaultInit] getResultWithString:s number:resultNumber]] floatValue];
                    resultString = [resultString stringByAppendingFormat:@"%@",[self getStringWithNumber:f]];
                    thisAll += f;
                }
            }else{
                if (s.length != 0) {
                    resultString = [resultString stringByAppendingString:@"X"];

                }
            }
           
            thisAllStr = [self getStringWithNumber:thisAll];
            float all = thisAll + [[dic objectForKey:@"total"] floatValue] - [[dic objectForKey:@"thisAll"] floatValue];
            allStr = [self getStringWithNumber:all];
        
            
        }else{
            // 退格
            NSString *string = [dic objectForKey:@"input"];
            NSArray *array = [string componentsSeparatedByString:@"\n"];
            NSString *s = array.lastObject;
            
            
            for (int i = 0; i < array.count- 1; i++) {
                resultString = [resultString stringByAppendingString:@"\n"];
            }
            if ([s containsString:@"/"]) {
                NSArray *a = [s componentsSeparatedByString:@"/"];
                NSString *str = a.lastObject;
                if ([str containsString:@"."]) {
                    str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
                }
                if (str.length == 0) {
                    resultString = [resultString stringByAppendingString:@"X"];
                }
            }else{
                if (s.length != 0) {
                    resultString = [resultString stringByAppendingString:@"X"];
                }
            }
       
            thisAllStr = @"";
            float all = [[dic objectForKey:@"total"] floatValue] - [[dic objectForKey:@"thisAll"] floatValue];
            allStr = [self getStringWithNumber:all];

            
            
        }
        

        [dic setObject:allStr forKey:@"total"];
        [dic setObject:resultString forKey:@"result"];
        [dic setObject:thisAllStr forKey:@"thisAll"];
        
        [[DataManager defaultManager] updateDataWithDictionary:dic];

        NSIndexPath *path = [tableView indexPathForSelectedRow];
        [tableView reloadData];
        [tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
        DetailModel *model = [DetailModel detailModelWithDictionary:dic];
        [FMDB updateDetail:model];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshResult" object:@(resultNumber)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshResultAll" object:@(resultNumber)];
    
}


#pragma mark - 判断结束本场按钮
- (void)judgeFinishBtn {
    BOOL isFinish = NO;
    for (int i = 1; i < cellMax; i++) {
        NSDictionary *dic = dataArray[i];
        if (![[dic objectForKey:@"input"] isEqualToString:@""]) {
            isFinish = YES;
            break;
        }
    }
    UIButton *uButton = [controlView viewWithTag:600];
    UIButton *finishButton = [controlView viewWithTag:602];
    if (isFinish) {
        finishButton.enabled = NO;
        [finishButton setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
        uButton.hidden = YES;
    }else {
        finishButton.enabled = YES;
        [finishButton setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
        uButton.hidden = NO;
    }
    if ([[dataArray.firstObject objectForKey:@"no"] integerValue] == 1) {
        uButton.hidden = YES;
    }
}

#pragma mark - 判断结束本筒按钮
- (void)judgeFinishThisBtn {
    UIButton *finishButton = [controlView viewWithTag:601];
    if ([[dataArray.firstObject objectForKey:@"result"] isEqualToString:@"未开"]) {
        finishButton.enabled = NO;
        [finishButton setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }else{
        finishButton.enabled = YES;
        [finishButton setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
    }
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

#pragma mark - 设置按钮状态
- (void)setButtonGray:(NSInteger)index{
    UIButton *button = [self viewWithTag:200 + index];
    button.enabled = NO;
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    
}

- (void)setButtonWhiter:(NSInteger)index{
    UIButton *button = [self viewWithTag:200 + index];
    button.enabled = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"button_bg_2"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
    
}

- (void)setAllButtonGray:(NSArray *)array{
    for (NSNumber *number in array) {
        UIButton *button = [self viewWithTag:200 + [number integerValue]];
        button.enabled = NO;
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    
}

- (void)setAllButtonWhiter:(NSArray *)array{
    for (NSNumber *number in array) {
        UIButton *button = [self viewWithTag:200 + [number integerValue]];
        button.enabled = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg_2"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
    }
}

- (void)setAllButtonGray{
    for (int i = 0;i < 15;i ++) {
        UIButton *button = [self viewWithTag:200 + i];
        button.enabled = NO;
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    
}

- (void)setAllButtonWhiter{
    for (int i = 0;i < 15;i ++) {
        UIButton *button = [self viewWithTag:200 + i];
        button.enabled = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg_2"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
    }
}



@end
