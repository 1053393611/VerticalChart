//
//  UpdateTableViewCell.m
//  chart
//
//  Created by 钟程 on 2018/11/9.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "UpdateTableViewCell.h"


@interface UpdateTableViewCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *resultView;
@property (weak, nonatomic) IBOutlet UIView *textBGView;


@end

@implementation UpdateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.userInteractionEnabled = NO;
    self.textView.delegate = self;
}

#pragma mark - 删除按钮
- (IBAction)deleteAction:(UIButton *)sender {
    NSInteger index = self.tag - 500;
    self.deleteHandler(index);
}

#pragma mark - 选中式样
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self changeSelectionColorForSelectedOrHiglightedState:selected];
}

- (void)changeSelectionColorForSelectedOrHiglightedState:(BOOL)state
{
    if (state) {
        //选中时候的样式
        self.textBGView.layer.borderWidth = 2;
        self.textBGView.layer.borderColor = [UIColor colorWithQuick:126 green:198 blue:113].CGColor;
        self.textBGView.backgroundColor = [UIColor colorWithQuick:247 green:255 blue:246];
        [self.textView becomeFirstResponder];
        self.textView.tintColor = [UIColor redColor];
    }else{
        //未选中时候的样式
        self.textBGView.backgroundColor = [UIColor clearColor];
        self.textBGView.layer.borderWidth = 0;
//        self.textView.layer.borderColor = 
        [self.textView resignFirstResponder];
    }
}

#pragma mark - 键盘弹出

- (void)textViewDidBeginEditing:(UITextView *)textView{
    for (UIWindow *window in [[UIApplication sharedApplication] windows] ) {
        if ([[window description] hasPrefix:@"<UIRemoteKeyboardWindow"] == YES) {
            window.hidden = YES;
            [window setAlpha:0];
        }
    }
    
}

#pragma mark - 数据
- (void)setCellData:(NSString *)cellData{
    [self judgeTextColor:cellData];
}

- (void)judgeTextColor:(NSString *)string {
    self.textView.text = string;
    self.textView.textColor = [UIColor blackColor];
    self.resultView.image = [UIImage imageNamed:@"right"];
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
            self.resultView.image = [UIImage imageNamed:@"wrong"];
        }
    }else{
        NSRange range = NSMakeRange(string.length - s.length, s.length);
        [self setupTextView:self.textView range:range color:[UIColor redColor]];
        self.resultView.image = [UIImage imageNamed:@"wrong"];
    }
}

// 设置富文本
- (void)setupTextView:(UITextView *)textView range:(NSRange)range color:(UIColor *)color {
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:textView.text];
    
    [string addAttribute:NSForegroundColorAttributeName value:color range:range];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, textView.text.length)];
    
    [textView setAttributedText:string];
}

@end
