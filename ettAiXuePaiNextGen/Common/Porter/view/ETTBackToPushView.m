//
//  ETTBackToPushView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/6.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBackToPushView.h"
@interface ETTBackToPushView()
@property (nonatomic,retain)UIButton * MVTapBtn;
@end

@implementation ETTBackToPushView
@synthesize  MVTapBtn = _MVTapBtn;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.MVTapBtn];
    }
    return self;
}

-(UIButton *)MVTapBtn
{
    if (_MVTapBtn == nil)
    {
        _MVTapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _MVTapBtn.frame = self.bounds;
        [_MVTapBtn setTitle:@"返回推送界面" forState:UIControlStateNormal];
        _MVTapBtn.backgroundColor = [[UIColor colorWithHexString:@"#f2b922"]colorWithAlphaComponent:204.0/255];
        _MVTapBtn.titleLabel.font  =[UIFont systemFontOfSize:12.0f];
        [_MVTapBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_MVTapBtn addTarget:self action:@selector(gobackToPushingView) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _MVTapBtn;
}
-(void)showView:(UIView *)superView
{
    if (self.superview)
    {
        return;
    }
    if (superView)
    {
        [superView addSubview:self];
    }
    else
    {
        UIWindow *window = [[UIApplication sharedApplication]keyWindow];
      
        [window addSubview:self];
    }
}
-(void)gobackToPushingView
{
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pViewSelected:)])
    {
        [self.EVDelegate pViewSelected:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
