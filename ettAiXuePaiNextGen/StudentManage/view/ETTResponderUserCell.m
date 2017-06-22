//
//  ETTResponderUserCell.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTResponderUserCell.h"
#import "ETTClassUserModel.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
@interface ETTResponderUserCell()
@property (nonatomic,retain)UIImageView      * MVUserIconImageview;

@property (nonatomic,retain)UILabel          * MVUserNameLable;

@property (nonatomic,retain)UILabel          * MVTimeLabel;
@end
@implementation ETTResponderUserCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.MVUserIconImageview];
        [self addSubview:self.MVUserNameLable];
        [self addSubview:self.MVTimeLabel];
        
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
-(UILabel *)MVTimeLabel
{
    if (_MVTimeLabel == nil)
    {
        _MVTimeLabel           = [[UILabel alloc]init];
        _MVTimeLabel.font      = [UIFont systemFontOfSize:12.0f];
        _MVTimeLabel.textColor = kAXPMAINCOLORc13;
        _MVTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _MVTimeLabel;
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


-(void)setUserModel:(id)userModel
{
    if (userModel)
    {
        ETTResponderModel * model  = userModel;
        self.MVTimeLabel.text      = [NSString stringWithFormat:@"%.2f",model.time.floatValue];
        self.MVUserNameLable.text  = model.userName;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];

        UIImage *cachedImage       = [manager.imageCache imageFromDiskCacheForKey:model.userPhoto];
        if (cachedImage)
        {
            self.MVUserIconImageview.image = cachedImage;
        }
        else
        {
             NSURL * url = [NSURL URLWithString:model.userPhoto] ;
            [_MVUserIconImageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_defalt"] options:SDWebImageRefreshCached|SDWebImageContinueInBackground|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error == nil)
                {
                    [manager saveImageToCache:image forURL:imageURL];
                }
                
            }];

        }
        
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _MVTimeLabel.frame         = CGRectMake(11, 5, 80, 15);
    _MVUserIconImageview.frame = CGRectMake(11, 26, 80, 80);
    _MVUserNameLable.frame     = CGRectMake(11, _MVUserIconImageview.v_bottom+12, 80, 15);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
