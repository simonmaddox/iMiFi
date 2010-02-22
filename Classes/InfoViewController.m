//
//  InfoViewController.m
//  Mifi
//
//  Created by Simon Maddox on 04/12/2009.
//  Copyright 2009 Sensible Duck Ltd. All rights reserved.
//

#import "InfoViewController.h"


@implementation InfoViewController

@synthesize mainTable;

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction) dismissModalViewController {
	[self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return 90;
			break;
		case 1:
			return 180;
			break;
		case 2:
			return 70;
			break;
		case 3:
			return 290;
		default:
			return 40;
			break;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	[[cell textLabel] setNumberOfLines:0];
	[[cell textLabel] setFont:[UIFont systemFontOfSize:14]];
	
	switch (indexPath.section) {
		case 0:
			[[cell textLabel] setText:@"To use iMiFI you need to be connected to your MiFi via WiFi, then just open the app and it will display key information about your connection."];
			break;
		case 1:
			[[cell textLabel] setText:@"If you are having problems check you can get to your MiFi using http://www.mifi in the browser\niMiFi has been tested with Novatel Wireless MiFi devices model numbers 2352 & 2372 with SIMs from many operators.\nIt does not work with Huawei MiFi Devices.\nLet us know about other devices at iMiFi@mogotion.com"];
			break;
		case 2:
			[[cell textLabel] setText:@"iMiFi was created overnight at BarCampLondon7 by Simon Maddox based on an idea by Sam Machin"];
			break;
		case 3:
			[[cell textLabel] setText:@"Simon Maddox\n@simonmaddox\nhttp://simonmaddox.com\n\nSam Machin\n@sammachin\nhttp://mogotion.com\n\nWithout the following people's help and hard work, this app would not have been possible:\n- Kieran Gutteridge\n- Ewan MacLeod\n- Kevin Thornton\n- Phil & Cally from 3MobileBuzz"];
			break;
	}
		
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return @"How To";
		case 1:
			return @"Troubleshooting";
		case 2:
			return @"About iMifi";
			break;
		case 3:
			return @"Credits";
			break;
		default:
			return @"";
			break;
	}
}

- (void)dealloc {
	[mainTable release];
    [super dealloc];
}


@end
