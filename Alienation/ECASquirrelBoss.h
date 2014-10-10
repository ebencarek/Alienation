//
//  ECASquirrelBoss.h
//  Alienation
//
//  Created by Eben Carek on 3/18/14.
//  Copyright (c) 2014 Eben Carek. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ECASquirrelBoss : SKSpriteNode

@property (nonatomic) unsigned int damage;
@property (strong, nonatomic) SKAction *playLaserSound;

- (void)flashDamage;
//- (void)flashEyes;
- (void)shootLasers;
- (SKAction *)movingAnimation;

- (id)initWithPosition:(CGPoint)position;

@end
