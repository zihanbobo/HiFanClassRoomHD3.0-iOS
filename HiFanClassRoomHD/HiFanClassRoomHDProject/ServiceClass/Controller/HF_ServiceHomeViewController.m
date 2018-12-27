//
//  HF_ServiceHomeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_ServiceHomeViewController.h"
#import "HF_ServiceHomeContentCell.h"

@interface HF_ServiceHomeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView; //tableView
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HF_ServiceHomeViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//    }];
//    [self.tableView.mj_header beginRefreshing];
}

//MARK:UITableView 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"HF_ServiceHomeContentCell";
    HF_ServiceHomeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HF_ServiceHomeContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
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
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
