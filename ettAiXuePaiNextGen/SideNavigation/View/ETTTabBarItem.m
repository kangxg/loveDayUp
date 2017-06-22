//
//  ETTTabBarItem.m
//  ettAiXuePaiNextGen
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

#import "ETTTabBarItem.h"

@implementation ETTTabBarItem

static const CGFloat kRatio = 0.4;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setTitleColor:kETTRGBCOLOR(144.0, 144.0, 144.0) forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted
{
    NSLog(@"setHighlighted");
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (self.width == self.height) {
        return contentRect;
    } else {
        contentRect.origin.y   = contentRect.origin.y +25;
        contentRect.size.width = contentRect.size.width * kRatio;
        return contentRect;
    }
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if (self.width == self.height) {
        return CGRectMake(0, 0, -1, -1);
    } else {
        contentRect.origin.x   = contentRect.size.width * kRatio;
        contentRect.size.width = contentRect.size.width * (1 - kRatio);
        return contentRect;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView setFrame:CGRectMake(50, self.height/2 - 30.0/2.0, 30.0, 30.0)];
}

@end
