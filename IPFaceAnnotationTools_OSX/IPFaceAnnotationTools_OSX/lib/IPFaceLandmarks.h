//
//  IPFaceLandmarks.h
//  IPFaceAnnotationTools_OSX
//
//  Created by Mostafizur Rahman on 6/7/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface IPFaceLandmarks : NSObject



@end
@interface Landmarks : NSObject
/*!
 co-ordinate value of the landmark point in X-axis
 */
@property (readwrite) float xCoodinate;

/*!
 co-ordinate value of the landmark point in Y-axis
 */
@property (readwrite) float yCoodinate;

/*!
 Specific index of the landmark.
 */
@property (readwrite) NSInteger landmarkIndex;



@end

@interface IPFaceRectAttribute : NSObject
-(instancetype)init;
@property (readwrite) NSString *attributeRotation;
@property (readwrite) NSString *imageTagString;
@property (readwrite) NSString *minBoxString;
@property (readwrite) NSString *maxBoxString;
@property (readwrite) NSString *fileName;
-(void)setMinBox:(NSRect)mbox;
-(void)setMaxBox:(NSRect)mbox;
-(void)setTagString:(NSString *)fileName;

@end
