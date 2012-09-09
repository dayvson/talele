/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "PuzzleGrid.h"

@implementation PuzzleGrid

@synthesize padding;
@synthesize menuPosition;
@synthesize touchStarted;
@synthesize touchStop;
@synthesize isMoving;
@synthesize swipeInMenu;
@synthesize	moveDelta;
@synthesize distanceToNextPage;
@synthesize totalPages;
@synthesize currentPage;
@synthesize animationSpeed;

-(id) initWithArray:(NSMutableArray*)items position:(CGPoint)pos padding:(CGPoint)pad
{
	if ((self = [super init])){
		self.isTouchEnabled = YES;
		int z = 1;
		for (id item in items){
			[self addChild:item z:z tag:z];
			++z;
		}
		isMoving = false;
		swipeInMenu = false;
		menuPosition = pos;
		distanceToNextPage = 10;
		animationSpeed = 1;
		padding = pad;
		currentPage = 0;
        director = [CCDirector sharedDirector];
        screenSize = [director winSize];
		[self adjustItems];
	}
	return self;
}

-(void) adjustItems
{
    int c = 0;
    totalPages = self.children.count;
    for (CCMenuItem* item in self.children){
		item.position = CGPointMake((c * screenSize.width), 0);
        c++;
	}
    self.position = menuPosition;
}

-(void) addChild:(CCMenuItem*)child z:(int)z tag:(int)aTag
{
	return [super addChild:child z:z tag:aTag];
}

-(CCMenuItem*) getItemInTouch:(UITouch*)touch
{
	CGPoint touchLocation = [director convertToGL: [touch locationInView: [touch view]]];	
	for (CCMenuItem* item in self.children){
		CGPoint local = [item convertToNodeSpace:touchLocation];
		CGRect area = [item rect];
        area.origin = CGPointZero;
		if (CGRectContainsPoint(area, local)){
			return item;
		}
	}
	return nil;
}

-(void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (CGPoint) getCurrentPagePosition
{
	return CGPointMake(menuPosition.x - (currentPage * screenSize.width),
                       menuPosition.y);
}

- (CGPoint) getCurrentPagePositionWithOffset:(float)offset
{
	return CGPointMake(menuPosition.x-(currentPage * screenSize.width)+offset, menuPosition.y);
}

-(void) onAnimationComplete{
    [delegate onMoveToCurrentPage:[self getCurrentPageData]];
}
- (void) moveToCurrentPage{
	id action = [CCMoveTo actionWithDuration:(animationSpeed*0.5) position:[self getCurrentPagePosition]];
	[self runAction:[CCSequence actions:action,
                    [CCCallFunc actionWithTarget:self selector:@selector(onAnimationComplete)],
                     nil]];
     
;
}

-(void) gotoNextPage{
    if ((currentPage+1) < totalPages){
        currentPage +=1;
    }
    [self moveToCurrentPage];
}

-(void) gotoPrevPage{
    if (currentPage > 0){
        currentPage -=1;
    }
    [self moveToCurrentPage];
}

-(void) gotoPage:(int)pageId{
    currentPage = pageId;
    [self moveToCurrentPage];
}

-(NSObject*) getCurrentPageData{
    CCMenuItem* itemPage = [self.children objectAtIndex:currentPage];
    return itemPage.userData;
}

- (void)setDelegate:(id)aDelegate {
    delegate = aDelegate;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	touchStarted = [director convertToGL:[touch locationInView:[touch view]]];
	if (state != kCCMenuStateWaiting){
		return NO;
	}
	selectedItem = [self getItemInTouch:touch];
	[selectedItem selected];
	if (!swipeInMenu || (swipeInMenu && selectedItem)){
		state = kCCMenuStateTrackingTouch;
		return YES;
	}
	return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
	if(isMoving){
		isMoving = false;
		if( totalPages > 1 && (distanceToNextPage < abs(moveDelta))){
			bool isForward = (moveDelta < 0) ? true : false;
			if(isForward && (currentPage+1) < totalPages){
				currentPage++;
			}else if(!isForward && (currentPage > 0)){
				currentPage--;
			}
		}
		[self moveToCurrentPage];			
	}else{
		[selectedItem unselected];
		[selectedItem activate];
	}
	state = kCCMenuStateWaiting;
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	[selectedItem unselected];
	state = kCCMenuStateWaiting;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	touchStop = [director convertToGL:[touch locationInView:[touch view]]];
	moveDelta = touchStop.x - touchStarted.x;
	[self setPosition:[self getCurrentPagePositionWithOffset:moveDelta]];
	isMoving = true;
}

-(void) dealloc
{
	[super dealloc];
}

@end