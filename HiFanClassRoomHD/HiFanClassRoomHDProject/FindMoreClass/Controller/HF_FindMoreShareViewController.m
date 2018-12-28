//
//  HF_FindMoreShareViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/27.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_FindMoreShareViewController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface HF_FindMoreShareViewController ()

@end

@implementation HF_FindMoreShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

-(void)initUI {
    NSArray *imgArray = @[@"微信",@"Moments",@"微博"];
    for (NSInteger i=0; i<imgArray.count; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%@",imgArray[i]];
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        button.tag = 10+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.left.equalTo(self.view.mas_left).offset(54*i);
            make.size.mas_equalTo(CGSizeMake(54, 54));
        }];
        
        if (i == 0 || i == 1) {
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF3);
            [self.view addSubview:lineView];

            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.view.mas_centerY);
                make.left.equalTo(self.view.mas_left).offset(54+54*i);
                make.size.mas_equalTo(CGSizeMake(1, 22));
            }];
        }
    }
}


-(void)buttonClick:(UIButton *)button {
    if (button.tag == 10) { //微信
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];

    } else if (button.tag == 11) { //微信朋友圈
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];

    } else if (button.tag == 12) { //微博
        [self shareWebPageToPlatformType:UMSocialPlatformType_Sina];

    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //title 和 webpageUrl不能为空
//    NSString *desctStr = [NSString stringWithFormat:@"%@ 在GoGoTalk青少外教英语体验课中获得了一份英语水平测评报告！",self.shareUrl];
//    NSString *desctStr = [NSString stringWithFormat:@"%@ 在GoGoTalk青少外教英语体验课中获得了一份英语水平测评报告！",self.shareUrl];

    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"hi翻外教课堂分享测试" descr:@"hi翻外教课堂分享测试描述" thumImage:UIIMAGE_FROM_NAME(@"分享图标")];
    
    //设置网页地址
    shareObject.webpageUrl = self.shareUrl;
    
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        
    }];
    
}

@end
