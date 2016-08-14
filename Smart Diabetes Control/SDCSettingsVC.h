//
//  SDCConfigurationVC.h
//  Smart Diabetes Control
//
//  Created by Mederi on 02/05/13.
//
//

#import <UIKit/UIKit.h>
#import "SDCAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
//En appdelegate se importa SDKFacebook. Si lo importase aqui también daria error por invocarse dos veces

@interface SDCSettingsVC : UIViewController<UITextFieldDelegate>{
    
    __weak IBOutlet UITextField *bolusKindField;
    __weak IBOutlet UITextField *basalKindField;
}

- (IBAction)settingsLoginAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *settingsLoginButton;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *settingsBirthDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *settingsNameLabel;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
- (IBAction)backgroundTapped:(id)sender;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;



@end
