//
//  NSImage+Scale.h
//  AVDesignShop
//
//  Created by Angel Vasa on 15/01/15.
//  Copyright (c) 2015 Angel Vasa. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Scale)

-(NSImage *)resizeImage:(NSImage *)image toSize:(NSSize)size;

@end
