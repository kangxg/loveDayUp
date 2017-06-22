//
//  ETTCoreEnum.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#ifndef ETTCoreEnum_h
#define ETTCoreEnum_h

//typedef struct ETTCVCard
//{
//    //门牌号，每个院落的门牌号
//    NSInteger   doorplate;
//    //工牌号，也就是每个门卫的编号
//    NSInteger  empno;
//    //是否需要通知 快速返回 推送页面不需要
//    BOOL       needNotice;
//    //请求类型
//    ETTGuradHandle   guradHandle;
//} ETTCVCard;



/**
 Description 身份级别 中国行政级别采用行政五级划分为：国家级、省部级、司厅局级、县处级、乡镇科级，各级分为正副职。中央部委的等级即平常大家所说的“国、部（省）、司、处、科”五级。
 */
typedef NS_ENUM(NSInteger,ETTOfficialsLevel)
{
    //无操作类型
    ETTOFFICIALSNONE = 0,
    
    //部级
    ETTOFFICIALSLEVEL  = 4000,
    //人事部部长
    ETTOFFICIALSPERDEP,
    
    //安全部部长
    ETTOFFICIALSSECURITY,
    
    //民政部部长
    ETTOFFICIALSCIVILAFFAIRS,
//    ETTOFFICIALSminister
    
    //国家级
    ETTOFFICIALSNATIONAL = 9000,
//    //代总理
//    ETTOFFICIALSGENERALINTERIMMANAGER= 9001,
    //总理
    ETTOFFICIALSGENERALMANAGER = 9001,
  
    //
    ETTOFFICIALSHIGHEST = 10000,
    

};

/**
 Description 身份类型
 */
typedef NS_ENUM(NSInteger,ETTPersonType)
{
    //无操作类型
    ETTPERSONTYPENONE = 0,
    //普通人员
    ETTPERSONTYPEORDINAEY,
    //官员
    ETTPERSONTYPEOFFICIALS,
    
};

/**
 Description 人事部工作类型
 */
typedef NS_ENUM(NSInteger,ETTPerDepOfficeType)
{
    //无操作类型
    ETTPERDEPOFFICENONE = 0,
    //整理政府总理资料
    ETTPERDEPOFFICEGENMANAGER,
    //官员
   
    
};


/**
 Description 形势
 */
typedef NS_ENUM(NSInteger,ETTSituation)
{
    //无操作类型
    ETTSITUATIONNONE = 0,
    //无任何信息
    ETTSITUATIONNOINFORMATION =ETTSITUATIONNONE,
    
    ETTSITUATIONLOG = 1,
    
    //进入班级（相当于加载完成）
    ETTSITUATIONINCLASSROOM,
    
    //课堂操作汇报(用于推送）
    ETTSITUATIONCLASSREPORT,
    //更新数据
    ETTETTSITUATIONCLASSUPDATE,
    //结束推送
    ETTSITUATIONCLASSENDPUSHREPORT,
    
    
    //官员
    
    
};

/**
 Description
 */
typedef NS_ENUM(NSInteger,ETTRestoreState)
{
    ETTRESTORENONO =  500,
    //救灾恢复开始
    ETTRESTOREBEGIN,
    //救灾恢复结束
    ETTRESTOREEND,
    //救灾恢复完成并删除备份
    ETTDELRESTOREACACHIVE,
    
};
/**
 Description 任务操作状态
 */
typedef NS_ENUM(NSInteger,ETTTaskOperationState)
{
    //无操作类型
    ETTTASKOPERATIONSTATENONE = 0,
    //将要开始
    ETTTASKOPERATIONSTATEWILLBEGAIN ,
    //开始执行
    ETTTASKOPERATIONSTATESTART,
    //加载资源
    ETTTASKOPERATIONSTATELOADDING,
    //资源加载完成
    ETTTASKOPERATIONSTATELOADCOMPLETE,
    //结束
    ETTTASKOPERATIONSTATEWILLBEGAINEND,
    //命令错误
    ETTTASKOPERATIONSTATETASKERROR,
    //恢复错误
    ETTTASKOPERATIONSTATEERROR,
    //结束推送操作了
    TTTASKOPERATIONSTATEPUSHFINISH,
    
};

/**
 Description 恢复的动作状态
 */
typedef NS_ENUM(NSInteger,ETTBackupOperationState)
{
    //无操作类型
    ETTBACKOPERATIONSTATENONE = 0,
    
    //将要开始
    ETTBACKOPERATIONSTATEWILLBEGAIN ,
    //开始执行
    ETTBACKOPERATIONSTATESTART,
   
    //完成
    ETTBACKOPERATIONSTATECOMPLETE,
    //失败
    ETTBACKOPERATIONSTATEFAILURE,
    
    //结束
    ETTBACKOPERATIONSTATEEND,
};



/**
 Description 需要恢复的动作状态
 */
typedef NS_ENUM(NSInteger,ETTCommandType)
{
    //无操作类型
    ETTCOMMANDTYPENONE = 0,
    //试卷
    ETTCOMMANDTYPEPAPER ,
    //课件
    ETTCOMMANDTYPECOURSEWARE,
    //白板
    ETTCOMMANDTYPEWHITEBOARD,
    
};

#endif /* ETTCoreEnum_h */
