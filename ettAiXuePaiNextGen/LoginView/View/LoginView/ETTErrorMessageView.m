//
//  ETTErrorMessageView.m
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
//  Created by zhaiyingwei on 16/9/30.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTErrorMessageView.h"

@interface ETTErrorMessageView ()

/**
 *  错误提示信息
 */
 
/**
*  @author LiuChuanan, 17-05-08 16:20:57
*  
*  @brief  属性的声明,修饰用的有错误,现更正过来.避免出现一些低级错误 19 20
*
*  branch  origin/bugfix/AIXUEPAIOS-1315
*   
*  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
* 
*  @since 
*/
@property (nonatomic,copy) NSString *messageStr;

@property (nonatomic,strong) ETTLabel *messageLabel;

@property (nonatomic,assign) ETTErrorMessageType errorMessageType;

@end

@implementation ETTErrorMessageView

-(instancetype)init
{
    if (self = [super init]) {
        [[[self setAttributes]createUI]setETTErrorMessageType:ETTErrorMessageTypeHide];
    }
    return self;
}

-(instancetype)setAttributes
{
    self.backgroundColor        = kETTRGBCOLOR(239.0, 243.0, 248.0);
    self.layer.cornerRadius     = kLoginCornerRadius;
    self.userInteractionEnabled = NO;
    self.clipsToBounds          = YES;
    self.layer.masksToBounds    = YES;
    self.alpha                  = 0;
    return self;
}

-(instancetype)createUI
{
    ETTLabel *messageLabel = [[ETTLabel alloc]initWithFrame:CGRectZero];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setTextColor:[UIColor colorWithRed:236.0/255.0 green:71.0/255.0 blue:87.0/255.0 alpha:1.0]];
    messageLabel.font      = [UIFont systemFontOfSize:18.0];
    [self addSubview:messageLabel];
    _messageLabel = messageLabel;
    
    return self;
}

-(instancetype)setMessage:(NSString *)messageStr
{
    [_messageLabel setText:messageStr];
    
    return self;
}

-(void)setETTErrorMessageType:(ETTErrorMessageType)type
{
    _errorMessageType = type;
}

-(instancetype)showErrorMessage:(NSString *)messageStr
{
    [self setMessage:messageStr];
    if (ETTErrorMessageTypeHide == [self getETTErrorMessageType]) {
        [self moveMessageView];
    }
    
    return self;
}

-(instancetype)moveMessageView
{
    CGFloat typeFloat;
    if (ETTErrorMessageTypeHide == [self getETTErrorMessageType]) {
        typeFloat = -1;
    }else if(ETTErrorMessageTypeDisplay == [self getETTErrorMessageType]){
        typeFloat = 1;
    }
    
    [ETTView animateWithDuration:kShowErrorMessageTime animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + kErrorMessageViewHeight*typeFloat, self.frame.size.width, self.frame.size.height);
        self.alpha = self.alpha - typeFloat;
        [self setETTErrorMessageType:ETTErrorMessageTypeMoving];
    } completion:^(BOOL finished) {
        NSLog(@"message frame is %lf  %lf",_messageLabel.frame.size.width,_messageLabel.frame.size.height);
        [self changeType:typeFloat];
    }];
    
    return self;
}

-(instancetype)changeType:(CGFloat)type
{
    if (-1 == type) {
        [self setETTErrorMessageType:ETTErrorMessageTypeDisplay];
    }else if (1 == type){
        [self setETTErrorMessageType:ETTErrorMessageTypeHide];
    }
    [self judgmentStatus];
    return self;
}

-(instancetype)judgmentStatus
{
    if (ETTErrorMessageTypeDisplay == [self getETTErrorMessageType]) {
        dispatch_queue_t queue = dispatch_queue_create("etiantian", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            NSLog(@"this thread is %@",[NSThread currentThread]);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kErrorStayTime*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"getMain this thread is %@",[NSThread currentThread]);
                [self moveMessageView];
            });
        });
    }
    
    return self;
}

-(ETTErrorMessageType)getETTErrorMessageType
{
    return _errorMessageType;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setFrame:CGRectMake(0, self.superview.frame.size.height, self.superview.frame.size.width, kErrorMessageViewHeight)];
    _messageLabel.frame = self.bounds;
}

@end
