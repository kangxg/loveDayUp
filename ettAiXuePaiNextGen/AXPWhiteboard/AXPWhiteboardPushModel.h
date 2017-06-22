//
//  AXPWhiteboardPushModel.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/31.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXPWhiteboardPushModel : NSObject

@property(nonatomic ) BOOL isLock;

@property(nonatomic ,copy) NSString *state;

@property(nonatomic ,copy) NSString *wbImg;

+(instancetype)modelWithDict:(NSDictionary *)dict;

@end
