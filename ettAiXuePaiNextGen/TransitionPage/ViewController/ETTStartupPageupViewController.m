//
//  ETTStartupPageupViewController.m
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
//  Created by zhaiyingwei on 2017/1/6.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTStartupPageupViewController.h"

@interface ETTStartupPageupViewController ()
{
    CGRect  _textRect;
    CGRect  _titleRect;
}

/**
 *  @author LiuChuanan, 17-05-08 15:50:57
 *  
 *  @brief  属性的声明,修饰用的有错误,现更正过来.避免出现一些低级错误 15 16 17 18
 *
 *  branch  origin/bugfix/AIXUEPAIOS-1315
 *   
 *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
@property (nonatomic,strong) ETTImageView         *backgroundView;
@property (nonatomic,strong) ETTImageView         *titleImageView;
@property (nonatomic,strong) ETTImageView         *coveImageView;
@property (nonatomic,strong) ETTImageView         *textImageView;

@end


CGFloat titleEndTop = 250/2.0+80;
CGFloat titleBeginTop = 430;
CGFloat textBottom = 210;


@implementation ETTStartupPageupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    [self createUI];
}

-(void)createUI
{
    WS(weakSelf);
    
    CGRect appRect              = [UIScreen mainScreen].bounds;

    ETTImageView *backgrounIV   = [[ETTImageView alloc]initWithImage:[ETTImage imageNamed:@"startupPage_bg"]];
    [backgrounIV setFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:backgrounIV];
    _backgroundView             = backgrounIV;

    ETTImageView *textImageView = [[ETTImageView alloc]initWithImage:[ETTImage imageNamed:@"startupPage_text"]];
    CGSize oldTextSize          = textImageView.image.size;
    CGSize textSize             = CGSizeMake(oldTextSize.width/2.0, oldTextSize.height/2.0);
    [textImageView setFrame:CGRectMake((appRect.size.width-textSize.width)/2.0, appRect.size.height-textBottom, textSize.width, textSize.height)];
    _textRect                   = textImageView.frame;
    [backgrounIV addSubview:textImageView];
    _textImageView              = textImageView;

    ETTImageView *coveImageView = [[ETTImageView alloc]initWithImage:[ETTImage imageNamed:@"startupPage_cover"]];
    [coveImageView setFrame:textImageView.bounds];
    [textImageView addSubview:coveImageView];
    _coveImageView              = coveImageView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            coveImageView.frame = CGRectMake(textImageView.frame.size.width, 0, textImageView.size.width, textImageView.size.height);
        } completion:^(BOOL finished) {
            [weakSelf showNextPage];
        }];
    });


    ETTImageView *titleImageView = [[ETTImageView alloc]initWithImage:[ETTImage imageNamed:@"startupPage_title"]];
    CGSize oldTitleSize          = titleImageView.size;
    CGSize titleSize             = CGSizeMake(oldTitleSize.width/2.0, oldTitleSize.height/2.0);
    [titleImageView setFrame:CGRectMake((appRect.size.width-titleSize.width)/2.0, titleBeginTop, titleSize.width, titleSize.height)];
    _titleRect                   = titleImageView.frame;
    [backgrounIV addSubview:titleImageView];
    _backgroundView              = backgrounIV;
    [UIView animateWithDuration:0.8 animations:^{
        [titleImageView setFrame:CGRectMake((appRect.size.width-titleSize.width)/2.0, titleEndTop, titleSize.width, titleSize.height)];
        _titleImageView.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

-(void)showNextPage
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(didTheEndOfTheAnimationPlaybackWithConfics:)]) {
            [self.MDelegate didTheEndOfTheAnimationPlaybackWithConfics:YES];
        }
    });
}

@end
