//
//  ViewController.m
//  DeviceSender
//
//  Created by Laur Neagu on 04/05/15.
//  Copyright (c) 2015 Laur Neagu. All rights reserved.
//


/*
 
Sample JSON ENTRIES

 mobile : accelerometer : sdhf3djhdas
 mobile : gyro : sdhf3djhdas
 mobile : magnetometer : sdhf3djhdas
 mobile: location : sdhf3djhdas
 
*/

#import "../SimpleTableCellTableViewCell.h"
#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

#import "DDLog.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

/** Degrees to Radian **/
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

/** Radians to Degrees **/
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

@interface ViewController ()

@end

@implementation ViewController

CMMotionManager *_motionManager;
CLLocationManager *locationManager;

@synthesize sensorController;

NSMutableArray *sensors;
NSMutableArray *sensorsToSendFlags;
NSMutableArray *sensorsThumbs;

NSMutableArray *mapSensorsList;

iPhoneXMPPAppDelegate *appDelegate;

NSString *url;
NSString *keyHeader;
NSString *separator;
NSString *deviceId;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Accessors
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _motionManager = [[CMMotionManager alloc] init];
    sensors = [NSMutableArray array];
    sensorsToSendFlags = [NSMutableArray array];
    sensorsThumbs = [NSMutableArray array];
    mapSensorsList = [NSMutableArray array];
    
    [self addSensorThumbs];
    
    locationManager = [[CLLocationManager alloc] init];

    // Set key header values: Eg : mobile : sensor_type : device_id
    keyHeader = @"mobile";
    separator = @" : ";
    deviceId = @"sdhf3djhdas";
    
    
    if(_motionManager.accelerometerAvailable){
        [sensors addObject:@"Accelerometer"];
        [mapSensorsList addObject:[NSNumber numberWithInteger:[sensorsToSendFlags count]]];
    }
    [sensorsToSendFlags addObject:[NSNumber numberWithBool:NO]];
    
    if(_motionManager.magnetometerAvailable){
        [sensors addObject:@"Magnetic"];
        [mapSensorsList addObject:[NSNumber numberWithInteger:[sensorsToSendFlags count]]];
    }
    [sensorsToSendFlags addObject:[NSNumber numberWithBool:NO]];
    
    if(_motionManager.gyroAvailable){
        [sensors addObject:@"Gyroscope"];
        [mapSensorsList addObject:[NSNumber numberWithInteger:[sensorsToSendFlags count]]];
    }
    [sensorsToSendFlags addObject:[NSNumber numberWithBool:NO]];
    
    [sensors addObject:@"GPS"];
    [mapSensorsList addObject:[NSNumber numberWithInteger:[sensorsToSendFlags count]]];
    [sensorsToSendFlags addObject:[NSNumber numberWithBool:NO]];
    
    /*
    [sensors addObject:@"Another"];
    [mapSensorsList addObject:[NSNumber numberWithInteger:[sensorsToSendFlags count]]];
    [sensorsToSendFlags addObject:[NSNumber numberWithBool:NO]];
     */
    
    NSLog(@"Available sensors loaded!");
    
    // Check if we have a qr code set
    NSString *shared = [QRCode qrCode];
    
    if([shared isEqualToString: @""]){
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"No Token available" message:@"Please scan the QR Code to send the sensors values " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [messageAlert show];
    }
    
    // SENSOR VALUES
    [NSTimer scheduledTimerWithTimeInterval:2
                                    target:self
                                    selector:@selector(getSensorValues)
                                    userInfo:nil
                                    repeats:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    iPhoneXMPPAppDelegate *appDeleg  = [[iPhoneXMPPAppDelegate alloc ]init];
    
    if(appDelegate == nil){
        [appDeleg setupStream];
        appDelegate = appDeleg;
    
        // AUTHENTICATE
        if ([appDeleg connect])
        {
            //NSString *jid = [[[appDelegate xmppStream] myJID] bare];
            NSLog(@"Connected");
        } else
        {
            NSLog(@"Not connected");
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sensors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    SimpleTableCellTableViewCell *cell = (SimpleTableCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.nameLabel.text = [sensors objectAtIndex:[mapSensorsList[indexPath.row] intValue]];
  
    if([sensorsThumbs count] > [mapSensorsList[indexPath.row] intValue]){
        cell.thumbnailImageView.image = [UIImage imageNamed:[sensorsThumbs objectAtIndex:[mapSensorsList[indexPath.row] intValue]]];
        cell.thumbnailImageView.contentMode   = UIViewContentModeScaleAspectFill;
        cell.thumbnailImageView.clipsToBounds = YES;
    }
    
    [cell.enabledSwitch setOn:NO animated:YES];
    cell.enabledSwitch.tag = [mapSensorsList[indexPath.row] intValue];
    [cell.enabledSwitch addTarget:self
                        action:@selector(myAction:)
                        forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

-(void)myAction: (id) sender {
    if(url == nil || [url isEqualToString:@""]){
           url =[QRCode qrCode];
    }

     UISwitch *clicked = (UISwitch *) sender;
    
    UISwitch *clicked_switch = (UISwitch *)sender;
     NSString *dataStatus = @"";
    
    if(![clicked_switch isOn]){
        dataStatus = @"Stopped sending data !";
        
        [sensorsToSendFlags removeObjectAtIndex:clicked.tag];
        [sensorsToSendFlags insertObject:[NSNumber numberWithBool:NO] atIndex:clicked.tag];

    }
    else{
        if(![url isEqualToString:@""] && url){
            dataStatus = @"Started sending data !";
            
            [sensorsToSendFlags removeObjectAtIndex:clicked.tag];
            [sensorsToSendFlags insertObject:[NSNumber numberWithBool:YES] atIndex:clicked.tag];
        }
        else{
            dataStatus = @"No token Found ! Please scan one to start sending data";
            [clicked_switch setOn:NO animated:YES];
        }

        
    }
    
    // your code
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:dataStatus message:[NSString stringWithFormat: @"%d %d" , clicked.tag, [clicked_switch isOn]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display Alert Message
    [messageAlert show];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70; //80
}

- (IBAction)btnBackClicked:(UIButton *)sender{
    //[appDelegate disconnect];
}

- (IBAction)btnViewQRClicked:(UIButton *)sender{
  
    NSString *shared = [QRCode qrCode];
    
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Current token" message:shared delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [messageAlert show];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

double rotation = 0;

-(void)getSensorValues{

    // values initialized
    
    if([sensorsToSendFlags count ]> 0){
        
        // ACCELEROMETER VALUES
        CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
        CMAcceleration acceleration = accelerometerData.acceleration;
        if([[sensorsToSendFlags objectAtIndex:0] isEqualToNumber:[NSNumber numberWithBool:YES]]){
            if(!_motionManager.accelerometerActive){
                [_motionManager startAccelerometerUpdates];
            }
        
            NSLog(@"Accelerometer x : %lf y : %lf z : %lf", acceleration.x, acceleration.y, acceleration.z);
       
            // HTTP POST TO BOARD
            [self sendHTTPPostMessageToBoard:acceleration.x :acceleration.y :acceleration.z :@"accelerometer"];
        }
        else{
            if(_motionManager.accelerometerActive){
                [_motionManager stopAccelerometerUpdates];
            }
        }
    
   
        // MAGNETOMETER VALUES
        CMMagnetometerData *magnetometerData = _motionManager.magnetometerData;
        if([[sensorsToSendFlags objectAtIndex:1] isEqualToNumber:[NSNumber numberWithBool:YES]]){
            if(!_motionManager.magnetometerActive){
                [_motionManager startMagnetometerUpdates];
                _motionManager.showsDeviceMovementDisplay = true;
            }
           
            double x = magnetometerData.magneticField.x;
            double y = magnetometerData.magneticField.y;
            double z = magnetometerData.magneticField.z;
        
            NSLog(@"Magnetometer x : %lf y : %lf z : %lf", x, y, z);
        
            // HTTP POST TO BOARD
            [self sendHTTPPostMessageToBoard:x :y :z :@"magnetometer"];
        }
        else{
            if(_motionManager.magnetometerActive){
                [_motionManager stopMagnetometerUpdates];
            }
        }

    
        // GYROSCOPE VALUES
        if([[sensorsToSendFlags objectAtIndex:2] isEqualToNumber:[NSNumber numberWithBool:YES]]){
            if(!_motionManager.gyroActive){
                [_motionManager startGyroUpdates];
            }
        
            CMGyroData *gyroData = _motionManager.gyroData;
        
            NSLog(@"Gyro x : %lf y : %lf z : %lf", gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z);
        
            // HTTP POST TO BOARD
            [self sendHTTPPostMessageToBoard:gyroData.rotationRate.x :gyroData.rotationRate.y :gyroData.rotationRate.z :@"gyro"];
        }
        else{
            if(_motionManager.gyroActive){
                [_motionManager stopGyroUpdates];
            }

        }
        
        // GPS VALUES
        if([[sensorsToSendFlags objectAtIndex:3] isEqualToNumber:[NSNumber numberWithBool:YES]]){
            if(![locationManager delegate]){
                locationManager.delegate = self;
                locationManager.distanceFilter = kCLDistanceFilterNone;
                locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
                    [locationManager requestWhenInUseAuthorization];
                [locationManager startUpdatingLocation];
            }
        }
        else{
            if([locationManager delegate]){
                [locationManager stopUpdatingLocation];
                locationManager.delegate = nil;
            }
        }

    }
}

- (IBAction)getCurrentLocation:(id)sender {
    }

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
      
        if([[sensorsToSendFlags objectAtIndex:3] isEqualToNumber:[NSNumber numberWithBool:YES]]){
            NSLog(@"Location latitude : %.8f longitude : %.8f ", location.coordinate.latitude, location.coordinate.longitude);
            
            [self sendHTTPPostMessageLocationToBoard:location.coordinate.latitude :location.coordinate.longitude :@"location"];
        }

    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
    }
}

-(void) sendMessageToBoard:(NSString *)curr_message{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    
    [body setStringValue:curr_message];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:@"laur-imaginefriend@wyliodrin.org"];
    [message addChild:body];
    
    [appDelegate.xmppStream sendElement:message];
}


-(void)sendHTTPPostMessageToBoard:(double)x :(double)y :(double)z :(NSString *)sensorType{
    NSDictionary *value = @{
                            @"x" : [NSString stringWithFormat:@"%lf", x],
                            @"y" : [NSString stringWithFormat:@"%lf", y],
                            @"z" : [NSString stringWithFormat:@"%lf", z]
                            };
    
    NSString *labelData = keyHeader;
    labelData = [labelData stringByAppendingString:separator];
    labelData = [labelData stringByAppendingString:sensorType];
    labelData = [labelData stringByAppendingString:separator];
    labelData = [labelData stringByAppendingString:deviceId];
    
    NSString *token = [url substringFromIndex:19];
    [WylioBoard sendOpenMessageWithToken:token label:labelData message:value];

}

-(void)sendHTTPPostMessageLocationToBoard:(double)latitude :(double)longitude :(NSString *)sensorType{
    NSDictionary *value = @{
                            @"latitude" : [NSString stringWithFormat:@"%lf", latitude],
                            @"longitude" : [NSString stringWithFormat:@"%lf", longitude]
                           };
    
    NSString *labelData = keyHeader;
    labelData = [labelData stringByAppendingString:separator];
    labelData = [labelData stringByAppendingString:sensorType];
    labelData = [labelData stringByAppendingString:separator];
    labelData = [labelData stringByAppendingString:deviceId];
    
    NSString *token = [url substringFromIndex:19];
    [WylioBoard sendOpenMessageWithToken:token label:labelData message:value];
    
}

-(void)addSensorThumbs{
    [sensorsThumbs  addObject:@"accelerometer.png"];
    [sensorsThumbs  addObject:@"magnetic.png"];
    [sensorsThumbs  addObject:@"gyroscope.png"];
    [sensorsThumbs  addObject:@"gps.png"];
}

@end


// WILL BE USED FOR XMPP FRAMEWORK COMMUNICATION

// XMPP FRAMEWORK
//NSString *message =[NSString stringWithFormat:@"magnetometer: x : %lf y : %lf z : %lf", x, y, z];
//[self sendMessageToBoard:message];
// XMPP FRAMEWORK
//NSString *message =[NSString stringWithFormat:@"gyro: %lf", radiansToDegrees(rate)];
//[self sendMessageToBoard:message];
// XMPP FRAMEWORK
//NSString *message =[NSString stringWithFormat:@"position:  latitude : %lf longitude : %lf", location.coordinate.latitude, location.coordinate.longitude];
//[self sendMessageToBoard:message];




