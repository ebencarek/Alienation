//
//  ECAGameSceneNine.m
//  Alienation
//
//  Created by Eben Carek on 2/11/14.
//  Copyright (c) 2014 Eben Carek. All rights reserved.
//

#import "ECAGameSceneNine.h"

@implementation ECAGameSceneNine

- (id)initWithSize:(CGSize)size score:(int)score
{
    self = [super initWithSize:size score:score];
    
    if (self)
    {
        self.level = 9;
    }
    
    return self;
}

// Two blue aliens following bezier paths coming down at the same time, red aliens following straight paths

- (SKAction *)addAliens
{
    SKAction *addBlueAliens = [SKAction sequence:@[
                                                   [SKAction waitForDuration:6.0 withRange:1.0],
                                                   [SKAction performSelector:@selector(newBlueAlien) onTarget:self]
                                                   ]];
    
    [self addRedAliens];
    
    return addBlueAliens;
}

- (void)addRedAliens
{
    SKAction *addRedAliens = [SKAction sequence:@[
                                                  [SKAction waitForDuration:2.5 withRange:0.7],
                                                  [SKAction performSelector:@selector(newRedAlien) onTarget:self]
                                                  ]];
    
    [self runAction:[SKAction repeatActionForever:addRedAliens] withKey:@"addRedAliens"];
}

- (void)newBlueAlien
{
    ECABlueAlien *alien1 = [[ECABlueAlien alloc] initWithPosition:CGPointMake(skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), self.size.height)];
    
    ECABlueAlien *alien2 = [[ECABlueAlien alloc] initWithPosition:CGPointMake(skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), self.size.height)];
    
    [self addChild:alien1];
    [self addChild:alien2];
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, alien1.position.x, alien1.position.y);
    CGPathAddCurveToPoint(path1, NULL, 0, (CGFloat) (self.size.height / 1.35), self.size.width, (CGFloat) (self.size.height / 3.2), skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), 0);
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, NULL, alien1.position.x, alien1.position.y);
    CGPathAddCurveToPoint(path2, NULL, self.size.width, (CGFloat) (self.size.height / 1.7), 0, (CGFloat) (self.size.height / 4.1), skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), 0);
    
    CGMutablePathRef path3 = CGPathCreateMutable();
    CGPathMoveToPoint(path3, NULL, alien2.position.x, alien2.position.y);
    CGPathAddCurveToPoint(path3, NULL, 0, (CGFloat) (self.size.height / 1.35), self.size.width, (CGFloat) (self.size.height / 3.2), skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), 0);
    
    CGMutablePathRef path4 = CGPathCreateMutable();
    CGPathMoveToPoint(path4, NULL, alien2.position.x, alien2.position.y);
    CGPathAddCurveToPoint(path4, NULL, self.size.width, (CGFloat) (self.size.height / 1.7), 0, (CGFloat) (self.size.height / 4.1), skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), 0);
    
    NSArray *possibleMovements1 = @[
                                    [SKAction followPath:path1 asOffset:NO orientToPath:NO duration:5.2],
                                    [SKAction followPath:path1 asOffset:NO orientToPath:NO duration:4.1],
                                    [SKAction followPath:path2 asOffset:NO orientToPath:NO duration:5.2],
                                    [SKAction followPath:path2 asOffset:NO orientToPath:NO duration:4.1]
                                    ];
    
    NSArray *possibleMovements2 = @[
                                    [SKAction followPath:path3 asOffset:NO orientToPath:NO duration:5.2],
                                    [SKAction followPath:path3 asOffset:NO orientToPath:NO duration:4.1],
                                    [SKAction followPath:path4 asOffset:NO orientToPath:NO duration:5.2],
                                    [SKAction followPath:path4 asOffset:NO orientToPath:NO duration:4.1]
                                    ];
    
    SKAction *animationAction = [SKAction repeatActionForever:[self animateBlueAlien]];
    
    [alien1 runAction:animationAction withKey:@"animate"];
    [alien1 runAction:possibleMovements1[(NSUInteger) (rand() % 4)] withKey:@"move"];
    
    [alien2 runAction:animationAction withKey:@"animate"];
    [alien2 runAction:possibleMovements2[(NSUInteger) (rand() % 4)] withKey:@"move"];
    
    CGPathRelease(path1);
    CGPathRelease(path2);
    CGPathRelease(path3);
    CGPathRelease(path4);
}

- (void)newRedAlien
{
    ECARedAlien *alien = [[ECARedAlien alloc] initWithPosition:CGPointMake(skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), self.size.height)];
    
    [self addChild:alien];
    
    CGFloat speed = 110 + (rand() % 50);
    
    CGFloat distance = self.size.height - (0 - (alien.size.height / 2));
    
    SKAction *moveAction = [SKAction moveToY:0 - (alien.size.height / 2) duration:distance / speed];
    
    [alien runAction:[SKAction repeatActionForever:[self animateRedAlien]]];
    [alien runAction:moveAction completion:^{
        self.deltaScore -= 200;
        [alien removeAllActions];
        [alien removeFromParent];
    }];
}

- (void)addPowerups
{
    SKAction *addPowerups = [SKAction sequence:@[
                                                 [SKAction waitForDuration:20 + (rand() % 15)],
                                                 [SKAction performSelector:@selector(newExtraLife) onTarget:self]
                                                 ]];
    
    [self runAction:addPowerups withKey:@"addPowerups"];
}

- (void)newExtraLife
{
    ECAPowerUp *extraLife = [[ECAPowerUp alloc] initWithType:kExtraLife position:CGPointMake(skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), self.size.height)];
    
    [self addChild:extraLife];
    
    [extraLife runAction:[SKAction moveToY:0 duration:3.5] completion:^{
        [extraLife removeAllActions];
        [extraLife removeFromParent];
    }];
}

- (void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
    
    if (![self actionForKey:@"addAliens"])
    {
        [self removeActionForKey:@"addRedAliens"];
    }
}

- (void)checkGameWon
{
    if (self.aliensKilled == 32)
    {
        ECAGameOverScene *gameOverScene = [[ECAGameOverScene alloc] initWithSize:self.view. frame.size won:YES score:self.score + self.deltaScore level:self.level + 1];
        
        [self.view presentScene:gameOverScene];
    }
}

@end
