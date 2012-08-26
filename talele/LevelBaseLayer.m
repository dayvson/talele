#import "LevelBaseLayer.h"
#import "GameManager.h"
#import "GameHelper.h"
@implementation LevelBaseLayer

-(void) playingPiecematch{
    [[GameManager sharedGameManager] playSoundEffect:@"plin.wav"];
}

-(void) movePieceToFinalPosition:(Piece*)piece{
    piece.fixed = YES;
    [piece setScale:1.0f];
    id action = [CCMoveTo actionWithDuration:0.5f 
                                    position:CGPointMake(piece.xTarget, 
                                                         piece.yTarget)];
    id ease = [CCEaseIn actionWithAction:action rate:1.0f];
    totalPieceFixed++;
    [self playingPiecematch];
    [piece runAction:ease];
    
}

- (BOOL) isPieceInRightPlace:(Piece*)piece {
    BOOL result = NO;
    if(piece && piece.fixed == NO){
        int radius = 60;
        if(piece.position.x < piece.xTarget + radius &&
           piece.position.x > piece.xTarget - radius &&
           piece.position.y < piece.yTarget + radius &&
           piece.position.y > piece.yTarget - radius){
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

-(void) loadPuzzleImage:(NSString*)name {
    puzzleImage = [[CCSprite alloc] initWithFile:name];
    puzzleImage.anchorPoint = ccp(0,0);
    puzzleImage.opacity = 40;
	puzzleImage.position = ccp(screenSize.width - puzzleImage.contentSize.width - 28,
                               screenSize.height - puzzleImage.contentSize.height - 20);
	[self addChild: puzzleImage z:1 tag:100];
    [puzzleImage release];
}

- (void) selectPieceForTouch:(CGPoint)touchLocation {
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

-(void) loadPlistLevel:(NSString*)plistName andSpriteName:(NSString*)spriteName {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistName];
    piecesSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:spriteName];    
    [self addChild:piecesSpriteBatchNode z:2];    
}

-(float) getDeltaX:(int)hAlign withIndex:(int)index andPieceWidth:(float)pieceWidth andCols:(int)cols andRows:(int)rows{
    float qWidth = puzzleImage.contentSize.width/cols;
    float deltaX = 0;
    switch (hAlign) {
        case kHAlignCENTER:
            deltaX = (ceil(index%cols) * qWidth) - pieceWidth/2 + qWidth/2;//center
            break;
        case kHAlignLEFT:
            deltaX = ceil(index%cols) * qWidth;
            break;
        case kHAlignRIGHT:
            deltaX = (ceil(index%cols) * qWidth) - pieceWidth + qWidth;
            break;
    }
    return deltaX;    
}

-(float) getDeltaY:(int)vAlign withIndex:(int)index andPieceHeight:(float)pieceHeight andCols:(int)cols andRows:(int)rows{
    float qHeight = puzzleImage.contentSize.height/rows;
    float deltaY = 0;
    switch (vAlign) {
        case kVAlignCENTER:
            deltaY = -(floor(index/cols) * qHeight) + pieceHeight/2 - qHeight/2;
            break;
        case kVAlignTOP:
            deltaY = -(floor(index/cols) * qHeight);
            break;
        case kVAlignBOTTOM:
            deltaY = -(floor(index/cols) * qHeight) + pieceHeight - qHeight;
            break;
    }
    return deltaY;    
}

-(void) initMenu {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttons.plist"];
    sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"buttons.png"];    
    [self addChild:sceneSpriteBatchNode z:1];
    [CCSpriteFrameCache sharedSpriteFrameCache ];
    CCSprite *backSprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:@"btn-voltar-mini.png"]];
    [backSprite.texture setAliasTexParameters];
    CCMenuItemSprite *backButton = [CCMenuItemSprite itemFromNormalSprite:backSprite
                                                           selectedSprite:nil target:self selector:@selector(onClickBack)];
    CCMenu *backMenu = [CCMenu menuWithItems:backButton,nil];
    
    [backMenu setPosition:ccp(40, screenSize.height - 40.0f)];
    [self addChild:backMenu z:7 tag:700];
}

-(void) onClickNewGame {
    [[GameManager sharedGameManager] runSceneWithID:kPuzzleSelection];
}

-(void) removeAllPieces{
    if(pieces){
        for (Piece *piece in pieces) {
            [self removeChild:piece cleanup:YES];
        }
        [pieces removeAllObjects];
    }
}

-(void) showPuzzleComplete{
    [self performSelector:@selector(removeAllPieces) withObject:nil afterDelay:2];
    [piecesSpriteBatchNode release];
    id action = [CCFadeIn actionWithDuration:1];
    [[self getChildByTag:100] runAction:action];
    [CCSpriteFrameCache sharedSpriteFrameCache ];
    CCSprite *congrats = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:@"congrats.png"]];
    
    [congrats setPosition:ccp(100, 50)];
    congrats.anchorPoint = ccp(0,0);
    CCSprite *newGame = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:@"btn-newgame.png"]];
    CCMenuItemSprite *newGameButton = [CCMenuItemSprite 
                                       itemFromNormalSprite:newGame
                                       selectedSprite:nil
                                       target:self 
                                       selector:@selector(onClickNewGame)];
    CCMenu *mainMenu = [CCMenu menuWithItems:newGameButton,nil];
    [[GameManager sharedGameManager] playSoundEffect:@"gamecomplete.wav"];
    [mainMenu setPosition:ccp(150, screenSize.height - 240.0f)];
    [self addChild:congrats z:40 tag:400];
    [self addChild:mainMenu z:50 tag:500];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectPieceForTouch:touchLocation];
    if( selectedPiece && selectedPiece.fixed == NO){
        [selectedPiece setScale:1.0f];
        zIndex += 1;
        [selectedPiece setZOrder:zIndex];
    }else{
        return NO;
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
    if(selectedPiece && selectedPiece.fixed) return;
    if([self isPieceInRightPlace:selectedPiece]){
        [self movePieceToFinalPosition:selectedPiece];
        if(self.isPuzzleComplete){
            [self showPuzzleComplete];
        }
    }
}

@end