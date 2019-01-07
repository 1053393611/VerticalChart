//
//  HomeTableViewCell.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/13.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "HomeTableViewCell.h"

@interface HomeTableViewCell ()

@property (strong, nonatomic)UILabel *lableTitle;
@property (strong, nonatomic)UILabel *lableCreate;
@property (strong, nonatomic)UILabel *lableUpdate;
@property (strong, nonatomic)UILabel *lableRow;
@property (strong, nonatomic)UIView *lineView;
//@property (strong, nonatomic)UIView *lView;




@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //        self.backgroundColor = DefaultBackColor;
        
        UIImageView *imgView = [UIImageView new];
        imgView.image = [UIImage imageNamed:@"cellBack"];
        [self.contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
        //标题
        self.lableTitle = [UILabel new];
        self.lableTitle.textColor = [UIColor colorWithSome:50];
        self.lableTitle.font = BoldFont(20);
        self.lableTitle.text = @"无备注";
        [self.contentView addSubview:self.lableTitle];
        [self.lableTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(SPACE);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-SPACE);
            make.top.mas_equalTo(self.contentView.mas_top).offset(SPACE);
            make.height.mas_equalTo(30);
        }];
        
        //创建时间
        self.lableCreate = [UILabel new];
        self.lableCreate.textColor = [UIColor colorWithSome:101];
        self.lableCreate.font = Font(18);
        //        self.lableTitle.text = @"阿娥无法微风微风";
        [self.contentView addSubview:self.lableCreate];
        [self.lableCreate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(SPACE);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-SPACE);
            make.top.mas_equalTo(self.lableTitle.mas_bottom).offset(5);
            make.height.mas_equalTo(30);
        }];
        
        //更新时间
        self.lableUpdate = [UILabel new];
        self.lableUpdate.textColor = [UIColor colorWithSome:101];
        self.lableUpdate.font = Font(18);
        //        self.lableTitle.text = @"阿娥无法微风微风";
        [self.contentView addSubview:self.lableUpdate];
        [self.lableUpdate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(SPACE);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-SPACE);
            make.top.mas_equalTo(self.lableCreate.mas_bottom).offset(5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-SPACE);
            make.height.mas_equalTo(30);
        }];
        
        //行数
        self.lableRow = [UILabel new];
        self.lableRow.backgroundColor = [UIColor colorWithQuick:10 green:60 blue:170];
        self.lableRow.highlightedTextColor = [UIColor colorWithSome:255];
        self.lableRow.textColor = [UIColor colorWithSome:255];
        self.lableRow.font = BoldFont(20);
        self.lableRow.textAlignment = NSTextAlignmentCenter;
        self.lableRow.layer.cornerRadius = 25;
        self.lableRow.layer.masksToBounds = YES;
        self.lableRow.layer.borderColor = [UIColor colorWithQuick:10 green:10 blue:100].CGColor;
        self.lableRow.layer.borderWidth = 1;
        self.lableRow.text = @"0";
        [self.contentView addSubview:self.lableRow];
        [self.lableRow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-SPACE);
            make.top.mas_equalTo(self.contentView.mas_top).offset(SPACE);
            make.height.mas_equalTo(50);
        }];
        
        // 分割线
        self.lineView = [UIView new];
        self.lineView.backgroundColor = [UIColor colorWithSome:150];
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
        
        
        
        
        
    }
    return self;
}

-(void)setCellData:(NSDictionary *)cellData {
    
    if (![[cellData objectForKey:@"title"] isKindOfClass:[NSNull class]]) {
        self.lableTitle.text   = [cellData objectForKey:@"title"];
        if ([self.lableTitle.text isEqualToString:@"无备注"]) {
            self.lableTitle.textColor = [UIColor colorWithSome:101];
        }else {
            self.lableTitle.textColor = [UIColor colorWithSome:50];
        }
    }
    
    if (![[cellData objectForKey:@"createTime"] isKindOfClass:[NSNull class]]) {
        
        NSString *str = [NSString stringWithFormat:@"创建于 %@", [cellData objectForKey:@"createTime"]];
        NSMutableAttributedString *att  = [[NSMutableAttributedString alloc] initWithString:str attributes:nil];
        [att addAttribute:NSFontAttributeName value:BoldFont(20) range:NSMakeRange(4, 11)];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSome:50] range:NSMakeRange(4, 11)];
        
        //        self.lableCreate.text   = [cellData objectForKey:@"createTime"];
        self.lableCreate.attributedText = att;
    }
    
    if (![[cellData objectForKey:@"updateTime"] isKindOfClass:[NSNull class]]) {
        self.lableUpdate.text   = [NSString stringWithFormat:@"更新于 %@", [cellData objectForKey:@"updateTime"]];
    }
    
    if (![[cellData objectForKey:@"row"] isKindOfClass:[NSNull class]]) {
        if ([[cellData objectForKey:@"row"] integerValue] == 0) {
            self.lableRow.text = @"1";
        }else {
            self.lableRow.text   = [[cellData objectForKey:@"row"] description];
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //    NSLog(@"%@", selected?@"选中":@"未选中");
    self.lableRow.backgroundColor = [UIColor colorWithQuick:10 green:60 blue:170];
    self.lineView.backgroundColor = [UIColor colorWithSome:150];
    
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.lableRow.backgroundColor = [UIColor colorWithQuick:10 green:60 blue:170];
    self.lineView.backgroundColor = [UIColor colorWithSome:150];
    
}

-(void)layoutSubviews{
    
    
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            UIView *v = (UIView *)control;
            UIView *view = [v viewWithTag:200];
            if (!view) {
                view = [UIView new];
                view.tag = 200;
                view.backgroundColor = [UIColor colorWithSome:150];
                [v addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(v.mas_left);
                    make.right.mas_equalTo(v.mas_right);
                    make.bottom.mas_equalTo(v.mas_bottom);
                    make.height.mas_equalTo(1);
                }];
            }
            
            //                view.center = CGPointMake(0, 0);
            //                img.frame = CGRectMake(img.frame.origin.x, 100, img.frame.size.width, img.frame.size.height);
            if (self.selected) {
                v.layer.contents = (id)[[UIImage imageNamed:@"cellBack"]CGImage];
                
                
                
                //                    img.image=[UIImage imageNamed:@"cellBack"];
                
            }else{
                v.layer.contents = (id)[[UIImage imageNamed:@"cellBack"]CGImage];
                
                //                    img.image=[UIImage imageNamed:@"wcellBack"];
                
                
                
            }
            
        }
            
        
        
    }
    [super layoutSubviews];
    
}


@end
