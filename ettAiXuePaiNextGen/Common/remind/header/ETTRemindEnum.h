//
//  ETTRemindEnum.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#ifndef ETTRemindEnum_h
#define ETTRemindEnum_h

typedef NS_ENUM(NSInteger,ETTRemindViewType)
{
   ETTREMINDVIEWNONE = 0x00000,
    //锁屏
   ETTLOCKSCREEViEW,
     //奖励
   ETTREWARDSVIEW,
    //提醒
   ETTREMINDVIEW,
     //点名
   ETTROLLCALLVIEW,
     //抢答
   ETTRESPONDERVIEW,
    //集体奖励
   ETTGROUPREWARDSVIEW,
   ////////////////////////////////////////////////////////
   /*
     new      : add
     time     : 2017.3.27  18:30
     modifier : 康晓光
     version  ：Epic_0322_AIXUEPAIOS-1124
     branch   ：Epic_0322_AIXUEPAIOS-1124／AIXUEPAIOS-1148
     describe : 老师的点击的提醒动画的枚举类型
    */

   //  老师点击提醒
   ETTREMINDFORTEACHERVIEW,
   ////////////////////////////////////////////////////////

    
};


typedef NS_ENUM(NSInteger,ETTCharAnimationViewType)
{
    ETTCHARANIMATIONVIEWNONE = 0x00000,
   
    //奖励自己
    ETTCHARANIMATIONREWAREMINE,
    //奖励他人
    ETTCHARANIMATIONREWAREOTHER,
    //组奖励
    ETTCHARANIMATIONREWAREGROUP,
  
    
    
};
#endif /* ETTRemindEnum_h */
