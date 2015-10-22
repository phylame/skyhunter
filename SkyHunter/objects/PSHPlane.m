//
//  PSHPlane.m
//  SkyHunter
//
//  Created by Peng Wan on 15-10-21.
//  Copyright (c) 2015年 Peng Wan. All rights reserved.
//

#import "PSHPlane.h"
#import "PSHBomb.h"

inline BOOL pointIsTopOfLine(CGFloat pointX, CGFloat pointY,
                      CGFloat startX, CGFloat startY, CGFloat endX, CGFloat endY) {
    return pointX * ((endY - startY) / (endX - startX)) > pointY;
}

@implementation PSHPlane

- (PSHBomb*)shootBombWithDamage:(NSUInteger)damage {
    PSHBomb *bomb = [PSHBomb new];
    bomb.damage = damage;
    
    CGPoint center = CGPointMake(self.frame.origin.x + self.frame.size.width * 0.5, 0);
    if (self.ySpeed <= 0) {  // move to top or stay
        bomb.ySpeed = -2.1;
        center.y = self.frame.origin.y - 6;
    } else {                // move to buttom
        bomb.ySpeed = 2.1;
        center.y = self.frame.origin.y + self.frame.size.height + 6;
    }
    bomb.center = center;
    
    return bomb;
}

- (BOOL)testBombShootAtSelf:(PSHBomb *)bomb {
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
