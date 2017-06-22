//
//  ETTReconnectionBackgroundView.m
//  ettAiXuePaiNextGen
//
//
//                          _oo8oo_
//                         o8888888o
//                         88" . "88
//                         (| -_- |)
//                         0\  =  /0
//                       ___/'==='\___
//                     .' \\|     |// '.
//                    / \\|||  :  |||// \
//                   / _||||| -:- |||||_ \
//                  |   | \\\  -  /// |   |
//                  | \_|  ''\---/''  |_/ |
//                  \  .-\__  '-'  __/-.  /
//                ___'. .'  /--.--\  '. .'___
//             ."" '<  '.___\_<|>_/___.'  >' "".
//            | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//            \  \ `-.   \_ __\ /__ _/   .-` /  /
//        =====`-.____`.___ \_____/ ___.`____.-`=====
//                          `=---=`
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                 佛祖镇楼   BUG辟易  永不修改
//       佛曰:
//                 写字楼里写字间，写字间里程序员；
//                 程序人员写程序，又拿程序换酒钱。
//                 酒醒只在网上坐，酒醉还来网下眠；
//                 酒醉酒醒日复日，网上网下年复年。
//                 但愿老死电脑间，不愿鞠躬老板前；
//                 奔驰宝马贵者趣，公交自行程序员。
//                 别人笑我忒疯癫，我笑自己命太贱；
//                 不见满街漂亮妹，哪个归得程序员？
//
//  Created by zhaiyingwei on 2016/12/8.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTReconnectionBackgroundView.h"

NSString * kBackgroundImageUrl = @"rectangle";

@interface ETTReconnectionBackgroundView ()

@property (nonatomic,retain)UIImageView * MVImageBalloonView;

@property (nonatomic,retain)UIButton    * MVRecClassBtn;

@property (nonatomic,retain)UIButton    * MVRecReloadBtn;


@end

@implementation ETTReconnectionBackgroundView
-(instancetype )initRemindView:(UIView *)superView
{
    if (superView == nil)
    {
        UIWindow *window = [[UIApplication sharedApplication]keyWindow];
        if (window == nil)
        {
            window =  [[[UIApplication sharedApplication] delegate] window];
        }
        self =   [super initRemindView:window];
        self.layer.zPosition = INT8_MAX;
    }
    else{
        CGRect frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        self = [self initRemindView:superView withFrame:frame];
        
      
    }
    self.userInteractionEnabled = YES;
    return self;

}

-(void)createLableView
{
    [super createLableView];
    self.YVRemindlable.font          = [UIFont systemFontOfSize:18];
    self.YVRemindlable.textColor     = [UIColor whiteColor];
    self.YVRemindlable.textAlignment = NSTextAlignmentCenter;
    self.YVRemindlable.text          = @"有未结束课程，请重新进入";
    self.YVRemindlable.frame         = CGRectMake((self.width-145)/2,-45, 145, 45);
}
-(void)createImageView
{
    [super createImageView];
 
    
    self.YVRemindImageView.image = [UIImage imageNamed:@"ReconnectWithTheClassroom_0"];
    self.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2, 194, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
}

-(void)createButtonView
{
    [self addSubview:self.MVRecClassBtn];
    [self addSubview:self.MVRecReloadBtn];
}

-(UIButton *)MVRecClassBtn
{
    if (_MVRecClassBtn == nil)
    {
        _MVRecClassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _MVRecClassBtn.layer.masksToBounds = YES;
        _MVRecClassBtn.layer.cornerRadius  = 5.0f;
        _MVRecClassBtn.layer.borderWidth   = 1.0f;
        _MVRecClassBtn.layer.borderColor   = kAXPMAINCOLORc1.CGColor;
        [_MVRecClassBtn setTitle:@"重建课堂" forState:UIControlStateNormal];
        [_MVRecClassBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _MVRecClassBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_MVRecClassBtn addTarget:self action:@selector(recClassbtnCallback) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _MVRecClassBtn;
}

-(UIButton *)MVRecReloadBtn
{
    if (_MVRecReloadBtn == nil)
    {
        _MVRecReloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _MVRecReloadBtn.layer.masksToBounds = YES;
        _MVRecReloadBtn.layer.cornerRadius  = 5.0f;
        _MVRecReloadBtn.layer.borderWidth   = 1.0f;
        _MVRecReloadBtn.layer.borderColor   = kAXPMAINCOLORc1.CGColor;
        [_MVRecReloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_MVRecReloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _MVRecReloadBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_MVRecReloadBtn addTarget:self action:@selector(recReloadbtnCallback) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MVRecReloadBtn;
}


///重建课堂
-(void)recClassbtnCallback
{
    NSLog(@"recClassbtnCallback!!!");
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenHandler:withCommandType:)])
    {
        [self.EVDelegate pEvenHandler:self withCommandType:1];
        [self removeFromSuperview];
    }
}
///重建加载
-(void)recReloadbtnCallback
{
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenHandler:withCommandType:)])
    {
        [self.EVDelegate pEvenHandler:self withCommandType:2];
        [self removeFromSuperview];
    }
}
-(void)beginAnimated
{
    [self beginGifAnimation];
}
-(void)beginGifAnimation
{
    NSMutableArray *imgArray = [NSMutableArray array];
    
    for (int i = 0; i<12; i++)
    {
        UIImage  * image = [UIImage imageNamed:[NSString stringWithFormat:@"ReconnectWithTheClassroom_%d",i]];
        [imgArray addObject:image];
    }
    
    self.YVRemindImageView.animationImages   = imgArray;
    //设置执行一次完整动画的时长
    self.YVRemindImageView.animationDuration = 0.5;
    //动画重复次数 （0为重复播放）
    self.YVRemindImageView.animationRepeatCount = 0;
    //开始播放动画
    [self.YVRemindImageView startAnimating];

}
-(void)animatedAgain
{
    
}

-(void)removeRemindview
{
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2, 0, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
    self.YVRemindlable.frame     = CGRectMake(0, self.YVRemindImageView.v_bottom, self.width, self.YVRemindlable.height);
    _MVRecClassBtn.frame         = CGRectMake((self.width - 400)/2-40, self.YVRemindlable.v_bottom+20, 200, 44);

    _MVRecReloadBtn.frame        = CGRectMake(_MVRecClassBtn.v_right+40, self.YVRemindlable.v_bottom+20, 200, 44);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchsBegin!!");
}

@end

@implementation ETCollapseTaskWaitingView
-(void)createLableView
{
    [super createLableView];
    self.YVRemindlable.text          = @"正在进入课堂...";
    self.YVRemindlable.frame         = CGRectMake(0,-45, self.width, 45);
}
-(void)createButtonView
{
    
}

-(void)removeRemindview
{
    [self removeFromSuperview];
    
}

@end
