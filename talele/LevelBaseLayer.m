#import "LevelBaseLayer.h"
#import "GameManager.h"
#import "GameHelper.h"
#import "ImageHelper.h"
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
    id ease = [CCEaseIn actionWithAction:action rate:0.7f];
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


-(void) loadLevelSprites:(NSString*)dimension{
    NSString *plistPuzzle = [NSString stringWithFormat:@"pieces_%@.plist", dimension];
    NSString *plistBevel = [NSString stringWithFormat:@"pieces_%@_bevel.plist", dimension];
    NSString *spritePuzzle = [NSString stringWithFormat:@"pieces_%@.png", dimension];
    NSString *spriteBevel = [NSString stringWithFormat:@"pieces_%@_bevel.png", dimension];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistPuzzle];
    piecesSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:spritePuzzle];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistBevel];
    bevelSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:spriteBevel];
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

-(void) resetScreen {
    [self removeAllPieces];
    [self removeAllChildrenWithCleanup:TRUE];
    if(pieces){
        [pieces release];
    }
}

-(void) initMenu {
    CCMenuItemSprite *backButton =[GameHelper createMenuItemBySprite:@"btn-voltar-mini.png" target:self selector:@selector(onClickBack)];
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
    [self performSelector:@selector(removeAllPieces) withObject:nil afterDelay:1];
    id action = [CCFadeIn actionWithDuration:1];
    [[self getChildByTag:100] runAction:action];
    CCSprite *congrats = [[CCSprite alloc] initWithFile:@"congrats.png"];
    [congrats setScale:0.1f];
    [congrats setPosition:ccp(100, 50)];
    [congrats runAction:[CCSequence actions:
    [CCScaleTo actionWithDuration:0.5f scale:1.3f],
     [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    congrats.anchorPoint = ccp(0,0);
    CCMenuItemSprite *newGameButton = [GameHelper createMenuItemBySprite:@"btn-novo-jogo.png" target:self selector:@selector(onClickNewGame)];
    CCMenu *mainMenu = [CCMenu menuWithItems:newGameButton,nil];
    [[GameManager sharedGameManager] playSoundEffect:@"gamecomplete.wav"];
    [mainMenu setPosition:ccp(150, screenSize.height - 240.0f)];
    [self addChild:congrats z:5000 tag:4];
    [self addChild:mainMenu z:4 tag:5];
}

-(void) loadPieces:(NSString*)level withCols:(int)cols andRols:(int)rows {
    float posInitialX = puzzleImage.position.x;
    float posInitialY = puzzleImage.position.y;
    float deltaX = 0;
    float deltaY = 0;
    int totalPieces = cols*rows;
    int i = 0;
    float randX, randY, wlimit, hlimit;
    NSDictionary* levelInfo = [GameHelper getPlist:level];
    UIImage* tempPuzzle = [ImageHelper convertSpriteToImage:
                           [CCSprite spriteWithTexture:[puzzleImage texture]]];
    for (int c = 1; c<=totalPieces; c++, i++) {
        NSString *pName = [NSString stringWithFormat:@"p%d.png", c];
        NSString *sName = [NSString stringWithFormat:@"s%d.png", c];
        NSString *fullName = [NSString stringWithFormat:@"Piece:%@-Puzzle:%@-D:%d", pName,[GameManager sharedGameManager].currentPuzzle, totalPieces];
        Piece* item = [[Piece alloc] initWithName:pName andMetadata:[levelInfo objectForKey:pName]];
        [item setName: fullName];
        deltaX = [self getDeltaX:item.hAlign withIndex:i andPieceWidth:item.width andCols:cols andRows:rows];
        deltaY = [self getDeltaY:item.vAlign withIndex:i andPieceHeight:item.height andCols:cols andRows:rows];
        [item createMaskWithPuzzle:tempPuzzle
                         andOffset:ccp(deltaX, tempPuzzle.size.height + deltaY - item.height)];
        item.anchorPoint = ccp(0,1);
        [item setScale:0.8f];
        item.xTarget = posInitialX + deltaX;
        item.yTarget = posInitialY + tempPuzzle.size.height + deltaY;
        [item addBevel:sName];
        wlimit = screenSize.width-item.width-30;
        hlimit = screenSize.height-item.height-50;
        if (c % 2 == 0){
            randX = [GameHelper randomFloatBetween:item.width and:wlimit];
            randY = [GameHelper randomFloatBetween:item.height and: 150];
        }else{
            randX = [GameHelper randomFloatBetween:10 and:90];
            randY = [GameHelper randomFloatBetween:item.height and: hlimit];
        }
        [item setPosition:ccp(item.xTarget, item.yTarget)];
        [item runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(randX,randY)]];
        [self addChild:item z:100+c tag:100+c];
        [pieces addObject:item];
    }
}

- (Piece*) selectPieceForTouch:(CGPoint)touchLocation {
    for (int i = pieces.count; i--;) {
        Piece *piece = [pieces objectAtIndex:i];
        if (CGRectContainsPoint(piece.getRealBoundingBox, touchLocation) && piece.fixed == NO) {
            return piece;
        }
    }
    return nil;
    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    selectedPiece = [self selectPieceForTouch:touchLocation];
    if(selectedPiece == nil) return NO;
    [selectedPiece setScale:1.0f];
    [selectedPiece setZOrder:++zIndex];
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if (selectedPiece != nil && selectedPiece.fixed == NO) {
        selectedPiece.position = ccp(touchLocation.x - (selectedPiece.width/2), 
                                     touchLocation.y + (selectedPiece.height/2));
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(selectedPiece != nil && selectedPiece.fixed) return;
    if([self isPieceInRightPlace:selectedPiece]){
        [self movePieceToFinalPosition:selectedPiece];
        if(self.isPuzzleComplete){
            [self showPuzzleComplete];
        }
    }else{
        if(selectedPiece != nil && (selectedPiece.position.x < puzzleImage.position.x ||
                             selectedPiece.position.y < puzzleImage.position.y)){
            [selectedPiece setScale:0.8f];
        }
    }
}

@end