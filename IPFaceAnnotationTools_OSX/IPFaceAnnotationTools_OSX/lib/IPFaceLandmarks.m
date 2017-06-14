//
//  IPFaceLandmarks.m
//  IPFaceAnnotationTools_OSX
//
//  Created by Mostafizur Rahman on 6/7/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "IPFaceLandmarks.h"

@implementation IPFaceLandmarks

@end

@implementation Landmarks

@end
@implementation IPFaceRectAttribute

-(instancetype)init{
    self = [super init];
    self.minBoxString = @"";
    self.maxBoxString = @"";
    self.imageTagString = @"";
    self.fileName = @"";
    [self setRotation:0];
    return self;
}
-(void)setMinBox:(NSRect)mbox{
    self.minBoxString = [NSString stringWithFormat:@"\n\t\t<minbox top='%.0f' left='%.0f' width='%.0f' height='%.0f' />",
                         mbox.origin.y,mbox.origin.x,mbox.size.width,mbox.size.height];
}
-(void)setMaxBox:(NSRect)mbox{
    self.maxBoxString = [NSString stringWithFormat:@"\n\t\t<maxbox top='%.0f' left='%.0f' width='%.0f' height='%.0f' />",
                         mbox.origin.y,mbox.origin.x,mbox.size.width,mbox.size.height];
}

-(void)setTagString:(NSString *)fileName{
    self.imageTagString = [NSString stringWithFormat:@"\n\t<image file='%@'>", fileName];
}

-(void)setRotation:(const float)angle{
    self.attributeRotation = [NSString stringWithFormat:@"\n\t\t<rotation angle='%2f' />",angle];
}
@end
