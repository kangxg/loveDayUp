//
//  ETTSelectIdentityBackgroundView.m
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
//  Created by zhaiyingwei on 2016/10/10.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTSelectIdentityBackgroundView.h"

@interface ETTSelectIdentityBackgroundView ()

@property (nonatomic,strong)ETTLabel *titleLabel;

@property (nonatomic,strong)ETTSelectIdentityButtonView *selectTearcherIdentityBtn;
@property (nonatomic,strong)ETTSelectIdentityButtonView *selectStudentIdentityBtn;

@end


@implementation ETTSelectIdentityBackgroundView

-(instancetype)init
{
    if (self = [super init]) {
        [[[self upDateViewAttributes]updateSelectIdentityBtn]updateTitle];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[[self upDateViewAttributes]updateSelectIdentityBtn]updateTitle];
    }
    return self;
}

-(instancetype)upDateViewAttributes
{
    self.backgroundColor = kETTRGBCOLOR(233.0, 242.0, 248.0);

    return self;
}

-(instancetype)updateTitle
{
    ETTLabel *titleLabel     = [[ETTLabel alloc]init];
    titleLabel.text          = kTitleMessage;
    [titleLabel setTextColor:kETTRGBCOLOR(130.0, 130.0, 130.0)];
    [titleLabel setFont:[UIFont systemFontOfSize:20.0 weight:10.0]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    return self;
}

-(instancetype)updateSelectIdentityBtn
{
    ETTSelectIdentityButtonView *selectTearcherIdentityBtn = [[ETTSelectIdentityButtonView alloc]initWithType:ETTSelectIdentityButtonTypeTeacher];
    [self addSubview:selectTearcherIdentityBtn];
    selectTearcherIdentityBtn.MDelegate                    = self;
    _selectTearcherIdentityBtn                             = selectTearcherIdentityBtn;

    ETTSelectIdentityButtonView *selectStudentIdentityBtn  = [[ETTSelectIdentityButtonView alloc]initWithType:ETTSelectIdentityButtonTypeStudent];
    [self addSubview:selectStudentIdentityBtn];
    selectStudentIdentityBtn.MDelegate                     = self;
    _selectStudentIdentityBtn = selectStudentIdentityBtn;
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame                = CGRectMake(self.width/2.0-200.0/2.0, 25.0, 200, 50);

    CGFloat intervalH                = (self.frame.size.width - kIdentityButtonWidth * 2)/3.0;
    CGFloat intervalV                = (self.frame.size.height - kIdentityButtonHeight)/2.0;
    _selectTearcherIdentityBtn.frame = CGRectMake(intervalH, intervalV, kIdentityButtonWidth, kIdentityButtonHeight);
    _selectStudentIdentityBtn.frame = CGRectMake(intervalH*2.0+kIdentityButtonWidth, intervalV, kIdentityButtonWidth, kIdentityButtonHeight);
}

-(instancetype)gotoScenesForIdentity:(ETTSelectIdentityButtonType)type
{
    if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(clickItem:)]) {
        [self.MDelegate clickItem:type];
    }
    
    return self;
}

-(instancetype)gotoScenesForIdentityButton:(ETTSelectIdentityButtonView *)sender
{
    if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(clickItemForButton:)]) {
        [self.MDelegate clickItemForButton:sender];
    }
    
    return self;
}

#pragma mark - ETTSelectIdentityButtonDelegate
-(void)clickItem:(ETTSelectIdentityButtonView *)sender
{
    ETTSelectIdentityButtonView *selectIdentityBtn = (ETTSelectIdentityButtonView *)sender;
    [self gotoScenesForIdentityButton:sender];
    switch ([selectIdentityBtn getType]) {
        case ETTSelectIdentityButtonTypeTeacher:
            NSLog(@"点击老师！");
            break;
        case ETTSelectIdentityButtonTypeStudent:
            NSLog(@"点击学生!");
            break;
        default:
            break;
    }
}

@end
