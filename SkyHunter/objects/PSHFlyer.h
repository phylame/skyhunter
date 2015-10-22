//
//  PSHFlyer.h
//  SkyHunter
//
//  Created by Peng Wan on 15-10-21.
//  Copyright (c) 2015年 Peng Wan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSHFlyer : UIImageView

@property (nonatomic) CGFloat xSpeed;
@property (nonatomic) CGFloat ySpeed;

- (BOOL)removeSelfIfOutOfBounds;
- (void)move;

@end
