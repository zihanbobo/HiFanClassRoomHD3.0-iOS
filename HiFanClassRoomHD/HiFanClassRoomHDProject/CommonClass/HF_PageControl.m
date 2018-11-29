//
//  HF_PageControl.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/28.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "HF_PageControl.h"
#define dotW 12    // 圆点宽
#define magrin 12  // 圆点间距

@implementation HF_PageControl

- (void)layoutSubviews {
    [super layoutSubviews];

    //计算圆点间距
    CGFloat marginX = dotW + magrin;

    //计算整个pageControll的宽度
    CGFloat newW = (self.subviews.count - 1 ) * marginX;

    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);

    //设置居中
    CGPoint center = self.center;
    center.x = self.superview.center.x;
    self.center = center;

    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];

        if (i == self.currentPage) {
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotW)];
            dot.layer.masksToBounds = YES;
            dot.layer.cornerRadius = LineH(6);
            
        }else {
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotW)];
            dot.layer.masksToBounds = YES;
            dot.layer.cornerRadius = LineH(6);
        }
    }
}


@end
