//
//  NewServerWindowController.h
//  Cloud Server Status
//
//  Created by Oliver Lumby on 29/04/14.
//  Copyright (c) 2014 Oliver Lumby. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OLCloudServers.h"

@interface NewServerWindowController : NSWindowController

@property (nonatomic, strong) OLCloudServers *cloudServers;
@property (weak) IBOutlet NSTextField *dropletName;
@property (weak) IBOutlet NSPopUpButton *dropletSize;
@property (weak) IBOutlet NSPopUpButton *dropletImage;
@property (weak) IBOutlet NSPopUpButton *dropletRegion;
@property (weak) IBOutlet NSTextField *dropletKeys;
@property (weak) IBOutlet NSButton *dropletPrivate;
@property (weak) IBOutlet NSButton *dropletBackups;
@property (weak) IBOutlet NSPopover *dropletPopover;

- (IBAction)createDroplet:(id)sender;
- (IBAction)showDropletPop:(id)sender;

@end
