//
//  GGT_NoEvaluationViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/20.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_NoEvaluationViewController.h"
#import "GGT_EvaluationSucceedView.h"

static NSString * const titleString = @"课后评价";
static NSString * const textViewPlaceholdString = @"请输入您对本节课程和外教老师的评价（100字以内）";

@interface GGT_NoEvaluationViewController () <getStatNumberDelegate>
@property (nonatomic, assign) int starNumber;
@property (nonatomic, strong) GGT_NoEvaluationView *noEvaluationView;
@end

@implementation GGT_NoEvaluationViewController

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController ) { //&& self.xc_textView != nil
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = LineW(460);
        tempSize.height = LineH(372);
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
    
    
    self.title = titleString;
    self.navigationController.navigationBar.barTintColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(18),NSFontAttributeName,UICOLOR_FROM_HEX(Color0D0101),NSForegroundColorAttributeName, nil]];
    //隐藏导航下的黑线
    [self.navigationController.navigationBar  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    [self setRightButtonWithImg:@"close"];
    [self beEvaluated];

}


#pragma mark 待评价
- (void)beEvaluated {
    self.noEvaluationView = [GGT_NoEvaluationView new];
    self.noEvaluationView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    self.noEvaluationView.delegate = self;
    
    if ([self.vcType isEqualToString:@"已结束"]) {
        [self.noEvaluationView getScheduleFinishedHomeModel:self.scheduleFinishedHomeModel];
    } else if ([self.vcType isEqualToString:@"课程详情"]){
        [self.noEvaluationView getScheduleDetailModel:self.scheduleDetailModel];
    }
    
    [self.view addSubview:self.noEvaluationView];

    
    [self.noEvaluationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    
    @weakify(self);
    [[self.noEvaluationView.finishedButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self postEvaluatedData];
     }];
    
}

//代理传值，获取星星个数
-(void)getStatNumber:(int)num {
    self.starNumber = num;
}

#pragma mark 评价成功
- (void)postEvaluatedData {
    [self.noEvaluationView.contentTextView resignFirstResponder];
    
    if (IsStrEmpty(self.noEvaluationView.contentTextView.text)) {
        [MBProgressHUD showMessage:@"请输入您对本节课程和外教老师的评价" toView:self.view];
        return;
    }
    
    //最低为1颗星，为0时代表是5颗星，用户没有选择
    if (self.starNumber == 0) {
        self.starNumber = 5;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    if ([self.vcType isEqualToString:@"已结束"]) {
        dic[@"Content"] = self.noEvaluationView.contentTextView.text;
        dic[@"LessonId"] = [NSString stringWithFormat:@"%ld",(long)self.scheduleFinishedHomeModel.LessonId];
        dic[@"TeacherId"] = [NSString stringWithFormat:@"%ld",(long)self.scheduleFinishedHomeModel.TeacherId];
        dic[@"StudentId"] = [NSString stringWithFormat:@"%ld",(long)self.scheduleFinishedHomeModel.StudentId];
        dic[@"Points"] = [NSString stringWithFormat:@"%d",self.starNumber];
    } else if ([self.vcType isEqualToString:@"课程详情"]){
        dic[@"Content"] = self.noEvaluationView.contentTextView.text;
        dic[@"LessonId"] = [NSString stringWithFormat:@"%ld",(long)self.scheduleDetailModel.DetailRecordID];
        dic[@"TeacherId"] = [NSString stringWithFormat:@"%ld",(long)self.scheduleDetailModel.TeacherId];
        dic[@"StudentId"] = [NSString stringWithFormat:@"%ld",(long)self.scheduleDetailModel.StudentId];
        dic[@"Points"] = [NSString stringWithFormat:@"%d",self.starNumber];
    }
    NSLog(@"上传的评价信息---%@",dic);
    
    
    [[BaseService share] sendPostRequestWithPath:URL_Tch_Comment parameters:dic token:YES viewController:self success:^(id responseObject) {

        //修改界面的状态
        self.noEvaluationView.hidden = YES;
        self.title = @"";
        [self.navigationController setNavigationBarHidden:YES animated:YES];

        GGT_EvaluationSucceedView *evaluationSucceedView = [GGT_EvaluationSucceedView new];
        [evaluationSucceedView getMessageDic:responseObject];
        evaluationSucceedView.starRatingView.rating = self.starNumber;
        [self.view addSubview:evaluationSucceedView];
        
        [evaluationSucceedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self.view);
        }];
        
      
        @weakify(self);
        [[evaluationSucceedView.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             @strongify(self);
             [self dismissViewControllerAnimated:YES completion:nil];
         }];
        
        
        if (self.refreshCell) {
            self.refreshCell(YES);
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
}


- (void)rightAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end







#pragma mark 头像-姓名-星星
@interface GGT_NoEvaluationView ()
@property (nonatomic, strong) UIImageView *teacherImgView; //教材图片
@property (nonatomic, strong) UILabel *nameLabel; //姓名
@property (nonatomic, strong) UILabel *alertLabel; //提醒文字

@end
@implementation GGT_NoEvaluationView : UIView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    // 图像
    self.teacherImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeCenter;
        imgView.image = UIIMAGE_FROM_NAME(@"headPortrait_default_avatar");
        imgView;
    });
    [self addSubview:self.teacherImgView];
    
    [self.teacherImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(LineY(18));
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LineH(60), LineH(60)));
    }];
    
    
    //姓名
    self.nameLabel = ({
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(14);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
//        label.text = @"Teacher";
        label;
    });
    [self addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.teacherImgView.mas_bottom).offset(LineY(8));
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(LineH(20)));
    }];
    
    
    
    self.starRatingView = [[ASStarRatingView alloc]init];
    self.starRatingView.delegate = self;
    self.starRatingView.rating = 5;
    self.starRatingView.starWidth = LineW(19);
    [self addSubview:self.starRatingView];
    
    
    [self.starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(LineY(6));
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LineW(140), LineW(20)));
    }];
    
    
    self.contentTextView = [[PlaceholderTextView alloc]init];
    self.contentTextView.delegate = self;
    self.contentTextView.font = Font(18);
    self.contentTextView.backgroundColor = UICOLOR_FROM_HEX(0xF4F4F4);
    self.contentTextView.placeHolderLabel.text = textViewPlaceholdString;
    self.contentTextView.placeholder = textViewPlaceholdString;
    self.contentTextView.placeholderColor = UICOLOR_FROM_HEX(Color4A4A4A);
    self.contentTextView.marginSize = CGSizeMake(margin10, margin10);
    [self addSubview:self.contentTextView];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starRatingView.mas_bottom).with.offset(LineY(18));
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LineW(380), LineH(120)));
    }];
    
    
    
    //提醒文字
    self.alertLabel = ({
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(12);
        label.textColor = UICOLOR_FROM_HEX(Color9B9B9B);
        label.text = @"完成课后评价获得5积分";
        label;
    });
    [self addSubview:self.alertLabel];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-LineY(24));
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(LineH(17)));
    }];
    
    
    //完成
    self.finishedButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, 114, 38);
        xc_button.titleLabel.font = Font(16);
        [xc_button setTitle:@"完成" forState:UIControlStateNormal];
        [xc_button setTitle:@"完成" forState:UIControlStateHighlighted];
        [xc_button setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonN") forState:UIControlStateNormal];
        [xc_button setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonN") forState:UIControlStateHighlighted];
        [xc_button setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
        xc_button;
    });
    self.finishedButton.enabled = NO;
    [self addSubview:self.finishedButton];
    
    [self.finishedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.alertLabel.mas_top).offset(- margin10);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LineW(114), LineH(38)));
    }];
}

-(void)getScheduleFinishedHomeModel :(GGT_ScheduleFinishedHomeModel *)model {
    if (!IsStrEmpty(model.TeacherImg)) {
        //请求图片
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.TeacherImg]]];
        UIImage *img = [UIImage imageWithData:data];
        
        //图片压缩
        img = [img imageScaledToSize:CGSizeMake(LineW(60), LineW(60))];
        self.teacherImgView.image = img;
    }
    
    if (!IsStrEmpty(model.TeacherName)) {
        self.nameLabel.text = model.TeacherName;
    }
}

-(void)getScheduleDetailModel :(GGT_ScheduleDetailModel *)model {
    if (!IsStrEmpty(model.TeacherImg)) {
        //请求图片
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.TeacherImg]]];
        UIImage *img = [UIImage imageWithData:data];
        
        //图片压缩
        img = [img imageScaledToSize:CGSizeMake(LineW(60), LineW(60))];
        self.teacherImgView.image = img;
    }
    
    if (!IsStrEmpty(model.TeacherName)) {
        self.nameLabel.text = model.TeacherName;
    }
}



- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        [self.finishedButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonY") forState:UIControlStateNormal];
        [self.finishedButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonY") forState:UIControlStateHighlighted];
        [self.finishedButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
        self.finishedButton.enabled = YES;
    } else {
        [self.finishedButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonN") forState:UIControlStateNormal];
        [self.finishedButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonN") forState:UIControlStateHighlighted];
        [self.finishedButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
        self.finishedButton.enabled = NO;
    }
    
    
    //如果超过100字，就限制，并放弃第一响应者
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
        [self.contentTextView resignFirstResponder];
    }
}


#pragma mark 代理方法
- (void)starNumber:(float)f{
    int num = ceilf(f*1.0);
    
    //如果实现了这个代理就调用，防止代理没有实现调用出现崩溃
    if ([self.delegate respondsToSelector:@selector(getStatNumber:)]) {
        [self.delegate getStatNumber:num];
    }
}


- (void)drawRect:(CGRect)rect {
    [self.teacherImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(30)];
    [self.contentTextView addBorderForViewWithBorderWidth:1.0f BorderColor:UICOLOR_FROM_HEX(0xD7D7D7) CornerRadius:LineH(6)];
}


@end
