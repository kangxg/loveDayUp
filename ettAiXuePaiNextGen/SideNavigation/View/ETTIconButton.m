//
//  ETTIconButton.m
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
//  Created by zhaiyingwei on 16/9/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTIconButton.h"

@interface ETTIconButton ()

@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userPhoto;

@property (nonatomic,weak) UIImageView  *iconImageView;

@end

@implementation ETTIconButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitle:@"XXX" forState:UIControlStateNormal];
        [self setTitleColor:kETTRGBCOLOR(144.0, 144.0, 144.0) forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:kTopIconDefaultImage] forState:UIControlStateNormal];
        self.imageView.clipsToBounds      = YES;
        self.imageView.layer.cornerRadius = 44;
        self.titleLabel.textAlignment     = NSTextAlignmentCenter;

        UIImageView *iconImageView        = [[UIImageView alloc]init];
        _iconImageView = iconImageView;
        
        [self updateAttribute];
    }
    return self;
}

//暂时不做，等扩充
-(void)rotateToLandscape:(BOOL)isLandscape
{
    self.width  = isLandscape ? kIconButtonLandscapeWidth : kIconButtonPortraitWH;
    self.height = isLandscape ? kIconButtonLandscapeHeight : kIconButtonPortraitWH;
    self.x      = (self.superview.width - self.width) * 0.5;
    self.y = kIconButtonY;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{

    if (self.width == self.height) {
        _iconImageView.frame = contentRect;
        return contentRect;
    } else {
        contentRect.size.height = contentRect.size.width;
        _iconImageView.frame = contentRect;
        return contentRect;
    }
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if (self.width == self.height) {
        return CGRectMake(0, 0, -1, -1);
    } else {
        contentRect.origin.y = contentRect.size.width;
        contentRect.size.height = kIconButtonLandscapeTitleH;
        return contentRect;
    }
}

-(instancetype)updateAttribute
{
    NSDictionary *allUSERDic = [NSDictionary dictionaryWithDictionary:[ETTUSERDefaultManager getUserTypeDictionary]];
    [ETTUSERDefaultManager getCurrentIdentity];
    if ([[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"teacher"]) {
        NSDictionary *teacherDic = [NSDictionary dictionaryWithDictionary:[allUSERDic objectForKey:@"teacher"]];
        [self setUserName:[teacherDic objectForKey:@"userName"]];
        [self setUserPhoto:[teacherDic objectForKey:@"userPhoto"]];
    }else{
        NSDictionary *studentDic = [NSDictionary dictionaryWithDictionary:[allUSERDic objectForKey:@"student"]];
        [self setUserName:[studentDic objectForKey:@"userName"]];
        [self setUserPhoto:[studentDic objectForKey:@"userPhoto"]];
    }
    return self;
}

-(void)setUserName:(NSString *)userName
{
    _userName  = userName;
    [self setTitle:userName forState:UIControlStateNormal];
}

-(void)setUserPhoto:(NSString *)userPhoto
{
    WS(weakSelf);
    _userPhoto = userPhoto;
    
    ////////////////////////////////////////////////////////
    /*
     new      : Create
     time     : 2017.4.17 15:30
     modifier : 康晓光
     version  ：Epic-0410-AIXUEPAIOS-1190
     branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     problem  : v新客户端问题修复（清空本地缓存）
     describe : 新登录用户图片没有更新问题
     */
    //    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:userPhoto] placeholderImage:[UIImage imageNamed:kTopIconDefaultImage]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //        if (image)
    //        {
    //            [ETTUSERDefaultManager setUSERMessageForIconImage:image];
    //            [weakSelf setImage:image forState:UIControlStateNormal];
    //        }
    //        else
    //        {
    //
    //            [ETTUSERDefaultManager setUSERMessageForIconImage:_iconImageView.image];
    //            [weakSelf setImage:_iconImageView.image forState:UIControlStateNormal];
    //
    //        }
    //    }];
    //
    
    
    //    if (_iconImageView.image) {
    //        [ETTUSERDefaultManager setUSERMessageForIconImage:_iconImageView.image];
    //    }
    //
    //    [self setImage:_iconImageView.image forState:UIControlStateNormal];
    /////////////////////////////////////////////////////
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:userPhoto]];
    _iconImageView.image = [UIImage imageWithData:data];
    [ETTUSERDefaultManager setUSERMessageForIconImage:_iconImageView.image];
    [weakSelf setImage:_iconImageView.image forState:UIControlStateNormal];

    

}

@end
