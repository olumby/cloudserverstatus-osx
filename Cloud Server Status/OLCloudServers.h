//
//  OLCloudServers.h
//  Cloud Server Status
//
//  Created by Oliver Lumby on 28/04/14.
//  Copyright (c) 2014 Oliver Lumby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLCloudServers : NSObject

@property (strong, retain) NSString *apiUrl;
@property (strong, retain) NSDictionary *apiParams;

- (id)initWithClientId:(NSString *)clientId andAPIKey:(NSString *)apiKey;
- (void)updateClientId:(NSString *)clientId andAPIKey:(NSString *)apiKey;
- (NSDictionary *)makeRequestTo:(NSString *)path withParams:(NSDictionary *)params andCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;

@end