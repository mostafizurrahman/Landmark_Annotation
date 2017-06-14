//
//  IPDrawingView.m
//  IPFaceAnnotationTools_OSX
//
//  Created by Mostafizur Rahman on 6/10/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "IPDrawingView.h"

@implementation IPDrawingView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


-(void)mouseDown:(NSEvent *)event {
    
        [super mouseDown:event];
        
        NSPoint point = [event locationInWindow];
    point = [self getConvertedClickedPoint:point];
    [self.clickedDelegate landmarkClickedAtPoint:point];
}
-(NSPoint)getConvertedClickedPoint:(NSPoint)point{
    NSPoint cPoint = [self convertViewPointToImagePoint:point];
    cPoint = NSMakePoint(cPoint.x - (int)cPoint.x > 0.5 ? ceil(cPoint.x) : floor(cPoint.x),
                         point.y - (int)cPoint.y > 0.5 ? ceil(cPoint.y) : floor(cPoint.y));
    
    
    
    
    
    
    
    return cPoint;
}
@end
