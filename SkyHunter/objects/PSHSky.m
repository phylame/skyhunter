//
//  PSHSky.m
//  SkyHunter
//
//  Created by Peng Wan on 15-10-21.
//  Copyright (c) 2015年 Peng Wan. All rights reserved.
//

#import "PSHSky.h"

@implementation PSHSky

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"sky.png"];
        self.ySpeed = 1.5;
    }
    return self;
}

- (void)move {
    [super move];
    CGRect frame = self.frame;
    if (frame.origin.y >= self.superview.bounds.size.height) {
        frame.origin.y -= frame.size.height * 2;
        self.frame = frame;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
