//
//  FreepixelPlayer.h
//  Game
//
//  Created by Matt Biddulph on 07/06/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FreepixelPlayer : AtlasSprite {
    AtlasSpriteManager *manager;
    AtlasAnimation *right;
    AtlasAnimation *down;
    AtlasAnimation *up;
}

+(id) nodeWithManager:(AtlasSpriteManager *)mgr;
-(void) walkUp;
-(void) walkDown;
-(void) walkLeft;
-(void) walkRight;

@property (nonatomic, retain) AtlasSpriteManager *manager;

@end