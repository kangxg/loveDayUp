//
//  ETTResponderView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTResponderView.h"
#import <ImageIO/ImageIO.h>
#import "AXPUserInformation.h"
#import "ETTRedisBasisManager.h"

@interface ETTResponderView()
{
    NSTimer * _mTimer;
    
    NSTimeInterval  _beginTime;
}
@property (nonatomic,retain)UIImageView * MVimageBalloonView;
@property (assign, nonatomic) NSInteger ProcessingIndex;
@end
@implementation ETTResponderView
@synthesize YVTapButton = _YVTapButton;
-(void)initData
{
    self.YVType = ETTRESPONDERVIEW;
    [self updateAttribute];
}

-(void)updateAttribute
{
    NSTimeInterval beginTime = [[NSDate new]timeIntervalSince1970];
    _beginTime = beginTime;
}

-(void)createImageView
{
    [super createImageView];
    self.YVRemindImageView.image = [UIImage imageNamed:@"responder"];
    self.YVRemindImageView.hidden = YES;
    [self addSubview:self.MVimageBalloonView];
    
}
-(void)createLableView
{
    [super createLableView];
    self.YVRemindlable.text = @"抢";
    self.YVRemindlable.textColor = [UIColor colorWithHexString:@"F2B922"];
    self.YVRemindlable.textAlignment = NSTextAlignmentCenter;
    [self.YVRemindlable sizeToFit];
}

-(void)beginAnimated
{
      [_mTimer invalidate];
    _mTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(action:) userInfo:nil repeats:YES];

}
-(void)action:(id)sender
{
    if (_ProcessingIndex>4) {
        
        _ProcessingIndex = 1;
    }
    else
    {
        [self setProcessingIndex:1];
    }
}
-(void)removeRemindview
{
    [_mTimer invalidate];
    [super removeRemindview];
}
- (void)setProcessingIndex:(NSInteger)processingIndex
{
    _ProcessingIndex = _ProcessingIndex +processingIndex;
    [self update];
}
-(void)update
{
    UIImage *imageBalloon;
    if(_ProcessingIndex < 5)
    {
        UIView *subviews  = [self  viewWithTag:1200];
        [subviews removeFromSuperview];
        
        NSLog(@"%li", (long)_ProcessingIndex);
        NSURL *BalloonGifRUL = [[NSBundle mainBundle] URLForResource:@"responder" withExtension:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfURL:BalloonGifRUL];
        CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)gifData, NULL);
        CGImageRef img;
        img = CGImageSourceCreateImageAtIndex(src, _ProcessingIndex/4.0, NULL);
        imageBalloon = [UIImage imageWithCGImage:img];
        
        CGImageRelease(img);
        CFRelease(src);
      
        _MVimageBalloonView = [[UIImageView alloc] initWithImage:imageBalloon];
        _MVimageBalloonView.tag = 1200;
//        _MVimageBalloonView.transform =  CGAffineTransformMakeScale(0.33, 0.33);
        _MVimageBalloonView.center =CGPointMake(self.width/2, self.height/2);
        [self addSubview:_MVimageBalloonView];
    }
}
-(void)createButtonView
{
    [super createButtonView];
    [self addSubview:self.YVTapButton];
    [self bringSubviewToFront:self.delBtn];
}

-(UIButton *)YVTapButton
{
    if (_YVTapButton == nil)
    {
        _YVTapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_YVTapButton addTarget:self action:@selector(tapBtnCallBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _YVTapButton;
}

///点击抢答确定按钮！
-(void)tapBtnCallBack
{
    [self publishResponderMessage];
    [self removeView];
//     [_mTimer invalidate];
//     [_MVimageBalloonView removeFromSuperview];
//     _MVimageBalloonView = nil;
//     self.YVRemindImageView.hidden = false;
//    self.YVRemindlable.text = @"已抢完";
//    self.YVRemindlable.textColor = [UIColor colorWithHexString:@"999999"];
//    [self.YVRemindlable sizeToFit];

}

-(void)publishResponderMessage
{
    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    NSString *classroomChannle = [NSString stringWithFormat:@"%@%@",userInformation.classroomId,kPCI_CLASSROOM_CHANNEL];
    NSTimeInterval timeDifference = [[NSDate new]timeIntervalSince1970]-_beginTime;
    NSString *timeDifferenceStr = [NSString stringWithFormat:@"%lf",timeDifference];
    NSDictionary *messageDic = @{@"jid":userInformation.jid,
                                 @"userName":userInformation.userName,
                                 @"userPhoto":userInformation.userPhoto,
                                 @"time":timeDifferenceStr};
    
    NSDictionary *channelDic = @{@"mid":[NSString stringWithFormat:@"%@_IOS",[ETTRedisBasisManager getTime]],
                                 @"time":[ETTRedisBasisManager getTime],
                                 @"from":userInformation.jid,
                                 @"to":@"XMAN",
                                 @"type":@"SMA_07",
                                 @"userInfo":messageDic};
    NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:channelDic];
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    [redisManager publishMessageToChannel:classroomChannle message:messageJSON respondHandler:^(id value, id error) {
        if (!error) {
            NSLog(@"成功提交抢答信息！");
            [ETTUSERDefaultManager setExecutedMid:[ETTUSERDefaultManager getCurrentMA07Mid]];
        }else{
            NSLog(@"提交抢答信息失败！");
        }
    }];
}

-(void)animatedAgain
{
//    [_mTimer invalidate];
//    self.YVRemindImageView.hidden = YES;
//    _mTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(action:) userInfo:nil repeats:YES];
}
-(UIImageView *)MVimageBalloonView
{
    if (_MVimageBalloonView == nil)
    {
        NSURL *BalloonGifRUL = [[NSBundle mainBundle] URLForResource:@"responder" withExtension:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfURL:BalloonGifRUL];
        CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)gifData, NULL);
        CGImageRef img = CGImageSourceCreateImageAtIndex(src, 1, NULL);
        UIImage *imageBalloon = [UIImage imageWithCGImage:img];
        CGImageRelease(img);
        CFRelease(src);
        _MVimageBalloonView = [[UIImageView alloc] initWithImage:imageBalloon];
        _MVimageBalloonView.tag = 1200;
//        _MVimageBalloonView.transform =  CGAffineTransformMakeScale(0.33, 0.33);
            _MVimageBalloonView.center = CGPointMake(self.width/2, self.height/2);
        ;
    }
    return _MVimageBalloonView;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2, (self.height -self.YVRemindImageView.image.size.height)/2, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
    _YVTapButton.frame =self.YVRemindImageView.frame;
    self.YVRemindlable.frame = CGRectMake(0, self.height-164, self.width, self.YVRemindlable.height);

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
