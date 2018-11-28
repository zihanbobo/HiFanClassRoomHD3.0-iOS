//
//  GGT_OrderUnitCourseViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/27.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_OrderUnitCourseViewController.h"
/*UITableView*/
#import "GGT_OrderUnitCourseInfoCell.h"
#import "GGT_ClassBookDetailModel.h"
#import "GGT_OrderUnitCourseDateView.h"
#import "GGT_DateModel.h"
/*UICollectionView*/
#import "GGT_OrderUnitCourseCollectionCell.h"
#import "GGT_PlaceHolderView.h"
#import "GGT_OrderUnitCourseModel.h"
#import "GGT_OrderUnitCourseCollFooter.h"

#import "GGT_ApplyViewController.h"
#import "GGT_ApplySucceedViewController.h"

@interface GGT_OrderUnitCourseViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate, UITableViewDataSource,UIPopoverPresentationControllerDelegate,getClassStatusDelegate>
/*UITableView的相关内容*/
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GGT_ClassBookDetailModel *classBookDetailModel; //tableView的header模型
@property (nonatomic, strong) NSMutableArray *tableViewDateArray;
@property (nonatomic, copy) NSString *selectedDateStr; //选中的时间

/*UICollectionView的相关内容*/
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) GGT_PlaceHolderView *xc_placeholderView;
@property (nonatomic, strong) NSMutableArray *collectionDataArray;


//导航右侧文字
@property (nonatomic, strong) UIButton *rightBtn;
//刷新坐标
@property BOOL isRefreshFrame;
@end


@implementation GGT_OrderUnitCourseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    self.tableViewDateArray = [NSMutableArray array];
    
    [self initUI];
    
    [self initClassBookDetailsLoadData];
    [self buildNetwork];
    
    //初始化为NO
    self.isRefreshFrame = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.selectedDateStr = [formatter stringFromDate:[NSDate date]];
    
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.collectionDataArray removeAllObjects];
        self.collectionDataArray = [NSMutableArray array];
        [self initCollectionViewLoadData:self.selectedDateStr];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self initCollectionViewLoadData:self.selectedDateStr];
    }];
    
}

#pragma mark 导航设置
- (void)setNav {
    //设置背景颜色以及导航
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self setLeftItem:@"fanhui_white" title:@"返回"];
    self.navigationItem.title = [NSString stringWithFormat:@"%@   %@",self.unitBookListModel.LevelName,self.unitBookListModel.FileTittle];
    
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(0, 0, LineW(70), LineH(44));
    self.rightBtn.titleLabel.font = Font(16);
    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    [self.rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)getClassStatus:(BOOL)isShowRightBtn {
    if (isShowRightBtn == YES) {
        [self.rightBtn setTitle:@" " forState:UIControlStateNormal];
    }
}

-(void)rightAction:(UIButton *)button {
    //取消课程 和 取消申请 是一个接口
    
    if ([button.titleLabel.text isEqualToString:@"取消课程"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定取消本次课程" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //首先获取这个月取消了几次课程了
            [self CancelLessonCountData:self.classBookDetailModel.DemandId];
        }];
        
        alert.titleColor = UICOLOR_FROM_HEX(0x000000);
        cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
        doneAction.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
        
        [alert addAction:cancelAction];
        [alert addAction:doneAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if ([button.titleLabel.text isEqualToString:@"取消申请"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定取消本次申请" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //取消约课
            [self CancelLessonData:self.classBookDetailModel.DemandId];
        }];
        
        alert.titleColor = UICOLOR_FROM_HEX(0x000000);
        cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
        doneAction.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
        
        [alert addAction:cancelAction];
        [alert addAction:doneAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if ([button.titleLabel.text isEqualToString:@" "]) {
        NSLog(@"按钮状态为空，不进行操作");
    }
}

#pragma mark ------------------UITableView的相关信息------------------
#pragma mark - 网络请求
- (void)buildNetwork {
    [[BaseService share] sendGetRequestWithPath:URL_GetDate token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] > 0) {
            NSArray *dataArray = responseObject[@"data"];
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GGT_DateModel *model = [GGT_DateModel yy_modelWithDictionary:obj];
                if (idx == 0) {
                    model.selectType = XCCellITypeSelect;
                    //[self initCollectionViewLoadData:model.DateTime];
                } else {
                    model.selectType = XCCellTypeDeselect;
                }
                [self.tableViewDateArray addObject:model];
            }];
            
            // 刷新
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
}

#pragma mark 获取这节课程是否预约
- (void)initClassBookDetailsLoadData {
    //获取这节课程是否预约
    NSString *urlStr = [NSString stringWithFormat:@"%@?BdeId=%ld&BookingId=%ld",URL_GetClassBookDetails,(long)self.unitBookListModel.BDEId,(long)self.unitBookListModel.BookingId];
    
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                self.classBookDetailModel = [GGT_ClassBookDetailModel yy_modelWithDictionary:dic];
            }
            
            if (self.classBookDetailModel.OpenClassType == 1) { //1 加入班级
                if (self.classBookDetailModel.DemandId >0) {
                    [self.rightBtn setTitle:@"取消课程" forState:UIControlStateNormal];
                }
                
            } else if (self.classBookDetailModel.OpenClassType == 2) { //2 申请开班
                [self.rightBtn setTitle:@"取消申请" forState:UIControlStateNormal];
            }
            
        }

        // 刷新
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
}



#pragma mark UITableView和UICollectionView初始化
- (void)initUI {
    //UITableView初始化
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(LineX(margin20), 0, home_right_width-LineX(margin40), LineH(366)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.view addSubview:self.tableView];
    
    
    //UICollectionView初始化
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, LineY(10)+self.tableView.height, home_right_width, SCREEN_HEIGHT()-self.tableView.height-LineH(74)) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.view addSubview:self.collectionView];
    
    
    
    //注册cell
//    [self.collectionView registerClass:[GGT_OrderUnitCourseCollFooter class] forCellWithReuseIdentifier:@"GGT_OrderUnitCourseViewFooter"];
    [self.collectionView registerClass:[GGT_OrderUnitCourseCollectionCell class] forCellWithReuseIdentifier:@"OrderUnitCell"];
    
    //添加xc_placeholderView
    self.xc_placeholderView = [[GGT_PlaceHolderView alloc] initWithFrame:CGRectZero withImgYHeight:LineY(20)];
    self.xc_placeholderView.frame = CGRectMake(0, 0, self.collectionView.width, LineH(396));
    [self.collectionView addSubview:self.xc_placeholderView];
    self.xc_placeholderView.hidden = YES;
}


#pragma mark - UITableViewCellDelegate & UITableViewCellDataSource
// scrollView 已经滑动----方案1
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.collectionView.bounces = YES;
    
    if (!IsArrEmpty(self.collectionDataArray)) { //数组不为空
        if (scrollView == self.collectionView) {
            
            //分2行的时候，才可以联动，1行可以显示完整，没意义
            if (self.collectionDataArray.count >=5) {
                
                CGFloat offsetY = self.collectionView.contentOffset.y;
                CGPoint offset = self.tableView.contentOffset;
                
                //如果往上，联动，往下禁止联动
                if (offsetY > 0 ) {
                    offset.y = offsetY;
                    self.tableView.contentOffset = offset;
                }
                
                
                
                CGFloat Y =  scrollView.contentOffset.y;
                
                
                
                
                if (Y < LineY(198) && Y >0) { //未到达某个点
                    self.tableView.frame = CGRectMake(LineX(margin20), 0, home_right_width-LineX(margin40), LineH(366)-Y);
                    self.collectionView.frame = CGRectMake(0, LineY(10) + self.tableView.height, home_right_width, SCREEN_HEIGHT() - self.tableView.height -LineH(74));
                    self.collectionView.bounces = NO;
                    
                } else if (Y >= LineY(198) && Y >0){ //到达某个点
                    if (self.isRefreshFrame == YES) {
                        self.tableView.frame = CGRectMake(LineX(margin20), 0, home_right_width-LineX(margin40), LineH(168));
                        self.tableView.contentOffset = CGPointMake(0,0);
                        self.collectionView.frame = CGRectMake(0, LineY(10) + self.tableView.height, home_right_width, SCREEN_HEIGHT() - self.tableView.height -LineH(74));
                        self.isRefreshFrame = NO;
                        
                    } else if(self.isRefreshFrame == NO){
                        self.tableView.frame = CGRectMake(LineX(margin20), 0, home_right_width-LineX(margin40), LineH(168));
                        self.tableView.contentOffset = CGPointMake(0,LineY(198));
                        self.collectionView.frame = CGRectMake(0, LineY(10) + self.tableView.height, home_right_width, SCREEN_HEIGHT() - self.tableView.height -LineH(74));
                        
                    }
                    
                }else if (self.collectionView.contentOffset.y < 0) {
                    
                    //正常坐标
                    self.tableView.frame = CGRectMake(LineX(margin20), 0, home_right_width-LineX(margin40), LineH(366));
                    self.collectionView.frame = CGRectMake(0, LineY(10) + self.tableView.height, home_right_width, SCREEN_HEIGHT()-self.tableView.height-LineH(74));
                    
                }
            } else if (self.collectionDataArray.count <=4) {//少于1行的时候，下拉，坐标重置为初始状态
                CGFloat offsetY = self.collectionView.contentOffset.y;
                //判断下拉
                if (offsetY < 0) {
                    [UIView animateWithDuration:0.5 animations:^{
                        //数组为空,改变坐标
                        self.tableView.frame = CGRectMake(LineX(margin20), 0, home_right_width-LineX(margin40), LineH(366));
                        self.collectionView.frame = CGRectMake(0, LineY(10) + self.tableView.height, home_right_width, SCREEN_HEIGHT()-self.tableView.height-LineH(74));
                        
                    }];
                }
            }
        }
    } else {
        
        CGFloat offsetY = self.collectionView.contentOffset.y;
        //判断下拉
        if (offsetY < 0) {
            [UIView animateWithDuration:0.5 animations:^{
                //数组为空,改变坐标
                self.tableView.frame = CGRectMake(LineX(margin20), 0, home_right_width-LineX(margin40), LineH(366));
                self.collectionView.frame = CGRectMake(0, LineY(10) + self.tableView.height, home_right_width, SCREEN_HEIGHT()-self.tableView.height-LineH(74));
                
            }];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellStr1 = @"GGT_OrderUnitCourseInfoCell";
        GGT_OrderUnitCourseInfoCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellStr1];
        if (!cell1) {
            cell1 = [[GGT_OrderUnitCourseInfoCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellStr1];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell1.degegate = self;
        [cell1 getModel:self.classBookDetailModel];
        [cell1.classEnterButton addTarget:self action:@selector(cancleButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
//        [cell1.yaoqingButton addTarget:self action:@selector(yaoqingButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        return cell1;
    } else if(indexPath.row == 1){
        static NSString *cellStr2 = @"GGT_OrderUnitCourseDateView";
        GGT_OrderUnitCourseDateView *cell2 = [tableView dequeueReusableCellWithIdentifier:cellStr2];
        if (!cell2) {
            cell2 = [[GGT_OrderUnitCourseDateView alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellStr2];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        [cell2 getArray:self.tableViewDateArray];
        
        __weak GGT_OrderUnitCourseViewController *weakSelf = self;
        cell2.getDateBlock = ^(NSString *dateTime) {
            self.selectedDateStr = dateTime;
            [self.collectionDataArray removeAllObjects];
            self.collectionDataArray = [NSMutableArray array];
            [weakSelf initCollectionViewLoadData:self.selectedDateStr];
        };
        
        
        return cell2;
    } else {
        NSLog(@"Some exception message for unexpected tableView");
        abort();  //__attribute__((noreturn)) 静态内存泄漏解决办法
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return LineH(198);
    } else {
        return LineH(168);
    }
}


#pragma mark ------------------UICollectionView的相关信息------------------
#pragma mark UICollectionView的数据请求----获取这节课程是否预约
- (void)initCollectionViewLoadData : (NSString *)dateTime {
    //获取这节课程是否预约
    NSString *urlStr = [NSString stringWithFormat:@"%@?bookID=%ld&chapterID=%ld&lessonTime=%@",URL_GetAttendLessonList,(long)self.unitBookListModel.BookingId,(long)self.unitBookListModel.BDEId,dateTime];
    
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            NSArray *resultArray = responseObject[@"data"];
            
            //data有数据，请求并展示
            self.xc_placeholderView.hidden = YES;
            for (NSDictionary *bigdic in resultArray) {
                GGT_OrderUnitCourseModel *model = [GGT_OrderUnitCourseModel yy_modelWithDictionary:bigdic];
                [self.collectionDataArray addObject:model];
            }
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            self.collectionView.mj_footer.hidden = YES;
            
            
            [self.collectionView reloadData];
            
            
        } else {
            NSDictionary *dic = responseObject;
            GGT_ResultModel *model = [GGT_ResultModel yy_modelWithDictionary:dic];
            self.xc_placeholderView.xc_model = model;
            self.xc_placeholderView.hidden = NO;
            
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView.mj_header endRefreshing];
            self.collectionView.mj_footer.hidden = YES;
            
            
            [self.collectionView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
        NSDictionary *dic = error.userInfo;
        GGT_ResultModel *model = [GGT_ResultModel yy_modelWithDictionary:dic];
        self.xc_placeholderView.xc_model = model;
        self.xc_placeholderView.hidden = NO;
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        self.collectionView.mj_footer.hidden = YES;
        
        [self.collectionView reloadData];
        
    }];
}


#pragma mark -- UICollectionViewDelegate--
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.collectionDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"OrderUnitCell";
    GGT_OrderUnitCourseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    GGT_OrderUnitCourseModel *model = [self.collectionDataArray safe_objectAtIndex:indexPath.row];
    
    [cell getCellModel:model];
    
    
    cell.joinButton.tag = 1000 + indexPath.row;
    [cell.joinButton addTarget:self action:@selector(joinButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return cell;

}



//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(208),LineH(152));
}



//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(LineY(10), LineX(20), LineY(10), LineX(20));
}


//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return LineY(20);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return LineY(20);
}


/*
#pragma mark ------------邀请好友  的操作-------------------------
-(void)yaoqingButtonClick {
    GGT_ApplySucceedViewController *vc = [GGT_ApplySucceedViewController new];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.popoverPresentationController.delegate = self;
    vc.preferredContentSize = CGSizeMake(460, 296);
    vc.classTypeName = @"邀请好友";
    
    
    //文字赋值
    if (self.classBookDetailModel.OpenClassType == 1) {//加入班级
        vc.jiaocaiStr = [NSString stringWithFormat:@"已加入 %@ 的课程",self.classBookDetailModel.StartTimePad];
        vc.chengbanStr = [NSString stringWithFormat:@"剩余%ld个席位",(long)self.classBookDetailModel.ResidueNum];
        
    } else  if (self.classBookDetailModel.OpenClassType == 2) { //申请开班
        vc.jiaocaiStr = [NSString stringWithFormat:@"已申请 %@ 的课程",self.classBookDetailModel.StartTimePad];
        vc.chengbanStr = [NSString stringWithFormat:@"还差%ld人开班",(long)self.classBookDetailModel.ResidueNum];
    }
    if ([self.classBookDetailModel.shareUrl isKindOfClass:[NSString class]] && self.classBookDetailModel.shareUrl.length >0) {
        vc.codeStr = self.classBookDetailModel.shareUrl;
    }
    
    [self presentViewController:nav animated:YES completion:nil];
}
*/

#pragma mark ------------加入  的操作-------------------------
#pragma mark 加入课程学习
- (void)joinButtonClick :(UIButton *)button {
    //ShowStatus 显示状态: 1=加入班级,2=申请开班,3=已满班
    
    //首先先检查课时。再继续下步操作
    //BookingId  教材Id
    //BDEId      单元Id
    //LessonTime 开课时间
    //LessonId  课程Id
    
    [[BaseService share] sendGetRequestWithPath:URL_CheckClassHour token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
        
        //HasExpireTime = 0; 0 未过期 1 过期
        //HasSurplus = 1;    1 有剩余课时 0 没有剩余课时
        
        // 首先判断课时是否过期
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] > 0) {
                NSDictionary *dic = [responseObject[@"data"] firstObject];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    if ([dic[@"HasExpireTime"] integerValue] == 0) {       // 未过期
                        
                        // 判断是否拥有课时
                        if ([dic[@"HasSurplus"] integerValue] == 1) {        // 有剩余课时
                            
                            // 进行约课请求
                            GGT_OrderUnitCourseModel *model = [self.collectionDataArray safe_objectAtIndex:button.tag - 1000];
                            [self bookingCourseAlertWithModel:model withButtonTitle:button.titleLabel.text];
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


- (void)bookingCourseAlertWithModel:(GGT_OrderUnitCourseModel *)model  withButtonTitle:(NSString *)buttonTitle{
    //1=加入班级,2=申请开班,3=已满班
    if ([buttonTitle isEqualToString:@"申请开班"]) {
        
        
        //弹出控制器
        GGT_ApplyViewController *vc = [GGT_ApplyViewController new];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        nav.popoverPresentationController.delegate = self;
        vc.sureBlock = ^(BOOL sure) {
            [self kaibanshenqingLoadData :model];
        };
        
        //处理课程名称
        NSString *classNameSrt;
        if (!IsStrEmpty(self.classBookDetailModel.FileTittle)) {
            NSRange range;
            range = [self.classBookDetailModel.FileTittle rangeOfString:@" "];
            if (range.location != NSNotFound) {
                NSString *titleStr = [self.classBookDetailModel.FileTittle substringFromIndex:range.location];//截取下标 之后的字符串
                classNameSrt = [NSString stringWithFormat:@"%@ %@",self.classBookDetailModel.LevelName,titleStr];
                
            } else {
                //Not Found
                classNameSrt = [NSString stringWithFormat:@"%@ %@",self.classBookDetailModel.LevelName,self.classBookDetailModel.FileTittle];
            }
        }
        
        
        vc.classNameStr = classNameSrt;
        vc.classTimeStr = [NSString stringWithFormat:@"%@",model.WeekDay];
        [self presentViewController:nav animated:YES completion:nil];
        
        
    } else if ([buttonTitle isEqualToString:@"加入班级"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:xc_canBook preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self joinClassLoadData : model];
        }];
        
        alert.titleColor = UICOLOR_FROM_HEX(0x000000);
        cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
        doneAction.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
        
        [alert addAction:cancelAction];
        [alert addAction:doneAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark 开班申请
- (void)kaibanshenqingLoadData :(GGT_OrderUnitCourseModel *)model {
    NSString *urlStr = [NSString stringWithFormat:@"%@?bookID=%ld&chapterID=%ld&lessonTime=%@", URL_JoinSubscribeLesson, (long)self.unitBookListModel.BookingId, (long)self.unitBookListModel.BDEId, model.LessonTime];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
        
        //再次请求是否约课接口
        [self refreshLodaData];

        //关闭申请开班弹窗
        [self dismissViewControllerAnimated:YES completion:nil];
        
        //弹出申请开班成功弹窗
        GGT_ApplySucceedViewController *vc = [GGT_ApplySucceedViewController new];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        nav.popoverPresentationController.delegate = self;
        vc.preferredContentSize = CGSizeMake(460, 238);
        vc.classTypeName = @"申请成功";
        
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSString *countStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"Count"]];
            if ([countStr isKindOfClass:[NSString class]] && countStr.length >0) {
                vc.shenqingStr =  [NSString stringWithFormat:@"申请成功！还差%@人开班",countStr];
            } else {
                vc.shenqingStr =  [NSString stringWithFormat:@"申请成功！还差0人开班"];
            }
            
            NSString *url = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"URL"]];
            if ([url isKindOfClass:[NSString class]] && url.length >0) {
                vc.codeStr =  url;
            } else {
                vc.codeStr =  @"http://www.hi-fan.cn";
            }
        }
        
        [self presentViewController:nav animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LOSAlertPRO(error.userInfo[@"msg"], @"知道了");
        });
        
    }];
}


#pragma mark 加入房间
- (void)joinClassLoadData : (GGT_OrderUnitCourseModel *)model{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?bookID=%ld&chapterID=%ld&lessonTime=%@", URL_JoinAttendLesson, (long)self.unitBookListModel.BookingId, (long)self.unitBookListModel.BDEId,model.LessonTime];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
        [MBProgressHUD showMessage:responseObject[@"data"] toView:self.view];
        
        
        //再次请求是否约课接口
        [self refreshLodaData];

        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
}

#pragma mark ------------进入教室  的操作-------------------------
- (void)cancleButtonClick :(UIButton *)button {
    GGT_ClassRoomModel *tkModel = [[GGT_ClassRoomModel alloc] init];
    tkModel.serial = self.classBookDetailModel.serial;
    tkModel.host = self.classBookDetailModel.host;
    tkModel.port = self.classBookDetailModel.port;
    tkModel.nickname = self.classBookDetailModel.nickname;
    tkModel.userrole = self.classBookDetailModel.userrole;
    tkModel.LessonId = self.classBookDetailModel.LessionId;
    
    
    [GGT_ClassRoomManager tk_enterClassroomWithViewController:self courseModel:tkModel leftRoomBlock:^{
        
    }];
}

//首先获取这个月取消了课程的次数
- (void)CancelLessonCountData : (NSInteger )DemandId {
    
    [[BaseService share] sendGetRequestWithPath:URL_CancelLessonCount token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //取消约课
            [self CancelLessonData:DemandId];
        }];
        
        
        alert.titleColor = UICOLOR_FROM_HEX(0x000000);
        cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
        doneAction.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
        
        [alert addAction:cancelAction];
        [alert addAction:doneAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        
    }];
}


//取消约课
- (void)CancelLessonData : (NSInteger )DemandId {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?&DemandId=%ld",URL_CancelLesson,(long)DemandId];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        [MBProgressHUD showMessage:responseObject[@"msg"] toView:self.view];
        
        //刷新
        [self refreshLodaData];
        [self.rightBtn setTitle:@" " forState:UIControlStateNormal];
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
}

#pragma mark 刷新数据
-(void)refreshLodaData {
    //刷新
    [self initClassBookDetailsLoadData];
    self.isRefreshFrame = YES;
    
    [self.collectionDataArray removeAllObjects];
    self.collectionDataArray = [NSMutableArray array];
    [self initCollectionViewLoadData:self.selectedDateStr];
    
    if (self.refreshCell) {
        self.refreshCell(YES);
    }
}


- (void)leftAction {
    GGT_OrderUnitCourseInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.countDown = 0;
    [cell.timer invalidate];
    cell.timer = nil;

    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

