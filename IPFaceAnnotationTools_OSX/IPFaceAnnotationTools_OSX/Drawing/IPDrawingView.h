//
//  IPDrawingView.h
//  IPFaceAnnotationTools_OSX
//
//  Created by Mostafizur Rahman on 6/10/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
@protocol OnLandamarkClicked <NSObject>

-(void)landmarkClickedAtPoint:(NSPoint)clickedPoint;

@end

@interface IPDrawingView : IKImageView
@property (readwrite, weak) id<OnLandamarkClicked> clickedDelegate;
@end
