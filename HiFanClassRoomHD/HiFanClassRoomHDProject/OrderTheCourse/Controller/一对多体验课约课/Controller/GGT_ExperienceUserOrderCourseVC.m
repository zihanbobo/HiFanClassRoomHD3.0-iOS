//
//  GGT_ExperienceUserOrderCourseVC.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_ExperienceUserOrderCourseVC.h"
#import "GGT_OrderCourseCollectionViewCell.h"
#import "GGT_OrderCourseTableViewCell.h"
#import "HF_PlaceHolderView.h"
#import "GGT_CustomPopAlertView.h"
#import "HF_PageControl.h"

static CGFloat const xc_cellWidth = 102.0f;
static CGFloat const xc_cellHeight = 78.0f;
static CGFloat const xc_cellMargin = 20.0f;

@interface GGT_ExperienceUserOrderCourseVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *xc_collectionView;
@property (nonatomic, strong) UITableView *xc_tableView;
@property (nonatomic, strong) NSMutableArray *xc_dateMuArray;
@property (nonatomic, strong) NSMutableArray *xc_courseMuArray;
@property (nonatomic, strong) GGT_DateModel *xc_model;
@property (nonatomic, strong) HF_PlaceHolderView *xc_placeHolderView;
@property (nonatomic, strong) HF_PageControl *pageControl;
@property (nonatomic, strong) UIPageControl *currentPageControl;
@property BOOL reFresh;

@end

@implementation GGT_ExperienceUserOrderCourseVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"约课";
    
    [self buildData];

    [self buildNetwork];
    
    [self buildUI];

    [self judgeHasAlert];
    
}

// 判断是否弹窗
- (void)judgeHasAlert {
    [[BaseService share] sendPostRequestWithPath:URL_SearchFirstLogin parameters:nil token:YES viewController:self success:^(id responseObject) {
        // 体验课学员需要弹框提醒
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"msg"] isKindOfClass:[NSString class]] && [responseObject[@"msg"] length] > 0) {
                
                [GGT_CustomPopAlertView viewWithMessage:responseObject[@"msg"] bottomButtonTitle:@"知道了" bgImg:@"外框" cancleBlock:^{
                    
                } enterBlock:^{
                    [self sureAlert];
                }];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

// 确定弹过窗
- (void)sureAlert {
    [[BaseService share] sendPostRequestWithPath:URL_SetFirstLogin parameters:nil token:YES viewController:self success:^(id responseObject) {

    } failure:^(NSError *error) {
        
    }];
}


- (void)buildData {
    self.xc_dateMuArray = [NSMutableArray array];
    self.xc_courseMuArray = [NSMutableArray array];
}


#pragma mark - 创建UI
- (void)buildUI {
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = LineH(10);
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(LineX(margin20));
        make.right.equalTo(self.view.mas_right).offset(-LineX(margin20));
        make.top.equalTo(self.view.mas_top).with.offset(LineY(margin20));
        make.height.mas_equalTo(LineH(168));
    }];
    
    
    // collectionView
    UICollectionViewFlowLayout *xc_layout = [[UICollectionViewFlowLayout alloc] init];
    xc_layout.itemSize = CGSizeMake(LineW(xc_cellWidth), LineH(xc_cellHeight));
    xc_layout.minimumLineSpacing = 0;
    xc_layout.minimumInteritemSpacing = 0;
    xc_layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.xc_collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:xc_layout];
        collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView;
    });
    [bgView addSubview:self.xc_collectionView];
    
    [self.xc_collectionView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(LineY(18));
        make.left.equalTo(bgView.mas_left).offset(LineX(11));
        make.right.equalTo(bgView.mas_right).offset(-LineX(11));
        make.height.mas_equalTo(LineH(xc_cellHeight));
    }];
    
    // 注册collectionViewCell
    [self.xc_collectionView registerClass:[GGT_OrderCourseCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([GGT_OrderCourseCollectionViewCell class])];
    

    self.pageControl = [[HF_PageControl alloc]initWithFrame:CGRectMake(0, 0, LineW(12), LineH(12))];
    self.pageControl.bounds = CGRectMake(0, 0, LineW(12), LineH(12));
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.currentPageIndicatorTintColor = UICOLOR_FROM_HEX(ColorFF6600);
    self.pageControl.pageIndicatorTintColor = UICOLOR_FROM_HEX_ALPHA(ColorFF6600, 20);
    self.currentPageControl = self.pageControl;
    [self.view addSubview:self.pageControl];
    
    [self.pageControl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_collectionView.mas_bottom).offset(LineY(margin20));
        make.left.right.equalTo(self.xc_collectionView);
        make.height.mas_equalTo(LineH(12));
    }];

    
    // tableView
    self.xc_tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorColor = [UIColor clearColor];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView;
    });
    [self.view addSubview:self.xc_tableView];
    
    [self.xc_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.top.equalTo(bgView.mas_bottom).offset(LineY(margin20));
        make.bottom.equalTo(self.view.mas_bottom).offset(-0);
    }];
    
    // 注册tableViewCell
    [self.xc_tableView registerClass:[GGT_OrderCourseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([GGT_OrderCourseTableViewCell class])];
    
    
    // 下拉刷新
    __unsafe_unretained UITableView *tableView = self.xc_tableView;
    
    @weakify(self);
    tableView.mj_header = [XCNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self buildNetworkWithDateTime:self.xc_model.DateTime];
        [tableView.mj_header endRefreshing];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.view layoutIfNeeded];
    
    // HF_PlaceHolderView
    self.xc_placeHolderView = [[HF_PlaceHolderView alloc]initWithFrame:CGRectZero withImgYHeight:LineY(110)];
    self.xc_placeHolderView.frame = CGRectMake(0, 0, SCREEN_WIDTH()-home_left_width-margin15*2, self.xc_tableView.height);
    self.xc_tableView.enablePlaceHolderView = YES;
    self.xc_tableView.xc_PlaceHolderView = self.xc_placeHolderView;
}

#pragma mark - 网络请求
- (void)buildNetwork {
    [[BaseService share] sendGetRequestWithPath:URL_GetDate token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] > 0) {
            NSArray *dataArray = responseObject[@"data"];
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GGT_DateModel *model = [GGT_DateModel yy_modelWithDictionary:obj];
                if (idx == 0) {
                    model.selectType = XCCellITypeSelect;
                    self.xc_model = model;
                    [self buildNetworkWithDateTime:model.DateTime];
                } else {
                    model.selectType = XCCellTypeDeselect;
                }
                [self.xc_dateMuArray addObject:model];
            }];
        }
        //计算总共几页
        self.pageControl.numberOfPages = self.xc_dateMuArray.count / 7;
        
        [self.xc_collectionView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)buildNetworkWithDateTime:(NSString *)dateTime {
    NSString *urlStr = [NSString stringWithFormat:@"%@?LessonTime=%@", URL_GetLessonRoomN, dateTime];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self showMBProgress:YES success:^(id responseObject) {

        [self.xc_courseMuArray removeAllObjects];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] > 0) {
            NSArray *dataArray = responseObject[@"data"];
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GGT_ExperienceCourseModel *model = [GGT_ExperienceCourseModel yy_modelWithDictionary:obj];
                [self.xc_courseMuArray addObject:model];
            }];

        }
        [self.xc_tableView reloadData];

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            HF_ResultModel *model = [HF_ResultModel yy_modelWithDictionary:responseObject];
            self.xc_placeHolderView.xc_model = model;
        }


    } failure:^(NSError *error) {
        HF_ResultModel *model = [HF_ResultModel yy_modelWithDictionary:error.userInfo];
        self.xc_placeHolderView.xc_model = model;
        [self.xc_tableView reloadData];
    }];
}


#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.xc_collectionView) {
        CGFloat x = scrollView.contentOffset.x;
        NSInteger count =  (int)ceil(x /self.xc_collectionView.width);
        self.currentPageControl.currentPage = count;
    }
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(LineY(0), LineX(20), LineY(0), LineX(20));
}

// 组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每组个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.xc_dateMuArray.count;
}

// 设置cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(xc_cellWidth), LineH(xc_cellHeight));
}

//返回行内部cell（item）之间的距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return LineH(xc_cellMargin);
}

//返回行间距 上下间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return LineH(20);
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_OrderCourseCollectionViewCell *cell = [GGT_OrderCourseCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.xc_model = self.xc_dateMuArray[indexPath.row];
    
    if (cell.xc_model.selectType == XCCellITypeSelect) {
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return cell;
}

// 设置header和footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

// collectionView的footer高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

// collectionView的header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

// 选中cell的时候
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GGT_DateModel *model = self.xc_dateMuArray[indexPath.row];
    model.selectType = XCCellITypeSelect;
    self.xc_model = model;
    [collectionView reloadData];

    // 选中上面的cell时 要刷新下面数据 请求接口
    [self buildNetworkWithDateTime:model.DateTime];
}

// 取消选中cell的时候
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    GGT_DateModel *model = self.xc_dateMuArray[indexPath.row];
    model.selectType = XCCellTypeDeselect;
    [self.xc_dateMuArray replaceObjectAtIndex:indexPath.row withObject:model];
    
}

#pragma mark - UITableViewCellDelegate & UITableViewCellDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.xc_courseMuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGT_OrderCourseTableViewCell *cell = [GGT_OrderCourseTableViewCell cellWithTableView:tableView forIndexPath:indexPath];
    cell.xc_model = self.xc_courseMuArray[indexPath.row];
    cell.xc_enterButton.tag = 100 + indexPath.row;
    [cell.xc_enterButton addTarget:self action:@selector(enterRoomAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LineH(178);
}


- (void)enterRoomAction:(UIButton *)button {
    /*
     BookingId  教材Id
     BDEId      单元Id
     LessonTime 开课时间
     LessonId  课程Id
     */
    [[BaseService share] sendGetRequestWithPath:URL_CheckClassHour token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        /*
         HasExpireTime = 0; 0 未过期 1 过期
         HasSurplus = 1;    1 有剩余课时 0 没有剩余课时
         */
        // 首先判断课时是否过期
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] > 0) {
                NSDictionary *dic = [responseObject[@"data"] firstObject];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    if ([dic[@"HasExpireTime"] integerValue] == 0) {       // 未过期
                        
                        // 判断是否拥有课时
                        if ([dic[@"HasSurplus"] integerValue] == 1) {        // 有剩余课时
                            
                            // 进行约课请求
                            GGT_ExperienceCourseModel *model = self.xc_courseMuArray[button.tag - 100];
                            [self bookingCourseAlertWithModel:model];
                            
                        } else {    // 没有剩余课时
                            LOSAlertPRO(responseObject[@"msg"], @"知道了");
                        }
                        
                    } else {        // 过期
                        [MBProgressHUD showMessage:responseObject[@"msg"] toView:self.view];
                    }
                }
            }
        }

    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
}

- (void)bookingCourseAlertWithModel:(GGT_ExperienceCourseModel *)model {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:xc_canBook preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self bookingCourseWithModel:model];
    }];

    alert.titleColor = UICOLOR_FROM_HEX(0x000000);
    cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
    doneAction.textColor = UICOLOR_FROM_HEX(Color2B8EEF);

    [alert addAction:cancelAction];
    [alert addAction:doneAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)bookingCourseWithModel:(GGT_ExperienceCourseModel *)model {
    NSString *urlStr = [NSString stringWithFormat:@"%@?bookID=%@&chapterID=%@&lessonTime=%@", URL_JoinAttendLesson, model.BookingId, model.BdId, model.StartTime];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
//        [MBProgressHUD showMessage:xc_courseSuccess toView:self.view];
        [MBProgressHUD showMessage:responseObject[@"msg"] toView:self.view];

        [self.xc_courseMuArray removeAllObjects];
        self.xc_courseMuArray = [NSMutableArray array];
        // 刷新数据
        [self buildNetworkWithDateTime:self.xc_model.DateTime];
        
    } failure:^(NSError *error) {
//        [MBProgressHUD showMessage:xc_courseNoSeat toView:self.view];
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];

    }];
}


@end
