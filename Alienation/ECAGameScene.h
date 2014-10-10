//
//  ECAGameScene.h
//  Alienation
//
//  Created by Eben Carek on 10/28/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ECAAppDelegate.h"
#import "ECASpaceship.h"
#import "ECARedAlien.h"
#import "ECABlueAlien.h"
#import "ECASquirrelBoss.h"
#import "ECAPowerUp.h"
#import "ECAGameOverScene.h"
#import "ECAIntroScene.h"
#import "ECASavedGameStore.h"

@interface ECAGameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) NSUInteger level;
@property (nonatomic) BOOL gameplayActive;
@property (strong, nonatomic) SKLabelNode *levelLabel;
@property (strong, nonatomic) SKLabelNode *resumeButton;
@property (strong, nonatomic) SKLabelNode *quitButton;
@property (strong, nonatomic) SKLabelNode *tryAgainYes;
@property (strong, nonatomic) SKLabelNode *tryAgainNo;
@property (strong, nonatomic) SKSpriteNode *blackShade;
@property (strong, nonatomic) ECASpaceship *spaceship;
@property (strong, nonatomic) SKAction *playAlienExplosionSound;
@property (strong, nonatomic) SKAction *playSpaceshipExplosionSound;
/*
 score holds the initial value of the score for the current level,
 deltaScore holds and tracks the increase or decrease in the value
 of the score. If the level is completeted, then deltaScore is added
 to score and passed into the ECAGameOverScene in order then be passed
 into the score property of the next level's scene. If the level is
 lost, then only the score is passed, and therefore deltaScore is
 ignored and is reset to 0.
 */
@property (nonatomic) int score;
@property (nonatomic) int deltaScore;
@property (nonatomic) int aliensKilled;

- (void)createSceneContents;
- (SKAction *)addAliens;
- (SKAction *)animateRedAlien;
- (SKAction *)animateBlueAlien;
- (SKEmitterNode *)alienDeathEmitter;
- (SKEmitterNode *)spaceshipDeathEmitter;
- (void)newRedAlien;
- (void)newBlueAlien;
- (void)displayLevel;
- (void)addPowerups;
- (void)checkGameWon;
- (void)gameLost;
- (void)prepareForBackground;
- (void)refreshFromBackground;

- (id)initWithSize:(CGSize)size score:(int)score;

@end

// Used in randomizing the appearance of aliens at the top of the screen

static inline CGFloat skRandf()
{
    return rand() / (CGFloat)RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf() * (high - low) + low;
}

