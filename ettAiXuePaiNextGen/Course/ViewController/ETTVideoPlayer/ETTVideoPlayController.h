//
//  SSVideoPlayController.h
//  SSVideoPlayer
//
//  Created by Mrss on 16/1/22.
//  Copyright © 2016年 expai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETTVideoModel : NSObject

@property (nonatomic,copy,readonly) NSString *path;
@property (nonatomic,copy,readonly) NSString *name;

- (instancetype)initWithName:(NSString *)name path:(NSString *)path;

@end


@interface ETTVideoPlayController : UIViewController

@property (nonatomic, copy) NSString *coursewareUrl;

@property (nonatomic, copy) NSString *titleString;//标题

- (instancetype)initWithVideoList:(NSArray <ETTVideoModel *> *)videoList;

@end
