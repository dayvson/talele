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
-(BOOL) isPieceInRightPlace:(Piece*)piece;
-(BOOL) isPuzzleComplete;
-(void) selectPieceForTouch:(CGPoint)touchLocation;
-(void) movePieceToFinalPosition:(Piece*)piece;
-(void) loadPlistLevel;
-(void) initMenu;
@end
