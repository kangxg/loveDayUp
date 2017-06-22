//
//	ReaderViewController.h
//	Reader v2.8.6
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2015 Julius Oklamcak. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "ReaderDocument.h"
#import "ReaderMainToolbar.h"
#import "ReaderMainPagebar.h"
#import "ETTPushMProgressBarView.h"

@class ReaderViewController;

@protocol ReaderViewControllerDelegate <NSObject>

@optional // Delegate protocols

- (void)dismissReaderViewController:(ReaderViewController *)viewController;

@end

@interface ReaderViewController : ETTViewController

@property (nonatomic, weak, readwrite) id <ReaderViewControllerDelegate> delegate;

@property (copy, nonatomic  ) NSString                *navigationTitle;

@property (copy, nonatomic  ) NSString                *coursewareID;

@property (copy, nonatomic  ) NSString                *courseId;

@property (copy, nonatomic  ) NSString                *coursewareUrl;

@property (strong, nonatomic) ReaderMainToolbar       *mainToolbar;//顶部导航栏

@property (strong, nonatomic) ReaderMainPagebar       *mainPagebar;//下面缩略图预览栏

@property (strong, nonatomic) ETTPushMProgressBarView *pushProgressView;

@property (assign, nonatomic) NSInteger               pushedCurrentPage;

@property (assign, nonatomic) BOOL                    isAgainPushCourseware;

@property (assign, nonatomic) BOOL isReopen;//是否是重新打开

- (instancetype)initWithReaderDocument:(ReaderDocument *)object;
- (void)showDocumentPage:(NSInteger)page;


@end
