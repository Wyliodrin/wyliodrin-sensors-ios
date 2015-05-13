#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPP.h"
#import "XMPPRoom.h"


@interface MUCTestingAppDelegate : NSObject <UIApplicationDelegate, XMPPRoomStorage>
{
	XMPPStream *xmppStream;
	XMPPRoom *xmppRoom;
	
	__unsafe_unretained UIWindow *window;
}

@property (unsafe_unretained) IBOutlet UIWindow *window;

@end
