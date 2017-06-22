//
//  ETTClassUserCell.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/20.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTCollectionViewCell.h"

@interface ETTClassUserCell : ETTCollectionViewCell
-(void)setUserModel:(id)userModel;

-(void)setUserModel:(id)userModel lockScreen:(BOOL)isLock;
@end
