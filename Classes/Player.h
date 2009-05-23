//
//  Player.h
//  Game
//
//  Created by Matt Biddulph on 20/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "Sprite.h"

@interface Player : Sprite {
    cpBody *body;
}

@property (nonatomic) cpBody *body;

@end
