//
//  ECAViewController.m
//  Alienation
//
//  Created by Eben Carek on 10/28/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import "ECAViewController.h"
#import "ECAIntroScene.h"
#import "ECAAppDelegate.h"
#import "ECAGameOverScene.h"
#import <SpriteKit/SpriteKit.h>

@interface ECAViewController ()

//@property (strong, nonatomic) ECAGameOverScene *gameOverScene;

@end

@implementation ECAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView *spriteView = (SKView *)self.view;
    
    spriteView.showsDrawCount = YES;
    spriteView.showsFPS = YES;
    spriteView.showsNodeCount = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SKView *spriteView = (SKView *)self.view;
    
    if (![(ECAAppDelegate *)[[UIApplication sharedApplication] delegate] gameOverScene])
    {
        ECAIntroScene *introScene = [[ECAIntroScene alloc] initWithSize:self.view.frame.size];
        [spriteView presentScene:introScene];
    }
    else
    {
        [spriteView presentScene:[(ECAAppDelegate *)[[UIApplication sharedApplication] delegate] gameOverScene]];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
