//
//  NSObject+DelayedPerforming.h
//  BounceMenu
//
//  Created by Shingai Yoshimi on 8/31/13.
//  Copyright (c) 2013 Shingai Yoshimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DelayedPerforming)

- (void)performAfterDelay:(NSTimeInterval)delay blocks:(void (^)(void))blocks;

@end
