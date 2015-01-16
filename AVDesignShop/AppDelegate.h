//
//  AppDelegate.h
//  AVDesignShop
//
//  Created by Angel Vasa on 15/01/15.
//  Copyright (c) 2015 Angel Vasa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileChooserViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) IBOutlet FileChooserViewController *viewController;

@end

