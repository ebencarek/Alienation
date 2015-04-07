//
//  ECASpaceship.m
//  Alienation
//
//  Created by Eben Carek on 10/30/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECASpaceship.h"
#import "ECAAlien.h"

@interface ECASpaceship ()

@property (nonatomic) CGFloat flightSpeed;

@end

// Variable to represent the ship used by all levels
static ECASpaceship *spaceship = nil;

@implementation ECASpaceship

- (id)init
{
    self = [super initWithImageNamed:@"spaceship-3"];
    
    if (self)
    {
        // Configure spaceship
        //self.position = position;
        self.name = @"spaceship";
        self.flightSpeed = 230;
        self.xScale = 0.75;
        self.yScale = 0.75;
        self.zPosition = 1;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.categoryBitMask = shipCategory;
        self.physicsBody.contactTestBitMask = alienCategory | powerUpCategory;
        self.physicsBody.collisionBitMask = noCategory;
        self.lasersOnScreen = 0;
        self.lives = 4;
        self.playLaserSound = [SKAction playSoundFileNamed:@"one-shot-laser.caf" waitForCompletion:NO];
    }
    
    return self;
}

// Ensure ECASpaceship's singleton status
+ (ECASpaceship *)sharedSpaceship
{
    if (!spaceship)
    {
        spaceship = (ECASpaceship *) [[super allocWithZone:nil] init];
    }
    
    return spaceship;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedSpaceship];
}

- (void)moveLeft
{
    CGPoint spaceshipLocation = self.position;
    
    CGFloat destinationX = self.size.width / 2;
    
    CGFloat distance = spaceshipLocation.x - destinationX;
    
    SKAction *moveLeft = [SKAction moveToX:destinationX duration:distance / self.flightSpeed];
    
    [self runAction:moveLeft withKey:@"moveLeft"];
}

- (void)moveRight
{
    CGPoint spaceshipLocation = self.position;
    
    CGFloat destinationX = self.scene.size.width - (self.size.width / 2);
    
    CGFloat distance = destinationX - spaceshipLocation.x;
    
    SKAction *moveRight = [SKAction moveToX:destinationX duration:distance / self.flightSpeed];
    
    [self runAction:moveRight withKey:@"moveRight"];
}

- (void)shootLaser
{
    // If there are more than two lasers on the screen, don't fire another laser
    
    if (self.lasersOnScreen == 2)
    {
        return;
    }
    else
    {
        SKSpriteNode *laser = [SKSpriteNode spriteNodeWithImageNamed:@"laser-1"];
        laser.name = @"laser";
        laser.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:laser.size];
        laser.physicsBody.categoryBitMask = laserCategory;
        laser.physicsBody.contactTestBitMask = alienCategory;
        laser.physicsBody.collisionBitMask = noCategory;
        laser.position = CGPointMake(self.position.x, self.position.y + (self.size.height / 2));
        [self.scene addChild:laser];
        
        self.lasersOnScreen++;
        
        CGFloat distance = self.scene.size.height - laser.position.y;
        
        const NSTimeInterval laserSpeed = 620;
        
        SKAction *shoot = [SKAction moveToY:self.scene.size.height duration:(distance / laserSpeed)];
        
        [laser runAction:shoot completion:^{
            [laser removeFromParent];
            self.lasersOnScreen--;
        }];
        
        [self runAction:self.playLaserSound];
    }
}

@end
