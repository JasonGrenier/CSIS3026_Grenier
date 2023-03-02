//
//  ViewControllerBlowTab.h
//  Cupload
//
//  Created by Jason Grenier on 2/26/23.
//
#import <UIKit/UIKit.h>
#import "BACtrack.h"

@interface ViewControllerBlowTab: UIViewController
{
    
    IBOutlet UIButton* connect;
    IBOutlet UIButton* disconnect;
    IBOutlet UIButton* refresh;
    IBOutlet UIButton* close;
    IBOutlet UIButton* battery;
    IBOutlet UIButton* test;
    IBOutlet UILabel* reading;
    IBOutlet UILabel* results;
    BOOL connected;
    int batteryLevel;
    NSTimer* stopTimer;
    
}
- (IBAction)testTapped:(UIButton *)sender;
- (IBAction)connectTapped:(UIButton *)sender ;
-(IBAction)disconnectTapped:(id)sender;
-(IBAction)batteryTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@end
