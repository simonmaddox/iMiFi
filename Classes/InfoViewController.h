//
//  InfoViewController.h
//  Mifi
//
//  Created by Simon Maddox on 04/12/2009.
//  Copyright 2009 Sensible Duck Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *mainTable;
}

@property (nonatomic, retain) IBOutlet UITableView *mainTable;

@end
