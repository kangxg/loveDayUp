//
//  ETTLeftTitleButton.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/29.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTLeftTitleButton.h"
@interface ETTLeftTitleButton()
@property (nonatomic,retain)UIImageView * MVRightImageView;
@property (nonatomic,retain)UIImageView * MVImageView;
@property (nonatomic,retain)UIButton    * MVTapButton;
@end
@implementation ETTLeftTitleButton
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
    
        [self addSubview:self.EVTitleLabe];
        [self addSubview:self.MVImageView];
        [self addSubview:self.MVTapButton];
    }
    return self;
}
-(void)resetViewCanSelect:(NSInteger)count
{
    if (count<2)
    {
        _MVImageView.hidden = YES;
        _MVTapButton.hidden = YES;
    }
    else
    {
        _MVImageView.hidden = false;
        _MVTapButton.hidden = false;
    }
}
-(UILabel *)EVTitleLabe
{
    if (_EVTitleLabe == nil)
    {
        _EVTitleLabe = [[UILabel alloc]init];
        _EVTitleLabe.font = [UIFont systemFontOfSize:17.0f];
        _EVTitleLabe.textColor = [UIColor whiteColor];
        _EVTitleLabe.text = @"选择班级";
        [_EVTitleLabe sizeToFit];
    }
    return _EVTitleLabe;
}


-(UIImageView * )MVImageView
{
    if (_MVImageView == nil)
    {
        _MVImageView = [[UIImageView alloc]init];
        _MVImageView.image               = [UIImage imageNamed:@"icon_down"];
        _MVImageView.highlightedImage    = [UIImage imageNamed:@"icon_up"];
    
    }
    return _MVImageView;
}

-(UIButton *)MVTapButton
{
    if (_MVTapButton == nil)
    {
        _MVTapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MVTapButton addTarget:self action:@selector(selectHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MVTapButton;
}

-(void)selectHandle
{
    _EVViewSelected = !_EVViewSelected;
    _MVImageView.highlighted = _EVViewSelected;
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pViewSelected:)])
    {
        [self.EVDelegate pViewSelected:self];
    }
  
}
-(void)setEVTitle:(NSString *)EVTitle
{
    if (EVTitle.length)
    {
        _EVTitleLabe.text = EVTitle;
        [_EVTitleLabe sizeToFit];
        self.frame = CGRectMake(self.x, self.y, _EVTitleLabe.width +20 +10, 44);
        _MVTapButton.frame = self.bounds;
    }
}
-(void)setEVViewSelected:(BOOL)EVViewSelected
{
    _MVImageView.highlighted = EVViewSelected;
    _EVViewSelected = EVViewSelected;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _EVTitleLabe.frame = CGRectMake(0, 0, _EVTitleLabe.width, 44);
    _MVImageView.frame = CGRectMake(_EVTitleLabe.v_right+10, 12, 20, 20);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
