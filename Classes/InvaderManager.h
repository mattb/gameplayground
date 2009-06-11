//
//  InvaderManager.h
//  Game
//
//  Created by Matt Biddulph on 11/06/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Invader.h"

@interface InvaderManager : AtlasSpriteManager {
    NSMutableArray *invaders;
}

- (void)addInvaderWithStyle: (int)style andPosition:(CGPoint)position;

@end
