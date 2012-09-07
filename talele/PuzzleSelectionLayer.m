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
}

-(void) onClickHard {
    [[GameManager sharedGameManager] runSceneWithID:kLevelHard];
}

-(void) onClickEasy {
    [[GameManager sharedGameManager] runSceneWithID:kLevelEasy];
}

-(void) onClickPrevPuzzle {
    [puzzleGrid gotoPrevPage];
}

-(void) onClickNextPuzzle {
    [puzzleGrid gotoNextPage];
}

-(void) onClickPhotoSelection {
    [self showPhotoLibrary];
}

-(CCMenuItemSprite *) createItemBySprite:(NSString *)name andCallback:(SEL)callback{
    CCSprite *itemSprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                         sharedSpriteFrameCache]
                                                                        spriteFrameByName:name]];
    CCMenuItemSprite *itemMenu = [CCMenuItemSprite itemWithNormalSprite:itemSprite
                                                         selectedSprite:nil target:self selector:callback];
    return itemMenu;
}
-(void) initStartGameButtons {

    easyButton = [self createItemBySprite:@"btn-facil.png" andCallback:@selector(onClickEasy)];
    hardButton = [self createItemBySprite:@"btn-dificil.png" andCallback:@selector(onClickHard)];
    CCMenu *levelMenu = [CCMenu menuWithItems:easyButton,hardButton, nil];
    [levelMenu alignItemsHorizontallyWithPadding:screenSize.height * 0.059f];
    [levelMenu setPosition: ccp(screenSize.height/2.0f + 140,100)];
    [levelMenu runAction:[CCFadeIn actionWithDuration:1.0f]];
    levelMenu.anchorPoint = ccp(0,0);
    [self addChild:levelMenu z:7 tag:7];
}

-(void) initNavigationButtons {
    prevButton = [self createItemBySprite:@"btn-voltar.png" andCallback:@selector(onClickPrevPuzzle)];
    nextButton = [self createItemBySprite:@"btn-proximo.png" andCallback:@selector(onClickNextPuzzle)];
    CCMenu *navArrowMenu = [CCMenu menuWithItems:prevButton,nextButton, nil];
    [navArrowMenu alignItemsHorizontallyWithPadding:680];
    [navArrowMenu setPosition: ccp(510,screenSize.height/2.0f )];
    [navArrowMenu runAction:[CCFadeIn actionWithDuration:1.0f]];
    [self addChild:navArrowMenu z:5 tag:5];
}

-(void) initPhotoButton {
    CCMenuItemSprite *pickbutton = [self createItemBySprite:@"btn-foto.png" andCallback:@selector(onClickPhotoSelection)];
    CCMenu *photoMenu = [CCMenu menuWithItems:pickbutton, nil];
    photoMenu.anchorPoint = ccp(0,0);
    photoMenu.position = ccp(screenSize.width - 150 , screenSize.height - 100 );
    [self addChild:photoMenu z:3 tag:3];
}

-(void) checkPuzzleGridForEnableButtons{
    [prevButton setOpacity:(puzzleGrid.currentPage >= 1)? 255 : 30];
    [prevButton setIsEnabled:(puzzleGrid.currentPage >= 1)? YES : NO];
    [nextButton setOpacity:(puzzleGrid.currentPage < puzzleGrid.totalPages-1)? 255 : 30];
    [nextButton setIsEnabled:(puzzleGrid.currentPage < puzzleGrid.totalPages-1)? YES : NO];
    [hardButton setIsEnabled:(puzzleGrid.totalPages > 0)];
    [hardButton setOpacity:(puzzleGrid.totalPages > 0)? 255 : 30];
    [easyButton setIsEnabled:(puzzleGrid.totalPages > 0)];
    [easyButton setOpacity:(puzzleGrid.totalPages > 0)? 255 : 30];
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
    [[GameManager sharedGameManager] setCurrentPage:puzzleGrid.currentPage];
    [self checkPuzzleGridForEnableButtons];
    if([self getChildByTag:40]){
        [self removeChildByTag:40 cleanup:YES];
    }
}

-(void)showEmptyBox{
    CCSprite *itemSprite = [[CCSprite alloc] initWithFile:@"photobg.png"];
    CCMenuItemSprite *itemMenu = [CCMenuItemSprite itemWithNormalSprite:itemSprite selectedSprite:nil
                                                                 target:self selector:@selector(onClickPhotoSelection)];
    CCMenu *emptyMenu = [CCMenu menuWithItems:itemMenu, nil];
    emptyMenu.anchorPoint = ccp(0,0);
    emptyMenu.position = ccp(screenSize.width/2 , screenSize.height/2 );
    [self addChild:emptyMenu z:40 tag:40];    
    [self checkPuzzleGridForEnableButtons];
}

-(void) loadPuzzleImages {
    if(puzzleGrid){
        [self removeChild:puzzleGrid cleanup:YES];
        puzzleGrid = nil;
    }
    NSDictionary* puzzlesInfo = [GameHelper getPlist:@"puzzles"];
    NSMutableArray *arrayNames = [[NSMutableArray alloc] 
                                  initWithArray:[puzzlesInfo objectForKey:@"puzzles"]];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:arrayNames.count];
    for (int i=0; i<arrayNames.count; i++) {
        CCSprite* bg = [[CCSprite alloc] initWithFile:@"photobg.png"];
        CCSprite* img = [CCSprite spriteWithFile:[arrayNames objectAtIndex:i]];
        img.anchorPoint = ccp(0,0);
        img.position = ccp(23,22);
        [img setScale:0.8];
        [bg addChild:img];
        CCMenuItemSprite* item = [[CCMenuItemSprite alloc] initWithNormalSprite:bg
                                                                 selectedSprite:nil
                                                                 disabledSprite:nil
                                                                         target:self
                                                                       selector:@selector(updateSelectedImage:)];
        item.userData = [arrayNames objectAtIndex:i];
        [items addObject:item];
    }
    puzzleGrid = [[PuzzleGrid alloc] initWithArray:items
                                           position:ccp(screenSize.width/2, screenSize.height/2)
                                            padding:CGPointZero];
    [puzzleGrid setSwipeInMenu:YES];
    [puzzleGrid setDelegate:self];
    [puzzleGrid gotoPage:[GameManager sharedGameManager].currentPage];
    if(puzzleGrid.totalPages == 0){
        [self showEmptyBox];
    }
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
    CCDirector * director =[CCDirector sharedDirector];
	[director stopAnimation];
	_picker = [[[UIImagePickerController alloc] init] retain];
	_picker.delegate = self;
	_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	_picker.wantsFullScreenLayout = NO;
    _picker.allowsEditing = NO;
	_popover = [[[UIPopoverController alloc] initWithContentViewController:_picker] retain];
    _popover.delegate = self;
	CGRect r = CGRectMake(screenSize.width/2,0,10,10);
	r.origin = [director convertToGL:r.origin];
	[_popover presentPopoverFromRect:r inView:[director view]
            permittedArrowDirections:0 animated:YES];
    _popover.popoverContentSize = CGSizeMake(320, screenSize.width);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[_picker dismissModalViewControllerAnimated:NO];
	[_picker.view removeFromSuperview];
	[_picker release];
	_picker = nil;
	[_popover dismissPopoverAnimated:NO];
	[_popover release];
    _popover = nil;
	[[CCDirector sharedDirector] startAnimation];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self imagePickerControllerDidCancel:nil];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    CGSize imageSize = CGSizeMake(693, 480);
    if([GameHelper isRetinaIpad]){
        imageSize.width = imageSize.width * 2;
        imageSize.height = imageSize.height * 2;
    }
    UIImage *originalImage;
    originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    originalImage = [ImageHelper cropImage:originalImage toSize:imageSize];
    [[CCDirector sharedDirector] purgeCachedData];
    [picker dismissModalViewControllerAnimated: YES];
    [picker release];
    [_popover dismissPopoverAnimated:YES];
	[[CCDirector sharedDirector] startAnimation];
    [ImageHelper saveImageFromLibraryIntoPuzzlePlist:originalImage];
    [self loadPuzzleImages];
    [puzzleGrid gotoPage:puzzleGrid.totalPages-1];
}

-(void) onEnter{
	[super onEnter];
    screenSize = [[CCDirector sharedDirector] winSize];
    [CCSpriteFrameCache sharedSpriteFrameCache];
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
