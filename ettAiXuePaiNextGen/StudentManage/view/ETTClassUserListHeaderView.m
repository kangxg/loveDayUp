//
//  ETTClassUserListHeaderView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/20.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTClassUserListHeaderView.h"
#import "ETTClasssGroupModel.h"
@interface ETTClassUserListHeaderView()
@property (nonatomic,weak)ETTClasssGroupModel  * MVModel;
@property (nonatomic,retain)UILabel            * MVMarkLabel;
@property (nonatomic,retain)UILabel            * MVNameLabel;
@property (nonatomic,retain)UIButton           * MVRewardBtn;
@property (nonatomic,copy)ETTCallbackBlock       MVBlock;
@end;


@implementation ETTClassUserListHeaderView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.MVMarkLabel];
        [self addSubview:self.MVNameLabel];
        [self addSubview:self.MVRewardBtn];
    }
    return self;
}
-(void)setHeadViewMessage:(ETTClasssGroupModel *)groupModel   withClick:(ETTCallbackBlock)block ;
{
    if (groupModel)
    {
        _MVModel = groupModel;
         _MVBlock  = block;
        _MVNameLabel.text = groupModel.groupName;
    }
}

-(UILabel *)MVMarkLabel
{
    if (_MVMarkLabel == nil)
    {
        _MVMarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, 3, 20)];
        _MVMarkLabel.backgroundColor = [UIColor colorWithHexString:@"#F2B922"];
    }
    return _MVMarkLabel;
}

-(UILabel *)MVNameLabel
{
    if (_MVNameLabel == nil)
    {
        _MVNameLabel           = [[UILabel alloc]initWithFrame:CGRectMake(26, 16, self.width/2, 18)];

        _MVNameLabel.textColor = kAXPTEXTCOLORf1;
        _MVNameLabel.font      = [UIFont systemFontOfSize:12.0f];
    }
    return _MVNameLabel;
}

-(UIButton *)MVRewardBtn
{
    if (_MVRewardBtn == nil)
    {
        _MVRewardBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
        _MVRewardBtn.frame = CGRectMake(self.width-76, 10, 60, 24);
        [_MVRewardBtn setImage:[UIImage imageNamed:@"manage_icon_reward"] forState:UIControlStateNormal];
        [_MVRewardBtn addTarget:self action:@selector(btnCallback) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MVRewardBtn;
}

-(void)btnCallback
{
    if (_MVBlock)
    {
        _MVBlock(_MVModel);
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
