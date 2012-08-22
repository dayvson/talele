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

-(NSDictionary *) getPieceMetadata:(NSString*)key{
    NSString *className = @"levelEasy";
    NSString *fullFileName = 
    [NSString stringWithFormat:@"%@.plist",className];
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:className ofType:@"plist"];
    }
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSDictionary *result = [plistDictionary objectForKey:key];
    return result;
}

-(Piece*) initWithName:(NSString*)pName{
    if(self = [super init]){
        NSDictionary *pieceMetadata = [self getPieceMetadata:pName];
        order= [[pieceMetadata objectForKey:@"order"] intValue];
        vAlign= [[pieceMetadata objectForKey:@"vAlign"] intValue]; 
        hAlign= [[pieceMetadata objectForKey:@"hAlign"] intValue];
        name = pName;
        fixed = NO;
        CCSprite* pieceSprite = [[CCSprite alloc] 
                                 initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:pName]];

        newPiece = [ImageHelper convertSpriteToImage:pieceSprite];
        width = newPiece.size.width;
        height = newPiece.size.height;
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

-(Piece*) initWithName:(NSString*)pName andImage:(UIImage*)image{
    if (self = [super initWithCGImage:image.CGImage key:pName]) {
        NSDictionary *pieceMetadata = [self getPieceMetadata:pName];
        order= [[pieceMetadata objectForKey:@"order"] intValue];
        vAlign= [[pieceMetadata objectForKey:@"vAlign"] intValue]; 
        hAlign= [[pieceMetadata objectForKey:@"hAlign"] intValue]; 
    }
    return self;
}
@end
