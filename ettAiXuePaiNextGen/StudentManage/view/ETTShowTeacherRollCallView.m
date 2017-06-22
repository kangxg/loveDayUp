//
//  ETTShowTeacherRollCallView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/22.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTShowTeacherRollCallView.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>
#import "ETTClassUserModel.h"
@interface   ETTShowTeacherRollCallView()

@property (nonatomic,retain ) UIButton       * MVCloseBtn;

@property (nonatomic,retain ) UIButton       * MVEnterBtn;
@property (nonatomic,retain ) NSArray        * MVModelArr;
@property (nonatomic,retain ) UIButton       * MVRewardBtn;
@property (nonatomic,retain ) UIImageView    * MVUserHeaderView;

@property (nonatomic,retain ) NSTimer        * MVTimer;
@property (assign, nonatomic) NSInteger      MVActionIndex;
@property (nonatomic,retain ) NSMutableArray * MVImageArr;
@property (nonatomic,retain)UILabel          *  MVUserNameLabel;

@end

@implementation ETTShowTeacherRollCallView
-(id)initWithFrame:(CGRect)frame withModelList:(NSArray *)arr
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        _MVModelArr = arr;
        [self initImageArr];
        [self createCloseView];
        [self createHeaderView];
   
        [self createRewareBtn];

        [self createUserNameLabel];
        [self createActionView];
        [self.MVEnterBtn  sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    return self;
}
-(void)initImageArr
{
    if (_MVImageArr == nil)
    {
        _MVImageArr = [[NSMutableArray alloc]init];
    }
    for (ETTClassUserModel * model in _MVModelArr)
    {
        [self.MVUserHeaderView sd_setImageWithURL:[NSURL URLWithString:model.userPhoto] placeholderImage:[UIImage imageNamed:@"user_defalt"]];
        
    }
}

-(void)beginGifAnimation
{
   
    //开始播放动画
    [self.MVRewardBtn.imageView startAnimating];
    
  
}

-(void)showView
{
    [super showView];
}

-(void)closeView
{
    [_MVTimer invalidate];
    NSDictionary * dic = @{@"show":@(NO)};
    [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDROLLCALL withInfo:dic];
    [super closeView];
}
-(void)beginAction
{
    if (_MVModelArr.count>1)
    {
        if (_MVTimer == nil || _MVTimer.isValid)
        {
            _MVTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(responderAction) userInfo:nil repeats:YES];
        }
        else
        {
            [_MVTimer setFireDate:[NSDate date]];
        }
        
    }
    else if(_MVModelArr.count == 1)
    {
        ETTClassUserModel * model = _MVModelArr[_MVActionIndex];
         _MVUserNameLabel.text = model.userName;
        self.MVEnterBtn.selected = YES;
    }
    else
    {
        
    }
    if (_MVRewardBtn)
    {
        _MVRewardBtn.hidden = YES;
    }
    _MVUserNameLabel.hidden = false;
}

-(void)responderAction
{
    _MVActionIndex             = arc4random() %(_MVModelArr.count);
    ETTClassUserModel * model  = _MVModelArr[_MVActionIndex];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    UIImage *cachedImage       = [manager.imageCache imageFromDiskCacheForKey:model.userPhoto];
    if (cachedImage)
    {
        self.MVUserHeaderView.image = cachedImage;
    }
    else
    {
        NSURL * url = [NSURL URLWithString:model.userPhoto] ;
        [self.MVUserHeaderView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_defalt"]];
    }
    _MVUserNameLabel.text = model.userName;
    
}
-(void)stopAction
{
    if (_MVTimer)
    {
        [_MVTimer setFireDate:[NSDate distantFuture]];
    }
    ETTClassUserModel * model = _MVModelArr[_MVActionIndex];
    model.rollCallCount ++;
    if (_MVRewardBtn)
    {
        _MVRewardBtn.hidden = false;
        [self beginGifAnimation];
    }
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenFunctionOperation:withCommandType:withInfo:)]) {
        NSDate *date                = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
        NSNumber *eventTime         = [NSNumber numberWithInteger:timeInterval];
        NSDictionary * dic = @{@"jid":model.jid,@"show":@(YES),@"eventTime":eventTime};
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDROLLCALL withInfo:dic];
    }
    
}
-(void)createHeaderView
{
    [self addSubview:self.MVUserHeaderView];
}
-(void)createCloseView
{
    [self addSubview:self.MVCloseBtn];
}

-(void)createActionView
{
    [self addSubview:self.MVEnterBtn];
}
-(UIButton * )MVCloseBtn
{
    if (_MVCloseBtn == nil)
    {
        _MVCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MVCloseBtn setImage:[UIImage imageNamed:@"socre_close_default"] forState:UIControlStateNormal];
        [_MVCloseBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MVCloseBtn;
}
-(void)createRewareBtn
{
    if (_MVRewardBtn == nil)
    {
        _MVRewardBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        _MVRewardBtn.layer.masksToBounds = YES;
        _MVRewardBtn.layer.cornerRadius  = 140;
        [_MVRewardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _MVRewardBtn.titleLabel.font     = [UIFont systemFontOfSize:16.0f];
        [_MVRewardBtn addTarget:self action:@selector(RewardBtnHandle) forControlEvents:UIControlEventTouchUpInside];
        _MVRewardBtn.hidden              = YES;
        [self addSubview:_MVRewardBtn];
        
        [_MVRewardBtn setImage:[UIImage imageNamed:@"rc_30"] forState:UIControlStateNormal];
        
        
        NSMutableArray *imgArray = [NSMutableArray array];
        
        for (int i = 1; i<31; i++)
        {
            UIImage  * image = [UIImage imageNamed:[NSString stringWithFormat:@"rc_%d",i]];
            [imgArray addObject:image];
        }
        
        _MVRewardBtn.imageView.animationImages   = imgArray;
        //设置执行一次完整动画的时长
        _MVRewardBtn.imageView.animationDuration = 1.5;
        //动画重复次数 （0为重复播放）
        _MVRewardBtn.imageView.animationRepeatCount = 1;

    }
    
}

-(void)RewardBtnHandle
{
    ETTClassUserModel * model = _MVModelArr[_MVActionIndex];
    model.rewardScore ++;
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenFunctionOperation:withCommandType:withInfo:)])
    {
        NSDate *date                = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
        NSNumber *eventTime         = [NSNumber numberWithInteger:timeInterval];
        NSDictionary * dic = @{@"jid":model.jid,@"name":model.userName,@"eventTime":eventTime};
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDREWARD withInfo:dic];
    }
}
-(UIButton * )MVEnterBtn
{
    if (_MVEnterBtn == nil)
    {
        _MVEnterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_MVEnterBtn setTitle:@"点名" forState:UIControlStateNormal];
        [_MVEnterBtn setTitle:@"结束" forState:UIControlStateSelected];
        [_MVEnterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _MVEnterBtn.titleLabel.font = [UIFont systemFontOfSize:24.0f];
        [_MVEnterBtn setBackgroundImage:[UIImage imageNamed:@"manage_button_roolcall"] forState:UIControlStateNormal];
        [_MVEnterBtn addTarget:self action:@selector(enterBtnHandle) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _MVEnterBtn;
}



-(UIImageView *)MVUserHeaderView
{
    if (_MVUserHeaderView == nil)
    {
        _MVUserHeaderView                     = [[UIImageView alloc]init];
        _MVUserHeaderView.layer.masksToBounds = YES;
        _MVUserHeaderView.layer.cornerRadius  = 140;
        _MVUserHeaderView.layer.borderWidth   = 3;
        _MVUserHeaderView.layer.borderColor   = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:26.0/255].CGColor;
        _MVUserHeaderView.image               = [UIImage imageNamed:@"user_defalt"];
        
    }
    return _MVUserHeaderView;
}
-(void)createUserNameLabel
{
    [self addSubview:self.MVUserNameLabel];
}


-(UILabel *)MVUserNameLabel
{
    if (_MVUserNameLabel == nil)
    {
        _MVUserNameLabel           = [[UILabel alloc]init];
        _MVUserNameLabel.textColor = kAXPTEXTCOLORf1;
        _MVUserNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _MVUserNameLabel;
}
-(void)enterBtnHandle
{
    _MVEnterBtn.selected = !_MVEnterBtn.selected;
    if (_MVEnterBtn.selected)
    {
        NSDictionary * dic = @{@"show":@(NO)};
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDROLLCALL withInfo:dic];

        [self beginAction];
    }
    else
    {
        
        [self stopAction];
        [self beginGifAnimation];
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _MVCloseBtn.frame       = CGRectMake(kWIDTH - 48 - 18, 75, 48, 48);
    _MVUserHeaderView.frame = CGRectMake((self.width-280)/2, self.height-204-280-64, 280, 280);
    _MVUserNameLabel.frame  = CGRectMake((self.width-280)/2, _MVUserHeaderView.v_bottom+20, 280, 20);
    _MVRewardBtn.frame      = _MVUserHeaderView.frame ;
    _MVEnterBtn.frame       = CGRectMake((self.width - 200)/2, self.height-177, 200, 97);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
