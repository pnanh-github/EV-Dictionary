//
//  AppDelegate.h
//  EVDictionary
//
//  Created by ADMIN on 11/5/15.
//  Copyright © 2015 Nhat Tung Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *wordList;
-(void) OpenAbout;
-(void) OpenMain;
@end

