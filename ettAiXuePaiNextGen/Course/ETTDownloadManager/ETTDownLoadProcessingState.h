//
//  ETTDownLoadProcessingState.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/1.
//  Copyright © 2017年 Etiantian. All rights reserved.
//
////////////////////////////////////////////////////////
/*
 new      : add
 time     : 2017.4.1  14:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: 创建下载任务失败，提示信息辅助类
 */
////////////////////////////////////////////////////////
#import "ETTBaseModel.h"
#import "EttDownloadHeader.h"
@interface ETTDownLoadProcessingState : ETTBaseModel
+(void)processingCreateDownloadstate:(ETTDownLoadTaskState)state;

@end
