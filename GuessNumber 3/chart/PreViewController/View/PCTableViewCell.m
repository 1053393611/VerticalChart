//
//  PCTableViewCell.m
//  chart
//
//  Created by 钟程 on 2018/11/8.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "PCTableViewCell.h"

#define defaultAllColor [UIColor colorWithQuick:62 green:131 blue:148]

@interface PCTableViewCell(){
    NSInteger index;
    NSMutableDictionary *dataDic;
    float allMoney;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowLabel;
@property (weak, nonatomic) IBOutlet UILabel *AllLabel;
//@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UILabel *thisLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *preLabel;

@end

@implementation PCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 数据
- (void)setCellData:(NSDictionary *)cellData {
    dataDic = [NSMutableDictionary dictionaryWithDictionary:cellData];
    allMoney = [[cellData objectForKey:@"total"] floatValue] - [[cellData objectForKey:@"thisAll"] floatValue] - [[cellData objectForKey:@"update"] floatValue];
    index = [[cellData objectForKey:@"row"] integerValue];
    
    self.rowLabel.text = [NSString stringWithFormat:@"%ld", (long)index];
    
    self.AllLabel.text = [cellData objectForKey:@"total"];
    if ([[cellData objectForKey:@"total"] floatValue] >= 0) {
        self.AllLabel.textColor = defaultAllColor;
    }else {
        self.AllLabel.textColor = [UIColor redColor];
    }
    
    self.nameLabel.text = [cellData objectForKey:@"name"] ;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    //    self.textView.text = [cellData objectForKey:@"input"];
//    [self judgeTextColor:[cellData objectForKey:@"input"]];
    //    self.resultTextView.text = [cellData objectForKey:@"result"];
//    [self judgeResultTextColor:[cellData objectForKey:@"result"]];
    
    if ([self.text isEqualToString:@""]) {
        self.textView.text = self.text;
    }else{
        [self judgeTextColor:self.text];
    }
    self.thisLabel.text = [cellData objectForKey:@"thisAll"];
    if ([[cellData objectForKey:@"thisAll"] floatValue] >= 0) {
        self.thisLabel.textColor = defaultAllColor;
    }else {
        self.thisLabel.textColor = [UIColor redColor];
    }
    self.updateLabel.text = [cellData objectForKey:@"update"];
//    self.preLabel.text = [cellData objectForKey:@"previous"];
    //    [self textViewDidChange:self.textView];
//    [self getCellHeight];
}

#pragma mark - 投入 结果 文字颜色
- (void)judgeTextColor:(NSString *)string {
    self.textView.text = string;
    self.textView.textColor = [UIColor blackColor];
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    NSString *s = array.lastObject;
    
    if ([s containsString:@"/"]) {
        NSArray *a = [s componentsSeparatedByString:@"/"];
        NSString *str = a.lastObject;
        if ([str containsString:@"."]) {
            str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
        if (str.length == 0) {
            NSRange range = NSMakeRange(string.length - s.length, s.length);
            [self setupTextView:self.textView range:range color:[UIColor redColor]];
        }
    }else{
        NSRange range = NSMakeRange(string.length - s.length, s.length);
        [self setupTextView:self.textView range:range color:[UIColor redColor]];
        
    }
}
/*
- (void)judgeResultTextColor:(NSString *)resultString {
    self.resultTextView.text = resultString;
    self.resultTextView.textColor = [UIColor blackColor];
    NSArray *array = [resultString componentsSeparatedByString:@"\n"];
    NSString *s = array.lastObject;
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:self.resultTextView.text];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, self.resultTextView.text.length)];
    for (NSString *str in array) {
        if (![str isEqualToString:@"X"]) {
            if ([str floatValue] < 0) {
                NSMutableArray *marr = [self getRangeStr:self.resultTextView.text findText:str];
                if ( marr != nil ) {
                    for (NSInteger k = 0; k < marr.count; k++) {
                        NSNumber *num = [marr objectAtIndex:k];
                        NSRange r = NSMakeRange([num integerValue], str.length);
                        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:r];
                    }
                }
            }
        }
    }
    
    if ([s isEqualToString:@"X"]) {
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[resultString rangeOfString:@"X"]];
        
    }
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17 weight:0.4] range:NSMakeRange(0, string.length)];
    [self.resultTextView setAttributedText:string];
}
*/
// 设置富文本
- (void)setupTextView:(UITextView *)textView range:(NSRange)range color:(UIColor *)color {
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:textView.text];
    
    [string addAttribute:NSForegroundColorAttributeName value:color range:range];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:0.4] range:NSMakeRange(0, textView.text.length)];
    
    [textView setAttributedText:string];
}
/*
#pragma mark - 获取这个字符串中的所有xxx的所在的index
- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText {
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:30];
    
    if (findText == nil && [findText isEqualToString:@""]) {
        return nil;
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0) {
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        NSInteger length = 0;
        
        for (int i = 0;; i++) {
            if (0 == i) {//去掉这个xxx
                location = rang.location + rang.length;
                length = text.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            } else {
                location = rang1.location + rang1.length;
                length = text.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            
            //在一个range范围内查找另一个字符串的range
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                break;
            } else {//添加符合条件的location进数组
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            }
        }
        
        return arrayRanges;
    }
    
    return nil;
}
*/
@end
