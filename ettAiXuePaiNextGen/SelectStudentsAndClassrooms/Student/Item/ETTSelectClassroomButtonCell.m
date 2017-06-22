//
//  ETTSelectClassroomButton.m
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
//  Created by zhaiyingwei on 2016/10/11.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTSelectClassroomButtonCell.h"

@interface ETTSelectClassroomButtonCell ()

@property (nonatomic,assign)    ETTSelectClassroomButtonType    mType;
@property (nonatomic,strong)    ETTImageView                    *iconView;
@property (nonatomic,strong)    ETTLabel                        *titleLabel;

@property (nonatomic,strong)    UIColor                         *colorForBackgroundWithSelected;
@property (nonatomic,strong)    UIColor                         *colorForBackgroundWithUnSelected;
@property (nonatomic,strong)    UIColor                         *colorForTextWithSelected;
@property (nonatomic,strong)    UIColor                         *colorForTextWithUnSelected;

@end

@implementation ETTSelectClassroomButtonCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[[self updateAttributes]updateIcon]updateTitle];
    }
    return self;
}

-(instancetype)initWithModel:(ETTStudentSelectTeacherModel *)model
{
    _sModel = model;
    if (self = [super init]) {
        [[[self updateAttributes]updateIcon]updateTitle];
    }
    return self;
}

-(instancetype)updateAttributes
{
    self.colorForBackgroundWithSelected     = kETTRGBCOLOR(99.0, 181.0, 239.0);
    self.colorForTextWithSelected           = [UIColor whiteColor];
    self.colorForBackgroundWithUnSelected   = [UIColor whiteColor];
    self.colorForTextWithUnSelected         = kETTRGBCOLOR(160.0, 160.0, 160.0);
    
    self.layer.cornerRadius = 5.0;
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    if (self.sModel.selected) {
        [self setMType:ETTSelectClassroomButtonTypeSelected];
    }else{
        [self setMType:ETTSelectClassroomButtonTypeUnSelected];
    }
    
    return self;
}

-(instancetype)updateIcon
{
    ETTImageView *iconView = [[ETTImageView alloc]init];
    iconView.exclusiveTouch = NO;
    [iconView sd_setImageWithURL:[NSURL URLWithString:_sModel.iconURL] placeholderImage:[UIImage imageNamed:kTopIconDefaultImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    iconView.layer.cornerRadius = kSelectClassroomButtonIconSidelength/2.0;
    [self addSubview:iconView];
    _iconView = iconView;
    
    return self;
}

-(instancetype)updateTitle
{
    ETTLabel *titleLabel = [[ETTLabel alloc]init];
    [titleLabel setFont:[UIFont systemFontOfSize:14.0 weight:10]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    return self;
}

-(BOOL)setTitle:(NSString *)title
{
    if (title&&![title isEqualToString:@""]) {
        [_titleLabel setText:title];
        return YES;
    }else{
        return NO;
    }
}

-(void)setMType:(ETTSelectClassroomButtonType)mType
{
    _mType = mType;
    if (ETTSelectClassroomButtonTypeSelected == mType) {
        _sModel.selected = YES;
    }else if(ETTSelectClassroomButtonTypeUnSelected == mType){
        _sModel.selected = NO;
    }
    
    [self updateTitleColor:mType];
}

-(ETTSelectClassroomButtonType)getType
{
    return _mType;
}

-(instancetype)updateTitleColor:(ETTSelectClassroomButtonType)type
{
    if (ETTSelectClassroomButtonTypeSelected == type) {
        _titleLabel.backgroundColor = _colorForBackgroundWithSelected;
        _titleLabel.textColor       = _colorForTextWithSelected;
    }else if (ETTSelectClassroomButtonTypeUnSelected == type){
        _titleLabel.backgroundColor = _colorForBackgroundWithUnSelected;
        _titleLabel.textColor       = _colorForTextWithUnSelected;
    }
    
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchsBegan!");
    if (ETTSelectClassroomButtonTypeUnSelected == [self getType]) {
        [self setMType:ETTSelectClassroomButtonTypeSelected];
    }else if (ETTSelectClassroomButtonTypeSelected == [self getType]){
        [self setMType:ETTSelectClassroomButtonTypeUnSelected];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch end!!!!");
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    _iconView.frame = CGRectMake(self.width/2.0-kSelectClassroomButtonIconSidelength/2.0, kSelectClassroomButtonIconTopMargin, kSelectClassroomButtonIconSidelength, kSelectClassroomButtonIconSidelength);
    
    _titleLabel.frame = CGRectMake(0, self.height-kSelectClassroomConfirmBottomTitleHeight, self.width, kSelectClassroomConfirmBottomTitleHeight);
}

@end
