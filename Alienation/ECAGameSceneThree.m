//
//  ECAGameSceneThree.m
//  Alienation
//
//  Created by Eben Carek on 11/22/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECAGameSceneThree.h"

@implementation ECAGameSceneThree

- (id)initWithSize:(CGSize)size score:(int)score
{
    self = [super initWithSize:size score:score];
    
    if (self)
    {
        self.level = 3;
    }
    
    return self;
}

// Red aliens moving diagonally, change direction when reaching the edge

- (SKAction *)addAliens
{
    SKAction *addAliens = [SKAction sequence:@[
                                               [SKAction waitForDuration:1.9 withRange:1.4],
                                               [SKAction performSelector:@selector(newRedAlien) onTarget:self]
                                               ]];
    
    return addAliens;
}

- (void)newRedAlien
{
    ECARedAlien *alien = [[ECARedAlien alloc] initWithPosition:CGPointMake(skRand(self.spaceship.size.width / 2, self.size.width - self.spaceship.size.width / 2), self.size.height)];
    
    [self addChild:alien];
    
    CGFloat speed = 120 + (rand() % 50);
    
    CGFloat dx = (alien.position.x > self.size.width / 2) ? -alien.position.x + (alien.size.width / 2) : self.size.width - alien.position.x - (alien.size.width / 2);
    
    CGFloat dy = -(170 + (rand() % 80));
    
    CGFloat distance = (CGFloat)sqrt((dx * dx) + (dy * dy));
    
    SKAction *moveAction = [SKAction moveBy:CGVectorMake(dx, dy) duration:distance / speed];
    
    [alien runAction:[SKAction repeatActionForever:[self animateRedAlien]]];
    [alien runAction:moveAction completion:^{
        [alien removeAllActions];
    }];
}

- (void)didEvaluateActions
{
    [super didEvaluateActions];
    
    [self enumerateChildNodesWithName:@"redAlien" usingBlock:^(SKNode *node, BOOL *stop) {
        ECARedAlien *alien = (ECARedAlien *)node;
        
        if (alien.position.y <= 0)
        {
            self.deltaScore -= 200;
            [alien removeAllActions];
            [alien removeFromParent];
        }
        else if (![alien hasActions] && alien.position.y > 0)
        {
            CGFloat speed = 120 + (rand() % 50);
            
            CGFloat dx = (alien.position.x > self.size.width / 2) ? -self.size.width + alien.size.width : self.size.width - alien.size.width;
            
            CGFloat dy = -(200 + (rand() % 70));
            
            CGFloat distance = (CGFloat)sqrt((dx * dx) + (dy * dy));
            
            SKAction *moveAction = [SKAction moveBy:CGVectorMake(dx, dy) duration:distance / speed];
            
            [alien runAction:[self animateRedAlien]];
            [alien runAction:moveAction completion:^{
                [alien removeAllActions];
            }];
        }
    }];
}

@end
