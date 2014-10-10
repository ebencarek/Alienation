//
//  ECASavedGame.m
//  Alienation
//
//  Created by Eben Carek on 12/26/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECASavedGame.h"

@implementation ECASavedGame

- (id)initWithCurrentScore:(int)score currentLevel:(NSUInteger)level lives:(NSInteger)lives
{
    self = [super init];
    
    if (self)
    {
        self.currentScore = score;
        self.currentLevel = level;
        self.lives = lives;
    }
    
    return self;
}

- (id)init
{
    return [self initWithCurrentScore:0 currentLevel:1 lives:3];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        [self setCurrentScore:[aDecoder decodeIntForKey:@"currentScore"]];
        [self setCurrentLevel:[aDecoder decodeIntegerForKey:@"currentLevel"]];
        [self setLives:[aDecoder decodeIntegerForKey:@"lives"]];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.currentScore forKey:@"currentScore"];
    [aCoder encodeInteger:self.currentLevel forKey:@"currentLevel"];
    [aCoder encodeInteger:self.lives forKey:@"lives"];
}

@end
