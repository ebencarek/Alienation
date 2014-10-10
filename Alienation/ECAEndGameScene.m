//
//  ECAEndGameScene.m
//  Alienation
//
//  Created by Eben Carek on 6/8/14.
//  Copyright (c) 2014 Eben Carek. All rights reserved.
//

#import "ECAEndGameScene.h"
#import "ECAGameScene.h"

@interface ECAEndGameScene ()

@property (nonatomic) BOOL contentCreated;
@property (nonatomic) int finalScore;
@property (strong, nonatomic) SKLabelNode *congratulationsLabel;
@property (strong, nonatomic) SKLabelNode *youWinLabel;
@property (strong, nonatomic) SKLabelNode *finalScoreLabel1;
@property (strong, nonatomic) SKLabelNode *finalScoreLabel2;
@property (strong, nonatomic) SKLabelNode *startOverButton;
@property (strong, nonatomic) ADBannerView *adBanner;

@end


@implementation ECAEndGameScene

- (id)initWithSize:(CGSize)size finalScore:(int)score
{
    self = [super initWithSize:size];
    
    if (self)
    {
        self.finalScore = score;
    }
    
    return self;
}

-(id)initWithSize:(CGSize)size
{
    return [self initWithSize:size finalScore:0];
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        self.contentCreated = YES;
        
        [self createSceneContents];
    }
    
    self.adBanner = [(ECAAppDelegate *)[[UIApplication sharedApplication] delegate] adBanner];
    self.adBanner.delegate = self;
    self.adBanner.frame = CGRectMake(0, self.size.height - self.adBanner.frame.size.height, self.adBanner.frame.size.width, self.adBanner.frame.size.height);
    
    if (self.adBanner.bannerLoaded)
    {
        [self.view addSubview:self.adBanner];
    }
}

- (void)createSceneContents
{
    [self setBackgroundColor:[SKColor blackColor]];
    
    [self setScaleMode:SKSceneScaleModeAspectFit];
    
    [self addChild:[self addStars]];
    
    self.congratulationsLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    [self.congratulationsLabel setName:@"congratulationsLabel"];
    [self.congratulationsLabel setText:@"Congratulations!"];
    [self.congratulationsLabel setFontColor:[SKColor greenColor]];
    [self.congratulationsLabel setFontSize:28];
    [self.congratulationsLabel setPosition:CGPointMake(self.size.width / 2, (self.size.height / 2) + 200)];
    [self.congratulationsLabel setXScale:2];
    [self.congratulationsLabel setZPosition:1];
    
    self.youWinLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    [self.youWinLabel setName:@"youWinLabel"];
    [self.youWinLabel setText:@"You Win!"];
    [self.youWinLabel setFontColor:[SKColor greenColor]];
    [self.youWinLabel setFontSize:28];
    [self.youWinLabel setPosition:CGPointMake(self.size.width / 2, (self.size.height / 2) + 150)];
    [self.youWinLabel setXScale:2];
    [self.youWinLabel setZPosition:1];
    
    self.finalScoreLabel1 = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    [self.finalScoreLabel1 setName:@"finalScoreLabel1"];
    [self.finalScoreLabel1 setText:@"Your Score:"];
    [self.finalScoreLabel1 setFontColor:[SKColor greenColor]];
    [self.finalScoreLabel1 setFontSize:32];
    [self.finalScoreLabel1 setPosition:CGPointMake(self.size.width / 2, (self.size.height / 2) + 25)];
    [self.finalScoreLabel1 setXScale:2];
    [self.finalScoreLabel1 setZPosition:1];
    
    self.finalScoreLabel2 = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    [self.finalScoreLabel2 setName:@"finalScoreLabel2"];
    [self.finalScoreLabel2 setText:[NSString stringWithFormat:@"%d", self.finalScore]];
    [self.finalScoreLabel2 setFontColor:[SKColor greenColor]];
    [self.finalScoreLabel2 setFontSize:32];
    [self.finalScoreLabel2 setPosition:CGPointMake(self.size.width / 2, (self.size.height / 2) - 25)];
    [self.finalScoreLabel2 setXScale:2];
    [self.finalScoreLabel2 setZPosition:1];
    
    self.startOverButton = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    self.startOverButton = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
    [self.startOverButton setName:@"startOverButton"];
    [self.startOverButton setText:@"START OVER"];
    [self.startOverButton setFontColor:[SKColor greenColor]];
    [self.startOverButton setFontSize:30];
    [self.startOverButton setPosition:CGPointMake(self.size.width / 2, (self.size.height / 2) - 150)];
    [self.startOverButton setXScale:2];
    [self.startOverButton setZPosition:1];
    
    [self addChild:self.startOverButton];
    [self addChild:self.finalScoreLabel1];
    [self addChild:self.finalScoreLabel2];
    [self addChild:self.youWinLabel];
    [self addChild:self.congratulationsLabel];
}

- (void)willMoveFromView:(SKView *)view
{
    self.adBanner.delegate = nil;
    [self.adBanner removeFromSuperview];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"Banner View Loaded Ad");
    [self.view addSubview:banner];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (SKEmitterNode *)addStars
{
    SKEmitterNode *stars = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Stars" ofType:@"sks"]];
    
    stars.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    stars.zPosition = 0;
    
    return stars;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    SKLabelNode *touchedNode = (SKLabelNode *)[self nodeAtPoint:touchLocation];
    
    if ([touchedNode isEqual:self.startOverButton])
    {
        ECAGameScene *gameScene = [[ECAGameScene alloc] initWithSize:self.view.frame.size score:0];
        
        SKTransition *fade = [SKTransition fadeWithDuration:0.5];
        
        [[ECASpaceship sharedSpaceship] setLives:4];
        
        [self.view presentScene:gameScene transition:fade];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

@end
