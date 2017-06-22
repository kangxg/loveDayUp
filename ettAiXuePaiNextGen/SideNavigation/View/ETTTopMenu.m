//
//  ETTTopMenu.m
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
//  Created by zhaiyingwei on 16/9/18.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTopMenu.h"

@interface ETTTopMenu ()

@property (nonatomic,strong) ETTImageView *titleImageView;
@property (nonatomic,strong) ETTImageView *backImageView;

@end

@implementation ETTTopMenu

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kETTRGBCOLOR(44, 44, 44);
        
        [self updateBackImageView];
    }
    return self;
}

-(instancetype)updateBackImageView
{
    ETTImageView *backImageView = [[ETTImageView alloc]initWithFrame:self.bounds];
    ETTImage *image             = [ETTImage imageNamed:@"menu_head.png"];
    backImageView.image         = image;
    backImageView.clipsToBounds = YES;
    [self setFrame:self.bounds];
    [self addSubview:backImageView];
    _backImageView = backImageView;
    
    return self;
}

-(void)rotateToLandscape:(BOOL)isLandscape
{
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    CGRect rect = CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height * 0.25);
    [self setFrame:rect];
    
    [_backImageView setFrame:rect];
}

-(void)drawRect:(CGRect)rect
{   
//    [self drawLine];
}

-(instancetype)drawLine
{
    CGContextRef context  = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, kLineSidesInterval, self.frame.size.height - kLineTopAndDownInterval);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width - kLineSidesInterval, self.frame.size.height - kLineTopAndDownInterval);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGContextSetRGBStrokeColor(context, 255, 255, 255, 1.0);
    CGContextSetLineWidth(context, kLineWidth);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
    
    return self;
}

@end
