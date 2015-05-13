//
//  WylioBoard.m
//  Messages Test
//
//  Created by Alexandru Radovici on 29/10/14.
//  Copyright (c) 2014 Alexandru Radovici. All rights reserved.
//

#import "WylioBoard.h"
#import "WylioIO.h"

@implementation WylioBoard

@synthesize communication_token;
@synthesize boardid;

-(id)initWithCommunicationToken:(NSString*)_communication_token
{
    self.communication_token = _communication_token;
    return self;
}

-(id)initWithCommunicationToken:(NSString*)_communication_token andBoardID:(NSString*)_boardid
{
    self.communication_token = _communication_token;
    self.boardid = _boardid;
    return self;
}

-(void)sendMessageWithLabel:(NSString*)label message:(id)message
{
    if (boardid==nil)
    {
        [WylioBoard sendMessageWithToken:self.communication_token boardid:self.boardid label:label message:message];
    }
    else
    {
        [WylioBoard sendOpenMessageWithToken:self.communication_token label:label message:message];
    }
}

+(void)sendMessageWithToken:(NSString*) communication_token boardid:(NSString*)boardid label:(NSString*)label message:(id)message
{
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:communication_token, @"communication_token",
                          boardid, @"gadgetid",
                          label, @"label",
                          message, @"message",
                          nil];
    [WylioBoard sendOpenMessage:json];
}


+(void)sendOpenMessageWithToken:(NSString*) communication_token label:(NSString*)label message:(id)message
{
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:communication_token, @"communication_token",
                                                                    label, @"label",
                                                                    message, @"message",
                          nil];
    [WylioBoard sendOpenMessage:json];
}

+(void)sendOpenMessage:(id) json
{
    [WylioIO sendPost:@"message" JSON:[NSJSONSerialization dataWithJSONObject:json options:0 error:nil]];
}

@end
