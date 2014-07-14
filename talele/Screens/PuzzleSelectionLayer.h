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
    PuzzleGrid* puzzleGrid;
    UIImagePickerController *_picker;
    UIPopoverController *_popover;
    UIWindow *window;
	UIImage *newImage;
    CCLabelBMFont *easyLabel;
    CCLabelBMFont *normalLabel;
    CCLabelBMFont *hardLabel;
    CCMenuItemSprite *prevButton;
    CCMenuItemSprite *nextButton;
    CCMenuItemSprite *easyButton;
    CCMenuItemSprite *hardButton;
    CCMenuItemSprite *normalButton;
    CCParticleSystem *explosion;
    CCMenu *navArrowMenu;
    CCMenu *levelMenu;
    NSArray *labelsEasy;
    NSArray *labelsNormal;
    NSArray *labelsHard;
}

+(CCScene *) scene;


@end
