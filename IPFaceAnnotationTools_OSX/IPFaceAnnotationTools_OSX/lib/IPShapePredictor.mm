//
//  IPShapePredictor.m
//  IPFaceAnnotationTools_OSX
//
//  Created by Mostafizur Rahman on 6/7/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "IPShapePredictor.h"
#import "IPFaceLandmarks.h"
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFData.h>
#include "dlib/image_processing.h"
#import "IPStaticDrawing.h"

@interface IPShapePredictor(){
    dlib::shape_predictor shapePredictor;
    BOOL isDeserialized;
    unsigned char *imageBuffer;
    long numOfPixels;
    NSMutableArray* currentShape;
}

@end

@implementation IPShapePredictor


-(instancetype)init{
    self = [super init];
    
    
    currentShape = [[NSMutableArray alloc] init];
    for (int i = 0; i < 92; ++i) {
        Landmarks* landmark = [[Landmarks alloc] init];
        landmark.landmarkIndex = i;
        [currentShape addObject:landmark];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self desirialize];
    });
    return self;
}

-(void)desirialize{
    NSString *modelFileName = [[NSBundle mainBundle] pathForResource:@"FDFaceMasking" ofType:@"dat"];
    std::string modelFileNameCString = [modelFileName UTF8String];
    
    dlib::deserialize(modelFileNameCString) >> shapePredictor;
    
    isDeserialized = YES;
}


-(NSMutableArray *)predictShape:(NSImage *)sourceImage withFaceRect:(IPFaceRect *)faceRect{
    
    if(imageBuffer == NULL){
        
        [self allocateSourceImage:sourceImage];
    }
    const dlib::rectangle oneFaceRect( faceRect.faceRect_OriginX,
                                      faceRect.faceRect_OriginY,
                                      faceRect.faceRect_Width + faceRect.faceRect_OriginX ,
                                      faceRect.faceRect_OriginY + faceRect.faceRect_Height);
    // predict shape
    const dlib::full_object_detection shape = shapePredictor.predictShape(imageBuffer, faceRect.imageWidth, faceRect.imageHeight, oneFaceRect);
    
    // update current shape
    for(int i = 0; i< shape.num_parts(); i++) {
        const dlib::point p = shape.part(i);
        Landmarks* landmark = [currentShape objectAtIndex:i];
        // vertices X axis is from right to left but dlib returns point with X axis from left to right. So mirrored x coordinate
        landmark.xCoodinate = faceRect.imageWidth - p.x();
        landmark.yCoodinate = p.y();
    }
    return currentShape;
}

-(void)allocateSourceImage:(NSImage *)sourceImage {
    NSBitmapImageRep* imageRep = [IPStaticDrawing bitmapImageRepresentation:sourceImage];
    
    const long width = [imageRep pixelsWide];
    const long height = [imageRep pixelsHigh];
    if(imageBuffer!= NULL) delete [] imageBuffer;
    imageBuffer = NULL;
    imageBuffer = new unsigned char[height * width];
    const long rowBytes = [imageRep bytesPerRow];
    const unsigned char* pixels = (unsigned char*)[imageRep bitmapData];
    int row, col;
    int index = 0;
    for (row = 0; row < height; row++) {
        
        unsigned char* rowStart = (unsigned char*)(pixels + (row * rowBytes));
        unsigned char* nextChannel = rowStart;
        for (col = 0; col < width; col++) {
            
            unsigned char red, green, blue, alpha;
            
            red = *nextChannel;
            nextChannel++;
            green = *nextChannel;
            nextChannel++;
            blue = *nextChannel;
            nextChannel++;
            alpha = *nextChannel;
            nextChannel++;
            imageBuffer[index++] = (0.299* ((float)red/255.0) + 0.587 * ((float)green/255.0) + 0.114 * ((float)blue/255.0)) * 255.0;
        }
    }
}

-(void)freePreviousImage{
    if(imageBuffer!= NULL) delete [] imageBuffer;
    imageBuffer = NULL;
}

@end
