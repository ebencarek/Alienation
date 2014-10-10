//
//  ECAIntroScene.m
//  Alienation
//
//  Created by Eben Carek on 10/28/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECAIntroScene.h"
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
#import "ECASavedGameStore.h"

@interface ECAIntroScene ()

@property (nonatomic) BOOL contentCreated;
@property (strong, nonatomic) SKLabelNode *titleLabel;
@property (strong, nonatomic) SKLabelNode *startButton;
@property (strong, nonatomic) SKLabelNode *continueButton;
@property (strong, nonatomic) ADBannerView *adBanner;

@end


@implementation ECAIntroScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        self.contentCreated = YES;
        
        [self createSceneContents];
    }
    
    self.adBanner = [(ECAAppDelegate *)[[UIApplication sharedApplication] delegate] adBanner];
    self.adBanner.delegate = self;
    self.adBanner.frame = CGRectMake(0, self.size.height - self.adBanner.frame.size.height, self.adBanner.frame.size.width, self.adBanner.frame.size.height);
    
    if (self.adBanner.bannerLoaded)
    {
        [self.view addSubview:self.adBanner];
    }
}

- (void)createSceneContents
{
    [self setBackgroundColor:[SKColor blackColor]];
    
    [self setScaleMode:SKSceneScaleModeAspectFit];
    
    [self addChild:[self addIntroLabel]];
    [self addChild:[self addStartButton]];
    
    if ([[[ECASavedGameStore savedGameStore] savedGame] currentLevel] != 1)
    {
        [self addChild:[self addContinueButton]];
    }
    
    [self addChild:[self addStars]];
}

- (void)willMoveFromView:(SKView *)view
{
    self.adBanner.delegate = nil;
    [self.adBanner removeFromSuperview];
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

- (SKLabelNode *)addIntroLabel
{
    self.titleLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    [self.titleLabel setName:@"labelNode"];
    [self.titleLabel setText:@"Alienation"];
    [self.titleLabel setFontSize:42];
    [self.titleLabel setFontColor:[SKColor greenColor]];
    [self.titleLabel setPosition:CGPointMake(self.size.width / 2, (self.size.height / 2) + 100)];
    [self.titleLabel setXScale:2];
    [self.titleLabel setZPosition:1];
    
    //NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    //NSLog(@"Supported Fonts: %@", familyNames);
    
    return self.titleLabel;
}

- (SKLabelNode *)addStartButton
{
    self.startButton = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    [self.startButton setName:@"buttonNode"];
    [self.startButton setText:@"START NEW"];
    [self.startButton setFontColor:[SKColor greenColor]];
    [self.startButton setFontSize:30];
    [self.startButton setPosition:CGPointMake(self.size.width / 2, (self.size.height / 2) - 75)];
    [self.startButton setXScale:2];
    [self.startButton setZPosition:1];
    
    return self.startButton;
}

- (SKLabelNode *)addContinueButton
{
    self.continueButton = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    [self.continueButton setName:@"continueButton"];
    [self.continueButton setText:@"CONTINUE"];
    [self.continueButton setFontColor:[SKColor greenColor]];
    [self.continueButton setFontSize:24];
    [self.continueButton setPosition:CGPointMake(self.size.width / 2, (self.size.height / 2) - 125)];
    [self.continueButton setXScale:2];
    [self.continueButton setZPosition:1];

    return self.continueButton;
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
    
    if ([touchedNode isEqual:self.startButton])
    {
        ECAGameScene *gameScene = [[ECAGameScene alloc] initWithSize:self.view.frame.size score:0];
        
        SKTransition *fade = [SKTransition fadeWithDuration:0.5];
        
        [[ECASpaceship sharedSpaceship] setLives:4];
        
        [self.view presentScene:gameScene transition:fade];
    }
    else if ([touchedNode isEqual:self.continueButton] && [[[ECASavedGameStore savedGameStore] savedGame] currentLevel] != 1)
    {
        ECASavedGame *savedGame = [[ECASavedGameStore savedGameStore] savedGame];
        
        NSMutableArray *levelContainer = [[NSMutableArray alloc] init];
        
        switch (savedGame.currentLevel)
        {
            case 1:
            {
                ECAGameScene *gameScene = [[ECAGameScene alloc] initWithSize:self.view.frame.size score:savedGame.currentScore];
                [levelContainer addObject:gameScene];
                break;
            }
            case 2:
            {
                ECAGameSceneTwo *gameScene = [[ECAGameSceneTwo alloc] initWithSize:self.view.frame.size score:savedGame.currentScore];
                [levelContainer addObject:gameScene];
                break;
            }
            case 3:
            {
                ECAGameSceneThree *gameScene = [[ECAGameSceneThree alloc] initWithSize:self.view.frame.size score:savedGame.currentScore];
                [levelContainer addObject:gameScene];
                break;
            }
            case 4:
            {
                ECAGameSceneFour *gameScene = [[ECAGameSceneFour alloc] initWithSize:self.view.frame.size score:savedGame.currentScore];
                [levelContainer addObject:gameScene];
                break;
            }
            case 5:
            {
                ECAGameSceneFive *gameScene = [[ECAGameSceneFive alloc] initWithSize:self.view.frame.size score:savedGame.currentScore];
                [levelContainer addObject:gameScene];
                break;
            }
            case 6:
            {
                ECAGameSceneSix *gameScene = [[ECAGameSceneSix alloc] initWithSize:self.view.frame.size score:savedGame.currentScore];
                [levelContainer addObject:gameScene];
                break;
            }
            case 7:
            {
                ECAGameSceneSeven *gameScene = [[ECAGameSceneSeven alloc] initWithSize:self.view.frame.size score:savedGame.currentScore];
                [levelContainer addObject:gameScene];
                break;
            }
            case 8:
            {
                ECAGameSceneEight *gameScene = [[ECAGameSceneEight alloc] initWithSize:self.view.frame.size score:savedGame.currentScore];
                [levelContainer addObject:gameScene];
                break;
            }
            case 9:
            {
                ECAGameSceneNine *gameScene = [[ECAGameSceneNine alloc] initWithSize:self.view.frame.size score:savedGame.currentScore];
                [levelContainer addObject:gameScene];
                break;
            }
            case 10:
            {
                ECAGameSceneTen *gameScene = [[ECAGameSceneTen alloc] initWithSize:self.view.frame.size score:savedGame.currentScore];
                [levelContainer addObject:gameScene];
                break;
            }
            default:
            {
                ECAGameScene *gameScene = [[ECAGameScene alloc] initWithSize:self.view.frame.size score:savedGame.currentScore];
                [levelContainer addObject:gameScene];
                break;
            }
        }
        
        SKTransition *fade = [SKTransition fadeWithDuration:0.5];
        
        [[ECASpaceship sharedSpaceship] setLives:savedGame.lives];
        
        [self.view presentScene:[levelContainer objectAtIndex:0] transition:fade];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

@end
