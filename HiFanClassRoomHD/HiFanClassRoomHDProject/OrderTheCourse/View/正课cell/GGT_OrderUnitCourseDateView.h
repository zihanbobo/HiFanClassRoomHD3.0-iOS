//
//  GGT_OrderUnitCourseDateView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/28.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_OrderCourseCollectionViewCell.h"
#import "HF_PageControl.h"

static CGFloat const xc_cellWidth = 102.0f;
static CGFloat const xc_cellHeight = 78.0f;
static CGFloat const xc_cellMargin = 20.0f;

typedef void(^GetDateBlock)(NSString *dateTime);
@interface GGT_OrderUnitCourseDateView : UITableViewCell 

@property (nonatomic, copy) GetDateBlock getDateBlock;
@property (nonatomic, strong) HF_PageControl *pageControl;
@property (nonatomic, strong) UIPageControl *currentPageControl;
@property BOOL reFresh;

-(void)getArray:(NSArray *)array;
@end
