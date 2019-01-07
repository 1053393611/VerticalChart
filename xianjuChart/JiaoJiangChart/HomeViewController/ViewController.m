//
//  ViewController.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/13.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "ViewController.h"
#import "HomeTableViewCell.h"
#import "ContentViewController.h"
#import "CustomPopOverView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, CustomPopOverViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *arrChartList;
@property (copy, nonatomic)NSString *sortType;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.sortType = @"updateTime";
    [self customNavButton];
    [self customToolButton];
    [self createUITabviewHomePage];
    // 允许在编辑模式下进行多选操作
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
}
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getChartList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
// tableview
-(void)createUITabviewHomePage {
    
    
    _tableView.delegate   = self;
    _tableView.dataSource = self;
//    _tableView.backgroundColor = DefaultBackColor;
//    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)){
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
    }
    _tableView.estimatedRowHeight = 100;
    
    
}

// 导航栏按钮
- (void)customNavButton {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 110, 36);
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"新建图纸" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithSome:0] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    leftButton.layer.masksToBounds = YES;
    leftButton.layer.cornerRadius = 18;
    leftButton.layer.borderWidth = 1;
    leftButton.layer.borderColor = [UIColor colorWithSome:100].CGColor;
    leftButton.backgroundColor = DefaultBackColor;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

    UIButton *leftButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton1.frame = CGRectMake(0, 0, 110, 36);
    [leftButton1 addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton1 setTitle:@"批量删除" forState:UIControlStateNormal];
    [leftButton1 setTitleColor:[UIColor colorWithSome:0] forState:UIControlStateNormal];
    leftButton1.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    leftButton1.layer.masksToBounds = YES;
    leftButton1.layer.cornerRadius = 18;
    leftButton1.layer.borderWidth = 1;
    leftButton1.layer.borderColor = [UIColor colorWithSome:100].CGColor;
    leftButton1.backgroundColor = DefaultBackColor;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithCustomView:leftButton1];
    NSArray *array = @[left, left1];
    self.navigationItem.leftBarButtonItems = array;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 180, 36);
    [rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"以修改时间排序" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithSome:0] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"filtrate"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"filtrate"] forState:UIControlStateHighlighted];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    rightButton.layer.masksToBounds = YES;
    rightButton.layer.cornerRadius = 5;
    rightButton.layer.borderWidth = 1;
    rightButton.layer.borderColor = [UIColor colorWithSome:100].CGColor;
    rightButton.backgroundColor = DefaultBackColor;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = right;

}

- (void)customToolButton {
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"增加" style:UIBarButtonItemStylePlain target:self action:nil];
    //设置按钮的位置，词条代码为关键
    [addBtn setWidth:50];
    addBtn.customView.center = CGPointMake(0, 500);
    UIBarButtonItem *delBtn = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:nil];
    [delBtn setWidth:400];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 80, 36);
    [leftButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithSome:0] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    leftButton.layer.masksToBounds = YES;
    leftButton.layer.cornerRadius = 18;
    leftButton.layer.borderWidth = 1;
    leftButton.layer.borderColor = [UIColor colorWithSome:100].CGColor;
    leftButton.backgroundColor = DefaultBackColor;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIButton *leftButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton1.frame = CGRectMake(0, 0, 80, 36);
    [leftButton1 addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton1 setTitle:@"完成" forState:UIControlStateNormal];
    [leftButton1 setTitleColor:[UIColor colorWithSome:0] forState:UIControlStateNormal];
    leftButton1.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    leftButton1.layer.masksToBounds = YES;
    leftButton1.layer.cornerRadius = 18;
    leftButton1.layer.borderWidth = 1;
    leftButton1.layer.borderColor = [UIColor colorWithSome:100].CGColor;
    leftButton1.backgroundColor = DefaultBackColor;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithCustomView:leftButton1];
    NSArray *array = @[left, left1];
    self.toolbarItems = array;
    
    
}


#pragma mark - UIcollectionView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrChartList.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeTableViewCell class])];
    if ( cell == nil ) {
        cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([HomeTableViewCell class])];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.cellData = [ListModel dictionaryWithListModel:self.arrChartList[indexPath.row]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContentViewController *vc = HBALLOCOBJ(ContentViewController);
    vc.listModel = self.arrChartList[indexPath.row];
    vc.isUpdate = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 按钮
- (void)leftAction {
    ListModel *model= [[ListModel alloc] init];
    model.listId = [self getNowTimeTimestamp];
    model.title = @"无备注";
    model.createTime = [self getNowTime];
    model.updateTime = [self getNowTime];
    model.row = 0;
    model.skip = 0;
    [FMDB insertTableList:model];
    
//    for (NSInteger i = 0; i < 20; i++) {
//        [FMDB insertDetail:i detailId:model.listId];
//    }
//    for (NSInteger i = 0; i < 12; i ++) {
//        DetailModel *dModel = [DetailModel initWithDetailId:model.listId row:i column:1 mark:0 data:0 background:1 seleted:0];
//        [FMDB updateDetail:dModel];
//    }
//    DetailModel *dModel = [DetailModel initWithDetailId:model.listId row:4 column:0 mark:0 data:0 background:0 seleted:1];
//    [FMDB updateDetail:dModel];
    [FMDB initDetail:model.listId];
    
    
    ContentViewController *vc = HBALLOCOBJ(ContentViewController);
    vc.listModel = model;
    vc.isUpdate = YES;
    [self.navigationController pushViewController:vc animated:YES];

    
}

- (void)deleteAction:(UIButton *)button {
    [self.tableView setEditing:YES animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
    self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.customView.userInteractionEnabled = NO;

}

- (void)cancelAction {
    [self.tableView setEditing:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem.customView.userInteractionEnabled = YES;

}

- (void)completeAction {
    // 获取被选中的行号
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    // 遍历所有的行号
    NSMutableArray *deleteArray = [NSMutableArray array];
    for (NSIndexPath *paths in indexPaths) {
        [deleteArray addObject:self.arrChartList[paths.row]];
         [FMDB deleteTableList:self.arrChartList[paths.row]];
    }
    // 删除被选中的行号模型数据
    [self.arrChartList removeObjectsInArray:deleteArray];
    
    [self.tableView reloadData];
    
    [self.tableView setEditing:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem.customView.userInteractionEnabled = YES;
    
}

- (void)rightAction:(UIButton *)button {
//    NSArray *titles = @[@"Menu1", @"Menu2", @"Ah_Menu3"];
    PopOverVieConfiguration *config = [PopOverVieConfiguration new];
    config.triAngelHeight = 15;
    config.triAngelWidth = 25;
    config.containerViewCornerRadius = 8.0;
    config.roundMargin = 10;
    config.defaultRowHeight = 40;
    config.tableBackgroundColor = [UIColor colorWithSome:255];
    config.textColor = [UIColor colorWithSome:10];
    config.textAlignment = NSTextAlignmentLeft;
    
    NSArray *arr = @[
                     @{@"name": @"以创建时间排序"},
                     @{@"name": @"以修改时间排序"},
                     @{@"name": @"以局数排序"},
                     @{@"name": @"以备注排序"}
                     ];
    
    CustomPopOverView *view = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, 250, 40*4) titleInfo:arr config:config];
    view.containerBackgroudColor = [UIColor colorWithSome:230];
    view.delegate = self;
    [view showFrom:button alignStyle:CPAlignStyleRight];
    
}
#pragma mark- CustomPopOverViewDelegate


- (void)popOverViewDidShow:(CustomPopOverView *)pView
{
//    NSLog(@"popOverViewDidShow");
}
- (void)popOverViewDidDismiss:(CustomPopOverView *)pView
{
//    NSLog(@"popOverViewDidDismiss");
}

- (void)popOverView:(CustomPopOverView *)pView didClickMenuIndex:(NSInteger)index
{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"index is %d", (int)index] message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [alert show];
    // 修改按钮
    NSArray *array = @[@"以创建时间排序", @"以修改时间排序", @"以局数排序", @"以备注排序"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 180, 36);
    [rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:array[index] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithSome:0] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"filtrate"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"filtrate"] forState:UIControlStateHighlighted];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    rightButton.layer.masksToBounds = YES;
    rightButton.layer.cornerRadius = 5;
    rightButton.layer.borderWidth = 1;
    rightButton.layer.borderColor = [UIColor colorWithSome:100].CGColor;
    rightButton.backgroundColor = DefaultBackColor;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = right;
    
    // 获取数据
    NSArray *a = @[@"createTime", @"updateTime", @"row", @"title"];
    self.sortType = a[index];
    [self getChartList];

}




#pragma mark - 数据
// 获取数据
- (void)getChartList {

//    NSDictionary *dic = @{@"title":@"标题名",@"createTime":@"创建时间",@"updateTime":@"更新时间",@"row":@"0"};
//
//    self.arrChartList = [NSMutableArray arrayWithArray:@[dic,dic,dic,dic,dic,dic,dic,dic,dic,dic]];
    self.arrChartList = [FMDB selectTableList:self.sortType];
    [self.tableView reloadData];
}

// 插入数据



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

-(NSString *)getNowTimeTimestamp{
    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}



        
 


@end
