//
//  NewServerWindowController.m
//  Cloud Server Status
//
//  Created by Oliver Lumby on 29/04/14.
//  Copyright (c) 2014 Oliver Lumby. All rights reserved.
//

#import "NewServerWindowController.h"

@interface NewServerWindowController ()

@end

@implementation NewServerWindowController

@synthesize dropletPopover = _dropletPopover;

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
    
    self.cloudServers = [[OLCloudServers alloc] initWithClientId:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientID"] andAPIKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"]];
    
    [self populateOptions];
}

- (void)populateOptions
{
    
    [self.cloudServers makeRequestTo:@"/regions/" withParams:nil andCallback:^(NSError *error, NSDictionary *result) {
        
        [[self.dropletRegion menu] removeAllItems];
        
        for(NSDictionary *region in [result valueForKey:@"regions"])
        {
            NSMenuItem *singleRegion = [[NSMenuItem alloc] initWithTitle:[region valueForKey:@"name"] action:nil keyEquivalent:@""];
            singleRegion.representedObject = region;
            [[self.dropletRegion menu] addItem:singleRegion];
        }
        
        [self.dropletRegion setEnabled:TRUE];
        
    }];
    
    [self.cloudServers makeRequestTo:@"/images/" withParams:nil andCallback:^(NSError *error, NSDictionary *result) {
        
        [[self.dropletImage menu] removeAllItems];
        
        for(NSDictionary *image in [result valueForKey:@"images"])
        {
            NSMenuItem *singleImage = [[NSMenuItem alloc] initWithTitle:[image valueForKey:@"name"] action:nil keyEquivalent:@""];
            singleImage.representedObject = image;
            [[self.dropletImage menu] addItem:singleImage];
        }
        
        [self.dropletImage setEnabled:TRUE];
        
    }];
    
    [self.cloudServers makeRequestTo:@"/sizes/" withParams:nil andCallback:^(NSError *error, NSDictionary *result) {
        
        [[self.dropletSize menu] removeAllItems];
        
        for(NSDictionary *size in [result valueForKey:@"sizes"])
        {
            NSMenuItem *singleSize = [[NSMenuItem alloc] initWithTitle:[size valueForKey:@"name"] action:nil keyEquivalent:@""];
            singleSize.representedObject = size;
            [[self.dropletSize menu] addItem:singleSize];
        }
        
        [self.dropletSize setEnabled:TRUE];
        
    }];
    
}

- (IBAction)createDroplet:(id)sender
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:[self.dropletName stringValue] forKey:@"name"];
    [params setValue:[[[self.dropletSize selectedItem] representedObject] valueForKey:@"slug"] forKey:@"size_slug"];
    [params setValue:[[[self.dropletImage selectedItem] representedObject] valueForKey:@"slug"] forKey:@"image_slug"];
    [params setValue:[[[self.dropletRegion selectedItem] representedObject] valueForKey:@"slug"] forKey:@"region_slug"];
    [params setValue:[self.dropletPrivate state]?@"true":@"false" forKey:@"private_networking"];
    [params setValue:[self.dropletBackups state]?@"true":@"false" forKey:@"backups_enabled"];
    
    [self.cloudServers makeRequestTo:@"/droplets/new" withParams:params andCallback:^(NSError *error, NSDictionary *result) {
        
        
    }];
    
}

- (IBAction)showDropletPop:(id)sender
{
    [_dropletPopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
}

@end
