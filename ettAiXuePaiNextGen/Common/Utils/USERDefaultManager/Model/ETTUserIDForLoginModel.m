//
//  ETTUserIDForLoginModel.m
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

#import "ETTUserIDForLoginModel.h"

@implementation ETTUserIDForLoginModel

@synthesize userType        =   _userType;
@synthesize jid             =   _jid;
@synthesize schoolId        =   _schoolId;
@synthesize redisIp         =   _redisIp;
@synthesize redisPort       =   _redisPort;
@synthesize paperRootUrl    =   _paperRootUrl;
@synthesize token           =   _token;
@synthesize netClassUrl     =   _netClassUrl;
@synthesize userPhoto       =   _userPhoto;
@synthesize userName        =   _userName;
@synthesize classTagList    =   _classTagList;

-(instancetype)initWithDictionary:(NSDictionary *)dataDic
{
    if (self = [super init]) {
        self.userType = [[dataDic objectForKey:@"userType"]intValue];
        self.jid      = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"jid"]];
        self.schoolId = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"schoolId"]];
        self.redisIp  = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"redisIp"]];
        self.redisPort= [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"redisPort"]];
        self.paperRootUrl= [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"paperRootUrl"]];
        self.token    = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"token"]];
        self.userPhoto = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"userPhoto"]];
        self.userName = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"userName"]];
        self.netClassUrl = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"netClassUrl"]];
        self.classTagList = [NSArray arrayWithArray:[dataDic valueForKey:@"classTagList"]];
        
        [AXPUserInformation sharedInformation].paperRootUrl = self.paperRootUrl;
        [AXPUserInformation sharedInformation].userPhoto = self.userPhoto;
        [AXPUserInformation sharedInformation].userName = self.userName;
        [AXPUserInformation sharedInformation].redisIp = self.redisIp;
        [AXPUserInformation sharedInformation].netClassUrl = self.netClassUrl;
    }
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userType       =   [aDecoder decodeIntegerForKey:@"userType"];
        self.jid            =   [aDecoder decodeObjectForKey:@"jid"];
        self.schoolId       =   [aDecoder decodeObjectForKey:@"schoolId"];
        self.redisIp        =   [aDecoder decodeObjectForKey:@"redisIp"];
        self.redisPort      =   [aDecoder decodeObjectForKey:@"redisPort"];
        self.paperRootUrl   =   [aDecoder decodeObjectForKey:@"paperRootUrl"];
        self.token          =   [aDecoder decodeObjectForKey:@"token"];
        self.netClassUrl    =   [aDecoder decodeObjectForKey:@"netClassUrl"];
        self.userPhoto      =   [aDecoder decodeObjectForKey:@"userPhoto"];
        self.userName       =   [aDecoder decodeObjectForKey:@"userName"];
        self.classTagList   =   [aDecoder decodeObjectForKey:@"classTagList"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.userType forKey:@"userType"];
    [aCoder encodeObject:self.jid forKey:@"jid"];
    [aCoder encodeObject:self.schoolId forKey:@"schoolId"];
    [aCoder encodeObject:self.redisIp forKey:@"redisIp"];
    [aCoder encodeObject:self.redisPort forKey:@"redisPort"];
    [aCoder encodeObject:self.paperRootUrl forKey:@"paperRootUrl"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.netClassUrl forKey:@"netClassUrl"];
    [aCoder encodeObject:self.userPhoto forKey:@"userPhoto"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.classTagList forKey:@"classTagList"];
}

@end
