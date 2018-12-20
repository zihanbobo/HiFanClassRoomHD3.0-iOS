//
//  HF_HomeUnitChooseCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/20.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeUnitChooseCell.h"




@interface HF_HomeUnitChooseCell()

@end

@implementation HF_HomeUnitChooseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.backgroundColor = UICOLOR_FROM_HEX(0xF4F6F9);
        [self initView];
    }
    return self;
}

- (void)initView {
    self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectedButton.frame = CGRectMake(0, 0, LineW(104), LineH(48));
    self.selectedButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineW(18)];
    [self.selectedButton setTitle:@"Unit 1" forState:UIControlStateNormal];
    [self.selectedButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(Color000000, 40) forState:UIControlStateNormal];
//    [self.selectedButton setImage:UIIMAGE_FROM_NAME(@"完成") forState:UIControlStateNormal];
//    [self initButton:self.selectedButton];
    [self.contentView addSubview:self.selectedButton];
    
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0);
    }];
}

//MARK:将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn {
    CGFloat imageWidth = btn.imageView.frame.size.width;
    CGFloat titleWidth = btn.titleLabel.frame.size.width;
    CGFloat space = 5;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageWidth+space*0.5), 0, (imageWidth+space*0.5))];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, (titleWidth + space*0.5), 0, -(titleWidth + space*0.5))];
}


@end
