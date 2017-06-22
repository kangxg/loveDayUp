//
//  ETTLoginButton.m
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
//  Created by zhaiyingwei on 16/9/29.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTLoginButton.h"

@interface ETTLoginButton ()

@property (nonatomic,strong) ETTLabel *titleLabel;

@property (nonatomic,copy  ) NSString *titleStr;

@property (nonatomic,strong) UIColor  *availableColor;

@property (nonatomic,strong) UIColor  *availableClickingColor;

@property (nonatomic,strong) UIColor  *unAvailableColor;

@property (nonatomic,strong) UIColor  *fontColor;

@property (nonatomic,assign) CGFloat fontSize;

@property (nonatomic,assign) ETTLoginButtonType buttonType;

@end

@implementation ETTLoginButton

-(instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        _titleStr = title;
        [self setBackgroundColor:[UIColor redColor]];
        [[self setAttributes]createUI];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        _titleStr = title;
        [self setBackgroundColor:[UIColor redColor]];
        [[self setAttributes]createUI];
    }
    return self;
}

-(instancetype)setAttributes
{
    _availableColor = kETTRGBCOLOR(99.0, 181.0, 239.0);
    _availableClickingColor = [UIColor colorWithRed:110.0/255.0 green:210.0/255.0 blue:245.0/255.0 alpha:1.0];
    _unAvailableColor = kETTRGBCOLOR(210.0, 210.0, 210.0);
    _fontColor = [UIColor whiteColor];
    _fontSize = 18.0;
    self.layer.cornerRadius = 8.0;
    
    return self;
}

-(instancetype)createUI
{
    ETTLabel *titleLabel              = [[ETTLabel alloc]initWithFrame:CGRectZero];
    [titleLabel setNumberOfLines:0];
    titleLabel.text                   = _titleStr;
    titleLabel.textColor              = _fontColor;
    titleLabel.textAlignment          = NSTextAlignmentCenter;
    titleLabel.font                   = [UIFont systemFontOfSize:_fontSize];
    titleLabel.userInteractionEnabled = NO;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    return self;
}

-(void)setButtonType:(ETTLoginButtonType)type
{
    _buttonType = type;
    [self changeType];
}

-(ETTLoginButtonType)getButtonType
{
    return _buttonType;
}

-(void)changeType
{
    switch ([self getButtonType]) {
        case ETTLoginButtonTypeAvailable:
            [self setBackgroundColor:_availableColor];
            break;
        case ETTLoginButtonTypeUnavailable:
            [self setBackgroundColor:_unAvailableColor];
            break;
        default:
            break;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_titleLabel setFrame:CGRectMake(self.width/2 - 200/2, self.height/2 - 40/2, 200, 40)];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    switch ([self getButtonType]) {
        case ETTLoginButtonTypeAvailable:
            if (_MDelegate&&[_MDelegate respondsToSelector:@selector(loginButtonClickHandler:)]) {
                WS(weakSelf);
                [self.MDelegate loginButtonClickHandler:weakSelf];
                [self setBackgroundColor:_availableClickingColor];
            }else{
                NSLog(@"self MDelegate was wrong!");
            }
            break;
        case ETTLoginButtonTypeUnavailable:
            NSLog(@"The button'type is ETTLoginButtonTypeUnavailable!");
            break;
        default:
            break;
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    switch ([self getButtonType]) {
        case ETTLoginButtonTypeAvailable:
            [self setBackgroundColor:_availableColor];
            break;
        default:
            break;
    }
}

@end
