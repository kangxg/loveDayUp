//
//  ETTShowOnlineUserView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/22.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTShowOnlineUserView.h"
#import "ETTStudentManageEnum.h"
#import "ETTClassUserModel.h"
#import <UIImageView+WebCache.h>
#import "ETTRedisBasisManager.h"
#import "ETTRemindManager.h"
@interface ETTShowOnlineUserView()
@property (nonatomic,retain) UIImageView       * MVUserHeaderView;
@property (nonatomic,retain) UIImageView       * MVCloseImageView;
//奖励
@property (nonatomic,retain) UIButton          * MVRewardBtn;
@property (nonatomic,retain) UIButton          * MVRemindBtn;
@property (nonatomic,retain) UIButton          * MVLookBtn;
@property (nonatomic,retain) UIButton          * MVCloseBtn;
@property (nonatomic,retain) ETTClassUserModel * MVModel;
@property (nonatomic,retain) UILabel            *  MVUserNameLabel;
@end

@implementation ETTShowOnlineUserView
-(id)initWithFrame:(CGRect)frame withModel:(ETTClassUserModel *)model
{
    if (self = [super initWithFrame:frame])
    {
        _MVModel = model;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        [self createCloseView];
        [self createHeaderView];
        [self createUserNameLabel];
        [self createRewardView];
        [self createRemindView];
        [self createLookView];
    }
    
    return self;
}
-(void)showView
{
    [super showView];
}
-(void)createHeaderView
{
    [self addSubview:self.MVUserHeaderView];
}
-(void)createCloseView
{
    [self addSubview:self.MVCloseBtn];
    
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
        _MVUserNameLabel.textColor = [UIColor whiteColor];
        _MVUserNameLabel.font      = [UIFont systemFontOfSize:18.0f];
        _MVUserNameLabel.text      = _MVModel.userName;
        _MVUserNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _MVUserNameLabel;
}
-(void)createRewardView
{
     [self addSubview:self.MVRewardBtn];
}

-(void)createRemindView
{
    [self addSubview:self.MVRemindBtn];

}

-(void)createLookView
{
     [self addSubview:self.MVLookBtn];
}
-(UIImageView *)MVCloseImageView
{
    if (_MVCloseImageView == nil)
    {
        _MVCloseImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"socre_close_default"] ];
    }
    return _MVCloseImageView;
}
-(UIButton * )MVCloseBtn
{
    if (_MVCloseBtn == nil)
    {
        _MVCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_MVCloseBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [_MVCloseBtn setImage:[UIImage imageNamed:@"socre_close_default"] forState:UIControlStateNormal];

        
    }
    return _MVCloseBtn;
}
-(UIButton * )MVRemindBtn
{
    if (_MVRemindBtn == nil)
    {
        _MVRemindBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MVRemindBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _MVRemindBtn.backgroundColor     = kC1_T80_COLOR;
        _MVRemindBtn.layer.masksToBounds = YES;
        _MVRemindBtn.layer.cornerRadius  = 2;
        _MVRemindBtn.layer.borderWidth   = 1;
        _MVRemindBtn.layer.borderColor   = [[UIColor whiteColor] colorWithAlphaComponent:152.0/255].CGColor;
        [_MVRemindBtn setTitle:@"提醒" forState:UIControlStateNormal];
        [_MVRemindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _MVRemindBtn.titleLabel.font     = [UIFont systemFontOfSize:16.0f];
        [_MVRemindBtn addTarget:self action:@selector(RemindBtnHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MVRemindBtn;
}

-(UIButton * )MVRewardBtn
{
    if (_MVRewardBtn == nil)
    {
        _MVRewardBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MVRewardBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _MVRewardBtn.backgroundColor     = kC1_T80_COLOR;
        _MVRewardBtn.layer.masksToBounds = YES;
        _MVRewardBtn.layer.cornerRadius  = 2;
        _MVRewardBtn.layer.borderWidth   = 1;
        _MVRewardBtn.layer.borderColor   = [[UIColor colorWithHexString:@"ffffff"]colorWithAlphaComponent:152.0/255.0].CGColor;


        [_MVRewardBtn setTitle:@"奖励" forState:UIControlStateNormal];
        [_MVRewardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _MVRewardBtn.titleLabel.font    = [UIFont systemFontOfSize:16.0f];
        [_MVRewardBtn addTarget:self action:@selector(RewardBtnHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MVRewardBtn;
}

-(UIButton * )MVLookBtn
{
    if (_MVLookBtn == nil)
    {
        _MVLookBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MVLookBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _MVLookBtn.backgroundColor     = kC1_T80_COLOR;
        _MVLookBtn.layer.masksToBounds = YES;
        _MVLookBtn.layer.cornerRadius  = 2;
        _MVLookBtn.layer.borderWidth   = 1;
        _MVLookBtn.layer.borderColor   = [[UIColor whiteColor] colorWithAlphaComponent:152.0/255].CGColor;

        [_MVLookBtn setTitle:@"查看" forState:UIControlStateNormal];
        [_MVLookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _MVLookBtn.titleLabel.font     = [UIFont systemFontOfSize:16.0f];
        [_MVLookBtn addTarget:self action:@selector(lookBtnHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MVLookBtn;
}

-(UIImageView *)MVUserHeaderView
{
    if (_MVUserHeaderView == nil)
    {
        _MVUserHeaderView                     = [[UIImageView alloc]init];
        _MVUserHeaderView.layer.masksToBounds = YES;
        _MVUserHeaderView.layer.cornerRadius  = 140;
        _MVUserHeaderView.layer.borderWidth   = 2;
        _MVUserHeaderView.layer.borderColor   = [UIColor whiteColor].CGColor;
        NSString *userPhoto;
        if (isEmptyString(_MVModel.userPhoto)?@"":_MVModel.userPhoto) {
            if ([_MVModel.userPhoto rangeOfString:@"axpad_unknown"].location ==NSNotFound) {// 不是默认的图片
                NSMutableString *mutStr = _MVModel.userPhoto.mutableCopy;
                //http://attach.etiantian.com/ett20/study/common/upload/3079083_96611229.png
                NSString *subStr = [mutStr substringWithRange:NSMakeRange(0, mutStr.length - 4)];
                subStr = [subStr stringByAppendingString:@"_480_480.png"];
                //http://attach.etiantian.com/ett20/study/common/upload/3077891_91380009_480_480.png
//                NSData *imgDate = [NSData dataWithContentsOfURL:[NSURL URLWithString:subStr]];
    
                userPhoto = subStr;
//                if (imgDate.bytes > 0) {
//                    userPhoto = subStr;
//                }else{
//                    userPhoto = _MVModel.userPhoto;
//                }
            }
        }else{
            userPhoto = _MVModel.userPhoto;
        }
        
        
        [_MVUserHeaderView sd_setImageWithURL:[NSURL URLWithString:userPhoto] placeholderImage:[UIImage imageNamed:@"user_defalt"]];
    }
    return _MVUserHeaderView;
}
-(void)closeView
{
    [super closeView];
}

-(void)RemindBtnHandle
{
    
    _MVModel.remindCount ++;
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenFunctionOperation:withCommandType:withInfo:)])
    {
        NSDate *date                = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
        NSNumber *eventTime         = [NSNumber numberWithInteger:timeInterval];
        NSDictionary * dic = @{@"jid":_MVModel.jid,@"remindCount":@(_MVModel.remindCount),@"eventTime":eventTime};
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDREMIND withInfo:dic];
    }
    ////////////////////////////////////////////////////////
    /*
     new      : add
     time     : 2017.3.6  18:07
     modifier : 康晓光
     version  ：Epic_0322_AIXUEPAIOS-1124
     branch   ：Epic_0322_AIXUEPAIOS-1124／AIXUEPAIOS-1107
     describe : 教师的奖励、查看、提醒按钮没有动画效果！
     */
    [[ETTRemindManager shareRemindManager] createRemindView:ETTREMINDFORTEACHERVIEW];
    /////////////////////////////////////////////////////
    
}
-(void)RewardBtnHandle
{
//     _MVModel.rewardScore ++;
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenFunctionOperation:withCommandType:withInfo:)])
    {
        NSDate *date                = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
        NSNumber *eventTime         = [NSNumber numberWithInteger:timeInterval];
        NSDictionary * dic = @{@"jid":_MVModel.jid,@"name":_MVModel.userName,@"eventTime":eventTime};
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDREWARD withInfo:dic];
    }
    ////////////////////////////////////////////////////////
    /*
     new      : add
     time     : 2017.3.6  18:07
     modifier : 康晓光
     version  ：Epic_0322_AIXUEPAIOS-1124
     branch   ：Epic_0322_AIXUEPAIOS-1124／AIXUEPAIOS-1107
     describe : 教师的奖励、查看、提醒按钮没有动画效果！
     */
     [[ETTRemindManager shareRemindManager] createRemindView:ETTREWARDSVIEW];
    /////////////////////////////////////////////////////
   
}

-(void)lookBtnHandle
{
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenFunctionOperation:withCommandType:withInfo:)])
    {
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDLOOKSTU withInfo:_MVModel];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _MVCloseBtn.frame       = CGRectMake(kWIDTH - 48 - 18, 75, 48, 48);
    _MVUserHeaderView.frame = CGRectMake((self.width-280)/2, 160, 280, 280);
    _MVUserNameLabel.frame  = CGRectMake((self.width-280)/2, _MVUserHeaderView.v_bottom+40, 280, 20);
    _MVRewardBtn.frame      = CGRectMake((self.width -112*3-90)/2,kHEIGHT-175-44, 112, 44);
    _MVRemindBtn.frame      = CGRectMake(_MVRewardBtn.v_right+45, kHEIGHT-175-44, 112, 44);
    _MVLookBtn.frame        =   CGRectMake(_MVRemindBtn.v_right+45, kHEIGHT-175-44, 112, 44);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
