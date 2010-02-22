//
//  MifiData.m
//  Mifi
//
//  Created by Simon Maddox on 24/10/2009.
//  Copyright 2009 Simon Maddox. All rights reserved.
//

#import "MifiData.h"

@implementation MifiData

@synthesize status, receivedData, connection, allowedStatus, upTransfer, downTransfer;

static MifiData *sharedData;

- (void) dealloc {
	[super dealloc];
	[status release]; status = nil;
	[receivedData release]; receivedData = nil;
	[connection release]; connection = nil;
	[allowedStatus release]; allowedStatus = nil;
}

+ (MifiData *) sharedData
{	
	
	if (sharedData) {
		return sharedData;
	}
	
	@synchronized(self)
	{
		if (!sharedData)
			sharedData = [[MifiData alloc] init];
		
		return sharedData;
	}
	
	return sharedData;
}

- (void) getStatusFromIP:(NSString *) ipAddress {
	
	status = [[NSMutableArray alloc] init];
	allowedStatus = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MifiStatus" ofType:@"plist"]];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/getStatus.cgi?dataType=TEXT", ipAddress]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
																cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
	
    receivedData = [[NSMutableData alloc] initWithLength:0];
	
	connection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Connection Started"
														object:nil
													  userInfo:nil];
	
	[request release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	expectedSize = [response expectedContentLength];
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Download Failed"
														object:nil
													  userInfo:nil];
	connection = nil;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection 
				  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return nil;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)theConnection {
	connection = nil;
		
	NSString *data = [NSString stringWithUTF8String:[receivedData bytes]];
	
	NSArray *pieces = [data componentsSeparatedByString:@""];
	
	if (status == nil){
		status = [NSMutableArray array];
	}
	
	for (id string in pieces){
		NSArray *items = [string componentsSeparatedByString:@"="];
		NSMutableArray *mutableItems = [NSMutableArray arrayWithArray:items];
		
		NSString *mifiString = [NSString stringWithString:[items objectAtIndex:0]];
		
		
		if ([allowedStatus objectForKey:mifiString] != nil){
			[mutableItems removeObjectAtIndex:0];
			[mutableItems insertObject:[allowedStatus objectForKey:mifiString] atIndex:0];
			
			if ([mifiString isEqual:@"WwConnStatus"]){
				NSInteger connectionStatus = [[items objectAtIndex:1] intValue];
				
				NSString *string;
				
				[mutableItems removeObjectAtIndex:1];
				
				switch (connectionStatus){
					case 0:
						string = @"Searching";
						break;
					case 1:
						string = @"Connecting";
						break;
					case 2:
						string = @"Connected";
						break;
					case 3:
						string = @"Disconnecting";
						break;
					case 4:
						string = @"Disconnected";
						break;
					case 5:
						string = @"Not Activated";
						break;
					case 6:
						string = @"Modem Failure";
						break;
					case 7:
						string = @"No SIM";
						break;
					case 8:
						string = @"SIM Locked";
						break;
					case 9:
						string = @"SIM Failure";
						break;
					case 10:
						string = @"Network Locked";
						break;
					case 11:
						string = @"Dormant";
						break;
					default:
						string = @"Unknown";
				}
				
				[mutableItems insertObject:string atIndex:1];
			}
			
			if ([[items objectAtIndex:0] isEqual:@"WwSessionTxMb"] || [[items objectAtIndex:0] isEqual:@"WwSessionRxMb"]){
				NSString *MB = [NSString stringWithFormat:@"%@ MB",[items objectAtIndex:1]];
				[mutableItems removeObjectAtIndex:1];
				[mutableItems insertObject:MB atIndex:1];
				
				if ([[items objectAtIndex:0] isEqual:@"WwSessionTxMb"]){
					upTransfer = [NSString stringWithString:[items objectAtIndex:1]];
				} else if ([[items objectAtIndex:0] isEqual:@"WwSessionRxMb"]){
					downTransfer = [NSString stringWithString:[items objectAtIndex:1]];
				}
				
			} else {
				[status addObject:mutableItems];
			}
		}
	}
	
		upTransfer = @"0.00";
	
		downTransfer = @"0.00";
	
	[status addObject:[NSArray arrayWithObjects:@"Data Up/Down",[NSString stringWithFormat:@"%.2fMB / %.2fMB", [upTransfer floatValue], [downTransfer floatValue]], nil]];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"Download Successful"
														object:nil
													  userInfo:nil];
}


@end
