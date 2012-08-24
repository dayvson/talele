/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "Piece.h"
#import "ImageHelper.h"

@implementation Piece

@synthesize vAlign;
@synthesize hAlign;
@synthesize order;
@synthesize xTarget;
@synthesize yTarget;
@synthesize width;
@synthesize height;
@synthesize fixed;
@synthesize name;

-(CGRect)getRealBoundingBox{
    CGPoint contentPosition = [self position];
    CGRect result = CGRectMake(contentPosition.x, contentPosition.y-height, width, height); 
    return result;
}

-(Piece*) initWithName:(NSString*)pName andMetadata:(NSDictionary*)metadata{
    if(self = [super init]){
        CCSprite* pieceSprite = [[CCSprite alloc] 
                                 initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:pName]];
        newPiece = [ImageHelper convertSpriteToImage:pieceSprite];
        order= [[metadata objectForKey:@"order"] intValue];
        vAlign= [[metadata objectForKey:@"vAlign"] intValue]; 
        hAlign= [[metadata objectForKey:@"hAlign"] intValue];
        width = newPiece.size.width;
        height = newPiece.size.height;
        name = pName;
        fixed = NO;
        [self addChild:pieceSprite z:1 tag:10];
    }
    return self;
}
-(void) createMaskWithPuzzle:(UIImage*)mainPuzzle andOffset:(CGPoint)offset{
    UIImage* newImageMask = [ImageHelper maskImage:mainPuzzle 
                                            withMask:newPiece 
                                            withOffset:offset];
    CCSprite *pieceFinal = [[CCSprite alloc] initWithCGImage:newImageMask.CGImage 
                                                         key:[NSString stringWithFormat:@"MASK%@", name]];
    pieceFinal.anchorPoint = ccp(0,1);
    [self removeChildByTag:10 cleanup:YES];
    [self addChild:pieceFinal z:1 tag:10];
}

-(void) dealloc{
    [newPiece release];
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}
@end
