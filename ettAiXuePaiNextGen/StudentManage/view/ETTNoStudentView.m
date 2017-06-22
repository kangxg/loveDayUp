//
//  ETTNoStudentView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTNoStudentView.h"
@interface ETTNoStudentView()
@property (nonatomic,retain)UIImageView  * MVBgView;

@end
@implementation ETTNoStudentView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.MVBgView];
        [self addSubview:self.EVTitlelabel];
    }
    return self;
}

-(UIImageView *)MVBgView
{
    if (_MVBgView == nil)
    {
        _MVBgView        = [[UIImageView alloc]init];
        UIImage  * image = [UIImage imageNamed:@"stu_null"];
        _MVBgView.image  = image;
        _MVBgView.frame  = CGRectMake((self.width-image.size.width)/2, 110, image.size.width, image.size.height);
    }
    
    return _MVBgView;
}

-(UILabel *)EVTitlelabel
{
    if (_EVTitlelabel == nil)
    {
        _EVTitlelabel               = [[UILabel alloc]init];
        _EVTitlelabel.frame         = CGRectMake(0, self.MVBgView.v_bottom, self.width, 15);
        _EVTitlelabel.textColor     = kAXPTEXTCOLORf2;
        _EVTitlelabel.font          = [UIFont systemFontOfSize:14.0f];
        _EVTitlelabel.textAlignment = NSTextAlignmentCenter;
        _EVTitlelabel.text          = @"暂时还没有学生听课";
    }
    return _EVTitlelabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
