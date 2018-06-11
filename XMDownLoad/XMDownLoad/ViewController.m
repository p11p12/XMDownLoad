//
//  ViewController.m
//  XMDownLoad
//
//  Created by 张琛 on 2018/6/11.
//  Copyright © 2018年 张琛. All rights reserved.
//

#import "ViewController.h"
#import "XMDownLoadFileManganer.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString * downloadUrl = @"http://resource.yidianjinku.com:8001//sign/contract/a5eaf02fa57f55104167189e88464b911ec6f77153f9d0c567c9ce88323d30be.pdf";
    //    [self downloadFileWithURL:_downloadUrl];
    [XMDownLoadFileManganer downLoadFileWithUrl:downloadUrl onDownLoadStart:^(XMDownLoadFileManganer *load) {
        NSLog(@"111%@",load.progress);
        
    } onDownLoadFinish:^(XMDownLoadFileManganer *load) {
        NSLog(@"222%@",load.savePathUrl);
        
    } onDownLoadError:^(XMDownLoadFileManganer *load) {
        NSLog(@"123321%@",load.error);
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
