//
//  ETTCacheDataManager.h
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 17/2/14.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETTCacheDataManager : NSObject


/**
 *  @author LiuChuanan, 17-02-14 17:02:57
 *  
 *  @brief 单例
 *
 *  @return 单例对象
 *
 *  @since 
 */
+ (instancetype)sharedManager;


/**
 *  @author LiuChuanan, 17-02-14 17:02:23
 *  
 *  @brief 插入数据
 *
 *  @param data 数据
 *
 *  @since 
 */
- (void)insertData:(id)data;

/**
 *  @author LiuChuanan, 17-02-14 17:02:40
 *  
 *  @brief 查询所有数据
 *
 *  @return 所有数据
 *
 *  @since 
 */
- (NSMutableArray *)selectAllData;


/**
 *  @author LiuChuanan, 17-02-14 17:02:06
 *  
 *  @brief 删除所有数据
 *
 *  @since 
 */
- (void)deleteAllData;


/**
 *  @author LiuChuanan, 17-02-14 17:02:18
 *  
 *  @brief 删除单条数据
 *
 *  @param ID 单条数据
 *
 *  @since 
 */
- (void)deleteOneDataWithID:(NSInteger)ID;

@end
