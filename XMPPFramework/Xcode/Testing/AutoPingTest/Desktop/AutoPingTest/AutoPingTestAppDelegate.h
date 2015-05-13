//
//  AutoPingTestAppDelegate.h
//  AutoPingTest
//
//  Created by Robbie Hanson on 4/13/11.
//  Copyright 2011 Deusty, LLC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPP.h"
#import "XMPPAutoPing.h"


@interface AutoPingTestAppDelegate : NSObject <UIApplicationDelegate> {
@private
	XMPPStream *xmppStream;
	XMPPAutoPing *xmppAutoPing;
	
	__unsafe_unretained UIWindow *window;
}

@property (unsafe_unretained) IBOutlet UIWindow *window;

@end
