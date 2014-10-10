//
//  ECAGameSceneTwo.m
//  Alienation
//
//  Created by Eben Carek on 11/13/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECAGameSceneTwo.h"

@interface ECAGameSceneTwo ()

@end


@implementation ECAGameSceneTwo

- (id)initWithSize:(CGSize)size score:(int)score
{
    self = [super initWithSize:size score:score];
    
    if (self)
    {
        self.level = 2;
    }
    
    return self;
}

// Same as level one, aliens move faster

- (SKAction *)addAliens
{
    SKAction *addAliens = [SKAction sequence:@[
                                               [SKAction waitForDuration:1.7 withRange:1.7],
                                               [SKAction performSelector:@selector(newRedAlien) onTarget:self]
                                               ]];
    
    return addAliens;
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

@end
