//
//  NSObject+DelayedPerforming.m
//  BounceMenu
//
//  Created by Shingai Yoshimi on 8/31/13.
//  Copyright (c) 2013 Shingai Yoshimi. All rights reserved.
//

#import "NSObject+DelayedPerforming.h"

@implementation NSObject (DelayedPerforming)

- (void)performAfterDelay:(NSTimeInterval)delay blocks:(void (^)(void))blocks {
    [self performSelector:@selector(executeBlocks:) withObject:blocks afterDelay:delay];
}

- (void)executeBlocks:(void (^)(void))blocks {
    blocks();
}


@end