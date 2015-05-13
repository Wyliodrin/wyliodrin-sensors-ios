#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"


@interface MucController : UIViewController <UIWebViewDelegate>
{
	__strong XMPPStream * xmppStream;
	__strong XMPPRoom   * xmppRoom;
	__strong id <XMPPRoomStorage> xmppRoomStorage;
	
	IBOutlet UITableView * messagesTableView;
	IBOutlet UITextField * sendMessageField;
	IBOutlet UITextField * logField;
	IBOutlet UITableView * occupantsTableView;
}

- (id)initWithStream:(XMPPStream *)stream roomJID:(XMPPJID *)roomJID;

@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPJID *jid;


- (IBAction)sendMessage:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MessageCellView : UITableView

@property (nonatomic, strong) IBOutlet UITextField *nicknameField;
@property (nonatomic, strong) IBOutlet UITextField *messageField;

- (CGFloat)fittingHeight;

@end
