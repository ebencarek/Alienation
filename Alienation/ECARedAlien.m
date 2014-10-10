//
//  ECARedAlien.m
//  Alienation
//
//  Created by Eben Carek on 12/3/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECARedAlien.h"

@implementation ECARedAlien

- (id)initWithPosition:(CGPoint)position
{
    self = [super initWithTexture:[[self textureAtlas] textureNamed:@"alien-1-2.png"]];
    
    if (self)
    {
        // Configure red alien
        self.name = @"redAlien";
        self.position = position;
        self.xScale = 0.6;
        self.yScale = 0.6;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.categoryBitMask = alienCategory;
        self.physicsBody.contactTestBitMask = laserCategory | shipCategory;
        self.physicsBody.collisionBitMask = noCategory;
        self.zPosition = 1;
    }
    
    return self;
}

+ (void)loadSharedAssets
{
    // Load assets that are shared between every alien only once throughout the lifetime of the game
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTextureAtlas = [SKTextureAtlas atlasNamed:@"alien"];
        sharedAnimationFrames = ECALoadRedFramesFromAtlas(sharedTextureAtlas);
    });
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
//    NSLog(@"deallocating red alien");
//}

@end
