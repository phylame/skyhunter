//
//  PSHPlane.h
//  SkyHunter
//
//  Created by Peng Wan on 15-10-21.
//  Copyright (c) 2015年 Peng Wan. All rights reserved.
//

#import "PSHWeapon.h"

@class PSHBomb;

extern BOOL pointIsTopOfLine(CGFloat pointX, CGFloat pointY,
                      CGFloat startX, CGFloat startY, CGFloat endX, CGFloat endY);

@interface PSHPlane : PSHWeapon

@property (nonatomic) NSInteger hitPoints;

- (PSHBomb*)shootBombWithDamage:(NSUInteger)damage;

- (BOOL)testBombShootAtSelf:(PSHBomb*)bomb;

@end
