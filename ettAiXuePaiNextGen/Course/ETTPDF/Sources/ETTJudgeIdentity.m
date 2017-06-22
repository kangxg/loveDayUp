//
//  ETTJudgeIdentity.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTJudgeIdentity.h"

@implementation ETTJudgeIdentity

+ (ETTSideNavigationViewIdentity)getCurrentIdentity {
    //判断是老师还是学生身份
    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    ETTSideNavigationViewController *sideNav = (ETTSideNavigationViewController *)appDele.window.rootViewController;
    
    return sideNav.identity;
}

+ (ETTSideNavigationViewController *)getSideNavigationViewController {
    
    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    ETTSideNavigationViewController *sideNav = (ETTSideNavigationViewController *)appDele.window.rootViewController;
    
    return sideNav;
}

@end
