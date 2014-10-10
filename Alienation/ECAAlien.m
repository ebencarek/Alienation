//
//  ECAAlien.m
//  Alienation
//
//  Created by Eben Carek on 11/5/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECAAlien.h"

@implementation ECAAlien

- (id)initWithPosition:(CGPoint)position
{
    self = [super init];
    
    if (self)
    {
        // Overriden by subclasses for implementing customized properties
        NSLog(@"ERROR: initWithPosition: should only be called from sublasses of ECAAlien");
    }
    
    return self;
}

- (id)init
{
    return [self initWithPosition:CGPointMake(self.scene.size.width / 2, self.scene.size.height / 2)];
}

+ (void)loadSharedAssets
{
    /* Load assets that are shared between every alien only once throughout the lifetime of the game
     Meant to be overriden by subclasses */
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

@end
