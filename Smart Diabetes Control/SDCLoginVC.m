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

#import "SDCLoginVC.h"
#import "SDCAppDelegate.h"
#import "SDCGlucoseRegisterVC.h"
#import "SDCSetInformationMenuVC.h"
#import "SDCMyProblemsVC.h"
#import "SDCSocialDiabetesVC.h"
#import "SDCSettingsVC.h"
#import "SDCConstants.h"


@interface SDCLoginVC ()

@property (strong, nonatomic) IBOutlet UIButton *buttonLoginFacebook;

- (IBAction)buttonClickHandler:(id)sender;
- (void)updateView;

@end

@implementation SDCLoginVC

- (void)viewDidLoad {    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
   }

// FBSample logic
// main helper method to update the UI to reflect the current state of the session.
- (void)updateView {
    
   }

- (void)loginFailed
{

    //Vacio de momento
    NSLog(@"Login FB FAILED");
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([deviceString isEqualToString:@"iPhone5"]) {
        
        self=[super initWithNibName:@"SDCLoginVC_iPhone5" bundle:nil];
    }else{
        
        self = [super initWithNibName:@"SDCLoginVC" bundle:nibBundleOrNil];
    }    if (self) {
        // Custom initialization
       
    }
    return self;
}
// FBSample logic
// handler for button click, logs sessions in or out
- (IBAction)buttonClickHandler:(id)sender {
    
    SDCAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
  }

#pragma mark Template generated code

- (void)viewDidUnload
{
    self.buttonLoginFacebook = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark -

@end
