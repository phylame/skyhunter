//
//  PSHUserPlane.h
//  SkyHunter
//
//  Created by Peng Wan on 15-10-21.
//  Copyright (c) 2015年 Peng Wan. All rights reserved.
//

#import "PSHPlane.h"

@class PSHEnemy;

@interface PSHPlayer : PSHPlane

- (instancetype)initWithSuperBounds:(CGRect)bounds;

@property (nonatomic) NSUInteger score;

- (BOOL)testEnemyCrashAtSelf:(PSHEnemy*)enemy;

- (void)reset;

@end
