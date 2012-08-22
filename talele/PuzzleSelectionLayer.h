/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PuzzleGrid.h"
@interface PuzzleSelectionLayer : CCLayer {
    CGSize screenSize;    
    CCSpriteFrameCache* sceneSpriteBatchNode;
    PuzzleGrid* puzzleGrid;
}

+(CCScene *) scene;


@end
