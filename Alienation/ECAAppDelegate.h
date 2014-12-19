//
//  ECAAppDelegate.h
//  Alienation
//
//  Created by Eben Carek on 10/28/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "ECAGameOverScene.h"

@interface ECAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ADBannerView *adBanner;
@property (strong, nonatomic) ECAGameOverScene *gameOverScene;

@end
