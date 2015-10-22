//
//  PSHGameMachine.m
//  SkyHunter
//
//  Created by Peng Wan on 15-10-21.
//  Copyright (c) 2015年 Peng Wan. All rights reserved.
//

#import "PSHGameMachine.h"
#import "ViewController.h"
#import "PSHSky.h"
#import "PSHPlayer.h"
#import "PSHEnemy.h"
#import "PSHBomb.h"

typedef NS_ENUM(NSUInteger, PSHGameState) {
    PSHGameStatePause,
    PSHGameStateStart,
    PSHGameStateDead,
};

@interface PSHGameMachine () {
    __weak ViewController *_viewController;
    SEL _didBack;
    NSTimer *_timer;
    
    NSMutableArray *_flyers;
    PSHPlayer *_player;
    NSMutableArray *_enemies;
    NSMutableArray *_bombs;
    NSMutableArray *_shotEnemies;
    
    UILabel *lbScore;
    UILabel *lbHitPoints;
    UILabel *lbGameOver;
    
    UIImage *_imgPlay;
    UIImage *_imgPause;
    
    UIButton *btnStart;
}

@property (nonatomic) PSHGameState gameState;

@end

@implementation PSHGameMachine

- (void)destroy {
    [_timer invalidate];
    [_flyers removeAllObjects];
    [_enemies removeAllObjects];
    [_bombs removeAllObjects];
    [_shotEnemies removeAllObjects];
}

- (void)initGame {
    self.gameState = PSHGameStatePause;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self createSky];
    [self createButtons];
    [self createScoreLabel];
    [self createPlayerPlane];
    [self createPlayerHitPoints];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.007
                                              target:self
                                            selector:@selector(gameLoop)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)createSky {
    PSHSky *sky = [[PSHSky alloc] initWithFrame:_viewController.view.bounds];
    [_viewController.view addSubview:sky];
    [_flyers addObject:sky];
    
    CGRect frame = _viewController.view.bounds;
    frame.origin.y = - frame.size.height;
    sky = [[PSHSky alloc] initWithFrame:frame];
    [_viewController.view addSubview:sky];
    [_flyers addObject:sky];
}

- (void)createButtons {
    [_viewController createBackToMenuButton];
    
    btnStart = [UIButton buttonWithType:UIButtonTypeSystem];
    btnStart.tag = 22;
    btnStart.frame = CGRectMake(_viewController.view.bounds.size.width - 35, 26, 20, 30);
    _imgPlay = [UIImage imageNamed:@"play.png"];
    [btnStart setImage:_imgPlay forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(buttonClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [_viewController.view addSubview:btnStart];
}

- (void)createScoreLabel {
    CGRect frame = CGRectMake(4, _viewController.view.bounds.size.height - 22,
                              _viewController.view.bounds.size.width * 0.5, 20);
    lbScore = [[UILabel alloc] initWithFrame:frame];
    lbScore.textColor = [UIColor redColor];
    lbScore.font = [UIFont boldSystemFontOfSize:18];
    [_viewController.view addSubview:lbScore];
    [self updateScore];
}

- (void)createPlayerPlane {
    _player = [[PSHPlayer alloc] initWithSuperBounds:_viewController.view.bounds];
    [_viewController.view addSubview:_player];
}

- (void)createPlayerHitPoints {
    CGRect frame = CGRectMake(0, 0, _viewController.view.bounds.size.width * 0.5, 20);
    frame.origin.x = _viewController.view.bounds.size.width - frame.size.width - 4;
    frame.origin.y = _viewController.view.bounds.size.height - frame.size.height - 2;
    lbHitPoints = [[UILabel alloc] initWithFrame:frame];
    lbHitPoints.textAlignment = NSTextAlignmentRight;
    lbHitPoints.textColor = [UIColor purpleColor];
    lbHitPoints.font = [UIFont boldSystemFontOfSize:18];
    [_viewController.view addSubview:lbHitPoints];
    [self updatePlayerHitPoints];
}

- (void)updateScore {
    lbScore.text = [NSString stringWithFormat:@"Score: %lu", (unsigned long)_player.score];
}

- (void)updatePlayerHitPoints {
    lbHitPoints.text = [NSString stringWithFormat:@"HP: %ld", (long)_player.hitPoints];
}

- (void)moveFlyers {
    for (PSHFlyer *flyer in _flyers) {
        [flyer move];
    }
}

- (void)enemyWasShot:(PSHEnemy*)enemy bomb:(PSHBomb*)bomb {
    [_shotEnemies addObject:enemy];
    [_enemies removeObject:enemy];
    if (bomb) {
        [bomb removeFromSuperview];
        [_bombs removeObject:bomb];
    }
    // destroyed by player plane
}

- (void)playerWasCrashed {
    self.gameState = PSHGameStateDead;
    lbGameOver = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _viewController.view.bounds.size.width, 40)];
    lbGameOver.center = _viewController.view.center;
    lbGameOver.text = @"Game Over";
    lbGameOver.textAlignment = NSTextAlignmentCenter;
    lbGameOver.font = [UIFont boldSystemFontOfSize:38];
    lbGameOver.textColor = [UIColor redColor];
    [_viewController.view addSubview:lbGameOver];
    
    [btnStart setImage:_imgPlay forState:UIControlStateNormal];
}

- (void)updateShotEnemies {
    for (int i = 0; i < _shotEnemies.count; ++i) {
        PSHEnemy *enemy = _shotEnemies[i];
        switch (enemy.destroyState) {
            case 0:
            {
                enemy.image = [UIImage imageNamed:@"boom_enemy1.png"];
                enemy.destroyState = 1;
            }
                break;
            case 1:
            {
                enemy.image = [UIImage imageNamed:@"boom_enemy2.png"];
                enemy.destroyState = 2;
            }
                break;
            case 2:
            {
                enemy.image = [UIImage imageNamed:@"boom_enemy3.png"];
                enemy.destroyState = 3;
            }
                break;
            default:
            {
                [enemy removeFromSuperview];
                [_shotEnemies removeObject:enemy];
                _player.score += enemy.reward;
                [self updateScore];
            }
                break;
        }
    }
}

- (void)shootAndCheck {
    [self updateShotEnemies];
    
    static int count = 0;
    BOOL enemyMoved = NO;
    for (int i = 0; i < _bombs.count; ++i) {
        PSHBomb *bomb = _bombs[i];
        [bomb move];
        
        BOOL bombRemoved = NO;
        if ([bomb removeSelfIfOutOfBounds]) {
            [_bombs removeObject:bomb];
            bombRemoved = YES;
        }
        
        for (int j = 0; j < _enemies.count; ++j) {
            PSHEnemy *enemy = _enemies[j];
            if (!enemyMoved) {
                [enemy move];
                if ([enemy removeSelfIfOutOfBounds]) {
                    [_enemies removeObject:enemy];
                    continue;
                }
            }
            
            // check shoot at enemy
            if (!bombRemoved) {
                if ([enemy testBombShootAtSelf:bomb]) {
                    enemy.hitPoints -= bomb.damage;
                    if (enemy.hitPoints <= 0) {
                        [self enemyWasShot:enemy bomb:bomb];
                        continue;
                    }
                }
            }
            
            // check crash at player
            if ([_player testEnemyCrashAtSelf:enemy]) {
                _player.hitPoints -= enemy.damage;
                [self updatePlayerHitPoints];
                if (_player.hitPoints <= 0) {
                    [self playerWasCrashed];
                    return;
                }
                enemy.hitPoints -= _player.damage;
                if (enemy.hitPoints <= 0) {
                    [self enemyWasShot:enemy bomb:nil];
                }
            }
        }
        enemyMoved = YES;
    }
    if (count >= 30) {
        // player shoot
        PSHBomb *bomb = [_player shootBombWithDamage:100];
        [_viewController.view addSubview:bomb];
        [_bombs addObject:bomb];
        
        // create enemy planes
        PSHEnemy *enemy = [[PSHEnemy alloc] initWithSuperBounds:_viewController.view.bounds];
        [_viewController.view addSubview:enemy];
        [_enemies addObject:enemy];
        
        count = 0;
    } else {
        ++count;
    }
}

- (void)buttonClicked:(UIButton *)button {
    switch (button.tag) {
        case 22:
        {
            if (PSHGameStateDead == self.gameState) {
                [self restartGame];
                self.gameState = PSHGameStatePause;
            }
            UIImage *image;
            if (PSHGameStatePause == self.gameState) {
                self.gameState = PSHGameStateStart;
                // lazy create pause image
                if (! _imgPause) {
                    _imgPause = [UIImage imageNamed:@"pause.png"];
                }
                image = _imgPause;
            } else {
                self.gameState = PSHGameStatePause;
                image = _imgPlay;
            }
            [button setImage:image forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)restartGame {
    [lbGameOver removeFromSuperview];
    lbGameOver = nil;
    [_player reset];
    [self updatePlayerHitPoints];
    [self updateScore];
    for (PSHEnemy *enemy in _enemies) {
        [enemy removeFromSuperview];
    }
    [_enemies removeAllObjects];
    for (PSHBomb *bomb in _bombs) {
        [bomb removeFromSuperview];
    }
    [_bombs removeAllObjects];
    for (PSHEnemy *enemy in _shotEnemies) {
        [enemy removeFromSuperview];
    }
    [_shotEnemies removeAllObjects];
}

- (void)gameLoop {
    switch (self.gameState) {
        case PSHGameStatePause:
        {
            
        }
            break;
        case PSHGameStateStart:
        {
            [self moveFlyers];
            [self shootAndCheck];
        }
            break;
        case PSHGameStateDead:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)movedPlayer:(CGPoint)center {
    if (CGRectContainsPoint(_player.frame, center))
    {
        _player.center = center;
    }
}

- (BOOL)isStarted {
    return self.gameState == PSHGameStateStart;
}

- (instancetype)initWithObject:(ViewController *)vc didBack:(SEL)selector {
    self = [super init];
    if (self) {
        _viewController = vc;
        _didBack = selector;
        _flyers = [[NSMutableArray alloc] init];
        _enemies = [[NSMutableArray alloc] init];
        _bombs = [[NSMutableArray alloc] init];
        _shotEnemies = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (PSHGameMachine*)startWithObject:(ViewController *)vc didBack:(SEL)selector {
    PSHGameMachine *gm = [[self alloc] initWithObject:vc didBack:selector];
    [gm initGame];
    return gm;
}

@end
