//
//  ETTTeacherChooseClassroomConfirmButton.m
//  ettAiXuePaiNextGen
//
//
//                          _oo8oo_
//                         o8888888o
//                         88" . "88
//                         (| -_- |)
//                         0\  =  /0
//                       ___/'==='\___
//                     .' \\|     |// '.
//                    / \\|||  :  |||// \
//                   / _||||| -:- |||||_ \
//                  |   | \\\  -  /// |   |
//                  | \_|  ''\---/''  |_/ |
//                  \  .-\__  '-'  __/-.  /
//                ___'. .'  /--.--\  '. .'___
//             ."" '<  '.___\_<|>_/___.'  >' "".
//            | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//            \  \ `-.   \_ __\ /__ _/   .-` /  /
//        =====`-.____`.___ \_____/ ___.`____.-`=====
//                          `=---=`
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                 佛祖镇楼   BUG辟易  永不修改
//       佛曰:
//                 写字楼里写字间，写字间里程序员；
//                 程序人员写程序，又拿程序换酒钱。
//                 酒醒只在网上坐，酒醉还来网下眠；
//                 酒醉酒醒日复日，网上网下年复年。
//                 但愿老死电脑间，不愿鞠躬老板前；
//                 奔驰宝马贵者趣，公交自行程序员。
//                 别人笑我忒疯癫，我笑自己命太贱；
//                 不见满街漂亮妹，哪个归得程序员？
//
//  Created by zhaiyingwei on 2016/10/19.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherChooseClassroomConfirmButton.h"

@interface ETTTeacherChooseClassroomConfirmButton ()

@property (nonatomic,strong) ETTLabel       *titleLable;

@property (nonatomic,strong) UIColor        *colorOfBackgroundForUnAvailable;
@property (nonatomic,strong) UIColor        *colorOfBackgroundForTouchDown;
@property (nonatomic,strong) UIColor        *colorOfBackgroundForTouchUp;
@property (nonatomic,strong) UIColor        *colorOfTitleText;
@property (nonatomic,assign) CGFloat        titleTextSize;
@property (nonatomic,assign) CGFloat        titleTextWeight;

@end

@implementation ETTTeacherChooseClassroomConfirmButton

-(instancetype)init
{
    if (self = [super init]) {
        [[[self updateAttributes]createUI]updateColor];
    }
    return self;
}

-(instancetype)updateAttributes
{
    _colorOfBackgroundForUnAvailable    = kETTRGBCOLOR(210.0, 210.0, 210.0);
    _colorOfBackgroundForTouchUp        = kETTRGBCOLOR(75.0, 157.0, 216.0);
    _colorOfBackgroundForTouchDown      = kETTRGBCOLOR(95.0, 177.0, 236.0);
    _colorOfTitleText                   = [UIColor whiteColor];
    _titleTextWeight                    = 10.0;
    _titleTextSize                      = 15.0;
    self.layer.cornerRadius             = 5.0;
    
    return self;
}

-(void)updateAvailable
{
    self.backgroundColor = _colorOfBackgroundForTouchUp;
    self.userInteractionEnabled = YES;
}

-(void)updateUnAvailable
{
    self.backgroundColor = _colorOfBackgroundForUnAvailable;
    self.userInteractionEnabled = NO;
}

-(instancetype)createUI
{
    ETTLabel *titleLable = [[ETTLabel alloc]init];
    [titleLable setFont:[UIFont systemFontOfSize:_titleTextSize weight:_titleTextWeight]];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLable];
    _titleLable = titleLable;
    
    return self;
}

-(instancetype)updateColor
{
    self.backgroundColor    = _colorOfBackgroundForTouchUp;
    [_titleLable setTextColor:_colorOfTitleText];
    
    return self;
}

-(BOOL)setTitleText:(NSString *)text
{
    if (text&&![text isEqualToString:@""]) {
        [_titleLable setText:text];
        return YES;
    }
    return NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = _colorOfBackgroundForTouchDown;
    if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(onClickItemHandler)]) {
        [self.MDelegate onClickItemHandler];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = _colorOfBackgroundForTouchUp;
}

-(void)setState:(ETTTeacherChooseClassroomConfirmButtonType)type
{
    if (type == ETTTeacherChooseClassroomConfirmButtonTypeAvailable) {
        [self updateAvailable];
    } else {
        [self updateUnAvailable];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _titleLable.frame = self.bounds;
}

@end
