//
//  ParserTestMacAppDelegate.h
//  ParserTestMac
//
//  Created by Robbie Hanson on 11/22/09.
//  Copyright 2009 Deusty Designs, LLC.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ParserTestMacAppDelegate : NSObject <UIApplicationDelegate>
{
    __unsafe_unretained UIWindow *window;
}

@property (unsafe_unretained) IBOutlet UIWindow *window;

@end
