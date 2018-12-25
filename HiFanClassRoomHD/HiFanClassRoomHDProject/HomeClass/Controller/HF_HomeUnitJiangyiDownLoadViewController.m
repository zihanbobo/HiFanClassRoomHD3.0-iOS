//
//  HF_HomeUnitJiangyiDownViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/25.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeUnitJiangyiDownLoadViewController.h"
#import <QuickLook/QuickLook.h>

@interface HF_HomeUnitJiangyiDownLoadViewController ()<QLPreviewControllerDelegate,QLPreviewControllerDataSource>
@property (strong, nonatomic) QLPreviewController *qlPreview;
@property (copy, nonatomic)NSURL *fileURL;
@end

@implementation HF_HomeUnitJiangyiDownLoadViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self setLeftItem:@"箭头"];
    
    self.qlPreview = [[QLPreviewController alloc] init];
    self.qlPreview.dataSource = self; //需要打开的文件的信息要实现dataSource中的方法
    self.qlPreview.delegate = self;  //视图显示的控制
    [self.view addSubview:self.qlPreview.view];
//    [self presentViewController:self.qlPreview animated:YES completion:^{
//        //需要用模态化的方式进行展示
//    }];
    
    [self a];
}

-(void)a {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = self.urlStr;
    NSString *fileName = [urlStr lastPathComponent]; //获取文件名称
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //判断是否存在
    if([self isFileExist:fileName]) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        self.fileURL = url;
//        [self presentViewController:self.qlPreview animated:YES completion:nil];
    }else {
        [MBProgressHUD showMessage:@"下载中" toView:self.view];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
            return url;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            self.fileURL = filePath;
//            [self presentViewController:self.qlPreview animated:YES completion:nil];
        }];
        [downloadTask resume];
    }

}

//判断文件是否已经在沙盒中存在
-(BOOL) isFileExist:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}



#pragma mark - previewControllerDataSource
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1; //需要显示的文件的个数
}

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    //返回要打开文件的地址，包括网络或者本地的地址
//    NSURL * url = [NSURL URLWithString:self.urlStr];
//        NSURL * url = [NSURL fileURLWithPath:self.urlStr];
    return self.fileURL;
}

#pragma mark - previewControllerDelegate
-(CGRect)previewController:(QLPreviewController *)controller frameForPreviewItem:(id<QLPreviewItem>)item inSourceView:(UIView *__autoreleasing *)view
{
    //提供变焦的开始rect，扩展到全屏
    return CGRectMake(110, 190, 100, 100);
}

//-(UIImage *)previewController:(QLPreviewController *)controller transitionImageForPreviewItem:(id<QLPreviewItem>)item contentRect:(CGRect *)contentRect
//{
//    //返回控制器在出现和消失时显示的图像
//    return [UIImage imageNamed:@"gerenziliao_morentouxiang.png"];
//}

//-(void)previewControllerDidDismiss:(QLPreviewController *)controller
//{
//    //控制器消失后调用
//}
//-(void)previewControllerWillDismiss:(QLPreviewController *)controller
//{
//    //控制器在即将消失后调用
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
