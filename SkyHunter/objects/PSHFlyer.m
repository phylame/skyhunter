//
//  PSHFlyer.m
//  SkyHunter
//
//  Created by Peng Wan on 15-10-21.
//  Copyright (c) 2015年 Peng Wan. All rights reserved.
//

#import "PSHFlyer.h"

@implementation PSHFlyer

- (void)move {
    CGPoint center = self.center;
    center.x += self.xSpeed;
    center.y += self.ySpeed;
    self.center = center;
}

- (BOOL)removeSelfIfOutOfBounds {
    CGRect superBounds = self.superview.bounds, frame = self.frame;
    BOOL reachedBounds = NO;
    if (self.xSpeed < 0 && (frame.origin.x + frame.size.width) <= 0) {  // move to left
        reachedBounds = YES;
    } else if (self.xSpeed > 0 && frame.origin.x >= superBounds.size.width) {   // move to right
        reachedBounds = YES;
    }
    if (!reachedBounds) {
        if (self.ySpeed < 0 && (frame.origin.y + frame.size.height) <= 0) {  // move to top
            reachedBounds = YES;
        } else if (self.ySpeed > 0 && frame.origin.y >= superBounds.size.height) {   // move to buttom
            reachedBounds = YES;
        }
    }
    if (reachedBounds) {
        [self removeFromSuperview];
    }
    return reachedBounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
