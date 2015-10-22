//
//  PSHEmemyPlane.h
//  SkyHunter
//
//  Created by Peng Wan on 15-10-21.
//  Copyright (c) 2015年 Peng Wan. All rights reserved.
//

#import "PSHPlane.h"

@interface PSHEnemy : PSHPlane

@property (nonatomic) int destroyState;
@property (nonatomic) NSUInteger reward;

- (instancetype)initWithSuperBounds:(CGRect)bounds;

@end
