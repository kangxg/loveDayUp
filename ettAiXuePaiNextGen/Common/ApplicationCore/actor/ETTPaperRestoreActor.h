//
//  ETTPaperRestoreActor.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/6/9.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseActor.h"
typedef NS_ENUM(NSInteger,ETTPaperRestoreState)
{
    //无类型
    ETTPAPERRESTORENONE,
    //推送恢复开始状态
    ETTPAPERRESTOREPUSHEDBEGIN,
    //推送恢复结束
    ETTPAPERRESTOREPUSHEND,
    //结束作答开始状态
    ETTPAPERRESTOREENDANSERBEGIN,
    //结束作答  结束
    ETTPAPERRESTOREENDANSEREND,

};

@interface ETTPaperRestoreActor : ETTBaseActor

@end
