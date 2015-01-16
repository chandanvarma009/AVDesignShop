//
//  NSImage+Scale.m
//  AVDesignShop
//
//  Created by Angel Vasa on 15/01/15.
//  Copyright (c) 2015 Angel Vasa. All rights reserved.
//

#import "NSImage+Scale.h"

@implementation NSImage (Scale)

-(NSImage *)resizeImage:(NSImage *)image toSize:(NSSize)size {
    NSImage *sourceImage = image;
    
    if (![sourceImage isValid]){
        
    } else {
        NSImage *resizedImage = [[NSImage alloc] initWithSize: size];
        [resizedImage lockFocus];
        [sourceImage setSize: size];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, size.width, size.height) operation:NSCompositeCopy fraction:1.0];
        [resizedImage unlockFocus];
        return resizedImage;
    }
    return nil;
}

@end
