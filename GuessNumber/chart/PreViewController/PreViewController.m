//
//  PreViewController.m
//  chart
//
//  Created by 钟程 on 2018/10/30.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "PreViewController.h"
#import "PreTableViewCell.h"
#import "PCTableViewCell.h"
#import "HeadView.h"
#import "UpdateViewController.h"

#define cellHeight 45

@interface PreViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *listArray;
    NSMutableArray *detailArray;
    NSMutableArray *heightArray;
    NSInteger row;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *seletedView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;

@end

@implementation PreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"PCTableViewCell" bundle:nil] forCellReuseIdentifier:@"PCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PreTableViewCell" bundle:nil] forCellReuseIdentifier:@"PreCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)){
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
    }
    self.tableView.estimatedRowHeight = 50;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    
    self.seletedView.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)){
        _seletedView.estimatedRowHeight = 0;
        _seletedView.estimatedSectionHeaderHeight =0;
        _seletedView.estimatedSectionFooterHeight =0;
    }
    self.seletedView.estimatedRowHeight = 50;
    [self.seletedView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.seletedView setSeparatorColor:[UIColor colorWithSome:192]];
    self.seletedView.tableFooterView = [[UIView alloc] init];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    heightArray = [NSMutableArray array];
    for (int i = 0; i < cellMax; i++) {
        [heightArray addObject:@(cellHeight)];
    }
    
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
        self.width.constant = 150;
        
        NSLog(@"竖屏");
    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        self.width.constant = 0;
        
        NSLog(@"横屏");
    }
}


#pragma mark - UITableViewDelegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        return cellMax;
    }else {
        return listArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 101) {
        return [heightArray[indexPath.row] floatValue];
    }else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 101) {
        if (indexPath.row == 0) {
            PreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PreCell"];
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            cell.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cellData = detailArray;
            return cell;
        }
        PCTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PCell"];
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *view = [[UIView alloc]initWithFrame:cell.bounds];
        view.backgroundColor = [UIColor clearColor];
        view.tag = indexPath.row + 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateThisAll:)];
        [view addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textAction:)];
        doubleTap.numberOfTapsRequired =2;
        [view addGestureRecognizer:doubleTap];
        
        [tap requireGestureRecognizerToFail:doubleTap];
        [cell addSubview:view];
        // 分割线顶到头
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellData = detailArray[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCell"];
        }
        // 分割线顶到头
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        UIView *view = [[UIView alloc]initWithFrame:cell.bounds];
        view.layer.borderWidth = 2;
        view.layer.borderColor = [UIColor colorWithQuick:126 green:198 blue:113].CGColor;
        cell.selectedBackgroundView = view;
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithQuick:247 green:255 blue:246];
        
        NSInteger c = [[listArray[indexPath.row] objectForKey:@"course"] integerValue];
        NSInteger n = [[listArray[indexPath.row] objectForKey:@"no"] integerValue];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld场第%ld筒", c, n];
        cell.detailTextLabel.text = [listArray[indexPath.row] objectForKey:@"result"];
        cell.detailTextLabel.textColor = [UIColor redColor];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        return 35;
    }else {
        return 60;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        HeadView *headView = [[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:nil options:nil].firstObject;
        return headView;
    }else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 90, 10, 80, 36)];
        backBtn.layer.cornerRadius = 18;
        backBtn.layer.masksToBounds = YES;
        backBtn.layer.borderWidth = 1;
        backBtn.layer.borderColor = [UIColor colorWithSome:192].CGColor;
        [backBtn setBackgroundImage:[UIImage imageNamed:@"button_bg_3"] forState:UIControlStateNormal];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:backBtn];
        
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 80, 36)];
        shareBtn.layer.cornerRadius = 18;
        shareBtn.layer.masksToBounds = YES;
        shareBtn.layer.borderWidth = 1;
        shareBtn.layer.borderColor = [UIColor colorWithSome:192].CGColor;
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"button_bg_3"] forState:UIControlStateNormal];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor colorWithQuick:4 green:51 blue:255] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:shareBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, tableView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithSome:192];
        [view addSubview:line];
        
        return view;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 102) {
        row = indexPath.row;
        detailArray = [NSMutableArray array];
        [detailArray addObject:listArray[indexPath.row]];
        NSString *listId = [listArray[indexPath.row] objectForKey:@"listId"];
        
        NSArray *array = [FMDB selectDetail:listId];
        [detailArray addObjectsFromArray:array];
        
        for (int i = 1; i < cellMax; i++) {
            NSString *input = [detailArray[i] objectForKey:@"input"];
            NSString *name = [detailArray[i] objectForKey:@"name"];
            CGFloat inputHeight = [self heightForText:input isName:NO];
            CGFloat nameHeight = [self heightForText:name isName:YES];
            CGFloat height = inputHeight > nameHeight ? inputHeight : nameHeight;
            if (height > 35) {
                [heightArray replaceObjectAtIndex:i withObject:@(height + 10)];
            }else {
                [heightArray replaceObjectAtIndex:i withObject:@(cellHeight)];
            }
        }
      
        [self.tableView reloadData];
    }
}

#pragma mark - 按钮事件
- (void)backAction {
    
    self.reloadTheVC();
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 截图 分享
- (void)shareAction {
    
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
    
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = view.frame;
    [view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
    
}



#pragma mark - 数据
- (void)getData {
    listArray = [NSMutableArray array];
    detailArray = [NSMutableArray array];
    row = 0;
    
    listArray = [FMDB selectTableList:_course no:_no];
    [detailArray addObject:listArray.firstObject];
    NSString *listId = [listArray.firstObject objectForKey:@"listId"];
    
    NSArray *array = [FMDB selectDetail:listId];
    [detailArray addObjectsFromArray:array];
    
    for (int i = 1; i < cellMax; i++) {
        
        NSString *input = [detailArray[i] objectForKey:@"input"];
        NSString *name = [detailArray[i] objectForKey:@"name"];
        CGFloat inputHeight = [self heightForText:input isName:NO];
        CGFloat nameHeight = [self heightForText:name isName:YES];
        CGFloat height = inputHeight > nameHeight ? inputHeight : nameHeight;
        if (height > 35) {
            [heightArray replaceObjectAtIndex:i withObject:@(height + 10)];
        }
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.seletedView reloadData];
    [self.tableView reloadData];
    [self.seletedView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - 计算高度
- (CGFloat)heightForText:(NSString *)str isName:(BOOL)isName {
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGFloat width;
    CGRect rect;
    if (isName) {
        width = self.view.bounds.size.width * 13 / 140.f;
        rect = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} context:nil];
    }else {
        width = self.view.bounds.size.width * 13 / 118.f;
        rect = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} context:nil];
    }
    CGFloat realHeight = ceilf(rect.size.height);
    return realHeight;
}


#pragma mark - 更新数据
- (void)updateThisAll:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    NSInteger index = view.tag - 100;
    NSLog(@"%ld", index);
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"请输入数值:" message:@"(更正的数值将被加到总计里)" preferredStyle:UIAlertControllerStyleAlert];
    
    [alt addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入数值";
//        textField.delegate = self;
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
                [self updateNumber:string index:index];
            }else{
                [Hud showMessage:@"输入的数值格式不正确，请重新输入！"];
                
            }
        }
        
    }];
    
    
    [alt addAction:cancelAction];
    [alt addAction:okAction];
    [self presentViewController:alt animated:YES completion:nil];
}


#pragma mark - 更新
- (void)updateNumber:(NSString *)string index:(NSInteger)index {
    
    // 本筒
    float number = [string floatValue];
    
    NSMutableDictionary *dic = detailArray[index];
    float update = [[dic objectForKey:@"update"] floatValue];
    float all = [[dic objectForKey:@"total"] floatValue] - update  + number;
    
    [dic setObject:[self getStringWithNumber:number] forKey:@"update"];
    [dic setObject:[self getStringWithNumber:all] forKey:@"total"];
    [detailArray replaceObjectAtIndex:index withObject:dic];
    
    DetailModel *model = [DetailModel detailModelWithDictionary:dic];
    [FMDB updateDetail:model];
    
    NSMutableDictionary *allDic = detailArray.firstObject;
    float thisAll = [[allDic objectForKey:@"thisAll"] floatValue] - update + number;
    float total = [[allDic objectForKey:@"total"] floatValue] - update + number;
    
    [allDic setObject:[self getStringWithNumber:thisAll] forKey:@"thisAll"];
    [allDic setObject:[self getStringWithNumber:total] forKey:@"total"];
    [detailArray replaceObjectAtIndex:0 withObject:allDic];
    
    ListModel *listModel = [ListModel listModelWithDictionary:allDic];
    [FMDB updateTableList:listModel];
    
    [self.tableView reloadData];
    
    
    
    NSMutableArray *lArray = [NSMutableArray array];
    lArray = [FMDB selectTableList:_course no:_no+1];
    for (int i = 0; i < row + 1; i ++) {
        NSMutableArray *dArray = [NSMutableArray array];
        [dArray addObject:lArray[i]];
        NSString *listId = [lArray[i] objectForKey:@"listId"];
        NSArray *array = [FMDB selectDetail:listId];
        [dArray addObjectsFromArray:array];
        
        NSMutableDictionary *dic = dArray[index];
        float afterAll = [[dic objectForKey:@"total"] floatValue] - update  + number;
        
        [dic setObject:[self getStringWithNumber:afterAll] forKey:@"total"];
        if (i == row) {
            float pre = [[dic objectForKey:@"previous"] floatValue] - update  + number;
            [dic setObject:[self getStringWithNumber:pre] forKey:@"previous"];
        }
  
        DetailModel *model = [DetailModel detailModelWithDictionary:dic];
        [FMDB updateDetail:model];
        
        NSMutableDictionary *allDic = dArray.firstObject;
        float afterTotal = [[allDic objectForKey:@"total"] floatValue] - update + number;
        
        [allDic setObject:[self getStringWithNumber:afterTotal] forKey:@"total"];
        if (i > 0) {
            [listArray replaceObjectAtIndex:i-1 withObject:allDic];
        }
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


#pragma mark - 双击输入
- (void)textAction:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
//    NSLog(@"双击%ld",index);
    UpdateViewController *vc = [[UpdateViewController alloc] init];
    vc.rowNo = index - 100;
    vc.dataArray = detailArray;
    vc.reloadTheVC = ^{
        self->listArray = [NSMutableArray array];
        self->listArray = [FMDB selectTableList:self.course no:self.no];
        self->detailArray = [NSMutableArray array];
        [self->detailArray addObject:self->listArray[self->row]];
        NSString *listId = [self->listArray[self->row] objectForKey:@"listId"];
        
        NSArray *array = [FMDB selectDetail:listId];
        [self->detailArray addObjectsFromArray:array];
        
        for (int i = 1; i < cellMax; i++) {
            NSString *input = [self->detailArray[i] objectForKey:@"input"];
            NSString *name = [self->detailArray[i] objectForKey:@"name"];
            CGFloat inputHeight = [self heightForText:input isName:NO];
            CGFloat nameHeight = [self heightForText:name isName:YES];
            CGFloat height = inputHeight > nameHeight ? inputHeight : nameHeight;
            if (height > 35) {
                [self->heightArray replaceObjectAtIndex:i withObject:@(height + 10)];
            }else {
                [self->heightArray replaceObjectAtIndex:i withObject:@(cellHeight)];
            }
        }
        
        [self.tableView reloadData];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

@end
