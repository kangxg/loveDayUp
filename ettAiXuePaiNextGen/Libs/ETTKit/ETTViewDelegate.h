//
//  ETTViewDelegate.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ETTViewDelegate <NSObject>
@optional
-(void)pEvenHandler:(id)object;
-(void)pEvenHandler:(id)object withCommandType:(NSInteger)commandType;
//用于页面切换
-(void)pEvenChangeViewHandler:(id)object withCommandType:(NSInteger)commandType;

//用户功能操作
-(void)pEvenFunctionOperation:(id)object  withCommandType:(NSInteger)commandType withInfo:(id)sender;


-(void)pEvenCloseView:(id)object;

-(NSString *)pGetDataMark:(id)object;

-(void)pViewSelected:(id)object;

-(NSArray *)pGetDataSource:(id)object;

@end

