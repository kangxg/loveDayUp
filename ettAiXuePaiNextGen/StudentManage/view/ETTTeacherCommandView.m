//
//  ETTTeacherCommandView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/18.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherCommandView.h"
#import "ETTClassificationModel.h"
@interface ETTTeacherCommandView()
@property (nonatomic,weak)ETTClassificationModel  * MVModel;
@property (nonatomic,retain)UIButton              * MVClickButon;
@property (nonatomic,retain)UIImageView           * MVImageView;
@property (nonatomic,retain)UILabel               * MVTitleLabel;
@end

@implementation ETTTeacherCommandView

-(id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame])
    {
        [self initData];
        [self createButtonView];
        [self createImageview];
        [self createLabelView];
        
    }
    return self;
}
-(void)initData
{
    
}
-(void)createButtonView
{
    [self addSubview:self.MVClickButon];
}

-(void)createImageview
{
    [self addSubview:self.MVImageView];
    
}

-(void)createLabelView
{
    [self addSubview:self.MVTitleLabel];
}
-(UIImageView *)MVImageView
{
    if (_MVImageView == nil)
    {
        _MVImageView = [[UIImageView alloc]init];
       
    }
    
    return _MVImageView;
}

-(UIButton *)MVClickButon
{
    if (_MVClickButon == nil)
    {
        _MVClickButon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MVClickButon addTarget:self action:@selector(btncallback) forControlEvents:UIControlEventTouchUpInside];
       
        
    }
    return _MVClickButon;
}
-(UILabel * )MVTitleLabel
{
    if (_MVTitleLabel == nil)
    {
        _MVTitleLabel               = [[UILabel alloc]init];
        _MVTitleLabel.textColor     = kAXPTEXTCOLORf2;
        _MVTitleLabel.textAlignment = NSTextAlignmentCenter;
        _MVTitleLabel.font          = [UIFont systemFontOfSize:10.0f];
    }
    return _MVTitleLabel;
}
-(void)btncallback
{
    if (self.EVOperationView )
    {
        [self.EVOperationView commandView:self];
    }
  
}


-(void)reloadView:(ETTClassificationModel *)model
{
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _MVClickButon.frame = self.bounds;
    _MVImageView.frame  = CGRectMake(17, 8, 30, 30);
    _MVTitleLabel.frame = CGRectMake(0, self.height-6-_MVTitleLabel.height, self.width, _MVTitleLabel.height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



@implementation ETTLockScreenCommandView
-(void)initData
{
    self.EVType = ETTTEACHERMOMMANDLOCKSCREEN;
    
}

-(void)reloadView:(ETTClassificationModel *)model
{
    if (model)
    {
        self.MVImageView.highlighted = model.isLockScreen;
    }
}
-(void)createImageview
{
    [super createImageview];
    self.MVImageView.image = [UIImage imageNamed:@"manage_icon_lock_default"];
    self.MVImageView.highlightedImage = [UIImage imageNamed:@"manage_icon_lock_selected"];
    self.MVTitleLabel.text = @"锁屏";
    [self.MVTitleLabel sizeToFit];
}
@end

@implementation ETTRollCallCommandView
-(void)initData
{
    self.EVType = ETTTEACHERMOMMANDROLLCALL;
    
}
-(void)reloadView:(ETTClassificationModel *)model
{
    if (model)
    {
        self.MVImageView.highlighted = model.isRollCall;
    }
}
-(void)createImageview
{
    [super createImageview];
    self.MVImageView.image = [UIImage imageNamed:@"manage_icon_call_default"];
    self.MVImageView.highlightedImage = [UIImage imageNamed:@"manage_icon_call_selected"];
    self.MVTitleLabel.text = @"点名";
    [self.MVTitleLabel sizeToFit];
}

-(void)setSelected:(BOOL)selected
{
    self.MVImageView.highlighted = false;
}
@end

@implementation ETTReponderCommandView

-(void)initData
{
    self.EVType = ETTTEACHERMOMMANDREPONDER;
    
}
-(void)reloadView:(ETTClassificationModel *)model
{
    if (model)
    {
        self.MVImageView.highlighted = model.isReponder;
    }
}
-(void)createImageview
{
    [super createImageview];
    self.MVImageView.image = [UIImage imageNamed:@"manage_icon_answer_default"];
    self.MVImageView.highlightedImage = [UIImage imageNamed:@"manage_icon_answer_selected"];
    self.MVTitleLabel.text = @"抢答";
    [self.MVTitleLabel sizeToFit];
}
@end

@implementation ETTGroupCommandView
-(void)initData
{
    self.EVType = ETTTEACHERMOMMANDGROUP;
    
}
-(void)reloadView:(ETTClassificationModel *)model
{
    if (model)
    {
        self.MVImageView.highlighted = model.isGroup;
    }
}
-(void)createImageview
{
    [super createImageview];
    self.MVImageView.image = [UIImage imageNamed:@"manage_icon_team_default"];
    self.MVImageView.highlightedImage = [UIImage imageNamed:@"manage_icon_team_selected"];
    self.MVTitleLabel.text = @"分组";
    [self.MVTitleLabel sizeToFit];
}
@end


@implementation ETTTVCommandView
-(void)initData
{
    self.EVType = ETTTEACHERMOMMANDTV;
    
}
-(void)reloadView:(ETTClassificationModel *)model
{
    if (model)
    {
        self.MVImageView.highlighted = model.isTV;
    }
}
-(void)createImageview
{
    [super createImageview];
    self.MVImageView.image = [UIImage imageNamed:@"manage_icon_tv_default"];
    self.MVImageView.highlightedImage = [UIImage imageNamed:@"manage_icon_tv_selected"];
    self.MVTitleLabel.text = @"投屏";
    [self.MVTitleLabel sizeToFit];
}
@end
