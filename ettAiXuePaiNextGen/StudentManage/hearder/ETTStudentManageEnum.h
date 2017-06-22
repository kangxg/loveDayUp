//
//  ETTStudentManageEnum.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#ifndef ETTStudentManageEnum_h
#define ETTStudentManageEnum_h
typedef NS_ENUM(NSInteger,ETTClassType)
{
    ETTCLASSTYPENONE = 0x00000,
    //在线
    ETTCLASSTYPEONLINE,
    //旁听
    ETTCLASSTYPEATTEND,
    //创建的班级
    ETTCLASSESTABLISH,
    
    //抢答
    ETTCLASSRESPONDER,
  
    
};

typedef NS_ENUM(NSInteger,ETTTeacherCommandType)
{
    ETTTEACHERMOMMANDNONE = 0x00000,
    //锁屏
    ETTTEACHERMOMMANDLOCKSCREEN,
     //点名
    ETTTEACHERMOMMANDROLLCALL,
     //分组
    ETTTEACHERMOMMANDGROUP,
     //投屏
    ETTTEACHERMOMMANDTV,
    //抢答
    ETTTEACHERMOMMANDREPONDER,
    //切换展示
    ETTTEACHERMOMMANDCHANGESHOWLIST,
    //展示用户信息
    ETTTEACHERMOMMANDSHOWUERINFO,
    
    //奖励
    ETTTEACHERMOMMANDREWARD,
    
    //组奖励
    ETTTEACHERMOMMANDREWARDGROUP,
    //提醒
    ETTTEACHERMOMMANDREMIND,
    //查看学生
    ETTTEACHERMOMMANDLOOKSTU,
    
    //用户详情
    ETTTEACHERMOMMANDUSERDETAILS,
    //老师推送课件
    ETTTEACHERMOMMANDPUSHFILES,
    //老师结束推送课件
    ETTTEACHERMOMMANDENDPUSHFILES,
    //下拉刷新view
    ETTTEACHERMOMMANDENDREFRESHVIEW,
    
    
};
typedef NS_ENUM(NSInteger,ETTVCTRCommandType)
{
    ETTVCTROMMANDTYPENONE,
    ETTVCTROMMANDTYPECLOSE,
};


#endif /* ETTStudentManageEnum_h */
