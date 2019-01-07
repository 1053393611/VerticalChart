//
//  ViewController.m
//  chart
//
//  Created by 钟程 on 2018/10/10.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "ViewController.h"
#import "HeadView.h"
#import "AllTableViewCell.h"
#import "TableViewCell.h"
#import "CleanViewController.h"
#import "ControlView.h"
#import "UpdateViewController.h"

#define cellHeight 35

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate>{
    NSMutableArray *heightArray;
    NSMutableArray *dataArray;
    UIView *rightView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ControlView *controlView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyWidth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    heightArray = [NSMutableArray array];
    for (int i = 0; i < cellMax; i++) {
        [heightArray addObject:@(cellHeight)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCellHeight:) name:@"refreshCellHeight" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInput:) name:@"refreshInput" object:nil];

    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AllTableViewCell" bundle:nil] forCellReuseIdentifier:@"AllCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)){
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
    }
    self.tableView.estimatedRowHeight = cellHeight;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self customUI];
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)doRotateAction:(NSNotification *)notification {
    NSLog(@"宽：%f, 高：%f, %f, %f", HBScreenWidth, HBScreenHeight, HBViewHeight, HBLandscapeViewHeight);
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        self.width.constant = 170;
//        self.keyWidth.constant = 160;
        rightView.hidden = NO;
        NSLog(@"竖屏");
    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        self.width.constant = 0;
//        self.keyWidth.constant = 0;
        rightView.hidden = YES;
        NSLog(@"横屏");
    }
}

#pragma mark - customUI
- (void)customUI {
    rightView = [[UIView alloc] init];
    rightView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.tableView.mas_right);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"分享" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"button_bg_3"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithSome:170].CGColor;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 15;
    [rightView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->rightView.mas_top).offset(50);
        make.right.mas_equalTo(self->rightView.mas_right).offset(-10);
        make.left.mas_equalTo(self->rightView.mas_left).offset(10);
        make.height.mas_equalTo(30);
    }];
    rightView.hidden = YES;
}



#pragma mark - UItableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height = [heightArray[indexPath.row] floatValue];
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellMax;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllCell"];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellData = dataArray[indexPath.row];
        return cell;
    }
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.tag = indexPath.row + 100;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textAction:)];
    doubleTap.numberOfTapsRequired =2;
    [cell addGestureRecognizer:doubleTap];
    // 分割线顶到头
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellData = dataArray[indexPath.row];
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeadView *headView = [[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:nil options:nil].firstObject;
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self aboutResult];
//    TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UITextView *textView = [cell viewWithTag:203];
//    [textView becomeFirstResponder];
    
    self.controlView.cellData = @{@"index":@(indexPath.row),@"tableView":tableView,@"dataArray":dataArray};
}

#pragma mark - 通知
// 高度变化
- (void)refreshCellHeight:(NSNotification *)noti {
    
    NSArray *array = [noti object];
    [heightArray replaceObjectAtIndex:[array.lastObject integerValue] withObject:array.firstObject];
}

// textView Text
//- (void)refreshInput:(NSNotification *)noti {
//    NSString *string = [noti object];
//    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//    TableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
//    cell.cellData = @{@"index":@(path.row),@"input":string};
//}

#pragma mark - 双击输入
- (void)textAction:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    //    NSLog(@"双击%ld",index);
    UpdateViewController *vc = [[UpdateViewController alloc] init];
    vc.rowNo = index - 100;
    vc.dataArray = dataArray;
    vc.reloadTheVC = ^{
        [[DataManager defaultManager] updateDataFromDatabase];
        [self.tableView reloadData];
        NSIndexPath *path = [NSIndexPath indexPathForRow:index - 100 inSection:0];
        [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self aboutResult];
        self.controlView.cellData = @{@"index":@(index - 100),@"tableView":self.tableView,@"dataArray":self->dataArray};
    };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 数据
- (void)getData {
    
    dataArray = [[DataManager defaultManager] getDataFromDatabase];
    self.controlView.cellData = @{@"tableView":self.tableView,@"dataArray":dataArray};
    [self.tableView reloadData];
    [self aboutControlView];
}



#pragma mark - 显示隐藏相关
// 点击 开牌相关
- (void)aboutResult {
    UIView *bgView = [self.controlView viewWithTag:500];
    UITextView *textView = [self.controlView viewWithTag:502];
    UIButton *buttn = [self.controlView viewWithTag:503];
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

// 初始显示
- (void)aboutControlView {
    UIView *openBGView = [self.controlView viewWithTag:500];
    UITextView *openLabel = [self.controlView viewWithTag:501];
    UITextView *openTextView = [self.controlView viewWithTag:502];
    UIButton *openBtn = [self.controlView viewWithTag:503];
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
    }
    
    // 判断是否能结束本筒
    if ([[dataArray.firstObject objectForKey:@"result"] isEqualToString:@"未开"]) {
        [self setButtonGray:601];
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
        UIButton *button = [self.controlView viewWithTag:600];
        button.hidden = YES;
    }
    if ([[dataArray.firstObject objectForKey:@"no"] integerValue] == 1) {
        UIButton *button = [self.controlView viewWithTag:600];
        button.hidden = YES;
    }
    
    // 下部按钮都为灰
//    [self setAllButtonGray];
    
    
}

- (void)setButtonGray:(NSInteger)index{
    UIButton *button = [self.controlView viewWithTag:index];
    button.enabled = NO;
//    [button setBackgroundImage:nil forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    
}

- (void)setAllButtonGray{
    for (int i = 0;i < 15;i ++) {
        UIButton *button = [self.controlView viewWithTag:200 + i];
        button.enabled = NO;
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    for (int i = 0;i < 3;i ++) {
        UIButton *button = [self.controlView viewWithTag:300 + i];
        button.enabled = NO;
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithSome:200] forState:UIControlStateNormal];
    }
    
}

#pragma mark - 截图 分享
- (void)shareAction:(id)sender {
    
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
    
    [self presentViewController:alertController animated:YES completion:nil];
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
