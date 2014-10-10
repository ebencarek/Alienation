//
//  ECAAppDelegate.m
//  Alienation
//
//  Created by Eben Carek on 10/28/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECAAppDelegate.h"
#import "ECAGameScene.h"
#import "ECASavedGameStore.h"
#import <SpriteKit/SpriteKit.h>

@interface ECAAppDelegate ()

@end

@implementation ECAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.adBanner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"Application closed");
    
    SKView *view = (SKView *)self.window.rootViewController.view;
    
    if ([view.scene isKindOfClass:[ECAGameScene class]])
    {
        ECAGameScene *scene = (ECAGameScene *)view.scene;
        
        [scene prepareForBackground];
        /*
         if (scene.paused == NO && scene.gameplayActive == YES)
         {
         scene.paused = YES;
         [scene addChild:scene.resumeButton];
         [scene addChild:scene.quitButton];
         [scene addChild:scene.blackShade];
         }
         else if (scene.paused == NO && scene.gameplayActive == NO)
         {
         scene.paused = YES;
         }
         */
    }
    
    BOOL success = [[ECASavedGameStore savedGameStore] saveGameToFile];
    
    if (success)
    {
        NSLog(@"successfully saved game to file");
    }
    else
    {
        NSLog(@"game could not be saved to file");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    SKView *view = (SKView *)self.window.rootViewController.view;
    
    if ([view.scene isKindOfClass:[ECAGameScene class]])
    {
        ECAGameScene *scene = (ECAGameScene *)view.scene;
        
        [scene refreshFromBackground];
        /*
         if (scene.paused == YES && scene.gameplayActive == NO)
         {
         scene.paused = NO;
         }
         */
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    SKView *view = (SKView *)self.window.rootViewController.view;
    
    if ([view.scene isKindOfClass:[ECAGameScene class]])
    {
        ECAGameScene *scene = (ECAGameScene *)view.scene;
        
        [scene refreshFromBackground];
        /*
         if (scene.paused == YES && scene.gameplayActive == NO)
         {
         scene.paused = NO;
         }
         */
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end