//
//  PSHUserPlane.m
//  SkyHunter
//
//  Created by Peng Wan on 15-10-21.
//  Copyright (c) 2015年 Peng Wan. All rights reserved.
//

#import "PSHPlayer.h"
#import "PSHEnemy.h"

#define PLAYER_WIDTH            70
#define PLAYER_HEIGHT           80
#define PLAYER_LEFT_FACTOR      -1.129
#define PLAYER_RIGHT_FACTOR     1.129

@implementation PSHPlayer {
    CGPoint _initCenter;
}

- (instancetype)initWithSuperBounds:(CGRect)bounds {
    self = [super init];
    if (self) {
        self.hitPoints = 800;
        self.damage = 200;
        self.frame = CGRectMake(0, 0, 70, 80);
        _initCenter = CGPointMake(bounds.size.width * 0.5, bounds.size.height - 41);;
        self.center = _initCenter;
        self.animationImages = @[
                                 [UIImage imageNamed:@"player1.png"],
                                 [UIImage imageNamed:@"player2.png"]
                                 ];
        self.animationDuration = 0.2;
        [self startAnimating];
    }
    return self;
}

- (void)reset {
    self.hitPoints = 800;
    self.score = 0;
    self.center = _initCenter;
}

- (BOOL)testEnemyCrashAtSelf:(PSHEnemy *)enemy {
    if (enemy.frame.origin.x + enemy.frame.size.width < self.frame.origin.x) {
        return NO;
    }
    if (enemy.frame.origin.x > self.frame.origin.x + self.frame.size.width) {
        return NO;
    }
    if (enemy.frame.origin.y + enemy.frame.size.height < self.frame.origin.y) {
        return NO;
    }
    if (enemy.frame.origin.y > self.frame.origin.y + self.frame.size.height) {
        return NO;
    }
    
    // a triangle and a triangle
    if (enemy.frame.origin.x >= self.center.x) {    // right of center
        return PLAYER_RIGHT_FACTOR * enemy.frame.origin.x + self.frame.origin.y <= enemy.frame.origin.y + 17;
    } else {  // left of center
        return PLAYER_LEFT_FACTOR * (enemy.frame.origin.x + self.frame.size.width) + self.frame.origin.y <= enemy.frame.origin.y + 17;
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
