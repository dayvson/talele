/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "PuzzleSelectionLayer.h"
#import "GameConstants.h"
#import "GameManager.h"
#import "GameHelper.h"
#import "ImageHelper.h"
#import <MobileCoreServices/UTCoreTypes.h>

@implementation PuzzleSelectionLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	PuzzleSelectionLayer *layer = [PuzzleSelectionLayer node];
	[scene addChild: layer];
	return scene;
}

-(void) loadPlistLevel {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttons.plist"];
    sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"buttons.png"];    
    [self addChild:sceneSpriteBatchNode z:1];
    
}

-(void) onClickHard {
    [[GameManager sharedGameManager] setCurrentPuzzle:(NSString*)puzzleGrid.getCurrentPageData];
    [[GameManager sharedGameManager] runSceneWithID:kLevelHard];
}

-(void) onClickEasy {
    [[GameManager sharedGameManager] setCurrentPuzzle:(NSString*)puzzleGrid.getCurrentPageData];
    [[GameManager sharedGameManager] runSceneWithID:kLevelEasy];
}

-(void) onClickPrevPuzzle {
    [puzzleGrid GoToPrevPage];
}

-(void) onClickNextPuzzle {
    [puzzleGrid GoToNextPage];
}

-(void) onClickPhotoSelection {
    CCLOG(@"SHOOOWWWWW PICKRE");
    [self showPhotoLibrary];    

}

-(CCMenuItemSprite *) createItemBySprite:(NSString *)name andCallback:(SEL)callback{
    CCSprite *itemSprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                         sharedSpriteFrameCache]
                                                                        spriteFrameByName:name]];
    CCMenuItemSprite *itemMenu = [CCMenuItemSprite itemFromNormalSprite:itemSprite
                                selectedSprite:nil target:self selector:callback];
    return itemMenu;
}
-(void) initStartGameButtons {

    CCMenuItemSprite *easyButton = [self createItemBySprite:@"btn-facil.png" andCallback:@selector(onClickEasy)];
    CCMenuItemSprite *hardButton = [self createItemBySprite:@"btn-dificil.png" andCallback:@selector(onClickHard)];
    CCMenu *mainMenu = [CCMenu menuWithItems:easyButton,hardButton, nil];
    [mainMenu alignItemsHorizontallyWithPadding:screenSize.height * 0.059f];
    [mainMenu setPosition: ccp(screenSize.width * 2.0f, screenSize.height / 2.0f)];
    id moveAction = [CCMoveTo actionWithDuration:0.5f 
                                        position:ccp(screenSize.height/2.0f + 140 ,
                                                      100)];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    id sequenceAction = [CCSequence actions:moveEffect,nil];
    [mainMenu runAction:sequenceAction];
    mainMenu.anchorPoint = ccp(0,0);
    [self addChild:mainMenu z:7 tag:7];
}

-(void) initNavigationButtons {
    CCMenuItemSprite *prevButton = [self createItemBySprite:@"btn-voltar.png" andCallback:@selector(onClickPrevPuzzle)];
    CCMenuItemSprite *nextButton = [self createItemBySprite:@"btn-proximo.png" andCallback:@selector(onClickNextPuzzle)];
    CCMenu *mainMenu = [CCMenu menuWithItems:prevButton,nextButton, nil];
    [mainMenu alignItemsHorizontallyWithPadding:680];
    [mainMenu setPosition: ccp(screenSize.width * 2.0f, screenSize.height / 2.0f)];
    id moveAction = [CCMoveTo actionWithDuration:0.5f 
                                        position:ccp(510 ,
                                        screenSize.height/2.0f )];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    id sequenceAction = [CCSequence actions:moveEffect,nil];
    [mainMenu runAction:sequenceAction];
    
    [self addChild:mainMenu z:5 tag:5];
}

-(void) initPhotoButton {
    CCMenuItemSprite *pickbutton = [self createItemBySprite:@"btn-foto.png" andCallback:@selector(onClickPhotoSelection)];
    CCMenu *mainMenu = [CCMenu menuWithItems:pickbutton, nil];
    mainMenu.anchorPoint = ccp(0,0);
    mainMenu.position = ccp(screenSize.width - 150 , screenSize.height - 100 );
    [self addChild:mainMenu z:3 tag:3];

    
}

-(void) initBackground {
	CCSprite *background;
    background = [CCSprite spriteWithFile:@"background-puzzle-selection.png"];
	background.position = ccp(screenSize.width/2, screenSize.height/2);
    
	[self addChild: background z:1 tag:1];
}
-(void) updateSelectedImage:(CCMenuItemSprite*)sender{
    [[GameManager sharedGameManager] setCurrentPuzzle:(NSString*)sender.userData];
}

-(void) onMoveToCurrentPage:(NSObject*)obj {
    [[GameManager sharedGameManager] setCurrentPuzzle:(NSString*)obj];
}

-(void) loadPuzzleImages {
    NSDictionary* puzzlesInfo = [GameHelper getPlist:@"puzzles"];
    NSMutableArray *arrayNames = [[NSMutableArray alloc] 
                                  initWithObjects:@"batman.jpg",@"cars2.jpg",@"valente.jpg",@"tangled.jpg", @"arthur.jpg", @"aranha.jpg", @"bob.jpg", nil];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:arrayNames.count];
    for (int i=0; i<arrayNames.count; i++) {
      //  CCSprite* bg = [CCSprite spriteWithFile:@"photobg.png"];
        CCSprite* img = [CCSprite spriteWithFile:[arrayNames objectAtIndex:i]];
        img.anchorPoint = ccp(0,0);
        img.position = ccp(23,22);
        [img setScale:0.8];
        //[bg addChild:img];
        CCMenuItemSprite* item = [[CCMenuItemSprite alloc] initWithNormalSprite:img selectedSprite:nil disabledSprite:nil target:self selector:@selector(updateSelectedImage:)];
        item.userData = [arrayNames objectAtIndex:i];
        [items addObject:item];
    }
    puzzleGrid = [[PuzzleGrid alloc] initWithArray:items
                                           position:ccp(screenSize.width/2, screenSize.height/2)
                                            padding:CGPointZero];
    [puzzleGrid setSwipeInMenu:YES];
    [puzzleGrid setDelegate:self];
    [self addChild:puzzleGrid z:2 tag:2];

}

-(void) showPhotoLibrary
{
	if (_picker) {
		[_picker dismissModalViewControllerAnimated:NO];
		[_picker.view removeFromSuperview];
		[_picker release];
	}
	if (_popover) {
		[_popover dismissPopoverAnimated:NO];
		[_popover release];
	}
    [[CCDirector sharedDirector] pause];
	[[CCDirector sharedDirector] stopAnimation];
	_picker = [[[UIImagePickerController alloc] init] retain];
	_picker.delegate = self;
	_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	_picker.wantsFullScreenLayout = YES;
    _picker.allowsEditing = YES;
	_popover = [[[UIPopoverController alloc] initWithContentViewController:_picker] retain];
	[_popover setDelegate:self];
	[_popover setPopoverContentSize:CGSizeMake(200, 1000) animated:NO];
	CGRect r = CGRectMake(0,0,100,100);
	r.origin = [[CCDirector sharedDirector] convertToGL:r.origin];

	[_popover presentPopoverFromRect:r inView:[[CCDirector sharedDirector] view]
            permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [_picker.view setFrame:_picker.view.superview.frame];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[_picker dismissModalViewControllerAnimated:YES];
	[_picker.view removeFromSuperview];
	[_picker release];
	_picker = nil;
	[_popover dismissPopoverAnimated:YES];
	[_popover release];
}

//for Ipad UIPopoverController if there is a cancel when the user click outside the popover
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	[_picker dismissModalViewControllerAnimated:YES];
	[_picker.view removeFromSuperview];
	[_picker release];
	_picker = nil;
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
        editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        // Do something with imageToUse, apparently you cannot pass nil as the key
		//eg. mySprite = ;
        [self addChild: [CCSprite spriteWithCGImage:imageToUse.CGImage key:@"someKey"]];
    CCLOG(@"IMAGEMMMMMMM SELECIONADAAAAA");
    [picker dismissModalViewControllerAnimated: YES];
    [picker release];

}

//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    
//    CCDirector *director = [CCDirector sharedDirector];
////    [director purgeCachedData];
//	// newImage is a UIImage do not try to use a UIImageView
//	newImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    
//	// Dismiss UIImagePickerController and release it
//	[picker dismissModalViewControllerAnimated:YES];
//	[picker.view removeFromSuperview];
//	[picker	release];
//    
//	// Restart Director after image is selected
//	[director startAnimation];
//	[director resume];
//
//	CCSprite *imageFromPicker = [CCSprite spriteWithCGImage: newImage.CGImage
//														key:@"Teste.aaa"];
//	[imageFromPicker setPosition:ccp(self.contentSize.width/2, self.contentSize.height/2-30)];
//	[self addChild: imageFromPicker];
//}

-(void) onEnter
{
	[super onEnter];
    screenSize = [[CCDirector sharedDirector] winSize];
    [CCSpriteFrameCache sharedSpriteFrameCache ];
    [self loadPlistLevel];
    [self initBackground];
    [self initStartGameButtons];
    [self initNavigationButtons];
    [self initPhotoButton];
    [self loadPuzzleImages];


    
}


-(void)dealloc {
    [self removeAllChildrenWithCleanup:TRUE];
    [super dealloc];
    
}

@end
