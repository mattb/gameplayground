//
//  CharacterLayer.m
//  Game
//
//  Created by Matt Biddulph on 20/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "CharacterLayer.h"
#import "cocos2d.h"

@implementation CharacterLayer
- (id) init {
    self = [super init];
    if(self != nil) {
		self.isTouchEnabled = YES;
        player = [Player node];
        player.position = ccp(120,120);
        [self addChild:player];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// Touch Events ////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

- (BOOL) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
    player.position = ccp(point.y, point.x);
    
	return YES;
}

- (BOOL) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    player.position = ccp(point.y, point.x);
	return YES;
}

- (BOOL) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    player.position = ccp(point.y, point.x);

	return YES;
}

@end
