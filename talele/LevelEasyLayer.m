/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "LevelEasyLayer.h"
#import "GameConfig.h"
#import "GameManager.h"
#import "ImageHelper.h"
#import "GameHelper.h"

@implementation LevelEasyLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	LevelEasyLayer *layer = [LevelEasyLayer node];
	[scene addChild: layer];
	return scene;
}

-(void) onClickBack {
    [[GameManager sharedGameManager] runSceneWithID:kPuzzleSelection];
}

-(void) loadPuzzleImage:(NSString*)name {
    puzzleImage = [CCSprite spriteWithFile:name];
    puzzleImage.anchorPoint = ccp(0,0);
    [puzzleImage setOpacity:30];
	puzzleImage.position = ccp(screenSize.width - puzzleImage.contentSize.width - 28,
                               screenSize.height - puzzleImage.contentSize.height - 20);
	[self addChild: puzzleImage];
}

-(float) getDeltaX:(int)hAlign withIndex:(int)index andPieceWidth:(float)pieceWidth{
    float qWidth = puzzleImage.contentSize.width/6;
    float deltaX = 0;
    switch (hAlign) {
        case kHAlignCENTER:
            deltaX = (ceil(index%6) * qWidth) - pieceWidth/2 + qWidth/2;//center
            break;
        case kHAlignLEFT:
            deltaX = ceil(index%6) * qWidth;
            break;
        case kHAlignRIGHT:
            deltaX = (ceil(index%6) * qWidth) - pieceWidth + qWidth;
            break;
    }
    return deltaX;    
}

-(float) getDeltaY:(int)vAlign withIndex:(int)index andPieceHeight:(float)pieceHeight{
    float qHeight = puzzleImage.contentSize.height/4;
    float deltaY = 0;
    switch (vAlign) {
        case kVAlignCENTER:
            deltaY = -(floor(index/6) * qHeight) + pieceHeight/2 - qHeight/2;
            break;
        case kVAlignTOP:
            deltaY = -(floor(index/6) * qHeight);
            break;
        case kVAlignBOTTOM:
            deltaY = -(floor(index/6) * qHeight) + pieceHeight - qHeight;
            break;
    }
    return deltaY;    
}

-(void) loadPieces {
    float posInitialX = puzzleImage.position.x;
    float posInitialY = puzzleImage.position.y;
    float deltaX = 0;
    float deltaY = 0;   
    int totalPieces = 24;
    int i = 0;
    float randX;
    float randY;
    float wlimit;
    float hlimit;
    NSDictionary* levelInfo = [GameHelper getPlist:@"levelEasy"];
    UIImage* tempPuzzle = [ImageHelper convertSpriteToImage:[CCSprite spriteWithTexture:[puzzleImage texture]]];
    for (int c = 1; c<=totalPieces; c++, i++) {        
        NSString *pName = [NSString stringWithFormat:@"p%d.png", c];
        Piece* item = [[Piece alloc] initWithName:pName andMetadata:[levelInfo objectForKey:pName]];  
        deltaX = [self getDeltaX:item.hAlign withIndex:i andPieceWidth:item.width];
        deltaY = [self getDeltaY:item.vAlign withIndex:i andPieceHeight:item.height];
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

-(void) onEnter
{
	[super onEnter];
    CCDirector * director_ = [CCDirector sharedDirector];
    screenSize = [director_ winSize];
    pieces = [[NSMutableArray alloc] initWithCapacity:24];
    zIndex = 400;
    [[director_ touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [self loadPlistLevel];
    [self initBackground];
    [self initMenu];
    [self loadPuzzleImage:[GameManager sharedGameManager].currentPuzzle];
    [self loadPieces];
}

-(void)dealloc {
    [self removeAllChildrenWithCleanup:TRUE];
    [super dealloc];
    
}

@end