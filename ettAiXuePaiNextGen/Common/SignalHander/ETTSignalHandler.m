//
//  ETTSignalHandler.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/3/20.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTSignalHandler.h"
#import <UIKit/UIKit.h>
#import "ETTExceptionLog.h"
#import "AvoidCrash.h"
#import "ETTReconnectionBackgroundView.h"
//当前处理的异常个数
volatile int32_t UncaughtExceptionCount = 0;
//最大能够处理的异常个数
volatile int32_t UncaughtExceptionMaximum = 10;
//捕获信号后的回调函数
void HandleException(int signo)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signo] forKey:@"signal"];
    
    //创建一个OC异常对象
    NSException *ex = [NSException exceptionWithName:@"SignalExceptionName" reason:[NSString stringWithFormat:@"Signal %d was raised.\n",signo] userInfo:userInfo];
    
    //处理异常消息
    [[ETTSignalHandler Instance] performSelectorOnMainThread:@selector(HandleException:) withObject:ex waitUntilDone:YES];
}

@interface ETTSignalHandler()
@property (nonatomic,retain)ETTExceptionLog *  MDLogModel;
@end
@implementation ETTSignalHandler
static  ETTSignalHandler *s_SignalHandler =  nil;

+(instancetype)Instance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (s_SignalHandler == nil) {
            s_SignalHandler  =  [[ETTSignalHandler alloc] init];
        }
    });
    
    return s_SignalHandler;
}
-(id)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(processingTasksCompleted:) name:ETTREDISCONNECTFINISH object:nil];
        _MDLogModel = [[ETTExceptionLog alloc]init];
       
    }
    return self;
}


+ (void)RegisterSignalHandler
{

#ifdef  OPENTHESINGNALCAPTURE
    /*
>>>>>>> hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
    //注册程序由于abort()函数调用发生的程序中止信号
    signal(SIGABRT, HandleException);
    
    //注册程序由于非法指令产生的程序中止信号
    signal(SIGILL, HandleException);
    
    //注册程序由于无效内存的引用导致的程序中止信号
    signal(SIGSEGV, HandleException);
    
    //注册程序由于浮点数异常导致的程序中止信号
    signal(SIGFPE, HandleException);
    
    //注册程序由于内存地址未对齐导致的程序中止信号
    signal(SIGBUS, HandleException);

    */
    //程序通过端口发送消息失败导致的程序中止信号
    signal(SIGPIPE, HandleException);
     [AvoidCrash becomeEffective];
#endif
   
}
BOOL isDismissed = NO;
-(void)HandleException:(NSException *)exception
{
    isDismissed = YES;
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    


    if (_MDLogModel)
    {
        [_MDLogModel writeFile:exception];
    }
    [self informationProcessingCollapse:exception];
  
    //当接收到异常处理消息时，让程序开始runloop，防止程序死亡
    while (isDismissed)
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    //当点击弹出视图的Cancel按钮哦,isDimissed ＝ YES,上边的循环跳出
    CFRelease(allModes);
    NSSetUncaughtExceptionHandler(NULL);
   /*
        
   
    signal(SIGILL,   SIG_IGN);
    signal(SIGSEGV,  SIG_IGN);
    signal(SIGFPE,   SIG_IGN);
    signal(SIGBUS,   SIG_IGN);
    signal(SIGPIPE,  SIG_IGN);
    
    signal(SIGABRT, SIG_DFL);

    
    signal(SIGABRT ,  SIG_DFL);
    signal(SIGILL  ,  SIG_DFL);
    signal(SIGSEGV ,  SIG_DFL);
    signal(SIGFPE  ,  SIG_DFL);
    signal(SIGBUS  ,  SIG_DFL);
    */

    

    signal(SIGPIPE ,  SIG_DFL);
    
    
}
-(void)processingTasksCompleted:(NSNotification *)notify
{
    if (isDismissed)
    {
        [self deleteCollapseWaitingView];
        isDismissed = false;
       
    }
}
-(void)informationProcessingCollapse:(NSException *)exception
{
    if (exception)
    {
        NSDictionary  * dic = exception.userInfo;
        if (dic == nil)
        {
            return;
        }

        if ([[dic allKeys] containsObject:@"signal"])
        {
            switch ([[dic valueForKey:@"signal"]integerValue])
            {
                case SIGPIPE:
                {
                    [self createCollapseWaitingView];
                    [[NSNotificationCenter defaultCenter]postNotificationName:ETTSIGPIPECOLLAPSE object:nil];
                }
                    break;
                    
                default:
                {
                    [[iToast makeText:@"你的应用罢工了！"]show];
                }
                    break;
            }
        }
        /*
        NSArray *callStack = [exception callStackSymbols];
        NSArray * returnAddresses  = [exception callStackReturnAddresses];
        NSString *reason = [exception reason];
        NSString *name = [exception name];
        NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@\ncallStackReturnAddresses:%@\n",name,reason,[callStack componentsJoinedByString:@"\n"],[returnAddresses componentsJoinedByString:@"\n"]];
       
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"程序出现问题啦" message:content delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alertView show];
        
        alertView = nil;
         */
    }

}

-(void)createCollapseWaitingView
{
    ETCollapseTaskWaitingView * lastview = (ETCollapseTaskWaitingView *)objc_getAssociatedObject(self, ETTCOLLAPSEDEALTASKWAITING);
    if (lastview)
    {
        [lastview removeRemindview];
        
    }
    
     ETCollapseTaskWaitingView * view =  [[ETCollapseTaskWaitingView alloc]initRemindView:nil];
     objc_setAssociatedObject(self, ETTCOLLAPSEDEALTASKWAITING, view, OBJC_ASSOCIATION_ASSIGN);
    
}

-(void)deleteCollapseWaitingView
{
    ETCollapseTaskWaitingView * lastview = (ETCollapseTaskWaitingView *)objc_getAssociatedObject(self, ETTCOLLAPSEDEALTASKWAITING);
    if (lastview)
    {
        [lastview removeRemindview];
        
    }
    objc_setAssociatedObject(self, ETTCOLLAPSEDEALTASKWAITING, nil, OBJC_ASSOCIATION_ASSIGN);
}
- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    //因为这个弹出视图只有一个Cancel按钮，所以直接进行修改isDimsmissed这个变量了
    isDismissed = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"houtaibengkui" object:nil];
}


@end
