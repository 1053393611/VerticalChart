//
//  ContentViewController.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/13.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "ContentViewController.h"
#import "ContentCollectionViewCell.h"
#import "BottomView.h"


@interface ContentViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    NSInteger itemHeight;
    NSInteger itemWidth;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic)  BottomView *bottomView;

@property (strong, nonatomic) NSMutableArray *data;

@property (assign, nonatomic)  NSInteger count;

@property (assign, nonatomic)  NSInteger row; // 列
//@property (assign, nonatomic)  NSInteger list;

@property (strong, nonatomic) NSMutableArray *seletedArray;

//@property (assign, nonatomic)  NSInteger contentofset;  // 记录偏移值

@property (assign, nonatomic)  BOOL isMark; // 是否有标志
@property (assign, nonatomic)  BOOL isUp; // 是否有数字


@property (strong, nonatomic) UILabel *titleLabel;

@property (copy, nonatomic) NSString *detailId;

@property (strong, nonatomic) NSMutableArray *deleteArray; //撤销数据




@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = DefaultBackColor;
    //    self.contentofset = 0;
    self.isMark = NO;
    self.isUp = NO;
    //    self.isUpdate = NO;
    itemWidth = 60;
    //    self.count = 0;
    self.detailId = self.listModel.listId;
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //    itemHeight = HBViewHeight;
    //        NSLog(@"宽：%f, 高：%f, %f, %f", HBScreenWidth, HBScreenHeight, HBViewHeight, HBLandscapeViewHeight);
    
    
    self.data = [NSMutableArray array];
    self.seletedArray = [NSMutableArray array];
    self.deleteArray = [NSMutableArray array];
    //    [self getData];
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        itemHeight = HBLandscapeViewHeight - 70;
        
    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        itemHeight = HBViewHeight - 70;
    }
    if (itemHeight == 0) {
        itemHeight = 628;
    }
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self createCollectionView];
    [self createBottomView];
    [self customNavigation];
    //    [self getData];
    //
    //    [GCDQueue executeInHighPriorityGlobalQueue:^{
    //        [self getData];
    //    }];
    
    
    if (self.isUpdate) {
        UIView *view = [self.bottomView viewWithTag:300];
        view.hidden = YES;
        [self createSkipButton];
    }else {
        [Hud showOperateBegin:@"数据加载中"];
    }
    
    if (self.listModel.skip) {
        self.collectionView.contentInset = UIEdgeInsetsMake(0, -60, 0, 0);
        
    }
    
    
}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [GCDQueue executeInGlobalQueue:^{
//        [self getData];
//    }];
//}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    HBWeakSelf(self);
    [GCDQueue executeInGlobalQueue:^{
        HBStrongSelf(self);
        [self getData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

//- (void)doRotateAction:(NSNotification *)notification {
//    NSLog(@"宽：%f, 高：%f, %f, %f", HBScreenWidth, HBScreenHeight, HBViewHeight, HBLandscapeViewHeight);
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
//        itemHeight = HBLandscapeViewHeight;
//        [self createCollectionView];
//        [self.collectionView reloadData];
//        NSLog(@"竖屏");
//    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
//        itemHeight = HBLandscapeViewHeight;
//        [self createCollectionView];
//        [self.collectionView reloadData];
//        NSLog(@"横屏");
//    }
//}

#pragma mark - UI
- (void)customNavigation {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 80, 36);
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"退出" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithSome:0] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    leftButton.layer.masksToBounds = YES;
    leftButton.layer.cornerRadius = 18;
    leftButton.layer.borderWidth = 1;
    leftButton.layer.borderColor = [UIColor colorWithSome:100].CGColor;
    leftButton.backgroundColor = DefaultBackColor;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = left;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    view.userInteractionEnabled = YES;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 22)];
    self.titleLabel.userInteractionEnabled = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    if ([_listModel.title isEqualToString:@"无备注"]) {
        self.titleLabel.text = @"点击添加备注";
    }else {
        self.titleLabel.text = _listModel.title;
    }
    self.titleLabel.font = BoldFont(20);
    [view addSubview:self.titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleAction:)];
    [self.titleLabel addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 200, 22)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = Font(14);
    label.text = [self.listModel.createTime substringWithRange:NSMakeRange(0, 11)];
    [view addSubview:label];
    
    self.navigationItem.titleView = view;
    
}



- (void)createCollectionView {
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置UICollectionView为横向滚动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 每一行cell之间的间距
    flowLayout.minimumLineSpacing = 0;
    // 每一列cell之间的间距
    // flowLayout.minimumInteritemSpacing = 10;
    // 设置第一个cell和最后一个cell,与父控件之间的间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //    flowLayout.minimumLineSpacing = 1;// 根据需要编写
    //    flowLayout.minimumInteritemSpacing = 1;// 根据需要编写
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);// 该行代码就算不写,item也会有默认尺寸
    
    //    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, HBViewHeight, HBScreenWidth) collectionViewLayout:flowLayout];
    
    
    self.collectionHeight.constant = itemHeight;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.backgroundColor = DefaultBackColor;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgImage"]];
    [self.collectionView setBackgroundView:imgView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[ContentCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //    [self.view addSubview:self.collectionView];
    self.collectionView.bounces = NO;
    if (@available(iOS 11.0, *)) {
        [_collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    
}

- (void)createBottomView {
    
    
    self.bottomView = [[NSBundle mainBundle] loadNibNamed:@"BottomView" owner:self options:nil].firstObject;
    
    //    self.bottomView.frame = CGRectMake(0, itemHeight, HBScreenWidth, 50);
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(70);
    }];
    
    
    for (int i = 1; i < 7; i++) {
        UIButton *button = [self.bottomView viewWithTag:100 + i];
        [button addTarget:self action:@selector(numberAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    UIButton *markButton = [self.bottomView viewWithTag:201];
    [markButton addTarget:self action:@selector(markAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *widthButton = [self.bottomView viewWithTag:202];
    [widthButton addTarget:self action:@selector(widthAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *upButton = [self.bottomView viewWithTag:203];
    [upButton addTarget:self action:@selector(upAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteButton = [self.bottomView viewWithTag:301];
    [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *updateButton = [self.bottomView viewWithTag:302];
    [updateButton addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareButton = [self.bottomView viewWithTag:502];
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)createRightButton:(BOOL)isRepeal or:(BOOL)isRecover {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 80, 36);
    [leftButton addTarget:self action:@selector(repealAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"撤销" forState:UIControlStateNormal];
    //    [leftButton setTitleColor:[UIColor colorWithSome:0] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    leftButton.layer.masksToBounds = YES;
    leftButton.layer.cornerRadius = 18;
    leftButton.layer.borderWidth = 1;
    //    leftButton.layer.borderColor = [UIColor colorWithSome:100].CGColor;
    leftButton.backgroundColor = DefaultBackColor;
    if (isRepeal) {
        [leftButton setTitleColor:[UIColor colorWithSome:0] forState:UIControlStateNormal];
        leftButton.layer.borderColor = [UIColor colorWithSome:100].CGColor;
    }else {
        [leftButton setTitleColor:[UIColor colorWithSome:210] forState:UIControlStateNormal];
        leftButton.layer.borderColor = [UIColor colorWithSome:210].CGColor;
    }
    leftButton.userInteractionEnabled = isRepeal;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIButton *leftButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton1.frame = CGRectMake(0, 0, 80, 36);
    [leftButton1 addTarget:self action:@selector(recoverAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton1 setTitle:@"恢复" forState:UIControlStateNormal];
    //    [leftButton1 setTitleColor:[UIColor colorWithSome:0] forState:UIControlStateNormal];
    leftButton1.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    leftButton1.layer.masksToBounds = YES;
    leftButton1.layer.cornerRadius = 18;
    leftButton1.layer.borderWidth = 1;
    //    leftButton1.layer.borderColor = [UIColor colorWithSome:100].CGColor;
    leftButton1.backgroundColor = DefaultBackColor;
    if (isRecover) {
        [leftButton1 setTitleColor:[UIColor colorWithSome:0] forState:UIControlStateNormal];
        leftButton1.layer.borderColor = [UIColor colorWithSome:100].CGColor;
    }else {
        [leftButton1 setTitleColor:[UIColor colorWithSome:210] forState:UIControlStateNormal];
        leftButton1.layer.borderColor = [UIColor colorWithSome:210].CGColor;
    }
    leftButton1.userInteractionEnabled = isRecover;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithCustomView:leftButton1];
    NSArray *array = @[left1, left];
    self.navigationItem.rightBarButtonItems = array;
}

- (void)createSkipButton {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 80, 36);
    [leftButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"跳过" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithSome:0] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    leftButton.layer.masksToBounds = YES;
    leftButton.layer.cornerRadius = 18;
    leftButton.layer.borderWidth = 1;
    leftButton.layer.borderColor = [UIColor colorWithSome:100].CGColor;
    leftButton.backgroundColor = DefaultBackColor;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = left;
}


#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    if (self.data != nil && self.data.count >= rowMax) {
    //        return self.data.count;
    //    }
    //    return rowMax;
    return self.data.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ContentCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell ) {
        cell = [[ContentCollectionViewCell alloc] init];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.index = indexPath.row;
    cell.currentRow = self.row;
    cell.cellData = self.data[indexPath.row];
    return cell;
}

#pragma mark - title
- (void)titleAction:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"修改备注" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alt addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入备注";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([alt.textFields.firstObject.text isEqualToString:@""]) {
            [Hud showMessage:@"请输入备注"];
        }else{
            label.text = alt.textFields.firstObject.text;
            self.listModel.title = label.text;
            [FMDB updateTableList:self.listModel];
        }
        
    }];
    
    
    [alt addAction:cancelAction];
    [alt addAction:okAction];
    
    [self presentViewController:alt animated:YES completion:^{
        
    }];
    
    
}



#pragma mark - 按钮处理
// 数字
- (void)numberAction:(UIButton *)button {
    
    [self.deleteArray removeAllObjects];
    [self createRightButton:YES or:NO];
    
    NSInteger index = button.tag - 100;
    if (self.count > 4) {
        self.count = 0;
    }
    
    if (self.row == 0) {
        [self lineFeed:index];
        self.row++;
        self.listModel.row = self.row;
        [FMDB updateTableList:self.listModel];
        self.count = 0;
        [self.bottomView setAllButtonWhiter];
        return;
    }
    
    if (CGColorEqualToColor(button.backgroundColor.CGColor, [UIColor colorWithQuick:220 green:250 blue:220].CGColor)) {
        [self lineFeed:index];
        [self getTopData];
//        [self getBottomData];
        [self setContentOffset];
        [self setpreRowMark];
        self.row++;
        self.listModel.row = self.row;
        [GCDQueue executeInGlobalQueue:^{
            [FMDB updateTableList:self.listModel];
        }];
        self.count = 0;
        [self.bottomView setAllButtonWhiter];
        return;
    }
    
    self.count ++;
    if (self.count >= 4) {
        [self insertData:index];
        //判断后5，6行数字
        [self.seletedArray addObject:@(index)];
        [self judgeResidue];
        
        
        //        self.count = 0;
        [self.bottomView setAllButtonGreen];
        return;
    }
    
    
    [self insertData:index];
    
    [self.seletedArray addObject:@(index)];
    
    
    [self.bottomView setButtonGray:index];
    
    
}

// 标志
- (void)markAction {
    self.isMark = !self.isMark;
    for (int i = 2; i < self.row; i++) {
        NSInteger center = [[self.data[i][2] objectForKey:@"data"] integerValue];
        NSArray *array = @[@3, @4, @5, @6, @7, @8];
        for (int j = 0; j < 6; j++) {
            if ([[self.data[i - 1][[array[j] integerValue]] objectForKey:@"data"] integerValue] == center) {
                if (self.isMark) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.data[i-1][[array[j] integerValue]]];
                    [dic setObject:@true forKey:@"mark"];
                    [self.data[i-1] replaceObjectAtIndex:[array[j] integerValue] withObject:dic];
                }else{
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.data[i-1][[array[j] integerValue]]];
                    [dic setObject:@false forKey:@"mark"];
                    [self.data[i-1] replaceObjectAtIndex:[array[j] integerValue] withObject:dic];
                }
                
                break;
            }
        }
    }
    [self.collectionView reloadData];
}

// row宽度
- (void)widthAction {
//    itemWidth += 5;
    if (itemWidth == 60) {
        itemWidth = 65;
    }else if (itemWidth == 65) {
        itemWidth = 56;
    }else{
        itemWidth = 60;
    }
    [self createCollectionView];
    
    if (self.listModel.skip) {
        if ((self.row + 0) * itemWidth < HBScreenWidth ) {
            [self.collectionView setContentOffset:CGPointMake(60, 0) animated:NO];
        }else{
            [self.collectionView setContentOffset:CGPointMake((self.row + 1)* itemWidth - HBScreenWidth, 0) animated:NO];
        }
    }else {
        if ((self.row + 1) * itemWidth < HBScreenWidth ) {
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
        }else{
            [self.collectionView setContentOffset:CGPointMake((self.row + 1)* itemWidth - HBScreenWidth, 0) animated:NO];
            
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshWidth" object:[NSNumber numberWithInteger:itemWidth]];
}


// 删除
- (void)deleteAction {
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"警告" message:@"删除后数据不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [FMDB deleteTableList:self.listModel];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    UIAlertAction *act2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    [controller addAction:act2];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
    
}


// 修改
- (void)updateAction {
    //    self.isUpdate = YES;
    UIView *view = [self.bottomView viewWithTag:300];
    view.hidden = YES;
    
    self.listModel.updateTime = [self getNowTime];
    [FMDB updateTableList:self.listModel];
    if (self.row == 0 && self.count == 0) {
        [self createSkipButton];
        
//    }else if (self.row == 1 && self.count == 0) {
//        [self createRightButton:NO or:NO];
    }else {
        if (self.listModel.skip) {
            if (self.row == 1 && self.count == 0) {
                [self createRightButton:NO or:NO];
            }else {
                [self createRightButton:YES or:NO];
            }
        }else{
            [self createRightButton:YES or:NO];
        }
    }
}

// 返回
- (void)leftAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 显示 隐藏 数字
- (void)upAction {
    self.isUp = !self.isUp;
    if (self.isUp) {
        [UIView animateWithDuration:5 animations:^{
            [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view.mas_left);
                make.right.mas_equalTo(self.view.mas_right);
                make.top.mas_equalTo(self.collectionView.mas_bottom).offset(-40);
                make.height.mas_equalTo(70);
            }];
        }];
       
    }else{
        [UIView animateWithDuration:5 animations:^{
            [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view.mas_left);
                make.right.mas_equalTo(self.view.mas_right);
                make.top.mas_equalTo(self.collectionView.mas_bottom);
                make.height.mas_equalTo(70);
            }];
        }];
        
    }
}



#pragma mark - 数据
- (void)getData {
    self.row = self.listModel.row;
    
    if (self.row < rowMax) {
        for (int i = 0; i < rowMax; i++) {
            NSMutableArray *array = [NSMutableArray array];
            array = [FMDB selectDetail:i detailId:self.detailId];
            [self.data addObject:array];
        }
    }else {
        for (int i = 0; i < self.row + 1; i++) {
            NSMutableArray *array = [NSMutableArray array];
            array = [FMDB selectDetail:i detailId:self.detailId];
            [self.data addObject:array];
        }
    }
    HBWeakSelf(self);
    [GCDQueue executeInMainQueue:^{
        HBStrongSelf(self);
        // 按钮
        [self.bottomView setAllButtonWhiter];
        self.count = 0;
        if (self.row == 0) {
            [self.bottomView setAllButtonGreen];
            
            [self.collectionView reloadData];
            [Hud showOperateEnd];
            return;
        }
        NSArray *array = [NSArray arrayWithArray:self.data[self.row]];
        if ([[array[3] objectForKey:@"data"] integerValue] != 0) {
            self.count ++;
            [self.bottomView setButtonGray:[[array[3] objectForKey:@"data"] integerValue]];
            [self.seletedArray addObject:@([[array[3] objectForKey:@"data"] integerValue])];
        }
        if ([[array[4] objectForKey:@"data"] integerValue] != 0) {
            self.count ++;
            [self.bottomView setButtonGray:[[array[4] objectForKey:@"data"] integerValue]];
            [self.seletedArray addObject:@([[array[4] objectForKey:@"data"] integerValue])];
        }
        if ([[array[5] objectForKey:@"data"] integerValue] != 0) {
            self.count ++;
            [self.bottomView setButtonGray:[[array[5] objectForKey:@"data"] integerValue]];
            [self.seletedArray addObject:@([[array[5] objectForKey:@"data"] integerValue])];
        }
        if ([[array[6] objectForKey:@"data"] integerValue] != 0) {
            self.count ++;
            [self.bottomView setButtonGray:[[array[6] objectForKey:@"data"] integerValue]];
            [self.seletedArray addObject:@([[array[6] objectForKey:@"data"] integerValue])];
        }
        if (self.count >= 4) {
            [self.bottomView setAllButtonGreen];
            [self.seletedArray removeAllObjects];
        }
        
        
        [self.collectionView reloadData];
        [Hud showOperateEnd];
    }];
    //    NSMutableArray *array = [NSMutableArray array];
    //    for (int i = 0 ; i < 12; i++) {
    //        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@false, @"seleted":@false}];
    //
    //        [dic setObject:@(0) forKey:@"data"];
    //        [array addObject:dic];
    //    }
    //
    //
    //
    //    for (int i = 0; i < rowMax; i++) {
    //        NSMutableArray *m = [NSMutableArray arrayWithArray:array];
    //        [self.data addObject:m];
    //    }
    //
    //
    //    NSMutableArray *a = [NSMutableArray array];
    //    for (int i = 0 ; i < 12; i++) {
    //        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@false}];
    //        [a addObject:dic];
    //    }
    //    [self.data replaceObjectAtIndex:1 withObject:a];
    //
    //    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@false, @"seleted":@true}];
    //    [self.data.firstObject replaceObjectAtIndex:4 withObject:d];
    //
    //
}

#pragma mark 换行
// 换行
-(void)lineFeed:(NSInteger)number {
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(number), @"background":@false, @"seleted":@false}];
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i < 9; i++) {
        NSMutableDictionary *dic = self.data[self.row][i];
        [dic setObject:@false forKey:@"background"];
        [array addObject:dic];
        DetailModel *model = [DetailModel initWithDetailId:self.detailId row:i column:self.row mark:[[dic objectForKey:@"mark"] integerValue] data:[[dic objectForKey:@"data"] integerValue] background:[[dic objectForKey:@"background"] integerValue] seleted:[[dic objectForKey:@"seleted"] integerValue]];
        [FMDB updateDetail:model];
    }
    
    // 更改当前行背景
    [self.data replaceObjectAtIndex:self.row withObject:array];
    //    [FMDB updateDetail:self.row detailId:self.detailId background:0];
    
    NSMutableArray *a = [NSMutableArray array];
    for (int i = 0 ; i < 9; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@false}];
        [a addObject:dic];
    }
    // 添加或更改下一行背景
    if (self.row < rowMax - 1) {
        [self.data replaceObjectAtIndex:self.row + 1 withObject:a];
        [FMDB updateDetail:self.row + 1 detailId:self.detailId background:1];
    }else{
        [self.data addObject:a];
        [FMDB insertDetail:self.row + 1 detailId:self.detailId];
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@true}];
    
    // 更改中间行
    [self.data[self.row] replaceObjectAtIndex:2 withObject:d];
    DetailModel *model1 = [DetailModel initWithDetailId:self.detailId row:2 column:self.row mark:0 data:number background:0 seleted:0];
    [FMDB updateDetail:model1];
    
    // 更改下一行 第一排
    [self.data[self.row+ 1] replaceObjectAtIndex:3 withObject:dic];
    DetailModel *model2 = [DetailModel initWithDetailId:self.detailId row:3 column:self.row + 1 mark:0 data:0 background:1 seleted:1];
    [FMDB updateDetail:model2];
    [self.collectionView reloadData];
}

#pragma mark 添加
// 数字
- (void)insertData:(NSInteger)number {
    NSArray *a = @[@3, @4, @5, @6];
    NSArray *array = @[@4, @5, @6 ,@2];
    
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(number), @"background":@true, @"seleted":@false}];
    
    [self.data[self.row] replaceObjectAtIndex:[a[self.count - 1] integerValue] withObject:d];
    DetailModel *model1 = [DetailModel initWithDetailId:self.detailId row:[a[self.count - 1] integerValue] column:self.row mark:0 data:number background:1 seleted:0];
    [FMDB updateDetail:model1];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@true}];
    [self.data[self.row] replaceObjectAtIndex:[array[self.count - 1] integerValue] withObject:dic];
    DetailModel *model2 = [DetailModel initWithDetailId:self.detailId row:[array[self.count - 1] integerValue] column:self.row mark:0 data:0 background:1 seleted:1];
    [FMDB updateDetail:model2];
    
    [self.collectionView reloadData];
    
}

#pragma mark 判断5，6行数字
// 判断5，6行数字
- (void)judgeResidue {
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@(1),@(2),@(3),@(4),@(5),@(6)]];
    //    for (NSNumber *number in self.seletedArray) {
    //        for (int i = 0; i < array.count; i++) {
    //            if([array[i] integerValue] == [number integerValue]){
    //                [array removeObject:array[i]];
    //            }
    //        }
    //    }
    [array removeObjectsInArray:self.seletedArray];
    //    NSLog(@"剩余数字：%@", array);
    
    // 判断前一row 5，6行数字
    NSInteger tmp;
    NSInteger a = [array.firstObject integerValue];
    NSInteger b = [array.lastObject integerValue];
    if (self.row - 1 != 0) {
        
        if (([[self.data[self.row - 1][8] objectForKey:@"data"] integerValue] == a) || ([[self.data[self.row - 1][7] objectForKey:@"data"] integerValue] == b)){
            tmp = a;
            a = b;
            b = tmp;
        }
    }
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(a), @"background":@true, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:7 withObject:d];
    DetailModel *model1 = [DetailModel initWithDetailId:self.detailId row:7 column:self.row mark:0 data:a background:1 seleted:0];
    [FMDB updateDetail:model1];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(b), @"background":@true, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:8 withObject:dic];
    DetailModel *model2 = [DetailModel initWithDetailId:self.detailId row:8 column:self.row mark:0 data:b background:1 seleted:0];
    [FMDB updateDetail:model2];
    
    //清除已选择数字
    [self.seletedArray removeAllObjects];
    
    [self.collectionView reloadData];
    
}

#pragma mark 判断上面两行 数字
// 判断上面两行 数字
- (void)getTopData {
    if (self.row < 2) {
        return;
    }
    NSInteger first = [[self.data[self.row][3] objectForKey:@"data"] integerValue];
    first = [self getTop:first];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(first), @"background":@false, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:0 withObject:d];
    DetailModel *model1 = [DetailModel initWithDetailId:self.detailId row:0 column:self.row mark:0 data:first background:0 seleted:0];
    [GCDQueue executeInGlobalQueue:^{
        [FMDB updateDetail:model1];
    }];
    
    NSInteger center = [[self.data[self.row][2] objectForKey:@"data"] integerValue];
    center = [self getTop:center];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(center), @"background":@false, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:1 withObject:dic];
    DetailModel *model2 = [DetailModel initWithDetailId:self.detailId row:1 column:self.row mark:0 data:center background:0 seleted:0];
    [GCDQueue executeInGlobalQueue:^{
        [FMDB updateDetail:model2];
    }];
    //    NSLog(@"{\nfirst: %ld,\ncenter: %ld}", first, center);
    
}
// 获取数字在前一row的位置
- (NSInteger)getTop:(NSInteger)number {
    NSArray *array = @[@3, @4, @5, @6, @7, @8];
    for (int i = 0; i < 6; i++) {
        if ([[self.data[self.row - 1][[array[i] integerValue]] objectForKey:@"data"] integerValue] == number) {
            if (i == 5) {
                number = i + 10;
            }else {
                number = i + 11;
            }
            return  number;
        }
    }
    return 0;
}

#pragma mark  判断下面三行 数字
// 判断下面三行 数字
- (void)getBottomData {
    if (self.row < 3) {
        return;
    }
    NSInteger center = [[self.data[self.row][4] objectForKey:@"data"] integerValue];
    center = [self getBottom:center];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(center), @"background":@false, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:9 withObject:d];
    DetailModel *model1 = [DetailModel initWithDetailId:self.detailId row:9 column:self.row mark:0 data:center background:0 seleted:0];
    [GCDQueue executeInGlobalQueue:^{
        [FMDB updateDetail:model1];
    }];
    
    NSInteger first = [[self.data[self.row][2] objectForKey:@"data"] integerValue];
    first = [self getBottom:first];
    NSMutableDictionary *di = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(first), @"background":@false, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:10 withObject:di];
    DetailModel *model2 = [DetailModel initWithDetailId:self.detailId row:10 column:self.row mark:0 data:first background:0 seleted:0];
    [GCDQueue executeInGlobalQueue:^{
        [FMDB updateDetail:model2];
    }];
    
    NSInteger third = [[self.data[self.row][5] objectForKey:@"data"] integerValue];
    third = [self getBottom:third];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(third), @"background":@false, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:11 withObject:dic];
    DetailModel *model3 = [DetailModel initWithDetailId:self.detailId row:11 column:self.row mark:0 data:third background:0 seleted:0];
    [GCDQueue executeInGlobalQueue:^{
        [FMDB updateDetail:model3];
    }];
    
    //    NSLog(@"{\ncenter: %ld,\nfirst: %ld,\nthird: %ld}", center, first, third);
    
}

- (NSInteger)getBottom:(NSInteger)number {
    NSArray *array = @[@2, @3, @5, @6, @7, @8];
    for (int i = 0; i < 6; i++) {
        if ([[self.data[self.row - 1][[array[i] integerValue]] objectForKey:@"data"] integerValue] == number) {
            number = [[self.data[self.row - 2][[array[i] integerValue]] objectForKey:@"data"] integerValue];
            number =  [self getTop:number];
            return number;
        }
    }
    return 0;
    
}

#pragma mark 设置前一行标志 有标志的情况
- (void)setpreRowMark {
    NSInteger center = [[self.data[self.row][2] objectForKey:@"data"] integerValue];
    NSArray *array = @[@3, @4, @5, @6, @7, @8];
    for (int j = 0; j < 6; j++) {
        if ([[self.data[self.row - 1][[array[j] integerValue]] objectForKey:@"data"] integerValue] == center) {
            if (self.isMark) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.data[self.row-1][[array[j] integerValue]]];
                [dic setObject:@true forKey:@"mark"];
                [self.data[self.row-1] replaceObjectAtIndex:[array[j] integerValue] withObject:dic];
            }
            
            break;
        }
    }
}



#pragma mark - 设置偏移量
- (void)setContentOffset {
    if (self.listModel.skip) {
        if ((self.row + 1) * itemWidth > HBScreenWidth) {
            [self.collectionView setContentOffset:CGPointMake((self.row + 2)* itemWidth - HBScreenWidth, 0) animated:NO];
        }
    }else{
        if ((self.row + 2) * itemWidth > HBScreenWidth) {
            [self.collectionView setContentOffset:CGPointMake((self.row + 2)* itemWidth - HBScreenWidth, 0) animated:NO];
        }
    }
}

#pragma mark - 获取当前时间
-(NSString *)getNowTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    //    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //
    //    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    
    NSString *locationString = [formatter stringFromDate:datenow];
    
    return locationString;
    
}


#pragma mark - 撤销、恢复相关
// 撤销
- (void)repealAction {
    
    
    // 恢复按钮状态
    [self createRightButton:YES or:YES];
    
    if (self.count == 0) {
        if (self.row == 1) {
            [self preLineZero];
        }else{
            [self preLine];
        }
        return;
    }
    NSArray *array = [NSArray arrayWithArray:self.data[self.row]];
    NSInteger current;
    switch (self.count) {
        case 4:{
            current = [[array[6] objectForKey:@"data"] integerValue];
            
            // 按钮状态
            [self.bottomView setAllButtonWhiter];
            [self.bottomView setButtonGray:[[array[3] objectForKey:@"data"] integerValue]];
            [self.bottomView setButtonGray:[[array[4] objectForKey:@"data"] integerValue]];
            [self.bottomView setButtonGray:[[array[5] objectForKey:@"data"] integerValue]];
            
            // 已用数字
            [self.seletedArray addObject:[array[3] objectForKey:@"data"]];
            [self.seletedArray addObject:[array[4] objectForKey:@"data"]];
            [self.seletedArray addObject:[array[5] objectForKey:@"data"]];
            
            // 5、6行数据变更
            NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@false}];
            
            [self.data[self.row] replaceObjectAtIndex:7 withObject:d];
            DetailModel *model1 = [DetailModel initWithDetailId:self.detailId row:7 column:self.row mark:0 data:0 background:1 seleted:0];
            [FMDB updateDetail:model1];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@false}];
            [self.data[self.row] replaceObjectAtIndex:8 withObject:dic];
            DetailModel *model2 = [DetailModel initWithDetailId:self.detailId row:8 column:self.row mark:0 data:0 background:1 seleted:0];
            [FMDB updateDetail:model2];
            
            break;
        }
        case 3:{
            current = [[array[5] objectForKey:@"data"] integerValue];
            [self.bottomView setButtonWhiter:current];
            break;
        }
        case 2:{
            current = [[array[4] objectForKey:@"data"] integerValue];
            [self.bottomView setButtonWhiter:current];
            break;
        }
        default:{
            current = [[array[3] objectForKey:@"data"] integerValue];
            [self.bottomView setButtonWhiter:current];
            break;
        }
    }
    
    [self.seletedArray removeObject:@(current)];
    [self.deleteArray addObject:@(current)];
    
    
    // 数据变更
    NSArray *a = @[@4, @5, @6, @2];
    NSArray *b = @[@3, @4, @5, @6];
    
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@false}];
    
    [self.data[self.row] replaceObjectAtIndex:[a[self.count - 1] integerValue] withObject:d];
    DetailModel *model1 = [DetailModel initWithDetailId:self.detailId row:[a[self.count - 1] integerValue] column:self.row mark:0 data:0 background:1 seleted:0];
    [FMDB updateDetail:model1];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@true}];
    [self.data[self.row] replaceObjectAtIndex:[b[self.count - 1] integerValue] withObject:dic];
    DetailModel *model2 = [DetailModel initWithDetailId:self.detailId row:[b[self.count - 1] integerValue] column:self.row mark:0 data:0 background:1 seleted:1];
    [FMDB updateDetail:model2];
    
    self.count --;
    if (self.listModel.skip) {
        if (self.row == 1 && self.count == 0 ) {
            [self createRightButton:NO or:YES];
        }
    }
    
    [self.collectionView reloadData];
    
}

// 跳转到上一行
- (void)preLine {
    NSMutableArray *a = [NSMutableArray array];
    for (int i = 0 ; i < 9; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@false, @"seleted":@false}];
        [a addObject:dic];
    }
    // 删除或更改本行背景
    if (self.row < rowMax) {
        [self.data replaceObjectAtIndex:self.row withObject:a];
        [FMDB updateDetail:self.row detailId:self.detailId background:0];
    }else{
        [self.data removeLastObject];
        [FMDB deleteDetail:self.row detailId:self.detailId];
    }
    
    // 修改前一行数据 背景
    NSMutableArray *array = [NSMutableArray array];
    array = self.data[self.row - 1];
    for (NSDictionary *dic in array) {
        [dic setValue:@(1) forKey:@"background"];
        [dic setValue:@(0) forKey:@"mark"];
        DetailModel *model = [DetailModel initWithDetailId:self.detailId row:[array indexOfObject:dic] column:self.row-1 mark:0 data:[[dic objectForKey:@"data"] integerValue] background:1 seleted:0];
        [FMDB updateDetail:model];
    }
    
    // 清除上上一行的标志
    NSMutableArray *array1 = [NSMutableArray array];
    array1 = self.data[self.row - 2];
    for (NSDictionary *dic in array1) {
        [dic setValue:@(0) forKey:@"mark"];
    }
    
    NSArray *b = @[@0, @1];
    for (NSNumber *number in b) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@false}];
        [array replaceObjectAtIndex:[number integerValue] withObject:dic];
        DetailModel *model = [DetailModel initWithDetailId:self.detailId row:[number integerValue] column:self.row-1 mark:0 data:0 background:1 seleted:0];
        [FMDB updateDetail:model];
    }
    
    NSInteger current = [[array[2] objectForKey:@"data"] integerValue];
    [self.deleteArray addObject:@(current)];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@true}];
    [array replaceObjectAtIndex:2 withObject:dic];
    DetailModel *model = [DetailModel initWithDetailId:self.detailId row:2 column:self.row-1 mark:0 data:0 background:1 seleted:1];
    [FMDB updateDetail:model];
    
    
    self.row --;
    
    self.listModel.row = self.row;
    [FMDB updateTableList:self.listModel];
    [self.bottomView setAllButtonGreen];
    self.count = 4;
    [self.collectionView reloadData];
}

// 跳转到上一行
- (void)preLineZero {
    NSMutableArray *a = [NSMutableArray array];
    for (int i = 0 ; i < 9; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@false}];
        [a addObject:dic];
    }
    // 删除或更改本行背景
    if (self.row < rowMax) {
        [self.data replaceObjectAtIndex:self.row withObject:a];
        [FMDB updateDetail:self.row detailId:self.detailId background:1];
    }else{
        [self.data removeLastObject];
        [FMDB deleteDetail:self.row detailId:self.detailId];
    }
    
    // 修改前一行数据 背景
    NSMutableArray *array = [NSMutableArray array];
    array = self.data[self.row - 1];
    
    NSInteger current = [[array[2] objectForKey:@"data"] integerValue];
    [self.deleteArray addObject:@(current)];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@false, @"seleted":@true}];
    [array replaceObjectAtIndex:2 withObject:dic];
    DetailModel *model = [DetailModel initWithDetailId:self.detailId row:2 column:self.row-1 mark:0 data:0 background:0 seleted:1];
    [FMDB updateDetail:model];
    
    
    
    self.row --;
    
    self.listModel.row = self.row;
    [FMDB updateTableList:self.listModel];
    [self.bottomView setAllButtonGreen];
    self.count = 4;
    [self createRightButton:NO or:YES];
    [self.collectionView reloadData];
}


// 恢复
- (void)recoverAction {
    
    // 撤销按钮状态
    [self createRightButton:YES or:YES];
    
    NSInteger tag = [self.deleteArray.lastObject integerValue];
    UIButton *button = [self.bottomView viewWithTag:100 + tag];
    [self recoverData:button];
    
    [self.deleteArray removeLastObject];
    if (self.deleteArray.count == 0) {
        [self createRightButton:YES or:NO];
    }
}

- (void)recoverData:(UIButton *)button {
    if (self.count > 4) {
        self.count = 0;
    }
    NSInteger index = button.tag - 100;
    if (self.row == 0) {
        [self lineFeed:index];
        self.row++;
        self.listModel.row = self.row;
        [FMDB updateTableList:self.listModel];
        self.count = 0;
        [self.bottomView setAllButtonWhiter];
        return;
    }
    
    if (CGColorEqualToColor(button.backgroundColor.CGColor, [UIColor colorWithQuick:220 green:250 blue:220].CGColor)) {
        [self lineFeed:index];
        [self getTopData];
//        [self getBottomData];
        [self setContentOffset];
        [self setpreRowMark];
        self.row++;
        self.listModel.row = self.row;
        [FMDB updateTableList:self.listModel];
        self.count = 0;
        [self.bottomView setAllButtonWhiter];
        return;
    }
    
    self.count ++;
    if (self.count >= 4) {
        [self insertData:index];
        //判断后5，6行数字
        [self.seletedArray addObject:@(index)];
        [self judgeResidue];
        
        
        //        self.count = 0;
        [self.bottomView setAllButtonGreen];
        return;
    }
    
    
    [self insertData:index];
    
    [self.seletedArray addObject:@(index)];
    
    
    [self.bottomView setButtonGray:index];
    
    
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
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size,NO, 0);
    
    [[UIColor clearColor] setFill];
    
    [[UIBezierPath bezierPathWithRect:self.view.bounds] fill];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //    [self.view.layer renderInContext:ctx];
    [self.navigationController.view.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

#pragma mark - 跳过
- (void)skipAction {
    self.listModel.skip = 1;
    [FMDB updateTableList:self.listModel];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, -60, 0, 0);
    UIButton *button = [self.bottomView viewWithTag:101];
    [self recoverData:button];
    
    [self createRightButton:NO or:NO];
    
}

- (void)wechat:(UIImage *)image {
    NSLog(@"%@",image);
    //    WXMediaMessage *message = [WXMediaMessage message];
    //    // 设置消息缩略图的方法
    //    [message setThumbImage:image];
    //    // 多媒体消息中包含的图片数据对象
    WXImageObject *imageObject = [WXImageObject object];
    //
    ////    UIImage *image = [UIImage imageNamed:@"要分享的图片名"];
    //
    //
    //    // 图片真实数据内容
    //
    NSData *data = UIImagePNGRepresentation(image);
    imageObject.imageData = data;
    // 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
    //    message.mediaObject = imageObject;
    //
    //    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    //    req.bText = NO;
    //    req.message = message;
    //    req.scene = WXSceneSession;// 分享到朋友圈
    //    [WXApi sendReq:req];
    //    NSData *data1 = UIImageJPEGRepresentation(image, 0.1);
    //    UIImage *resultImage = [UIImage imageWithData:data1];
    CGSize size = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    WXMediaMessage *message = [self messageWithTitle:nil
                                         Description:nil
                                              Object:imageObject
                                          MessageExt:@"这是第三方带的测试字段"
                                       MessageAction:@"<action>dotalist</action>"
                                          ThumbImage:resultImage
                                            MediaTag:@"WECHAT_TAG_JUMP_APP"];
    
    SendMessageToWXReq* req = [self requestWithText:nil
                                     OrMediaMessage:message
                                              bText:NO
                                            InScene:WXSceneSession];
    
    [WXApi sendReq:req];
    NSLog(@"分享%d", [WXApi sendReq:req]);
}

- (WXMediaMessage *)messageWithTitle:(NSString *)title
                         Description:(NSString *)description
                              Object:(id)mediaObject
                          MessageExt:(NSString *)messageExt
                       MessageAction:(NSString *)action
                          ThumbImage:(UIImage *)thumbImage
                            MediaTag:(NSString *)tagName {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = mediaObject;
    message.messageExt = messageExt;
    message.messageAction = action;
    message.mediaTagName = tagName;
    [message setThumbImage:thumbImage];
    return message;
}

- (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.scene = scene;
    //    if (req.scene == WXSceneSpecifiedSession) {
    //        req.toUserOpenId = @"oyAaTjoAesTaqxEm8pm2FQ4UZMkM";
    //    }
    if (bText)
        req.text = text;
    else
        req.message = message;
    return req;
}

@end
