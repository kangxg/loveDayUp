
//  main.m
//  ettAiXuePaiNextGen
//
//  Created by zhaiyingwei on 16/9/13.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ETTSignalHandler.h"
int main(int argc, char * argv[]) {
    @autoreleasepool {
        ////////////////////////////////////////////////////////
        /*
        new      : ADD
        time     : 2017.3.30  12:04
        modifier : 康晓光
        version  ：bugfix/Epic-0322-AIXUEPAIOS-1124
        branch   ：bugfix/Epic-0322-AIXUEPAIOS-1124／AIXUEPAIOS-0322-984
        describe : 系统异常崩溃类型 redis 连接完成发送消息
         */
        [ETTSignalHandler RegisterSignalHandler];
        /////////////////////////////////////////////////////
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
