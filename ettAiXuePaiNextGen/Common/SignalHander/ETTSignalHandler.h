//
//  ETTSignalHandler.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/3/20.
//  Copyright © 2017年 Etiantian. All rights reserved.
//
////////////////////////////////////////////////////////
/*
 new      : ADD
<<<<<<< HEAD
 time     : 2017.3.27  14:45
 modifier : 康晓光
 version  ：bugfix/Epic-0327-AIXUEPAIOS-1140
 branch   ：bugfix/Epic-0327-AIXUEPAIOS-1140／AIXUEPAIOS-0327-984
=======
 time     : 2017.3.30  12:04
 modifier : 康晓光
 version  ：bugfix/Epic-0322-AIXUEPAIOS-1124
 branch   ：bugfix/Epic-0322-AIXUEPAIOS-1124／AIXUEPAIOS-0322-984
>>>>>>> hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 describe : 系统崩溃信号量捕获
 */

/////////////////////////////////////////////////////
#import <Foundation/Foundation.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>
@interface ETTSignalHandler : NSObject
+(instancetype)Instance;
//注册捕获信号的方法
+ (void)RegisterSignalHandler;
-(void)HandleException:(NSException *)exception;
@end
