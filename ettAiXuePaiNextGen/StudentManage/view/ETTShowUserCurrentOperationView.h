//
//  ETTShowUserCurrentOperationView.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/22.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTView.h"

@interface ETTShowUserCurrentOperationView : ETTView
-(id)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName;
-(id)initWithFrame:(CGRect)frame withImag:(UIImage  *)image;
-(void)reloadView:(NSString *)imageNmae;
@end
