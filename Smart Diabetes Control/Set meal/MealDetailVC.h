//
//  DetailViewController.h
//  Homepwner
//
//  Created by ladmin on 22/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCMeal.h"
@interface MealDetailVC : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIPopoverControllerDelegate,UIActionSheetDelegate> {
    
    __weak IBOutlet UIButton *mealDetailExtraDetailsButton;
    __weak IBOutlet UILabel *mealDetailActionKindLabel;
    __weak IBOutlet UISegmentedControl *mealDetailActionKindSegmentedControl;
    __weak IBOutlet UISegmentedControl *mealDetailUnitSegmentedControl;
    __weak IBOutlet UITextField *mealDetailUnitValueField;
    __weak IBOutlet UITextField *mealDetailCarboRationField;
    __weak IBOutlet UITextField *mealDetailNameField;
    __weak IBOutlet UILabel *mealDetailDateLabel;  
    __weak IBOutlet UILabel *mealDetailCarboLabel;
    __weak IBOutlet UILabel *mealDetailNameLabel;
    __weak IBOutlet UIToolbar *mealDetailTakePicture;
    __weak IBOutlet UIImageView *mealDetailImageView;
    UIPopoverController *mealDetailImagePickerPopover;
    
}
@property (nonatomic,strong) SDCMeal *meal;
@property (nonatomic,copy) void(^dismissBlock) (void);

-(id) initForNewMeal:(BOOL)isNew;
- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)mealDetailExtraDetailsButton:(id)sender;

-(NSInteger *)getMealIndex:(NSString *)s;

@end
