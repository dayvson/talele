/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "ImageHelper.h"
#import "GameHelper.h"
@implementation ImageHelper

+(UIImage *) convertSpriteToImage:(CCSprite *)sprite {
    CGPoint p = sprite.anchorPoint;
    [sprite setAnchorPoint:ccp(0,0)];
    CCRenderTexture *renderer = [[CCRenderTexture alloc] initWithWidth:sprite.contentSize.width 
                                                                height:sprite.contentSize.height 
                                                           pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    [renderer begin];
    [sprite visit];
    [renderer end];
    [sprite setAnchorPoint:p];
    return [renderer getUIImage];
}

+(BOOL)removeImageFromPage:(NSString*)itemPath{
    int index = -1;
    NSError *error;
    NSMutableDictionary* dict = [GameHelper getPlist:@"puzzles"];
    NSMutableArray *arrayNames = [[NSMutableArray alloc]
                                  initWithArray:[dict objectForKey:@"puzzles"]];
    for(int i =0; i<arrayNames.count; i++){
        if([[arrayNames objectAtIndex:i] isEqualToString:itemPath]){
            index = i;
        }
    }
    if(index == -1)return NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistpath = [documentsDirectory stringByAppendingPathComponent:@"puzzles.plist"];
    NSString *imagePath = [arrayNames objectAtIndex:index];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:imagePath error:&error];
    [arrayNames removeObjectAtIndex:index];
    [dict setValue:arrayNames forKey:@"puzzles"];    
    [dict writeToFile:plistpath atomically:YES];
    return YES;
}

+(NSString*)saveImageFromLibraryIntoPuzzlePlist:(UIImage*)image{
    NSMutableDictionary* dict = [GameHelper getPlist:@"puzzles"];
    NSMutableArray *arrayNames = [[NSMutableArray alloc]
                                  initWithArray:[dict objectForKey:@"puzzles"]];
    NSString* newPuzzleName = [NSString stringWithFormat:@"newPuzzle_%@", [GameHelper generateUUID]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:newPuzzleName];
    NSData *webData = UIImageJPEGRepresentation(image, 0.8);
    [webData writeToFile:imagePath atomically:YES];
    NSString *plistpath = [documentsDirectory stringByAppendingPathComponent:@"puzzles.plist"];    
    [arrayNames addObject:newPuzzleName];
    [dict setValue:arrayNames forKey:@"puzzles"];
    [dict writeToFile:plistpath atomically:YES];
    return imagePath;

}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*) cropImage:(UIImage*)image toSize:(CGSize)crop
{
    CGSize imgSize = [image size];
    float nWidth, nHeight;
    if(imgSize.width/crop.width < imgSize.height/crop.height){
        nHeight= imgSize.height/imgSize.width*crop.width;
        nWidth= crop.width;
    }else if(imgSize.width/crop.width > imgSize.height/crop.height){
        nWidth = imgSize.width/imgSize.height*crop.height;
        nHeight = crop.height;
    }
    UIImage *img = [ImageHelper imageWithImage:image scaledToSize:CGSizeMake(nWidth, nHeight)];
    CGRect newRect = CGRectMake((nWidth/2)-(crop.width/2), (nHeight/2)-(crop.height/2), crop.width, crop.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage], newRect);
    img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
}

+(UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage withOffset:(CGPoint)offset
{
    CGContextRef mainViewContentContext;
    CGColorSpaceRef colorSpace;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    if (mainViewContentContext==NULL)return NULL;
    CGImageRef maskImageRef = maskImage.CGImage;
    CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, maskImage.size.width, maskImage.size.height), maskImageRef);
    CGContextDrawImage(mainViewContentContext, CGRectMake(-offset.x, -offset.y, image.size.width, image.size.height), image.CGImage);
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    UIImage *theImage = [UIImage imageWithCGImage:mainViewContentBitmapContext scale:maskImage.scale orientation:maskImage.imageOrientation];
    CGImageRelease(mainViewContentBitmapContext);
    return theImage;
}
@end
