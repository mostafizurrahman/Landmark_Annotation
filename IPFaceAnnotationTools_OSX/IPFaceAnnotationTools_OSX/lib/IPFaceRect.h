//
//  IPFaceRect.h
//  IPFaceAnnotationTools_OSX
//
//  Created by Mostafizur Rahman on 6/7/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPFaceRect : NSObject
@property (readwrite) int imageWidth;
@property (readwrite) int imageHeight;
@property (readwrite) int faceRect_OriginX;
@property (readwrite) int faceRect_OriginY;
@property (readwrite) int faceRect_Width;
@property (readwrite) int faceRect_Height;
@property (readwrite) NSMutableArray *landmarkArray;
@end
