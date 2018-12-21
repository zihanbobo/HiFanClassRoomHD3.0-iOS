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


@interface HF_HomeClassDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *aboutTableView;
@property(nonatomic, strong) HF_ClassDetailsTopView *topView;
@property(nonatomic, strong) NSMutableDictionary *data;  //测试数据
@property(nonatomic, strong) HF_PreviewView *previewView;  //课前预习
@property(nonatomic, strong) HF_PracticeView *practiceView;  //课后练习
//@property(nonatomic, assign) BOOL isPreviewViewShow;
@end

@implementation HF_HomeClassDetailViewController

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

-(void)getLodadata
{
    NSString *url = [NSString stringWithFormat:@"%@?lessonId=%d",URL_GetClassDetail,3287];
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self success:^(id responseObject) {
        if([responseObject[@"result"] integerValue] == 1){
            self.data = responseObject[@"data"];
            self.topView.classTitleLabel.text = self.data[@"ChapterName"];
            self.topView.imagePath = self.data[@"ChapterImagePath"];
            self.topView.levelLabel.text = self.data[@"BookName"];
            [self.aboutTableView reloadData];
            //课前预习
            [self initPreviewView];
            //课后练习
            [self initPracticeView];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLodadata];
    [self initTopView];
    //关于本课
    [self initAboutTableView];
    
    


    
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
- (void)initTopView
{
    self.topView = [HF_ClassDetailsTopView new];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.height.mas_equalTo(LineH(245));
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 课前预习View
- (void)initPreviewView
{
    self.previewView = [HF_PreviewView new];
    [self.view addSubview:self.previewView];
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
    self.previewView.desc = @"【课前预习】可以帮助宝贝提升上课效果3~6倍。\n养成良好学习习惯，上课更轻松，知识掌握更牢固。";
    self.previewView.hidden = YES;
}
#pragma mark -- 课后预习View
- (void)initPracticeView
{
    self.practiceView = [HF_PracticeView new];
    [self.view addSubview:self.practiceView];
    [self.practiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
    self.practiceView.hidden = YES;
    self.practiceView.desc = @"【课后复习】可以帮助宝贝对课堂所学知识查漏补缺巩固学习成果。\n配合【课前预习】，可以形成完整学习闭环，有效保障学习效果。";
}
#pragma mark -- 关于本课TableView
-(void)initAboutTableView
{
    //测试数据
//    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"剧情介绍",@"title",@"妈妈今天买回来好多红苹果啊，小朋友们想吃吗，你们能吃几个呢？1个、2个还是3个？今天的词汇课让我们一起数数字吧小鸟、飞机、钢笔、书包等都是我们经常看到的哦，那小朋友们能用英语读出他们的名字吗？今天的语音课让我们一起大声读出来吧！",@"content", nil];
//
//    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"学习目标",@"title",@"hello student hello student hello stustudent hello student hello student hello student student hello studentudent hello student hello student  student hello student hent hello student hello student hellent ",@"content", nil];
//
//    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"词汇",@"title",@"desk（桌子）      chair（椅子）      school（学校）",@"content", nil];
//
//    NSDictionary *dic4 = [NSDictionary dictionaryWithObjectsAndKeys:@"句型",@"title",@"Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nAenean euismod bibendum laoreet.\nProin gravida dolor sit amet lacus accumsan et viverra justo commodo.",@"content", nil];
//
//    NSDictionary *dic5 = [NSDictionary dictionaryWithObjectsAndKeys:@"语法",@"title",@"Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nAenean euismod bibendum laoreet.\nProin gravida dolor sit amet lacus accumsan et viverra justo commodo.",@"content", nil];
    //self.data = [NSMutableArray arrayWithObjects:dic1,dic2,dic3,dic4,dic5, nil];
    self.aboutTableView = [UITableView new];
    self.aboutTableView.estimatedRowHeight = 44.0f;//推测高度，必须有，可以随便写多少
    self.aboutTableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值，可以省略
    self.aboutTableView.dataSource = self;
    self.aboutTableView.delegate = self;
    self.aboutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.aboutTableView];
    [self.aboutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom).offset(0);
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HF_AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell"];
    if(!cell){
        cell = [[HF_AboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aboutCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(indexPath.row == 0){
        cell.title = @"剧情介绍";
        cell.content = self.data[@"ChIntroduction"];
    }
    if(indexPath.row == 1){
        cell.title = @"学习目标";
        cell.content = self.data[@"EnIntroduction"];
    }
    if(indexPath.row == 2){
        cell.title = @"词汇";
        cell.content = @"";
    }
    if(indexPath.row ==3){
        cell.title = @"句型";
        cell.content = @"";
    }
    if(indexPath.row ==4){
        cell.title = @"语法";
        cell.content = @"";
    }
    return cell;
}
@end
