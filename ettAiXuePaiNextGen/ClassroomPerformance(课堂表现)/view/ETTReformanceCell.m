//
//  ETTReformanceCell.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTReformanceCell.h"
#import "ETTClassUserModel.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import "ETTClassUserModel.h"
@interface ETTReformanceCell()
{
    float  _mRewardWith;
}
@property (nonatomic,retain)UIImageView      * MVUserIconImageview;
@property (nonatomic,retain)UIImageView      * MVNumImageView;

@property (nonatomic,retain)UIImageView      * MVCouronneImageView;
@property (nonatomic,retain)UILabel          * MVNumLabel;
@property (nonatomic,retain)UILabel          * MVNameLabel;
@property (nonatomic,retain)UILabel          * MVRewardLable;

@property (nonatomic,retain)UILabel          * MVResponderLabel;
@property (nonatomic,retain)UILabel          * MVRollCallLabel;

@property (nonatomic,retain)UILabel          * MVRemindLabel;

@end
@implementation ETTReformanceCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor =[UIColor colorWithHexString:@"#fafafa"];
        _mRewardWith = (kWIDTH-17-24-32-20-91-96*2)/4;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.MVUserIconImageview];
        [self addSubview:self.MVNameLabel];
        [self addSubview:self.MVRewardLable];
        [self addSubview:self.MVResponderLabel];
        [self addSubview:self.MVRollCallLabel];
        [self addSubview:self.MVRemindLabel];

    }
    return  self;
}
-(void)updateCellViews:(ETTBaseModel *)model withScore:(ETTScoreSectionModel *)scoreModel withIndex:(NSIndexPath * )indexPath responderCount:(NSInteger )responderCount rollcallCount:(NSInteger)rollcallCount
{
    if (!model)
    {
        return;
    }

    ETTClassUserModel * userModel = (ETTClassUserModel *)model;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    UIImage *cachedImage = [manager.imageCache imageFromDiskCacheForKey:userModel.userPhoto];
    if (cachedImage)
    {
        self.MVUserIconImageview.image = cachedImage;
    }
    else
    {
        NSURL * url = [NSURL URLWithString:userModel.userPhoto] ;
        [_MVUserIconImageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_defalt"] options:SDWebImageRefreshCached|SDWebImageContinueInBackground|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error == nil)
            {
                [manager saveImageToCache:image forURL:imageURL];
            }
            
        }];
        
    }
    
    _MVNameLabel.text      = userModel.userName;
    
    _MVRewardLable.text    = [NSString stringWithFormat:@"%ld",(long)userModel.rewardScore];
    [self setResonderText:userModel responder:responderCount];
    [self setRollcallText:userModel rollcall:rollcallCount];
    

   
    _MVRemindLabel.text    = [NSString stringWithFormat:@"%ld",(long)userModel.remindCount];
    
    if (scoreModel.EDFirstBest >0 )
    {
        NSLog(@"userModel.rewardScore = %ld ,firstCount = %ld",(long)userModel.rewardScore,(long)scoreModel.EDFirstBest);
        [self setCouronneImageState:(userModel.rewardScore == scoreModel.EDFirstBest)];
    }
    [self topselling:userModel withScore:scoreModel index:indexPath];
    
    
 
}
-(void)setResonderText:(ETTClassUserModel * )model responder:(NSInteger)count
{
    if (count)
    {
        _MVResponderLabel.text = [NSString stringWithFormat:@"%ld | %ld次",(long)model.answerCount,(long)count];
        if (model.answerCount>0) {
            NSLog(@"%@抢答了%ld次",model.jid,model.answerCount);
        }
    }
    else
    {
        _MVResponderLabel.text = [NSString stringWithFormat:@"%ld",(long)model.answerCount];
    }

}

-(void)setRollcallText:(ETTClassUserModel * )model rollcall:(NSInteger)count
{
    if (count)
    {
        _MVRollCallLabel.text  = [NSString stringWithFormat:@"%ld | %ld次",(long)model.rollCallCount,(long)count];
    }
    else
    {
        _MVRollCallLabel.text  = [NSString stringWithFormat:@"%ld",(long)model.rollCallCount];
    }
}
-(void)topselling:(ETTClassUserModel * )model  withScore:(ETTScoreSectionModel *)scoreModel  index:(NSIndexPath * )indexPath
{
    if (scoreModel.EDFirstBest>0)
    {
        if (indexPath.row == 0  &&  model.rewardScore == [scoreModel getBestScore:indexPath.section] ) {
            if (!self.MVNumLabel.superview)
            {
                [self addSubview:self.MVNumLabel];
                
            }
            self.MVNumLabel.text = [NSString stringWithFormat:@"%ld",(long)[scoreModel getBestNum:indexPath.section]];
            
        }
        else
        {
            if (_MVNumLabel.superview)
            {
                [_MVNumLabel removeFromSuperview];
                _MVNumLabel  = nil;
            }
        }
        
        if (model.rewardScore>0)
        {
            self.MVRewardLable.textColor =kAXPMAINCOLORc12;
        }
        else
        {
            self.MVRewardLable.textColor =kAXPTEXTCOLORf1;
        }
    }
    else
    {
        if (_MVNumLabel.superview)
        {
            [_MVNumLabel removeFromSuperview];
            _MVNumLabel  = nil;
        }
         self.MVRewardLable.textColor =kAXPTEXTCOLORf1;
    }
}

-(void)setCouronneImageState:(BOOL)isBest
{
    if (isBest)
    {
        
        [self addSubview:self.MVCouronneImageView];
    }
    else
    {
        if (_MVCouronneImageView.superview)
        {
            [_MVCouronneImageView removeFromSuperview];
        }
        _MVCouronneImageView = nil;
        
    }
}

//-(void)scoreRanking:
-(UIImageView *)MVCouronneImageView
{
    if (_MVCouronneImageView == nil)
    {
        _MVCouronneImageView = [[UIImageView alloc]init];
        _MVCouronneImageView.image =[UIImage imageNamed:@"manage_icon_crown"];
        _MVCouronneImageView.frame = CGRectMake(24+8.5, (64-32)/2-19.0/2, 19, 19);
        
    }
    return _MVCouronneImageView;
}

-(UIImageView *)MVNumImageView
{
    if (_MVNumImageView == nil)
    {
        _MVNumImageView = [[UIImageView alloc]init];
        _MVNumImageView.frame =CGRectMake(0, (64-32)/2, 24, 24);
    }
    return _MVNumImageView;
}
-(UIImageView *)MVUserIconImageview
{
    if (_MVUserIconImageview == nil)
    {
        _MVUserIconImageview = [[UIImageView alloc]init];
        _MVUserIconImageview.layer.masksToBounds = YES;
        _MVUserIconImageview.layer.cornerRadius  = 16;
        
    }
    return _MVUserIconImageview;
}

-(UILabel *)MVNameLabel
{
    if (_MVNameLabel == nil)
    {
        _MVNameLabel = [[UILabel alloc]init];
        _MVNameLabel.font = [UIFont systemFontOfSize:12.0f];
        _MVNameLabel.textColor = kAXPTEXTCOLORf1;
        _MVNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _MVNameLabel;
}
-(UILabel *)MVNumLabel
{
    if (_MVNumLabel == nil)
    {
        _MVNumLabel  = [[UILabel alloc]init];
        _MVNumLabel.frame =CGRectMake(0, (64-32)/2, 24, 24);
        _MVNumLabel.font  = [UIFont systemFontOfSize:12.0f];
        _MVNumLabel.textColor = [UIColor colorWithHexString:@"#555555"];
    }
    return _MVNumLabel;
}
-(UILabel *)MVRewardLable
{
    if (_MVRewardLable == nil)
    {
        _MVRewardLable = [[UILabel alloc]init];
        _MVRewardLable.font = [UIFont systemFontOfSize:14.0f];
        _MVRewardLable.textColor = kAXPTEXTCOLORf1;
        _MVRewardLable.textAlignment = NSTextAlignmentCenter;
    }
    return _MVRewardLable;
}

-(UILabel *)MVResponderLabel
{
    if (_MVResponderLabel == nil)
    {
        _MVResponderLabel = [[UILabel alloc]init];
        _MVResponderLabel.font = [UIFont systemFontOfSize:12.0f];
        _MVResponderLabel.textColor = kAXPTEXTCOLORf1;
        _MVResponderLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _MVResponderLabel;
}
-(UILabel *)MVRollCallLabel
{
    if (_MVRollCallLabel == nil)
    {
        _MVRollCallLabel = [[UILabel alloc]init];
        _MVRollCallLabel.font = [UIFont systemFontOfSize:12.0f];
        _MVRollCallLabel.textColor = kAXPTEXTCOLORf1;
        _MVRollCallLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _MVRollCallLabel;
}
-(UILabel *)MVRemindLabel
{
    if (_MVRemindLabel == nil)
    {
        _MVRemindLabel = [[UILabel alloc]init];
        _MVRemindLabel.font = [UIFont systemFontOfSize:12.0f];
        _MVRemindLabel.textColor = kAXPTEXTCOLORf1;
        _MVRemindLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _MVRemindLabel;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _MVUserIconImageview.frame = CGRectMake(24+17, (self.height-32)/2, 32, 32);
    _MVNameLabel.frame  = CGRectMake(_MVUserIconImageview.v_right+20, 0, 91, self.height);
    _MVRewardLable.frame = CGRectMake(_MVNameLabel.v_right, 0, _mRewardWith, self.height);
    _MVResponderLabel.frame =  CGRectMake(_MVRewardLable.v_right, 0, _mRewardWith, self.height);
    _MVRollCallLabel.frame  =  CGRectMake(_MVResponderLabel.v_right, 0, _mRewardWith, self.height);
    _MVRemindLabel.frame    =  CGRectMake(_MVRollCallLabel.v_right, 0, _mRewardWith, self.height);



}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
