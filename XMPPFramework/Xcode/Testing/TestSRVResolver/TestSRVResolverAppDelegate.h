#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class XMPPSRVResolver;


@interface TestSRVResolverAppDelegate : NSObject <UIApplicationDelegate>
{
	XMPPSRVResolver *srvResolver;
	__unsafe_unretained UIWindow *window;
}

@property (unsafe_unretained) IBOutlet UIWindow *window;

@end
