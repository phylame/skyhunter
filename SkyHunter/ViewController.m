//
//  ViewController.m
//  SkyHunter
//
//  Created by Peng Wan on 15-10-21.
//  Copyright (c) 2015年 Peng Wan. All rights reserved.
//

#import "ViewController.h"
#import "PSHGameMachine.h"

@interface ViewController () {
    UIImageView *_ivBackground;
    PSHGameMachine *_gm;
}

@end

@implementation ViewController

- (void)gameExited {
    NSLog(@"game exited");
    [self removeAllViews];
    [self createMenuPage];
}

- (void)buttonClicked:(UIButton *)button {
    switch (button.tag) {
        case 11:
            // start game
        {
            [self removeAllViews];
            _gm = [PSHGameMachine startWithObject:self didBack:@selector(gameExited)];
        }
            break;
        case 12:
            // app options
        {
            [self removeAllViews];
            [self createOptionsPage];
        }
            break;
        case 13:
            // about app
        {
            [self removeAllViews];
            [self createAboutPage];
        }
            break;
        case 10:
            // back to menu
        {
            // from game
            if (_gm != nil) {
                [_gm destroy];
                _gm = nil;
            }
            [self removeAllViews];
            [self createMenuPage];
        }
            break;
        default:
            break;
    }
}

- (void)createMenuPage {
    [self createCommonBackground];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * 0.75, 40)];
    label.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.2);
    label.text = @"Sky Hunter";
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont italicSystemFontOfSize:38];
    [self.view addSubview:label];
    
    NSArray *titles = @[@"Start", @"Options", @"About"];
    CGFloat width = self.view.bounds.size.width * 0.75, height = 39;
    CGFloat x = self.view.bounds.size.width * 0.5;
    CGFloat y = self.view.bounds.size.height * 0.45;
    UIFont *font = [UIFont boldSystemFontOfSize:height - 6];
    UIColor *color = [UIColor yellowColor];
    for (int i = 0; i < titles.count; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 11 + i;
        button.frame = CGRectMake(0, 0, width, height);
        button.center = CGPointMake(x, y);
        y += height * 1.4;
        button.titleLabel.font = font;
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)createOptionsPage {
    [self createCommonBackground];
    [self createBackToMenuButton];
}

- (void)createAboutPage {
    [self createCommonBackground];
    [self createBackToMenuButton];
    
    NSArray *strings = @[
                         @"Sky Hunter",
                         @"version: 1.0",
                         @"author: Peng Wan",
                         @"email: phylame@163.com",
                         @"(C) 2015 PW. All rights reserved."
                         ];
    CGFloat x = self.view.bounds.size.width * 0.5;
    CGFloat y = self.view.bounds.size.height * 0.33;
    UIFont *font = [UIFont systemFontOfSize:18];
    UIColor *color = [UIColor greenColor];
    for (int i = 0; i < strings.count; ++i) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * 0.85, 23)];
        label.center = CGPointMake(x, y);
        y += 30;
        label.text = strings[i];
        label.font = font;
        label.textColor = color;
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
}

- (void)createCommonBackground {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.view addSubview:_ivBackground];
}

- (void)createBackToMenuButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tag = 10;
    button.frame = CGRectMake(15, 26, 30, 20);
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)removeAllViews {
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // not start
    if (!_gm || !_gm.started) {
        return;
    }
    UITouch *touch = [touches anyObject];
    [_gm movedPlayer:[touch locationInView:self.view]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ivBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_bg.png"]];
    _ivBackground.frame = self.view.bounds;
    
    // show menu
    [self createMenuPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
