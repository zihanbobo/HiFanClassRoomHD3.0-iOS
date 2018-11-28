//
//  GGT_MineClassViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/5/15.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_MineClassViewController.h"
#import "GGT_MineClassTableViewCell.h"
#import "GGT_PlaceHolderView.h"
#import "GGT_ResultModel.h"

@interface GGT_MineClassViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *headerDataArray;
@property (nonatomic, strong) NSMutableArray *detailDataArray;

//pageIndex
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) GGT_PlaceHolderView *xc_placeHolderView;
@end

@implementation GGT_MineClassViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的课时";
    
    [self initTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.dataArray = [NSMutableArray array];
        self.headerDataArray = [NSMutableArray array];
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
        
        
        NSMutableArray *tempArray = [NSMutableArray array];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            NSArray *array = responseObject[@"data"];
            for (NSDictionary *dic in array) {
                NSString *hourStr = [NSString stringWithFormat:@"%@",dic[@"Hours"]];
                
                if (![hourStr xc_isContainString:@"-" ] && ![hourStr xc_isContainString:@"+"]) {
                    hourStr = [NSString stringWithFormat:@"+%@",hourStr];
                }
                [tempArray addObject:@{@"leftTitle":[NSString stringWithFormat:@"%@",dic[@"TypeName"]],@"centerTitle":hourStr,@"rightTitle":[NSString stringWithFormat:@"%@",dic[@"CreateTime"]]}];
            }
            [self.detailDataArray addObjectsFromArray:tempArray];
        }
        
        if (self.dataArray.count == 1) {
            [self.dataArray addObject:self.detailDataArray];
        }
        
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (tempArray.count >0 && tempArray.count <10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = NO;
            
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        //        UserInfo={msg=没有获取到信息, result=0}
        
        //数据加载完毕
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.hidden = NO;
        [self.tableView reloadData];
    }];
}


#pragma mark 数据请求
- (void)getHeaderLoadData {
    NSString *urlStr = [NSString stringWithFormat:@"%@?pageIndex=1",URL_GetMyClassHour];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        
        //1.购买过课时
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            NSArray *array = responseObject[@"data"];
            for (NSDictionary *dic in array) {
                [self.headerDataArray addObject:@{@"leftTitle":[NSString stringWithFormat:@"剩余%@课时",dic[@"SurplusCount"]],@"centerTitle":@"",@"rightTitle":@""}];
                [self.headerDataArray addObject:@{@"leftTitle":[NSString stringWithFormat:@"总共%@课时",dic[@"TotalCount"]],@"centerTitle":@"",@"rightTitle":[NSString stringWithFormat:@"有效期至:%@",dic[@"ExpireTime"]]}];
                
                
                //判断是否操作课时，如果操作，进行刷新left的数据
                GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
                
                //数据不一样，进行刷新，因为在修改姓名的时候，有一个通知，再次直接用那个了
                if ([[NSString stringWithFormat:@"%@",dic[@"SurplusCount"]] isEqualToString:sin.leftTotalCount] == NO) {
                    sin.leftTotalCount = [NSString stringWithFormat:@"%@",dic[@"SurplusCount"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reFreshClassTotalCount" object:nil userInfo:nil];
                }
            }
            [self.dataArray addObject:self.headerDataArray];
        }
        self.xc_placeHolderView.hidden = YES;
        
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
            self.dataArray = [NSMutableArray array];
            self.headerDataArray = [NSMutableArray array];
            self.detailDataArray = [NSMutableArray array];
            
            
            GGT_ResultModel *model = [GGT_ResultModel yy_modelWithDictionary:dic];
            self.xc_placeHolderView.xc_model = model;
            self.xc_placeHolderView.hidden = NO;
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
            [self.tableView reloadData];
            
            
        } else { //0 失败
            self.dataArray = [NSMutableArray array];
            self.headerDataArray = [NSMutableArray array];
            self.detailDataArray = [NSMutableArray array];
            
            GGT_ResultModel *model = [GGT_ResultModel yy_modelWithDictionary:dic];
            self.xc_placeHolderView.xc_model = model;
            self.xc_placeHolderView.hidden = NO;
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
            [self.tableView reloadData];
        }
    }];
}


- (void)initTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(LineX(20),0, marginMineRight-LineW(40), SCREEN_HEIGHT()-64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.view addSubview:self.tableView];
    
    
    // GGT_PlaceHolderView
    self.xc_placeHolderView = [[GGT_PlaceHolderView alloc] initWithFrame:CGRectZero withImgYHeight:LineY(120)];
    self.xc_placeHolderView.frame = CGRectMake(0, 0, _tableView.width,  SCREEN_HEIGHT()-LineH(20)-64);
    [self.tableView addSubview:self.xc_placeHolderView];
    self.xc_placeHolderView.hidden = YES;
}

#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataArray safe_objectAtIndex:section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_MineClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[GGT_MineClassTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);

        }
    

    //对第一个和最后一个进行切圆角
    if (IsArrEmpty(self.headerDataArray)) {
        cell.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    } else {
        
        if ([[self.dataArray safe_objectAtIndex:indexPath.section] count] == 1) {
            [self cornCell:cell sideType:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight];
        } else {
            if (indexPath.row == 0) {
                [self cornCell:cell sideType:UIRectCornerTopLeft|UIRectCornerTopRight];
            } else if (indexPath.row == [[self.dataArray safe_objectAtIndex:indexPath.section] count] -1) {
                [self cornCell:cell sideType:UIRectCornerBottomLeft|UIRectCornerBottomRight];
            }
        }
    }
    
    
    
    cell.leftTitleLabel.text = [[self.dataArray safe_objectAtIndex:indexPath.section] safe_objectAtIndex:indexPath.row][@"leftTitle"];
    cell.centerTitleLabel.text = [[self.dataArray safe_objectAtIndex:indexPath.section] safe_objectAtIndex:indexPath.row][@"centerTitle"];
    cell.contentLabel.text = [[self.dataArray safe_objectAtIndex:indexPath.section] safe_objectAtIndex:indexPath.row][@"rightTitle"];
    
    
    return cell;
}


- (void)cornCell:(UITableViewCell *)cell sideType:(UIRectCorner)corners{
    CGSize cornerSize = CGSizeMake(LineW(6),LineH(6));
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _tableView.width,LineH(48)) byRoundingCorners:corners cornerRadii:cornerSize];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, _tableView.width, LineH(48));
    maskLayer.path = maskPath.CGPath;
    
    cell.layer.mask = maskLayer;
    [cell.layer setMasksToBounds:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return LineY(20);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, marginMineRight, LineY(20))];
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LineH(48);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
