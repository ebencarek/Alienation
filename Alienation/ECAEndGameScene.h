//
//  ECAEndGameScene.h
//  Alienation
//
//  Created by Eben Carek on 6/8/14.
//  Copyright (c) 2014 Eben Carek. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>

@interface ECAEndGameScene : SKScene <ADBannerViewDelegate>

- (id)initWithSize:(CGSize)size finalScore:(int)score;

@end
