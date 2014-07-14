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
#import "AudioHelper.h"
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation PuzzleSelectionLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	PuzzleSelectionLayer *layer = [PuzzleSelectionLayer node];
	[scene addChild: layer];
	return scene;
}

-(void) onClickHard {
    [AudioHelper playHard];
    [[GameManager sharedGameManager] runSceneWithID:kLevelHard];
}

-(void) onClickNormal {
    [AudioHelper playNormal];
    [[GameManager sharedGameManager] runSceneWithID:kLevelNormal];
}

-(void) onClickEasy {
    [AudioHelper playEasy];
    [[GameManager sharedGameManager] runSceneWithID:kLevelEasy];
}

-(void) onClickPrevPuzzle {
    [AudioHelper playClick];
    [puzzleGrid gotoPrevPage];
}

-(void) onClickNextPuzzle {
    [AudioHelper playClick];
    [puzzleGrid gotoNextPage];
}

-(void) onClickPhotoSelection {
    [AudioHelper playSelectPicture];
    [self showPhotoLibrary];
}

-(void) initStartGameButtons {
    int language = [GameManager sharedGameManager].language;
    easyLabel = [GameHelper getLabelFontByLanguage:labelsEasy andLanguage:language];
    normalLabel = [GameHelper getLabelFontByLanguage:labelsNormal andLanguage:language];
    hardLabel = [GameHelper getLabelFontByLanguage:labelsHard andLanguage:language];
    easyButton = [GameHelper createMenuItemBySprite:@"btn-facil.png" target:self selector:@selector(onClickEasy)];
    easyLabel.position = ccp(easyButton.contentSize.width/2, easyButton.contentSize.height/2);
    [easyButton addChild:easyLabel];
    normalButton = [GameHelper createMenuItemBySprite:@"btn-normal.png" target:self selector:@selector(onClickNormal)];
    normalLabel.position = ccp(normalButton.contentSize.width/2, normalButton.contentSize.height/2);
    [normalButton addChild:normalLabel];
    hardButton = [GameHelper createMenuItemBySprite:@"btn-dificil.png" target:self selector:@selector(onClickHard)];
    hardLabel.position = ccp(hardButton.contentSize.width/2, hardButton.contentSize.height/2);
    [hardButton addChild:hardLabel];
    levelMenu = [CCMenu menuWithItems:easyButton,normalButton, hardButton, nil];
    [levelMenu alignItemsHorizontallyWithPadding:40];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [levelMenu setPosition: ccp(screenSize.height/2.0f + 140,130)];
    }else{
        [levelMenu setPosition: ccp(screenSize.height/2.0f + 80,60)];
    }
    
    if (iPhone5) {
        [levelMenu setPosition: ccp(screenSize.height/2.0f + 124,60)];
    }
    
    levelMenu.anchorPoint = ccp(0,0);
    [self addChild:levelMenu z:7 tag:7];
}

-(void) initNavigationButtons {
    prevButton = [GameHelper createMenuItemBySprite:@"btn-voltar.png" target:self
                                           selector:@selector(onClickPrevPuzzle)];
    nextButton = [GameHelper createMenuItemBySprite:@"btn-proximo.png" target:self
                                           selector:@selector(onClickNextPuzzle)];
    navArrowMenu = [CCMenu menuWithItems:prevButton,nextButton, nil];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [navArrowMenu setPosition: ccp(510,screenSize.height/2.0f + 30 )];
        [navArrowMenu alignItemsHorizontallyWithPadding:680];
    }else{
        [navArrowMenu setPosition: ccp(240,screenSize.height/2.0f + 30 )];
        [navArrowMenu alignItemsHorizontallyWithPadding:310];
    }
    if (iPhone5) {
        [navArrowMenu setPosition: ccp(285,screenSize.height/2.0f + 30 )];
        [navArrowMenu alignItemsHorizontallyWithPadding:310];
    }
    [self addChild:navArrowMenu z:5 tag:5];
}

-(void) initPhotoButton {
    CCMenuItemSprite *pickbutton = [GameHelper createMenuItemBySprite:@"btn-foto.png"
                                                               target:self
                                                             selector:@selector(onClickPhotoSelection)];
    CCMenu *photoMenu = [CCMenu menuWithItems:pickbutton, nil];
    photoMenu.anchorPoint = ccp(0,0);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        photoMenu.position = ccp(screenSize.width - 80 , screenSize.height - 85 );
    }else{
        photoMenu.position = ccp(screenSize.width - 30 , screenSize.height - 25 );
    }
    [self addChild:photoMenu z:3 tag:3];
}

-(void) checkPuzzleGridForEnableButtons{
    [prevButton setOpacity:(puzzleGrid.currentPage > 0)? 255 : 30];
    [prevButton setIsEnabled:(puzzleGrid.currentPage > 0)? YES : NO];
    [nextButton setOpacity:(puzzleGrid.currentPage < puzzleGrid.totalPages-1)? 255 : 30];
    [nextButton setIsEnabled:(puzzleGrid.currentPage < puzzleGrid.totalPages-1)? YES : NO];
    [levelMenu setEnabled:(puzzleGrid.totalPages > 0)? YES : NO];
    [levelMenu setOpacity:(puzzleGrid.totalPages > 0)? 255 : 30];
}
-(void) initBackground {
	CCSprite *background;
    background = [CCSprite spriteWithFile:i5res(@"background-puzzle-selection.png")];
	background.position = ccp(screenSize.width/2, screenSize.height/2);
	[self addChild: background z:1 tag:1];
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

-(void)onClickPhoto{
    CCLOG(@"CLICK OVER IMAGE");
}
-(void)showEmptyBox{
    CCSprite *itemSprite = [[CCSprite alloc] initWithFile:@"empty.png"];
    CCMenuItemSprite *itemMenu = [CCMenuItemSprite itemWithNormalSprite:itemSprite selectedSprite:nil
                                                                 target:self
                                                               selector:@selector(onClickPhotoSelection)];
    CCMenu *emptyMenu = [CCMenu menuWithItems:itemMenu, nil];
    emptyMenu.anchorPoint = ccp(0,0);
    emptyMenu.position = ccp(screenSize.width/2 , screenSize.height/2 + 30 );
    [self addChild:emptyMenu z:40 tag:40];
}

-(void)onClickDelete{
    [ImageHelper removeImageFromPage:[(NSDictionary*)puzzleGrid.getCurrentPageData objectForKey:@"name"]];
    if([GameManager sharedGameManager].currentPage>0){
        [GameManager sharedGameManager].currentPage -= 1;
    }
    [self loadPuzzleImages];
    [self checkPuzzleGridForEnableButtons];
}

-(void) onClickBack {
    [AudioHelper playBack];
    [[GameManager sharedGameManager] runSceneWithID:kHomeScreen];
}

-(void) initBackMenu {
    CCMenuItemSprite *backButton =[GameHelper createMenuItemBySprite:@"btn-voltar-mini.png"
                                                              target:self selector:@selector(onClickBack)];
    CCMenu *backMenu = [CCMenu menuWithItems:backButton,nil];
    [backMenu setPosition:ccp(backButton.contentSize.width-15,
                              screenSize.height - (backButton.contentSize.height))];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [backMenu setPosition:ccp(backButton.contentSize.width-5,
                                  screenSize.height - backButton.contentSize.height )];
        
    }
    [self addChild:backMenu z:7 tag:70];
}

-(CCMenuItemSprite*) createPuzzleSprite:(NSString*)imageName withLazyLoad:(BOOL)lazyload{
    CCSprite* bg = [[CCSprite alloc] initWithFile:@"photobg.png"];

    CCMenuItemSprite *btnDelete = [GameHelper createMenuItemBySprite:@"btn-close.png"
                                                              target:self selector:@selector(onClickDelete)];
    CCMenu* menuDelete = [CCMenu menuWithItems:btnDelete, nil];
    menuDelete.position = ccp(bg.position.x+bg.contentSize.width-(btnDelete.contentSize.width/4),
                             bg.position.y+bg.contentSize.height-(btnDelete.contentSize.height/4));
    CCSprite* cloud = [[CCSprite alloc] initWithFile:@"cloud-photo-support-front.png"];
    cloud.anchorPoint = ccp(0,0);
    cloud.position = ccp(-40,-5);
    if(!lazyload){
        CCSprite* img = [[CCSprite alloc] initWithFile:[GameHelper getResourcePathByName:imageName]];
        img.anchorPoint = ccp(0,0);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            img.position = ccp(23,22);
        }else{
            img.position = ccp(10,10);
        }
        [img setScale:0.8];
        [bg addChild:img];
    }
    [bg addChild:cloud];
    [bg addChild:menuDelete];
    
    CCMenuItemSprite* item = [[CCMenuItemSprite alloc] initWithNormalSprite:bg
                                                             selectedSprite:nil
                                                             disabledSprite:nil
                                                                     target:self
                                                                   selector:@selector(onClickPhoto)];
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
                                           position:ccp(screenSize.width/2, screenSize.height/2+30)
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
	_picker.wantsFullScreenLayout = YES;
    _picker.allowsEditing = NO;
    CGRect r = CGRectMake(screenSize.width/2,0,10,10);

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        _popover = [[[UIPopoverController alloc] initWithContentViewController:_picker] retain];
        _popover.delegate = self;
        r.origin = [director convertToGL:r.origin];
        [_popover presentPopoverFromRect:r inView:[director view]
            permittedArrowDirections:0 animated:YES];
        _popover.popoverContentSize = CGSizeMake(320, screenSize.width);
    }else{
        [director presentModalViewController:_picker animated:YES];
    }
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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]){
            imageSize.width = 648;
            imageSize.height = 448;
        }else{
            imageSize.width = 324;
            imageSize.height = 224;
        }
    }
    
    UIImage *originalImage;
    originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    originalImage = [ImageHelper cropImage:originalImage toSize:imageSize];
    [picker dismissModalViewControllerAnimated: YES];
    [picker release];
    [_popover dismissPopoverAnimated:YES];
	[[CCDirector sharedDirector] startAnimation];
    [ImageHelper saveImageFromLibraryIntoPuzzlePlist:originalImage];
    [GameManager sharedGameManager].currentPage = 0;
    [self loadPuzzleImages];
}


-(void) createExplosionAtPosition:(CGPoint)point{
    if(explosion != nil){
        [explosion resetSystem];
        [self removeChild:explosion cleanup:NO];
        explosion = nil;
    }
    explosion = [[CCParticleSun alloc] initWithTotalParticles:50];
    explosion.texture = [[CCTextureCache sharedTextureCache] addImage:@"snow.png"];
    explosion.autoRemoveOnFinish = YES;
    explosion.speed = 30.0f;
    explosion.duration = 0.5f;
    explosion.emitterMode = 1;
    explosion.startSize = 20;
    explosion.endSize = 80;
    explosion.life = 0.6;
    explosion.endRadius = 120;
    explosion.position = point;
    [self addChild:explosion z:1000 tag:1000];
}

-(void) updateLabels{
    int language = [GameManager sharedGameManager].language;
    [easyLabel setString:[labelsEasy objectAtIndex:language]];
    [normalLabel setString:[labelsNormal objectAtIndex:language]];
    [hardLabel setString:[labelsHard objectAtIndex:language]];
}

-(void) onEnter{
	[super onEnter];
    screenSize = [[CCDirector sharedDirector] winSize];
    [CCSpriteFrameCache sharedSpriteFrameCache];
    labelsEasy = [[NSArray alloc] initWithObjects:@"EASY",@"FÁCIL",@"TRANQUILO",@"简单", nil ];
    labelsNormal = [[NSArray alloc] initWithObjects:@"NORMAL",@"NORMAL",@"REGULAR",@"容易", nil ];
    labelsHard = [[NSArray alloc] initWithObjects:@"HARD",@"DIFÍCIL",@"DURO",@"复杂", nil ];
    [self initBackground];

}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self createExplosionAtPosition:touchLocation];
    return YES;
}


-(void)onEnterTransitionDidFinish{
    [self loadPuzzleImages];
    [self initStartGameButtons];
    [self initNavigationButtons];
    [self initPhotoButton];
    [self checkPuzzleGridForEnableButtons];
    [self initBackMenu];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];

}

-(void) onExit{
    [super onExit];
    [levelMenu setEnabled:NO];
    [navArrowMenu setEnabled:NO];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [self removeChild:levelMenu cleanup:YES];
    [self removeChild:navArrowMenu cleanup:YES];
}

-(void)dealloc {
    [super dealloc];
}

@end
