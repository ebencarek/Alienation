//
//  ECAPowerUp.h
//  Alienation
//
//  Created by Eben Carek on 1/16/14.
//  Copyright (c) 2014 Eben Carek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, PowerUpType)
{
    kExtraLife
};

@interface ECAPowerUp : SKSpriteNode

@property (nonatomic) PowerUpType type;

- (id)initWithType:(PowerUpType)type position:(CGPoint)position;

- (void)wasCollected;

@end
