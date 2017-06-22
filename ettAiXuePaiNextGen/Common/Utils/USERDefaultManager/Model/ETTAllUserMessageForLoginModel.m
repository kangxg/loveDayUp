//
//  ETTAllUserMessageForLoginModel.m
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
//  Created by zhaiyingwei on 2016/10/26.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTAllUserMessageForLoginModel.h"

@implementation ETTAllUserMessageForLoginModel

@synthesize result      =   _result;
@synthesize msg         =   _msg;
@synthesize data        =   _data;

-(instancetype)initWithDictionary:(NSDictionary *)dataDic
{
    if (self = [super init]) {
        self.result = [[dataDic objectForKey:@"result"]intValue];
        self.msg    = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"msg"]];
        self.data   = [NSDictionary dictionaryWithDictionary:[dataDic objectForKey:@"data"]];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.result     =   [aDecoder decodeIntegerForKey:@"result"];
        self.msg        =   [aDecoder decodeObjectForKey:@"msg"];
        self.data       =   [aDecoder decodeObjectForKey:@"data"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.result forKey:@"result"];
    [aCoder encodeObject:self.msg forKey:@"msg"];
    [aCoder encodeObject:self.data forKey:@"data"];
}

@end
