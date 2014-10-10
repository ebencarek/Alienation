//
//  ECASquirrelBoss.m
//  Alienation
//
//  Created by Eben Carek on 3/18/14.
//  Copyright (c) 2014 Eben Carek. All rights reserved.
//

#import "ECASquirrelBoss.h"
#import "ECAAlien.h"

@implementation ECASquirrelBoss

- (id)initWithPosition:(CGPoint)position
{
    self = [super initWithImageNamed:@"squirrel-boss-1.png"];
    
    if (self)
    {
        //Configure Squirrel
        self.name = @"squirrelBoss";
        self.position = position;
        self.zPosition = 1.3;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.categoryBitMask = squirrelBossCategory;
        self.physicsBody.contactTestBitMask = shipCategory | laserCategory;
        self.physicsBody.collisionBitMask = noCategory;
        self.damage = 250;
        self.playLaserSound = [SKAction playSoundFileNamed:@"one-shot-laser.caf" waitForCompletion:NO];
    }
    
    return self;
}

- (id)initWithImageNamed:(NSString *)name
{
    return [self initWithPosition:CGPointZero];
}

- (id)init
{
    return [self initWithPosition:CGPointZero];
}

- (void)flashDamage
{
    SKAction *flashDamage = [SKAction sequence:@[
                                                 [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.1],
                                                 [SKAction colorizeWithColorBlendFactor:0.0 duration:0.1]
                                                 ]];
    
    [self runAction:flashDamage];
}

- (void)shootLasers
{
    SKSpriteNode *laser1 = [SKSpriteNode spriteNodeWithImageNamed:@"laser-2"];
    laser1.name = @"alienLaser";
    laser1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:laser1.size];
    laser1.physicsBody.categoryBitMask = alienLaserCategory;
    laser1.physicsBody.contactTestBitMask = shipCategory;
    laser1.physicsBody.collisionBitMask = noCategory;
    laser1.position = CGPointMake(self.position.x, self.position.y - (self.size.height / 2));
    [self.scene addChild:laser1];
    
    CGFloat distance1 = laser1.position.y;
    
    const NSTimeInterval laserSpeed = 270;
    
    SKAction *shoot1 = [SKAction moveToY:0 duration:(distance1 / laserSpeed)];
        [laser1 runAction:shoot1 completion:^{
        [laser1 removeFromParent];
    }];
    
    [self runAction:self.playLaserSound];
}

- (SKAction *)movingAnimation
{
    SKAction *shoot = [SKAction sequence:@[
                                           [SKAction performSelector:@selector(shootLasers) onTarget:self],
                                           [SKAction waitForDuration:0.3],
                                           [SKAction performSelector:@selector(shootLasers) onTarget:self]
                                           ]];
    
    SKAction *moveSideways = [SKAction sequence:@[
                                                  [SKAction moveToX:self.scene.size.width / 4 duration:1],
                                                  [SKAction group:@[shoot, [SKAction moveToX:(3 * self.scene.size.width) / 4 duration:2]]],
                                                  [SKAction group:@[shoot, [SKAction moveToX:self.scene.size.width / 2 duration:1]]],
                                                  ]];
    
    SKAction *shake = [SKAction sequence:@[
                                           [SKAction rotateByAngle:M_PI / 12 duration:0.2],
                                           [SKAction rotateByAngle:-(M_PI / 6) duration:0.4],
                                           [SKAction rotateByAngle:M_PI / 12 duration:0.2]
                                           ]];
    
    SKAction *moveUp = [SKAction moveToY:self.scene.size.height - self.size.height duration:1.6];
    
    SKAction *moveDown = [SKAction moveToY:(self.scene.size.height / 2) + 60 duration:1.6];
    
    SKAction *finalAction = [SKAction sequence:@[
                                                 moveSideways,
                                                 [SKAction group:@[[SKAction sequence:@[shake, shake]], moveUp, shoot]],
                                                 moveSideways,
                                                 [SKAction group:@[[SKAction sequence:@[shake, shake]], moveDown, shoot]]
                                                 ]];
    
    return finalAction;
}

@end
