//
//  GGT_LevelMenuViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/27.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_LevelMenuViewController.h"
#import "GGT_GetBookingLevelsModel.h"

@interface GGT_LevelMenuViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GGT_LevelMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化tableview
    [self initTableView];
    
    [self getLevelData];
}

#pragma mark 获取数据
- (void)getLevelData {
    
    [[BaseService share] sendGetRequestWithPath:URL_GetBookList token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            NSArray *tempArray = responseObject[@"data"];
            self.dataArray = [NSMutableArray array];
            
            for (NSDictionary *dic in tempArray) {
                GGT_GetBookingLevelsModel *model = [GGT_GetBookingLevelsModel yy_modelWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
            self.preferredContentSize = CGSizeMake(LineW(168), LineH(38)*self.dataArray.count);
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];

}



- (void)initTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-0);
    }];
    
}

#pragma mark - Table View delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LevelMenuCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"LevelMenuCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    GGT_GetBookingLevelsModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];

    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.BookingTitle];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = Font(18);
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, LineY(37), SCREEN_WIDTH(), LineH(1))];
    lineView.backgroundColor = UICOLOR_FROM_HEX(0xE8E8E8);
    [cell addSubview:lineView];

    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LineH(38);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_GetBookingLevelsModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];

    if (self.getBookingIdBlock) {
        self.getBookingIdBlock([NSString stringWithFormat:@"%@",model.BookingTitle],model.BookingId);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
