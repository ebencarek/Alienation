//
//  ECAGameSceneFour.m
//  Alienation
//
//  Created by Eben Carek on 12/6/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECAGameSceneFour.h"

@implementation ECAGameSceneFour

- (id)initWithSize:(CGSize)size score:(int)score
{
    self = [super initWithSize:size score:score];
    
    if (self)
    {
        self.level = 4;
    }
    
    return self;
}

// Single blue aliens following bezier paths one at a time

- (SKAction *)addAliens
{
    SKAction *addAliens = [SKAction sequence:@[
                                               [SKAction waitForDuration:2.9 withRange:1.0],
                                               [SKAction performSelector:@selector(newBlueAlien) onTarget:self]
                                               ]];
    
    return addAliens;
}

- (void)newBlueAlien
{
    // Create and configure new blue alien and array of possible actions for alien to perform
    
    ECABlueAlien *alien = [[ECABlueAlien alloc] initWithPosition:CGPointMake(skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), self.size.height)];
    
    [self addChild:alien];
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, alien.position.x, alien.position.y);
    CGPathAddCurveToPoint(path1, NULL, 0, (CGFloat) (self.size.height / 1.6), self.size.width, self.size.height / 4, skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), 0);
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, NULL, alien.position.x, alien.position.y);
    CGPathAddCurveToPoint(path2, NULL, self.size.width, (CGFloat) (self.size.height / 1.7), 0, (CGFloat) (self.size.height / 4.5), skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), 0);
    
    NSArray *possibleMovements = @[
                                   [SKAction followPath:path1 asOffset:NO orientToPath:NO duration:5.3],
                                   [SKAction followPath:path2 asOffset:NO orientToPath:NO duration:5.3]
                                   ];
    
    SKAction *animationAction = [SKAction repeatActionForever:[self animateBlueAlien]];
    
    [alien runAction:animationAction withKey:@"animate"];
    [alien runAction:possibleMovements[(NSUInteger) (rand() % 2)] withKey:@"move"];
    
    CGPathRelease(path1);
    CGPathRelease(path2);
}

- (void)checkGameWon
{
    if (self.aliensKilled == 15)
    {
        ECAGameOverScene *gameOverScene = [[ECAGameOverScene alloc] initWithSize:self.view. frame.size won:YES score:self.score + self.deltaScore level:self.level + 1];
        
        [self.view presentScene:gameOverScene];
    }
}

@end
