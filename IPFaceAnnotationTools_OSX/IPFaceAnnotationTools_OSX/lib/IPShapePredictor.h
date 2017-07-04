//
//  IPShapePredictor.h
//  IPFaceAnnotationTools_OSX
//
//  Created by Mostafizur Rahman on 6/7/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "IPFaceRect.h"

@interface IPShapePredictor : NSObject
-(instancetype)init;

-(NSMutableArray *)predictShape:(NSImage *)sourceImage withFaceRect:(IPFaceRect *)faceRect isCV_detection:(BOOL)is_cv_detection;

-(void)freePreviousImage;

@end
