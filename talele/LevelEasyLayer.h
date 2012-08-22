/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Piece.h"
@interface LevelEasyLayer : CCLayer {
	CGSize screenSize;
    NSMutableArray* pieces;
    Piece* selectedPiece;
    CCSprite* puzzleImage;
    CCSpriteFrameCache* sceneSpriteBatchNode;
    CCSpriteFrameCache* piecesSpriteBatchNode;
}
+(CCScene *) scene;


@end
