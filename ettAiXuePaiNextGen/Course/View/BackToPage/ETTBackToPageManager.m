//
//  ETTBackToPageManager.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBackToPageManager.h"
#import <UIKit/UIKit.h>
#import "AXPGetRootVcTool.h"

@implementation ETTBackToPageManager

-(void)startPushing
{
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];

    self.isPushing = YES;
    [self addBackPageViewToView:rootVc.view];
}

-(void)endPushing
{
    self.isPushing    = NO;
    [self.backPageView removeFromSuperview];
    self.backPageView = nil;
    self.pushingVc    = nil;
    self.selectedBtn  = nil;
    self.indexPath    = nil;
    self.coursewareUrl = nil;
}

+ (instancetype)sharedManager {
    
    static ETTBackToPageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}


- (void)addBackPageViewToView:(UIView *)view {

    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    if (!view) {
        view = rootVc.view;
    }
    
    if (!self.backPageView) {
    
        UIView *backPageView              = [[UIView alloc]init];
        self.backPageView                 = backPageView;
        self.backPageView.frame           = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44, [UIScreen mainScreen].bounds.size.width, 44);
        self.backPageView.backgroundColor = [UIColor yellowColor];
        UILabel *backLabel                = [[UILabel alloc]init];
        backLabel.text                    = @"返回推送页面";
        backLabel.backgroundColor         = [UIColor redColor];
        backLabel.frame                   = CGRectMake(0, 0, 120, 44);
        backLabel.textColor               = [UIColor whiteColor];
        backLabel.textAlignment           = NSTextAlignmentCenter;
        backLabel.centerX                 = self.backPageView.centerX;
        [self.backPageView addSubview:backLabel];

        UITapGestureRecognizer *tapGes    = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backPageViewAction:)];
        [self.backPageView addGestureRecognizer:tapGes];
    }
    
    [view addSubview:self.backPageView];
}

//点击返回推送页面action
- (void)backPageViewAction:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(backToTheNeedPage:)]) {
        [self.delegate backToTheNeedPage:tap];
    }
}


@end
