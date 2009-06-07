//
//  FreepixelLayer.m
//  Game
//
//  Created by Matt Biddulph on 07/06/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "FreepixelLayer.h"


@implementation FreepixelLayer
- (id) init {
    self = [super init];
    if(self != nil) {
		self.isTouchEnabled = YES;
        AtlasSpriteManager *mgr = [AtlasSpriteManager spriteManagerWithFile:@"small-fry.png"];
        player = [FreepixelPlayer nodeWithManager:mgr];
        player.position = ccp(300,200);
        [player walkDown];
        [self addChild:mgr];
    }
    return self;
}

- (void) recordTouch:(CGPoint)point {
    if(point.x >= player.position.x) {
        if(point.y >= player.position.y) {
            [player walkUp];
        } else {
            [player walkRight];
        }
    } else {
        if(point.y < player.position.y) {
            [player walkDown];
        } else {
            [player walkLeft];
        }        
    }
}

- (BOOL) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *) event {
    UITouch *touch = [touches anyObject];
    [self recordTouch:[[Director sharedDirector] convertCoordinate:[touch locationInView: [touch view]]]];
    return YES;
}

- (BOOL) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *) event {
    UITouch *touch = [touches anyObject];
    [self recordTouch:[[Director sharedDirector] convertCoordinate:[touch locationInView: [touch view]]]];
    return YES;
}

- (BOOL) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *) event {
    UITouch *touch = [touches anyObject];
    [self recordTouch:[[Director sharedDirector] convertCoordinate:[touch locationInView: [touch view]]]];
    return YES;
}

@end
