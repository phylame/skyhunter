//
//  PSHEmemyPlane.m
//  SkyHunter
//
//  Created by Peng Wan on 15-10-21.
//  Copyright (c) 2015年 Peng Wan. All rights reserved.
//

#import "PSHEnemy.h"
#import "PSHBomb.h"

#define ENEMY_WIDTH             42
#define ENEMY_HEIGHT            30
#define ENEMY_LEFT_FACTOR       1.5385
#define ENEMY_RIGHT_FACTOR      -1.5385

@implementation PSHEnemy

- (instancetype)initWithSuperBounds:(CGRect)bounds {
    self = [super initWithImage:[UIImage imageNamed:@"enemy.png"]];
    if (self) {
        self.hitPoints = 100;
        self.damage = 100;
        self.reward = 100;
        self.ySpeed = 2.3;
        int rand = arc4random() % 100;
        if (rand < 50) {
            self.xSpeed = rand / 300.0;
        } else {
            self.xSpeed = - (rand - 50) / 300.0;
        }
        CGFloat x = arc4random() % ((int)(bounds.size.width-ENEMY_WIDTH));
        self.frame = CGRectMake(x, -ENEMY_HEIGHT + 10, ENEMY_WIDTH, ENEMY_HEIGHT);
        self.destroyState = 0;
    }
    return self;
}

- (BOOL)testBombShootAtSelf:(PSHBomb*)bomb {
    if (bomb.frame.origin.x + bomb.frame.size.width < self.frame.origin.x) {
        return NO;
    }
    if (bomb.frame.origin.x > self.frame.origin.x + self.frame.size.width) {
        return NO;
    }
    if (bomb.frame.origin.y + bomb.frame.size.height < self.frame.origin.y) {
        return NO;
    }
    if (bomb.frame.origin.y > self.frame.origin.y + self.frame.size.height) {
        return NO;
    }
    
    // a triangle
    if (bomb.frame.origin.x >= self.center.x) {    // right of center
        return ENEMY_RIGHT_FACTOR * bomb.frame.origin.x + self.frame.origin.y >= bomb.frame.origin.y;
    } else {  // left of center
        return ENEMY_LEFT_FACTOR * (bomb.frame.origin.x + bomb.frame.size.width) + self.frame.origin.y >= bomb.frame.origin.y;
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
