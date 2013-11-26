//
//  AppDelegate.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/8/28.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "AppDelegate.h"
#import "VCMap.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlus/GooglePlus.h>
#import <FacebookSDK/FacebookSDK.h>
#import "VariableStore.h"
#import "Util.h"
@implementation AppDelegate
@synthesize fb_session = _fb_session;
@synthesize window = _window;
@synthesize json_goods = _json_goods;
static NSString * const kClientId = @"235322884744.apps.googleusercontent.com";

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSString *strURL =[ NSString stringWithFormat:@"%@",url];
    if([strURL hasPrefix:@"fb"]){
        return [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication
                            withSession:self.fb_session];
    }else{
        return [GPPURLHandler handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [GMSServices provideAPIKey:@"AIzaSyBtb7I2tk-7hP6KWKU4wC4tNoFzM4pCcI0"];
    _vs =[VariableStore sharedInstance];
    _vs.keyGoogleMap=@"AIzaSyBtb7I2tk-7hP6KWKU4wC4tNoFzM4pCcI0";
    _vs.domain=@"36.224.8.126";
    _vs.listWidth=@"320.00";
    _vs.listHeight=@"160.00";
    _vs.appLaunchDate=[[NSDate alloc] init];
    CLLocationManager * manager=[[CLLocationManager alloc]init];
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    manager.distanceFilter = kCLDistanceFilterNone;
    [manager startUpdatingLocation];
    _vs.myLocation=manager.location;
    NSString *jsonCate= @"{\"cate\":[\
        {\"name\":\"小吃\",\"keyword\":\"小吃\",\"type\":\"\",\"pic\":\"cate-search.png\",\"bg\":\"\",\"color\":\"#b7dd6c\"},\
        \
        {\"name\":\"景點\",\"keyword\":\"旅遊景點\",\"type\":\"\",\"pic\":\"cate-attraction.png\",\"bg\":\"tourist-attraction-gray-640x320\",\"color\":\"#abd156\"},\
        \
        {\"name\":\"餐廳\",\"keyword\":\"餐廳\",\"type\":\"\",\"pic\":\"cate-rest.png\",\"bg\":\"restaurants-gray-640x320.png\",\"color\":\"#abd156\"},\
        \
        {\"name\":\"咖啡\",\"keyword\":\"咖啡+茶+簡餐\",\"type\":\"\",\"pic\":\"cate-cafe.png\",\"bg\":\"coffee-gray-640x320.png\",\"color\":\"#b4da5f\"},\
        \
        {\"name\":\"ATM\",\"keyword\":\"提款機|郵局\",\"type\":\"\",\"pic\":\"cate-atm.png\",\"bg\":\"atm-gray-640x320.png\",\"color\":\"#bcda78\"},\
        \
        {\"name\":\"旅館\",\"keyword\":\"\",\"type\":\"hotel\",\"pic\":\"cate-hotel.png\",\"bg\":\"hotel-gray-640x320.png\",\"color\":\"#b9dd57\"}]}";
    
    
    NSData * dataCate=[jsonCate dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonParsingError = nil;
    _vs.dicPlaceCate =(NSDictionary *) [NSJSONSerialization JSONObjectWithData:dataCate options:0 error:&jsonParsingError];
    _vs.screenH=self.window.frame.size.height;
    _vs.screenW=self.window.frame.size.width;
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:self.fb_session];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(UIApplication *)theApplication {

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    _vs.appExitDate=[[NSDate alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *url=[NSString stringWithFormat:@"http://%@/controller/mobile/report.aspx?action=add-app-use-long&creator_ip=%@&launch_date=%@&exit_date=%@", _vs.domain,[Util getIPAddress],[format stringFromDate:_vs.appLaunchDate],[format stringFromDate:_vs.appExitDate]];
    NSLog(url);
    [Util stringWithUrl:url];
    [self.fb_session close];

}
@end
