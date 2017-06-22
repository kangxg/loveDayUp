//
//  ETTManageVCInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ETTViewController;
@protocol ETTManageVCInterface <NSObject>

-(void)manageViewControllerClose:(ETTViewController *)VCTR withCommond:(NSInteger)commondType;
-(void)manageViewControllerClose:(ETTViewController *)VCTR withCommond:(NSInteger)commondType withInfo:(id)object;

-(void)managePushViewController:(ETTViewController *)viewController animated:(BOOL)animated;
-(void)managePresentViewController:(ETTViewController *)viewController animated:(BOOL)animated;

-(void)managePresentViewController:(ETTViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

-(void)managePopViewController:(ETTViewController *)viewController animated:(BOOL)animated;

-(void)manageDimissViewController:(ETTViewController *)viewController animated:(BOOL)animated;

-(void)manageViewDataOperation:(id)data;


@end
