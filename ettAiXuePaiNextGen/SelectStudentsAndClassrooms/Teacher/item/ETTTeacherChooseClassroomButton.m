//
//  ETTTeacherChooseClassroomButton.m
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
//  Created by zhaiyingwei on 2016/10/19.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherChooseClassroomButton.h"

@interface ETTTeacherChooseClassroomButton ()

@property (nonatomic,strong) ETTLabel                               *accountTypeLabel;
@property (nonatomic,strong) ETTLabel                               *classTypeLabel;

@property (nonatomic,assign) ETTTeacherChooseClassroomButtonType    mType;

@property (nonatomic,strong) UIColor                                *colorOfLabelTextForSelected;
@property (nonatomic,strong) UIColor                                *colorOfLabelTextForUnSelected;
@property (nonatomic,strong) UIColor                                *colorOfBackgroundForSelected;
@property (nonatomic,strong) UIColor                                *colorOfBackgroundForUnSelected;

@end

@implementation ETTTeacherChooseClassroomButton

@synthesize classroomModel      =       _classroomModel;
@synthesize indexPath           =       _indexPath;

-(instancetype)init
{
    if (self = [super init]) {
        [[[self updateAttributes]createUI]setMType:ETTTeacherChooseClassroomButtonTypeUnSelected];
    }
    
    return self;
}

-(instancetype)updateAttributes
{
    self.classroomModel = [ETTTeacherChooseClassroomModel new];
    
    _colorOfLabelTextForSelected = [UIColor whiteColor];
    _colorOfLabelTextForUnSelected = [UIColor grayColor];
    _colorOfBackgroundForSelected = kETTRGBCOLOR(99.0, 181.0, 239.0);
    _colorOfBackgroundForUnSelected = [UIColor whiteColor];
    
    self.backgroundColor = _colorOfBackgroundForUnSelected;
    
    self.layer.cornerRadius = 5.0;
    
    return self;
}

-(instancetype)createUI
{
    ETTLabel *accountTypeLabel = [[ETTLabel alloc]init];
    [accountTypeLabel setFont:[UIFont systemFontOfSize:kTeacherChooseClassroomButtonTitleTextSize weight:kTeacherChooseClassroomButtonTitleTextWeight]];
    [accountTypeLabel setTextAlignment:NSTextAlignmentCenter];
    [accountTypeLabel setTextColor:_colorOfLabelTextForUnSelected];
//    [self addSubview:accountTypeLabel];
    _accountTypeLabel = accountTypeLabel;
     
    ETTLabel *classTypeLabel = [[ETTLabel alloc]init];
    [classTypeLabel setFont:[UIFont systemFontOfSize:kTeacherChooseClassroomButtonTitleTextSize weight:kTeacherChooseClassroomButtonTitleTextWeight]];
    classTypeLabel.frame = CGRectMake(0, 0, self.width - 90, 0);
    classTypeLabel.numberOfLines = 0;
    [classTypeLabel setTextAlignment:NSTextAlignmentCenter];
    [classTypeLabel setTextColor:_colorOfLabelTextForUnSelected];
    classTypeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:classTypeLabel];
    _classTypeLabel = classTypeLabel;
    
    return self;
}

-(void)setClassroomModel:(ETTTeacherChooseClassroomModel *)classroomModel
{
    _classroomModel = classroomModel;
//    [_accountTypeLabel setText:self.classroomModel.classTag];
    if ([self.classroomModel.className isKindOfClass:[NSString class]]) {
        [_classTypeLabel setText:self.classroomModel.className];
        CGSize size = [_classTypeLabel sizeThatFits:CGSizeMake(_classTypeLabel.frame.size.width, MAXFLOAT)];
        _classTypeLabel.frame = CGRectMake(_classTypeLabel.frame.origin.x, _classTypeLabel.frame.origin.y, _classTypeLabel.frame.size.width, size.height);
        _classTypeLabel.center = self.center;
        
    }


}

-(void)setType:(ETTTeacherChooseClassroomButtonType)type
{
    _mType = type;
    [self changeColor:type];
}

-(void)changeType
{
    if (ETTTeacherChooseClassroomButtonTypeSelected == [self getType]) {
        [self setType:ETTTeacherChooseClassroomButtonTypeUnSelected];
    }else{
        [self setType:ETTTeacherChooseClassroomButtonTypeSelected];
    }
}

-(void)changeColor:(ETTTeacherChooseClassroomButtonType)type
{
    if (ETTTeacherChooseClassroomButtonTypeSelected == type) {
        self.backgroundColor = _colorOfBackgroundForSelected;
        [_accountTypeLabel setTextColor:_colorOfLabelTextForSelected];
        [_classTypeLabel setTextColor:_colorOfLabelTextForSelected];
    }else if (ETTTeacherChooseClassroomButtonTypeUnSelected == type)
    {
        self.backgroundColor = _colorOfBackgroundForUnSelected;
        [_accountTypeLabel setTextColor:_colorOfLabelTextForUnSelected];
        [_classTypeLabel setTextColor:_colorOfLabelTextForUnSelected];
    }
}

-(ETTTeacherChooseClassroomButtonType)getType
{
    return _mType;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    _accountTypeLabel.frame = CGRectMake(self.width/2.0-kTeacherChooseClassroomButtonTitleWidth/2.0, self.height/2.0-kTeacherChooseClassroomButtonTitleHeight, kTeacherChooseClassroomButtonTitleWidth, kTeacherChooseClassroomButtonTitleHeight);
//    _classTypeLabel.frame = CGRectMake(self.width/2.0-kTeacherChooseClassroomButtonTitleWidth/2.0, self.height/2.0, kTeacherChooseClassroomButtonTitleWidth, kTeacherChooseClassroomButtonTitleHeight);
}

@end
