/* cocos2d for iPhone
 *
 * http://code.google.com/p/cocos2d-iphone
 *
 * Copyright (C) 2009 Ricardo Quesada
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the 'cocos2d for iPhone' license.
 *
 * You will find a copy of this license within the cocos2d for iPhone
 * distribution inside the "LICENSE" file.
 *
 */

#import "CocosNode.h"

/** ParallaxNode: A node that simulates a parallax scroller
 
 The children will be moved faster / slower than the parent according the the parallax ratio.
 
 */
@interface ParallaxNode : CocosNode {
	NSMutableDictionary	*parallaxDictionary;
}

/** Adds a child to the container with a z-order, a parallax ratio and a position offset
 It returns self, so you can chain several addChilds.
 @since v0.8
 */
-(id) addChild: (CocosNode*)node z:(int)z parallaxRatio:(CGPoint)c positionOffset:(CGPoint)positionOffset;

@end
