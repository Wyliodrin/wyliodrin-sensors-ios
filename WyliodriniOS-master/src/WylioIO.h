//
//  WylioIO.h
//  Messages Test
//
//  Created by Alexandru Radovici on 29/10/14.
//  Copyright (c) 2014 Alexandru Radovici. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WYLIO_ADDRESS "https://www.wyliodrin.com/"

@interface WylioIO : NSObject

+(void)sendGet:(NSString*)url;
+(void)sendPost:(NSString*)url JSON:(NSData*)json;

@end
