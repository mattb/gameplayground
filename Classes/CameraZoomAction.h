//
//  CameraZoomAction.h
//  Game
//
//  Created by Matt Biddulph on 25/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CameraZoomAction : IntervalAction <NSCopying>
{
	float x, y, z;
    float originX, originY, originZ;
}
/** creates the action */
+(id) actionWithDuration:(ccTime)duration x:(float)toX y:(float)toY z:(float)toZ;
/** initializes the action */
-(id) initWithDuration:(ccTime)duration x:(float)toX y:(float)toY z:(float)toZ;

@end
