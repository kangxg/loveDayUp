//
//  ETTPorterEnum.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/7.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#ifndef ETTPorterEnum_h
#define ETTPorterEnum_h
#define YZ_INLINE static inline
/**
 Description 操作类型
 */
typedef NS_ENUM(NSInteger,ETTGuradHandle)
{
    //无操作类型
    ETTVCHANDLENONE,
    //push操作类型
    ETTVCHANDLEPUSH,
    //present操作类型
    ETTVCHANDLEPRESENT,
    //添加子视图类型
    ETTVCHANDLESUBVIEW,
};

/**
 Description  门卫系统人员的档案信息
 */
typedef struct ETTGuradArchive
{
    //门牌号，每个院落的门牌号
    NSInteger   doorplate;
    //工牌号，也就是每个门卫的编号
    NSInteger  empno;
    //是否需要通知 快速返回 推送页面不需要
    BOOL       needNotice;
    //请求类型
    ETTGuradHandle   guradHandle;
} ETTGuradArchive;

YZ_INLINE ETTGuradArchive
ETTGuradArchiveNoticeMake(NSInteger doorplate,NSInteger empno,BOOL needNotice,ETTGuradHandle guradHandle)
{
    ETTGuradArchive             guradArchive ;
    guradArchive.doorplate    = doorplate;
    guradArchive.empno        = empno;
    guradArchive.needNotice   = needNotice;
    guradArchive.guradHandle  = guradHandle;
    
    return guradArchive;
}
YZ_INLINE ETTGuradArchive

ETTGuradArchiveMake(NSInteger doorplate,NSInteger empno,ETTGuradHandle guradHandle)
{

    return ETTGuradArchiveNoticeMake(doorplate, empno, YES, guradHandle);
}


#endif /* ETTPorterEnum_h */
