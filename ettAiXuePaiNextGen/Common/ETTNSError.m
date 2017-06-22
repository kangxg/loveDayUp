//
//  ETTNSError.m
//  ettNextGen
//
//  Created by Bin Lee on 7/12/15.
//  Copyright (c) 2015 Etiantian. All rights reserved.
//

#import "ETTNSError.h"

@implementation ETTNSError
@synthesize err, errorType;

- (instancetype)initWithNSError:(NSError *)aErr {
    self = [super init];
    if (self) {
        self.err = [aErr copy];
        err = 0;
    }
    return self;
}
@end
