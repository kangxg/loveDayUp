//
//  ETTSelectIdentityButtonView.m
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
//  Created by zhaiyingwei on 2016/10/10.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTSelectIdentityButtonView.h"

@interface ETTSelectIdentityButtonView ()

@property (nonatomic,strong) ETTImageView                *iconView;

@property (nonatomic,assign) ETTSelectIdentityButtonType type;

@property (nonatomic,strong) ETTLabel                    *typeLabel;

@end

@implementation ETTSelectIdentityButtonView

-(instancetype)initWithType:(ETTSelectIdentityButtonType)type
{
    if (self = [super init]) {
        [self setType:type];
        [[[self updateAttributes]updateIcon]updateTypeLabel:[self getType]];
    }
    return self;
}

-(instancetype)updateAttributes
{
    self.layer.cornerRadius  = 5.0;
    self.layer.shadowRadius  = 5.0;
    self.layer.masksToBounds = YES;
    self.layer.shadowColor   = kETTRGBCOLOR(217, 234, 247).CGColor;
    self.layer.shadowOffset  = CGSizeMake(-10, 10);
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

-(instancetype)updateIcon
{
    ETTImageView *iconView      = [[ETTImageView alloc]initWithImage:[ETTImage imageNamed:[self getIconURL]]];
    iconView.layer.cornerRadius = kIdentityButtonIconSide/2.0;
    iconView.layer.borderColor  = kETTRGBCOLOR(212, 212, 212).CGColor;
    iconView.layer.borderWidth  = 1.0;
    iconView.backgroundColor    = [UIColor grayColor];
    iconView.clipsToBounds      = YES;
    [self addSubview:iconView];
    _iconView = iconView;
    
    return self;
}

-(instancetype)updateTypeLabel:(ETTSelectIdentityButtonType)type
{
    ETTLabel *typeLabel     = [[ETTLabel alloc]init];
    [typeLabel setTextColor:kETTRGBCOLOR(212, 212, 212)];
    [typeLabel setFont:[UIFont systemFontOfSize:20.0 weight:10.0]];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    [typeLabel setText:[self getName:type]];
    [self addSubview:typeLabel];
    _typeLabel = typeLabel;
    
    return self;
}

-(NSString *)getName:(ETTSelectIdentityButtonType)type
{
    NSString *name;
    switch (type) {
        case ETTSelectIdentityButtonTypeStudent:
            name = @"学生";
            break;
        case ETTSelectIdentityButtonTypeTeacher:
            name = @"教师";
            break;
        default:
            name = @"出错";
            break;
    }
    
    return name;
}

-(NSString *)getIconURL
{
    NSString *url;
    switch ([self getType]) {
        case ETTSelectIdentityButtonTypeStudent:
            url = @"student.png";
            break;
        case ETTSelectIdentityButtonTypeTeacher:
            url = @"teacher.png";
            break;
            
        default:
            break;
    }
    return url;
}

-(instancetype)drawLine
{
    CGPoint beginPoint = CGPointMake(0.0, self.height-kIdentityTitleLineHeight);
    CGPoint endPoint   = CGPointMake(self.width, self.height-kIdentityTitleLineHeight);
    [self drawLineFrom:beginPoint toPoint:endPoint withWidth:1.0];
    
    return self;
}

-(instancetype)drawLineFrom:(CGPoint)beginPoint toPoint:(CGPoint)endPoint withWidth:(CGFloat)width
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, beginPoint.x, beginPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    [kETTRGBCOLOR(233, 242, 248) set];
    CGContextSetLineWidth(context, width);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
    
    return self;
}


-(void)setType:(ETTSelectIdentityButtonType)type
{
    _type = type;
}

-(ETTSelectIdentityButtonType)getType
{
    return _type;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = kETTRGBCOLOR(217, 234, 247);
    CAKeyframeAnimation * bounceAnimation =  [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    bounceAnimation.values = @[@(0.5),@(0.7),@(1.0), @(0.9), @(1.15), @(0.75), @(1.12), @(1.0)];
    bounceAnimation.values = @[@(0.7),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
    bounceAnimation.duration = 0.1;
    bounceAnimation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:bounceAnimation forKey:@"ImageViewAnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WS(weakSelf);
        if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(clickItem:)]) {
            [self.MDelegate clickItem:weakSelf];
        }
    });
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor whiteColor];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _iconView.frame = CGRectMake(self.width/2.0-kIdentityButtonIconSide/2.0, 33.0, kIdentityButtonIconSide, kIdentityButtonIconSide);
    
    _typeLabel.frame = CGRectMake(self.width/2.0-100.0/2.0, self.height-33.0-30.0, 100.0, 30.0);
}

@end
