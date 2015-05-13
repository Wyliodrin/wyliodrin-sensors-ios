//
//  ViewController.h
//  DeviceSender
//
//  Created by Laur Neagu on 04/05/15.
//  Copyright (c) 2015 Laur Neagu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

#import "WylioBoard.h"
#import "XMPPFramework.h"
#import "iPhoneXMPPAppDelegate.h"

#import "QRCode.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *sensorController;
@property (strong, nonatomic) IBOutlet UIButton *viewQR;
@property (strong, nonatomic) IBOutlet UIButton *backPressed;

@end

