//
//  ECAAlien.h
//  Alienation
//
//  Created by Eben Carek on 11/5/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ECAAlien : SKSpriteNode

- (id)initWithPosition:(CGPoint)position;
- (SKTextureAtlas *)textureAtlas;
- (NSArray *)animationFrames;

+ (void)loadSharedAssets;

@end

// Bitmasks for collision detection
static const uint32_t alienCategory = 0x1 << 0;
static const uint32_t blueAlienCategory = 0x1 << 1;
static const uint32_t squirrelBossCategory = 0x1 << 2;
static const uint32_t laserCategory = 0x1 << 3;
static const uint32_t alienLaserCategory = 0x1 << 4;
static const uint32_t shipCategory = 0x1 << 5;
static const uint32_t powerUpCategory = 0x1 << 6;
static const uint32_t noCategory = 0x1 << 7;

static inline NSArray *ECALoadRedFramesFromAtlas(SKTextureAtlas *atlas)
{
    NSMutableArray *textures = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < atlas.textureNames.count; i++)
    {
        [textures addObject:[atlas textureNamed:atlas.textureNames[i]]];
    }
    
    NSLog(@"%@", textures);
    
    return textures;
}

static inline NSArray *ECALoadBlueAlienFramesFromAtlas(SKTextureAtlas *atlas)
{
    NSMutableArray *textures = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= atlas.textureNames.count; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"bluealien%d", i];
        
        [textures addObject:[atlas textureNamed:textureName]];
    }
    
    NSLog(@"%@",textures);
    
    return textures;
}
