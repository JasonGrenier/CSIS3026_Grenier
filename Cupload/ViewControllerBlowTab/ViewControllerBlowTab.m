//
//  ViewControllerBlowTab.m
//  Cupload
//
//  Created by Jason Grenier on 2/26/23.
//

#import <Foundation/Foundation.h>
#import "ViewControllerBlowTab.h"
#import "BACtrack.h"


@interface ViewControllerBlowTab () <BacTrackAPIDelegate>
{
    BacTrackAPI * BacTrack;
}
@end

@implementation ViewControllerBlowTab

- (void)viewDidLoad
{
    [super viewDidLoad];
    results.hidden = YES;
    reading.hidden = YES;
    test.hidden = YES;
    // API Key from BACtrack developer's website
    BacTrack = [[BacTrackAPI alloc] initWithDelegate:self AndAPIKey:@"1cf11bed18844a77916771add6c59e"];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [BacTrack startScan];
    stopTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:BacTrack selector:@selector(stopScan) userInfo:nil repeats:NO];
}

- (void)resetLabels
{
    reading.text = @"";
    results.text = @"";
    reading.hidden = YES;
    results.hidden = YES;
}

//API Key valid, you can now connect to a breathlyzer
-(void)BacTrackAPIKeyAuthorized
{
    
}

//API Key declined for some reason
-(void)BacTrackAPIKeyDeclined:(NSString *)errorMessage
{
    reading.text = @"API declined. Please contact Cupload developers.";
    reading.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)batteryTapped
{
    [BacTrack getBreathalyzerBatteryLevel];
    NSLog(@"Geting battery voltage");
}

-(void)BacTrackSerial:(NSString *)serial_hex
{
    //[[[UIAlertView alloc] initWithTitle:@"Serial Number"
                               // message:serial_hex
                               //delegate:nil
                      //cancelButtonTitle:@"OK"
                      //otherButtonTitles:nil] show];

}

-(void)BacTrackUseCount:(NSNumber*)number
{
    NSLog(@"Use count:, %d", number.intValue);
    // uncomment below lines to show use count on countdown
//    [[[UIAlertView alloc] initWithTitle:@"Use Count"
//                                message:[NSString stringWithFormat:@"%d",number.intValue]
//                               delegate:nil
//                      cancelButtonTitle:@"OK"
//                      otherButtonTitles:nil] show];
}

- (IBAction)connectTapped:(UIButton *)sender {
    printf("connect button was tapped");
    [BacTrack connectToNearestBreathalyzer];
}

- (IBAction)testTapped:(id)sender {
    NSLog(@"Take Test Tapped");
    [BacTrack startCountdown];
    results.hidden = NO;
    reading.hidden = NO;
}

-(void)BacTrackError:(NSError*)error
{
    if(error)
    {
        [self resetLabels];

        NSString* errorDescription = [error localizedDescription];
    
        /*UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                     message:errorDescription
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
         */
        // [av show];
    }
}

// Initialized countdown from number
-(void)BacTrackCountdown:(NSNumber *)seconds executionFailure:(BOOL)failure
{
    if (failure)
    {
        [self BacTrackError:nil];
        return;
    }
    else
    {
        reading.text = @"Warming up";
    }
    
    results.text = [NSString stringWithFormat: @"%d", seconds.intValue];
}

// Tell the user to start
- (void)BacTrackStart
{
    reading.text = @"Blow now!";
    results.text = @"";
}

// Tell the user to blow
- (void)BacTrackBlow:(NSNumber*)breathFractionRemaining
{
    reading.text = @"Keep blowing!";
    results.text = [NSString stringWithFormat:@"%d%%",
                         100 - (int)([breathFractionRemaining floatValue]*100.0)];
}

- (void)BacTrackAnalyzing
{
    reading.text = @"Analyzing results";
    results.text = @"";
}

-(void)BacTrackResults:(CGFloat)bac
{
    reading.text = @"Your Result";
    results.text = [NSString stringWithFormat: @"%.2f", bac];
}

-(void)refreshButtonState
{
    if (connected)
    {
        connect.enabled = NO;
        connect.alpha = .5;
        test.hidden = NO;
        // battery.hidden = NO;
    }
    else
    {
        connect.enabled = YES;
        connect.alpha = 1.0;
        test.hidden = YES;
        // battery.hidden = YES;
    }

}
-(void)BacTrackConnected:(BACtrackDeviceType)device
{
    connected = YES;
    batteryLevel = -1;
    [self refreshButtonState];
    NSLog(@"Connected to BACtrack device");
}

-(void)BacTrackDisconnected
{
    connected = NO;
    batteryLevel = -1;
    
    [self resetLabels];
    [self refreshButtonState];
    /*UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Disconnected"
                                                 message:@"You are now disconnected from your BACtrack device"
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
     */
    // [av show];
}

-(void)BacTrackConnectTimeout
{
    //Callback for device connection timeout; can use method to reset UI etc
}

-(NSTimeInterval)BacTrackGetTimeout
{
    //Optional, sets a callback timeout timer (in seconds)
    return 10;
}

-(void)BacTrackFoundBreathalyzer:(Breathalyzer*)breathalyzer
{
    //Can use to store/record device id, breathalyzer type, etc.
    //Here I've just listed the breathalyzer type
    NSLog(@"Found breathalyzer: %@", breathalyzer.peripheral.name.description);
    
    // NSString *breathalyzerUUID = [breathalyzer.peripheral.identifier UUIDString];
}

- (void) BacTrackBatteryVoltage:(NSNumber *)number
{
    NSLog(@"Battery Voltage: %f", [number floatValue]);
    results.hidden = NO;
    results.text = [NSString stringWithFormat:@"%.02fv", [number floatValue]];
}

- (void) BacTrackBatteryLevel:(NSNumber *)number
{
    NSLog(@"Battery Level: %d", [number intValue]);
    reading.hidden = NO;
    reading.text = [NSString stringWithFormat:@"Level: %d", [number intValue]];
    batteryLevel = [number intValue];
}

-(void)dealloc
{
    if (stopTimer)
    {
        [stopTimer invalidate];
        stopTimer = nil;
    }
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}


@end
