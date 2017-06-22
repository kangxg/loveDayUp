//
//  ETTClassUserListHeaderView.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/20.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTCollectionReusableView.h"
#import "DefineBlock.h"
@class ETTClasssGroupModel;
@interface ETTClassUserListHeaderView : ETTCollectionReusableView
-(void)setHeadViewMessage:(ETTClasssGroupModel *)groupModel   withClick:(ETTCallbackBlock)block ;
@end
