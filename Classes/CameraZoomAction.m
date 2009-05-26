//
//  CameraZoomAction.m
//  Game
//
//  Created by Matt Biddulph on 25/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "CameraZoomAction.h"


@implementation CameraZoomAction
+(id) actionWithDuration: (ccTime) t x:(float)toX y:(float)toY z:(float)toZ
{	
	return [[[self alloc] initWithDuration:t x:toX y:toY z:toZ ] autorelease];
}

-(id) initWithDuration: (ccTime) t x:(float)toX y:(float)toY z:(float)toZ
{
	if( !(self=[super initWithDuration: t]) )
		return nil;
	
    x = toX;
    y = toY;
    z = toZ;
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	Action *copy = [[[self class] allocWithZone: zone] initWithDuration:[self duration] x:x y:y z:z];
	return copy;
}

-(void) start
{
	[super start];
    [[target camera] eyeX:&originX eyeY:&originY eyeZ:&originZ];
}

-(void) update: (ccTime) t
{
    float theX = (originX - ((originX-x)*t));
    float theY = (originY - ((originY-y)*t));
    float theZ = (originZ - ((originZ-z)*t));
    //NSLog(@"Updating at %f to (%f, %f, %f)", t, theX, theY, theZ);
    [[target camera] setCenterX:theX centerY:theY centerZ:0.0f];
    [[target camera] setEyeX:theX eyeY:theY eyeZ:theZ];
}
@end
