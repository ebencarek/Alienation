//
//  ECAGameSceneSix.m
//  Alienation
//
//  Created by Eben Carek on 12/25/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECAGameSceneSix.h"

@interface ECAGameSceneSix ()

@property (nonatomic) int aliensAdded;
@property (nonatomic) int aliensPassed;

@end

@implementation ECAGameSceneSix

- (id)initWithSize:(CGSize)size score:(int)score
{
    self = [super initWithSize:size score:score];
    
    if (self)
    {
        self.level = 6;
    }
    
    return self;
}

// Rows of 5 aliens coming down all at the same time in straight lines

- (SKAction *)addAliens
{
    SKAction *addRedAliens = [SKAction sequence:@[
                                                  [SKAction waitForDuration:3.0],
                                                  [SKAction performSelector:@selector(newRedAlien) onTarget:self]
                                                  ]];
    
    return addRedAliens;
}

- (void)newRedAlien
{
    if (self.aliensAdded >= 90)
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

- (void)addPowerups
{
    SKAction *addPowerups = [SKAction sequence:@[
                                                 [SKAction waitForDuration:25 + (rand() % 20)],
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

- (void)gameLost
{
    [self enumerateChildNodesWithName:@"redAlien" usingBlock:^(SKNode *node, BOOL *stop) {
        self.aliensAdded--;
    }];
    
    [super gameLost];
}

- (void)checkGameWon
{
    if (self.aliensKilled + self.aliensPassed == 90)
    {
        ECAGameOverScene *gameOverScene = [[ECAGameOverScene alloc] initWithSize:self.view.frame.size won:YES score:self.score + self.deltaScore level:self.level + 1];
        
        [self.view presentScene:gameOverScene];
    }
}

@end
