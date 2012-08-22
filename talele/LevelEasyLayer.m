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

@implementation LevelEasyLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	LevelEasyLayer *layer = [LevelEasyLayer node];
	[scene addChild: layer];
	return scene;
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

-(void) loadPlistLevel {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttons.plist"];
    sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"buttons.png"];    
    [self addChild:sceneSpriteBatchNode z:1];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"pieces.plist"];
    piecesSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"pieces.png"];    
    [self addChild:piecesSpriteBatchNode z:2];    
}

-(void) onClickBack {
    [[GameManager sharedGameManager] runSceneWithID:kPuzzleSelection];
    CCLOG(@"CLICKKKKKK BACK");
}

-(void) initMenu {
    [CCSpriteFrameCache sharedSpriteFrameCache ];
    CCSprite *backSprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:@"btn-voltar-mini.png"]];
    [backSprite.texture setAliasTexParameters];
    CCMenuItemSprite *backButton = [CCMenuItemSprite itemFromNormalSprite:backSprite
                                    selectedSprite:nil target:self selector:@selector(onClickBack)];
    CCMenu *mainMenu = [CCMenu menuWithItems:backButton,nil];

    [mainMenu setPosition:ccp(40, screenSize.height - 40.0f)];
    [self addChild:mainMenu];
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

- (void)selectPieceForTouch:(CGPoint)touchLocation {
    Piece * newSelection = nil;
    for (Piece *piece in pieces) {
        if (CGRectContainsPoint(piece.getRealBoundingBox, touchLocation)) {            
            newSelection = piece;
            break;
        }
    }    
    if (newSelection != selectedPiece) {
        selectedPiece = newSelection;
    }
}
-(void) movePieceToFinalPosition:(Piece*)piece{
    [selectedPiece setScale:1.0f];
    selectedPiece.fixed = YES;
    id action = [CCMoveTo actionWithDuration:0.5f 
                                    position:CGPointMake(selectedPiece.xTarget, 
                                                         selectedPiece.yTarget)];
    id ease = [CCEaseIn actionWithAction:action rate:2];
    [selectedPiece runAction:ease];
    
}

- (BOOL) isPieceInRightPlace:(Piece*)piece {
    BOOL result = NO;
    if(selectedPiece && selectedPiece.fixed == NO){
        int radius = 60;
        if(selectedPiece.position.x < selectedPiece.xTarget + radius &&
           selectedPiece.position.x > selectedPiece.xTarget - radius &&
           selectedPiece.position.y < selectedPiece.yTarget + radius &&
           selectedPiece.position.y > selectedPiece.yTarget - radius){
            result = YES;
        }
    }
    return result;
}

-(BOOL) isPuzzleComplete {
    for (Piece *piece in pieces) {
        if(piece.fixed == NO){
            return NO;
        }
    }
    return YES;
}

-(void) loadPieces {
    float posInitialX = puzzleImage.position.x;
    float posInitialY = puzzleImage.position.y;
    float deltaX = 0;
    float deltaY = 0;   
    int i = 0;
    int totalPieces = 24;
    float randX;
    float randY;
    float wlimit;
    float hlimit;

    UIImage* tempPuzzle = [ImageHelper convertSpriteToImage:[CCSprite spriteWithTexture:[puzzleImage texture]]];
    for (int c = 1; c<=totalPieces; c++,i++) {        
        NSString *pName = [NSString stringWithFormat:@"p%d.png", c];
        Piece* item = [[Piece alloc] initWithName:pName];  
        deltaX = [self getDeltaX:item.hAlign withIndex:i andPieceWidth:item.width];
        deltaY = [self getDeltaY:item.vAlign withIndex:i andPieceHeight:item.height];
        [item createMaskWithPuzzle:tempPuzzle 
                          andOffset:ccp(deltaX, tempPuzzle.size.height + deltaY - item.height)];
        item.anchorPoint = ccp(0,1);
        item.xTarget = posInitialX + deltaX;
        item.yTarget = posInitialY + tempPuzzle.size.height + deltaY;
        [item setScale:0.8f];
        wlimit = screenSize.width-item.width-30;
        hlimit = screenSize.height-item.height-30;        
        if (c % 2 == 0){
            randX = [self randomFloatBetween:item.width and:wlimit];
            randY = [self randomFloatBetween:item.height and: 150];
        }else{
            randX = [self randomFloatBetween:10 and:90];
            randY = [self randomFloatBetween:item.height and: hlimit];
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

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectPieceForTouch:touchLocation];
    if( selectedPiece && selectedPiece.fixed == NO){
        [selectedPiece setScale:1.0f];
        zIndex += 1;
        [selectedPiece setZOrder:zIndex];
    }
    return TRUE;
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {       
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if (selectedPiece && selectedPiece.fixed == NO) {
        selectedPiece.position = ccp(touchLocation.x - (selectedPiece.width/2), 
                                     touchLocation.y + (selectedPiece.height/2));
    }
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if([self isPieceInRightPlace:selectedPiece]){
        [self movePieceToFinalPosition:selectedPiece];
        if(self.isPuzzleComplete){
            CCLOG(@" ########################### PUZZLE COMPLETE ########################### ");
        }
    }
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
    [self loadPuzzleImage:@"arthur.jpg"];
    [self loadPieces];
}


-(void)dealloc {
    [self removeAllChildrenWithCleanup:TRUE];
    [super dealloc];
    
}

@end
