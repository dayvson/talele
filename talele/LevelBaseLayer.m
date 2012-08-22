#import "LevelBaseLayer.h"
#import "GameManager.h"

@implementation LevelBaseLayer

-(void) movePieceToFinalPosition:(Piece*)piece{
    piece.fixed = YES;
    [piece setScale:1.0f];
    id action = [CCMoveTo actionWithDuration:0.5f 
                                    position:CGPointMake(piece.xTarget, 
                                                         piece.yTarget)];
    id ease = [CCEaseIn actionWithAction:action rate:2];
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
    puzzleImage = [CCSprite spriteWithFile:name];
    puzzleImage.anchorPoint = ccp(0,0);
    [puzzleImage setOpacity:30];
	puzzleImage.position = ccp(screenSize.width - puzzleImage.contentSize.width - 28,
                               screenSize.height - puzzleImage.contentSize.height - 20);
	[self addChild: puzzleImage];
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

-(void) loadPlistLevel {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttons.plist"];
    sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"buttons.png"];    
    [self addChild:sceneSpriteBatchNode z:1];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"pieces.plist"];
    piecesSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"pieces.png"];    
    [self addChild:piecesSpriteBatchNode z:2];    
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

-(void) onClickNewGame {
    [[GameManager sharedGameManager] runSceneWithID:kPuzzleSelection];
}
-(void) showPuzzleComplete{
    for (Piece *piece in pieces) {
        [self removeChild:piece cleanup:YES];
    }
    [puzzleImage setOpacity:100];
    [CCSpriteFrameCache sharedSpriteFrameCache ];
    CCSprite *congrats = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:@"congrats.png"]];
    
    [congrats setPosition:ccp(100, 50)];
    congrats.anchorPoint = ccp(0,0);
    CCSprite *newGame = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:@"btn-newgame.png"]];
    [newGame.texture setAliasTexParameters];
    CCMenuItemSprite *newGameButton = [CCMenuItemSprite itemFromNormalSprite:newGame
                                                           selectedSprite:nil target:self selector:@selector(onClickNewGame)];
    CCMenu *mainMenu = [CCMenu menuWithItems:newGameButton,nil];
    
    [mainMenu setPosition:ccp(congrats.contentSize.width + 20, screenSize.height - 240.0f)];
    [self addChild:congrats];
    [self addChild:mainMenu];
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
            [self showPuzzleComplete];
        }
    }
}

@end