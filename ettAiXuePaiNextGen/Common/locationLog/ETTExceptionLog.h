//
//  ETTExceptionLog.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/3/21.
//  Copyright © 2017年 Etiantian. All rights reserved.
//
////////////////////////////////////////////////////////
/*
 new      : ADD
 time     : 2017.3.27  14:26
 modifier : 康晓光
 version  ：bugfix/Epic-0327-AIXUEPAIOS-1140
 branch   ：bugfix/Epic-0327-AIXUEPAIOS-1140／AIXUEPAIOS-0327-984
 describe : 将捕获到崩溃信息 写入到本地日志
 */

/////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface ETTExceptionLog : NSObject

-(void)writeFile:(NSException *)exception;

-(BOOL)createLogFile:(NSString *)fileName;
-(void)deleteLogFile:(NSString *)fileName;
@end
