//
//  SDCConfigurationVC.m
//  Smart Diabetes Control
//
//  Created by Mederi on 02/05/13.
//
//

#import "SDCSettingsVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SDCConstants.h"

@interface SDCSettingsVC ()




@end



@implementation SDCSettingsVC

@synthesize userProfileImage,settingsBirthDateLabel,settingsNameLabel,settingsLoginButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([deviceString isEqualToString:@"iPhone5"]) {
        self=[super initWithNibName:@"SDCSettingsVC_iPhone5" bundle:nil];
    }else{
        
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        self.title = NSLocalizedString(@"Configuración", @"Configuración");
       [n setTitle:@"Configuración"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [bolusKindField setDelegate:self];
    [basalKindField setDelegate:self];
       

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }
}
- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 self.settingsNameLabel.text = user.name;
                 self.userProfileImage.profileID = user.id;
                 self.settingsBirthDateLabel.text=user.birthday;
             }
         }];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults] setObject:[bolusKindField text] forKey:@"bolusKind"];
    [[NSUserDefaults standardUserDefaults] setObject:[basalKindField text] forKey:@"basalKind"];
    [[NSUserDefaults standardUserDefaults] setObject:[settingsNameLabel text] forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:[settingsBirthDateLabel text] forKey:@"birthDate"];


    
}
- (void)viewDidUnload {
    self.settingsBirthDateLabel=nil;
    self.settingsNameLabel = nil;
    self.loggedInUser = nil;
    self.userProfileImage = nil;
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)settingsLoginAction:(id)sender {
    
        [FBSession.activeSession closeAndClearTokenInformation];
    
}
// Quito teclado si toco el fondo
- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

@end
