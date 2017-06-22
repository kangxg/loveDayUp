//
//  ETTDownloadModel.h
//  ETTNetworkManager
//
//  Created by Liu Chuanan on 16/9/12.
//  Copyright © 2016年 etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

// 下载状态
typedef NS_ENUM(NSUInteger, ETTDownloadState) {
    ETTDownloadStateNone,        // 未下载
    ETTDownloadStateReadying,    // 等待下载
    ETTDownloadStateRunning,     // 正在下载
    ETTDownloadStateSuspended,   // 下载暂停
    ETTDownloadStateCompleted,   // 下载完成
    ETTDownloadStateFailed,      // 下载失败
    ETTDownloadStateCancel,      // 取消下载
};

@class ETTDownloadProgress;
@class ETTDownloadModel;

// 进度更新block
typedef void (^ETTDownloadProgressBlock)(ETTDownloadProgress *progress);
// 状态更新block
typedef void (^ETTDownloadStateBlock)(ETTDownloadState state,NSString *filePath, NSError *error);

/**
 *  下载模型
 */
@interface ETTDownloadModel : NSObject

// >>>>>>>>>>>>>>>>>>>>>>>>>>  download info
// 下载地址
@property (nonatomic, strong, readonly) NSString *downloadURL;
// 文件名 默认nil 则为下载URL中的文件名
@property (nonatomic, strong, readonly) NSString *fileName;
// 缓存文件目录 默认nil 则为manger缓存目录
@property (nonatomic, strong, readonly) NSString *downloadDirectory;

// >>>>>>>>>>>>>>>>>>>>>>>>>>  task info
// 下载状态
@property (nonatomic, assign, readonly) ETTDownloadState state;
// 下载任务
@property (nonatomic, strong, readonly) NSURLSessionTask *task;
// 文件流
@property (nonatomic, strong, readonly) NSOutputStream *stream;
// 下载进度
@property (nonatomic, strong ,readonly) ETTDownloadProgress *progress;
// 下载路径 如果设置了downloadDirectory，文件下载完成后会移动到这个目录，否则，在manager默认cache目录里
@property (nonatomic, strong, readonly) NSString *filePath;

// >>>>>>>>>>>>>>>>>>>>>>>>>>  download block
// 下载进度更新block
@property (nonatomic, copy) ETTDownloadProgressBlock progressBlock;
// 下载状态更新block
@property (nonatomic, copy) ETTDownloadStateBlock stateBlock;


- (instancetype)initWithURLString:(NSString *)URLString;
/**
 *  初始化方法
 *
 *  @param URLString 下载地址
 *  @param filePath  缓存地址 当为nil 默认缓存到cache
 */
- (instancetype)initWithURLString:(NSString *)URLString filePath:(NSString *)filePath;
////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.6  11:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: 状态设置与数据重置
 
 */

-(void)setDownloadCompleted:(ETTDownloadState)Completed;

-(void)setDownloadState:(ETTDownloadState)state;

-(void)setDownloadProgress:(float)progress;

-(void)resetDownloadData;


-(void)setDownFileName:(NSString *)fileName;
////////////////////////////////////////////////////////
@end

/**
 *  下载进度
 */
@interface ETTDownloadProgress : NSObject

// 续传大小
@property (nonatomic, assign, readonly) int64_t resumeBytesWritten;
// 这次写入的数量
@property (nonatomic, assign, readonly) int64_t bytesWritten;
// 已下载的数量
@property (nonatomic, assign, readonly) int64_t totalBytesWritten;
// 文件的总大小
@property (nonatomic, assign, readonly) int64_t totalBytesExpectedToWrite;
// 下载进度
@property (nonatomic, assign, readonly) float progress;
// 下载速度
@property (nonatomic, assign, readonly) float speed;
// 下载剩余时间
@property (nonatomic, assign, readonly) int remainingTime;
////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.6  11:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: 设置进度
 
 */
-(void)setProgress:(float)progress;@end
////////////////////////////////////////////////////////
