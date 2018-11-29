//
//  GGT_NoEvaluationViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/20.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_ScheduleFinishedHomeModel.h"
#import "GGT_ScheduleDetailModel.h"

typedef void(^RefreshCell)(BOOL refresh);
@interface GGT_NoEvaluationViewController : BaseViewController
@property (nonatomic, strong) GGT_ScheduleFinishedHomeModel *scheduleFinishedHomeModel;
@property (nonatomic, strong) GGT_ScheduleDetailModel *scheduleDetailModel;
@property (nonatomic, copy) NSString *vcType; //查看是哪个控制器push过来的
@property (nonatomic, copy) RefreshCell refreshCell;

@end




#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"
#import "PlaceholderTextView.h"

#pragma mark 头像-姓名-星星
//使用代理获取点击星星的个数，block获取后，比较难拿到值😆
@protocol getStatNumberDelegate <NSObject>
-(void)getStatNumber:(int)num;
@end


@interface GGT_NoEvaluationView : UIView <ASStarRatingViewDelegate,UITextViewDelegate>
@property (nonatomic, strong) ASStarRatingView *starRatingView;
//文字输入框
@property (nonatomic, strong) PlaceholderTextView *contentTextView;
@property (nonatomic, strong) UIButton *finishedButton;
@property (nonatomic,strong) id<getStatNumberDelegate>delegate;

-(void)getScheduleFinishedHomeModel :(GGT_ScheduleFinishedHomeModel *)model;
-(void)getScheduleDetailModel :(GGT_ScheduleDetailModel *)model;

@end
