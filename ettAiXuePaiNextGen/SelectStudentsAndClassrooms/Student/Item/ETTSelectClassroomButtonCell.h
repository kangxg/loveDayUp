//
//  ETTSelectClassroomButton.h
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

#import <UIKit/UIKit.h>
#import "ETTKit.h"
#import "ETTStudentSelectTeacherConst.h"
#import "ETTStudentSelectTeacherModel.h"
#import "SidNavigationConst.h"
#import <SDWebImage/UIImageView+WebCache.h>

typedef NS_ENUM(NSInteger,ETTSelectClassroomButtonType)
{
    /**
     *  按钮被选中
     */
    ETTSelectClassroomButtonTypeSelected = 0,
    /**
     *  按钮未被选中
     */
    ETTSelectClassroomButtonTypeUnSelected
};

@class ETTSelectClassroomButtonCell;
@protocol ETTSelectClassroomButtonDelegate <NSObject>

@optional
/**
 *  按钮点击时触发
 *
 *  @param sender 按钮自身
 */
-(void)clickItem:(ETTSelectClassroomButtonCell *)sender;

@end

@interface ETTSelectClassroomButtonCell : UICollectionViewCell

@property (nonatomic,weak)id<ETTSelectClassroomButtonDelegate> MDelegate;
@property (nonatomic,strong)    ETTStudentSelectTeacherModel    *sModel;

-(instancetype)initWithModel:(ETTStudentSelectTeacherModel *)model;

/*
 * 设置按钮当前状态
 */
-(void)setMType:(ETTSelectClassroomButtonType)mType;
/**
 *  获取按钮当前状态
 *
 *  @return 按钮的当前状态
 */
-(ETTSelectClassroomButtonType)getType;

/*
 *  设置title显示的文字
 *
 *  @return 如何设置成功返回YES,否则返回NO.
 */
-(BOOL)setTitle:(NSString *)title;

@end