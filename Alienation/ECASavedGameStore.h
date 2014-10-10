//
//  ECASavedGameStore.h
//  Alienation
//
//  Created by Eben Carek on 1/8/14.
//  Copyright (c) 2014 Eben Carek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECASavedGame.h"

@interface ECASavedGameStore : NSObject
{
    ECASavedGame *savedGame;
}

+ (ECASavedGameStore *)savedGameStore;

- (ECASavedGame *)savedGame;
- (void)setCurrentScore:(int)score currentLevel:(NSUInteger)level lives:(NSInteger)lives;
- (void)clearSavedGame;
- (NSString *)savedGameArchivePath;
- (BOOL)saveGameToFile;

@end
