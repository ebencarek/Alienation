//
//  ECABlueAlien.h
//  Alienation
//
//  Created by Eben Carek on 12/4/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECAAlien.h"

@interface ECABlueAlien : ECAAlien

@property (nonatomic) unsigned int damage;
@property (strong, nonatomic) SKAction *playLaserSound;

- (void)flashDamage;
- (void)shootLaser;

@end
