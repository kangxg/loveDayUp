//
//  ETTScenePorter.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/5.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTScenePorterInterface.h"
#import "ETTViewsLoadedRecordManager.h"
@interface ETTScenePorter : NSObject<ETTScenePorterInterface>

/**
 Description 用户防止视图重复加载现象  这个和快速返回的门卫系统是独立的
 */
@property (nonatomic,retain,readonly)ETTViewsLoadedRecordManager  *  EDViewRecordManager;


@end
    
