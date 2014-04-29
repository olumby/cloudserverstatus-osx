//
//  PreferencesWindowController.m
//  Cloud Server Status
//
//  Created by Oliver Lumby on 28/04/14.
//  Copyright (c) 2014 Oliver Lumby. All rights reserved.
//

#import "PreferencesWindowController.h"

@interface PreferencesWindowController ()

@end

@implementation PreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if( [defaults objectForKey:@"clientID"] )
        [self.clientID setStringValue:[defaults objectForKey:@"clientID"]];
    
    if( [defaults objectForKey:@"apiKey"] )
        [self.apiKey setStringValue:[defaults objectForKey:@"apiKey"]];
    
    if( [defaults objectForKey:@"reloadTimer"] )
        [self.reloadTimer setStringValue:[defaults objectForKey:@"reloadTimer"]];
    
}

- (void)windowWillClose:(NSNotification *)notification
{
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.clientID.stringValue forKey:@"clientID"];
    [defaults setObject:self.apiKey.stringValue forKey:@"apiKey"];
    [defaults setObject:self.reloadTimer.stringValue forKey:@"reloadTimer"];
    
    [defaults synchronize];
    
}

@end