//
//  GGT_OrderCourseViewController.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_OrderCourseViewController.h"
#import "GGT_OrderClassHeaderCell.h"
#import "GGT_OrderClassCollectionViewCell.h"
#import "GGT_LevelMenuViewController.h"
#import "GGT_OrderUnitCourseViewController.h"
#import "GGT_UnitBookListModel.h"


@interface GGT_OrderCourseViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UIPopoverPresentationControllerDelegate>

//显示所有等级的Vc
@property (nonatomic, strong) GGT_LevelMenuViewController *levelMenuVC;
@property(nonatomic, strong) UIPopoverPresentationController *popover;

//显示header的信息-Model
@property(nonatomic, strong) GGT_UnitBookListHeaderModel *unitBookListHeaderModel;

@property (nonatomic, strong) UICollectionView *orderClassCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger bookingIdS;
@property (nonatomic, strong) UIButton *xc_titleButton;

@end

@implementation GGT_OrderCourseViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.bookingIdS =  [[UserDefaults() objectForKey:K_BookingId] integerValue];
    
    [self initTitleView];
    [self initCollectionView];


    self.orderClassCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        self.dataArray = [NSMutableArray array];
        [self getLevelData];
        [self initCollectionViewLoadData];
    }];
    [self.orderClassCollectionView.mj_header beginRefreshing];
    
    
    self.orderClassCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self initCollectionViewLoadData];
    }];
    
}


#pragma mark 获取约课中的header的数据
- (void)getLevelData {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?BookingId=%ld", URL_GetBookOverInfo,(long)self.bookingIdS];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                self.unitBookListHeaderModel = [GGT_UnitBookListHeaderModel yy_modelWithDictionary:dic];
            }
        }
        
    }failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
}


#pragma mark 获取CollectionView数据
- (void)initCollectionViewLoadData {
    NSString *urlStr = [NSString stringWithFormat:@"%@?&bookingId=%ld",URL_GetUnitBookList,(long)self.bookingIdS];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            NSArray *tempArray = responseObject[@"data"];
            for (NSDictionary *dic in tempArray) {
                GGT_UnitBookListModel *model = [GGT_UnitBookListModel yy_modelWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
            [self.orderClassCollectionView.mj_footer endRefreshing];
            [self.orderClassCollectionView.mj_header endRefreshing];
            [self.orderClassCollectionView.mj_footer endRefreshingWithNoMoreData];
            
            [self.orderClassCollectionView reloadData];
        }
        

    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];

}


#pragma mark 初始化UICollectionView
- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _orderClassCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _orderClassCollectionView.delegate = self;
    _orderClassCollectionView.dataSource =self;
    _orderClassCollectionView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    _orderClassCollectionView.showsVerticalScrollIndicator = NO;
    _orderClassCollectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_orderClassCollectionView];
    
    [_orderClassCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-0);
    }];
    

    // 注册头视图
    [_orderClassCollectionView registerClass:[GGT_OrderClassHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OrderClassHeaderCell"];
    //注册cell
    [_orderClassCollectionView registerClass:[GGT_OrderClassCollectionViewCell class] forCellWithReuseIdentifier:@"OrderClassCell"];
}


#pragma mark -- UICollectionView代理
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *identify = @"OrderClassCell";
    GGT_OrderClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    //解决数据布局错乱问题
//    for (UIView *subView in cell.contentView.subviews) {
//        [subView removeFromSuperview];
//    }
    
    GGT_UnitBookListModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    [cell getModel:model];

    return cell;
}


//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(220),LineH(212));
}


//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(LineY(5), LineX(13), LineY(5), LineX(13));
}


//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return LineY(10);
}


//选中某item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_UnitBookListModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];

    //未解锁图片 IsUnlock 0是未解锁，1是已解锁
    if (model.IsUnlock == 0) {
      //未解锁
        return;
    } else {
        GGT_OrderUnitCourseViewController *Vc = [[GGT_OrderUnitCourseViewController alloc]init];
        Vc.unitBookListModel = model;
        Vc.refreshCell = ^(BOOL fresh) {
            //重新刷新数据
            self.dataArray = [NSMutableArray array];
            [self initCollectionViewLoadData];
        };
        [self.navigationController pushViewController:Vc animated:YES];
    }

}


//设置header的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(home_right_width,LineH(155));
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    GGT_OrderClassHeaderCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OrderClassHeaderCell" forIndexPath:indexPath];

    [header getModel:self.unitBookListHeaderModel];
    
    return header;
}


#pragma mark ---- 初始化titleView
- (void)initTitleView {
    UIButton *xc_titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //默认显示当前的等级信息Ax
    [xc_titleButton setTitle:[NSString stringWithFormat:@"%@",[UserDefaults() objectForKey:K_LevelName]] forState:UIControlStateNormal];
    [xc_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *image = UIIMAGE_FROM_NAME(@"xiala");
    [xc_titleButton setImage:image forState:UIControlStateNormal];
    
    [xc_titleButton.titleLabel sizeToFit];
    [xc_titleButton sizeToFit];
    // 设置button的insets
    [xc_titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [xc_titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, xc_titleButton.titleLabel.bounds.size.width + margin5, 0, -xc_titleButton.titleLabel.bounds.size.width - margin5)];
    [xc_titleButton setFrame:CGRectMake(0, 0, 200, 30)];
    self.xc_titleButton = xc_titleButton;
    self.navigationItem.titleView = xc_titleButton;
    
    
    @weakify(self);
    [[xc_titleButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         
         
         [xc_titleButton setImage:UIIMAGE_FROM_NAME(@"shangla") forState:UIControlStateNormal];
         
         self.levelMenuVC = [GGT_LevelMenuViewController new];//初始化内容视图控制器
         self.levelMenuVC.preferredContentSize = CGSizeMake(LineW(168), LineH(38));
         self.levelMenuVC.modalPresentationStyle = UIModalPresentationPopover;
         self.popover = self.levelMenuVC.popoverPresentationController;//初始化一个popover
         self.popover.delegate = self;
         //设置popover的来源按钮（以button谁为参照）
         self.popover.sourceView = self.xc_titleButton;
         //设置弹出视图的位置（以button谁为参照）
         self.popover.sourceRect = self.xc_titleButton.bounds;
         self.popover.backgroundColor = [UIColor whiteColor];
         
         __weak GGT_OrderCourseViewController *weakSelf  = self;
         self.levelMenuVC.getBookingIdBlock = ^(NSString *levelStr, NSInteger bookingIdS) {
             [xc_titleButton setTitle:levelStr forState:UIControlStateNormal];
             [xc_titleButton setImage:UIIMAGE_FROM_NAME(@"xiala") forState:UIControlStateNormal];
             [weakSelf dismissViewControllerAnimated:YES completion:nil];
             
             //重新刷新数据
             weakSelf.bookingIdS = bookingIdS;
             weakSelf.dataArray = [NSMutableArray array];
             [weakSelf getLevelData];
             [weakSelf initCollectionViewLoadData];
         };
         
         [self presentViewController:self.levelMenuVC animated:YES completion:nil];//推出popover
         
     }];
}


#pragma mark --  popVc实现代理方法
//默认返回的是覆盖整个屏幕，需设置成UIModalPresentationNone。
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

//点击蒙版是否消失，默认为yes；
-(BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    return YES;
}

//弹框消失时调用的方法
-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    //NSLog(@"弹框已经消失");
    [self.xc_titleButton setImage:UIIMAGE_FROM_NAME(@"xiala") forState:UIControlStateNormal];
}

@end
