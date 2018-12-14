//
//  HF_TechnicalDebugViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/14.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_TechnicalDebugViewController.h"
#import "HF_TechnicalDebugView.h"

@interface HF_TechnicalDebugViewController ()

@end

@implementation HF_TechnicalDebugViewController

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 355;
        tempSize.height = 249;//294 切图是294，减去45的导航高度
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    HF_TechnicalDebugView *view = [[HF_TechnicalDebugView alloc]init];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    @weakify(self);
    [[view.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    
    
    //在线技术支持
    [[view.enterClassButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         //#warning 自测直播教室使用，用完之后注释
         //                HF_ClassRoomModel *tkModel = [[HF_ClassRoomModel alloc] init];
         //                tkModel.serial = @"1782752406";
         //                tkModel.host = @"global.talk-cloud.net";
         //                tkModel.port = @"80";
         //                tkModel.nickname = @"小ipad";
         //                tkModel.userrole = @"2";
         //
         //                [HF_ClassRoomManager tk_enterClassroomWithViewController:self courseModel:tkModel leftRoomBlock:^{
         //
         //                }];
         //                return;
         
         
         [self dismissViewControllerAnimated:YES completion:nil];
         [self getHumanCheckClassroomInfo];
     }];
}

// 获取人工检测设备房间的信息
- (void)getHumanCheckClassroomInfo {
    [[BaseService share] sendGetRequestWithPath:URL_GetOnlineInfns token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        // 进入教室
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            HF_ClassRoomModel *model = [HF_ClassRoomModel yy_modelWithDictionary:responseObject[@"data"]];
            if (![model.nickname isKindOfClass:[NSString class]] || model.nickname.length == 0) {
                model.nickname = @"Student";
            }
            
            [HF_ClassRoomManager tk_enterClassroomWithViewController:self courseModel:model leftRoomBlock:^{
                
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
