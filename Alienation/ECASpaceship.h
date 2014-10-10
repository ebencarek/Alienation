//
//  ECASpaceship.h
//  Alienation
//
//  Created by Eben Carek on 10/30/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ECASpaceship : SKSpriteNode

@property (nonatomic) NSUInteger lasersOnScreen;
@property (nonatomic) NSInteger lives;
@property (strong, nonatomic) SKAction *playLaserSound;

//+ (ECASpaceship *)newSpaceshipWithPosition:(CGPoint)position;

+ (ECASpaceship *)sharedSpaceship;
- (void)moveLeft;
- (void)moveRight;
- (void)shootLaser;

@end
