//
//  ETTUserIDForLoginModel.h
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
//  Login.do接口返回数据的identityList（NSArray）集合的元素。
//  用于表示用户身份
//

#import <Foundation/Foundation.h>

@interface ETTUserIDForLoginModel : NSObject<NSCoding>

@property (nonatomic,assign)    NSInteger        userType;
@property (nonatomic,copy)      NSString         *jid;
@property (nonatomic,copy)      NSString         *schoolId;
@property (nonatomic,copy)      NSString         *redisIp;
@property (nonatomic,copy)      NSString         *redisPort;
@property (nonatomic,copy)      NSString         *paperRootUrl;
@property (nonatomic,copy)      NSString         *token;
@property (nonatomic,copy)      NSString         *netClassUrl;
@property (nonatomic,copy)      NSString         *userPhoto;
@property (nonatomic,copy)      NSString         *userName;
@property (nonatomic,copy)      NSArray          *classTagList;

-(instancetype)initWithDictionary:(NSDictionary *)dataDic;

@end
