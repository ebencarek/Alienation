//
//  ECAGameSceneFive.m
//  Alienation
//
//  Created by Eben Carek on 12/22/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECAGameSceneFive.h"

@implementation ECAGameSceneFive

- (id)initWithSize:(CGSize)size score:(int)score
{
    self = [super initWithSize:size score:score];
    
    if (self)
    {
        self.level = 5;
    }
    
    return self;
}

// Blue aliens following bezier paths, red aliens following straight lines

- (SKAction *)addAliens
{
    SKAction *addRedAliens = [SKAction sequence:@[
                                                  [SKAction waitForDuration:1.7 withRange:1.2],
                                                  [SKAction performSelector:@selector(newRedAlien) onTarget:self]
                                                  ]];
    
    SKAction *addBlueAliens = [SKAction sequence:@[
                                                   [SKAction waitForDuration:2.7 withRange:1.3],
                                                   [SKAction performSelector:@selector(newBlueAlien) onTarget:self]
                                                   ]];
    
    SKAction *addAliens = [SKAction group:@[
                                            addRedAliens,
                                            addBlueAliens
                                            ]];
    
    return addAliens;
}

- (void)newRedAlien
{
    ECARedAlien *alien = [[ECARedAlien alloc] initWithPosition:CGPointMake(skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), self.size.height)];
    
    [self addChild:alien];
    
    CGFloat speed = 90 + (rand() % 50);
    
    CGFloat distance = self.size.height - (0 - (alien.size.height / 2));
    
    SKAction *moveAction = [SKAction moveToY:0 - (alien.size.height / 2) duration:distance / speed];
    
    [alien runAction:[SKAction repeatActionForever:[self animateRedAlien]]];
    [alien runAction:moveAction completion:^{
        self.deltaScore -= 200;
        [alien removeAllActions];
        [alien removeFromParent];
    }];
}

- (void)newBlueAlien
{
    ECABlueAlien *alien = [[ECABlueAlien alloc] initWithPosition:CGPointMake(skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), self.size.height)];
    
    [self addChild:alien];
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, alien.position.x, alien.position.y);
    CGPathAddCurveToPoint(path1, NULL, 0, self.size.height / 1.35, self.size.width, self.size.height / 3.2, skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), 0);
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, NULL, alien.position.x, alien.position.y);
    CGPathAddCurveToPoint(path2, NULL, self.size.width, self.size.height / 1.7, 0, self.size.height / 4.1, skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), 0);
    
    NSArray *possibleMovements = @[
                                   [SKAction followPath:path1 asOffset:NO orientToPath:NO duration:4.6],
                                   [SKAction followPath:path1 asOffset:NO orientToPath:NO duration:5.2],
                                   [SKAction followPath:path2 asOffset:NO orientToPath:NO duration:4.6],
                                   [SKAction followPath:path2 asOffset:NO orientToPath:NO duration:5.2]
                                   ];
    
    SKAction *animationAction = [SKAction repeatActionForever:[self animateBlueAlien]];
    
    [alien runAction:animationAction withKey:@"animate"];
    [alien runAction:[possibleMovements objectAtIndex:(rand() % 4)] withKey:@"move"];
    
    CGPathRelease(path1);
    CGPathRelease(path2);
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

- (void)checkGameWon
{
    if (self.aliensKilled == 30)
    {
        ECAGameOverScene *gameOverScene = [[ECAGameOverScene alloc] initWithSize:self.view.frame.size won:YES score:self.score + self.deltaScore level:self.level + 1];
        
        [self.view presentScene:gameOverScene];
    }
}

@end
