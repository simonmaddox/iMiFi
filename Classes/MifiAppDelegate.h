//
//  MifiAppDelegate.h
//  Mifi
//
//  Created by Simon Maddox on 24/10/2009.
//  Copyright Simon Maddox 2009. All rights reserved.
//

@interface MifiAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

