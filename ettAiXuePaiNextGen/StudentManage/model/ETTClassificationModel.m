//
//  ETTClassificationModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTClassificationModel.h"

@implementation ETTClassificationModel
-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}
@end


//在线
@implementation ETTClassOnlineModel
-(id)init
{
    if (self = [super init])
    {
        self.classType = ETTCLASSTYPEONLINE;
        self.className = @"在线学生";
        self.onlineCount = 0;
    
    }
    return self;
}
@end
//旁听
@implementation ETTClassAttendModel
-(id)init
{
    if (self = [super init])
    {
        self.classType = ETTCLASSTYPEATTEND;
        self.className = @"旁听";
        self.studentCount = 0;
        
    }
    return self;
}
@end
//创建的班级
@implementation ETTClassEstablishModel
-(id)init
{
    if (self = [super init])
    {
        self.classType    = ETTCLASSESTABLISH;
        self.studentCount = 0;
        self.onlineCount  = 0;
        
    }
    return self;
}
@end
