//
//  ETTClearCache.h
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 2017/4/1.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETTClearCache : NSObject

/**
 获得缓存路径
 
 @return 缓存路径
 */
- (NSString *)getCachePath:(NSString *)cachePath;

/**
 计算单个文件的大小
 
 @param path 文件路径
 @return 文件大小
 */
- (float)fileSizeAtPath:(NSString *)path;

/**
 计算目录大小
 缓存文件包括两部分，一部分是使用SDWebImage缓存的内容，其次可能存在自定义的文件夹中的内容（视频，音频等内容），于是计算要分两部分
 @param path 目录
 @return 目录大小
 */
- (float)folderSizeAtPath:(NSString *)foldedPath;

/**
 清理缓存文件
 缓存文件包括两部分，一部分是使用SDWebImage缓存的内容，其次可能存在自定义的文件夹中的内容（视频，音频等内容），于是计算要分两部分
 @param path 目录
 */
- (void)clearCacheAtPath:(NSString *)cachePath;


@end
