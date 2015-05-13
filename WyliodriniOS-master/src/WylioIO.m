//
//  WylioIO.m
//  Messages Test
//
//  Created by Alexandru Radovici on 29/10/14.
//  Copyright (c) 2014 Alexandru Radovici. All rights reserved.
//

#import "WylioIO.h"

@implementation WylioIO

+(void)sendGet:(NSString*)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @WYLIO_ADDRESS, url]]];
    [request setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (error) {
            NSLog(@"WylioIO: get error %@", error.localizedDescription);
        }}
     ];
    
}

+(void)sendPost:(NSString*)url JSON:(NSData*)jsonData
{
    // NSData *jsonData = [json dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @WYLIO_ADDRESS, url]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lul", (unsigned long)jsonData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    // NSLog (@"%@", [NSString stringWithFormat:@"%@%@", @WYLIO_ADDRESS, url]);
    NSLog (@"%@", [NSString stringWithUTF8String:[jsonData bytes]]);

    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (error) {
            NSLog(@"WylioIO: post error %@", error.localizedDescription);
        }}
     ];
    

}

@end
