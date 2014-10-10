//
//  ECAGameOverScene.h
//  Alienation
//
//  Created by Eben Carek on 11/9/13.
//  Copyright (c) 2013 Eben Carek. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>

@interface ECAGameOverScene : SKScene <ADBannerViewDelegate>

- (id)initWithSize:(CGSize)size won:(BOOL)won score:(int)score level:(NSUInteger)level;

@end
