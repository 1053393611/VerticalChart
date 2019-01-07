//
//  ContentCollectionViewCell.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/13.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "ContentCollectionViewCell.h"
#import "ItemCollectionViewCell.h"
#import "HeaderView.h"

#define HeadWidth 30


@interface ContentCollectionViewCell()<UICollectionViewDataSource, UICollectionViewDelegate>{
    NSInteger itemHeight;
}

@property (strong, nonatomic)UICollectionView *collectionView;

//@property (strong, nonatomic)UILabel *labelRow;
//@property (strong, nonatomic)UIImageView *imgView;

@property (copy, nonatomic)NSString *row;
@property (copy, nonatomic)NSMutableArray *data;




@end


@implementation ContentCollectionViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        itemHeight = self.contentView.bounds.size.height;
        self.data = [NSMutableArray array];
        [self customUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        itemHeight = self.contentView.bounds.size.height;
        self.data = [NSMutableArray array];
        [self customUI];
    }
    return self;
}

- (void)customUI {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWidth:) name:@"refreshWidth" object:nil];
    
    
    float itemWidth = (self.contentView.bounds.size.width - HeadWidth) / 12.0;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置UICollectionView为横向滚动
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 每一行cell之间的间距
    flowLayout.minimumLineSpacing = 0;
    // 每一列cell之间的间距
    flowLayout.minimumInteritemSpacing = 0;
    // 设置第一个cell和最后一个cell,与父控件之间的间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //    flowLayout.minimumLineSpacing = 1;// 根据需要编写
    //    flowLayout.minimumInteritemSpacing = 1;// 根据需要编写
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);// 该行代码就算不写,item也会有默认尺寸
//    flowLayout.headerReferenceSize = CGSizeMake(HeadWidth,itemHeight);
    
    self.collectionView.tag = 500;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, itemHeight) collectionViewLayout:flowLayout];
    self.collectionView.collectionViewLayout = flowLayout;
//    self.collectionView.backgroundColor = DefaultBackColor;
    self.collectionView.backgroundColor = [UIColor clearColor];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self.collectionView registerNib:[UINib nibWithNibName:@"ItemCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"itemCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeaderView" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"head"];

//    [self.collectionView registerNib:[UINib nibWithNibName:@"HeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.contentView addSubview:self.collectionView];
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 13;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HeaderView *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"head" forIndexPath:indexPath];
        if (!cell ) {
            cell = [[HeaderView alloc] init];
            
        }
        if (self.currentRow > self.index) {
            cell.labelRow.text = self.row;
            cell.imgView.hidden = YES;
            cell.labelRow.backgroundColor = DefaultBackColor;
        }else if (self.currentRow == self.index){
            cell.labelRow.text = self.row;
            cell.imgView.hidden = NO;
            cell.labelRow.backgroundColor = [UIColor clearColor];
        }else{
            cell.labelRow.text = @"";
            cell.imgView.hidden = YES;
            cell.labelRow.backgroundColor = DefaultBackColor;
        }
        if (self.currentRow == 0) {
            if (self.index == 0) {
                cell.labelRow.text = self.row;
                cell.imgView.hidden = YES;
                cell.labelRow.backgroundColor = DefaultBackColor;
            }else if(self.index == 1){
                cell.labelRow.text = self.row;
                cell.imgView.hidden = NO;
                cell.labelRow.backgroundColor = [UIColor clearColor];
            }
        }
        return cell;
    }else{
        ItemCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
        if (!cell ) {
            cell = [[ItemCollectionViewCell alloc] init];
            
        }
        cell.backgroundColor = [UIColor clearColor];
        
        if (indexPath.row == 2 || indexPath.row == 6) {
            cell.partLine.hidden = NO;
        }else {
            cell.partLine.hidden = YES;
        }
//        if (indexPath.row == 4) {
//            cell.backgroundColor = DefaultBackColor;
//        }else {
//            cell.backgroundColor = [UIColor whiteColor];
//        }
        cell.cellData = self.data[indexPath.row - 1];
        return cell;
    }
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    HeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//    if (self.currentRow > self.index) {
//        header.labelRow.text = self.row;
//        header.imgView.hidden = YES;
//        header.labelRow.backgroundColor = DefaultBackColor;
//    }else if (self.currentRow == self.index){
//        header.labelRow.text = self.row;
//        header.imgView.hidden = NO;
//        header.labelRow.backgroundColor = [UIColor clearColor];
//    }else{
//        header.labelRow.text = @"";
//        header.imgView.hidden = YES;
//        header.labelRow.backgroundColor = DefaultBackColor;
//    }
//    if (self.currentRow == 0) {
//        if (self.index == 0) {
//            header.labelRow.text = self.row;
//            header.imgView.hidden = YES;
//            header.labelRow.backgroundColor = DefaultBackColor;
//        }else if(self.index == 1){
//            header.labelRow.text = self.row;
//            header.imgView.hidden = NO;
//            header.labelRow.backgroundColor = [UIColor clearColor];
//        }
//    }
//    return header;
//}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return CGSizeMake(HeadWidth,itemHeight);
    }else {
        float itemWidth = (self.contentView.bounds.size.width - HeadWidth - 1) / 12.0;
        return CGSizeMake(itemWidth,itemHeight);
    }
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - 数据
-(void)setCellData:(NSArray *)cellData {
    
    self.data = [NSMutableArray arrayWithArray:cellData];
    self.row = [NSString stringWithFormat:@"%ld", self.index];
    [self.collectionView reloadData];

}

#pragma mark - 刷新宽度
- (void)refreshWidth:(NSNotification *)noti {
    NSLog(@"%@", self.contentView.subviews);
    itemHeight = [[noti object] integerValue];
    float itemWidth = (self.contentView.bounds.size.width - HeadWidth) / 12.0;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置UICollectionView为横向滚动
    //    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 每一行cell之间的间距
    flowLayout.minimumLineSpacing = 0;
    // 每一列cell之间的间距
    flowLayout.minimumInteritemSpacing = 0;
    // 设置第一个cell和最后一个cell,与父控件之间的间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //    flowLayout.minimumLineSpacing = 1;// 根据需要编写
    //    flowLayout.minimumInteritemSpacing = 1;// 根据需要编写
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);// 该行代码就算不写,item也会有默认尺寸
    flowLayout.headerReferenceSize = CGSizeMake(HeadWidth,itemHeight);
    
//    UICollectionView *collectionView = [self.contentView viewWithTag:500];
    UICollectionView *collectionView = self.contentView.subviews.firstObject;

    collectionView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, itemHeight);
    collectionView.collectionViewLayout = flowLayout;
    [self.collectionView reloadData];
}



@end
