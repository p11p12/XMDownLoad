//
//  DownLoadFileManganer.m
//  test
//
//  Created by 张琛 on 2018/6/11.
//  Copyright © 2018年 张琛. All rights reserved.
//

#import "XMDownLoadFileManganer.h"
@interface XMDownLoadFileManganer()<NSURLSessionDownloadDelegate>


@end
@implementation XMDownLoadFileManganer
+ (void)downLoadFileWithUrl:(NSString *)url
            onDownLoadStart:(void(^)(XMDownLoadFileManganer * load))onStartBlock
           onDownLoadFinish:(void(^)(XMDownLoadFileManganer * load))onFinishBlock
            onDownLoadError:(void(^)(XMDownLoadFileManganer * load))onErrorBlock{

    XMDownLoadFileManganer * loadManganer = [[[self class] alloc]init];

    [loadManganer downLoadWithUrl:url
                  onDownLoadStart:onStartBlock
                 onDownLoadFinish:onFinishBlock
                  onDownLoadError:onErrorBlock];
    
    
    

    
}
- (void)downLoadWithUrl:(NSString *)url
  onDownLoadStart:(void(^)(XMDownLoadFileManganer * load))onStartBlock
 onDownLoadFinish:(void(^)(XMDownLoadFileManganer * load))onFinishBlock
  onDownLoadError:(void(^)(XMDownLoadFileManganer * load))onErrorBlock{
        _downLoadUrl = url;
        if (onStartBlock) {
            _onDownLoadStartBlock  =[onStartBlock copy];
            
        }
        if (onFinishBlock) {
            _onDownLoadFinishBlock  =[onFinishBlock copy];
            
        }
        if (onErrorBlock) {
            _onDownLoadErrorBlock  =[onErrorBlock copy];
            
        }
        
        NSString * fileName = [url lastPathComponent];
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        if(![fileManager fileExistsAtPath:filePath])
        {
            [self  downloadFileWithURL:url];
        }else{
            
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *savePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
            NSURL *saveUrl = [NSURL fileURLWithPath:savePath];
            _savePathUrl = saveUrl;
            _onDownLoadFinishBlock(self);
        }
        
}
- (void)downloadFileWithURL:(NSString *)urlStr{
    //默认配置
    NSURLSessionConfiguration *configuration= [NSURLSessionConfiguration defaultSessionConfiguration];
    //得到session对象
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    // url
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    //创建任务
    NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithURL:url];
    //开始任务
    [downloadTask resume];
    
}
#pragma mark -- NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSError *saveError;
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *savePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[_downLoadUrl lastPathComponent]]];
    NSURL *saveUrl = [NSURL fileURLWithPath:savePath];
    _savePathUrl = saveUrl;
    //把下载的内容从cache复制到document下
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveUrl error:&saveError];
    if (!saveError) {
        NSLog(@"save success");
        _onDownLoadFinishBlock(self);
        
    }else{
        NSLog(@"save error:%@",saveError.localizedDescription);
        _error = saveError;
        _onDownLoadErrorBlock(self);

    }
    
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    NSString * progress =  [NSString stringWithFormat:@"下载进度:%f",(double)totalBytesWritten/totalBytesExpectedToWrite];
    _progress = progress;
    _onDownLoadStartBlock(self);
    
    
}
@end
