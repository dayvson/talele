#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Piece.h"
@interface LevelBaseLayer : CCLayer {
    CGSize screenSize;
    NSMutableArray* pieces;
    Piece* selectedPiece;
    int zIndex;
    int totalPieceFixed;
    CCSprite* puzzleImage;
    CCSpriteFrameCache* sceneSpriteBatchNode;
    CCSpriteFrameCache* piecesSpriteBatchNode;
    CCSpriteFrameCache* bevelSpriteBatchNode;
}
-(void) enableTouch:(ccTime)dt;
-(BOOL) isPieceInRightPlace:(Piece*)piece;
-(BOOL) isPuzzleComplete;
-(Piece*) selectPieceForTouch:(CGPoint)touchLocation;
-(void) movePieceToFinalPosition:(Piece*)piece;
-(void) loadLevelSprites:(NSString*)dimension;
-(void) initMenu;
-(void) removeAllPieces;
-(void) loadPieces:(NSString*)level withCols:(int)cols andRols:(int)rows;
-(float) getDeltaX:(int)hAlign withIndex:(int)index andPieceWidth:(float)pieceWidth andCols:(int)cols andRows:(int)rows;
-(float) getDeltaY:(int)vAlign withIndex:(int)index andPieceHeight:(float)pieceHeight andCols:(int)cols andRows:(int)rows;
-(void) loadPuzzleImage:(NSString*)name;
-(void) resetScreen;
@end
