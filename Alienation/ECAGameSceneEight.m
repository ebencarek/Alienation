//
//  ECAGameSceneEight.m
//  Alienation
//
//  Created by Eben Carek on 1/24/14.
//  Copyright (c) 2014 Eben Carek. All rights reserved.
//

#import "ECAGameSceneEight.h"

@interface ECAGameSceneEight ()

@property (nonatomic) int aliensAdded;
@property (nonatomic) int aliensPassed;

@end

@implementation ECAGameSceneEight

- (id)initWithSize:(CGSize)size score:(int)score
{
    self = [super initWithSize:size score:score];
    
    if (self)
    {
        self.level = 8;
    }
    
    return self;
}

// Red aliens coming down in rows similar to level 6 with blue aliens following bezier paths one at a time 

- (SKAction *)addAliens
{
    SKAction *addBlueAliens = [SKAction sequence:@[
                                                   [SKAction waitForDuration:6.0 withRange:1.5],
                                                   [SKAction performSelector:@selector(newBlueAlien) onTarget:self]
                                                   ]];
    
    [self addRedAliens];
    
    return addBlueAliens;
}

- (void)addRedAliens
{
    SKAction *addRedAliens = [SKAction sequence:@[
                                                  [SKAction waitForDuration:3.0],
                                                  [SKAction performSelector:@selector(newRedAlien) onTarget:self]
                                                  ]];
    
    [self runAction:[SKAction repeatActionForever:addRedAliens] withKey:@"addRedAliens"];
}

- (void)newRedAlien
{
    if (self.aliensAdded >= 100)
    {
        return;
    }
    else
    {
        ECARedAlien *alien1, *alien2, *alien3, *alien4, *alien5;
        
        CGPoint position1 = CGPointMake(self.size.width / 10, self.size.height);
        CGPoint position2 = CGPointMake((3 * self.size.width) / 10, self.size.height);
        CGPoint position3 = CGPointMake(self.size.width / 2, self.size.height);
        CGPoint position4 = CGPointMake(self.size.width - ((3 * self.size.width) / 10), self.size.height);
        CGPoint position5 = CGPointMake(self.size.width - (self.size.width / 10), self.size.height);
        
        alien1 = [[ECARedAlien alloc] initWithPosition:position1];
        alien2 = [[ECARedAlien alloc] initWithPosition:position2];
        alien3 = [[ECARedAlien alloc] initWithPosition:position3];
        alien4 = [[ECARedAlien alloc] initWithPosition:position4];
        alien5 = [[ECARedAlien alloc] initWithPosition:position5];
        
        NSArray *aliensArray = @[alien1, alien2, alien3, alien4, alien5];
        
        for (ECARedAlien *alien in aliensArray)
        {
            [self addChild:alien];
            
            CGFloat speed = 43;
            
            CGFloat distance = self.size.height - (0 - (alien.size.height / 2));
            
            SKAction *moveAction = [SKAction moveToY:0 - (alien.size.height / 2) duration:distance / speed];
            
            [alien runAction:[SKAction repeatActionForever:[self animateRedAlien]]];
            [alien runAction:moveAction completion:^{
                self.deltaScore -= 200;
                self.aliensPassed++;
                [alien removeAllActions];
                [alien removeFromParent];
            }];
        }
        self.aliensAdded += 5;
    }
}

- (void)newBlueAlien
{
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

- (void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
    
    if (![self actionForKey:@"addAliens"])
    {
        [self removeActionForKey:@"addRedAliens"];
    }
}

- (void)gameLost
{
    [self enumerateChildNodesWithName:@"redAlien" usingBlock:^(SKNode *node, BOOL *stop) {
        self.aliensAdded--;
    }];
    
    [super gameLost];
}

- (void)checkGameWon
{
    if (self.aliensKilled + self.aliensPassed == 100)
    {
        ECAGameOverScene *gameOverScene = [[ECAGameOverScene alloc] initWithSize:self.view.frame.size won:YES score:self.score + self.deltaScore level:self.level + 1];
        
        [self.view presentScene:gameOverScene];
    }
}

@end
