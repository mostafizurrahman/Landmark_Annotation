//
//  IPStaticDrawing.h
//  IPFaceAnnotationTools_OSX
//
//  Created by Mostafizur Rahman on 6/10/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "IPFaceRect.h"

@interface IPStaticDrawing : NSObject
+(NSImage *)drawImage:(NSImage *)image inputFaceProperties:(IPFaceRect *)frect cv_predction:(BOOL)shouldInclude;
+(NSImage *)getSaveImage:(NSImage *)image properties:(IPFaceRect *)frect;
+ (NSBitmapImageRep *)bitmapImageRepresentation:(NSImage *)src_image;
@end
