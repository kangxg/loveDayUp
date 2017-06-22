//
//  ETTClassSelectCell.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/28.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTClassSelectCell.h"
@interface  ETTClassSelectCell()

@end
@implementation ETTClassSelectCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addSubview:self.EVNameLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kC2_COLOR;
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
       
        _EVNameLabel.textColor  = [UIColor whiteColor];
     
    }
    else
    {
        
        _EVNameLabel.textColor =  [[UIColor colorWithHexString:@"#ffffff"]colorWithAlphaComponent:66.0/255.0f];;
       
    }
}
-(UILabel *)EVNameLabel
{
    if (_EVNameLabel == nil)
    {
        _EVNameLabel = [[UILabel alloc]init];
        _EVNameLabel.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 45);
        _EVNameLabel.textColor = [[UIColor colorWithHexString:@"#ffffff"]colorWithAlphaComponent:66.0/255.0f];
        _EVNameLabel.font  = [UIFont systemFontOfSize:18.0f];
        _EVNameLabel.textAlignment = NSTextAlignmentCenter;
        _EVNameLabel.backgroundColor = kC2_COLOR;
    }
    return _EVNameLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
