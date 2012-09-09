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

-(void) initStartGameButtons {

    easyButton = [GameHelper createMenuItemBySprite:@"btn-facil.png" target:self selector:@selector(onClickEasy)];
    hardButton = [GameHelper createMenuItemBySprite:@"btn-dificil.png" target:self selector:@selector(onClickHard)];
    CCMenu *levelMenu = [CCMenu menuWithItems:easyButton,hardButton, nil];
    [levelMenu alignItemsHorizontallyWithPadding:screenSize.height * 0.059f];
    [levelMenu setPosition: ccp(screenSize.height/2.0f + 140,100)];
    levelMenu.anchorPoint = ccp(0,0);
    [self addChild:levelMenu z:7 tag:7];
}

-(void) initNavigationButtons {
    prevButton = [GameHelper createMenuItemBySprite:@"btn-voltar.png" target:self selector:@selector(onClickPrevPuzzle)];
    nextButton = [GameHelper createMenuItemBySprite:@"btn-proximo.png" target:self selector:@selector(onClickNextPuzzle)];
    CCMenu *navArrowMenu = [CCMenu menuWithItems:prevButton,nextButton, nil];
    [navArrowMenu alignItemsHorizontallyWithPadding:680];
    [navArrowMenu setPosition: ccp(510,screenSize.height/2.0f )];
    [self addChild:navArrowMenu z:5 tag:5];
}

-(void) initPhotoButton {
    CCMenuItemSprite *pickbutton = [GameHelper createMenuItemBySprite:@"btn-foto.png"
                                                               target:self selector:@selector(onClickPhotoSelection)];
    CCMenu *photoMenu = [CCMenu menuWithItems:pickbutton, nil];
    photoMenu.anchorPoint = ccp(0,0);
    photoMenu.position = ccp(screenSize.width - 150 , screenSize.height - 100 );
    [self addChild:photoMenu z:3 tag:3];
}

-(void) checkPuzzleGridForEnableButtons{
    [prevButton setOpacity:(puzzleGrid.currentPage > 0)? 255 : 30];
    [prevButton setIsEnabled:(puzzleGrid.currentPage > 0)? YES : NO];
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
    //[[GameManager sharedGameManager] setCurrentPuzzle:(NSString*)sender.userData];
}

-(void) onMoveToCurrentPage:(NSObject*)obj {
    NSDictionary* puzzleInfo = (NSDictionary*)obj;
    NSString* puzzleName = [puzzleInfo objectForKey:@"name"];
    if([[puzzleInfo objectForKey:@"isLazy"] boolValue]){
        CCMenuItem * atualItem = (CCMenuItem*)[puzzleGrid getChildByTag:puzzleGrid.currentPage+1];
        CCMenuItemSprite * item = [self createPuzzleSprite:puzzleName withLazyLoad:NO];
        item.position = CGPointMake(atualItem.position.x,0);
        [puzzleGrid removeChildByTag:puzzleGrid.currentPage+1 cleanup:YES];
        [puzzleGrid addChild:item z:puzzleGrid.currentPage+1 tag:puzzleGrid.currentPage+1];
    }
    [[GameManager sharedGameManager] setCurrentPuzzle:puzzleName];
    [[GameManager sharedGameManager] setCurrentPage:puzzleGrid.currentPage];
    [self checkPuzzleGridForEnableButtons];
    if([self getChildByTag:40]){
        [self removeChildByTag:40 cleanup:YES];
    }
}

-(void)showEmptyBox{
    CCSprite *itemSprite = [[CCSprite alloc] initWithFile:@"empty.png"];
    CCMenuItemSprite *itemMenu = [CCMenuItemSprite itemWithNormalSprite:itemSprite selectedSprite:nil
                                                                 target:self selector:@selector(onClickPhotoSelection)];
    CCMenu *emptyMenu = [CCMenu menuWithItems:itemMenu, nil];
    emptyMenu.anchorPoint = ccp(0,0);
    emptyMenu.position = ccp(screenSize.width/2 , screenSize.height/2 );
    [self addChild:emptyMenu z:40 tag:40];
}


-(CCMenuItemSprite*) createPuzzleSprite:(NSString*)imageName withLazyLoad:(BOOL)lazyload{
    CCSprite* bg = [[CCSprite alloc] initWithFile:@"photobg.png"];
    if(!lazyload){
        CCSprite* img = [CCSprite spriteWithFile:imageName];
        img.anchorPoint = ccp(0,0);
        img.position = ccp(23,22);
        [img setScale:0.8];
        [bg addChild:img];
    }
    CCMenuItemSprite* item = [[CCMenuItemSprite alloc] initWithNormalSprite:bg
                                                             selectedSprite:nil
                                                             disabledSprite:nil
                                                                     target:self
                                                                   selector:@selector(updateSelectedImage:)];
    NSMutableDictionary* puzzleInfo = [[NSMutableDictionary alloc] init];
    [puzzleInfo setValue:imageName forKey:@"name"];
    [puzzleInfo setValue:[NSNumber numberWithBool:lazyload] forKey:@"isLazy"];
    item.userData = puzzleInfo;
    return item;
   
}

-(void) addNewPuzzleToGrid:(NSString*)puzzleName{
    CCMenuItemSprite * item = [self createPuzzleSprite:puzzleName withLazyLoad:NO];
    puzzleGrid.totalPages += 1;
    item.position = CGPointMake(screenSize.width * puzzleGrid.totalPages,0);
    [puzzleGrid addChild:item z:puzzleGrid.totalPages tag:puzzleGrid.totalPages];
    [puzzleGrid gotoPage:puzzleGrid.totalPages-1];
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
    int totalLoadEagleMode = [GameManager sharedGameManager].currentPage+1;
    int c = 0;
    for (int i=arrayNames.count; i--; c++) {
        [items addObject:[self createPuzzleSprite:[arrayNames objectAtIndex:i]
                                     withLazyLoad:(c > totalLoadEagleMode)]];
    }
    puzzleGrid = [[PuzzleGrid alloc] initWithArray:items
                                           position:ccp(screenSize.width/2, screenSize.height/2)
                                            padding:CGPointZero];
    [puzzleGrid setSwipeInMenu:YES];
    [puzzleGrid setDelegate:self];
    if(puzzleGrid.totalPages == 0){
        [self showEmptyBox];
    }else{
        [puzzleGrid gotoPage:[GameManager sharedGameManager].currentPage];
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[_picker dismissModalViewControllerAnimated:NO];
	[_picker.view removeFromSuperview];
	[_picker release];
	_picker = nil;
	[_popover dismissPopoverAnimated:NO];
	[_popover release];
    _popover = nil;
	[[CCDirector sharedDirector] startAnimation];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
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
    [picker dismissModalViewControllerAnimated: YES];
    [picker release];
    [_popover dismissPopoverAnimated:YES];
	[[CCDirector sharedDirector] startAnimation];
    [ImageHelper saveImageFromLibraryIntoPuzzlePlist:originalImage];
    [self loadPuzzleImages];
}

-(void) onEnter{
	[super onEnter];
    screenSize = [[CCDirector sharedDirector] winSize];
    [CCSpriteFrameCache sharedSpriteFrameCache];
    [self loadPlistLevel];
    [self initBackground];
}

-(void)onEnterTransitionDidFinish{
    [self loadPuzzleImages];
    [self initStartGameButtons];
    [self initNavigationButtons];
    [self initPhotoButton];
    [self checkPuzzleGridForEnableButtons];
}

-(void) onExit{
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
}

-(void)dealloc {
    [super dealloc];
}

@end
