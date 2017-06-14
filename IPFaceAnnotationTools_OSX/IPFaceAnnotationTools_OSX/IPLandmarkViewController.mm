//
//  ViewController.m
//  IPFaceAnnotationTools_OSX
//
//  Created by Mostafizur Rahman on 6/7/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "IPLandmarkViewController.h"
#import "Formatter/IPNumberFormatter.h"
#import "IPFaceRect.h"
#import "IPShapePredictor.h"
#import "IPStaticDrawing.h"
#import "IPFaceLandmarks.h"
#include "lib/dlib/image_processing.h"



@interface IPLandmarkViewController (){
    IPShapePredictor *predictor;
    int faceRectArmLength;
    CGPoint centerPoint;
    BOOL shouldSelectCenterPoint;
    NSMutableArray *imagePathArray;
    NSMutableArray *imagePropertiesArray;
    int currentIndex;
    NSImage *sourceImage;
    IPFaceRect *faceRect;
    NSString *rootDirectory;
    NSString *imageFileName;
    int fileCount;
    NSImage *outputImage;
    NSURL *testXmlUrl;
    IPFaceRectAttribute *properties;
    
}

@end

@implementation IPLandmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        faceRectArmLength = 150;
    shouldSelectCenterPoint = YES;
    IPNumberFormatter *formatter = [[IPNumberFormatter alloc] init];
    [self.pixelTextField setFormatter:formatter];
    
    predictor = [[IPShapePredictor alloc] init];
    self.detailsImageView.clickedDelegate = self;
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}

- (IBAction)jumpFaceRectByTextFieldSizePixels:(id)sender {
    if([imagePathArray count] <= 0) return;
    const int difference = [[self.pixelTextField stringValue] intValue];
    faceRectArmLength += difference;
    [self allocFaceRect];
    [self drawPredictedFace];
    

}

-(void)landmarkClickedAtPoint:(NSPoint)clickedPoint{
    if([imagePathArray count] <= 0) return;
    if([self.lockCenterCheckbox state] == 0){
        
        
        centerPoint = NSMakePoint(clickedPoint.x, faceRect.imageHeight - clickedPoint.y) ;
        self.clickPointLabel.stringValue = [NSString stringWithFormat:@"clicked at point %@", NSStringFromPoint(centerPoint)];
        [self allocFaceRect];
        [self drawPredictedFace];
    }
    
}




- (IBAction)setMaxFaceRect:(id)sender {

    [properties setMaxBox:[self getFaceRect]];
}


-(NSRect)getFaceRect{
    return NSMakeRect(faceRect.faceRect_OriginX, faceRect.faceRect_OriginY, faceRect.faceRect_Width, faceRect.faceRect_Height);
}

- (IBAction)setMinFaceRect:(id)sender {
    [properties setMinBox:[self getFaceRect]];
}

- (IBAction)increaseFaceRect:(id)sender {
    if([imagePathArray count] <= 0) return;
    faceRectArmLength += 15;
    [self allocFaceRect];
    [self drawPredictedFace];
}

- (IBAction)decreaseFaceRect:(id)sender {
    if([imagePathArray count] <= 0) return;
    faceRectArmLength -= 15;
    [self allocFaceRect];
    [self drawPredictedFace];
    
}

- (IBAction)captureImage:(id)sender {
    if([imagePathArray count] <= 0) return;
    NSImage *saveImage = [IPStaticDrawing getSaveImage:outputImage properties:faceRect];
    NSData *data = [saveImage TIFFRepresentation];
    [data writeToFile:[rootDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"cap_%@_%d.jpg", imageFileName, fileCount++]] atomically:NO];
}

- (IBAction)loadNextImage:(id)sender {
    if([imagePathArray count] <= 0) return;
    if(currentIndex != [imagePathArray count] - 1){
        NSURL *path = [imagePathArray objectAtIndex:++currentIndex];
        [self allocateImage:path];
    }
}



- (IBAction)loadPreviousImage:(id)sender {
    if([imagePathArray count] <= 0) return;
    if(currentIndex != 0){
        NSURL *path = [imagePathArray objectAtIndex:--currentIndex];
        [self allocateImage:path];
    }
}

-(void)allocateImage:(NSURL *)imageUrl {
    sourceImage = nil;
    fileCount = 0;
    imageFileName = [[[imageUrl path] stringByDeletingPathExtension] lastPathComponent];
    sourceImage = [[NSImage alloc] initWithContentsOfURL:imageUrl];
    centerPoint = CGPointMake(sourceImage.size.width / 2, sourceImage.size.height / 2);
    faceRect = nil;
    faceRect = [[IPFaceRect alloc] init];
    properties = nil;
    properties = [[IPFaceRectAttribute alloc] init];
    properties.fileName = imageFileName;
    [properties setTagString:imageFileName];
    [imagePropertiesArray addObject:properties];
    faceRect.imageWidth = sourceImage.size.width;
    faceRect.imageHeight = sourceImage.size.height;
    [predictor freePreviousImage];
     faceRectArmLength = 150;
    [self allocFaceRect];
    [self drawPredictedFace];
}

-(void)allocFaceRect{
    
    faceRect.faceRect_OriginX = centerPoint.x - faceRectArmLength / 2;
    faceRect.faceRect_OriginY = centerPoint.y - faceRectArmLength / 2;
    faceRect.faceRect_Width = faceRectArmLength;
    faceRect.faceRect_Height = faceRectArmLength;
}



-( void)drawPredictedFace{
    
        faceRect.landmarkArray = [predictor predictShape:sourceImage withFaceRect:faceRect];
        outputImage = [IPStaticDrawing drawImage:sourceImage inputFaceProperties:faceRect];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGImageSourceRef source;
            CFDataRef cfdRef = (__bridge CFDataRef)[outputImage TIFFRepresentation];
            source = CGImageSourceCreateWithData(cfdRef, NULL);
            CGImageRef imgRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
            [self.detailsImageView setImage:imgRef imageProperties:nil];
            CGImageRelease(imgRef);
            CFRelease(source);
            source = NULL;
        });
    
}

- (IBAction)openFileDialog:(id)sender {
    
    NSOpenPanel *openPanel = [[NSOpenPanel alloc] init];
    [openPanel setCanChooseFiles:NO];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSFileHandlingPanelOKButton) {
            currentIndex = 0;
                for (NSURL *rootDirectoryURL in [openPanel URLs]) {
                    NSError *error;
                    testXmlUrl = [rootDirectoryURL URLByAppendingPathComponent:@"test_xml" isDirectory:NO];
                    testXmlUrl = [testXmlUrl URLByAppendingPathExtension:@"xml"];
                    self.rootDirectoryTextfield.stringValue = rootDirectoryURL.path;
                    imagePathArray = (NSMutableArray *)[[NSFileManager defaultManager] contentsOfDirectoryAtURL:rootDirectoryURL
                                                includingPropertiesForKeys:nil
                                                                   options:(NSDirectoryEnumerationSkipsHiddenFiles)
                                                                     error:&error];
                    imagePropertiesArray = [[NSMutableArray alloc] init];
                    int count = (int)[imagePathArray count];
                    for(int i = 0; i<count; i++ ){
                        NSURL *path = [imagePathArray objectAtIndex:i];
                        if([[path lastPathComponent] containsString:@"cap_"]){
                            [imagePathArray removeObject:path];
                            i--;
                            count--;
                        }
                    }
                    
                    NSURL *path = [imagePathArray objectAtIndex:currentIndex];
                    rootDirectory = [path.path stringByDeletingLastPathComponent];
                    [self allocateImage:path];
                    if(error){
                        NSLog(@"error : %@", error);
                    }
                    break;
                }
            
        }
    }];
}

- (IBAction)exportLandmarks:(id)sender {
    NSError *error;
    NSMutableString *outputString = [[NSMutableString alloc] initWithContentsOfURL:testXmlUrl encoding:NSUTF8StringEncoding error:&error];
    

    if(![outputString containsString:@"<dataset>"]){
        
        [outputString appendString:@"<?xml version=\"1.0\"?>\n<dataset>\n"];
    } else {
        outputString = (NSMutableString *)[outputString stringByReplacingOccurrencesOfString:@"</dataset>" withString:@""];
    }
    for(IPFaceRectAttribute *attribute in imagePropertiesArray){
        if([outputString containsString:attribute.fileName])
            continue;
        [outputString appendString:attribute.imageTagString];
        [outputString appendString:attribute.maxBoxString];
        [outputString appendString:attribute.minBoxString];
        [outputString appendString:attribute.attributeRotation];
        [outputString appendString:@"\n\t</image>"];
    }
    [outputString appendString:@"\n</dataset>"];
    
    
//    [outputString appendString:@"<mask_title>butterfly-live-mask</mask_title>"];
//        [outputString appendString:[NSString stringWithFormat:@"<mask_image_name>%@.jpg</mask_image_name>\n", imageFileName]];
//    [outputString appendString:@"<landmarks_count>68</landmarks_count>\n<landmarks>\n"];
//        for(long partIndex = 0; partIndex < 68; partIndex++){
//            [outputString appendString:[self getLandmarkString:[faceRect.landmarkArray objectAtIndex:partIndex]]];
//        }
//        [outputString appendString:@"\t</landmarks>\n</masklandmark>"];
//    
        NSData *xmlData = [[NSData alloc ] initWithBytes:outputString.UTF8String length:outputString.length];
        [xmlData writeToFile:testXmlUrl.path atomically:YES];
}

-(NSString *)getLandmarkString:(Landmarks *)landmark {
    
    return [NSString stringWithFormat:@"<landmark vertex = \"%ld\" x = \"%ld\" y = \"%ld\"/>\n",
            landmark.landmarkIndex, (long)landmark.xCoodinate, (long)landmark.yCoodinate];
}


@end
