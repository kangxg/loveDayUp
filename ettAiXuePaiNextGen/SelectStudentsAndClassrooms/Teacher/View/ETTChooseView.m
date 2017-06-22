//
//  ETTChooseView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/3/17.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTChooseView.h"
#import <CoreLocation/CoreLocation.h>
@implementation ETTChooseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)checkLoactionServeropen
{
    CLAuthorizationStatus type = [CLLocationManager authorizationStatus];
    if (![CLLocationManager locationServicesEnabled] || type == kCLAuthorizationStatusDenied)
    {
        UIAlertView * alwe= [[UIAlertView alloc]initWithTitle:ETTLocationServerAlertTitle  message:ETTLocationServerAlertMsg delegate:self cancelButtonTitle:ETTLocationServerAlertCancelTitle otherButtonTitles:ETTLocationServerAlertEnterTitle, nil];
        
        [alwe show];
    }
    else
    {
        
        [self enterChoose];
    }

}

/**
 Description 子类处理
 */
-(void)enterChoose
{
    
}

/**
 Description 跳转到设置里
 */
-(void)openMyAPPSetting
{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

/**
 Description  提醒视图回调
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {   //允许
        [self openMyAPPSetting];
    }
    
    
}
@end
