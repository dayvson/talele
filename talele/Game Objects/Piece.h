/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Piece : CCNode {
    int vAlign;
    int hAlign;
    int order;
    float xTarget;
    float yTarget;
    float width;
    float height;
    BOOL fixed;
    NSString * name;
    UIImage* newPiece;
}
@property (readwrite) int vAlign;
@property (readwrite) int hAlign;
@property (readwrite) int order;
@property (readwrite) float xTarget;
@property (readwrite) float yTarget;
@property (readwrite) float width;
@property (readwrite) float height;
@property (readwrite) BOOL fixed;
@property (readwrite, retain) NSString* name;

-(CGRect)getRealBoundingBox;
-(void) addBevel:(NSString*)pName;
-(void) createMaskWithPuzzle:(UIImage*)mainPuzzle andOffset:(CGPoint)offset;
-(Piece*) initWithName:(NSString*)pName andMetadata:(NSDictionary*)metadata;
@end
