//
//  ECABlueAlien.m
//  Alienation
//
//  Created by Eben Carek on 12/4/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECABlueAlien.h"

@implementation ECABlueAlien

- (id)initWithPosition:(CGPoint)position
{
    self = [super initWithTexture:[[self textureAtlas] textureNamed:@"bluealien1.png"]];
    
    if (self)
    {
        self.name = @"blueAlien";
        self.position = position;
        self.xScale = 0.75;
        self.yScale = 0.75;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.categoryBitMask = blueAlienCategory;
        self.physicsBody.contactTestBitMask = laserCategory | shipCategory;
        self.physicsBody.collisionBitMask = noCategory;
        self.zPosition = 1;
        self.damage = 0;
        self.playLaserSound = [SKAction playSoundFileNamed:@"one-shot-laser.caf" waitForCompletion:NO];
    }
    
    return self;
}

+ (void)loadSharedAssets
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTextureAtlas = [SKTextureAtlas atlasNamed:@"bluealien"];
        sharedAnimationFrames = ECALoadBlueAlienFramesFromAtlas(sharedTextureAtlas);
    });
}

- (void)flashDamage
{
    SKAction *flash = [SKAction sequence:@[
                                           [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.1],
                                           [SKAction colorizeWithColorBlendFactor:0.0 duration:0.1]
                                           ]];
    
    [self runAction:flash];
}

- (void)shootLaser
{
    SKSpriteNode *laser = [SKSpriteNode spriteNodeWithImageNamed:@"laser-2"];
    laser.name = @"alienLaser";
    laser.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:laser.size];
    laser.physicsBody.categoryBitMask = alienLaserCategory;
    laser.physicsBody.contactTestBitMask = shipCategory;
    laser.physicsBody.collisionBitMask = noCategory;
    laser.position = CGPointMake(self.position.x, self.position.y - (self.size.height / 2));
    [self.scene addChild:laser];
    
    CGFloat distance = laser.position.y;
    
    const NSTimeInterval laserSpeed = 270;
    
    SKAction *shoot = [SKAction moveToY:0 duration:(distance / laserSpeed)];
    
    [laser runAction:shoot completion:^{
        [laser removeFromParent];
    }];
    
    [self runAction:self.playLaserSound];
}

static SKTextureAtlas *sharedTextureAtlas = nil;
static NSArray *sharedAnimationFrames = nil;

- (SKTextureAtlas *)textureAtlas
{
    return sharedTextureAtlas;
}

- (NSArray *)animationFrames
{
    return sharedAnimationFrames;
}

//- (void)dealloc
//{
//    NSLog(@"deallocating blue alien");
//}

@end
