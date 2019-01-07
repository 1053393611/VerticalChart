//
//  UpdateViewController.m
//  chart
//
//  Created by 钟程 on 2018/11/8.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "UpdateViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UpdateTableViewCell.h"

#define SOUNDID 1306
#define cellHeight 50
#define headHeight 55

@interface UpdateViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSString *stringData;
    NSMutableArray *strArray;
    NSInteger row;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@property (weak, nonatomic) IBOutlet UILabel *beforeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beforeHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;

@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"UpdateTableViewCell" bundle:nil] forCellReuseIdentifier:@"UpdateCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor colorWithSome:150]];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setAllButtonGray];
    [self customUI];
}

#pragma mark - UI相关
- (void)customUI {
    
    NSDictionary *dic = self.dataArray.firstObject;
    NSString *no = [NSString stringWithFormat:@"[#%ld-%ld]",[[dic objectForKey:@"course"] integerValue], [[dic objectForKey:@"no"] integerValue]];
    self.noLabel.text = no;
    
    self.resultLabel.text = [dic objectForKey:@"result"];
    self.rowLabel.text = [NSString stringWithFormat:@"(%ld)", (long)self.rowNo];
    self.nameLabel.text = [self.dataArray[self.rowNo] objectForKey:@"name"];
    
    self.beforeLabel.text = [self.dataArray[self.rowNo] objectForKey:@"input"];
    CGRect frame = self.beforeLabel.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [self.beforeLabel sizeThatFits:constraintSize];
    NSInteger height = (size.height > 40) ? size.height : 40;
    self.beforeHeight.constant = height + 85;
    
    strArray = [NSMutableArray arrayWithArray:[[self.dataArray[self.rowNo] objectForKey:@"input"] componentsSeparatedByString:@"\n"]];
    row = 0;
    _tableHeight.constant = cellHeight * strArray.count + headHeight;
    
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return strArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UpdateTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UpdateCell"];
    
    // 分割线顶到头
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    cell.tag = 500 + indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellData = strArray[indexPath.row];
    cell.deleteHandler = ^(NSInteger index){
//        NSLog(@"%ld", index);
        [self->strArray removeObjectAtIndex:index];
        [self.tableView reloadData];
        [self setAllButtonGray];
        self.tableHeight.constant = cellHeight * self->strArray.count + headHeight;
        if (self->strArray.count == 0) {
            [self setButtonWhiter:12];
            self->row = -1;
        }
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithSome:240];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width / 3, headHeight - 1)];
    label.textColor = [UIColor colorWithSome:150];
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"点击任意一行进行修改：";
    [view addSubview:label];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headHeight - 1, tableView.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithSome:192];
    [view addSubview:line];
    
    return view;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    row = indexPath.row;
    
    [self customKeyboardView:strArray[indexPath.row]];
}

#pragma mark - 按钮处理
// 按键声音
- (IBAction)buttonPress:(UIButton *)sender {
    AudioServicesPlaySystemSound(SOUNDID);
}

- (IBAction)buttonAction:(UIButton *)sender {
    if (row != -1) {
        stringData = strArray[row];
    }
    
    NSInteger index = sender.tag - 200;
    if (index >=0 && index < 10) {
            // 正常情况
            stringData = [NSMutableString stringWithFormat:@"%@%ld", stringData, index];
            [strArray replaceObjectAtIndex:row withObject:stringData];
    }else{
        switch (index) {
            case 10:
                stringData = [NSString stringWithFormat:@"%@.", stringData];
                [strArray replaceObjectAtIndex:row withObject:stringData];
                break;
            case 13:
                stringData = [NSString stringWithFormat:@"%@>", stringData];
                [strArray replaceObjectAtIndex:row withObject:stringData];
                break;
            case 14:
                stringData = [NSString stringWithFormat:@"%@/", stringData];
                [strArray replaceObjectAtIndex:row withObject:stringData];
                break;
            case 11:
                stringData = [stringData substringToIndex:stringData.length-1];
                [strArray replaceObjectAtIndex:row withObject:stringData];
                break;
            case 12:
                stringData = @"";
                if (row == -1) {
                    row = 0;
                    [strArray addObject:stringData];
                }else{
                    row = row + 1;
                    [strArray insertObject:stringData atIndex:row];
                }
                break;
            default:
                break;
        }
    }

    [self customKeyboardView:stringData];
    
    [self.tableView reloadData];
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
    self.tableHeight.constant = cellHeight * strArray.count + headHeight;
}
- (IBAction)backAction:(id)sender {
    self.reloadTheVC();
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)completeAction:(id)sender {
    NSString *resultAll = [self.dataArray.firstObject objectForKey:@"result"];
    if (![resultAll isEqualToString:@"未开"]) {
        NSInteger resultNumber = [[resultAll substringFromIndex:1] integerValue];
        [self refreshResult:resultNumber];
    }else {
        [self refreshResult:0];
    }
    [self refreshInput];
    self.reloadTheVC();
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 投入
- (void)refreshInput {

    float all = 0;
    NSArray *dataArray = self.dataArray;
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

    NSMutableDictionary *allDic = self.dataArray.firstObject;
    [allDic setObject:[self getInputStringWithNumber:all/10] forKey:@"input"];

    ListModel *listModel = [ListModel listModelWithDictionary:allDic];
    [FMDB updateTableList:listModel];

}

- (void)refreshResult:(NSInteger)resultNumber{
    
    NSMutableDictionary *dic = self.dataArray[_rowNo];
    NSString *thisAllStr;
    NSString *allStr;
    NSString *resultString = [NSString string];
    float number;
    if (resultNumber != 0) {
        // 数字
//        NSString *string = [dic objectForKey:@"input"];
//        NSArray *array = [string componentsSeparatedByString:@"\n"];
        NSArray *array = strArray;
        float thisAll = 0;
        for (int i = 0; i < array.count; i++) {
            NSString *s = array[i];
            if ([s containsString:@"/"]) {
                NSArray *a = [s componentsSeparatedByString:@"/"];
                NSString *str = a.lastObject;
                if ([str containsString:@"."]) {
                    str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
                }
                if (str.length == 0) {
                    if (i < array.count- 1) {
                        resultString = [resultString stringByAppendingString:@"X\n"];
                    }else{
                        resultString = [resultString stringByAppendingString:@"X"];
                    }
                }else {
                    float f = [[self getStringWithNumber:[[MoneyResult defaultInit] getResultWithString:s number:resultNumber]] floatValue];
                    if (i < array.count- 1) {
                         resultString = [resultString stringByAppendingFormat:@"%@\n",[self getStringWithNumber:f]];
                    }else{
                        resultString = [resultString stringByAppendingFormat:@"%@",[self getStringWithNumber:f]];
                    }
                    thisAll += f;
                }
            }else{
                if (s.length != 0) {
                    if (i < array.count- 1) {
                        resultString = [resultString stringByAppendingString:@"X\n"];
                    }else{
                        resultString = [resultString stringByAppendingString:@"X"];
                    }
                }
            }
        }
        
        number = thisAll  - [[dic objectForKey:@"thisAll"] floatValue];
        thisAllStr = [self getStringWithNumber:thisAll];
        float all = thisAll + [[dic objectForKey:@"total"] floatValue] - [[dic objectForKey:@"thisAll"] floatValue];
        allStr = [self getStringWithNumber:all];
        
        
    }else{
        // 退格
//        NSString *string = [dic objectForKey:@"input"];
//        NSArray *array = [string componentsSeparatedByString:@"\n"];
        NSArray *array = strArray;
        for (int i = 0; i < array.count; i++) {
            NSString *s = array[i];
            if ([s containsString:@"/"]) {
                NSArray *a = [s componentsSeparatedByString:@"/"];
                NSString *str = a.lastObject;
                if ([str containsString:@"."]) {
                    str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
                }
                if (str.length == 0) {
                    if (i < array.count- 1) {
                        resultString = [resultString stringByAppendingString:@"X\n"];
                    }else{
                        resultString = [resultString stringByAppendingString:@"X"];
                    }
                }else{
                    if (i < array.count- 1) {
                        resultString = [resultString stringByAppendingString:@"\n"];
                    }
                }
            }else{
                if (s.length != 0) {
                    if (i < array.count- 1) {
                        resultString = [resultString stringByAppendingString:@"X\n"];
                    }else{
                        resultString = [resultString stringByAppendingString:@"X"];
                    }
                }
            }
        }
        
        number = 0;
        thisAllStr = @"";
        float all = [[dic objectForKey:@"total"] floatValue] - [[dic objectForKey:@"thisAll"] floatValue];
        allStr = [self getStringWithNumber:all];
        
    }
    
    NSString *inputStr = [NSString string];
    for (NSString *str in strArray) {
        if ([inputStr isEqualToString:@""]) {
            inputStr = str;
        }else {
            inputStr = [inputStr stringByAppendingFormat:@"\n%@", str];
        }
    }
    
    
    // 本筒
    [dic setObject:inputStr forKey:@"input"];
    [dic setObject:allStr forKey:@"total"];
    [dic setObject:resultString forKey:@"result"];
    [dic setObject:thisAllStr forKey:@"thisAll"];
    
    DetailModel *model = [DetailModel detailModelWithDictionary:dic];
    [FMDB updateDetail:model];
    
    
    NSMutableDictionary *allDic = self.dataArray.firstObject;
    float thisAll = [[allDic objectForKey:@"thisAll"] floatValue] + number;
    float total = [[allDic objectForKey:@"total"] floatValue] + number;
    
    [allDic setObject:[self getStringWithNumber:thisAll] forKey:@"thisAll"];
    [allDic setObject:[self getStringWithNumber:total] forKey:@"total"];
    ListModel *listModel = [ListModel listModelWithDictionary:allDic];
    [FMDB updateTableList:listModel];
    
    NSInteger course = [[self.dataArray.firstObject objectForKey:@"course"] integerValue];
    NSInteger no = [[self.dataArray.firstObject objectForKey:@"no"] integerValue];
    NSMutableArray *lArray = [NSMutableArray array];
    lArray = [FMDB selectTableList:course];
    for (int i = 0; i < lArray.count - no; i ++) {
        NSMutableArray *dArray = [NSMutableArray array];
        [dArray addObject:lArray[i]];
        NSString *listId = [lArray[i] objectForKey:@"listId"];
        NSArray *array = [FMDB selectDetail:listId];
        [dArray addObjectsFromArray:array];
        
        NSMutableDictionary *dic = dArray[_rowNo];
        float afterAll = [[dic objectForKey:@"total"] floatValue] + number;
        
        [dic setObject:[self getStringWithNumber:afterAll] forKey:@"total"];
        if (no == [[dArray.firstObject objectForKey:@"no"] integerValue] - 1) {
            float pre = [[dic objectForKey:@"previous"] floatValue] + number;
            [dic setObject:[self getStringWithNumber:pre] forKey:@"previous"];
        }
        
        DetailModel *model = [DetailModel detailModelWithDictionary:dic];
        [FMDB updateDetail:model];
        
        NSMutableDictionary *allDic = dArray.firstObject;
        float afterTotal = [[allDic objectForKey:@"total"] floatValue] + number;
        
        [allDic setObject:[self getStringWithNumber:afterTotal] forKey:@"total"];
        ListModel *listModel = [ListModel listModelWithDictionary:allDic];
        [FMDB updateTableList:listModel];
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

- (NSString *)getInputStringWithNumber:(float)number {
    int decimalNum = 2; //保留的小数位数
    
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    
    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [nFormat setMaximumFractionDigits:decimalNum];
    
    NSString *string = [nFormat stringFromNumber:@(number)];
    return string;
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
        [self setAllButtonGray:@[@0,@7,@8,@9,@10,@11,@12,@13,@14]];
    }else{
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

#pragma mark - 设置按钮状态
- (void)setButtonGray:(NSInteger)index{
    UIButton *button = [self.view viewWithTag:200 + index];
    button.enabled = NO;
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    
}

- (void)setButtonWhiter:(NSInteger)index{
    UIButton *button = [self.view viewWithTag:200 + index];
    button.enabled = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"button_bg_2"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
    
}

- (void)setAllButtonGray:(NSArray *)array{
    for (NSNumber *number in array) {
        UIButton *button = [self.view viewWithTag:200 + [number integerValue]];
        button.enabled = NO;
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    
}

- (void)setAllButtonWhiter:(NSArray *)array{
    for (NSNumber *number in array) {
        UIButton *button = [self.view viewWithTag:200 + [number integerValue]];
        button.enabled = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg_2"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
    }
}

- (void)setAllButtonGray{
    for (int i = 0;i < 15;i ++) {
        UIButton *button = [self.view viewWithTag:200 + i];
        button.enabled = NO;
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    
}

- (void)setAllButtonWhiter{
    for (int i = 0;i < 15;i ++) {
        UIButton *button = [self.view viewWithTag:200 + i];
        button.enabled = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg_2"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
    }
}



@end
