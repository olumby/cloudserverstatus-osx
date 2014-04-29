//
//  OLCloudServers.m
//  Cloud Server Status
//
//  Created by Oliver Lumby on 28/04/14.
//  Copyright (c) 2014 Oliver Lumby. All rights reserved.
//

#import "OLCloudServers.h"

@implementation OLCloudServers

- (id)init {
    return [self initWithClientId:nil andAPIKey:nil];
}

- (id)initWithClientId:(NSString *)clientId andAPIKey:(NSString *)apiKey
{
    NSParameterAssert(clientId != nil && apiKey != nil);
    
    self = [super init];
    
    if (self) {
        self.apiUrl = [NSString stringWithFormat:@"https://api.digitalocean.com"];
        self.apiParams = [[NSDictionary alloc] initWithObjectsAndKeys:apiKey, @"api_key", clientId, @"client_id", nil];
    }
    
    return self;
}

- (void)updateClientId:(NSString *)clientId andAPIKey:(NSString *)apiKey
{
    NSParameterAssert(clientId != nil && apiKey != nil);
    
    self.apiParams = [[NSDictionary alloc] initWithObjectsAndKeys:apiKey, @"api_key", clientId, @"client_id", nil];
}

- (NSDictionary *)makeRequestTo:(NSString *)path withParams:(NSDictionary *)params andCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
{
    
    NSOperationQueue *callerQueue = [NSOperationQueue currentQueue];
    
    NSMutableDictionary *requestParams = [[NSMutableDictionary alloc] initWithDictionary:self.apiParams];
    [requestParams addEntriesFromDictionary:params];
    
    NSURL *myURL = [self prepareRequestUrl:self.apiUrl withPath:path andDictionary:requestParams];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:myURL]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                               
                               [callerQueue addOperationWithBlock:^{
                                   callback(nil, res);
                               }];
                               
                           }];
    
    return self.apiParams;
    
}

- (NSString*)urlEscapeString:(NSString *)unencodedString
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}

- (NSURL *)prepareRequestUrl:(NSString *)urlString withPath:(NSString *)path andDictionary:(NSDictionary *)dictionary
{
    
    NSMutableString *finalUrl = [[NSMutableString alloc] initWithString:urlString];
    [finalUrl appendString:path];
    
    for (id key in dictionary) {
        NSString *keyString = [key description];
        NSString *valueString = [[dictionary objectForKey:key] description];
        
        if ([finalUrl rangeOfString:@"?"].location == NSNotFound) {
            [finalUrl appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        } else {
            [finalUrl appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        }
    }
    
    return [NSURL URLWithString:finalUrl];
}

@end