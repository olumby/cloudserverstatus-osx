//
//  PreferencesWindowController.h
//  Cloud Server Status
//
//  Created by Oliver Lumby on 28/04/14.
//  Copyright (c) 2014 Oliver Lumby. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesWindowController : NSWindowController

@property (strong, retain) IBOutlet NSTextField *clientID;
@property (strong, retain) IBOutlet NSTextField *apiKey;
@property (strong, retain) IBOutlet NSTextField *reloadTimer;

@end
