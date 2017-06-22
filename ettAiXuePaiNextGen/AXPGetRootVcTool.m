//
//  AXPGetRootVcTool.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/12/7.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPGetRootVcTool.h"

@implementation AXPGetRootVcTool

+(ETTSideNavigationViewController *)getCurrentWindowRootViewController
{
    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    ETTSideNavigationViewController *rootVc = (ETTSideNavigationViewController *)appDele.window.rootViewController;
    
    return rootVc;
}

@end
