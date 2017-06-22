//
//  ETTRemindDelegate.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ETTRemindDelegate <NSObject>
@optional
-(NSInteger )pGetRemindCount;
-(NSInteger )pGetRemindCount:(id)sender;
-(void)pRemoveRemindView;

-(void)pRemoveRemindView:(id)sender;
@end
