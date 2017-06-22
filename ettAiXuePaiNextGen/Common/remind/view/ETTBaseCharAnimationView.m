//
//  ETTBaseCharAnimationView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/1/10.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseCharAnimationView.h"
#import "ETTGroupRewardCharAnimationView.h"
#import "ETTSingleCharAnimationView.h"
#import "ETTRemindEnum.h"
#import "UIColor+RGBColor.h"
#import "UIView+Frame.h"
@implementation ETTBaseCharAnimationView

@synthesize EVType             = _EVType;

@synthesize EVDelegate         = _EVDelegate;

@synthesize EVAnimationCount   = _EVAnimationCount;
+(id<ETTCharAnimationInterface>)createAnimationView:(ETTCharAnimationViewType)ViewType withSuperView:(UIView *)superView info:(id)info
{
    ETTBaseCharAnimationView * view = nil;
    switch (ViewType) {
        case ETTCHARANIMATIONREWAREGROUP:
        {
            view = [[ETTGroupRewardCharAnimationView alloc]initAnimationView:superView info:info];
        }
            break;
        case ETTCHARANIMATIONREWAREOTHER:
        {
            view = [[ETTRewardSingleCharAnimationView alloc]initAnimationView:superView info:info];
            
        }
        break;
        case ETTCHARANIMATIONREWAREMINE:
        {
            view = [[ETTRewardSelfCharAnimationView alloc]initAnimationView:superView info:info];
        }
            break;
            default:
            break;
    }
    return view;
}

-(instancetype)initAnimationView:(UIView *)superView info:(id)info
{
    if (!superView)
    {
        return nil;
    }
    CGRect frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self = [self initAnimationView:superView withFrame:frame info:info];
    return self;

}

-(instancetype)initAnimationView:(UIView *)superView withFrame:(CGRect)frame info:(id)info
{
    if (self = [super initWithFrame:frame])
    {
        [superView addSubview:self];
        [self initData:info];
        [self createView];
        [self beginAnimated];
        
    }
    return self;
}

-(void)initData:(id)data
{
    if (data)
    {
        
        _EVInfoArr = [[NSArray alloc]initWithArray:data];
    }

}
-(void)beginAnimated
{
    
}
-(void)createView
{
    [self createBackGroundView];
    [self createImageView];
    
    [self createButtonView];
    [self createLableView];
    [self createOtherView];
    
}
-(void)createBackGroundView
{
    
    self.backgroundColor =
    [[UIColor blackColor]colorWithAlphaComponent:0.3];
    
}
-(void)createImageView
{
   
}

-(void)createLableView
{
    [self addSubview:self.EVAnimationLabel];
    
    self.EVAnimationLabel.frame = self.bounds;
    //CGRectMake((self.width-self.YVRemindlable.width)/2,self.height-164, self.YVRemindlable.width, self.YVRemindlable.height);
}

-(void)createButtonView
{

}

-(void)createOtherView
{
    
}


-(void)removeView
{
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pRemoveRemindView)])
    {
        [self.EVDelegate pRemoveRemindView];
    }
    
}
-(void)animatedAgain:(NSArray *)name
{
    
}
-(void)removeAnimationView
{
    [self removeFromSuperview];
}
-(UILabel *)EVAnimationLabel
{
    if (_EVAnimationLabel == nil)
    {
        _EVAnimationLabel = [[UILabel alloc]init];
        _EVAnimationLabel.font = [UIFont systemFontOfSize:14];
        _EVAnimationLabel.textAlignment = NSTextAlignmentCenter;
        _EVAnimationLabel.textColor = [UIColor whiteColor];
        
    }
    return _EVAnimationLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
