//
//  HF_FindMoreHomeCycleCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/5.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_FindMoreHomeCycleCell.h"


@implementation HF_FindMoreHomeCycleCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    BaseScrollHeaderView *headerView = [[BaseScrollHeaderView alloc] init];
    headerView.navBigLabel.text = @"Find More";
    headerView.titleLabel.text = @"发现";
    [headerView.rightButton setTitle:@"我喜欢的" forState:UIControlStateNormal];
    [headerView.rightButton setImage:UIIMAGE_FROM_NAME(@"爱心") forState:UIControlStateNormal];
    [self addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.height.mas_equalTo(106);
    }];
    
    @weakify(self);
    [[headerView.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.favoriteBtnBlock) {
             self.favoriteBtnBlock();
         }
     }];
    
    self.adScroll = [[AdCycleScrollView alloc] init];
    self.adScroll.frame = CGRectMake(LineX(17), LineY(177), home_right_width-LineW(34), LineH(210));
    self.adScroll.delegate = self;
    self.adScroll.pageControlAliment = AdCycleScrollViewPageControlAlimentCenter;
    [self addSubview:self.adScroll];

}

- (void)drawRect:(CGRect)rect {
    [self.adScroll xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(10)];
}


#pragma mark - 轮播图点击事件
- (void)cycleScrollView:(AdCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)selectedIndex{
    if (self.adCycleClickBlock) {
        self.adCycleClickBlock(selectedIndex);
    }
}

@end
