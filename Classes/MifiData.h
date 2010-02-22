//
//  MifiData.h
//  Mifi
//
//  Created by Simon Maddox on 24/10/2009.
//  Copyright 2009 Simon Maddox. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MifiData : NSObject {
	NSMutableArray *status;
	NSURLConnection *connection;
	NSMutableData *receivedData;
	long long expectedSize;
	
	NSDictionary *allowedStatus;
	NSString *upTransfer;
	NSString *downTransfer;
}

@property (nonatomic, retain) NSMutableArray *status;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSDictionary *allowedStatus;
@property (nonatomic, retain) NSString *upTransfer;
@property (nonatomic, retain) NSString *downTransfer;

- (void) getStatusFromIP:(NSString *) ipAddress;
+ (MifiData *) sharedData;

@end
