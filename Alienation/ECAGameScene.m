//
//  ECAGameScene.m
//  Alienation
//
//  Created by Eben Carek on 10/28/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECAGameScene.h"
#import "ECAGameSceneTen.h"

@interface ECAGameScene ()

@property (nonatomic) BOOL contentCreated;
@property (nonatomic) BOOL backgroundPauseCheck;
@property (strong, nonatomic) SKSpriteNode *leftButton;
@property (strong, nonatomic) SKSpriteNode *rightButton;
@property (strong, nonatomic) SKSpriteNode *fireButton;
@property (strong, nonatomic) SKSpriteNode *pauseButton;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *livesLabel;
@property (strong, nonatomic) SKEmitterNode *stars;

@end


@implementation ECAGameScene

- (id)initWithSize:(CGSize)size score:(int)score;
{
    self = [super initWithSize:size];
    
    if (self)
    {
        self.score = score;
        
        self.level = 1;
        
        self.spaceship = [ECASpaceship sharedSpaceship];
    }
    
    return self;
}

- (id)initWithSize:(CGSize)size
{
    return [self initWithSize:size score:0];
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        
        [self setContentCreated:YES];
        
        //[[ECASavedGameStore savedGameStore] setCurrentScore:self.score currentLevel:self.level lives:self.spaceship.lives];
    }
    
    NSLog(@"Level %u", (unsigned int)self.level);
}

- (void)willMoveFromView:(SKView *)view
{
    [self removeAllActions];
    [self.spaceship removeAllChildren];
    [self.spaceship removeAllActions];
    [self.spaceship removeFromParent];
}

- (void)createSceneContents
{
    // Configure general scene properties
    
    [[self view] setMultipleTouchEnabled:YES];
    
    [self setBackgroundColor:[SKColor blackColor]];
    
    [self setScaleMode:SKSceneScaleModeAspectFit];
    
    [[self physicsWorld] setContactDelegate:self];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    [self configureHUD];
    
    [self displayLevel];

    self.deltaScore = 0;
    self.aliensKilled = 0;
    self.spaceship.lasersOnScreen = 0;
    
    self.spaceship.position = CGPointMake(((CGFloat) self.size.width / 2), (CGFloat) (self.size.height / 7.5));
    
    // Begin the onslaught of alien scum
    
    [ECABlueAlien loadSharedAssets];
    [ECARedAlien loadSharedAssets];
    
    srand((unsigned int)time(NULL));
    
    [self runAction:[SKAction repeatActionForever:[self addAliens]] withKey:@"addAliens"];
    
    [self addPowerups];
    
    [self setGameplayActive:YES];
}

- (void)configureHUD
{
    self.leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"movement-button-left"];
    self.rightButton = [SKSpriteNode spriteNodeWithImageNamed:@"movement-button-right"];
    self.pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"pause-button"];
    self.fireButton = [SKSpriteNode spriteNodeWithImageNamed:@"fire-button"];
    
    NSArray *buttons = @[self.leftButton, self.rightButton, self.pauseButton, self.fireButton];
    
    for (SKSpriteNode *button in buttons)
    {
        button.alpha = 0.5;
        button.zPosition = 2;
    }
    
    self.leftButton.position = CGPointMake(((CGFloat) self.size.width / 10), (CGFloat) (self.size.height / 13.1));
    self.leftButton.name = @"leftButton";
    self.leftButton.zPosition = 2;
    self.leftButton.xScale = 0.85;
    self.leftButton.yScale = 0.85;
    
    self.rightButton.position = CGPointMake(((CGFloat) self.size.width / 3), (CGFloat) (self.size.height / 13.1));
    self.rightButton.name = @"rightButton";
    self.rightButton.zPosition = 2;
    self.rightButton.xScale = 0.85;
    self.rightButton.yScale = 0.85;
    
    self.fireButton.position = CGPointMake(self.size.width - (self.size.width / 10), (CGFloat) (self.size.height / 13.1));
    self.fireButton.name = @"fireButton";
    self.fireButton.zPosition = 2;
    self.fireButton.xScale = 0.75;
    self.fireButton.yScale = 0.75;
    
    self.pauseButton.position = CGPointMake(self.size.width / 12, self.size.height - (self.size.height / 20));
    self.pauseButton.name = @"pauseButton";
    self.pauseButton.zPosition = 2;
    self.pauseButton.xScale = 0.5;
    self.pauseButton.yScale = 0.5;
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    self.scoreLabel.name = @"scoreLabel";
    self.scoreLabel.zPosition = 2;
    self.scoreLabel.fontColor = [SKColor greenColor];
    self.scoreLabel.fontSize = 20;
    self.scoreLabel.text = [NSString stringWithFormat:@"SCORE: %d", self.score];
    self.scoreLabel.xScale = 2;
    self.scoreLabel.position = CGPointMake(self.size.width - (self.scoreLabel.frame.size.width / 2), self.size.height - (self.size.height / 20));
    
    self.levelLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    self.levelLabel.name = @"levelLabel";
    self.levelLabel.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    self.levelLabel.xScale = 2;
    self.levelLabel.zPosition = 2;
    self.levelLabel.text = [NSString stringWithFormat:@"Level %d", (unsigned int)self.level];
    self.levelLabel.fontColor = [SKColor greenColor];
    self.levelLabel.alpha = 0.0;
    
    self.livesLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    self.livesLabel.name = @"livesLabel";
    self.livesLabel.zPosition = 2;
    self.livesLabel.fontColor = [SKColor greenColor];
    self.livesLabel.fontSize = 20;
    self.livesLabel.text = [NSString stringWithFormat:@"LIVES: %d", (int)self.spaceship.lives];
    self.livesLabel.xScale = 2;
    self.livesLabel.position = CGPointMake(self.size.width - (self.livesLabel.frame.size.width / 2), self.size.height - (2 * (self.size.height / 20)));
    
    self.resumeButton = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    self.resumeButton.name = @"resumeButton";
    self.resumeButton.zPosition = 3;
    self.resumeButton.fontColor = [SKColor greenColor];
    self.resumeButton.fontSize = 30;
    self.resumeButton.text = @"RESUME";
    self.resumeButton.xScale = 2;
    self.resumeButton.position = CGPointMake(self.size.width / 2, (self.size.height / 2) + 50);
    
    self.quitButton = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    self.quitButton.name = @"quitButton";
    self.quitButton.zPosition = 3;
    self.quitButton.fontColor = [SKColor greenColor];
    self.quitButton.fontSize = 30;
    self.quitButton.text = @"QUIT";
    self.quitButton.xScale = 2;
    self.quitButton.position = CGPointMake(self.size.width / 2, (self.size.height / 2) - 50);
    
    self.tryAgainYes = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    self.tryAgainYes.name = @"tryAgainYes";
    self.tryAgainYes.zPosition = 2;
    self.tryAgainYes.fontColor = [SKColor greenColor];
    self.tryAgainYes.fontSize = 20;
    self.tryAgainYes.text = @"YES";
    self.tryAgainYes.xScale = 2;
    self.tryAgainYes.position = CGPointMake((self.size.width / 2) - 40, (self.size.height / 2) - 50);
    
    self.tryAgainNo = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    self.tryAgainNo.name = @"tryAgainNo";
    self.tryAgainNo.zPosition = 2;
    self.tryAgainNo.fontColor = [SKColor greenColor];
    self.tryAgainNo.fontSize = 20;
    self.tryAgainNo.text = @"NO";
    self.tryAgainNo.xScale = 2;
    self.tryAgainNo.position = CGPointMake((self.size.width / 2) + 40, (self.size.height / 2) - 50);
    
    self.blackShade = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:self.size];
    self.blackShade.zPosition = 2.9;
    self.blackShade.alpha = 0.4;
    self.blackShade.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    
    self.stars = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Stars" ofType:@"sks"]];
    self.stars.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    self.stars.zPosition = 0;
    
    self.playAlienExplosionSound = [SKAction playSoundFileNamed:@"alien-explosion.caf" waitForCompletion:NO];
    self.playSpaceshipExplosionSound = [SKAction playSoundFileNamed:@"spaceship-explosion.caf" waitForCompletion:NO];
    
    [self addChild:self.spaceship];
    [self addChild:self.stars];
    [self addChild:self.scoreLabel];
    [self addChild:self.levelLabel];
    [self addChild:self.livesLabel];
    [self addChild:self.pauseButton];
    [self addChild:self.fireButton];
    [self addChild:self.leftButton];
    [self addChild:self.rightButton];
}

- (void)prepareForBackground
{
    /*
    if (self.paused == NO && self.gameplayActive == YES)
    {
        
        [self addChild:self.resumeButton];
        [self addChild:self.quitButton];
        [self addChild:self.blackShade];
        
        self.paused = YES;
    }
    else if (self.paused == NO && self.gameplayActive == YES)
    {
        self.paused = YES;
    }
     */
    NSLog(@"preparing for backgrouond");
    self.view.paused = YES;
    
    if (self.view.paused)
    {
        NSLog(@"paused the view");
    }
}

- (void)refreshFromBackground
{
    /*
    if (self.paused == YES)
    {
        NSLog(@"the scene is actually paused and i have no idea what's going on");
    }
    
    if (self.paused == YES && self.gameplayActive == NO)
    {
        self.paused = NO;
    }
     */
    
    NSLog(@"refreshing from background");
    
    self.view.paused = NO;
    
    if (!self.view.paused)
    {
        NSLog(@"unpaused the view");
    }

    if (!self.backgroundPauseCheck && self.gameplayActive)
    {
        NSLog(@"about to add pause menu");

        [self addChild:self.resumeButton];
        [self addChild:self.quitButton];
        [self addChild:self.blackShade];

        NSLog(@"added pause menu");

        self.paused = YES;
        self.backgroundPauseCheck = YES;
    }
    else if (self.backgroundPauseCheck)
    {
        self.paused = YES;
    }
}

- (void)displayLevel
{
    [self.levelLabel runAction:[SKAction sequence:@[
                                                    [SKAction fadeInWithDuration:0.7],
                                                    [SKAction waitForDuration:0.5],
                                                    [SKAction fadeOutWithDuration:0.7]
                                                    ]]
                    completion:^{
                        [self.levelLabel removeFromParent];
                    }];
}

// Single red alien at a time moving down in a straight line

- (SKAction *)addAliens
{
    SKAction *addAliens = [SKAction sequence:@[
                                               [SKAction waitForDuration:2.0 withRange:1.4],
                                               [SKAction performSelector:@selector(newRedAlien) onTarget:self]
                                               ]];
    
    return addAliens;
}

- (void)newRedAlien
{
    // Create and configure the alien and its movement on the screen
    
    ECARedAlien *alien = [[ECARedAlien alloc] initWithPosition:CGPointMake(skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), self.size.height)];
    
    [self addChild:alien];
    
    CGFloat speed = 80 + (rand() % 50);
    
    CGFloat distance = self.size.height - (0 - (alien.size.height / 2));
    
    SKAction *moveAction = [SKAction moveToY:0 - (alien.size.height / 2) duration:distance / speed];
    SKAction *animationAction = [SKAction repeatActionForever:[self animateRedAlien]];
    
    [alien runAction:animationAction];
    [alien runAction:moveAction completion:^{
        // Execute consequences of alien moving below the botton of the screen
        self.deltaScore -= 200;
        [alien removeAllActions];
        [alien removeFromParent];
    }];
}

- (void)newBlueAlien
{
    return;
}

- (void)addPowerups
{
    return;
}

- (SKAction *)animateRedAlien
{
    return [SKAction animateWithTextures:[(ECARedAlien *)[self childNodeWithName:@"redAlien"] animationFrames] timePerFrame:0.5 resize:YES restore:NO];
}

- (SKAction *)animateBlueAlien
{
    return [SKAction animateWithTextures:[(ECABlueAlien *)[self childNodeWithName:@"blueAlien"] animationFrames] timePerFrame:0.4 resize:YES restore:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInNode:self];
    
        SKSpriteNode *button = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
        
        if ([button isEqual:self.leftButton])
        {
            [self.spaceship moveLeft];
        }
        else if ([button isEqual:self.rightButton])
        {
            [self.spaceship moveRight];
        }
        else if ([button isEqual:self.fireButton])
        {
            [self.spaceship shootLaser];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInNode:self];
        
        SKSpriteNode *button = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
        
        [self endTouches:touches withEvent:event];
        
        // Handle the pause menu
        if ([self isPaused])
        {
            if ([button isEqual:self.resumeButton])
            {
                [self setPaused:NO];
                [self setBackgroundPauseCheck:NO];
                
                [self.blackShade removeFromParent];
                [self.resumeButton removeFromParent];
                [self.quitButton removeFromParent];
            }
            else if ([button isEqual:self.quitButton])
            {
                ECAIntroScene *introScene = [[ECAIntroScene alloc] initWithSize:self.view.frame.size];
                
                SKTransition *fade = [SKTransition fadeWithDuration:0.5];
                
                [self.view presentScene:introScene transition:fade];
            }
        }
        
        if (!self.gameplayActive)
        {
            if ([button isEqual:self.tryAgainYes])
            {
                [(SKLabelNode *)[self childNodeWithName:@"tryAgain"] removeFromParent];
                [self.tryAgainYes removeFromParent];
                [self.tryAgainNo removeFromParent];
                
                [self setGameplayActive:YES];
                
                [self.spaceship setLasersOnScreen:0];
                
                self.spaceship.position = CGPointMake((CGFloat) (self.size.width / 2), (CGFloat) (self.size.height / 9.5));
                [self addChild:self.spaceship];
                
                if (self.level != 10)
                {
                    [self runAction:[SKAction repeatActionForever:[self addAliens]] withKey:@"addAliens"];
                }
                else if ([self isKindOfClass:[ECAGameSceneTen class]])
                {
                    [(ECAGameSceneTen *)self addBoss];
                }
            }
            else if ([button isEqual:self.tryAgainNo])
            {
                ECAIntroScene *introScene = [[ECAIntroScene alloc] initWithSize:self.view.frame.size];
                
                SKTransition *fade = [SKTransition fadeWithDuration:0.5];
                
                [self.view presentScene:introScene transition:fade];
            }
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches withEvent:event];
}

- (void)endTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInNode:self];
        
        SKSpriteNode *button = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
        
        if (![button isEqual:self.fireButton])
        {
            [self.spaceship removeAllActions];
        }
        
        if ([button isEqual:self.pauseButton])
        {
            if (![self isPaused] && self.gameplayActive)
            {
                [self addChild:self.resumeButton];
                [self addChild:self.quitButton];
                [self addChild:self.blackShade];
                
                [self setPaused:YES];
                [self setBackgroundPauseCheck:YES];
            }
        }
    }
}

- (SKEmitterNode *)alienDeathEmitter
{
    SKEmitterNode *alienDeath = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"AlienDeath" ofType:@"sks"]];
    
    alienDeath.name = @"alienDeath";
    alienDeath.zPosition = 1.5;
    
    return alienDeath;
}

- (SKEmitterNode *)spaceshipDeathEmitter
{
    SKEmitterNode *spaceshipDeath = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"SpaceshipDeath" ofType:@"sks"]];
    
    spaceshipDeath.name = @"spaceshipDeath";
    spaceshipDeath.zPosition = 1.5;
    
    return spaceshipDeath;
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    // Making sure the pointers are pointing to the correct body in the collision
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (firstBody.categoryBitMask == alienCategory && secondBody.categoryBitMask == laserCategory)
    {
        NSLog(@"Red Alien / Laser contact");
        
        ECARedAlien *alien = (ECARedAlien *)firstBody.node;
        
        SKSpriteNode *laser = (SKSpriteNode *)secondBody.node;
        
        [alien removeAllActions];
        [alien removeFromParent];
        [laser removeAllActions];
        [laser removeFromParent];
        
        // Add explosion effect on alien
        SKEmitterNode *alienDeath = [self alienDeathEmitter];
        alienDeath.position = alien.position;
        [self addChild:alienDeath];
        
        [self runAction:self.playAlienExplosionSound];
        
        // Update game counters
        self.deltaScore += 100;
        self.aliensKilled++;
        self.spaceship.lasersOnScreen--;
    }
    else if ((firstBody.categoryBitMask == alienCategory || firstBody.categoryBitMask == blueAlienCategory) && secondBody.categoryBitMask == shipCategory)
    {
        NSLog(@"Alien / Spaceship contact");
        
        ECAAlien *alien = (ECAAlien *)firstBody.node;
        
        [self spaceshipDiedWithAlien:alien laser:nil];
    }
    else if (firstBody.categoryBitMask == blueAlienCategory && secondBody.categoryBitMask == laserCategory)
    {
        NSLog(@"Blue Alien / Laser contact");
        
        ECABlueAlien *alien = (ECABlueAlien *)firstBody.node;
        SKSpriteNode *laser = (SKSpriteNode *)secondBody.node;
        
        [laser removeAllActions];
        [laser removeFromParent];
        
        alien.damage++;
        
        if (alien.damage == 2)
        {
            NSLog(@"Beginning removal of blue alien");
            
            if (alien.hasActions)
            {
                NSLog(@"has actions");
            }
            
            [alien removeAllActions];
            [alien removeFromParent];
            
            SKEmitterNode *alienDeath = [self alienDeathEmitter];
            alienDeath.position = alien.position;
            [self addChild:alienDeath];
            
            self.deltaScore += 150;
            self.aliensKilled++;
            self.spaceship.lasersOnScreen--;
            
            [self runAction:self.playAlienExplosionSound];
            
            //alien = nil;
        }
        else
        {
            [alien flashDamage];
            self.spaceship.lasersOnScreen--;
        }
    }
    else if (firstBody.categoryBitMask == alienLaserCategory && secondBody.categoryBitMask == shipCategory)
    {
        NSLog(@"Alien Laser / Ship contact");
        
        SKSpriteNode *laser = (SKSpriteNode *)firstBody.node;
        
        [self spaceshipDiedWithAlien:nil laser:laser];
    }
    else if ((firstBody.categoryBitMask == powerUpCategory && secondBody.categoryBitMask == shipCategory) || (firstBody.categoryBitMask == shipCategory && secondBody.categoryBitMask == powerUpCategory))
    {
        NSLog(@"PowerUp collected");
        
        ECAPowerUp *powerUp;
        
        if (firstBody.categoryBitMask == powerUpCategory)
        {
            powerUp = (ECAPowerUp *)firstBody.node;
        }
        else if (secondBody.categoryBitMask == powerUpCategory)
        {
            powerUp = (ECAPowerUp *)secondBody.node;
        }
        
        [powerUp wasCollected];
        [powerUp removeAllActions];
        [powerUp removeFromParent];
    }
    else if (firstBody.categoryBitMask == squirrelBossCategory && secondBody.categoryBitMask == laserCategory)
    {
        NSLog(@"Laser / Squirrel contact");
        
        ECASquirrelBoss *squirrelBoss = (ECASquirrelBoss *)firstBody.node;
        SKSpriteNode *laser = (SKSpriteNode *)secondBody.node;
        
        squirrelBoss.damage += 5;
        [squirrelBoss flashDamage];
        
        self.deltaScore += 50;
        
        [laser removeAllActions];
        [laser removeFromParent];
        self.spaceship.lasersOnScreen--;
        
        NSLog(@"Squirrel Damage: %d", squirrelBoss.damage);
        
        if (squirrelBoss.damage % 100 == 0)
        {
            squirrelBoss.speed += 0.3;
        }
    }
}

- (void)spaceshipDiedWithAlien:(ECAAlien *)alien laser:(SKSpriteNode *)laser
{
    if (laser && alien)
    {
        return;
    }
    else if (laser || alien)
    {
        if (laser)
        {
            [laser removeAllActions];
            [laser removeFromParent];
        }
        else
        {
            [alien removeAllActions];
            [alien removeFromParent];
            
            SKEmitterNode *alienDeath = [self alienDeathEmitter];
            alienDeath.position = alien.position;
            [self addChild:alienDeath];
        }
        
        [self.spaceship removeAllActions];
        [self.spaceship removeFromParent];
        
        SKEmitterNode *spaceshipDeath = [self spaceshipDeathEmitter];
        spaceshipDeath.position = self.spaceship.position;
        [self addChild:spaceshipDeath];
        
        [self runAction:self.playSpaceshipExplosionSound];
        
        SKAction *deathAction = [SKAction sequence:@[
                                                     [SKAction waitForDuration:0.7],
                                                     [SKAction performSelector:@selector(gameLost) onTarget:self]
                                                     ]];
        [self runAction:deathAction];
    }
}

- (void)gameLost
{
    self.spaceship.lives--;
    
    if (self.spaceship.lives >= 0)
    {
        NSLog(@"Remaining lives: %d",(int)self.spaceship.lives);
        
        [self setGameplayActive:NO];
        
        [[self childNodeWithName:@"spaceshipDeath"] removeFromParent];
        
        [self removeActionForKey:@"addAliens"];
        
        [self enumerateChildNodesWithName:@"redAlien" usingBlock:^(SKNode *node, BOOL *stop) {
            ECAAlien *alien = (ECAAlien *)node;
            [alien removeAllActions];
            [alien removeFromParent];
        }];
        
        [self enumerateChildNodesWithName:@"blueAlien" usingBlock:^(SKNode *node, BOOL *stop) {
            ECAAlien *alien = (ECAAlien *)node;
            [alien removeAllActions];
            [alien removeFromParent];
        }];
        
        [self enumerateChildNodesWithName:@"alienLaser" usingBlock:^(SKNode *node, BOOL *stop) {
            SKSpriteNode *laser = (SKSpriteNode *)node;
            [laser removeAllActions];
            [laser removeFromParent];
        }];
        
        if (self.level == 10)
        {
            ECASquirrelBoss *boss = (ECASquirrelBoss *)[self childNodeWithName:@"squirrelBoss"];
            [boss removeAllActions];
            [boss removeFromParent];
        }
        
        [self displayTryAgain];
    }
    else
    {
        ECAGameOverScene *gameOverScene;
        
        gameOverScene = [[ECAGameOverScene alloc] initWithSize:self.view.frame.size won:NO score:self.score + self.deltaScore level:1];
        
        [self.view presentScene:gameOverScene];
    }
}

- (void)displayTryAgain
{
    SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    tryAgain.name = @"tryAgain";
    tryAgain.zPosition = 2;
    tryAgain.fontColor = [SKColor greenColor];
    tryAgain.fontSize = 30;
    tryAgain.text = @"Try Again?";
    tryAgain.xScale = 2;
    tryAgain.position = CGPointMake((self.size.width / 2), (self.size.height / 2) + 50);
    
    [self addChild:tryAgain];
    [self addChild:self.tryAgainYes];
    [self addChild:self.tryAgainNo];
}

- (void)checkGameWon
{
    // Can be overridden in other levels
    
    if (self.aliensKilled == 25)
    {
        // Pass in gained points and next level so player can advance in the game
        
        ECAGameOverScene *gameOverScene = [[ECAGameOverScene alloc] initWithSize:self.view.frame.size won:YES score:self.score + self.deltaScore level:self.level + 1];
        
        [self.view presentScene:gameOverScene];
    }
}

- (void)update:(NSTimeInterval)currentTime
{
    // Keep the score label updated with the current score and make sure the label fits on screen
    NSString *scoreString = [NSString stringWithFormat:@"SCORE: %d", self.score + self.deltaScore];
    
    [self.scoreLabel setText:scoreString];
    
    self.scoreLabel.position = CGPointMake(self.size.width - (self.scoreLabel.frame.size.width / 2), self.size.height - (self.size.height / 20));
    
    NSString *livesString = [NSString stringWithFormat:@"LIVES: %d", (int)self.spaceship.lives];
    
    [self.livesLabel setText:livesString];
    
    self.livesLabel.position = CGPointMake(self.size.width - (self.livesLabel.frame.size.width / 2), self.size.height - (2 * (self.size.height / 20)));
    
    [self checkGameWon];
    
    if ([self childNodeWithName:@"blueAlien"])
    {
        [self enumerateChildNodesWithName:@"blueAlien" usingBlock:^(SKNode *node, BOOL *stop)
        {
            ECABlueAlien *alien = (ECABlueAlien *)node;
            
            if (alien.position.x <= (self.spaceship.position.x + 40) && alien.position.x >= (self.spaceship.position.x - 40))
            {
                if (![alien actionForKey:@"shoot"])
                {
                    SKAction *shoot = [SKAction sequence:@[
                                                           [SKAction waitForDuration:0.3],
                                                           [SKAction performSelector:@selector(shootLaser) onTarget:alien],
                                                           [SKAction waitForDuration:1.5]
                                                           ]];
                    
                    [alien runAction:[SKAction repeatActionForever:shoot] withKey:@"shoot"];
                }
            }
            else
            {
                if ([alien actionForKey:@"shoot"] != nil)
                {
                    [alien removeActionForKey:@"shoot"];
                }
            }
        }];
    }
}

- (void)didEvaluateActions
{
    if ([self childNodeWithName:@"alienLaser"])
    {
        [self enumerateChildNodesWithName:@"alienLaser" usingBlock:^(SKNode *node, BOOL *stop) {
            SKSpriteNode *laser = (SKSpriteNode *)node;
            
            if (laser.position.y <= self.spaceship.position.y)
            {
                laser.physicsBody = nil;
            }
        }];
    }
    
    if ([self childNodeWithName:@"blueAlien"])
    {
        [self enumerateChildNodesWithName:@"blueAlien" usingBlock:^(SKNode *node, BOOL *stop) {
            ECABlueAlien *alien = (ECABlueAlien *)node;
            
            if (![alien actionForKey:@"move"])
            {
                [alien removeAllActions];
                [alien removeFromParent];
                self.deltaScore -= 200;
            }
        }];
    }
}

@end
