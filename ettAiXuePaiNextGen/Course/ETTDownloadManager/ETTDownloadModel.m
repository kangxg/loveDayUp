//
//  ETTDownloadModel.m
//  ETTNetworkManager
//
//  Created by Liu Chuanan on 16/9/12.
//  Copyright © 2016年 etiantian. All rights reserved.
//

#import "ETTDownloadModel.h"

@interface ETTDownloadProgress ()
// 续传大小
@property (nonatomic, assign) int64_t resumeBytesWritten;
// 这次写入的数量
@property (nonatomic, assign) int64_t bytesWritten;
// 已下载的数量
@property (nonatomic, assign) int64_t totalBytesWritten;
// 文件的总大小
@property (nonatomic, assign) int64_t totalBytesExpectedToWrite;
// 下载进度
@property (nonatomic, assign) float   progress;
// 下载速度
@property (nonatomic, assign) float   speed;
// 下载剩余时间
@property (nonatomic, assign) int remainingTime;

@end

@interface ETTDownloadModel ()

// >>>>>>>>>>>>>>>>>>>>>>>>>>  download info
// 下载地址
@property (nonatomic, strong) NSString *downloadURL;
// 文件名 默认nil 则为下载URL中的文件名
@property (nonatomic, strong) NSString *fileName;
// 缓存文件目录 默认nil 则为manger缓存目录
@property (nonatomic, strong) NSString *downloadDirectory;

// >>>>>>>>>>>>>>>>>>>>>>>>>>  task info
// 下载状态
@property (nonatomic, assign) ETTDownloadState state;
// 下载任务
@property (nonatomic, strong) NSURLSessionTask *task;
// 文件流
@property (nonatomic, strong) NSOutputStream   *stream;
// 下载文件路径,下载完成后有值,把它移动到你的目录
@property (nonatomic, strong) NSString         *filePath;
// 下载时间
@property (nonatomic, strong) NSDate           *downloadDate;
// 断点续传需要设置这个数据
@property (nonatomic, strong) NSData           *resumeData;
// 手动取消当做暂停
@property (nonatomic, assign) BOOL manualCancle;

@end

@implementation ETTDownloadModel

- (instancetype)init
{
    if (self = [super init]) {
        _progress = [[ETTDownloadProgress alloc]init];
    }
    return self;
}

- (instancetype)initWithURLString:(NSString *)URLString
{
    return [self initWithURLString:URLString filePath:nil];
}

- (instancetype)initWithURLString:(NSString *)URLString filePath:(NSString *)filePath
{
    if (self = [self init]) {
        _downloadURL = URLString;
        _fileName = filePath.lastPathComponent;
        _downloadDirectory = filePath.stringByDeletingLastPathComponent;
        _filePath = filePath;
    }
    return self;
}

-(void)setDownloadCompleted:(ETTDownloadState)Completed
{
    if (Completed  == ETTDownloadStateCompleted ||Completed  ==ETTDownloadStateFailed )
    {
        if (_task)
        {
            [_task cancel];
            _task = nil;
            
        }
    }
    _state = Completed;
}

-(void)setDownloadState:(ETTDownloadState)state
{
    _state = state;
    
    switch (_state)
    {
        case ETTDownloadStateCancel:
        {
            if (_progress)
            {
                [_progress setProgress:0];
            }
        }
            break;
        case ETTDownloadStateCompleted:
        {
            [self setDownloadCompleted:ETTDownloadStateCompleted];
        }
            break;
        case ETTDownloadStateFailed :
        {
            [self setDownloadCompleted:ETTDownloadStateFailed ];
            if (_progress)
            {
                [_progress setProgress:0];
            }
        }
            break;
        default:
            break;
    }
}

-(void)resetDownloadData
{
    if (_progress)
    {
        [_progress setProgress:0];
    }
    self.state = ETTDownloadStateNone;
}
-(void)setDownloadProgress:(float)progress;
{
    if (_progress)
    {
        [_progress setProgress:progress];
    }
    
}

-(NSString *)fileName
{
    if (!_fileName) {
        
        NSString *str = _downloadURL.lastPathComponent;
        
        NSString *fileName = [_downloadURL substringToIndex:_downloadURL.length - str.length-1].lastPathComponent;
        
        _fileName = [NSString stringWithFormat:@"%@%@",fileName,str];
    
    }
    return _fileName;
}

-(void)setDownFileName:(NSString *)fileName
{

}
- (NSString *)downloadDirectory
{
    if (!_downloadDirectory) {
        _downloadDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ETTDownloadCache"];
    }
    return _downloadDirectory;
}

- (NSString *)filePath
{
    if (!_filePath) {
        _filePath = [self.downloadDirectory stringByAppendingPathComponent:self.fileName];
    }
    return _filePath;
}

@end

@implementation ETTDownloadProgress
-(void)setProgress:(float)progress
{
    _progress = MIN(progress, 1.0);
    _progress = MAX(progress, 0);
    
}
@end
