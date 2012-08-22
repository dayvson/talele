#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Piece.h"
@interface LevelBaseLayer : CCLayer {
    CGSize screenSize;
    NSMutableArray* pieces;
    Piece* selectedPiece;
    int zIndex;
    CCSprite* puzzleImage;
    CCSpriteFrameCache* sceneSpriteBatchNode;
    CCSpriteFrameCache* piecesSpriteBatchNode;

}
-(void) movePieceToFinalPosition:(Piece*)piece;
-(BOOL) isPieceInRightPlace:(Piece*)piece;
-(BOOL) isPuzzleComplete;
-(void) loadPlistLevel;
-(void) initMenu;
@end
