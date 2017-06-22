//
//  ETTClassUserModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"
#import "ETTStudentManageEnum.h"
@interface ETTClassUserModel : ETTBaseModel<NSCopying>
//用户id
@property (nonatomic,copy)NSString  *  jid;
//用户名
@property (nonatomic,copy)NSString  *  userName;
//用户照片
@property (nonatomic,copy)NSString  *  userPhoto;
//课堂表现得分
@property (nonatomic,copy)NSString  *  showScore;
//最后得分时间
@property (nonatomic,copy)NSString  *  lastScoreTime;

@property (nonatomic,assign)ETTClassType        userType;

@property (nonatomic,assign)BOOL        isOnline;
//奖励得分
@property (nonatomic,assign)NSInteger   rewardScore;
//answerCount
@property (nonatomic,assign)NSInteger   answerCount;
//rollCallCount
@property (nonatomic,assign)NSInteger   rollCallCount;
//remindCount
@property (nonatomic,assign)NSInteger   remindCount;


-(NSDictionary  *)getUserIntegral;
@end


@interface ETTAttendUserModel : ETTClassUserModel

@end

@interface ETTResponderModel  : ETTClassUserModel
@property (nonatomic,copy)NSString  * time;
@end


@interface ETTStuPerforemanceUserModel : ETTClassUserModel
//奖励得分 累计
@property (nonatomic,assign)NSInteger   rewardScoreSum;
//抢答 累计
@property (nonatomic,assign)NSInteger   answerSum;
//点名 累计
@property (nonatomic,assign)NSInteger   rollCallSum;
//提醒 累计
@property (nonatomic,assign)NSInteger   remindSum;
@end
