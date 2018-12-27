//
//  HF_MineClassCountViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/10.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_MineClassCountViewController.h"
#import "HF_MineClassCountHeaderCell.h"
#import "HF_MineClassCountListCell.h"
#import "HF_MineClassCountHeaderModel.h"
#import "HF_MineClassCountListModel.h"

@interface HF_MineClassCountViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UILabel *myCountLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *detailDataArray;
@property (nonatomic, strong) HF_MineClassCountHeaderModel *headerModel;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) HF_PlaceHolderView *placeHolderView;
@end

@implementation HF_MineClassCountViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.detailDataArray = [NSMutableArray array];
        self.page = 1;
        [self getHeaderLoadData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self getDetailLoadData];
    }];
    
}


- (void)getDetailLoadData {
    NSString *urlStr = [NSString stringWithFormat:@"%@?pageSize=10&pageIndex=%ld",URL_GetClassHourPage,(long)self.page];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            NSArray *array = responseObject[@"data"];
            for (NSDictionary *dic in array) {
                NSString *hourStr = [NSString stringWithFormat:@"%@",dic[@"Hours"]];
                
                if (![hourStr xc_isContainString:@"-" ] && ![hourStr xc_isContainString:@"+"]) {
                    hourStr = [NSString stringWithFormat:@"+%@",hourStr];
                }
                
                HF_MineClassCountListModel *model = [HF_MineClassCountListModel yy_modelWithDictionary:dic];
                [self.detailDataArray addObject:model];
            }
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.detailDataArray.count >0 && self.detailDataArray.count <10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = NO;
        }
        [self.tableView reloadData];
        
    }failure:^(NSError *error) {
        //数据加载完毕
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.hidden = NO;
        [self.tableView reloadData];
    }];
}


- (void)getHeaderLoadData {
    NSString *urlStr = [NSString stringWithFormat:@"%@?pageIndex=1",URL_GetMyClassHour];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        //1.购买过课时
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            NSArray *array = responseObject[@"data"];
            for (NSDictionary *dic in array) {
                self.headerModel = [HF_MineClassCountHeaderModel yy_modelWithDictionary:dic];
            }
        }
        self.placeHolderView.hidden = YES;
        [self getDetailLoadData];

    } failure:^(NSError *error) {
        //没课 2   0失败
        /*
         {
         data = "";
         msg = "您还没有购买课时，如需购买请登录“hi翻外教课堂”官网：www.hi-fan.cn
         或联系客服：400 - 6767 - 671";
         result = 2;
         }
         */
        
        NSDictionary *dic = error.userInfo;
        if ([dic[xc_returnCode] integerValue] == 2) {    // 2表示还未购买过课时，新用户
            self.detailDataArray = [NSMutableArray array];
            
            HF_ResultModel *model = [HF_ResultModel yy_modelWithDictionary:dic];
            self.placeHolderView.xc_model = model;
            self.placeHolderView.hidden = NO;
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
            [self.tableView reloadData];
            
        } else { //0 失败
            self.detailDataArray = [NSMutableArray array];
            
            HF_ResultModel *model = [HF_ResultModel yy_modelWithDictionary:dic];
            self.placeHolderView.xc_model = model;
            self.placeHolderView.hidden = NO;
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
            [self.tableView reloadData];
        }
    }];
    
}


#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"HF_MineClassCountListCell";
    HF_MineClassCountListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[HF_MineClassCountListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    HF_MineClassCountListModel *model = [self.detailDataArray safe_objectAtIndex:indexPath.row];
    cell.listModel = model;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LineH(50);
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HF_MineClassCountHeaderCell *headerView = [[HF_MineClassCountHeaderCell alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), LineH(208));
    headerView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    headerView.listHeaderModel = self.headerModel;
    
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return LineH(115);
}


//MARK:UI加载
- (void)initUI {
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    //返回按钮
    [self.view addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    @weakify(self);
    [[self.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.navigationController popViewControllerAnimated:YES];
     }];
    
    
    //我的课时
    [self.view addSubview:self.myCountLabel];
    [self.myCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(17);
        make.top.equalTo(self.view.mas_top).offset(75);
        make.height.mas_offset(38);
    }];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.myCountLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-0);
    }];
    
    [self.tableView addSubview:self.placeHolderView];
    self.placeHolderView.hidden = YES;
}


//MARK:懒加载
-(UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

-(HF_PlaceHolderView *)placeHolderView {
    if (!_placeHolderView) {
        self.placeHolderView = [[HF_PlaceHolderView alloc] initWithFrame:CGRectZero withImgYHeight:LineY(120)];
        self.placeHolderView.frame = CGRectMake(0, 0, home_right_width, SCREEN_HEIGHT());
    }
    return _placeHolderView;
}

-(UIButton *)leftButton {
    if (!_leftButton) {
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftButton setImage:UIIMAGE_FROM_NAME(@"箭头") forState:UIControlStateNormal];
        [self.leftButton setImage:UIIMAGE_FROM_NAME(@"箭头") forState:UIControlStateHighlighted];
    }
    return _leftButton;
}

-(UILabel *)myCountLabel {
    if (!_myCountLabel) {
        self.myCountLabel = [[UILabel alloc]init];
        self.myCountLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(38)];
        self.myCountLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
        self.myCountLabel.text = @"我的课时";
    }
    return _myCountLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
