//
//  RootViewController.h
//  Mifi
//
//  Created by Simon Maddox on 24/10/2009.
//  Copyright Simon Maddox 2009. All rights reserved.
//

#import "AdMobDelegateProtocol.h"

#define AD_REFRESH_PERIOD 30.0

@interface RootViewController : UITableViewController <AdMobDelegate>  {
	IBOutlet UITableView *mainTable;
	NSMutableDictionary *settings;
	NSString *ipAddress;
}

@property (nonatomic, retain) NSString *ipAddress;
@property (nonatomic, retain) NSMutableDictionary *settings;

- (IBAction) reloadTable;
- (IBAction) dismissModalViewController;

@end
