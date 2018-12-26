//
//  HF_HomeUnGradedViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/26.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeUnGradedViewController.h"
#import "HF_HomeUnGradedHeaderCell.h"
#import "HF_HomeUnGradedContentCell.h"
#import "HF_HomeCourseStrategyViewController.h"

@interface HF_HomeUnGradedViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView; //tableView
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HF_HomeUnGradedViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

//MARK:UITableView 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellID = @"HF_HomeUnGradedHeaderCell";
        HF_HomeUnGradedHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HF_HomeUnGradedHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //MARK:课程攻略
        cell.gonglueBtnBlock = ^{
            HF_HomeCourseStrategyViewController *vc = [[HF_HomeCourseStrategyViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *cellID = @"HF_HomeUnGradedContentCell";
        HF_HomeUnGradedContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HF_HomeUnGradedContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return LineH(106);
    } else {
        return self.tableView.height - LineH(106);
    }
}


//MARK:UI加载
- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-0);
    }];
}

//MARK:懒加载
-(UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
