//
//  ECASavedGameStore.m
//  Alienation
//
//  Created by Eben Carek on 1/8/14.
//  Copyright (c) 2014 Eben Carek. All rights reserved.
//

#import "ECASavedGameStore.h"

static ECASavedGameStore *gameStore = nil;

@implementation ECASavedGameStore

+ (ECASavedGameStore *)savedGameStore
{
    if (!gameStore)
    {
        gameStore = (ECASavedGameStore *) [[super allocWithZone:nil] init];
    }
    
    return gameStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self savedGameStore];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        NSString *path = [self savedGameArchivePath];
        savedGame = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!savedGame)
        {
            savedGame = [[ECASavedGame alloc] init];
        }
    }
    
    return self;
}

- (ECASavedGame *)savedGame
{
    return savedGame;
}

- (void)setCurrentScore:(int)score currentLevel:(NSUInteger)level lives:(NSInteger)lives
{
    savedGame.currentScore = score;
    savedGame.currentLevel = level;
    savedGame.lives = lives;
    
    NSLog(@"Updated saved game ------ Score: %d Level: %d Lives: %d", savedGame.currentScore, (int)savedGame.currentLevel, (int)savedGame.lives);
}

- (void)clearSavedGame
{
    savedGame.currentScore = 0;
    savedGame.currentLevel = 1;
    savedGame.lives = 3;
    
    NSLog(@"Cleared saved game");
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if ([fileManager fileExistsAtPath:[self savedGameArchivePath]])
    {
        BOOL success = [fileManager removeItemAtPath:[self savedGameArchivePath] error:nil];
        
        if (success)
        {
            NSLog(@"Deleted game file");
        }
        else
        {
            NSLog(@"Could not delete game file");
        }
    }
    
    
}

- (NSString *)savedGameArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = documentDirectories[0];
    
    return [documentDirectory stringByAppendingPathComponent:@"game.archive"];
}

- (BOOL)saveGameToFile
{
    NSString *path = [self savedGameArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:savedGame toFile:path];
}

@end
