//
//  PSHBomb.m
//  SkyHunter
//
//  Created by Peng Wan on 15-10-21.
//  Copyright (c) 2015年 Peng Wan. All rights reserved.
//

#import "PSHBomb.h"

@implementation PSHBomb

- (instancetype)init {
    self = [super initWithImage:[UIImage imageNamed:@"bomb.png"]];
    if (self) {
        self.frame = CGRectMake(0, 0, 10, 20);
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
