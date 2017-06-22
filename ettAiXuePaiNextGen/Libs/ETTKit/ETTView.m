//
//  ETTView.m
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
//  Created by zhaiyingwei on 16/9/27.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTView.h"

@implementation ETTView
@synthesize EVDelegate;
-(void)reloadView
{
    
}

-(void)commandView:(id)object
{
    
}
-(NSArray *)pGetDataSource:(id)object
{
    return nil;
}
-(void)showView
{
    [self showView:nil];
}
-(void)showView:(UIView *)superView
{
    if (self.superview)
    {
        return;
    }
    if (superView)
    {
        [superView addSubview:self];
    }
    else
    {
        UIWindow *window = [[UIApplication sharedApplication]keyWindow];
        self.frame = window.bounds;
        [window addSubview:self];
    }
}
-(void)pViewSelected:(id)object
{
    
}
-(NSString *)pGetDataMark:(id)object
{
    return @"";
}
-(void)closeView
{
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenCloseView:)])
    {
        [self.EVDelegate pEvenCloseView:self];
    }
    else
    {
        [self removeFromSuperview];
    }
}
@end
