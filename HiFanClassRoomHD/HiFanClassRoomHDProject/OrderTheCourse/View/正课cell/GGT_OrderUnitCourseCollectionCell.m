//
//  GGT_OrderUnitCourseCollectionCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/28.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_OrderUnitCourseCollectionCell.h"

@interface GGT_OrderUnitCourseCollectionCell()
//xx:xx 开课
@property (nonatomic, strong) UILabel *startTimeLabel;
//剩余 x
@property (nonatomic, strong) UILabel *surplusHowMuchLabel;
@end



@implementation GGT_OrderUnitCourseCollectionCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


#pragma mark 初始化界面
- (void)initView {
    //对CollectionCell进行裁切
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = LineW(10);
    self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    
    self.startTimeLabel = [[UILabel alloc]init];
    self.startTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.startTimeLabel.font = Font(16);
    [self.contentView addSubview:self.startTimeLabel];

    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(LineY(10));
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(LineH(16));
    }];
    
    
    //剩余 x
    self.surplusHowMuchLabel = [[UILabel alloc]init];
    self.surplusHowMuchLabel.font = Font(18);
    self.surplusHowMuchLabel.textColor = UICOLOR_FROM_HEX(ColorFF6600);
    self.surplusHowMuchLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.surplusHowMuchLabel];
    
    [self.surplusHowMuchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startTimeLabel.mas_bottom).with.offset(LineH(20));
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(LineH(18));
    }];
  
  
    //加入  按钮
    self.joinButton = [UIButton new];
    self.joinButton.layer.masksToBounds = YES;
    self.joinButton.layer.cornerRadius = LineH(18);
    [self.contentView addSubview:self.joinButton];
    
    
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-LineH(20));
        make.size.mas_equalTo(CGSizeMake(LineW(108), LineH(36)));
    }];
}

- (void)getCellModel:(GGT_OrderUnitCourseModel *)OrderUnitCourseModel{
    if (!IsStrEmpty(OrderUnitCourseModel.StartTime)) {
        self.startTimeLabel.text = [NSString stringWithFormat:@"%@开课",OrderUnitCourseModel.StartTime];
    }

    
    
    self.joinButton.enabled = YES;
    [self.joinButton setBackgroundImage:nil forState:(UIControlStateNormal)];
    
    
    //ShowStatus 显示状态: 0=申请开班,1=加入班级,2=已满班
    //IsMake 是否可以加入,0=可以加入,1=不可以加入.
    switch (OrderUnitCourseModel.ShowStatus) {
        case 0: //申请开班
            switch (OrderUnitCourseModel.IsMake) {

                case 0:
                    //可加入
                    [self.joinButton setBackgroundImage:UIIMAGE_FROM_NAME(@"practiceBtn_copy") forState:(UIControlStateNormal)];
                    [self.joinButton setTitle:@"申请开班" forState:(UIControlStateNormal)];
                    [self.joinButton setTitleColor:UICOLOR_FROM_HEX(ColorFF6600) forState:UIControlStateNormal];
                    self.surplusHowMuchLabel.text = [NSString stringWithFormat:@"还差%ld人开班",(long)OrderUnitCourseModel.ResidueNum];

                    break;
                case 1:
                    //不可加入
                    [self.joinButton setBackgroundImage:UIIMAGE_FROM_NAME(@"anniu_line") forState:(UIControlStateNormal)];
                    [self.joinButton setTitle:@"申请开班" forState:(UIControlStateNormal)];
                    [self.joinButton setTitleColor:UICOLOR_FROM_HEX(ColorE8E8E8) forState:UIControlStateNormal];
                    self.joinButton.enabled = NO;
                    self.surplusHowMuchLabel.text = [NSString stringWithFormat:@"还差%ld人开班",(long)OrderUnitCourseModel.ResidueNum];

                    break;
                default:
                    break;
            }
            break;
        case 1: //加入班级
            switch (OrderUnitCourseModel.IsMake) {

                case 0:
                    //可加入
                    [self.joinButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonY") forState:(UIControlStateNormal)];
                    [self.joinButton setTitle:@"加入班级" forState:(UIControlStateNormal)];
                    [self.joinButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
                    self.surplusHowMuchLabel.text = [NSString stringWithFormat:@"剩余席位 %ld",(long)OrderUnitCourseModel.ResidueNum];

                    break;
                case 1:
                    //不可加入
                    [self.joinButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonN") forState:(UIControlStateNormal)];
                    [self.joinButton setTitle:@"加入班级" forState:(UIControlStateNormal)];
                    [self.joinButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
                    self.joinButton.enabled = NO;
                    self.surplusHowMuchLabel.text = [NSString stringWithFormat:@"剩余席位 %ld",(long)OrderUnitCourseModel.ResidueNum];

                    break;
                default:
                    break;
            }
            break;
        case 2: //已满班
            self.surplusHowMuchLabel.text = [NSString stringWithFormat:@"剩余席位 %ld",(long)OrderUnitCourseModel.ResidueNum];
            [self.joinButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonN") forState:(UIControlStateNormal)];
            [self.joinButton setTitle:@"已满班" forState:(UIControlStateNormal)];
            [self.joinButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
            self.joinButton.enabled = NO;

            break;
        default:
            break;
    }
}


@end
