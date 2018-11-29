//
//  GGT_SelfInfoViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/5/12.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_SelfInfoViewController.h"
#import "GGT_SelfInfoTableViewCell.h"
#import "GGT_SelfInfoModel.h"

@interface GGT_SelfInfoViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
//左边文字
@property (nonatomic, strong) NSArray *leftTitleArray;
//右边请求的数组
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) GGT_SelfInfoModel *selfInfoModel;

@end

@implementation GGT_SelfInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    self.navigationItem.title = @"个人信息";
    

    //初始化tableview
    [self initTableView];
    
    //获取网络请求，添加到cell上
    [self getLoadData];
    
}


- (void)initTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(LineX(20), LineY(20), marginMineRight-LineW(40), SCREEN_HEIGHT()-LineH(40)-64) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.view addSubview:_tableView];
    
    
    _leftTitleArray = @[@"账号信息",@"英文名",@"性别",@"生日"];

    [_tableView reloadData];
    
}

#pragma mark 获取网络请求，添加到cell上
- (void)getLoadData {
    
    [[BaseService share] sendGetRequestWithPath:URL_GetStudentInfo token:YES viewController:self success:^(id responseObject) {
        
        self.selfInfoModel = [GGT_SelfInfoModel yy_modelWithDictionary:responseObject[@"data"]];
        self.dataArray = [NSMutableArray array];
        NSArray *sectionArr1 = @[self.selfInfoModel.Mobile,IsStrEmpty(self.selfInfoModel.NameEn) ? @"" : self.selfInfoModel.NameEn,self.selfInfoModel.Gender,self.selfInfoModel.Birthday];
        self.dataArray = [NSMutableArray arrayWithArray:sectionArr1];
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        
    }];
    
}



#pragma mark - Table View delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _leftTitleArray.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_SelfInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[GGT_SelfInfoTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    //对第一个和最后一个进行切圆角
    if (indexPath.row == 0) {
        
        [self cornCell:cell sideType:UIRectCornerTopLeft|UIRectCornerTopRight];
        
    } else if (indexPath.row == 3) {
        
        [self cornCell:cell sideType:UIRectCornerBottomLeft|UIRectCornerBottomRight];
    }
    
//    if (indexPath.section == 0 && indexPath.row == 0) {
        //更新坐标
        cell.rightImgView.hidden = YES;
        [cell.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.leftTitleLabel.mas_right).with.offset(LineX(15));
            make.right.equalTo(cell.rightImgView.mas_left).with.offset(-LineX(20));
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.height.mas_offset(LineH(22));
        }];
        
        
        [cell.rightImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).with.offset(-LineX(0));
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.size.mas_offset(CGSizeMake(LineW(0), LineH(0)));
        }];
        
//    }
    
    
    
    cell.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    cell.leftTitleLabel.text = _leftTitleArray[indexPath.row];
    cell.contentLabel.text = _dataArray[indexPath.row];
    
    
    
    return cell;
    
}

- (void)cornCell:(UITableViewCell *)cell sideType:(UIRectCorner)corners{
    CGSize cornerSize = CGSizeMake(LineW(6),LineH(6));
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _tableView.width,LineH(48))
                                                   byRoundingCorners:corners
                                                         cornerRadii:cornerSize];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, _tableView.width, LineH(48));
    maskLayer.path = maskPath.CGPath;
    
    cell.layer.mask = maskLayer;
    [cell.layer setMasksToBounds:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LineH(48);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
