//
//  ViewController.h
//  IPFaceAnnotationTools_OSX
//
//  Created by Mostafizur Rahman on 6/7/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "IPDrawingView.h"
#import <Foundation/Foundation.h>

@interface IPLandmarkViewController : NSViewController<OnLandamarkClicked>
@property (weak) IBOutlet NSTextField *pixelTextField;


@property (weak) IBOutlet IPDrawingView *detailsImageView;

@property (weak) IBOutlet NSTextField *clickPointLabel;

@property (weak) IBOutlet NSTextField *rootDirectoryTextfield;
@property (weak) IBOutlet NSButton *lockCenterCheckbox;

@end

