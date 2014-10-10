//
//  ECAGameSceneSeven.m
//  Alienation
//
//  Created by Eben Carek on 1/13/14.
//  Copyright (c) 2014 Eben Carek. All rights reserved.
//

#import "ECAGameSceneSeven.h"

@implementation ECAGameSceneSeven

- (id)initWithSize:(CGSize)size score:(int)score
{
    self = [super initWithSize:size score:score];
    
    if (self)
    {
        self.level = 7;
    }
    
    return self;
}

// Two red aliens following bezier paths coming down at the same time, blue aliens following bezier paths one at a time less often than red aliens

- (SKAction *)addAliens
{
    SKAction *addBlueAliens = [SKAction sequence:@[
                                                   [SKAction waitForDuration:6.0 withRange:2.0],
                                                   [SKAction performSelector:@selector(newBlueAlien) onTarget:self]
                                                   ]];
    
    [self addRedAliens];
    
    return addBlueAliens;
}

- (void)addRedAliens
{
    SKAction *addRedAliens = [SKAction sequence:@[
                                                  [SKAction waitForDuration:3.0 withRange:0.8],
                                                  [SKAction performSelector:@selector(newRedAlien) onTarget:self]
                                                  ]];
    
    [self runAction:[SKAction repeatActionForever:addRedAliens] withKey:@"addRedAliens"];
}

- (void)newRedAlien
{
    ECARedAlien *alien1 = [[ECARedAlien alloc] initWithPosition:CGPointMake(skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), self.size.height)];
    
    ECARedAlien *alien2 = [[ECARedAlien alloc] initWithPosition:CGPointMake(skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), self.size.height)];

    [self addChild:alien1];
    [self addChild:alien2];
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, alien1.position.x, alien1.position.y);
    CGPathAddCurveToPoint(path1, NULL, 0, self.size.height / 1.35, self.size.width, self.size.height / 3.2, skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), 0);
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, NULL, alien1.position.x, alien1.position.y);
    CGPathAddCurveToPoint(path2, NULL, self.size.width, self.size.height / 1.7, 0, self.size.height / 4.1, skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), 0);
    
    CGMutablePathRef path3 = CGPathCreateMutable();
    CGPathMoveToPoint(path3, NULL, alien2.position.x, alien2.position.y);
    CGPathAddCurveToPoint(path3, NULL, 0, self.size.height / 1.35, self.size.width, self.size.height / 3.2, skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), 0);
    
    CGMutablePathRef path4 = CGPathCreateMutable();
    CGPathMoveToPoint(path4, NULL, alien2.position.x, alien2.position.y);
    CGPathAddCurveToPoint(path4, NULL, self.size.width, self.size.height / 1.7, 0, self.size.height / 4.1, skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), 0);
    
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
    
    SKAction *animationAction = [SKAction repeatActionForever:[self animateRedAlien]];
    
    [alien1 runAction:animationAction withKey:@"animate"];
    [alien1 runAction:[possibleMovements1 objectAtIndex:(rand() % 4)] withKey:@"move"];
    
    [alien2 runAction:animationAction withKey:@"animate"];
    [alien2 runAction:[possibleMovements2 objectAtIndex:(rand() % 4)] withKey:@"move"];
    
    CGPathRelease(path1);
    CGPathRelease(path2);
    CGPathRelease(path3);
    CGPathRelease(path4);
}

- (void)newBlueAlien
{
    ECABlueAlien *alien = [[ECABlueAlien alloc] initWithPosition:CGPointMake(skRand(self.spaceship.size.width / 2, self.size.width - (self.spaceship.size.width / 2)), self.size.height)];
    
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

- (void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
    
    if (![self actionForKey:@"addAliens"])
    {
        [self removeActionForKey:@"addRedAliens"];
    }
}

- (void)didEvaluateActions
{
    [super didEvaluateActions];
    
    if ([self childNodeWithName:@"redAlien"])
    {
        [self enumerateChildNodesWithName:@"redAlien" usingBlock:^(SKNode *node, BOOL *stop) {
            ECARedAlien *alien = (ECARedAlien *)node;
            
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
