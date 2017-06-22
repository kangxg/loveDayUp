//
//  ETTBaseRemindView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseRemindView.h"
#import "ETTLockScreenView.h"
#import "ETTRewardsView.h"
#import "ETTRemindView.h"
#import "ETTRollCallView.h"
#import "ETTResponderView.h"
#import "UIColor+RGBColor.h"
#import "UIView+Frame.h"
#import "ETTRemindManager.h"
#import "ETTRemindForTeacherView.h"
@implementation ETTBaseRemindView
@synthesize YVType             = _YVType;
@synthesize YVRemindImageView  = _YVRemindImageView;
@synthesize YVDelegate         = _YVDelegate;
@dynamic  YVTapButton ;

+(id<ETTRemindViewInterface>)createRemindView:(ETTRemindViewType)ViewType withSuperView:(UIView *)superView
{
    ETTBaseRemindView * view = nil;
    
    switch (ViewType) {
        case ETTLOCKSCREEViEW:
        {
            view = [[ETTLockScreenView alloc]initRemindView:superView];
        }
            break;
        case ETTREWARDSVIEW:
        {
            view = [[ETTRewardsView alloc]initRemindView:superView];
            
        }
            break;
        case ETTREMINDVIEW:
        {
            view = [[ETTRemindView alloc]initRemindView:superView];
            
        }
            break;
        ////////////////////////////////////////////////////////
        /*
             new      : add
             time     : 2017.3.27  18:30
             modifier : 康晓光
             version  ：Epic_0322_AIXUEPAIOS-1124
             branch   ：Epic_0322_AIXUEPAIOS-1124／AIXUEPAIOS-1148
             describe : 老师的点击的提醒动画，没有文字提示和学生端端区别
        */
        case ETTREMINDFORTEACHERVIEW:
        {
            view = [[ETTRemindForTeacherView alloc]initRemindView:superView];
        }
            break;
        ////////////////////////////////////////////////////////
        
        case ETTROLLCALLVIEW:
        {
            view = [[ETTRollCallView alloc]initRemindView:superView];
            
        }
            break;
        case ETTRESPONDERVIEW:
        {
            view = [[ETTResponderView alloc]initRemindView:superView];
        }
            break;
        
        default:
            break;
    }
    
    return view;

}

-(instancetype)initRemindView:(UIView *)superView
{
    if (!superView)
    {
        return nil;
    }
    CGRect frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self = [self initRemindView:superView withFrame:frame];
    return self;
}
-(instancetype)initRemindView:(UIView *)superView withFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [superView addSubview:self];
        [self initData];
        [self createView];
        [self beginAnimated];
        
    }
    return self;
}
-(void)initData
{
    self.YVType = ETTREMINDVIEWNONE;
}
-(void)createView
{
    [self createBackGroundView];
    [self createImageView];
   
    [self createButtonView];
     [self createLableView];
    [self createOtherView];
    
}
-(void)beginAnimated
{
    
}
-(void)createBackGroundView
{
    
    self.backgroundColor =
    [[UIColor blackColor]colorWithAlphaComponent:0.3];
   
}
-(void)createImageView
{
    [self addSubview:self.YVRemindImageView];
}

-(void)createLableView
{
    [self addSubview:self.YVRemindlable];
    self.YVRemindlable.frame = CGRectMake((self.width-self.YVRemindlable.width)/2,self.height-164, self.YVRemindlable.width, self.YVRemindlable.height);
}

-(void)createButtonView
{
//    _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _delBtn.backgroundColor = [UIColor blueColor];
//   _delBtn.frame = CGRectMake(430, 60, 60, 30);
//    [self addSubview:_delBtn];
//    [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
//    [_delBtn addTarget:self action:@selector(removeView
//                                          ) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_delBtn];
}

-(void)removeView
{
    if (self.YVDelegate && [self.YVDelegate respondsToSelector:@selector(pRemoveRemindView)])
    {
        [self.YVDelegate pRemoveRemindView];
    }
   
}
-(void)createOtherView
{
    
}
-(void)deblockingRemindView
{
    
}
-(UIImageView *)YVRemindImageView
{
    if (_YVRemindImageView == nil)
    {
         _YVRemindImageView = [[UIImageView alloc]init];
    }
    return _YVRemindImageView;
}

-(UILabel *)YVRemindlable
{
    if (_YVRemindlable == nil)
    {
        _YVRemindlable = [[UILabel alloc]init];
        _YVRemindlable.font = [UIFont systemFontOfSize:40];
    }
    return _YVRemindlable;
}
-(void)removeRemindview
{
    [self removeFromSuperview];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
//    _YVRemindImageView.frame = CGRectMake((self.width - _YVRemindImageView.image.size.width)/2, (self.height - _YVRemindImageView.image.size.height)/2, _YVRemindImageView.image.size.width, _YVRemindImageView.image.size.height);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
