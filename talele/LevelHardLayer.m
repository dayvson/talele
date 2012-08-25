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


-(void) loadPieces {
    float posInitialX = puzzleImage.position.x;
    float posInitialY = puzzleImage.position.y;
    float deltaX = 0;
    float deltaY = 0;
    int rows = 4;
    int cols = 6;
    int totalPieces = cols*rows;
    int i = 0;
    float randX;
    float randY;
    float wlimit;
    float hlimit;
    NSDictionary* levelInfo = [GameHelper getPlist:@"levelHard"];
    UIImage* tempPuzzle = [ImageHelper convertSpriteToImage:
                           [CCSprite spriteWithTexture:[puzzleImage texture]]];
    for (int c = 1; c<=totalPieces; c++, i++) {        
        NSString *pName = [NSString stringWithFormat:@"p%d.png", c];
        Piece* item = [[Piece alloc] initWithName:pName andMetadata:[levelInfo objectForKey:pName]];
        [item setName:[NSString stringWithFormat:@"%@_puzzle_%@", pName,[GameManager sharedGameManager].currentPuzzle]];
        deltaX = [self getDeltaX:item.hAlign withIndex:i andPieceWidth:item.width andCols:cols andRows:rows];
        deltaY = [self getDeltaY:item.vAlign withIndex:i andPieceHeight:item.height andCols:cols andRows:rows];
        [item createMaskWithPuzzle:tempPuzzle 
                         andOffset:ccp(deltaX, tempPuzzle.size.height + deltaY - item.height)];
        item.anchorPoint = ccp(0,1);
        item.xTarget = posInitialX + deltaX;
        item.yTarget = posInitialY + tempPuzzle.size.height + deltaY;
        [item setScale:0.8f];
        wlimit = screenSize.width-item.width-30;
        hlimit = screenSize.height-item.height-50;        
        if (c % 2 == 0){
            randX = [GameHelper randomFloatBetween:item.width and:wlimit];
            randY = [GameHelper randomFloatBetween:item.height and: 150];
        }else{
            randX = [GameHelper randomFloatBetween:10 and:90];
            randY = [GameHelper randomFloatBetween:item.height and: hlimit];
        }
        [item setPosition:ccp(randX, randY)];
        [self addChild:item];
        [pieces addObject:item];
    }
}

-(void) initBackground {
	CCSprite *background;
    background = [CCSprite spriteWithFile:@"background-gameplay.png"];
	background.position = ccp(screenSize.width/2, screenSize.height/2);
	[self addChild: background];    
}

-(void) resetScreen {
    [self removeAllPieces];
    [self removeAllChildrenWithCleanup:TRUE];
    if(pieces){
        [pieces release];
    }
    
}
-(void) onExit{

    [self resetScreen];
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
    CCLOG(@"EXIIIIIIIIIIITTTTTTT");
}

-(void) onEnter
{
	[super onEnter];
    CCDirector * director_ = [CCDirector sharedDirector];
    screenSize = [director_ winSize];
    [self resetScreen];
    if(puzzleImage){
        [puzzleImage removeAllChildrenWithCleanup:YES];
        [puzzleImage release];
        puzzleImage = nil;
    }
    pieces = [[NSMutableArray alloc] initWithCapacity:24];
    zIndex = 400;
    [[director_ touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [self loadPlistLevel:@"pieces_6x4.plist" andSpriteName:@"pieces_6x4.png"];
    [self initBackground];
    [self initMenu];
    NSString* puzz = [GameManager sharedGameManager].currentPuzzle;
    [self loadPuzzleImage:puzz];
    [self loadPieces];
}

-(void)dealloc {
    [self resetScreen];
    [puzzleImage release];
    [super dealloc];
    
}

@end