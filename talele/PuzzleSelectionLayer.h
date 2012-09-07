/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "cocos2d.h"
#import "PuzzleGrid.h"
@interface PuzzleSelectionLayer : CCLayer <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>{
    CGSize screenSize;    
    CCSpriteFrameCache* sceneSpriteBatchNode;
    PuzzleGrid* puzzleGrid;
    UIImagePickerController *_picker;
    UIPopoverController *_popover;
    UIWindow *window;
	UIImage *newImage;
    CCMenuItemSprite *prevButton;
    CCMenuItemSprite *nextButton;
}

+(CCScene *) scene;


@end
