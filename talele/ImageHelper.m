/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "ImageHelper.h"

@implementation ImageHelper

+(UIImage *) convertSpriteToImage:(CCSprite *)sprite {
    CGPoint p = sprite.anchorPoint;
    [sprite setAnchorPoint:ccp(0,0)];
    CCRenderTexture *renderer = [CCRenderTexture 
                                 renderTextureWithWidth:sprite.contentSize.width height:sprite.contentSize.height];
    
    [renderer begin];
    [sprite visit];
    [renderer end];
    [sprite setAnchorPoint:p];
    return [renderer getUIImage];
}


+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage withOffset:(CGPoint)offset
{
    CGContextRef mainViewContentContext;
    CGColorSpaceRef colorSpace;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a bitmap graphics context the size of the image
    mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    
    // free the rgb colorspace
    CGColorSpaceRelease(colorSpace);
    
    if (mainViewContentContext==NULL)return NULL;
    
    CGImageRef maskImageRef = maskImage.CGImage;
    CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, maskImage.size.width, maskImage.size.height), maskImageRef);
    CGContextDrawImage(mainViewContentContext, CGRectMake(-offset.x, -offset.y, image.size.width, image.size.height), image.CGImage);
    
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    // convert the finished resized image to a UIImage
    UIImage *theImage = [UIImage imageWithCGImage:mainViewContentBitmapContext];
    // image is retained by the property setting above, so we can
    // release the original
    CGImageRelease(mainViewContentBitmapContext);
    
    // return the image
    return theImage;
}
@end
