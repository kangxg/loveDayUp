//
//  ETTTakecareRegistrationModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/7.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"

/**
 Description  登记薄  进出院落登记信息
 */
@interface ETTTakecareRegistrationModel : ETTBaseModel
@property (nonatomic,assign)NSInteger   EDEmpo;
@property (nonatomic,assign)NSInteger   EDDoorplate;
-(void)resetTakecareRegistration;
@end
