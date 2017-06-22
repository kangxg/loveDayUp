//
//  ETTRestoreCommand.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/6.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"
#import "ETTCommandInterface.h"
#import "ETTDisasterListingModel.h"
@interface ETTRestoreCommand : ETTBaseModel<ETTCommandInterface>
@property (nonatomic,copy)NSString         * EDCommandIdentity;

@property (nonatomic,retain)ETTDisasterListingModel * EDListModel;
+(instancetype )createCommand:(id<ETTCommandInterface>)manager
          withEntity:(id<ETTPerformEntityInterface>)entity
            withlist:(ETTDisasterListingModel *)model;
;

-(void)init:(id<ETTCommandInterface>)manager
withEntity:(id<ETTPerformEntityInterface>)entity
withlist:(ETTDisasterListingModel *)model;
-(void)feedbackError:(ETTTaskOperationState  )state;
-(void)pretreatmentRestoreCommand;
-(void)initData;
@end


