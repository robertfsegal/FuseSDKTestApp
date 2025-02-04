//
//  AppDelegate.m
//  FuseSDKTestApp
//
//  Created by Robert Segal on 2015-08-08.
//  Copyright (c) 2015 Get Set Games Inc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (copy, nonatomic) NSString *zone;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FuseSDK startSession:@"" delegate:self withOptions:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onZoneSelected:) name:@"FuseZoneSelected" object:nil];
    
    return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

-(void)sessionLoginError:(NSError *)_error
{
    NSDictionary *d = @{@"message" : _error};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FuseMessageLog" object:nil userInfo:d];
}

-(void)sessionStartReceived
{
    NSDictionary *d = @{@"message" : NSStringFromSelector(_cmd)};
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"FuseMessageLog" object:nil userInfo:d];
 
    for (int i = 1 ; i <= 10; i++)
    {
        [FuseSDK registerCustomEvent:i withInt:0];
    }
    
    for (int i = 11 ; i <= 20; i++)
    {
        [FuseSDK registerCustomEvent:i withString:@""];
    }
}

-(void)adAvailabilityResponse:(NSNumber *)_available Error:(NSError *)_error
{
    BOOL isAvailable = [_available boolValue];
    
    int error = (int) [_error code];
 
    //NSLog(@"isAvailable -> %@, error -> %@", _available, _error);
    
    NSDictionary *d = @{@"message" : [NSString stringWithFormat:@"isAvailable -> %@, error -> %@", _available, _error]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FuseMessageLog" object:nil userInfo:d];
    
    
    if (error != FUSE_ERROR_NO_ERROR)
    {
        
    }
    else
    {
        if (isAvailable)
        {
            
            
            [FuseSDK showAdForZoneID:self.zone options:@{kFuseRewardedAdOptionKey_ShowPreRoll:@NO}];
        }
    }
}

-(void)adWillClose
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"FuseMessageLog" object:nil userInfo:@{@"message" : NSStringFromSelector(_cmd)}];
}

-(void)adFailedToDisplay
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FuseMessageLog"
                                                        object:nil
                                                      userInfo:@{@"message" : NSStringFromSelector(_cmd)}];
}

-(void)onZoneSelected:(NSNotification *)n
{
    self.zone = n.userInfo[@"zone"];
}

@end
