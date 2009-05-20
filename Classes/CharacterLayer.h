//
//  CharacterLayer.h
//  Game
//
//  Created by Matt Biddulph on 20/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Layer.h"
#import "Player.h"

@interface CharacterLayer : Layer {
    Player *player;
}

@end
