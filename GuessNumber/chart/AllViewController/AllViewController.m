//
//  AllViewController.m
//  chart
//
//  Created by 钟程 on 2018/10/20.
//  Copyright © 2018 钟程. All rights reserved.
//

#import "AllViewController.h"

#define CellHeight 35
#define HeadHeight (CellHeight * 2 + 30)
#define itemWidth 100

#define Green [UIColor colorWithQuick:62 green:131 blue:148]
#define Red [UIColor colorWithQuick:170 green:38 blue:28]
#define Blue [UIColor colorWithQuick:4 green:51 blue:255]
#define BGColor [UIColor colorWithQuick:243 green:248 blue:255]
#define BlackColor [UIColor colorWithSome:90]
#define LineColor [UIColor colorWithSome:190]

@interface AllViewController ()<StockViewDataSource,StockViewDelegate, UITextFieldDelegate>{
    NSMutableArray *allArray;
    NSMutableArray *nameArray;
    NSMutableArray *contentArray;
    NSMutableArray *updateArray;
    NSMutableArray *everyAllArray;
    NSInteger index;
    BOOL isSort;
}

@property (strong, nonatomic) JJStockView *stockView;

@end

@implementation AllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    index = -1;
    isSort = NO;
    self.stockView.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame) - 150, CGRectGetHeight(self.view.frame) - 20);
    [self.view addSubview:self.stockView];
    [self.stockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-120);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [self getData];
    UIButton *button = [self.view viewWithTag:500];
    [self sortAction:button];
}

#pragma mark - 返回按钮

- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Stock DataSource

- (NSUInteger)countForStockView:(JJStockView*)stockView{
    return cellMax - 1;
}

// 第一列
- (UIView*)titleCellForStockView:(JJStockView*)stockView atRowPath:(NSUInteger)row{
    UIView *BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWidth + 50, CellHeight)];
    [BGView setBorderWithTop:NO left:YES bottom:YES right:YES borderColor:LineColor borderWidth:1];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, CellHeight)];
    label1.textColor = BlackColor;
    label1.text = [NSString stringWithFormat:@"%ld", row + 1];
    if (contentArray.count !=0) {
        label1.text = [NSString stringWithFormat:@"%@", [contentArray.firstObject[row] objectForKey:@"row"]];
    }
    label1.textAlignment = NSTextAlignmentCenter;
    [label1 setBorderWithTop:NO left:YES bottom:NO right:YES borderColor:LineColor borderWidth:1];
    [BGView addSubview:label1];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, itemWidth, CellHeight)];
    label2.font = [UIFont systemFontOfSize:17 weight:0.5];
    label2.text = nameArray[row];
    label2.adjustsFontSizeToFitWidth = YES;
    label2.textAlignment = NSTextAlignmentCenter;
    [BGView addSubview:label2];

    return BGView;
}

// 每行
- (UIView*)contentCellForStockView:(JJStockView*)stockView atRowPath:(NSUInteger)row{
    NSInteger count = allArray.count - 3;
    
    UIView *BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWidth *(count + 3), CellHeight)];
    [BGView setBorderWithTop:NO left:NO bottom:YES right:YES borderColor:LineColor borderWidth:1];
//    BGView.backgroundColor = row % 2 == 0 ?[UIColor whiteColor] :[UIColor colorWithRed:240.0f/255.0 green:240.0f/255.0 blue:240.0f/255.0 alpha:1.0];
    for (int i = 0; i < count; i++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, CellHeight -1)];
        [label setBorderWithTop:NO left:NO bottom:NO right:YES borderColor:LineColor borderWidth:1];
        label.font = [UIFont systemFontOfSize:17 weight:0.4];
        label.textAlignment = NSTextAlignmentCenter;
        [BGView addSubview:label];
        if ([[allArray[i] objectForKey:@"hidden"] integerValue] == 0) {
            label.text = [contentArray[i][row] objectForKey:@"total"];
            if ([[contentArray[i][row] objectForKey:@"total"] floatValue] >= 0) {
                label.textColor = Green;
            }else {
                label.textColor = Red;
            }
            label.backgroundColor = [UIColor whiteColor];
        }else {
            NSString *string = @"该场数据已经排除";
            label.textColor = [UIColor blackColor];
            if (row < string.length) {
                label.text = [string substringWithRange:NSMakeRange(row, 1)];
            }else {
                label.text = @"";
            }

            label.backgroundColor = LineColor;
        }
    }
    
    UILabel *updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * count, 0, itemWidth, CellHeight)];
    [updateLabel setBorderWithTop:NO left:NO bottom:NO right:YES borderColor:LineColor borderWidth:1];
    updateLabel.font = [UIFont systemFontOfSize:17 weight:0.4];
    updateLabel.text = updateArray[row];
    if ([updateArray[row] floatValue] >= 0) {
        updateLabel.textColor = Green;
    }else{
        updateLabel.textColor = Red;
    }
    
    updateLabel.textAlignment = NSTextAlignmentCenter;
    [BGView addSubview:updateLabel];
    if (index == row) {
        updateLabel.backgroundColor = [UIColor whiteColor];
        updateLabel.layer.borderWidth = 2;
        updateLabel.layer.borderColor = [UIColor colorWithQuick:126 green:198 blue:113].CGColor;
        updateLabel.backgroundColor = [UIColor colorWithQuick:247 green:255 blue:246];
    }
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * (count+1), 0, itemWidth, CellHeight - 1)];
    nameLabel.text = nameArray[row];
//    [nameLabel setBorderWithTop:NO left:NO bottom:NO right:YES borderColor:LineColor borderWidth:1];
    nameLabel.backgroundColor = BGColor;
    nameLabel.font = [UIFont systemFontOfSize:17 weight:0.5];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [BGView addSubview:nameLabel];
    
    
    UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * (count+2), 0, itemWidth, CellHeight - 1)];
    [allLabel setBorderWithTop:NO left:YES bottom:NO right:YES borderColor:LineColor borderWidth:1];
    allLabel.font = [UIFont systemFontOfSize:17 weight:0.4];
    allLabel.backgroundColor = BGColor;
    allLabel.text = everyAllArray[row];
    if ([everyAllArray[row] floatValue] >= 0) {
        allLabel.textColor = Green;
    }else{
        allLabel.textColor = Red;
    }
    allLabel.textAlignment = NSTextAlignmentCenter;
    [BGView addSubview:allLabel];
    
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(itemWidth* i - 1, 40, 1, 30)];
//        line.backgroundColor = LineColor;
//        [BGView addSubview:line];
    
        
    
    return BGView;
}

#pragma mark - Stock Delegate

- (CGFloat)heightForCell:(JJStockView*)stockView atRowPath:(NSUInteger)row{
    return CellHeight;
}

// 左上角
- (UIView*)headRegularTitle:(JJStockView*)stockView{
    
    UIView *BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWidth + 50, HeadHeight)];
    [BGView setBorderWithTop:YES left:YES bottom:YES right:YES borderColor:LineColor borderWidth:1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CellHeight, 50, 30)];
    label1.backgroundColor = BlackColor;
    [label1 setBorderWithTop:NO left:YES bottom:NO right:YES borderColor:LineColor borderWidth:1];
    [BGView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(50, CellHeight, itemWidth, 30)];
    label2.backgroundColor = BlackColor;
    [label2 setBorderWithTop:NO left:NO bottom:NO right:YES borderColor:LineColor borderWidth:1];
    label2.text = @"名字";
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [BGView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CellHeight + 30, 50, CellHeight)];
    label3.backgroundColor = BGColor;
    [label3 setBorderWithTop:NO left:YES bottom:YES right:YES borderColor:LineColor borderWidth:1];
    [BGView addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(50, CellHeight + 30, itemWidth - 1, CellHeight - 1)];
    label4.backgroundColor = BGColor;
    label4.text = @"每场总帐";
    [label4 setBorderWithTop:NO left:NO bottom:YES right:YES borderColor:LineColor borderWidth:1];
    
    label4.textAlignment = NSTextAlignmentCenter;
    [BGView addSubview:label4];
    
    return BGView;
}

// 第一行
- (UIView*)headTitle:(JJStockView*)stockView{
    NSInteger count = allArray.count - 3;
    
    UIView *BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWidth *(count + 3), HeadHeight)];
    [BGView setBorderWithTop:YES left:YES bottom:YES right:YES borderColor:LineColor borderWidth:1];
//    BGView.backgroundColor = LineColor;
    
    for (int i = 0; i < count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, CellHeight)];
        button.tag = 100+i;
        [button addTarget:self action:@selector(exclude:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg_3"] forState:UIControlStateNormal];
        if ([[allArray[i] objectForKey:@"hidden"] integerValue] == 0) {
            [button setTitle:@"排除" forState:UIControlStateNormal];
        }else {
            [button setTitle:@"恢复" forState:UIControlStateNormal];
        }
        
        [button setTitleColor:Blue forState:UIControlStateNormal];
        [button setBorderWithTop:YES left:NO bottom:YES right:YES borderColor:LineColor borderWidth:1];
        
        [BGView addSubview:button];
        
        UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * i, CellHeight, itemWidth, 30)];
        noLabel.backgroundColor = BlackColor;
        noLabel.text = [NSString stringWithFormat:@"第%d场", i + 1];
        noLabel.textColor = [UIColor whiteColor];
        noLabel.textAlignment = NSTextAlignmentCenter;
        [BGView addSubview:noLabel];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(itemWidth* i - 1, CellHeight, 1, 30)];
        line.backgroundColor = LineColor;
        [BGView addSubview:line];
        
        UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * i, CellHeight + 30, itemWidth, CellHeight)];
        allLabel.backgroundColor = BGColor;
        allLabel.font = [UIFont systemFontOfSize:17 weight:0.4];
        allLabel.textAlignment = NSTextAlignmentCenter;
        if ([[allArray[i] objectForKey:@"hidden"] integerValue] == 0) {
            allLabel.text = [allArray[i] objectForKey:@"total"];
            if ([[allArray[i] objectForKey:@"total"] floatValue] >= 0) {
                allLabel.textColor = Green;
            }else {
                allLabel.textColor = Red;
            }
        }else{
            allLabel.text = @"";
        }
        
        [allLabel setBorderWithTop:NO left:NO bottom:YES right:YES borderColor:LineColor borderWidth:1];
        [BGView addSubview:allLabel];
    }
    
    NSArray *name = @[@"手动更正", @"名字", @"个人总账"];
    for (NSInteger i = count; i < 3 + count; i ++) {
        UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * i, CellHeight, itemWidth, 30)];
        noLabel.backgroundColor = BlackColor;
        noLabel.text = name[i - count];
        noLabel.textColor = [UIColor whiteColor];
        noLabel.textAlignment = NSTextAlignmentCenter;
        [BGView addSubview:noLabel];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(itemWidth* i - 1, CellHeight, 1, 30)];
        line.backgroundColor = LineColor;
        [BGView addSubview:line];
        
        UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * i, CellHeight + 30, itemWidth, CellHeight)];
        allLabel.backgroundColor = BGColor;
        allLabel.textAlignment = NSTextAlignmentCenter;
        allLabel.font = [UIFont systemFontOfSize:17 weight:0.4];
        allLabel.text = allArray[i];
        [allLabel setBorderWithTop:NO left:NO bottom:YES right:YES borderColor:LineColor borderWidth:1];
        if (i == count) {
            if ([allArray[i] floatValue] >= 0) {
                allLabel.textColor = Green;
            }else {
                allLabel.textColor = Red;
            }
        }
        if (i == count + 2) {
            if ([allArray[i] floatValue] >= 0) {
                allLabel.backgroundColor = Green;
            }else {
                allLabel.backgroundColor = Red;
            }
            allLabel.textColor = [UIColor whiteColor];
        }
        
        [BGView addSubview:allLabel];
    }
    
    
    
    return BGView;
}

- (CGFloat)heightForHeadTitle:(JJStockView*)stockView{
    return HeadHeight;
}

- (void)didSelect:(JJStockView*)stockView atRowPath:(NSUInteger)row{
//    NSLog(@"DidSelect Row:%ld",row);
    if (allArray.count == 3) {
        return;
    }
    index = row;
    [_stockView reloadStockView];
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
                [self updateNumber:string];
            }else{
                [Hud showMessage:@"输入的数值格式不正确，请重新输入！"];

            }
        }
        
    }];
    
    
    [alt addAction:cancelAction];
    [alt addAction:okAction];
    [self presentViewController:alt animated:YES completion:nil];
    
}

#pragma mark - 按钮点击事件
// 排除
- (void)exclude:(UIButton *)button {
    NSLog(@"%ld",button.tag);
    NSInteger n = button.tag - 100;
    if ([button.titleLabel.text isEqualToString:@"排除"]) {
        [button setTitle:@"恢复" forState:UIControlStateNormal];
        NSMutableDictionary *dic = allArray[n];
        [dic setObject:@(1) forKey:@"hidden"];
        
        
    }else {
        [button setTitle:@"排除" forState:UIControlStateNormal];
        NSMutableDictionary *dic = allArray[n];
        [dic setObject:@(0) forKey:@"hidden"];
        
    }
    ListModel *model = [ListModel listModelWithDictionary:allArray[n]];
    [FMDB updateTableList:model];
    
    [self excludeOrRecover];
    [_stockView reloadStockView];
}



#pragma mark - Get
- (JJStockView*)stockView{
    if(_stockView != nil){
        return _stockView;
    }
    _stockView = [JJStockView new];
    _stockView.dataSource = self;
    _stockView.delegate = self;
    return _stockView;
}

#pragma mark - 数据
- (void)getData {
    // 第一行数据
    allArray = [FMDB selectTableListResult];

    // 每行数据
    NSArray *listArray = [allArray valueForKeyPath:@"listId"];
    contentArray = [NSMutableArray array];
    for (NSString *listId in listArray) {
       NSMutableArray *detaiArray = [FMDB selectDetail:listId];
        [contentArray addObject:detaiArray];
    }
    
    nameArray = [NSMutableArray arrayWithArray:[contentArray.firstObject valueForKeyPath:@"name"]];
    updateArray = [NSMutableArray arrayWithArray:[contentArray.firstObject valueForKey:@"updateAll"]];
    [allArray removeLastObject];
    [contentArray removeLastObject];
    
    float all = 0;
    for (NSDictionary *dic in allArray) {
        if ([[dic objectForKey:@"hidden"] integerValue] == 0) {
            all += [[dic objectForKey:@"total"] floatValue];
        }
    }
    float update = [[updateArray valueForKeyPath:@"@sum.floatValue"] floatValue];
    all += update;
    [allArray addObject:[self getStringWithNumber:update]];
    [allArray addObject:@""];
    [allArray addObject:[self getStringWithNumber:all]];
    
    everyAllArray = [NSMutableArray array];
    for (int i = 0; i < cellMax - 1; i ++) {
        [everyAllArray addObject:@""];
    }
    
    
    if (allArray.count > 3) {
        [everyAllArray removeAllObjects];
        for (int i = 0; i < cellMax - 1; i ++) {
            float thisAll = 0;
            for (int j = 0; j < contentArray.count; j ++) {
                NSArray *array = contentArray[j];
                if ([[allArray[j] objectForKey:@"hidden"] integerValue] == 0) {
                    thisAll += [[array[i] objectForKey:@"total"] floatValue];
                }
            }
            thisAll += [updateArray[i] floatValue];
            [everyAllArray addObject:[self getStringWithNumber:thisAll]];
        }
    }

    
    
    
    
    [_stockView reloadStockView];
}


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

#pragma mark - 更新
- (void)updateNumber:(NSString *)string {
    
    float number = [string floatValue];
    float all = [allArray.lastObject floatValue] - [allArray[allArray.count - 3] floatValue];
    [updateArray replaceObjectAtIndex:index withObject:[self getStringWithNumber:number]];
    
    
    float update = [[updateArray valueForKeyPath:@"@sum.floatValue"] floatValue];
    all += update;
    [allArray replaceObjectAtIndex:allArray.count - 3 withObject:[self getStringWithNumber:update]];
    [allArray replaceObjectAtIndex:allArray.count - 1 withObject:[self getStringWithNumber:all]];
    
    float thisAll = 0;
    for (int j = 0; j < contentArray.count; j ++) {
        NSArray *array = contentArray[j];
        if ([[allArray[j] objectForKey:@"hidden"] integerValue] == 0) {
            thisAll += [[array[index] objectForKey:@"total"] floatValue];
        }
    }
    thisAll += number;
    [everyAllArray replaceObjectAtIndex:index withObject:[self getStringWithNumber:thisAll]];

    NSMutableDictionary *dic = contentArray.firstObject[index];
    [dic setObject:[self getStringWithNumber:number] forKey:@"updateAll"];
    DetailModel *model = [DetailModel detailModelWithDictionary:dic];
    [FMDB updateDetail:model];
    [_stockView reloadStockView];
}


#pragma mark - 排除 恢复
- (void)excludeOrRecover {
    float all = 0;
    for (int i = 0;i < allArray.count - 3; i++) {
        NSDictionary *dic = allArray[i];
        if ([[dic objectForKey:@"hidden"] integerValue] == 0) {
            all += [[dic objectForKey:@"total"] floatValue];
        }
    }
    float update = [[updateArray valueForKeyPath:@"@sum.floatValue"] floatValue];
    all += update;
    [allArray replaceObjectAtIndex:allArray.count - 1 withObject:[self getStringWithNumber:all]];
    
    [everyAllArray removeAllObjects];
    for (int i = 0; i < cellMax - 1; i ++) {
        float thisAll = 0;
        for (int j = 0; j < contentArray.count; j ++) {
            NSArray *array = contentArray[j];
            if ([[allArray[j] objectForKey:@"hidden"] integerValue] == 0) {
                thisAll += [[array[i] objectForKey:@"total"] floatValue];
            }
        }
        thisAll += [updateArray[i] floatValue];
        [everyAllArray addObject:[self getStringWithNumber:thisAll]];
    }
}


#pragma mark - 键盘
- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:2];
//    tempWindow.hidden = NO;
//    [tempWindow setAlpha:1];
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


#pragma mark - 排序按钮
- (IBAction)sortAction:(UIButton *)sender {
    index = -1;
    if (!isSort) {
        isSort = YES;
        NSInteger count = contentArray.count;
        NSMutableArray *sortArray = [NSMutableArray array];
        for (int i = 0; i < cellMax - 1; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:everyAllArray[i] forKey:@"everyAll"];
            [dic setObject:nameArray[i] forKey:@"name"];
            [dic setObject:updateArray[i] forKey:@"update"];
            for (int j = 0; j < count; j ++) {
                [dic setObject:contentArray[j][i] forKey:[NSString stringWithFormat:@"content%d",j]];
            }
            [sortArray addObject:dic];
        }
        
        //对数组进行排序
        
        NSArray *result = [sortArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            obj1 = [obj1 objectForKey:@"everyAll"];
            obj2 = [obj2 objectForKey:@"everyAll"];
//            NSLog(@"%@~%@",obj1,obj2); //3~4 2~1 3~1 3~2
            if ([obj1 hasPrefix:@"+"]) {
                obj1 = [(NSString *)obj1 stringByReplacingOccurrencesOfString:@"+" withString:@""];
            }
            if ([obj2 hasPrefix:@"+"]) {
                obj2 = [(NSString *)obj2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
            }
            NSLog(@"%@~%@",obj1,obj2);
            if (([obj1 hasPrefix:@"-"]&&[obj2 hasPrefix:@"-"]) || ([obj1 hasPrefix:@"-"]&&[obj2 floatValue] == 0) || ([obj2 hasPrefix:@"-"]&&[obj1 floatValue] == 0)) {
                return [obj1 compare:obj2 options:NSNumericSearch]; // 升序
            }
            return [obj2 compare:obj1 options:NSNumericSearch]; //降序
            
        }];
        
        sortArray = [NSMutableArray arrayWithArray:result];
        
        
        contentArray = [NSMutableArray array];
        nameArray = [NSMutableArray array];
        updateArray = [NSMutableArray array];
        everyAllArray = [NSMutableArray array];
        for (int i = 0; i < cellMax - 1; i++) {
            NSDictionary *dic = sortArray[i];
            [everyAllArray addObject:[dic objectForKey:@"everyAll"]];
            [nameArray addObject:[dic objectForKey:@"name"]];
            [updateArray addObject:[dic objectForKey:@"update"]];
        }
        for (int j = 0; j < count; j ++) {
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < cellMax - 1; i++) {
                NSDictionary *dic = sortArray[i];
                [array addObject:[dic objectForKey:[NSString stringWithFormat:@"content%d",j]]];
            }
            [contentArray addObject:array];
        }
        
        
        [_stockView reloadStockView];
//        NSLog(@"result=%@",result);
    }else{
        isSort = NO;
        [self getData];
    }
    
    
}

@end
