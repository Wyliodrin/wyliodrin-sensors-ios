#import <UIKit/UIKit.h>



@interface RosterController : NSObject <UITableViewDelegate>
{
	BOOL useSSL;
	BOOL customCertEvaluation;
	
	BOOL isOpen;
	BOOL isRegistering;
	BOOL isAuthenticating;
	
	NSArray *roster;
    
	// Sign-In Sheet
	
	IBOutlet UILabel     * signInSheet;
	IBOutlet UITextField * serverField;
	IBOutlet UITextField * portField;
	IBOutlet UIButton    * sslButton;
	IBOutlet UIButton    * customCertEvalButton;
	IBOutlet UITextField * jidField;
    IBOutlet UITextField * passwordField;
	IBOutlet UIButton    * rememberPasswordCheckbox;
    IBOutlet UITextField * resourceField;
	IBOutlet UITextField * messageField;
	IBOutlet UIButton    * registerButton;
    IBOutlet UIButton    * signInButton;
	
	// MUC Sheet
	
	IBOutlet UILabel     * mucSheet;
	IBOutlet UITextField * mucRoomField;
	
	// Roster Window
	
	IBOutlet UIWindow    * window;
    IBOutlet UITableView * rosterTable;
	IBOutlet UITextField * buddyField;
}

// Sign-In Sheet

- (void)displaySignInSheet;

- (IBAction)jidDidChange:(id)sender;
- (IBAction)createAccount:(id)sender;
- (IBAction)signIn:(id)sender;

// MUC Sheet

- (IBAction)mucCancel:(id)sender;
- (IBAction)mucJoin:(id)sender;

// Roster Window

- (IBAction)changePresence:(id)sender;
- (IBAction)muc:(id)sender;
- (IBAction)connectViaXEP65:(id)sender;
- (IBAction)chat:(id)sender;
- (IBAction)addBuddy:(id)sender;
- (IBAction)removeBuddy:(id)sender;


@end
