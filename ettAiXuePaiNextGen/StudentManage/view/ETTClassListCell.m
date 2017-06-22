//
//  ETTClassListCell.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTClassListCell.h"
#import "ETTClassificationModel.h"
#import "UIColor+RGBColor.h"
#import "UIView+Frame.h"
@implementation ETTClassListCell
@synthesize EVModel = _EVModel;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle= UITableViewCellSelectionStyleNone;
        [self createImageView];
        [self createLabelView];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected)
    {
        _EVCountLabel.textColor = kC1_COLOR;
        _EVNameLabel.textColor  = kC1_COLOR;
        _EVMarkView.backgroundColor =kC1_COLOR;
        //kC1_COLOR;
    }
    else
    {
        _EVCountLabel.textColor = kAXPTEXTCOLORf1;
        _EVNameLabel.textColor  = kAXPTEXTCOLORf1;
        _EVMarkView.backgroundColor = [UIColor whiteColor];
    }
    
    // Configure the view for the selected state
}
-(void)createImageView
{
  
}

-(void)createLabelView
{
    [self addSubview:self.EVMarkView];
    [self addSubview:self.EVNameLabel];
    [self addSubview:self.EVCountLabel];
}
-(UILabel *)EVMarkView
{
    if (_EVMarkView == nil)
    {
        _EVMarkView = [[UILabel alloc]init];
        _EVMarkView.backgroundColor = [UIColor whiteColor];
    }
    return _EVMarkView;
}

-(UILabel *)EVNameLabel
{
    if (_EVNameLabel == nil)
    {
        _EVNameLabel      = [[UILabel alloc]init];
        _EVNameLabel.font = [UIFont systemFontOfSize:14.0f];
        _EVNameLabel.textColor = kAXPTEXTCOLORf1;
    }
    return _EVNameLabel;
}

-(UILabel *)EVCountLabel
{
    if (_EVCountLabel == nil)
    {
        _EVCountLabel               = [[UILabel alloc]init];
        _EVCountLabel.font          = [UIFont systemFontOfSize:13.0f];
        _EVCountLabel.textAlignment = NSTextAlignmentRight;
        _EVCountLabel.textColor = kAXPTEXTCOLORf1 ;
    }
    return _EVCountLabel;
}
-(void)updateCellViews:(ETTBaseModel *)model
{
    if (model)
    {
        _EVModel = (ETTClassificationModel *)model;
        _EVNameLabel.text = _EVModel.className;
      
        
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _EVNameLabel.frame = CGRectMake(20, 0, self.width/2, self.height);
    _EVMarkView.frame  = CGRectMake(0, 2, 3, 40);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation ETTClassOnlineCell
-(void)createLabelView
{
    [super createLabelView];
    self.EVNameLabel.textColor  = kC1_COLOR ;
    self.EVCountLabel.textColor = kC1_COLOR ;
    
}
-(void)updateCellViews:(ETTBaseModel *)model
{
    [super  updateCellViews:model];
    if (model)
    {
        self.EVCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.EVModel.onlineCount];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
 
    self.EVCountLabel.frame = CGRectMake(self.width/2+20, 0, self.width/2-36, self.height);
    
    
}
@end

@implementation ETTClassAttendCell
-(void)updateCellViews:(ETTBaseModel *)model
{
    [super  updateCellViews:model];
    if (model)
    {
        self.EVCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.EVModel.onlineCount];
        [self.EVCountLabel sizeToFit];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.EVCountLabel.frame = CGRectMake(self.width/2+20, 0, self.width/2-36, self.height);
    
    
}


@end

@implementation ETTClassEstablishCell
-(void)createLabelView
{
    [super createLabelView];
    [self addSubview:self.EVOnlineLabel];
   

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected)
    {
        _EVOnlineLabel.textColor = kC1_COLOR;
        
    }
    else
    {
        _EVOnlineLabel.textColor =kAXPTEXTCOLORf1;
    }
    
    // Configure the view for the selected state
}
-(void)updateCellViews:(ETTBaseModel *)model
{
    [super  updateCellViews:model];
    if (model)
    {
        _EVOnlineLabel.text = [NSString stringWithFormat:@"%ld",(long)self.EVModel.onlineCount];
        [_EVOnlineLabel sizeToFit];
        
        self.EVCountLabel.text =  [NSString stringWithFormat:@"/%ld",(long)self.EVModel.studentCount];
        [self.EVCountLabel sizeToFit];

    }
}
-(UILabel *)EVOnlineLabel
{
    if (_EVOnlineLabel == nil)
    {
        _EVOnlineLabel               = [[UILabel alloc]init];
        _EVOnlineLabel.font          = [UIFont systemFontOfSize:13.0f];
        _EVOnlineLabel.textAlignment = NSTextAlignmentRight;
        _EVOnlineLabel.textColor = kAXPTEXTCOLORf2 ;
    }
    return _EVOnlineLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.EVCountLabel.frame  = CGRectMake(self.width-16-self.EVCountLabel.width, 0, self.EVCountLabel.width, self.height);
    self.EVOnlineLabel.frame = CGRectMake(self.EVCountLabel.x-self.EVOnlineLabel.width, 0, self.EVOnlineLabel.width, self.height);
    self.EVNameLabel.frame   = CGRectMake(20, 0, self.width-16-self.EVOnlineLabel.width-self.EVCountLabel.width-16-10, self.height);
    
}
@end
