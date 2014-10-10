//
//  ECAPowerUp.m
//  Alienation
//
//  Created by Eben Carek on 1/16/14.
//  Copyright (c) 2014 Eben Carek. All rights reserved.
//

#import "ECAPowerUp.h"
#import "ECASpaceship.h"
#import "ECAAlien.h"

@implementation ECAPowerUp

- (id)initWithType:(PowerUpType)type position:(CGPoint)position
{    
    switch (type)
    {
        case kExtraLife:
        {
            self = [super initWithImageNamed:@"spaceship-3"];
            
            if (self)
            {
                self.name = @"extraLife";
                self.position = position;
                self.xScale = 0.5;
                self.yScale = 0.5;
                self.zPosition = 1.5;
                self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
                self.physicsBody.categoryBitMask = powerUpCategory;
                self.physicsBody.contactTestBitMask = shipCategory;
                self.physicsBody.collisionBitMask = noCategory;
                self.alpha = 0.8;
            }
            
            break;
        }
            
        default:
        {
            self = [super initWithImageNamed:@"spaceship-3"];
            
            if (self)
            {
                self.name = @"extraLife";
                self.position = position;
                self.xScale = 0.5;
                self.yScale = 0.5;
                self.zPosition = 1.5;
                self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
                self.physicsBody.categoryBitMask = powerUpCategory;
                self.physicsBody.contactTestBitMask = shipCategory;
                self.physicsBody.collisionBitMask = noCategory;
                self.alpha = 0.8;
            }
            
            break;
        }
    }
    
    self.type = type;
    
    return self;
}

- (id)init
{
    return [self initWithType:kExtraLife position:CGPointZero];
}

- (void)wasCollected
{
    switch (self.type)
    {
        case kExtraLife:
        {
            ECASpaceship *spaceship = [ECASpaceship sharedSpaceship];
            
            spaceship.lives++;
            
            break;
        }
        default:
        {
            ECASpaceship *spaceship = [ECASpaceship sharedSpaceship];
            
            spaceship.lives++;
            
            break;
        }
    }
}

@end
