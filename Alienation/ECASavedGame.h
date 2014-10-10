//
//  ECASavedGame.h
//  Alienation
//
//  Created by Eben Carek on 12/26/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECASavedGame : NSObject <NSCoding>

@property (nonatomic) int currentScore;
@property (nonatomic) NSUInteger currentLevel;
@property (nonatomic) NSInteger lives;

- (id)initWithCurrentScore:(int)score currentLevel:(NSUInteger)level lives:(NSInteger)lives;

@end
