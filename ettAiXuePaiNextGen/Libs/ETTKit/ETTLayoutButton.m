//
//  ETTLayoutButton.m
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
//  Created by zhaiyingwei on 16/9/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTLayoutButton.h"

@interface ETTLayoutButton ()

@property (nonatomic,assign)ETTButtonLayoutStyle layoutStyle;

@end

@implementation ETTLayoutButton

-(instancetype)initWithLayoutStryle:(ETTButtonLayoutStyle)layoutStyle
{
    if (self = [super init]) {
        [self setLayoutStyle:layoutStyle];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame withLayoutStyle:(ETTButtonLayoutStyle)layoutStyle
{
    if (self = [super initWithFrame:frame]) {
        [self setLayoutStyle:layoutStyle];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    switch (self.layoutStyle) {
        case ETTButtonLayoutStyleHorizontal:
            self.imageView.x = (self.width - self.imageView.width - self.titleLabel.width)/2;
            self.imageView.y = (self.height - self.imageView.height)/2;
            self.titleLabel.x = self.imageView.x + self.imageView.width + 5;
            self.titleLabel.y = (self.height - self.titleLabel.height)/2;
            break;
        case ETTButtonLayoutStyleVertical:
            self.imageView.x = (self.width - self.imageView.width)/2;
            self.imageView.y = (self.height - self.imageView.height - self.titleLabel.height)/2;
            self.titleLabel.x = (self.width - self.titleLabel.width)/2;
            self.titleLabel.y = (self.imageView.y + self.imageView.height) + 15;
            break;
        default:
            break;
    }
}

@end
