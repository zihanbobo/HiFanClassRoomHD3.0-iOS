//
//  GGT_EvaluationSucceedView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/21.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"

@interface GGT_EvaluationSucceedView : UIView
//星星评价
@property (nonatomic, strong) ASStarRatingView *starRatingView;
//关闭按钮
@property (nonatomic, strong) UIButton *closeButton;

- (void)getMessageDic:(NSDictionary *)dic;
@end
