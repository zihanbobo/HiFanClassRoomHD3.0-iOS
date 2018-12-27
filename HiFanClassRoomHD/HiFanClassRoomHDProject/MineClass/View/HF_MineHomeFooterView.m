//
//  HF_MineHomeFooterView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/10.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_MineHomeFooterView.h"

@interface HF_MineHomeFooterView()
@property (nonatomic, strong) UIButton *loginOutButton;
@end


@implementation HF_MineHomeFooterView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView {
    //退出登录
    self.loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginOutButton setTitleColor:UICOLOR_FROM_HEX(0xFF8A65) forState:UIControlStateNormal];
    [self.loginOutButton setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    self.loginOutButton.titleLabel.font = Font(18);
    [self.contentView addSubview:self.loginOutButton];
    
    [self.loginOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    @weakify(self);
    [[self.loginOutButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.loginOutButtonBlock) {
             self.loginOutButtonBlock();
         }
     }];
    
    
    UILabel *weixinLabel = [UILabel new];
    weixinLabel.font = Font(12);
    weixinLabel.text = @"扫码关注微信公众号进行咨询";
    weixinLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
    [self.contentView addSubview:weixinLabel];
    
    [weixinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.loginOutButton.mas_top).offset(-25);
    }];
    
    UIImageView *QRCodeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"微信二维码"]];
    [self.contentView addSubview:QRCodeImageView];
    [QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(weixinLabel.mas_top).offset(-4);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
}


- (void)drawRect:(CGRect)rect {
    [self.loginOutButton addBorderForViewWithBorderWidth:1 BorderColor:UICOLOR_FROM_HEX(0xFF8A65) CornerRadius:25];
    [self.loginOutButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:25];
}

@end
