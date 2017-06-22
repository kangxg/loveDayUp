//
//  ETTBottomMenu.m
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
//  Created by zhaiyingwei on 16/9/13.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBottomMenu.h"

@implementation ETTBottomMenu

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kETTRGBCOLOR(44, 44, 44);
        [self setupItemWithImageName:@"menu_icon_logout" type:ETTBottomMenuItemTypeSignOut];
    }
    return self;
}

- (instancetype)setupItemWithImageName:(NSString *)imageName type:(ETTBottomMenuItemType)type
{
    ETTButton *item = [ETTButton buttonWithType:UIButtonTypeCustom];
    item.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [item setTitle:@"退出" forState:UIControlStateNormal];
    [item setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [item setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [item setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [item setBackgroundImage:[UIImage imageNamed:@"tabbar_separate_selected_bg"] forState:UIControlStateHighlighted];
    item.tag = type;
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:item];
    
    return self;
}

-(void)itemClick:(ETTButton *)sender
{
    if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(bottomMenu:type:)]) {
        [self.MDelegate bottomMenu:self type:sender.tag];
    }
}

-(void)drawRect:(CGRect)rect
{
    [self drawLine];
}

-(instancetype)drawLine
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, kLineSidesInterval, kLineTopAndDownInterval);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width - kLineSidesInterval, kLineTopAndDownInterval);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGContextSetRGBStrokeColor(context, 255, 255, 255, 1.0);
    CGContextSetLineWidth(context, kLineWidth);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
    
    return self;
}

-(void)rotateToLandscape:(BOOL)isLandscape
{
    NSInteger count = self.subviews.count;
    
    self.frame = CGRectMake(0, self.superview.height - self.superview.height/8 , self.superview.width, self.superview.height/8);
    CGFloat tap = self.width/self.subviews.count;
    for (int i = 0; i<count; i++) {
        ETTButton *item = self.subviews[i];
        item.width = 130.0;
        item.height = 30.0;
        item.x = tap*i + tap/2.0-item.width/2.0;
        item.y = self.height/2.0 - item.height/2.0;
    }
}

@end
