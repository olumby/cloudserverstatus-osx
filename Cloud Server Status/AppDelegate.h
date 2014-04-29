//
//  AppDelegate.h
//  Cloud Server Status
//
//  Created by Oliver Lumby on 28/04/14.
//  Copyright (c) 2014 Oliver Lumby. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OLCloudServers.h"

@class PreferencesWindowController;
@class NewServerWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    @private PreferencesWindowController *preferencesController;
    @private NewServerWindowController *newServerController;
}

@property (strong, nonatomic) NSString *apiKey;
@property (strong, nonatomic) NSString *clientID;

@property (strong, nonatomic) OLCloudServers *cloudServers;
@property (strong, nonatomic) NSStatusItem *statusBarItem;
@property (strong, nonatomic) NSMenu *statusMenu;
@property (strong, nonatomic) NSMutableArray *dropletArray;
@property (strong, nonatomic) NSMutableDictionary *dropletRegions;
@property (strong, nonatomic) NSMutableDictionary *dropletImages;
@property (strong, nonatomic) NSMutableDictionary *dropletSizes;



@end
