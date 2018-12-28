//
//  HF_HomeClassDetailViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/19.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeClassDetailViewController.h"
#import "HF_ClassDetailsTopView.h"
#import "HF_AboutCell.h"
#import "HF_PreviewView.h"
#import "HF_PracticeView.h"
#import "HF_PracticeViewController.h"
#import "HF_HomeClassDetailModel.h"

@interface HF_HomeClassDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *aboutTableView;
@property(nonatomic, strong) HF_ClassDetailsTopView *topView;
@property(nonatomic, strong) NSMutableDictionary *data;  //测试数据
@property(nonatomic, strong) HF_PreviewView *previewView;  //课前预习
@property(nonatomic, strong) HF_PracticeView *practiceView;  //课后练习
@property(nonatomic, strong) HF_HomeClassDetailModel *cellModel;
@end

@implementation HF_HomeClassDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopView];
    [self getLodadata];
}

-(void)getLodadata {
    NSString *url = [NSString stringWithFormat:@"%@?chapterId=%ld",URL_GetChapterInfo,(long)self.lessonId];
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self success:^(id responseObject) {
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            self.cellModel = [HF_HomeClassDetailModel yy_modelWithDictionary:responseObject[@"data"]];
        }
        self.topView.headerModel = self.cellModel;
        [self.aboutTableView reloadData];

    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HF_AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell"];
    if(!cell){
        cell = [[HF_AboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aboutCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if(indexPath.row == 0){
        cell.titleLabel.text = @"剧情介绍";
        
        if (!IsStrEmpty(self.cellModel.ChIntroduction)) {
            cell.contentLabel.text = self.cellModel.ChIntroduction;
        }
    }
    
    if(indexPath.row == 1){
        cell.titleLabel.text = @"学习目标";
        if (!IsStrEmpty(self.cellModel.EnIntroduction)) {
            cell.contentLabel.text = self.cellModel.EnIntroduction;
        }
    }

    return cell;
}

//MARK:UI加载
- (void)initTopView {
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.height.mas_equalTo(LineH(245));
    }];
    
    [self.view addSubview:self.aboutTableView];
    [self.aboutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom).offset(0);
    }];
    
    [self.view addSubview:self.practiceView];
    [self.practiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
    
    
    [self.view addSubview:self.previewView];
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
}

//MARK:懒加载
-(HF_ClassDetailsTopView *)topView {
    if (!_topView) {
        self.topView = [[HF_ClassDetailsTopView alloc] init];
        //关闭按钮
        @weakify(self);
        [[self.topView.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             @strongify(self);
             [self dismissViewControllerAnimated:YES completion:nil];
         }];
        
        //关于本课按钮
        [[self.topView.aboutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.topView.aboutButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 70) forState:UIControlStateNormal];
                [self.topView.previewButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 40) forState:UIControlStateNormal];
                [self.topView.practiceButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 40) forState:UIControlStateNormal];
                self.topView.buttonLine.frame = CGRectMake(self.topView.aboutButton.frame.origin.x, self.topView.aboutButton.frame.origin.y + self.topView.aboutButton.frame.size.height - 6, self.topView.aboutButton.frame.size.width, LineH(3));
            } completion:^(BOOL finished) {
                self.aboutTableView.hidden = NO;
                self.previewView.hidden = YES;
                self.practiceView.hidden = YES;
                
            }];
        }];
        //课前预习按钮
        [[self.topView.previewButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.topView.aboutButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 40) forState:UIControlStateNormal];
                [self.topView.previewButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 70) forState:UIControlStateNormal];
                [self.topView.practiceButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 40) forState:UIControlStateNormal];
                self.topView.buttonLine.frame = CGRectMake(self.topView.previewButton.frame.origin.x, self.topView.previewButton.frame.origin.y + self.topView.previewButton.frame.size.height - 6, self.topView.previewButton.frame.size.width, LineH(3));
            } completion:^(BOOL finished) {
                self.aboutTableView.hidden = YES;
                self.previewView.hidden = NO;
                self.practiceView.hidden = YES;
                
            }];
        }];
        //课后练习按钮
        [[self.topView.practiceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.topView.aboutButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 40) forState:UIControlStateNormal];
                [self.topView.previewButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 40) forState:UIControlStateNormal];
                [self.topView.practiceButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 70) forState:UIControlStateNormal];
                self.topView.buttonLine.frame = CGRectMake(self.topView.practiceButton.frame.origin.x, self.topView.practiceButton.frame.origin.y + self.topView.practiceButton.frame.size.height - 6, self.topView.practiceButton.frame.size.width, LineH(3));
            } completion:^(BOOL finished) {
                self.aboutTableView.hidden = YES;
                self.previewView.hidden = YES;
                self.practiceView.hidden = NO;
            }];
        }];
        
    }
    return _topView;
}


-(UITableView *)aboutTableView {
    if (!_aboutTableView) {
        self.aboutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        self.aboutTableView.estimatedRowHeight = 44.0f;//推测高度，必须有，可以随便写多少
        self.aboutTableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值，可以省略
        self.aboutTableView.dataSource = self;
        self.aboutTableView.delegate = self;
        self.aboutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _aboutTableView;
}

-(HF_PreviewView *)previewView {
    if (!_previewView) {
        self.previewView = [HF_PreviewView new];
        self.previewView.desc = @"【课前预习】可以帮助宝贝提升上课效果3~6倍。\n养成良好学习习惯，上课更轻松，知识掌握更牢固。";
        self.previewView.hidden = YES;
        @weakify(self);
        self.previewView.classBeforeBtnBlock = ^{
            @strongify(self);
            HF_PracticeViewController *vc = [[HF_PracticeViewController alloc] init];
            vc.webUrl = self.cellModel.BeforeFilePath;
            vc.titleStr = self.cellModel.ChapterName;
            vc.lessonid = self.cellModel.ChapterID;
            [self presentViewController:vc animated:YES completion:nil];
        };
    }
    return _previewView;
}


-(HF_PracticeView *)practiceView {
    if (!_practiceView) {
        self.practiceView = [HF_PracticeView new];
        self.practiceView.desc = @"【课后练习】可以帮助宝贝对课堂所学知识查漏补缺巩固学习成果。\n配合【课前预习】，可以形成完整学习闭环，有效保障学习效果。";
        self.practiceView.hidden = YES;
        @weakify(self);
        self.practiceView.classAfterBtnBlock = ^{
            @strongify(self);
            HF_PracticeViewController *vc = [[HF_PracticeViewController alloc] init];
            vc.webUrl = self.cellModel.AfterFilePath;
            vc.titleStr = self.cellModel.ChapterName;
            vc.lessonid = self.cellModel.ChapterID;
            [self presentViewController:vc animated:YES completion:nil];
        };
    }
    return _practiceView;
}

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 600;
        tempSize.height = SCREEN_HEIGHT()-145;
        return tempSize;
    }else {
        return [super preferredContentSize];
    }
}

- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    super.preferredContentSize = preferredContentSize;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
