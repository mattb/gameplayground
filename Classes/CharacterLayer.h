//
//  CharacterLayer.h
//  Game
//
//  Created by Matt Biddulph on 20/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "Layer.h"
#import "Player.h"
#import "CameraZoomAction.h"
#import "Obstacle.h"
#import "CocosDenshion.h"

@interface CharacterLayer : Layer {
	CDSoundEngine *soundEngine;
    Player *player;
	cpSpace *space;
    NSTimeInterval lastTouch;
    CGPoint firstTouchPoint;
}

@end
