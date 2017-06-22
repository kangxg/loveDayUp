//
//  ETTSelectClassroomConfirmButton.m
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
//  Created by zhaiyingwei on 2016/10/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTSelectClassroomConfirmButton.h"

@interface ETTSelectClassroomConfirmButton ()

@property (nonatomic,strong)ETTLabel        *titleLabel;

@property (nonatomic,strong)UIColor         *colorOfUnAvailable;
@property (nonatomic,strong)UIColor         *colorOfBackgroundForTouchDown;
@property (nonatomic,strong)UIColor         *colorOfBackgroundForTouchUp;
@property (nonatomic,strong)UIColor         *colorOfText;
@property (nonatomic,assign)CGFloat         titleTextSize;
@property (nonatomic,assign)CGFloat         titleTextWeight;

@end

@implementation ETTSelectClassroomConfirmButton

@synthesize mType       =   _mType;
@synthesize MDelegate   =   _MDelegate;

-(instancetype)init
{
    if (self = [super init]) {
        [[self updateAttributes]createUI];
    }
    
    return self;
}

-(instancetype)updateAttributes
{
    self.colorOfUnAvailable             = kETTRGBCOLOR(210.0, 210.0, 210.0);
    self.colorOfText                    = [UIColor whiteColor];
    self.colorOfBackgroundForTouchUp    = kETTRGBCOLOR(75.0, 157.0, 216.0);
    self.colorOfBackgroundForTouchDown  = kETTRGBCOLOR(95.0, 177.0, 236.0);
    self.titleTextSize                  = 15.0;
    self.titleTextWeight                = 10.0;
    
    self.backgroundColor = self.colorOfBackgroundForTouchUp;
    
    return self;
}

-(instancetype)createUI
{
    ETTLabel *titleLabel = [[ETTLabel alloc]init];
    [titleLabel setFont:[UIFont systemFontOfSize:_titleTextSize weight:_titleTextWeight]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:self.colorOfText];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    return self;
}

-(BOOL)setTitleText:(NSString *)title
{
    if (title&&![title isEqualToString:@""]) {
        [_titleLabel setText:title];
        return YES;
    }else{
        return NO;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(0, 0, self.width, self.height);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = self.colorOfBackgroundForTouchDown;
    NSLog(@"ETTSelectClassroomConfirmButton was click!");
    WS(weakSelf);
    if (_MDelegate&&[self.MDelegate respondsToSelector:@selector(onSelectClassroomConfirmButtonClick:)]) {
        __strong ETTSelectClassroomConfirmButton *strongSelf = weakSelf;
        [self.MDelegate onSelectClassroomConfirmButtonClick:strongSelf];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = self.colorOfBackgroundForTouchUp;
}

-(void)setConfirmType:(ETTCreateClassroomType)type
{
    if (type == ETTCreateClassroomTypeAvailable) {
        [self updateAvailable];
    }else{
        [self updateUnAvailable];
    }
}

-(void)updateAvailable
{
    self.backgroundColor        = self.colorOfBackgroundForTouchUp;
    self.userInteractionEnabled = YES;
}

-(void)updateUnAvailable
{
    self.backgroundColor        = self.colorOfUnAvailable;
    self.userInteractionEnabled = NO;
}

@end
