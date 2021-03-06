//
//  IPStaticDrawing.m
//  IPFaceAnnotationTools_OSX
//
//  Created by Mostafizur Rahman on 6/10/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "IPStaticDrawing.h"
#import "IPFaceLandmarks.h"

@implementation IPStaticDrawing
+(NSImage *)drawImage:(NSImage *)inputImage inputFaceProperties:(IPFaceRect *)faceRect  cv_predction:(BOOL)shouldInclude{
    
    
    CGRect imgRect = CGRectMake(0, 0, inputImage.size.width, inputImage.size.height);
    __block NSBitmapImageRep *offscreenRep = [[NSBitmapImageRep alloc]
                                              initWithBitmapDataPlanes:NULL
                                              pixelsWide:faceRect.imageWidth
                                              pixelsHigh:faceRect.imageHeight
                                              bitsPerSample:8
                                              samplesPerPixel:4
                                              hasAlpha:YES
                                              isPlanar:NO
                                              colorSpaceName:NSDeviceRGBColorSpace
                                              bitmapFormat:NSAlphaFirstBitmapFormat
                                              bytesPerRow:0
                                              bitsPerPixel:0];
    NSGraphicsContext *graphicsContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:offscreenRep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:graphicsContext];
    CGContextRef contextRef = [NSGraphicsContext.currentContext graphicsPort];
    CFRetain(contextRef);
    CGImageSourceRef source;
    CFDataRef cfdRef = (__bridge CFDataRef)[inputImage TIFFRepresentation];
    source = CGImageSourceCreateWithData(cfdRef, NULL);
    CGImageRef imgRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CGContextDrawImage(contextRef, imgRect, imgRef);
    CGImageRelease(imgRef);
    CFRelease(cfdRef);
    source = NULL;
    
    
    
    [graphicsContext saveGraphicsState];

    NSColor *dotColor = [NSColor greenColor];
    for(Landmarks *faceLandmarks in faceRect.landmarkArray){
        [self drawCircleAtX:faceLandmarks.xCoodinate Y:faceLandmarks.yCoodinate Radius:4 Color:dotColor Bitmap:offscreenRep];
    }
    
    NSColor *centerColor = [NSColor redColor];
    if(shouldInclude){
        dotColor = [NSColor magentaColor];
        for(Landmarks *faceLandmarks in faceRect.cv_fd_LandmarkArray){
            [self drawCircleAtX:faceLandmarks.xCoodinate Y:faceLandmarks.yCoodinate Radius:4 Color:dotColor Bitmap:offscreenRep];
        }
    }
    
    [self drawCircleAtX:faceRect.faceRect_CenterX Y:faceRect.faceRect_CenterY Radius:6 Color:centerColor Bitmap:offscreenRep];

    [self drawCircleAtX:faceRect.cv_faceRect_CenterX Y:faceRect.cv_faceRect_CenterY Radius:10 Color:centerColor Bitmap:offscreenRep];
    
    CGContextBeginPath(contextRef);
    float topBox = faceRect.imageHeight - faceRect.faceRect_OriginY;
    float bottomHeight = faceRect.imageHeight - faceRect.faceRect_Height - faceRect.faceRect_OriginY;
    
    
    
    [[NSColor  orangeColor] setStroke];
    CGContextMoveToPoint(contextRef, faceRect.faceRect_OriginX, topBox);
    CGContextAddLineToPoint(contextRef, faceRect.faceRect_OriginX + faceRect.faceRect_Width, topBox);
    CGContextAddLineToPoint(contextRef, faceRect.faceRect_OriginX + faceRect.faceRect_Width, bottomHeight );
    CGContextAddLineToPoint(contextRef, faceRect.faceRect_OriginX, bottomHeight);
    CGContextAddLineToPoint(contextRef, faceRect.faceRect_OriginX, topBox);
    
    CGContextClosePath(contextRef);
    CGContextStrokePath(contextRef);
    
    
    [[NSColor blueColor] setStroke];
    topBox = faceRect.imageHeight - faceRect.cv_faceRect_OriginY;
    bottomHeight = faceRect.imageHeight - faceRect.cv_faceRect_Height - faceRect.cv_faceRect_OriginY;
    CGContextMoveToPoint(contextRef, faceRect.cv_faceRect_OriginX, topBox);
    
    CGContextAddLineToPoint(contextRef, faceRect.cv_faceRect_OriginX + faceRect.cv_faceRect_Width, topBox);
    CGContextAddLineToPoint(contextRef, faceRect.cv_faceRect_OriginX + faceRect.cv_faceRect_Width, bottomHeight );
    CGContextAddLineToPoint(contextRef, faceRect.cv_faceRect_OriginX, bottomHeight);
    CGContextAddLineToPoint(contextRef, faceRect.cv_faceRect_OriginX, topBox);
    
    CGContextClosePath(contextRef);
    CGContextStrokePath(contextRef);
    
    [NSGraphicsContext restoreGraphicsState];
    CFRelease(contextRef);
    NSImage *outputImage = [[NSImage alloc] initWithSize:inputImage.size] ;
    [outputImage addRepresentation:offscreenRep];
    offscreenRep = nil;
    
    return outputImage;
}

+(void)drawCircleAtX:(int)_x Y:(int)_y Radius:(int)_r Color:(NSColor*)_c Bitmap:(NSBitmapImageRep*)_b {
    for (int _i = 0; _i < _r; ++_i) {
        for (int _j = 0; _j < _r; ++_j) {
            [_b setColor:_c atX:_x + _i y:_y + _j];
            [_b setColor:_c atX:_x - _i y:_y + _j];
            [_b setColor:_c atX:_x + _i y:_y - _j];
            [_b setColor:_c atX:_x - _i y:_y - _j];
        }
    }
}

+(NSImage *)getSaveImage:(NSImage *)inputImage properties:(IPFaceRect *)faceRect {
    CGRect imgRect = CGRectMake(0, 0, inputImage.size.width, inputImage.size.height);
    NSSize imgSize = imgRect.size;
    __block NSBitmapImageRep *offscreenRep = [[NSBitmapImageRep alloc]
                                              initWithBitmapDataPlanes:NULL
                                              pixelsWide:faceRect.imageWidth
                                              pixelsHigh:faceRect.imageHeight
                                              bitsPerSample:8
                                              samplesPerPixel:4
                                              hasAlpha:YES
                                              isPlanar:NO
                                              colorSpaceName:NSDeviceRGBColorSpace
                                              bitmapFormat:NSAlphaFirstBitmapFormat
                                              bytesPerRow:0
                                              bitsPerPixel:0];
    NSGraphicsContext *graphicsContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:offscreenRep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:graphicsContext];
    CGContextRef contextRef = [NSGraphicsContext.currentContext graphicsPort];
    CFRetain(contextRef);
    CGImageSourceRef source;
    CFDataRef cfdRef = (__bridge CFDataRef)[inputImage TIFFRepresentation];
    source = CGImageSourceCreateWithData(cfdRef, NULL);
    CGImageRef imgRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CGContextDrawImage(contextRef, imgRect, imgRef);
    CGImageRelease(imgRef);
    CFRelease(cfdRef);
    source = NULL;
    CGFontRef font = CGFontCreateWithFontName((CFStringRef)@"Courier Bold");
    [[NSColor magentaColor] setStroke];
    CGContextSetFont(contextRef, font);
    
    [graphicsContext saveGraphicsState];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:25], NSFontAttributeName, [NSColor redColor], NSForegroundColorAttributeName, nil];
    NSAttributedString * currentText = [[NSAttributedString alloc] initWithString:
                                        [NSString stringWithFormat:@"origin( %d, %d) size( %d, %d)",faceRect.faceRect_OriginX, faceRect.faceRect_OriginY, faceRect.faceRect_Width, faceRect.faceRect_Height] attributes: attributes];
    [currentText drawAtPoint:NSMakePoint(20, 20)];
    
    [graphicsContext restoreGraphicsState];
    
    [NSGraphicsContext restoreGraphicsState];
    CFRelease(contextRef);
    NSImage *img = [[NSImage alloc] initWithSize:imgSize] ;
    [img addRepresentation:offscreenRep];
    offscreenRep = nil;
    return img;
}

+ (NSBitmapImageRep *)bitmapImageRepresentation:(NSImage *)src_image {
    int width = [src_image size].width;
    int height = [src_image size].height;
    
    if(width < 1 || height < 1)
        return nil;
    
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes: NULL
                             pixelsWide: width
                             pixelsHigh: height
                             bitsPerSample: 8
                             samplesPerPixel: 4
                             hasAlpha: YES
                             isPlanar: NO
                             colorSpaceName: NSDeviceRGBColorSpace
                             bytesPerRow: width * 4
                             bitsPerPixel: 32];
    
    NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: rep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext: ctx];
    [src_image drawAtPoint: NSZeroPoint fromRect: NSZeroRect operation: NSCompositingOperationCopy fraction: 1.0];
    [ctx flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    
    return rep;
}
@end

