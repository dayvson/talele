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

}
-(BOOL) isPieceInRightPlace:(Piece*)piece;
-(BOOL) isPuzzleComplete;
-(void) selectPieceForTouch:(CGPoint)touchLocation;
-(void) movePieceToFinalPosition:(Piece*)piece;
-(void) loadPlistLevel:(NSString*)plistName andSpriteName:(NSString*)spriteName;
-(void) initMenu;
-(void) removeAllPieces;
-(float) getDeltaX:(int)hAlign withIndex:(int)index andPieceWidth:(float)pieceWidth andCols:(int)cols andRows:(int)rows;
-(float) getDeltaY:(int)vAlign withIndex:(int)index andPieceHeight:(float)pieceHeight andCols:(int)cols andRows:(int)rows;
-(void) loadPuzzleImage:(NSString*)name;
@end
