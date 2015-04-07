//
//  ECAGameSceneTen.m
//  Alienation
//
//  Created by Eben Carek on 2/23/14.
//  Copyright (c) 2014 Eben Carek. All rights reserved.
//

#import "ECAGameSceneTen.h"
#import "ECAEndGameScene.h"

@interface ECAGameSceneTen ()

@property (strong, nonatomic) ECASquirrelBoss *squirrelBoss;
@property (nonatomic) BOOL animationPlaying;

@end

@implementation ECAGameSceneTen

- (id)initWithSize:(CGSize)size score:(int)score
{
    self = [super initWithSize:size score:score];
    
    if (self)
    {
        self.level = 10;
    }
    
    return self;
}

// The player must face the terrifying space squirrel head

- (SKAction *)addAliens
{
    SKAction *addNoAliens = [SKAction performSelector:@selector(noAlienMethod) onTarget:self];
    
    return addNoAliens;
}

- (void)noAlienMethod
{
    return;
}

- (void)createSceneContents
{
    [super createSceneContents];
    
    if ([self actionForKey:@"addAliens"] != nil)
    {
        [self removeActionForKey:@"addAliens"];
    }
    
    [self addBoss];
}

- (void)addBoss
{
    self.squirrelBoss = [[ECASquirrelBoss alloc] initWithPosition:CGPointMake(self.size.width / 2, (CGFloat) (self.size.height + 46.5))];
    
    //NSLog(@"%f",self.squirrelBoss.size.height / 2);
    
    [self addChild:self.squirrelBoss];
    
    SKAction *moveDown = [SKAction moveToY:(self.size.height / 2) + 60 duration:5];
    
    [self.squirrelBoss runAction:[SKAction sequence:@[
                                                      [SKAction waitForDuration:3.0],
                                                      moveDown
                                                      ]] withKey:@"moveDown"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.squirrelBoss actionForKey:@"moveDown"] || self.animationPlaying)
    {
        return;
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)update:(NSTimeInterval)currentTime
{
    if (![self.squirrelBoss actionForKey:@"moveDown"] && ![self.squirrelBoss actionForKey:@"movingAnimation"] && !self.animationPlaying)
    {
        [self.squirrelBoss runAction:[SKAction repeatActionForever:[self.squirrelBoss movingAnimation]] withKey:@"movingAnimation"];
    }
    
    [super update:currentTime];
}

- (void)checkGameWon
{
    if (self.squirrelBoss.damage >= 300)
    {
        self.animationPlaying = YES;
        
        [self.squirrelBoss removeActionForKey:@"movingAnimation"];
        
        //[self.squirrelBoss runAction:[SKAction rotateToAngle:0 duration:1.0 shortestUnitArc:YES]];
        
        CGFloat dx = (self.size.width / 2) > self.squirrelBoss.position.x ? (self.size.width / 2) - self.squirrelBoss.position.x : self.squirrelBoss.position.x - (self.size.width / 2);
        CGFloat dy = self.squirrelBoss.position.y - (self.size.height / 2);
        CGFloat distance = (CGFloat) sqrt((dx * dx) + (dy * dy));
        CGFloat speed = 200;
        
        [self.squirrelBoss runAction:[SKAction group:@[
                                                       [SKAction moveTo:CGPointMake(self.size.width / 2, (self.size.height / 2 + 60)) duration:distance / speed],
                                                       [SKAction rotateToAngle:0 duration:1.0 shortestUnitArc:YES]
                                                       ]] completion:^{
            [self.squirrelBoss runAction:[SKAction sequence:@[
                                                              [SKAction fadeAlphaTo:0.0 duration:2.0],
                                                              [SKAction waitForDuration:1.0]
                                                              ]] completion:^{
                ECAEndGameScene *endGameScene = [[ECAEndGameScene alloc] initWithSize:self.view.frame.size finalScore:self.score + self.deltaScore];
                [self.view presentScene:endGameScene];
            }];
        }];
    }
}

@end
