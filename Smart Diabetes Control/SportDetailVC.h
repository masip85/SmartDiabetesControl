//
//  DetailViewController.h
//  Homepwner
//
//  Created by ladmin on 22/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCSport.h"
@interface SportDetailVC : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIPopoverControllerDelegate,UIActionSheetDelegate> {
    

    __weak IBOutlet UISlider *sportDetailIntensitySlider;
    __weak IBOutlet UITextField *sportDetailNameField;
    __weak IBOutlet UILabel *sportDetailDateLabel;
    __weak IBOutlet UILabel *sportDetailIntensityLabel;

    __weak IBOutlet UILabel *sportDetailNameLabel;
    __weak IBOutlet UIToolbar *sportDetailTakePicture;
    __weak IBOutlet UIImageView *sportDetailImageView;
    UIPopoverController *sportDetailImagePickerPopover;
    
}
@property (nonatomic,strong) SDCSport *sport;
@property (nonatomic,copy) void(^dismissBlock) (void);
- (IBAction)sliderValueChanged:(id)sender;

-(id) initForNewSport:(BOOL)isNew;
- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;


@end
