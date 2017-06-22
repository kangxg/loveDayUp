//
//  ETTRestoreRecessCommand.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/6.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

//CO_02 课件恢复

#import "ETTRestoreCommand.h"

/**
 Description  课间恢复命令父类
 */
@interface ETTRestoreRecessCommand : ETTRestoreCommand

@end



/**
 Description 课件恢复第一步  CO_02_state1
 */
@interface ETTRestoreRecessFirstStepCommand : ETTRestoreRecessCommand

@end



