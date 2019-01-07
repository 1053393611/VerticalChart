//
//  ControlView.m
//  chart
//
//  Created by 钟程 on 2018/10/16.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "ControlView.h"
#import "KeyboardView.h"
#import "CleanViewController.h"
#import "AllViewController.h"
#import "TableViewCell.h"
#import "PreViewController.h"

@interface ControlView()<UITextFieldDelegate, UITextViewDelegate, CleanDelegate>{
    NSInteger index;
    UITableView *tableView;
    NSMutableArray *dataArray;
}
@property (weak, nonatomic) IBOutlet KeyboardView *keyboardView;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UILabel *thisAllLabel;

@end

@implementation ControlView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
    [self setAllButtonGray];
    [self customUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshResult:) name:@"refreshResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshIndex:) name:@"refreshIndex" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTextView:) name:@"refreshTextView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLabel:) name:@"refreshLabel" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
- (void)customUI {
    // 开牌背景 添加点击事件
    UIView *view = [self viewWithTag:500];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resultAction:)];
    [view addGestureRecognizer:tap];
}


#pragma mark - 上面 按钮处理
// 清空所有
- (IBAction)deleteAll:(UIButton *)sender {
    
    CleanViewController *vc = [[CleanViewController alloc] init];
    vc.isCleanAll = YES;
    vc.delegate = self;
    [[self getViewController:self] presentViewController:vc animated:YES completion:nil];
    
}

// 结束本场
- (IBAction)finishStage:(UIButton *)sender {
    
    CleanViewController *vc = [[CleanViewController alloc] init];
    vc.isCleanAll = NO;
    vc.delegate = self;
    [[self getViewController:self] presentViewController:vc animated:YES completion:nil];
    
}

// 查看上筒
- (IBAction)checkPre:(UIButton *)sender {
    
    PreViewController *vc = [[PreViewController alloc] init];
    vc.course = [[dataArray.firstObject objectForKey:@"course"] integerValue];
    vc.no = [[dataArray.firstObject objectForKey:@"no"] integerValue];
    vc.reloadTheVC = ^{
        [[DataManager defaultManager] updateDataFromDatabase];
        [self->tableView reloadData];
        [self aboutResult];
        [self setAllButtonGray];
    };
    [[self getViewController:self] presentViewController:vc animated:YES completion:nil];
    
}

// 查看总账
- (IBAction)checkAll:(UIButton *)sender {
    AllViewController *vc = [[AllViewController alloc] init];
    [[self getViewController:self] presentViewController:vc animated:YES completion:nil];
    [tableView reloadData];
    [self aboutResult];
    [self setAllButtonGray];
}

// 结束本筒
- (IBAction)finishThis:(UIButton *)sender {
    NSString *listId = [[DataManager defaultManager] getNowTimeTimestamp];
    NSString *all = [dataArray.firstObject objectForKey:@"total"];
    NSInteger course = [[dataArray.firstObject objectForKey:@"course"] integerValue];
    NSInteger no = [[dataArray.firstObject objectForKey:@"no"] integerValue] + 1;
    ListModel *listModel = [ListModel modelWithListId:listId total:all course:course no:no input:@"0.00" result:@"未开" thisAll:@"0"];
    [FMDB insertTableList:listModel];
    
    
    NSArray *allArray = [dataArray valueForKeyPath:@"total"];
    NSArray *nameArray = [dataArray valueForKeyPath:@"name"];
    NSArray *preArray = [dataArray valueForKeyPath:@"thisAll"];
    NSArray *updateArray = [dataArray valueForKeyPath:@"update"];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"", nil];
    for (int i = 1; i < cellMax; i++) {
        float a = [preArray[i] floatValue] + [updateArray[i] floatValue];
        NSString *str = [self getStringWithNumber:a];
        if ([preArray[i] isEqualToString:@""] && [updateArray[i] isEqualToString:@""]) {
            str = @"";
        }
        [array addObject:str];
    }
    
    [FMDB initDetail:listId all:allArray name:nameArray pre:array];
    
    [[DataManager defaultManager] updateDataFromDatabase];
    [tableView reloadData];
    [self aboutControlView];
    self.thisAllLabel.text = @"0";
}

// 继续修改上一筒
- (IBAction)updatePre:(UIButton *)sender {
    ListModel *listModel = [ListModel listModelWithDictionary:dataArray.firstObject];
    [FMDB deleteTableList:listModel];
    [FMDB deleteDetail:listModel.listId];
    
    [[DataManager defaultManager] updateDataFromDatabase];
    [tableView reloadData];
    [self aboutControlViewPre];
}

// 点此开牌
- (IBAction)openAction:(UIButton *)sender {
    sender.hidden = YES;
    NSArray *array = @[@0,@7,@8,@9,@10,@12,@13,@14];
    for (NSNumber *number in array) {
        UIButton *button = [self viewWithTag:200 + [number integerValue]];
        button.enabled = NO;
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    array = @[@1,@2,@3,@4,@5,@6,@11];
    for (NSNumber *number in array) {
        UIButton *button = [self viewWithTag:200 + [number integerValue]];
        button.enabled = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg_2"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    UIView *view = [self viewWithTag:500];
    view.hidden = NO;
    
    UITextView *textView = [self viewWithTag:502];
    [textView becomeFirstResponder];
    [textView scrollRangeToVisible:NSMakeRange(0,0)];
    
    UILabel *nameLabel = [self viewWithTag:220];
    UILabel *stringLabel = [self viewWithTag:221];
    nameLabel.text = @"开牌";
    stringLabel.text = [NSString stringWithFormat:@"  %@", textView.text];
    
}

// 开牌显示点击
- (void)resultAction:(UIGestureRecognizer *)tap {
    UIView *view = tap.view;
    view.backgroundColor = [UIColor colorWithQuick:247 green:255 blue:246];
    view.layer.borderWidth = 3;
    
    UIButton *button = [self viewWithTag:503];
    [self openAction:button];
}


#pragma mark - 下面 按钮处理
// 上移一行
- (IBAction)upAction:(UIButton *)sender {
    [self setButtonWhiter:302];
    index--;
    NSIndexPath *path = [NSIndexPath indexPathForRow:index+1 inSection:0];
    NSIndexPath *afterPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSMutableDictionary *dic = dataArray[index];
    NSMutableDictionary *afterDic = dataArray[index+1];
    // 变更前的cell
    [dic setObject:@(index + 1) forKey:@"row"];
    [[DataManager defaultManager] updateDataWithDictionary:dic];
    [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//    DetailModel *model = [DetailModel detailModelWithDictionary:dic];
//    [FMDB updateDetail:model];
    
    // 变更后cell
    [afterDic setObject:@(index) forKey:@"row"];
    [[DataManager defaultManager] updateDataWithDictionary:afterDic];
    [tableView reloadRowsAtIndexPaths:@[afterPath] withRowAnimation:UITableViewRowAnimationNone];
//    DetailModel *model1 = [DetailModel detailModelWithDictionary:afterDic];
//    [FMDB updateDetail:model1];
    [FMDB ExchangeDetail:index and:index + 1];
    
    [tableView selectRowAtIndexPath:afterPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
    NSDictionary *mDic = @{@"index":@(index),@"tableView":tableView,@"dataArray":dataArray,@"controlView":self};
    self.keyboardView.cellData = mDic;
    
    if (index == 1) {
        [self setButtonGray:300];
    }
}

// 下移一行
- (IBAction)downAction:(UIButton *)sender {
    [self setButtonWhiter:300];
    index++;
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:index-1 inSection:0];
    NSIndexPath *afterPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSMutableDictionary *dic = dataArray[index];
    NSMutableDictionary *afterDic = dataArray[index - 1];
    // 变更前的cell
    [dic setObject:@(index - 1) forKey:@"row"];
    [[DataManager defaultManager] updateDataWithDictionary:dic];
    [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//    DetailModel *model = [DetailModel detailModelWithDictionary:dic];
//    [FMDB updateDetail:model];
    
    // 变更后cell
    [afterDic setObject:@(index) forKey:@"row"];
    [[DataManager defaultManager] updateDataWithDictionary:afterDic];
    [tableView reloadRowsAtIndexPaths:@[afterPath] withRowAnimation:UITableViewRowAnimationNone];
//    DetailModel *model1 = [DetailModel detailModelWithDictionary:afterDic];
//    [FMDB updateDetail:model1];
    
    [FMDB ExchangeDetail:index and:index - 1];
    
    [tableView selectRowAtIndexPath:afterPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    NSDictionary *mDic = @{@"index":@(index),@"tableView":tableView,@"dataArray":dataArray,@"controlView":self};
    self.keyboardView.cellData = mDic;
    
    if (index == cellMax-1) {
        [self setButtonGray:302];
    }
}

// 手动更正
- (IBAction)updateAction:(UIButton *)sender {
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"请输入数值:" message:@"(更正的数值将被加到总计里)" preferredStyle:UIAlertControllerStyleAlert];
    
    [alt addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入数值";
        textField.delegate = self;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([alt.textFields.firstObject.text isEqualToString:@""]) {
            [Hud showMessage:@"请输入数值"];
        }else{
            NSString *string = alt.textFields.firstObject.text;
            NSString *regex = @"[0-9]*";
            regex = @"-?\\d+.?\\d*";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            if ([pred evaluateWithObject:string]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNumber" object:string];
                [self updateNumber:string];
            }else{
                [Hud showMessage:@"输入的数值格式不正确，请重新输入！"];
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入的数值格式不正确，请重新输入！" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self updateAction:sender];
//                }];
//                [alert addAction:action];
//                [[self getViewController:self] presentViewController:alert animated:YES completion:nil];
            }
        }
        
    }];
    
    
    [alt addAction:cancelAction];
    [alt addAction:okAction];
    UIViewController *vc = [self getViewController:self];
    [vc presentViewController:alt animated:YES completion:nil];
}

- (void)updateNumber:(NSString *)string {
    
    float number = [string floatValue];
    
    NSMutableDictionary *dic = dataArray[index];
   
    float all = [[dic objectForKey:@"total"] floatValue] - [[dic objectForKey:@"update"] floatValue] + number;

    [dic setObject:[self getStringWithNumber:number] forKey:@"update"];
    [dic setObject:[self getStringWithNumber:all] forKey:@"total"];
    NSIndexPath *path = [tableView indexPathForSelectedRow];
    [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    [tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
    [[DataManager defaultManager] updateDataWithDictionary:dic];
    DetailModel *model = [DetailModel detailModelWithDictionary:dic];
    [FMDB updateDetail:model];
 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateResultAll" object:nil];
    
}

#pragma mark - 获取当前ViewController

- (UIViewController *)getViewController:(UIResponder*)sender{
    if ([sender isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)sender;
    }
    
    return [self getViewController:sender.nextResponder];
}

#pragma mark - 键盘
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:2];
    tempWindow.hidden = NO;
    [tempWindow setAlpha:1];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:2];
    tempWindow.hidden = YES;
    [tempWindow setAlpha:0];
}

#pragma mark - 设置按钮状态
- (void)setButtonGray:(NSInteger)index{
    UIButton *button = [self viewWithTag:index];
    button.enabled = NO;
//    [button setBackgroundImage:nil forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    
}

- (void)setButtonWhiter:(NSInteger)index{
    UIButton *button = [self viewWithTag:index];
    button.enabled = YES;
//    [button setBackgroundImage:[UIImage imageNamed:@"button_bg_2"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
    
}


- (void)setBottomButtonGray{
    for (int i = 0;i < 3;i ++) {
        UIButton *button = [self viewWithTag:300 + i];
        button.enabled = NO;
//        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    
}

- (void)setAllButtonWhiter{
    for (int i = 0;i < 3;i ++) {
        UIButton *button = [self viewWithTag:300 + i];
        button.enabled = YES;
//        [button setBackgroundImage:[UIImage imageNamed:@"button_bg_2"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
    }
}


- (void)cunstomBottomButton {
    [self setBottomButtonGray];
    if (index > 1 && index < cellMax-1) {
        [self setAllButtonWhiter];
    }else{
        [self setButtonWhiter:301];
        if (index == 1) {
            [self setButtonWhiter:302];
        }else {
            [self setButtonWhiter:300];
        }
    }
}

#pragma mark - 数据
- (void)setCellData:(NSDictionary *)cellData {
    index = [[cellData objectForKey:@"index"] integerValue];
    tableView = [cellData objectForKey:@"tableView"];
    dataArray = [cellData objectForKey:@"dataArray"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:cellData];
    [dic setObject:self forKey:@"controlView"];
    
    if (index != 0) {
        [self cunstomBottomButton];
    }
    self.courseLabel.text = [NSString stringWithFormat:@"第 %ld 场",[[dataArray.firstObject objectForKey:@"course"] integerValue]];
    self.allLabel.text = [dataArray.firstObject objectForKey:@"total"];
    self.thisAllLabel.text = [dataArray.firstObject objectForKey:@"thisAll"];
    
    self.keyboardView.cellData = dic;
}



#pragma mark - 通知
// 开牌
- (void)refreshResult:(NSNotification *)noti {
    
    UILabel *label = [self viewWithTag:501];
    UITextView *tView = [self viewWithTag:502];
    
    NSInteger resultNumber = [[noti object] integerValue];
    if (resultNumber != 0) {
        // 数字
        label.text = @"本筒开";
        tView.text = [NSString stringWithFormat:@"%ld", resultNumber];
    }else {
        // 退格
        label.text = @"请输入";
        tView.text = @"";
    }
}

- (void)refreshTextView:(NSNotification *)noti {
    
    UITextView *tView = [self viewWithTag:502];
    [tView becomeFirstResponder];
}

// 上部第几场 本筒小记
- (void)refreshLabel:(NSNotification *)noti {
    self.allLabel.text = [dataArray.firstObject objectForKey:@"total"];
    self.thisAllLabel.text = [dataArray.firstObject objectForKey:@"thisAll"];
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

#pragma mark - 显示隐藏相关
// 结束本筒后显示
- (void)aboutControlView {
    UIView *openBGView = [self viewWithTag:500];
    UITextView *openLabel = [self viewWithTag:501];
    UITextView *openTextView = [self viewWithTag:502];
    UIButton *openBtn = [self viewWithTag:503];
    openLabel.text = @"请输入";
    openTextView.text = @"";
    openBGView.hidden = YES;
    openBtn.hidden = NO;
    // 查看上筒按钮
    [self setButtonWhiter:604];
    // 结束本筒
    [self setButtonGray:601];
    // 结束本场或继续修改
    [self setButtonWhiter:602];
    UIButton *button = [self viewWithTag:600];
    button.hidden = NO;
    
    // 下部按钮都为灰
    [self setAllButtonGray];
    
    // 键盘上的显示
    UILabel *nameLabel = [self viewWithTag:220];
    UILabel *stringLabel = [self viewWithTag:221];
    nameLabel.text = @"";
    stringLabel.text = @"  ";
    stringLabel.backgroundColor = [UIColor colorWithSome:220];
}
- (void)setAllButtonGray{
    for (int i = 0;i < 15;i ++) {
        UIButton *button = [self viewWithTag:200 + i];
        button.enabled = NO;
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    for (int i = 0;i < 3;i ++) {
        UIButton *button = [self viewWithTag:300 + i];
        button.enabled = NO;
//        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    
}

// 点击 开牌相关
- (void)aboutResult {
    UIView *bgView = [self viewWithTag:500];
    UITextView *textView = [self viewWithTag:502];
    UIButton *buttn = [self viewWithTag:503];
    if ([textView.text isEqualToString:@""]) {
        // 没有结果
        bgView.hidden = YES;
        buttn.hidden = NO;
        bgView.backgroundColor = [UIColor colorWithQuick:247 green:255 blue:246];
        bgView.layer.borderWidth = 1;
    }else {
        // 有结果
        bgView.backgroundColor = [UIColor clearColor];
        bgView.layer.borderWidth = 0;
    }
}

// 继续修改本筒后的显示
- (void)aboutControlViewPre {
    UIView *openBGView = [self viewWithTag:500];
    UITextView *openLabel = [self viewWithTag:501];
    UITextView *openTextView = [self viewWithTag:502];
    UIButton *openBtn = [self viewWithTag:503];
    NSString *resultAll = [dataArray.firstObject objectForKey:@"result"];
    if ([resultAll isEqualToString:@"未开"]) {
        openBGView.hidden = YES;
        openBtn.hidden = NO;
    }else {
        openBGView.hidden = NO;
        openBtn.hidden = YES;
        openLabel.text = @"本筒开";
        openTextView.text = [resultAll substringFromIndex:1];
        openBGView.backgroundColor = [UIColor clearColor];
        openBGView.layer.borderWidth = 0;
    }
    
    // 判断上部显示
    // 查看上筒按钮
    if ([[dataArray.firstObject objectForKey:@"no"] integerValue] == 1) {
        [self setButtonGray:604];
    }else{
        [self setButtonWhiter:604];
    }
    
    // 判断是否能结束本筒
    if ([[dataArray.firstObject objectForKey:@"result"] isEqualToString:@"未开"]) {
        [self setButtonGray:601];
    }else {
        [self setButtonWhiter:601];
    }
    
    // 判断能否结束本场或继续修改本场
    BOOL isFinish = NO;
    for (int i = 1; i < cellMax; i++) {
        NSDictionary *dic = dataArray[i];
        if (![[dic objectForKey:@"input"] isEqualToString:@""]) {
            isFinish = YES;
            break;
        }
    }
    if (isFinish) {
        [self setButtonGray:602];
        UIButton *button = [self viewWithTag:600];
        button.hidden = YES;
    }else {
        [self setButtonWhiter:602];
        UIButton *button = [self viewWithTag:600];
        button.hidden = NO;
    }
    if ([[dataArray.firstObject objectForKey:@"no"] integerValue] == 1) {
        UIButton *button = [self viewWithTag:600];
        button.hidden = YES;
    }
    
    // 下部按钮都为灰
    [self setAllButtonGray];
    
    // 键盘上的显示
    UILabel *nameLabel = [self viewWithTag:220];
    UILabel *stringLabel = [self viewWithTag:221];
    nameLabel.text = @"";
    stringLabel.text = @"  ";
    stringLabel.backgroundColor = [UIColor colorWithSome:220];
}


#pragma mark - CleanDelegate
- (void)reloadTableView{
    [tableView reloadData];
    [self aboutControlViewClean];
    self.courseLabel.text = [NSString stringWithFormat:@"第 %ld 场",[[dataArray.firstObject objectForKey:@"course"] integerValue]];
    self.allLabel.text = @"0";
    self.thisAllLabel.text = @"0";
}

- (void)aboutControlViewClean {
    UIView *openBGView = [self viewWithTag:500];
    UITextView *openLabel = [self viewWithTag:501];
    UITextView *openTextView = [self viewWithTag:502];
    UIButton *openBtn = [self viewWithTag:503];
    openLabel.text = @"请输入";
    openTextView.text = @"";
    openBGView.hidden = YES;
    openBtn.hidden = NO;
    // 查看上筒按钮
    [self setButtonGray:604];
    // 结束本筒
    [self setButtonGray:601];
    // 结束本场或继续修改
    [self setButtonWhiter:602];
    UIButton *button = [self viewWithTag:600];
    button.hidden = YES;
    
    // 下部按钮都为灰
    [self setAllButtonGray];
    
    // 键盘上的显示
    UILabel *nameLabel = [self viewWithTag:220];
    UILabel *stringLabel = [self viewWithTag:221];
    nameLabel.text = @"";
    stringLabel.text = @"  ";
    stringLabel.backgroundColor = [UIColor colorWithSome:220];
}

#pragma mark - arguments
- (void)refreshIndex:(NSNotification *)noti {
    index = [[noti object] integerValue];
    NSDictionary *mDic = @{@"index":@(index),@"tableView":tableView,@"dataArray":dataArray,@"controlView":self};
    self.keyboardView.cellData = mDic;
    if (index != 0) {
        [self cunstomBottomButton];
    }
}


#pragma mark - 截图 分享
- (IBAction)shareAction:(id)sender {
    
    // 截屏
    UIWindow  *window = [UIApplication sharedApplication].keyWindow;
    
    UIImage * image = [self captureImageFromView:window];
    
    // 图片保存相册
    //    UIImage *image = [UIImage imageNamed:@"cellBack"];
    UIImageWriteToSavedPhotosAlbum(image,self,@selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:),nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"分享当前屏幕" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *weChatOneAction = [UIAlertAction actionWithTitle:@"分享至微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([WXApi isWXAppInstalled]) {
            //            [WXApi openWXApp];
            WXMediaMessage *message = [WXMediaMessage message];
            // 设置消息缩略图的方法
            CGSize size = CGSizeMake(100, 100);
            UIGraphicsBeginImageContext(size);
            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
            UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [message setThumbImage:resultImage];
            // 多媒体消息中包含的图片数据对象
            WXImageObject *imageObject = [WXImageObject object];
            
            //        UIImage *image = _shareImage.image;
            
            // 图片真实数据内容
            
            NSData *data = UIImagePNGRepresentation(image);
            imageObject.imageData = data;
            // 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
            message.mediaObject = imageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            //            [WXApi sendReq:req];
            [GCDQueue executeInMainQueue:^{
                [WXApi sendReq:req];
            }];
            
        }else {
            [Hud showMessage:@"本机未安装微信，请先下载微信"];
        }
        
        
    }];
    
    [alertController addAction:weChatOneAction];
    [alertController addAction:cancelAction];
    
    //    if ([alertController respondsToSelector:@selector(popoverPresentationController)]) {
    //
    //        alertController.popoverPresentationController.sourceView = self.view; //必须加
    //
    ////        alertVC.popoverPresentationController.sourceRect = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);//可选，我这里加这句代码是为了调整到合适的位置
    //
    //    }
    
    [[self getViewController:self] presentViewController:alertController animated:YES completion:nil];
}

// 图片保存后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo

{
    if(!error) {
        //        [self showHUD:@"成功保存到相册"];
        
    }else {
        //        NSString *message = [error description];
        //        [self showHUD:message];
    }
    
}


// 截屏
-(UIImage *)captureImageFromView:(UIView *)view{
    
    //    UIGraphicsBeginImageContextWithOptions(view.frame.size,NO, 0);
    //
    //    [[UIColor clearColor] setFill];
    //
    //    [[UIBezierPath bezierPathWithRect:self.view.bounds] fill];
    //
    //    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //
    //    //    [self.view.layer renderInContext:ctx];
    //    [self.navigationController.view.layer renderInContext:ctx];
    //
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //
    //    UIGraphicsEndImageContext();
    //
    //    return image;
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = view.frame;
    [view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
    
}


@end
