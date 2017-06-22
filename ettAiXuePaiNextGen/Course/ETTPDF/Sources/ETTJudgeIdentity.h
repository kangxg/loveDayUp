//
//  ETTJudgeIdentity.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ETTSideNavigationViewController.h"
#import "ETTLoginViewController.h"


@interface ETTJudgeIdentity : NSObject

+ (ETTSideNavigationViewIdentity)getCurrentIdentity;

+ (ETTSideNavigationViewController *)getSideNavigationViewController;

@end
