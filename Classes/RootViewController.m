//

//  RootViewController.m
//  Mifi
//
//  Created by Simon Maddox on 24/10/2009.
//  Copyright Simon Maddox 2009. All rights reserved.
//

#import "RootViewController.h"
#import "MifiData.h"

#import "FlurryAPI.h"
#import "AdMobView.h"

#import "InfoViewController.h"

@implementation RootViewController

@synthesize ipAddress, settings;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"]];
	
	ipAddress = [NSString stringWithString:[settings objectForKey:@"ipAddress"]];
	
	self.title = [NSString stringWithString:[settings objectForKey:@"name"]];

	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTable)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    [refreshButton release];
	
	UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:self action:@selector(info:)];
    self.navigationItem.leftBarButtonItem = infoButton;
    [infoButton release];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(connectionStarted:) name:@"Connection Started" object:nil];
	[notificationCenter addObserver:self selector:@selector(downloadSuccessful:) name:@"Download Successful" object:nil];
	[notificationCenter addObserver:self selector:@selector(downloadFailed:) name:@"Download Failed" object:nil];
	
	[[MifiData sharedData] getStatusFromIP:ipAddress];
	
	/*AdMobView *ad = (AdMobView *)[AdMobView requestAdWithDelegate:self]; // start a new ad request
	ad.frame = CGRectMake(0, 432, 320, 48); // set the frame, in this case at the bottom of the screen
	[self.view.window addSubview:ad]; */
	
}

- (void) connectionStarted: (id) sender {
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[mainTable reloadData];
}

- (void) downloadSuccessful: (id) sender {
	[FlurryAPI logEvent:@"MIFI_CONNECTED" withParameters:[NSDictionary dictionaryWithObject:[[MifiData sharedData] status] forKey:@"MIFI"]];
	NSLog(@"%@", [NSDictionary dictionaryWithObject:[[MifiData sharedData] status] forKey:@"MIFI"]);
	
	self.navigationItem.rightBarButtonItem.enabled = YES;
	[mainTable reloadData];
}

- (void) downloadFailed: (id) sender {
	[FlurryAPI logEvent:@"CANNOT_CONNECT"];
	
	self.navigationItem.rightBarButtonItem.enabled = YES;
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Unable to connect to %@", ipAddress] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
	[alert show];
	[mainTable reloadData];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[MifiData sharedData] status] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	[[cell textLabel] setText:[[[[MifiData sharedData] status] objectAtIndex:indexPath.row] objectAtIndex:0]];
	[[cell detailTextLabel] setText:@""];
	
	if ([[[[[MifiData sharedData] status] objectAtIndex:indexPath.row] objectAtIndex:0] isEqual:@"Battery"]){
		UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
		float amount = [[[[[MifiData sharedData] status] objectAtIndex:indexPath.row] objectAtIndex:1] intValue] * 0.25;
		[progress setProgress:amount];
		[progress setFrame:CGRectMake(160, 20, progress.frame.size.width - 30, progress.frame.size.height)];
		[[cell contentView] addSubview:progress];
		[progress release];
	} else if ([[[[[MifiData sharedData] status] objectAtIndex:indexPath.row] objectAtIndex:0] isEqual:@"Signal"]){
		UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
		float amount = [[[[[MifiData sharedData] status] objectAtIndex:indexPath.row] objectAtIndex:1] intValue] * 0.2;
		[progress setProgress:amount];
		[progress setFrame:CGRectMake(160, 20, progress.frame.size.width - 30, progress.frame.size.height)];
		[[cell contentView] addSubview:progress];
		[progress release];
	} else {
		[[cell detailTextLabel] setText:[[[[MifiData sharedData] status] objectAtIndex:indexPath.row] objectAtIndex:1]];
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ([[[MifiData sharedData] status] count] == 0){
		return [NSString stringWithFormat:@"Not connected to MiFi (%@)", ipAddress];
	}
	
	return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if ([[[MifiData sharedData] status] count] > 0){
		return @"Idea by @sammachin\nBuilt by @simonmaddox";
	}
	
	return @"";
}

- (void) reloadTable {
	[[MifiData sharedData] getStatusFromIP:ipAddress];
}

- (void) info: (id) sender {
	InfoViewController *info = [[InfoViewController alloc] init];
	[self presentModalViewController:info animated:YES];
	[info release];
}

- (IBAction) dismissModalViewController {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark AdMobDelegate methods

- (NSString *)publisherId {
	return @"a14b597d4b0d514"; // this should be prefilled; if not, get it from www.admob.com
}

- (void)dealloc {
    [super dealloc];
	[ipAddress release]; ipAddress = nil;
	[settings release]; settings = nil;
}


@end

