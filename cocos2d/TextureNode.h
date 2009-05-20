/* cocos2d for iPhone
 *
 * http://code.google.com/p/cocos2d-iphone
 *
 * Copyright (C) 2008,2009 Ricardo Quesada
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the 'cocos2d for iPhone' license.
 *
 * You will find a copy of this license within the cocos2d for iPhone
 * distribution inside the "LICENSE" file.
 *
 */


#import <UIKit/UIKit.h>

#import "Support/Texture2D.h"

#import "CocosNode.h"


/** TextureNode is a subclass of CocosNode that implements the CocosNodeRGBA
 * and CocosNodeTexture protocol.
 *
 * As the name implies it, it knows how to render a textures.
 *
 * All features from CocosNode are valid, plus the following new features:
 *  - opacity and RGB
 *  - texture (can be Aliased or AntiAliased)
 */
@interface TextureNode : CocosNode <CocosNodeRGBA, CocosNodeTexture> {

	/// texture
	Texture2D *texture_;
	
	/// texture opacity
	GLubyte opacity_;
	
	/// texture color
	GLubyte	r_,g_,b_;
}

/** The texture that is rendered */
@property (readwrite,retain) Texture2D *texture;

/** conforms to CocosNodeRGBA protocol */
@property (readonly) GLubyte r, g, b, opacity;
@end
