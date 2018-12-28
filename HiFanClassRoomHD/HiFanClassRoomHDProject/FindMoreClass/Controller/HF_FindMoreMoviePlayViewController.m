//
//  HF_FindMoreMoviePlayViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_FindMoreMoviePlayViewController.h"
#import "HF_FindMoreMoviePlayCell.h"
#import "HF_FindMoreMoviePlayView.h"
#import "HF_BaseTabbarViewController.h"
#import "AppDelegate.h"
#import <UMSocialCore/UMSocialCore.h>
#import "HF_FindMoreShareViewController.h"

@interface HF_FindMoreMoviePlayViewController () <UICollectionViewDelegate,UICollectionViewDataSource,playerDelegate,UIPopoverPresentationControllerDelegate>
//@property(nonatomic,strong) UIBarButtonItem *likeBtn;//喜欢
//@property(nonatomic,strong) UIBarButtonItem *shareBtn;//分享
@property(nonatomic,strong) UIView *navView;
@property(nonatomic,strong) UIButton *likeBtn;//喜欢
@property(nonatomic,strong) UIButton *shareBtn;//分享





@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) HF_FindMoreMoviePlayView *headerView;
@property(nonatomic, strong) UIPopoverPresentationController *popover;

@end

@implementation HF_FindMoreMoviePlayViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setLeftItem:@"箭头"];
    self.navigationItem.title = self.model.Title;
    self.dataArray = [NSMutableArray array];

    [self initUI];
    [self getLoadData];
}

-(void)navButtonClick : (UIButton *)button {

    if (button.tag == 10) { //分享
        [self.shareBtn setImage:UIIMAGE_FROM_NAME(@"分享选中") forState:UIControlStateNormal];

        HF_FindMoreShareViewController *shareVc = [HF_FindMoreShareViewController new];//初始化内容视图控制器
        shareVc.preferredContentSize = CGSizeMake(LineW(166), LineH(54));
        shareVc.modalPresentationStyle = UIModalPresentationPopover;
        self.popover = shareVc.popoverPresentationController;//初始化一个popover
        self.popover.delegate = self;
        //设置popover的来源按钮（以button谁为参照）
        self.popover.sourceView = self.shareBtn;
        //设置弹出视图的位置（以button谁为参照）
        self.popover.sourceRect = self.shareBtn.bounds;
        self.popover.backgroundColor = [UIColor whiteColor];
        shareVc.shareUrl = self.shareUrlStr;
        [self presentViewController:shareVc animated:YES completion:nil];//推出popover
        
    } else if (button.tag == 20){ //喜欢
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/%ld",URL_UpdataLike,(long)self.ResourcesID];
        [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
            if ([responseObject[@"msg"] isKindOfClass:[NSString class]]) {
                [MBProgressHUD showMessage:responseObject[@"msg"] toView:self.view];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        }];
    }

}


-(void)getLoadData {
    NSString *urlStr;
    if (self.isLikeVc == YES) {  //我喜欢的
        urlStr = URL_GetLikeList;
    } else {                     //其他
        urlStr = [NSString stringWithFormat:@"%@?resourcesID=%ld",URL_GetInstructionalInfoList,(long)self.ResourcesID];
    }
    
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        
        if (self.isLikeVc == YES) {  //我喜欢的
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
                for (NSDictionary *dic in responseObject[@"data"]) {
                    HF_FindMoreInstructionalListModel *model = [HF_FindMoreInstructionalListModel yy_modelWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
            }
            
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            [self.collectionView reloadData];
        } else {                     //其他
            if ([responseObject[@"data"][@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"][@"data"] count] >0) {
                for (NSDictionary *dic in responseObject[@"data"][@"data"]) {
                    HF_FindMoreInstructionalListModel *model = [HF_FindMoreInstructionalListModel yy_modelWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
            }
            
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            [self.collectionView reloadData];
        }

        
    } failure:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        [self.collectionView reloadData];
    }];
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


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"HF_FindMoreMoviePlayCell";
    HF_FindMoreMoviePlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    HF_FindMoreInstructionalListModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    cell.cellModel = model;
    
    return cell;
}


//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(230),LineH(221));
}


//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, LineX(17), 0, LineX(17));
}


//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


//定义每个UICollectionView 的横向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return LineY(17);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HF_FindMoreInstructionalListModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    self.title = model.Title;
    self.ResourcesID = model.RecordID;
    self.headerView.playerUrlStr = model.RelationUrl;
    self.shareUrlStr = model.ShareUrl;
}


-(void)player:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn {
    if (self.headerView.wmPlayer.width == SCREEN_WIDTH()) {
        self.headerView.wmPlayer.frame = CGRectMake(LineX(184), LineY(71), LineW(556), LineH(313));
        [self.headerView addSubview:self.headerView.wmPlayer];
    } else {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        HF_BaseTabbarViewController *vc = (HF_BaseTabbarViewController *)window.rootViewController;
        self.headerView.wmPlayer.frame = CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT());
        [vc.view addSubview:self.headerView.wmPlayer];
    }
}


//MAEK:UI加载
-(void)initUI {
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
 
    [self.navView addSubview:self.likeBtn];
    [self.navView addSubview:self.shareBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navView];

    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];
    //注册cell
    [self.collectionView registerClass:[HF_FindMoreMoviePlayCell class] forCellWithReuseIdentifier:@"HF_FindMoreMoviePlayCell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-246);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-0);
    }];
}


//MARK:懒加载
-(HF_FindMoreMoviePlayView *)headerView {
    if (!_headerView) {
        self.headerView = [[HF_FindMoreMoviePlayView alloc] init];
        self.headerView.frame = CGRectMake(0, 0, home_right_width, LineH(456));
        self.headerView.playerUrlStr = self.playerUrlStr;
        self.headerView.playerDelegate = self;
    }
    return _headerView;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

-(UIView *)navView {
    if (!_navView) {
        self.navView = [[UIView alloc] init];
        self.navView.frame = CGRectMake(0, 0, LineW(130), LineH(44));
//        self.navView.backgroundColor = UICOLOR_RANDOM_COLOR();
    }
    return _navView;
}

//喜欢
-(UIButton *)likeBtn {
    if (!_likeBtn) {
        UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.likeNum == 0) {
            [btn setImage:UIIMAGE_FROM_NAME(@"灰爱心") forState:UIControlStateNormal];
        } else {
            [btn setImage:UIIMAGE_FROM_NAME(@"爱心") forState:UIControlStateNormal];
        }
        [btn setTitle:@"喜欢" forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, LineY(12), LineW(60), LineH(20));
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = Font(16);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -LineW(3), 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -LineW(3));
        [btn addTarget:self action:@selector(navButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn sizeToFit];
//        btn.backgroundColor = UICOLOR_RANDOM_COLOR();
        btn.tag = 20;
        self.likeBtn =  btn;
    }
    return _likeBtn;
}

//分享
-(UIButton *)shareBtn {
    if (!_shareBtn) {
        UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:UIIMAGE_FROM_NAME(@"灰分享") forState:UIControlStateNormal];
        [btn setTitle:@"分享" forState:UIControlStateNormal];
        btn.frame = CGRectMake(LineX(70),LineY(12), LineW(60), LineH(20));
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = Font(16);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -LineW(3), 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -LineW(3));
        [btn addTarget:self action:@selector(navButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.tag = 10;
        [btn sizeToFit];
//        btn.backgroundColor = UICOLOR_RANDOM_COLOR();
        self.shareBtn =  btn;
    }
    return _shareBtn;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
