/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "LevelHardLayer.h"
#import "GameConfig.h"
#import "GameManager.h"
#import "ImageHelper.h"
#import "GameHelper.h"

@implementation LevelHardLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	LevelHardLayer *layer = [LevelHardLayer node];
	[scene addChild: layer];
	return scene;
}

-(void) onClickBack {
    [[GameManager sharedGameManager] runSceneWithID:kPuzzleSelection];
}

-(void) initBackground {
	CCSprite *background;
    background = [CCSprite spriteWithFile:@"background-gameplay.png"];
	background.position = ccp(screenSize.width/2, screenSize.height/2);
	[self addChild: background];    
}

-(void)onExit{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_6x4.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_6x4.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_6x4_bevel.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_6x4_bevel.png"];
    [self removeAllChildrenWithCleanup:TRUE];    
}

-(void) onEnter
{
	[super onEnter];
    [self resetScreen];
    CCDirector * director_ = [CCDirector sharedDirector];
    [director_ purgeCachedData];
    screenSize = [director_ winSize];
    [[director_ touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    self.isTouchEnabled = YES;
    zIndex = 400;
    [self initBackground];
    UIActivityIndicatorView *myIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    myIndicator.frame = CGRectMake(139.0f-18.0f, 80.0f, 37.0f, 37.0f);
	myIndicator.center = CGPointMake(160, 240);
	myIndicator.hidesWhenStopped = NO;
    [myIndicator setUserInteractionEnabled:NO];
    [myIndicator startAnimating];
    [[director_ view] addSubview:myIndicator];

}
-(void) onEnterTransitionDidFinish{
    int cols = 6;
    int rows = 4;
    pieces = [[NSMutableArray alloc] initWithCapacity:cols*rows];
    [self loadPuzzleImage:[GameManager sharedGameManager].currentPuzzle];
    [self loadLevelSprites:@"6x4"];
    [self loadPieces:@"levelHard" withCols:cols andRols:rows];
    [self initMenu];
    
}
-(void)dealloc {
    [super dealloc];
}

@end