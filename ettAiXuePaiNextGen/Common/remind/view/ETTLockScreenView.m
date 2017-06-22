//
//  ETTLockScreenView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTLockScreenView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIColor+RGBColor.h"
@implementation ETTLockScreenView
-(void)initData
{
    self.YVType = ETTLOCKSCREEViEW;
}

-(void)createImageView
{
    [super createImageView];
    self.YVRemindImageView.image = [UIImage imageNamed:@"lockScree"];
    
}

-(void)createLableView
{
    [super createLableView];
    self.YVRemindlable.text = @"锁屏";
    self.YVRemindlable.textColor = [UIColor colorWithHexString:@"F2B922"];
    [self.YVRemindlable sizeToFit];
}
-(void)beginAnimated
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


-(void)deblockingRemindView
{
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.7  16:40
     modifier : 康晓光
     version  ：Dev-0224
     branch   ：1043
     describe : 将新疆成都老客户端xinjiangHIRedis0305 分支上代码优化move到Dev-0224上的工作任务 防止在分线程上操作UI
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeRemindview];
    });
    /////////////////////////////////////////////////////
   
    
}
-(void)removeRemindview
{
    
     AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    [super removeRemindview];
}
-(void)animatedAgain
{

    //[self animatedAgain];

//    AudioServicesPlaySystemSound(1008);
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2, (self.height -self.YVRemindImageView.image.size.height)/2, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
    self.YVRemindlable.frame = CGRectMake((self.width-self.YVRemindlable.width)/2,self.height-164, self.YVRemindlable.width, self.YVRemindlable.height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
