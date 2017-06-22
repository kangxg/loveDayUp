//
//  ETTCollectionViewCell.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
////////////////////////////////////////////////////////
/*
 new      : add
 time     : 2017.4.1  15:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: UICollectionViewCell 代理协议
 */


@protocol  ETTCollectionViewCellDelegate <NSObject>
@optional
-(void)pCellEventHandle:(UICollectionViewCell *)cell withEvenType:(NSInteger )evenType withInfo:(id)info;
@end


@interface ETTCollectionViewCell : UICollectionViewCell
////////////////////////////////////////////////////////
/*
 new      : add
 time     : 2017.4.1  15:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: UICollectionViewCell 代理协议
 */
@property(nonatomic,weak)id<ETTCollectionViewCellDelegate> EVDelegate;
////////////////////////////////////////////////////////
@end
