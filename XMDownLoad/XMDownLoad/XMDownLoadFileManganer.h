//
//  DownLoadFileManganer.h
//  test
//
//  Created by 张琛 on 2018/6/11.
//  Copyright © 2018年 张琛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMDownLoadFileManganer : NSObject
{
    void(^_onDownLoadStartBlock)(XMDownLoadFileManganer *);
    void(^_onDownLoadFinishBlock)(XMDownLoadFileManganer *);
    void(^_onDownLoadErrorBlock)(XMDownLoadFileManganer *);
    
}
//下载链接
@property (copy,nonatomic)NSString  *  downLoadUrl;
//下载进度
@property (copy,nonatomic)NSString  *  progress;
//保存地址
@property (copy,nonatomic)NSURL  *  savePathUrl;
//下载错误信息
@property (strong,nonatomic)NSError *  error;

+ (void)downLoadFileWithUrl:(NSString *)url
            onDownLoadStart:(void(^)(XMDownLoadFileManganer * load))onStartBlock
           onDownLoadFinish:(void(^)(XMDownLoadFileManganer * load))onFinishBlock
            onDownLoadError:(void(^)(XMDownLoadFileManganer * load))onErrorBlock;
- (void)downLoadWithUrl:(NSString *)url
        onDownLoadStart:(void(^)(XMDownLoadFileManganer * load))onStartBlock
       onDownLoadFinish:(void(^)(XMDownLoadFileManganer * load))onFinishBlock
        onDownLoadError:(void(^)(XMDownLoadFileManganer * load))onErrorBlock;
@end
