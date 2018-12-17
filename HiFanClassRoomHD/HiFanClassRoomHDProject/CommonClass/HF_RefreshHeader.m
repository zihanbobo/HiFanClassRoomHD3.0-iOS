//
//  RKRefreshHeader.m
//  ShiXiNetwork
//
//  Created by Karl on 2016/11/11.
//  Copyright © 2016年 Shixi.com. All rights reserved.
//

#import "HF_RefreshHeader.h"

@implementation HF_RefreshHeader


- (void)placeSubviews
{
    [super placeSubviews];
    
//    self.gifView.frame = CGRectMake(SCREEN_WIDTH()/2-200, self.mj_h/2 - 15 , 400, 200);
    self.gifView.frame = CGRectMake(home_right_width/2-100, self.mj_h/2 - 50 , 200, 100);
    self.gifView.clipsToBounds  = YES;
    self.gifView.contentMode = UIViewContentModeScaleToFill;
}



@end
