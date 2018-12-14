//
//  AdCollectionViewCell.h
//  Ad
//
//  Created by RF on 15/5/10.
//  Copyright (c) 2015年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdCollectionViewCell : UICollectionViewCell{
    UILabel *_titleLabel;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIView *bgView;

//@property (nonatomic, strong) UILabel *titleLabel;

@end
