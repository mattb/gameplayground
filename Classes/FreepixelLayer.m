//
//  FreepixelLayer.m
//  Game
//
//  Created by Matt Biddulph on 07/06/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "FreepixelLayer.h"
#import "InvaderManager.h"

@implementation FreepixelLayer
- (id) init {
    self = [super init];
    if(self != nil) {
		self.isTouchEnabled = YES;
        AtlasSpriteManager *mgr = [AtlasSpriteManager spriteManagerWithFile:@"small-fry.png"];
        player = [FreepixelPlayer nodeWithManager:mgr];
        player.position = ccp(200,50);
        [player walkDown];
        [self addChild:mgr];
        PointParticleSystem *snow = [ParticleSnow node];
        snow.speed = 100;
        snow.speedVar = 10;
        [self addChild:snow];
        InvaderManager *invaders = [InvaderManager node];
        for(int i = 0 ; i < 10; i++) {
            [[invaders addInvaderWithStyle:i andPosition:ccp(50 + i*20,200)] setRGB:255 :32 :32];
            [[invaders addInvaderWithStyle:i + 1 andPosition:ccp(50 + i*20,180)] setRGB:255 :255 :255];
            [[invaders addInvaderWithStyle:i + 2 andPosition:ccp(50 + i*20,160)] setRGB:0 :0 :255];
        }
        [self addChild:invaders];
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
