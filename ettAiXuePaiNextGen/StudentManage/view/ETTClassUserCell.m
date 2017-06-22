//
//  ETTClassUserCell.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/20.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTClassUserCell.h"
#import "ETTClassUserModel.h"
#import <UIImageView+WebCache.h>
@interface ETTClassUserCell()
@property (nonatomic,retain)UIImageView      * MVUserIconImageview;
@property (nonatomic,retain)UIImageView      * MVLockView;
@property (nonatomic,retain)UILabel          * MVUserNameLable;
@property (nonatomic,weak)ETTClassUserModel  * MVModel;
@property (nonatomic,retain)UIImageView      * MVUnlineView;
@end

@implementation ETTClassUserCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.MVUserIconImageview];
        [self addSubview:self.MVUserNameLable];
    
    }
    return self;
}

-(UILabel *)MVUserNameLable
{
    if (_MVUserNameLable == nil)
    {
        _MVUserNameLable           = [[UILabel alloc]init];
        _MVUserNameLable.font      = [UIFont systemFontOfSize:12.0f];
        _MVUserNameLable.textColor = kAXPTEXTCOLORf1;
        _MVUserNameLable.textAlignment = NSTextAlignmentCenter;
    }
    return _MVUserNameLable;
}
-(UIImageView *)MVUnlineView
{
    if (_MVUnlineView == nil)
    {
        _MVUnlineView = [[UIImageView alloc]init];
        _MVUnlineView.image = [UIImage imageNamed:@"cover"];
    }
    return _MVUnlineView;
}
-(UIImageView *)MVUserIconImageview
{
    if (_MVUserIconImageview == nil)
    {
        _MVUserIconImageview                     = [[UIImageView alloc]init];
        _MVUserIconImageview.layer.masksToBounds = YES;
        _MVUserIconImageview.layer.cornerRadius  = 40;

    }
    return _MVUserIconImageview;
}

-(UIImageView *)MVLockView
{
    if (_MVLockView == nil)
    {
        _MVLockView = [[UIImageView alloc]init];

        UIImage * image = [UIImage imageNamed:@"bg_lock"];
        _MVLockView.image = image;

        
        
    }
    return _MVLockView;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _MVUserIconImageview.frame = CGRectMake(11, 10, 80, 80);
    _MVUserNameLable.frame     = CGRectMake(11, _MVUserIconImageview.v_bottom+12, 80, 15);
    _MVLockView.frame          = CGRectMake(11, 10, 80, 80);
    _MVUnlineView.frame        = CGRectMake(11, 10, 80, 80);

}

-(void)setUserModel:(id)userModel
{
    [self setUserModel:userModel lockScreen:false];
 
}

-(void)setUserModel:(id)userModel lockScreen:(BOOL)isLock
{
    if (userModel)
    {
        _MVModel = userModel;
        _MVUserNameLable.text =_MVModel.userName;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
       [_MVUserIconImageview sd_setImageWithURL:[NSURL URLWithString:_MVModel.userPhoto] placeholderImage:[UIImage imageNamed:@"user_defalt"] options:SDWebImageRefreshCached|SDWebImageContinueInBackground|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
           if (error == nil)
           {
               [manager saveImageToCache:image forURL:imageURL];
           }

       }];
       
        if (!_MVModel.isOnline)
        {
            [self createUnlineView];
            _MVUserNameLable.textColor = kAXPLINECOLORl1;
        }
        else
        {
            _MVUserNameLable.textColor = kAXPTEXTCOLORf1;
            [self.MVUnlineView removeFromSuperview];
        }
        
        if (isLock)
        {
            [_MVUnlineView removeFromSuperview];
            _MVUnlineView = nil;
            [self createLockView];
        }
        else
        {
            [self.MVLockView removeFromSuperview];
        }
       
    }
}

-(void)createLockView
{
    if (!self.MVLockView.superview)
    {
        [self addSubview:self.MVLockView];
    }
}

-(void)createUnlineView
{
    if (!self.MVUnlineView.superview)
    {
        [self addSubview:self.MVUnlineView];
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
