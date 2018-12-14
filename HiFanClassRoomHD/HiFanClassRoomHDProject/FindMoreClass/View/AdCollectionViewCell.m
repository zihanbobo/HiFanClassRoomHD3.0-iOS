//
//  AdCollectionViewCell.m
//  Ad
//
//  Created by RF on 15/5/10.
//  Copyright (c) 2015年 RF. All rights reserved.
//

#import "AdCollectionViewCell.h"

@implementation AdCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        [self addSubview:imageView];
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:_bgView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _titleLabel = titleLabel;
        _titleLabel.hidden = YES;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@",title];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    
    CGFloat titleLabelW = self.frame.size.width-60;
    CGFloat titleLabelH = 30;
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = self.frame.size.height-titleLabelH;
    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    _titleLabel.hidden = !_titleLabel;
    _bgView.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW+60, titleLabelH);
}

@end
