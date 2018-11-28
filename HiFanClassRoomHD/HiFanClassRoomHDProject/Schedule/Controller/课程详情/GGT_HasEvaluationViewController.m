//
//  GGT_HasEvaluationViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/20.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_HasEvaluationViewController.h"
#import "GGT_ScheduleDetailModel.h"
#import "ASStarRatingView.h"

@interface GGT_HasEvaluationViewController ()
@property (nonatomic, strong) ASStarRatingView *starRatingView;
@property (nonatomic, strong) UIImageView *teacherImgView;
@property (nonatomic, strong) UILabel *nameLabel; //姓名
@property (nonatomic, strong) UILabel *evaluateContentLabel; //评价内容
@property (nonatomic, strong) GGT_ScheduleDetailModel *scheduleDetailModel;
@end

@implementation GGT_HasEvaluationViewController

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController ) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = LineW(460);
        tempSize.height = LineH(255);
        return tempSize;
    }else {
        return [super preferredContentSize];
    }
}


- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    super.preferredContentSize = preferredContentSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"课后评价";
    self.navigationController.navigationBar.barTintColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(18),NSFontAttributeName,UICOLOR_FROM_HEX(Color0D0101),NSForegroundColorAttributeName, nil]];
    //隐藏导航下的黑线
    [self.navigationController.navigationBar  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    [self setRightButtonWithImg:@"close"];
    
    [self beEvaluated];
    [self getEvaluatedData];
}

- (void)getEvaluatedData {

    NSString *urlStr = [NSString stringWithFormat:@"%@?lessonId=%ld",URL_GetLessonDeatil,(long)self.lessonId];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArray = responseObject[@"data"];
            if ([dataArray isKindOfClass:[NSArray class]] && (dataArray.count > 0)) {
                for (NSDictionary *dic in dataArray) {
                    self.scheduleDetailModel = [GGT_ScheduleDetailModel yy_modelWithDictionary:dic];
                }
            }
            //头像
            if (!IsStrEmpty(self.scheduleDetailModel.TeacherImg)) {
                //请求图片
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.scheduleDetailModel.TeacherImg]]];
                UIImage *img = [UIImage imageWithData:data];
                
                //图片压缩
                img = [img imageScaledToSize:CGSizeMake(LineW(60), LineW(60))];
                self.teacherImgView.image = img;
            }
            
            //姓名
            if (!IsStrEmpty(self.scheduleDetailModel.TeacherName)) {
                self.nameLabel.text = [NSString stringWithFormat:@"%@",self.scheduleDetailModel.TeacherName];
            }
            
            //星星数量
            self.starRatingView.rating = self.scheduleDetailModel.Points;
            
            //评价内容
            if (!IsStrEmpty(self.scheduleDetailModel.EvaluateContent)) {
                self.evaluateContentLabel.text = [NSString stringWithFormat:@"%@",self.scheduleDetailModel.EvaluateContent];
            }
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
}



- (void)beEvaluated {
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    // 图像
    self.teacherImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.frame = CGRectMake(0, 0, LineH(60), LineH(60));
        imgView.contentMode = UIViewContentModeCenter;
        imgView.image = UIIMAGE_FROM_NAME(@"headPortrait_default_avatar");
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = LineH(30);
        imgView;
    });
    [self.view addSubview:self.teacherImgView];
    
    [self.teacherImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(LineY(18));
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LineH(60), LineH(60)));
    }];
    
    
    //姓名
    self.nameLabel = ({
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(14);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
        label;
    });
    [self.view addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.teacherImgView.mas_bottom).offset(LineY(8));
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(LineH(20)));
    }];
    
    
    
    self.starRatingView = [[ASStarRatingView alloc]init];
    self.starRatingView.starWidth = LineW(19);
    self.starRatingView.canEdit = NO;
    [self.view addSubview:self.starRatingView];
    
    
    [self.starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(LineY(6));
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LineW(140), LineW(20)));
    }];
    
    //评价内容
    self.evaluateContentLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(14);
        label.numberOfLines = 0;
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
        label;
    });
    [self.view addSubview:self.evaluateContentLabel];
    
    [self.evaluateContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starRatingView.mas_bottom).offset(LineY(margin20));
        make.left.equalTo(self.view.mas_left).offset(LineX(56));
        make.right.equalTo(self.view.mas_right).offset(-LineX(56));
    }];
}


#pragma mark 关闭按钮
- (void)rightAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

