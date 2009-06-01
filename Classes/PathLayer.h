//
//  PathLayer.h
//  Game
//
//  Created by Matt Biddulph on 01/06/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PathLayer : Layer {
    Sprite *thing;
    CGPoint points[10];
    NSTimeInterval times[10];
    int ring_idx;
}

@end
