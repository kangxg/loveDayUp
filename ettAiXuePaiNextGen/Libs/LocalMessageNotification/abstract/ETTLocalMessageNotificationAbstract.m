//
//  ETTLocalMessageNotificationAbstract.m
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
//  Created by zhaiyingwei on 2016/12/20.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTLocalMessageNotificationAbstract.h"
#import "ETTRedisBasisManager.h"

@interface ETTLocalMessageNotificationAbstract ()

@property (nonatomic,strong) CLLocationManager      *locationManager;

@end

@implementation ETTLocalMessageNotificationAbstract

-(instancetype)init
{
    if ([self isMemberOfClass:[ETTLocalMessageNotificationAbstract class]]) {
        NSLog(@"ETTLocalMessageNotificationAbstract is Abstract!");
        [self doesNotRecognizeSelector:_cmd];
        return nil;
    }else{
        self = [super init];
        if (self) {
            [self createLocationManager];
            return self;
        }
        return nil;
    }
}

-(void)registerUSERNotification
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"request authorization successed!");
        }
    }];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%@",settings);
    }];
}

-(void)presentLocalNotification:(NSString *)title message:(NSString *)message
{
    if (!title) {
        title = @"提示";
    }
    
    if (!message) {
        message = @"返回安学派";
    }
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification == nil) {
        return;
    }
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = message;
    localNotification.alertAction = title;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

-(void)createLocationManager
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
    if ([_locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
        [_locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    ///进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    ///进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)appResignActive
{
    NSLog(@"进入后台!");
    [[ETTRedisBasisManager sharedRedisManager]dataCodeing];
    [_locationManager startUpdatingLocation];
}

-(void)appBecomeActive
{
    NSLog(@"返回前台");
    [[ETTRedisBasisManager sharedRedisManager]redisDatarecovery];
    [_locationManager stopUpdatingLocation];
}

@end
