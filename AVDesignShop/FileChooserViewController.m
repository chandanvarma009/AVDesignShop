//
//  FileChooserViewController.m
//  AVDesignShop
//
//  Created by Angel Vasa on 15/01/15.
//  Copyright (c) 2015 Angel Vasa. All rights reserved.
//

#import "FileChooserViewController.h"
#import "NSImage+Scale.h"

typedef NS_ENUM(NSUInteger, DeviceType) {
    iOS = 1,
    Android = 2,
    Windows = 3,
};

#define kIOS @"iOS"
#define kANDROID @"android"
#define kWINDOWS @"windows"

@interface FileChooserViewController ()


@property (nonatomic, strong) IBOutlet NSView *scaleView;
@property (nonatomic, strong) IBOutlet NSView *settingView;

@property (nonatomic, strong) NSArray *keyPair;
@property (nonatomic, strong) NSArray *valuePair;


@property (nonatomic, strong) NSArray *androidValuePairs;
@property (nonatomic, strong) NSArray *androidKeyPairs;


@property (nonatomic, strong) NSArray *windowsValuePairs;
@property (nonatomic, strong) NSArray *windowsKeyPairs;


@property (nonatomic, strong) NSDictionary *iOSDict;
@property (nonatomic, strong) NSDictionary *androidDict;
@property (nonatomic, strong) NSDictionary *windowsDict;


@property (nonatomic, strong) IBOutlet NSButton *iOSButton;
@property (nonatomic, strong) IBOutlet NSButton *androidButton;
@property (nonatomic, strong) IBOutlet NSButton *windowsButton;
@property (nonatomic, strong) IBOutlet NSButton *selectPath;

@property (nonatomic, strong) IBOutlet NSTextField *textField;

@property (nonatomic, strong) IBOutlet NSTextField *saveToPathTextField;
@property (nonatomic, strong) IBOutlet NSTextField *iconPathTextField;

@property (nonatomic, strong) NSOpenPanel *selectIconpanel;

@property (nonatomic, strong) NSString *saveToPath;



@end

@implementation FileChooserViewController


- (void)loadView {
    [super loadView];
    
    self.keyPair = [[NSArray alloc] initWithObjects:@29, @58, @87, @40, @80, @120, @120, @180, @76, @152, @120, @512, @1024, nil];
    self.valuePair = [[NSArray alloc] initWithObjects:@"Icon-Small.png", @"Icon-Small@2x.png", @"Icon-Small@3x.png", @"Icon-40.png", @"Icon-40@2x.png", @"Icon-40@3x.png", @"Icon-60@2x.png", @"Icon-60@3x.png", @"Icon-76.png", @"Icon-76@2x.png", @"Icon-120.png", @"iTunesArtwork.png", @"iTunesArtwork@2x.png", nil];
    self.iOSDict = [[NSDictionary alloc] initWithObjects:self.valuePair forKeys:self.keyPair];

    
   
    self.androidValuePairs = [[NSArray alloc] initWithObjects:@"drawable-ldpi", @"drawable-mdpi", @"drawable-hdpi", @"drawable-xhdpi", @"drawable-xxhdpi", @"drawable-xxxhdpi",@"PlayStore", nil];
    self.androidKeyPairs = [[NSArray alloc] initWithObjects:@36, @48, @72, @96, @144, @192,@512, nil];
    self.androidDict = [[NSDictionary alloc] initWithObjects:self.androidValuePairs forKeys:self.androidKeyPairs];
    

    
    self.windowsValuePairs = [[NSArray alloc] initWithObjects:@"w-62.png", @"w-99.png", @"w-173.png", @"w-200.png", nil];
    self.windowsKeyPairs = [[NSArray alloc] initWithObjects:@62,@99, @173, @200, nil];
    self.windowsDict = [[NSDictionary alloc] initWithObjects:self.windowsValuePairs forKeys:self.windowsKeyPairs];
    
    
    [self.scaleView setHidden:NO];
    
    [self.iOSButton setState:[[NSUserDefaults standardUserDefaults] boolForKey:kIOS]];
    [self.androidButton setState:[[NSUserDefaults standardUserDefaults] boolForKey:kANDROID]];
    [self.windowsButton setState:[[NSUserDefaults standardUserDefaults] boolForKey:kWINDOWS]];
}


- (IBAction)deviceSelection:(NSButton *)sender {
    if (sender.tag == iOS) {
        [[NSUserDefaults standardUserDefaults] setBool:sender.state forKey:kIOS];
    } else if (sender.tag == Android) {
        [[NSUserDefaults standardUserDefaults] setBool:sender.state forKey:kANDROID];
    } else if (sender.tag == Windows) {
        [[NSUserDefaults standardUserDefaults] setBool:sender.state forKey:kWINDOWS];
    }
}


- (IBAction)chooseFileAction:(id)sender {
    self.selectIconpanel = [NSOpenPanel openPanel];
    [self.selectIconpanel setCanChooseFiles:YES];
    [self.selectIconpanel setCanChooseDirectories:NO];
    
    NSInteger clicked = [self.selectIconpanel runModal];
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [self.selectIconpanel URLs]) {
            NSString *path = [NSString stringWithFormat:@"%@", url];
            path = [path stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            [self.iconPathTextField setStringValue:path];
        }
    }
}


- (IBAction)selectPath:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    
    NSInteger clicked = [panel runModal];
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [panel URLs]) {
            self.saveToPath = [NSString stringWithFormat:@"%@", url];
            self.saveToPath = [self.saveToPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            [self.saveToPathTextField setStringValue:self.saveToPath];
        }
    }
}


- (IBAction)generateAction:(id)sender {
    for (NSURL *url in [self.selectIconpanel URLs]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self writeToDirectoryForUrl:url];
        });
    }
    
    
    NSString *alertMessage;
    if ([[self.selectIconpanel URLs] count] > 0) {
        if ([self.saveToPath length] > 0) {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kIOS] || [[NSUserDefaults standardUserDefaults] boolForKey:kANDROID] || [[NSUserDefaults standardUserDefaults] boolForKey:kWINDOWS]) {
                alertMessage = @"Icon generated Successfully";
            } else {
             alertMessage = @"Please select device for which you want to generate images";
            }
        } else {
            alertMessage = @"Please select path to save images";
        }
    } else {
        alertMessage = @"Please select Icon to convert";
    }
    
    
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:alertMessage];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}


- (void)createDirectoryAtPath:(NSString *)path {
    NSError * error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error != nil) {
        NSLog(@"error creating directory: %@", error);
    }
}


- (void)createFolders {
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIOS]) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:kIOS]) {
            NSString *path = [NSString stringWithFormat:@"%@/%@", self.saveToPath,@"iOS"];
            [self createDirectoryAtPath:path];
        }
    }
    
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kANDROID]) {
        for (int i = 0; i < [self.androidDict count]; i++) {
            NSString *temp = [NSString stringWithFormat:@"%@/%@", self.saveToPath,@"Android"];
            NSString *path = [NSString stringWithFormat:@"%@/%@",temp,[self.androidDict allValues][i]];
            [self createDirectoryAtPath:path];
        }
        
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kWINDOWS]) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", self.saveToPath,@"Windows"];
        [self createDirectoryAtPath:path];
    }
    
    
    
}

- (void)writeToFileAtPath:(NSString *)path forUrl:(NSURL *)url WithSize:(float)size {
    NSImage *selectedImage = [[NSImage alloc] initWithData:[NSData dataWithContentsOfFile:[url path]]];
    NSImage *resized = [selectedImage resizeImage:selectedImage toSize:NSSizeFromCGSize(CGSizeMake(size, size))];
    NSBitmapImageRep *bmpImageRep = [[NSBitmapImageRep alloc]initWithData:[resized TIFFRepresentation]];
    [resized addRepresentation:bmpImageRep];
    NSData *data = [bmpImageRep representationUsingType: NSPNGFileType properties: nil];
    [data writeToFile:path atomically: NO];
}


- (void)writeToDirectoryForUrl:(NSURL *)url {
    
    
    [self createFolders];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIOS]) {
        for (int i = 0; i < [self.iOSDict count]; i++) {
            NSString *nameString = [self.iOSDict allValues][i];
            if ([[self.textField stringValue] length] > 0) {
                nameString = [nameString stringByReplacingOccurrencesOfString:@"Icon" withString:[self.textField stringValue]];
            }
            
        
            
            NSString *temp = [NSString stringWithFormat:@"%@/%@", self.saveToPath,@"iOS"];
            NSString *tempPath = [[NSString alloc] initWithFormat:@"%@/%@",temp,nameString];
            float size = [[self.iOSDict allKeys][i] floatValue] / 2;
            
            
            [self writeToFileAtPath:tempPath forUrl:url WithSize:size];
        }
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kANDROID]) {
        for (int i = 0; i < [self.androidDict count]; i++) {
            NSString *temp = [NSString stringWithFormat:@"%@/%@", self.saveToPath,@"Android"];
            NSString *str = [NSString stringWithFormat:@"%@/%@",temp,[self.androidDict allValues][i]];
            NSString *tempPath;
            if ([[self.textField stringValue] length] > 0) {
                tempPath = [[NSString alloc] initWithFormat:@"%@/%@.png",str,[self.textField stringValue]];
            } else {
                tempPath = [[NSString alloc] initWithFormat:@"%@/%@",str,@"Icon.png"];
            }
            
            
            float size = [[self.androidDict allKeys][i] floatValue] / 2;
            [self writeToFileAtPath:tempPath forUrl:url WithSize:size];
        }
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kWINDOWS]) {
        for (int i = 0; i < [self.windowsDict count]; i++) {
            NSString *temp = [NSString stringWithFormat:@"%@/%@", self.saveToPath,@"Windows"];
            
            NSString *str = [NSString stringWithFormat:@"%@",temp];
            NSString *tempPath;
            
            NSString *nameString = [self.windowsDict allValues][i];
            if ([[self.textField stringValue] length] > 0) {
                nameString = [nameString stringByReplacingOccurrencesOfString:@"w" withString:[self.textField stringValue]];
            }
            
            if ([[self.textField stringValue] length] > 0) {
                tempPath = [[NSString alloc] initWithFormat:@"%@/%@.png",str,nameString];
            } else {
                tempPath = [[NSString alloc] initWithFormat:@"%@/%@",str,[self.windowsDict allValues][i]];
            }
            
            
            float size = [[self.windowsDict allKeys][i] floatValue] / 2;
            [self writeToFileAtPath:tempPath forUrl:url WithSize:size];
        }
    }
    
    
}

@end
