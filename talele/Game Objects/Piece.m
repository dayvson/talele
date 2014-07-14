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
        CCSprite* pieceSprite = [CCSprite spriteWithSpriteFrameName:pName];
        newPiece = [ImageHelper convertSpriteToImage:pieceSprite];
        order= [[metadata objectForKey:@"order"] intValue];
        vAlign= [[metadata objectForKey:@"vAlign"] intValue]; 
        hAlign= [[metadata objectForKey:@"hAlign"] intValue];
        width = newPiece.size.width;
        height = newPiece.size.height;
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
                                                         key:[NSString stringWithFormat:@"SPRITE_MASK_%@", name]];
    pieceFinal.anchorPoint = ccp(0,1);
    [pieceFinal setScale:mainPuzzle.scale];
    [self removeChildByTag:10 cleanup:YES];
    [self addChild:pieceFinal z:1 tag:10];
    [pieceFinal release];
}

-(void) addBevel:(NSString*)pName{
    CCSprite* bevelSprite = [CCSprite spriteWithSpriteFrameName:pName];
    bevelSprite.anchorPoint = ccp(0,1);
    [self addChild:bevelSprite z:2 tag:20];
}

-(void) dealloc{
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
    [super dealloc];
}
@end
