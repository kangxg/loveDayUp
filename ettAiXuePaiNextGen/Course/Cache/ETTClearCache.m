//
//  ETTClearCache.m
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 2017/4/1.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTClearCache.h"
#import <SDImageCache.h>

@implementation ETTClearCache

#pragma - mark 清理缓存

/**
 获得缓存路径
 
 @return 缓存路径
 */
- (NSString *)getCachePath:(NSString *)cachePath
{
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *filePath = [cachesDirectory stringByAppendingPathComponent:cachePath];
    return filePath;
}

/**
 计算单个文件的大小
 
 @param path 文件路径
 @return 文件大小
 */
- (float)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path])
    {
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        float sizeC = size /1024.0/1024.0;
        return sizeC;
    }
    return 0;
}


/**
 计算目录大小
 缓存文件包括两部分，一部分是使用SDWebImage缓存的内容，其次可能存在自定义的文件夹中的内容（视频，音频等内容），于是计算要分两部分
 @param path 目录
 @return 目录大小
 */
- (float)folderSizeAtPath:(NSString *)foldedPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:foldedPath])
    {
        NSArray *childFiles = [fileManager subpathsAtPath:foldedPath];
        for (NSString *fileName in childFiles) {
            NSString *absoluatePath = [foldedPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absoluatePath];
            
            //SDWebImage框架计算缓存
            folderSize += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        }
        return folderSize;
    }
    return 0;
}


/**
 清理缓存文件
 缓存文件包括两部分，一部分是使用SDWebImage缓存的内容，其次可能存在自定义的文件夹中的内容（视频，音频等内容），于是计算要分两部分
 @param path 目录
 */
- (void)clearCacheAtPath:(NSString *)cachePath
{
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        dispatch_queue_t clearQueue = dispatch_queue_create("clearQueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(clearQueue, ^{
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:cachePath])
            {
                NSArray *childFiles = [fileManager subpathsAtPath:cachePath];
                for (NSString *fileName in childFiles) {
                    NSString *absoluatePath = [cachePath stringByAppendingPathComponent:fileName];
                    [fileManager removeItemAtPath:absoluatePath error:nil];
                }
            }
        });
    }];
}

@end
