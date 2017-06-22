//
//  EttDownloadHeader.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/1.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#ifndef EttDownloadHeader_h
#define EttDownloadHeader_h
////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.1  10:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: 下载相关枚举值
 */

/**
 Description 操作类型
 */
typedef NS_ENUM(NSInteger,ETTDownLoadTaskState)
{
    //无操作类型
    ETTDOWNLOADTASKSTATENONE = 0x00000,
    //任务正在下载中
    ETTDOWNLOADTASKSTATEDOWNLOADING,
    //任务创建失败
     ETTDOWNLOADTASKSTATECREATEFAILE,
    //下载超过配置最大数目
     ETTDOWNLOADTASKSTATEMORETHANMAX,
    //下载任务创建成功
    ETTDOWNLOADTASKSTATECREATESUCCESS,
    //下载失败
    ETTDOWNLOADTASKSTATEFAILURE,
    //没有网络
    ETTDOWNLOADTASKSTATENONETWORK,
};


typedef NS_ENUM(NSInteger,ETTCellEvenType)
{
    //无操作类型
    ETTCELLEVENTYPENONE = 0x00000,
    //开始下载
    ETTCELLEVENTYPEDOWNSTART,
    //暂停下载
    ETTCELLEVENTYPEDOWNPAUSE,
    //取消下载
    ETTCELLEVENTYPEDOWNCANNEL,
    //重新开始下载
    ETTCELLEVENTYPEDOWNAGAIN,
  
};
#endif /* EttDownloadHeader_h */
