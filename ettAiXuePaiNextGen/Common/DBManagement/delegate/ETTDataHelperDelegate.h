//
//  ETTDataHelperDelegate.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/11.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.4.12 10:30
 modifier : 康晓光
 version  ：Epic-0410-AIXUEPAIOS-1190
 branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
 problem  : v新客户端问题修复（清空本地缓存）
 describe : 数据表操作类代理
 */
/////////////////////////////////////////////////////
#ifndef ETTDataHelperDelegate_h
#define ETTDataHelperDelegate_h
#import <FMDB.h>

@protocol ETTDataHelperDelegate <NSObject>
@required
-(FMDatabase  *)pGetDatabase;
@optional


@end

#endif /* ETTDataHelperDelegate_h */
