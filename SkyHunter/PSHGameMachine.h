//
//  PSHGameMachine.h
//  SkyHunter
//
//  Created by Peng Wan on 15-10-21.
//  Copyright (c) 2015年 Peng Wan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;

@interface PSHGameMachine : NSObject

@property (nonatomic, readonly, getter=isStarted) BOOL started;
@property (nonatomic) NSUInteger level;

- (void)movedPlayer:(CGPoint)center;
- (void)destroy;

+ (PSHGameMachine*)startWithObject:(ViewController *)vc didBack:(SEL)selector;

@end
