//
//  GGT_GradingAlertVC.m
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/12/1.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_GradingAlertVC.h"
#import "GGT_QuestionCell.h"
#import "GGT_QuestionHeaderView.h"
#import "GGT_QuestionBottomView.h"
#import "GGT_GradingResultAlertView.h"

static NSString * const xc_answerMuArray = @"xc_answerMuArray";

static CGFloat const xc_topContentViewHeight = 82.0f;
static CGFloat const xc_collectionHeight = 299.0f;
static CGFloat const xc_cellWidth = 98.0f;
static CGFloat const xc_cellHeight = 38.0f;

@interface GGT_GradingAlertVC ()<UICollectionViewDelegate, UICollectionViewDataSource,UIGestureRecognizerDelegate,getNameFieldDelegate>

// 顶部
@property (nonatomic, strong) UIView *xc_topContentView;
@property (nonatomic, strong) UIButton *xc_topTitleButton;
@property (nonatomic, strong) UILabel *xc_topMessageLabel;

// 中间
@property (nonatomic, strong) UICollectionView *xc_questionCollectionView;

// 底部
@property (nonatomic, strong) GGT_QuestionBottomView *xc_bottomView;

@property (nonatomic, strong) UIDatePicker *xc_datePicker;

// 容器
@property (nonatomic, strong) NSMutableArray *xc_questionMuArray;
@property (nonatomic, strong) NSMutableDictionary *xc_answerMuDic;
@property (nonatomic, strong) NSMutableArray *xc_answerMuArray;
@end

@implementation GGT_GradingAlertVC

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = SCREEN_WIDTH() - 186 * 2;
        tempSize.height = SCREEN_HEIGHT() - 79 * 2;
        return tempSize;
    }else {
        return [super preferredContentSize];
    }
}
- (void)setPreferredContentSize:(CGSize)preferredContentSize {
    super.preferredContentSize = preferredContentSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //给bgView添加手势
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapClick)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    //初始化数据
    self.xc_questionMuArray = [NSMutableArray array];
    self.xc_answerMuDic = [NSMutableDictionary dictionary];
    self.xc_answerMuArray = [NSMutableArray array];
    self.xc_answerMuDic[@"HeadImg"] = @"";
    self.xc_answerMuDic[@"StudyEnglishChannel"] = @"";
    self.xc_answerMuDic[@"Gender"] = @"1";

    
    [self buildUI];
    [self buildNet];
    [self checkArrayCount];
}

#pragma mark 获取分级调查的数据
- (void)buildNet {
    [[BaseService share] sendGetRequestWithPath:URL_AppGetSurvey token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDic = responseObject[@"data"];
            if ([dataDic isKindOfClass:[NSDictionary class]]) {
                [self.xc_topTitleButton setTitle:dataDic[@"Head"] forState:UIControlStateNormal];
                [self.xc_topTitleButton setTitle:dataDic[@"Head"] forState:UIControlStateHighlighted];
                self.xc_topMessageLabel.text = dataDic[@"Title"];
                
                NSArray *listArray = dataDic[@"List"];
                if ([listArray isKindOfClass:[NSArray class]] && listArray.count > 0) {
                    [listArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        GGT_QuestionModel *model = [GGT_QuestionModel yy_modelWithDictionary:obj];
                        
                        [model.QuestionValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            GGT_AnswerModel *model = obj;
                            model.type = XCAnswerTypeDeselect;
                        }];
                        
                        [self.xc_questionMuArray addObject:model];
                    }];
                }
            }
        }
        
        [self.xc_questionCollectionView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 创建UI
- (void)buildUI {
    // 顶部
    self.xc_topContentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_FROM_HEX(kThemeColor);
        view;
    });
    [self.view addSubview:self.xc_topContentView];
    
    [self.xc_topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(xc_topContentViewHeight));
        make.left.right.top.equalTo(self.view);
    }];
    
    // title
    self.xc_topTitleButton = ({
        UIButton *button = [UIButton new];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setImage:UIIMAGE_FROM_NAME(@"笔") forState:UIControlStateNormal];
        [button setImage:UIIMAGE_FROM_NAME(@"笔") forState:UIControlStateHighlighted];
        button.titleLabel.font = Font(22);
        button;
    });
    [self.xc_topContentView addSubview:self.xc_topTitleButton];
    
    [self.xc_topTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_topContentView.mas_top).offset(14);
        make.centerX.equalTo(self.xc_topContentView.mas_centerX);
    }];
    
    // message
    self.xc_topMessageLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = Font(16);
        label;
    });
    [self.xc_topContentView addSubview:self.xc_topMessageLabel];
    
    [self.xc_topMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.xc_topContentView.mas_bottom).offset(-12);
        make.centerX.equalTo(self.xc_topContentView.mas_centerX);
    }];
    
    // 中间
    // questionView
    UICollectionViewFlowLayout *xc_layout = [[UICollectionViewFlowLayout alloc] init];
    xc_layout.itemSize = CGSizeMake(xc_cellWidth, xc_cellHeight);
    xc_layout.minimumLineSpacing = 0;
    xc_layout.minimumInteritemSpacing = 0;
    xc_layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.xc_questionCollectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:xc_layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        //        collectionView.alwaysBounceVertical = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView;
    });
    [self.view addSubview:self.xc_questionCollectionView];
    
    [self.xc_questionCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_topContentView.mas_bottom);
        make.height.equalTo(self.view).offset(-xc_collectionHeight);
        make.left.equalTo(self.view).offset(margin40);
        make.right.equalTo(self.view).offset(-margin40);
    }];
    
    // 注册cell
    [self.xc_questionCollectionView registerClass:[GGT_QuestionCell class] forCellWithReuseIdentifier:NSStringFromClass([GGT_QuestionCell class])];
    [self.xc_questionCollectionView registerClass:[GGT_QuestionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([GGT_QuestionHeaderView class])];
    
    
    // 底部
    self.xc_bottomView = ({
        GGT_QuestionBottomView *view = [[GGT_QuestionBottomView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        view;
    });
    self.xc_bottomView.delegate = self;
    [self.view addSubview:self.xc_bottomView];
    
    [self.xc_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_questionCollectionView.mas_bottom);
        make.left.right.equalTo(self.xc_questionCollectionView);
        make.bottom.equalTo(self.view);
    }];
    
    // 生日PickerView
    self.xc_datePicker = ({
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        picker.hidden = YES;
        picker.backgroundColor = [UIColor whiteColor];
        picker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_ch"];
        // 设置时区
        [picker setTimeZone:[NSTimeZone localTimeZone]];
        picker.datePickerMode = UIDatePickerModeDate;
        // 设置当前显示时间
        [picker setDate:[NSDate date] animated:YES];
        // 设置显示最大时间（此处为当前时间）
        NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
        [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSDate *minDate = [pickerFormatter dateFromString:@"1918年01月01日"];
        //设置日期最大及最小值
        picker.minimumDate = minDate;
        [picker setMaximumDate:[NSDate date]];
        //        [picker addTarget:self action:@selector(seletedBirthyDate:) forControlEvents:UIControlEventValueChanged];
        picker;
    });
    [self.view addSubview:self.xc_datePicker];
    
    
    [self.xc_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.xc_bottomView.xc_rightTFParentView.mas_top);
        make.centerX.equalTo(self.xc_bottomView.xc_rightTFParentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(240, 160));
    }];
    
    
    [self buildAction];
}


#pragma mark - 添加按钮时间
- (void)buildAction {
    @weakify(self);
    // Gender 0 女 1 男
    // 男孩按钮
    [[self.xc_bottomView.xc_manButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         self.xc_bottomView.xc_manButton.selected = YES;
         self.xc_bottomView.xc_womanButton.selected = NO;
         self.xc_answerMuDic[@"Gender"] = @"1";
         self.xc_datePicker.hidden = YES;
         [[self mutableArrayValueForKey:xc_answerMuArray] addObject:@"1"];
         [self checkArrayCount];
     }];
    
    // 女孩按钮
    [[self.xc_bottomView.xc_womanButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         self.xc_bottomView.xc_manButton.selected = NO;
         self.xc_bottomView.xc_womanButton.selected = YES;
         self.xc_answerMuDic[@"Gender"] = @"0";
         self.xc_datePicker.hidden = YES;
         [[self mutableArrayValueForKey:xc_answerMuArray] addObject:@"2"];
         [self checkArrayCount];
     }];
    
    
    // 生日
    [[self.xc_datePicker rac_signalForControlEvents:UIControlEventValueChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
         [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
         NSString *dateStr = [pickerFormatter stringFromDate:[self.xc_datePicker date]];
         self.xc_bottomView.xc_birthdayLabel.text = dateStr;
         self.xc_answerMuDic[@"Birthday"] = dateStr;
         [[self mutableArrayValueForKey:xc_answerMuArray] addObject:dateStr];
         [self checkArrayCount];
     }];
    
    // 生日
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        self.xc_datePicker.hidden = NO;
    }];
    [self.xc_bottomView.xc_rightTFParentView addGestureRecognizer:tap];
    
}


- (void)getNameField:(NSString *)nameStr {
    self.xc_answerMuDic[@"EName"] = self.xc_bottomView.xc_nameTextField.text;
    if (self.xc_bottomView.xc_nameTextField.text.length == 0) {
        [self.xc_answerMuDic removeObjectForKey:@"EName"];
    }
    self.xc_datePicker.hidden = YES;
    [[self mutableArrayValueForKey:xc_answerMuArray] addObject:self.xc_bottomView.xc_nameTextField.text];
    [self checkArrayCount];
}

#pragma mark 检查数组的个数，判断是否可以点击完成按钮
- (void)checkArrayCount {
    NSLog(@"%@", self.xc_answerMuDic);

    if (self.xc_answerMuDic.allKeys.count == 8) {
        self.xc_bottomView.xc_commitButton.enabled = YES;
        [self.xc_bottomView.xc_commitButton setBackgroundColor:UICOLOR_FROM_HEX(kThemeColor)];
        // 完成按钮事件
        @weakify(self);
        [[self.xc_bottomView.xc_commitButton rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             @strongify(self);
             self.xc_datePicker.hidden = YES;
             [self sendData];
         }];
    } else {
        [self.xc_bottomView.xc_commitButton setBackgroundColor:UICOLOR_FROM_HEX(ColorE8E8E8)];
        self.xc_bottomView.xc_commitButton.enabled = NO;
    }

}

#pragma mark 点击手势,点击空白处，让时间弹窗隐藏
-(void)TapClick {
    [self.view endEditing:YES];
    self.xc_datePicker.hidden = YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.xc_datePicker.hidden = YES;
}



- (void)sendData {
    NSLog(@"%@",self.xc_answerMuDic);
    
    /*
     EName                  学生英文名
     Birthday               生日
     Gender                 性别
     HeadImg                学生头像
     StudyTime              孩子学习英语已有多久 1:(一年以下) 2:(1-2年) 3:(2-3年) 4:(3年以上)
     StudyWeekTime            孩子每周学习英语时长   1:(小于1小时) 2:(1-2小时) 3:(2-3小时) 4:(大于3小时)
     StudyEnglishChannel    孩子学习英语的主要途径  1:(在校学习) 2:(自学) 3:(在培训机构学习) 4:(以上全部)----暂未使用，置为空
     IsJoinEnglishTest      孩子是否参加过校外英语测试  1:(是) 2:(否)
     */

    [[BaseService share] sendPostRequestWithPath:URL_GradeInvestigation parameters:self.xc_answerMuDic token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                    
                    [UserDefaults() setObject:responseObject[@"data"][@"BookingId"] forKey:K_BookingId];
                    [UserDefaults() setObject:responseObject[@"data"][@"LevelName"] forKey:K_LevelName];
                    [UserDefaults() synchronize];
                    
                    
                    NSDictionary *dic = responseObject[@"data"];
                    //展示弹窗
                    if ([dic[@"Title"] isKindOfClass:[NSString class]] && [dic[@"Title"] length] > 0 &&
                        [dic[@"Title1"] isKindOfClass:[NSString class]] && [dic[@"Title1"] length] > 0 &&
                        [dic[@"Title2"] isKindOfClass:[NSString class]] && [dic[@"Title2"] length] > 0) {

                        
                        [GGT_GradingResultAlertView viewWithTitle:dic[@"Title"] middleMessage:dic[@"Title1"] bottomMessage:dic[@"Title2"] bottomButtonTitle:@"知道了" bgImg:@"外框" cancleBlock:^{

                        } enterBlock:^{
                            //刷新《我的》部分的数据
                            HF_Singleton *sin = [HF_Singleton sharedSingleton];
                            sin.isRefreshSelfInfoData = YES;
                        }];
                    }
                }
            }
        }];


        // 弹框提醒
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
}


#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
// 组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.xc_questionMuArray.count;
}

// 每组个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.xc_questionMuArray.count > 0) {
        return [self.xc_questionMuArray[section] QuestionValue].count;
    }
    return 0;
}

// 设置cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(xc_cellWidth, xc_cellHeight);
}

//返回行内部cell（item）之间的距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return margin30;
}

//返回行间距 上下间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGT_QuestionCell *cell = [GGT_QuestionCell cellWithCollectionView:collectionView indexPath:indexPath];
    GGT_QuestionModel *xc_questionModel = self.xc_questionMuArray[indexPath.section];
    GGT_AnswerModel *xc_answerModel = xc_questionModel.QuestionValue[indexPath.row];
    cell.xc_answerModel = xc_answerModel;
    return cell;
}

// 设置header和footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    GGT_QuestionHeaderView *headerView = [GGT_QuestionHeaderView headerWithCollectionView:collectionView indexPath:indexPath];
    headerView.xc_questionModel = self.xc_questionMuArray[indexPath.section];
    return headerView;
}

// collectionView的footer高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 10);
}

// collectionView的header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 45);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 首先取出来在哪一个section
    NSArray *sectionArray = [self.xc_questionMuArray[indexPath.section] QuestionValue];
    
    // 将选中的设置成选中状态 将其他的设置成未选中状态
    [sectionArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GGT_AnswerModel *model = obj;
        if (indexPath.row == idx) {
            model.type = XCAnswerTypeSelect;
            [[self mutableArrayValueForKey:xc_answerMuArray] addObject:model.Value];
            switch (indexPath.section) {
                case 0:
                {
                    self.xc_answerMuDic[@"StudyTime"] = model.Value;
                    [self checkArrayCount];
                }
                    break;
                case 1:
                {
                    self.xc_answerMuDic[@"StudyWeekTime"] = model.Value;
                    [self checkArrayCount];

                }
                    break;
                case 2:
                {
                    self.xc_answerMuDic[@"IsJoinEnglishTest"] = model.Value;
                    [self checkArrayCount];

                }
                    break;
                    
                default:
                    break;
            }
        } else {
            model.type = XCAnswerTypeDeselect;
        }
    }];
    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
