/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */
#import "cocos2d.h"

@interface PuzzleGrid : CCLayer
{
    int currentPage;
	int totalPages;
    bool isMoving;
	bool swipeInMenu;
	float moveDelta;
	float distanceToNextPage;
	float animationSpeed; // 0.0 to 1.0 slow/fast animation page.
    CGPoint touchStarted;
	CGPoint touchStop;
	CGPoint padding;
	CGPoint menuPosition;
    CGSize screenSize;
    CCDirector* director;
	CCMenuItem *selectedItem;
    tCCMenuState state;
    id delegate;

}
@property (nonatomic, readwrite) int currentPage;
@property (nonatomic, readwrite) int totalPages;
@property (nonatomic, readwrite) bool isMoving;
@property (nonatomic, readwrite) bool swipeInMenu;
@property (nonatomic, readwrite) float moveDelta;
@property (nonatomic, readwrite) float distanceToNextPage;
@property (nonatomic, readwrite) CGPoint touchStarted;
@property (nonatomic, readwrite) CGPoint touchStop;
@property (nonatomic, readwrite) CGPoint padding;
@property (nonatomic, readwrite) CGPoint menuPosition;
@property (nonatomic, readwrite) float animationSpeed;

-(id) initWithArray:(NSMutableArray*)items position:(CGPoint)pos padding:(CGPoint)pad;
-(void) adjustItems;
-(void) gotoNextPage;
-(void) gotoPrevPage;
-(void) gotoPage:(int)pageId;
-(NSObject*) getCurrentPageData;
-(CGPoint) getCurrentPagePosition;
-(CGPoint) getCurrentPagePositionWithOffset:(float)offset;
-(CCMenuItem*) getItemInTouch:(UITouch*)touch;
- (void)setDelegate:(id)delegate;
@end

@interface NSObject(PuzzleGridDelegateMethods)
- (void)onMoveToCurrentPage:(NSObject *)puzzleData;
@end
