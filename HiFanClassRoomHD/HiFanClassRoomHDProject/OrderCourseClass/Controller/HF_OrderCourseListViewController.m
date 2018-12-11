//
//  HF_OrderCourseListViewController.m
//  HiFanClassRoomHD
//
//  Created by 何建新 on 2018/12/4.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_OrderCourseListViewController.h"
#import "HF_OrderDateListView.h"
#import "HF_OrderDateCell.h"
#import "HF_OrderTimeListView.h"
#import "HF_OrderTimeCell.h"
@interface HF_OrderCourseListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *dateCollectionView;
@property(nonatomic, strong) HF_OrderDateCell *dateCell;
@property(nonatomic, strong) UICollectionView *timeCollectionView;
@property(nonatomic, strong) HF_OrderTimeCell *timeCell;
@end

@implementation HF_OrderCourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(0xf2f2f2);
    //导航栏设置
    [self setNavationStyle];
    //日期选择视图
    [self setDateTimeSelectView];
    //约课说明
    [self setExplainView];
    
    
    
}
#pragma mark --- 导航栏设置
- (void)setNavationStyle{
    self.navigationController.navigationBar.barTintColor = UICOLOR_FROM_HEX(0xf2f2f2);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //分割线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF3);
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LineW(890));
        make.height.mas_equalTo(1);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    //左侧按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSString *leftBtnTitle = @"Stage2 已完成3节/共15节";
    UIImage *leftBtnImage = [[UIImage imageNamed:@"箭头"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBtn setTitle:leftBtnTitle forState:UIControlStateNormal];
    [leftBtn setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 70) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = Font(20);
    [leftBtn setImage:leftBtnImage forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 280, 20);
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(1, 0, 1, 0);
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = left;
    
    //右侧按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(helpBtn) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    NSString *title = @"取消课程规则";
    UIImage *image = [[UIImage imageNamed:@"帮助"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 40) forState:UIControlStateNormal];
    [rightBtn setImage:image forState:UIControlStateNormal];
    rightBtn.titleLabel.font = Font(16);
    rightBtn.frame = CGRectMake(0, 0, 120, 22);
//    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:10.f]];
//    CGSize imageSize = image.size;
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 0);
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(2.5,0,2.5,0);
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    
}
- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)helpBtn {
    NSLog(@"弹出规则说明");
}
#pragma mark --  日期时间选择视图
- (void)setDateTimeSelectView {
    HF_OrderDateListView *dateListView = [HF_OrderDateListView new];
    [self.view addSubview:dateListView];
    [dateListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(17);
        make.top.equalTo(self.view.mas_top).offset(25);
        make.height.mas_equalTo(LineH(570));
        make.width.mas_equalTo(LineW(312));
    }];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.dateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, dateListView.frame.size.width, dateListView.frame.size.height-60) collectionViewLayout:layout];
    self.dateCollectionView.backgroundColor = [UIColor clearColor];
    self.dateCollectionView.dataSource = self;
    self.dateCollectionView.delegate = self;
    self.dateCollectionView.tag = 1;
    [dateListView addSubview:self.dateCollectionView];
    [self.dateCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateListView.mas_top).offset(60);
        make.bottom.left.right.equalTo(dateListView);
    }];
    [self.dateCollectionView registerClass:[HF_OrderDateCell class] forCellWithReuseIdentifier:@"dateCell"];
    
    
    UICollectionViewFlowLayout *timeLayout = [[UICollectionViewFlowLayout alloc] init];
    HF_OrderTimeListView *timeListView = [HF_OrderTimeListView new];
    [self.view addSubview:timeListView];
    [timeListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-17);
        make.width.mas_equalTo(LineW(561));
        make.height.mas_equalTo(LineH(570));
    }];
    self.timeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:timeLayout];
    self.timeCollectionView.backgroundColor = [UIColor clearColor];
    self.timeCollectionView.delegate = self;
    self.timeCollectionView.dataSource = self;
    self.timeCollectionView.tag = 2;
    [timeListView addSubview:self.timeCollectionView];
    [self.timeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeListView.mas_top).offset(65);
        make.left.equalTo(timeListView.mas_left).offset(76);
        make.right.equalTo(timeListView);
        make.bottom.equalTo(timeListView.mas_bottom).offset(-63);
    }];
    [self.timeCollectionView registerClass:[HF_OrderTimeCell class] forCellWithReuseIdentifier:@"timeCell"];
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(collectionView.tag == 1){
        return 1;
    }else if(collectionView.tag == 2){
        return 3;
    }
    return 0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView.tag == 1){
        return 10;
    }else if(collectionView.tag == 2){
        return 10;
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if(collectionView.tag == 1){
         HF_OrderDateCell *cell = (HF_OrderDateCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"dateCell" forIndexPath:indexPath];
        return cell;
    }else if(collectionView.tag == 2){
        HF_OrderTimeCell *cell = (HF_OrderTimeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"timeCell" forIndexPath:indexPath];
        
        return cell;
    }
    return nil;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1){
        return CGSizeMake(70, 52);
    }else if(collectionView.tag == 2){
        return CGSizeMake(76, 36);
    }
    return CGSizeZero;
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(12, 16, 6, 16);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1){
        HF_OrderDateCell *cell = (HF_OrderDateCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = UICOLOR_FROM_HEX(0x02B6E3);
        cell.layer.cornerRadius = 7;
        cell.dateLabel.textColor = [UIColor whiteColor];
        cell.weekLabel.textColor = [UIColor whiteColor];
        
        
        
        cell.layer.shadowColor = UICOLOR_FROM_HEX(0x02B6E3).CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        cell.layer.shadowRadius = 7.0f;
        cell.layer.shadowOpacity = 0.5f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        //[cell addShadowForViewWithShadowOffset:CGSizeMake(0, 0) ShadowOpacity:0.12 ShadowRadius:7 ShadowColor:UICOLOR_FROM_HEX(0x02B6E3)];
    }else if(collectionView.tag == 2){
        HF_OrderTimeCell *cell = (HF_OrderTimeCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = UICOLOR_FROM_HEX(0x02B6E3);
        cell.layer.cornerRadius = 7;
        cell.timeLabel.textColor = [UIColor whiteColor];
        cell.layer.shadowColor = UICOLOR_FROM_HEX(0x02B6E3).CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        cell.layer.shadowRadius = 7.0f;
        cell.layer.shadowOpacity = 0.5f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    }
    NSLog(@"点击了CELL");
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1){
        HF_OrderDateCell *cell = (HF_OrderDateCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = UICOLOR_FROM_HEX(0xffffff);
        cell.dateLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
        cell.weekLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
        
        cell.layer.shadowColor = UICOLOR_FROM_HEX(0xffffff).CGColor;
        cell.layer.shadowOffset = CGSizeZero;
        cell.layer.shadowRadius = 0;
        cell.layer.shadowOpacity = 0;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = nil;
    }else if(collectionView.tag == 2){
        HF_OrderTimeCell *cell = (HF_OrderTimeCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = UICOLOR_FROM_HEX(0xffffff);
        cell.timeLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
        cell.layer.shadowColor = UICOLOR_FROM_HEX(0xffffff).CGColor;
        cell.layer.shadowOffset = CGSizeZero;
        cell.layer.shadowRadius = 0;
        cell.layer.shadowOpacity = 0;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = nil;
    }
}
//footer的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if(collectionView.tag == 2){
        return CGSizeMake(0, 16);
    }
    return CGSizeZero;
}
#pragma mark ----  约课说明
- (void)setExplainView {
    UIView *circular1 = [UIView new];
    circular1.backgroundColor = UICOLOR_FROM_HEX(0xD8D8D8);
    circular1.layer.masksToBounds = YES;
    circular1.layer.cornerRadius = 10/2;
    [self.view addSubview:circular1];
    [circular1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-51);
        make.left.equalTo(self.view.mas_left).offset(647);
        make.width.height.mas_equalTo(10);
    }];
    UILabel *info1 = [UILabel new];
    info1.text = @"不可选/约满";
    info1.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 40);
    info1.font = Font(12);
    [info1 sizeToFit];
    [self.view addSubview:info1];
    [info1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(circular1.mas_centerY);
        make.left.equalTo(circular1.mas_right).offset(5);
    }];
    
    UIView *circular2 = [UIView new];
    circular2.backgroundColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    circular2.layer.masksToBounds = YES;
    circular2.layer.cornerRadius = 10/2;
    [self.view addSubview:circular2];
    [circular2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(circular1.mas_centerY);
        make.left.equalTo(info1.mas_right).offset(10);
        make.width.height.mas_equalTo(10);
    }];
    UILabel *info2 = [UILabel new];
    info2.text = @"可选/可预约";
    info2.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 40);
    info2.font = Font(12);
    [info2 sizeToFit];
    [self.view addSubview:info2];
    [info2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(circular2.mas_centerY);
        make.left.equalTo(circular2.mas_right).offset(5);
    }];
    
    UIView *circular3 = [UIView new];
    circular3.backgroundColor = UICOLOR_FROM_HEX(0x02B6E3);
    circular3.layer.masksToBounds = YES;
    circular3.layer.cornerRadius = 10/2;
    [self.view addSubview:circular3];
    [circular3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(circular2.mas_centerY);
        make.left.equalTo(info2.mas_right).offset(10);
        make.width.height.mas_equalTo(10);
    }];
    UILabel *info3 = [UILabel new];
    info3.text = @"已选择";
    info3.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 40);
    info3.font = Font(12);
    [info3 sizeToFit];
    [self.view addSubview:info3];
    [info3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(circular3.mas_centerY);
        make.left.equalTo(circular3.mas_right).offset(5);
    }];
    
    
}
@end
