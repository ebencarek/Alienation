//
//  ECAGameOverScene.m
//  Alienation
//
//  Created by Eben Carek on 11/9/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECAGameOverScene.h"
#import "ECAGameScene.h"
#import "ECAGameSceneTwo.h"
#import "ECAGameSceneThree.h"
#import "ECAGameSceneFour.h"
#import "ECAGameSceneFive.h"
#import "ECAGameSceneSix.h"
#import "ECAGameSceneSeven.h"
#import "ECAGameSceneEight.h"
#import "ECAGameSceneNine.h"
#import "ECAGameSceneTen.h"
#import "ECAIntroScene.h"

@interface ECAGameOverScene ()

@property (nonatomic) BOOL contentCreated;
@property (nonatomic) BOOL won;
@property (nonatomic) int score;
@property (nonatomic) NSUInteger level;
@property (strong, nonatomic) SKLabelNode *messageLabel;
@property (strong, nonatomic) SKLabelNode *continueLabel;
@property (strong, nonatomic) SKLabelNode *quitLabel;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) NSArray *gameLevels;
@property (strong, nonatomic) ADBannerView *adBanner;

@end


@implementation ECAGameOverScene

- (id)initWithSize:(CGSize)size won:(BOOL)won score:(int)score level:(NSUInteger)level
{
    self = [super initWithSize:size];
    
    if (self)
    {
        self.won = won;
        self.score = score;
        self.level = level;
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        self.contentCreated = YES;
        
        [self createSceneContents];
        
        BOOL gameOver = [[ECASpaceship sharedSpaceship] lives] == -1 && !self.won;
        
        if (gameOver)
        {
            [[ECASavedGameStore savedGameStore] clearSavedGame];
        }
        else
        {
            [[ECASavedGameStore savedGameStore] setCurrentScore:self.score currentLevel:self.level lives:[[ECASpaceship sharedSpaceship] lives]];
        }
    }
    
    self.adBanner = [(ECAAppDelegate *)[[UIApplication sharedApplication] delegate] adBanner];
    self.adBanner.delegate = self;
    self.adBanner.frame = CGRectMake(0, self.size.height - self.adBanner.frame.size.height, self.adBanner.frame.size.width, self.adBanner.frame.size.height);
    
    if (self.adBanner.bannerLoaded)
    {
        [self.view addSubview:self.adBanner];
    }
    
    [(ECAAppDelegate *)[[UIApplication sharedApplication] delegate] setGameOverScene:self];
}

- (void)createSceneContents
{
    [self setBackgroundColor:[SKColor blackColor]];
    
    [self setScaleMode:SKSceneScaleModeAspectFit];
    
    if ([ECASpaceship sharedSpaceship].physicsBody == nil)
    {
        [[ECASpaceship sharedSpaceship] setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:[[ECASpaceship sharedSpaceship] size]]];
    }
    
    BOOL gameOver = [[ECASpaceship sharedSpaceship] lives] == -1 && !self.won;
    
    self.messageLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    self.messageLabel.name = @"messageLabel";
    self.messageLabel.fontColor = [SKColor greenColor];
    self.messageLabel.fontSize = 40;
    self.messageLabel.xScale = 2;
    self.messageLabel.position = CGPointMake(self.size.width / 2, (self.size.height / 2) + 75);
    
    if (self.won)
    {
        [self.messageLabel setText:@"You Win!"];
    }
    else if (gameOver)
    {
        [self.messageLabel setText:@"Game Over"];
        
        [[ECASpaceship sharedSpaceship] setLives:4];
    }
    
    self.continueLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    self.continueLabel.name = @"continueLabel";
    self.continueLabel.fontColor = [SKColor greenColor];
    self.continueLabel.fontSize = 22;
    self.continueLabel.xScale = 2;
    self.continueLabel.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    self.continueLabel.text = (self.won) ? @"CONTINUE" : @"TRY AGAIN";
    
    self.quitLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    self.quitLabel.name = @"quitLabel";
    self.quitLabel.fontColor = [SKColor greenColor];
    self.quitLabel.fontSize = 22;
    self.quitLabel.xScale = 2;
    self.quitLabel.position = CGPointMake(self.size.width / 2, (self.size.height / 2) - 50);
    self.quitLabel.text = @"QUIT";
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    self.scoreLabel.name = @"scoreLabel";
    self.scoreLabel.zPosition = 2;
    self.scoreLabel.fontColor = [SKColor greenColor];
    self.scoreLabel.fontSize = 20;
    self.scoreLabel.xScale = 2;
    NSString *score = [NSString stringWithFormat:@"SCORE: %d", self.score];
    self.scoreLabel.text = score;
    self.scoreLabel.position = CGPointMake(self.size.width - (self.scoreLabel.frame.size.width / 2), self.size.height - (self.size.height / 20));
    
    [self addChild:self.scoreLabel];
    [self addChild:[self addStars]];
    [self addChild:self.messageLabel];
    [self addChild:self.continueLabel];
    [self addChild:self.quitLabel];
}

- (void)willMoveFromView:(SKView *)view
{
    self.adBanner.delegate = nil;
    [self.adBanner removeFromSuperview];
    
    [(ECAAppDelegate *)[[UIApplication sharedApplication] delegate] setGameOverScene:nil];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"Banner View Loaded Ad");
    [self.view addSubview:banner];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (SKEmitterNode *)addStars
{
    SKEmitterNode *stars = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Stars" ofType:@"sks"]];
    
    stars.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    stars.zPosition = 0;
    
    return stars;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    SKLabelNode *touchedNode = (SKLabelNode *)[self nodeAtPoint:touchLocation];
    
    if ([touchedNode isEqual:self.continueLabel])
    {
        SKTransition *fade = [SKTransition fadeWithDuration:0.5];
        
        NSMutableArray *levelContainer = [[NSMutableArray alloc] init];
        
        BOOL gameOver = [[ECASpaceship sharedSpaceship] lives] == -1 && !self.won;
        
        switch (self.level)
        {
            case 1:
            {
                ECAGameScene *gameScene = (gameOver) ? [[ECAGameScene alloc] initWithSize:self.view.frame.size score:0] : [[ECAGameScene alloc] initWithSize:self.view.frame.size score:self.score];
                [levelContainer addObject:gameScene];
                break;
            }
            case 2:
            {
                ECAGameSceneTwo *gameScene = [[ECAGameSceneTwo alloc] initWithSize:self.view.frame.size score:self.score];
                [levelContainer addObject:gameScene];
                break;
            }
            case 3:
            {
                ECAGameSceneThree *gameScene = [[ECAGameSceneThree alloc] initWithSize:self.view.frame.size score:self.score];
                [levelContainer addObject:gameScene];
                break;
            }
            case 4:
            {
                ECAGameSceneFour *gameScene = [[ECAGameSceneFour alloc] initWithSize:self.view.frame.size score:self.score];
                [levelContainer addObject:gameScene];
                break;
            }
            case 5:
            {
                ECAGameSceneFive *gameScene = [[ECAGameSceneFive alloc] initWithSize:self.view.frame.size score:self.score];
                [levelContainer addObject:gameScene];
                break;
            }
            case 6:
            {
                ECAGameSceneSix *gameScene = [[ECAGameSceneSix alloc] initWithSize:self.view.frame.size score:self.score];
                [levelContainer addObject:gameScene];
                break;
            }
            case 7:
            {
                ECAGameSceneSeven *gameScene = [[ECAGameSceneSeven alloc] initWithSize:self.view.frame.size score:self.score];
                [levelContainer addObject:gameScene];
                break;
            }
            case 8:
            {
                ECAGameSceneEight *gameScene = [[ECAGameSceneEight alloc] initWithSize:self.view.frame.size score:self.score];
                [levelContainer addObject:gameScene];
                break;
            }
            case 9:
            {
                ECAGameSceneNine *gameScene = [[ECAGameSceneNine alloc] initWithSize:self.view.frame.size score:self.score];
                [levelContainer addObject:gameScene];
                break;
            }
            case 10:
            {
                ECAGameSceneTen *gameScene = [[ECAGameSceneTen alloc] initWithSize:self.view.frame.size score:self.score];
                [levelContainer addObject:gameScene];
                break;
            }
            default:
            {
                ECAGameScene *gameScene = (gameOver) ? [[ECAGameScene alloc] initWithSize:self.view.frame.size score:0] : [[ECAGameScene alloc] initWithSize:self.view.frame.size score:self.score];
                [levelContainer addObject:gameScene];
                break;
            }
        }
        
        [self.view presentScene:[levelContainer objectAtIndex:0] transition:fade];
    }
    else if ([touchedNode isEqual:self.quitLabel])
    {
        ECAIntroScene *introScene = [[ECAIntroScene alloc] initWithSize:self.view.frame.size];
        
        SKTransition *fade = [SKTransition fadeWithDuration:0.5];
        
        [self.view presentScene:introScene transition:fade];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

@end
