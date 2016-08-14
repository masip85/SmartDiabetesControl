/*
 * Copyright 2010-present Facebook.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SDCAppDelegate.h"
#import "SDCGlucoseRegisterVC.h"
#import "SDCSetInformationMenuVC.h"
#import "SDCMyProblemsVC.h"
#import "SDCSocialDiabetesVC.h"
#import "SDCSettingsVC.h"
#import "SDCLoginVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SDCMealStore.h"
#import "SDCMeasureStore.h"
#import "SDCSportStore.h"
#import "MCLViewController.h"
#import "MCLTrackStore.h"
#import "SDCEventsVC.h"
#import "MCLVisitStore.h"
#import "SDCConstants.h"

@interface SDCAppDelegate()

@property (strong, nonatomic) UINavigationController* navController;


@end


@implementation SDCAppDelegate

@synthesize navController = _navController;
@synthesize mainTabBarController;

@synthesize window = _window;
@synthesize viewController = _viewController;

@synthesize glucoseRegisterNC;




- (void)applicationWillTerminate:(UIApplication *)application {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"UIApplicationWillTerminate" object:self];
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UIApplicationWillResignActive" object:self];
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UIapplicationWillEnterForeground" object:self];
    
}

-(void)whichDeviceAmI{
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        deviceString=@"iPhone5";
    }else{
        deviceString=@"iPhone4s";
    }
}

#pragma mark Template generated code

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setFrame:[[UIScreen mainScreen] bounds]];
    
    [self whichDeviceAmI];
    
    //Then, make menuofapplicattion the root view controller for this navigation controller. In the application:didFinishLaunchingWithOptions: method, change this code:
    [self createMenu];

    [FBProfilePictureView class]; // para que FBProfilePictureView de configuraciónVC no de error
    
    
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
    } else {
        // No, display the login page.
        [self showLoginView];
    }
    // Override point for customization after application launch.
        return YES;
}
- (void)showLoginView
{
        
    UIViewController *topViewController = [self.navController topViewController];    
    UIViewController *modalViewController = [topViewController presentedViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![modalViewController isKindOfClass:[SDCLoginVC class]]) {
        SDCLoginVC* loginViewController = [[SDCLoginVC alloc]
                                                      initWithNibName:@"SDCLoginVC"
                                                      bundle:nil];
        [topViewController presentViewController:loginViewController animated:NO completion:nil];
    } else {
        SDCLoginVC* loginViewController =
        (SDCLoginVC*)modalViewController;
        [loginViewController loginFailed];
    }
    
}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController =
            [self.navController topViewController];
            if ([[topViewController presentedViewController]
                 isKindOfClass:[SDCLoginVC class]]) {
                [topViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error FB"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // Cuando se cierra el navegador donde inicio sesión,vuelvo aquí.
    return [FBSession.activeSession handleOpenURL:url];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {

}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    
    BOOL success = [[SDCMealStore sharedStore] saveChanges];
    BOOL success2 = [[SDCSportStore sharedStore ] saveChanges];
    BOOL success3 = [[SDCMeasureStore sharedStore] saveChanges];
    BOOL success4 =[[MCLTrackStore sharedStore]saveChanges]; // Guardo todas las rutas que tengo
    BOOL success5 =[[MCLVisitStore sharedStore]saveChanges]; // Guardo todas las rutas que tengo
    if (success) {
        NSLog(@"Alimentos guardados"); }
    else {
        NSLog(@"No se pudo guardar alimentos"); }
    if (success2) {
        NSLog(@"Deportes guardados"); }
    else {
        NSLog(@"No se pudo guardar deportes"); }
    if (success3) {
        NSLog(@"Medidas guardados"); }
    else {
        NSLog(@"No se pudo guardar medidas"); }
    if (success4) {
        NSLog(@"Rutas guardados"); }
    else {
        NSLog(@"No se pudo guardar rutas"); }
    if (success5) {
        NSLog(@"Visitas guardadas"); }
    else {
        NSLog(@"No se pudo guardar visitas"); }
}

-(void)createMenu{
    
    SDCGlucoseRegisterVC *glucoseRegisterVC=[[SDCGlucoseRegisterVC alloc]init];
    glucoseRegisterNC = [[UINavigationController alloc]
                                                 initWithRootViewController:glucoseRegisterVC];
    
    SDCSetInformationMenuVC *setInformationMenuVC=[[SDCSetInformationMenuVC alloc]init];
    UINavigationController *setInformationMenuNC = [[UINavigationController alloc]
                                                    initWithRootViewController:setInformationMenuVC];
    
//    SDCMyProblemsVC *myProblemsVC=[[SDCMyProblemsVC alloc]init];
//    UINavigationController *myProblemsNC = [[UINavigationController alloc]
//                                            initWithRootViewController:myProblemsVC];
    
    MCLViewController *map = [[MCLViewController alloc] initWithNibName:@"MCLViewController" bundle:nil];
    UINavigationController *myProblemsNC = [[UINavigationController alloc]
                                              initWithRootViewController:map];
    
    SDCEventsVC *socialDiabetesVC=[[SDCEventsVC alloc]init];
    UINavigationController *socialDiabetesNC = [[UINavigationController alloc]
                                                   initWithRootViewController:socialDiabetesVC];
    
    
//    SDCSocialDiabetesVC *socialDiabetesVC=[[SDCSocialDiabetesVC alloc]init];
//    UINavigationController *socialDiabetesNC = [[UINavigationController alloc]
//                                                initWithRootViewController:socialDiabetesVC];
    
    SDCSettingsVC *configurationVC=[[SDCSettingsVC alloc]init];
    UINavigationController *configurationNC = [[UINavigationController alloc]
                                               initWithRootViewController:configurationVC];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:glucoseRegisterNC,setInformationMenuNC,myProblemsNC,socialDiabetesNC,configurationNC,nil];
    mainTabBarController = [[UITabBarController alloc] init];
    [mainTabBarController setViewControllers:viewControllers];
    self.navController = [[UINavigationController alloc]
                          initWithRootViewController:self.mainTabBarController];
    [self.navController setNavigationBarHidden:YES];

    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
}



@end
