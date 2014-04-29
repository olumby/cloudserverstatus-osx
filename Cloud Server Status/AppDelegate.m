//
//  AppDelegate.m
//  Cloud Server Status
//
//  Created by Oliver Lumby on 28/04/14.
//  Copyright (c) 2014 Oliver Lumby. All rights reserved.
//

#import "AppDelegate.h"
#import "PreferencesWindowController.h"
#import "NewServerWindowController.h"

@implementation AppDelegate

#define digitalOceanSeperator 10;

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    
    self.statusBarItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusBarItem.title = @"";
    self.statusBarItem.image = [NSImage imageNamed:@"MenuBarIcon"];
    self.statusBarItem.alternateImage = [NSImage imageNamed:@"MenuBarIconAlt"];
    self.statusBarItem.highlightMode = YES;
    
    self.statusMenu = [[NSMenu alloc] init];
    [self.statusMenu addItemWithTitle:@"Loading.." action:nil keyEquivalent:@""];
    
    NSMenuItem *doSeperator = [NSMenuItem separatorItem];
    doSeperator.tag = digitalOceanSeperator;
    
    [self.statusMenu addItem:doSeperator];

    NSMenu *createSubMenu = [[NSMenu alloc] initWithTitle:@"New Server"];
    [createSubMenu addItemWithTitle:@"Digital Ocean" action:@selector(newDroplet:) keyEquivalent:@""];
    
    NSMenuItem *createMenu = [[NSMenuItem alloc] initWithTitle:@"New Server" action:nil keyEquivalent:@""];
    createMenu.submenu = createSubMenu;
    [self.statusMenu addItem:createMenu];
    
    [self.statusMenu addItem:[NSMenuItem separatorItem]];
    
    
    [self.statusMenu addItemWithTitle:@"Refresh" action:@selector(reloadDroplets) keyEquivalent:@""];
    [self.statusMenu addItemWithTitle:@"Preferences" action:@selector(showPreferences:) keyEquivalent:@""];
    [self.statusMenu addItemWithTitle:@"Check for Updates" action:nil keyEquivalent:@""];
    
    [self.statusMenu addItem:[NSMenuItem separatorItem]];
    
    [self.statusMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    self.statusBarItem.menu = self.statusMenu;
    
    if( ! [[NSUserDefaults standardUserDefaults] objectForKey:@"clientID"] || ! [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"] )
    {
        [self showPreferences:nil];
    } else
    {
        self.cloudServers = [[OLCloudServers alloc] initWithClientId:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientID"] andAPIKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"]];
    }
    
    if( [[NSUserDefaults standardUserDefaults] objectForKey:@"reloadTimer"] > 0 )
    {
        
        float timerInterval = [[[NSUserDefaults standardUserDefaults] objectForKey:@"reloadTimer"] floatValue];
        NSTimer *reloadTimer = [NSTimer timerWithTimeInterval:timerInterval target:self selector:@selector(timerFired:) userInfo:nil repeats:TRUE];
        
        [[NSRunLoop currentRunLoop] addTimer:reloadTimer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer:reloadTimer forMode:NSEventTrackingRunLoopMode];
        
    }
    
    [self reloadDroplets];
}

- (void)reloadDroplets
{
    
    [self setMenuMessage:@"Loading.."];
    
    if( !self.cloudServers)
    {
        self.cloudServers = [[OLCloudServers alloc] initWithClientId:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientID"] andAPIKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"]];
    }
    
    [self getDroplets:nil];
}


- (void)getDroplets:(id)sender
{
    
    [self.cloudServers makeRequestTo:@"/droplets/" withParams:nil andCallback:^(NSError *error, NSDictionary *result) {
        
        [self.dropletArray removeAllObjects];
        
        NSMutableArray *array = [result valueForKey:@"droplets"];
        
        self.dropletArray = [array mutableCopy];
        
        [self considerReload];
    }];
    
}

- (void)setMenuMessage:(NSString *)message
{
    int tag = digitalOceanSeperator;
    
    for (int i = (int)[self.statusMenu indexOfItemWithTag:tag]-1 ; i >= 0; i--)
    {
        [self.statusMenu removeItemAtIndex:i];
    }
    
    if(message)
        [self.statusMenu insertItemWithTitle:message action:nil keyEquivalent:@"" atIndex:0];

}


- (void)considerReload
{
    
    [self setMenuMessage:nil];
    
    if ([self.dropletArray count] == 0)
        [self setMenuMessage:@"No Droplets"];
    
    for (NSDictionary *singleDroplet in self.dropletArray)
    {
        
        NSMenu *subMenu = [[NSMenu alloc] init];
        
        // Droplet ID
        
        NSAttributedString *dropletIdString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"ID: %@", [singleDroplet valueForKey:@"id"]]
                                                                              attributes:@{
                                                                                           NSFontAttributeName : [NSFont systemFontOfSize:14],
                                                                                           NSForegroundColorAttributeName : [NSColor blackColor],
                                                                                           }];
        
        NSMenuItem *dropletId = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
        dropletId.attributedTitle = dropletIdString;
        [subMenu addItem:dropletId];
        
        // Droplet Name
        
        NSAttributedString *dropletNameString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Name: %@", [singleDroplet valueForKey:@"name"]]
                                                                                attributes:@{
                                                                                             NSFontAttributeName : [NSFont systemFontOfSize:14],
                                                                                             NSForegroundColorAttributeName : [NSColor blackColor],
                                                                                             }];
        
        NSMenuItem *dropletName = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
        dropletName.attributedTitle = dropletNameString;
        [subMenu addItem:dropletName];
        
        // Droplet IP
        
        NSAttributedString *dropletIpString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"IP: %@", [singleDroplet valueForKey:@"ip_address"]]
                                                                              attributes:@{
                                                                                           NSFontAttributeName : [NSFont systemFontOfSize:14],
                                                                                           NSForegroundColorAttributeName : [NSColor blackColor],
                                                                                           }];
        
        NSMenuItem *dropletIp = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
        dropletIp.attributedTitle = dropletIpString;
        [subMenu addItem:dropletIp];
        
        // The rest
        
        [subMenu addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *powerCycle = [[NSMenuItem alloc] initWithTitle:@"Power Cycle" action:@selector(powerCycle:) keyEquivalent:@""];
        [powerCycle setRepresentedObject:singleDroplet];
        [subMenu addItem:powerCycle];
        
        NSMenuItem *powerOff = [[NSMenuItem alloc] initWithTitle:@"Power Off" action:@selector(powerOff:) keyEquivalent:@""];
        [powerOff setRepresentedObject:singleDroplet];
        [subMenu addItem:powerOff];
        
        NSMenuItem *powerOn = [[NSMenuItem alloc] initWithTitle:@"Power On" action:@selector(powerOn:) keyEquivalent:@""];
        [powerOn setRepresentedObject:singleDroplet];
        [subMenu addItem:powerOn];
        
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@" %@", [singleDroplet valueForKey:@"name"]] action:nil keyEquivalent:@""];
        menuItem.submenu = subMenu;
        
        
        if( [[singleDroplet valueForKey:@"status"] isEqualToString:@"active"] )
        {
            menuItem.offStateImage = [NSImage imageNamed:NSImageNameStatusAvailable];
        } else
        {
            menuItem.offStateImage = [NSImage imageNamed:NSImageNameStatusUnavailable];
        }
        
        [self.statusMenu insertItem:menuItem atIndex:0];
    }
    
}

- (void)powerCycle:(id)sender
{
    NSMenuItem *menuItem = sender;
    
    NSString *requestPath = [NSString stringWithFormat:@"/droplets/%@/power_cycle", [[menuItem representedObject] valueForKey:@"id"]];
    
    [self.cloudServers makeRequestTo:requestPath withParams:nil andCallback:^(NSError *error, NSDictionary *result) {
        
        [self reloadDroplets];
        
    }];
}

- (void)powerOff:(id)sender
{
    NSMenuItem *menuItem = sender;
    
    NSString *requestPath = [NSString stringWithFormat:@"/droplets/%@/power_off", [[menuItem representedObject] valueForKey:@"id"]];
    
    [self.cloudServers makeRequestTo:requestPath withParams:nil andCallback:^(NSError *error, NSDictionary *result) {
        
        [self reloadDroplets];
        
    }];
}

- (void)powerOn:(id)sender
{
    NSMenuItem *menuItem = sender;
    
    NSString *requestPath = [NSString stringWithFormat:@"/droplets/%@/power_on", [[menuItem representedObject] valueForKey:@"id"]];
    
    [self.cloudServers makeRequestTo:requestPath withParams:nil andCallback:^(NSError *error, NSDictionary *result) {
        
        [self reloadDroplets];
        
    }];
}

- (void)newDroplet:(id)sender
{
    if( ! newServerController) {
        newServerController = [[NewServerWindowController alloc] initWithWindowNibName:@"NewServerWindowController"];
    }
    
    [newServerController showWindow:self];
    
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)showPreferences:(id)sender
{
    
    if( ! preferencesController) {
        preferencesController = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindowController"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePreferencesAndReload:) name:NSWindowWillCloseNotification object:preferencesController.window];
    
    [preferencesController showWindow:self];

    [NSApp activateIgnoringOtherApps:YES];
    
}

- (void)updatePreferencesAndReload:(id)sender
{
    
    [self.cloudServers updateClientId:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientID"] andAPIKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"]];
    
    [self reloadDroplets];
    
}

- (void)timerFired:(NSTimer *)timer
{
    [self reloadDroplets];
}

@end
