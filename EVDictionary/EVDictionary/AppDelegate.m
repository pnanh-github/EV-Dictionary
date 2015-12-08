//
//  AppDelegate.m
//  EVDictionary
//
//  Created by ADMIN on 11/5/15.
//  Copyright © 2015 Nhat Tung Media. All rights reserved.
//

#import "AppDelegate.h"
#import "MSSlidingPanelController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    if(self.wordList ==nil){
        
        self.wordList = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wordlist" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
    }
    
    
    
    return YES;
}

-(void) OpenAbout{
    [self openControllerWithIndentifier:@"about"];
}
-(void) OpenMain{
    [self openControllerWithIndentifier:@"main"];
}

- (void)openControllerWithIndentifier:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
    
    MSSlidingPanelController *rootController = (MSSlidingPanelController *)self.window.rootViewController;
    
    [rootController setCenterViewController:controller];
    [rootController closePanel];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
