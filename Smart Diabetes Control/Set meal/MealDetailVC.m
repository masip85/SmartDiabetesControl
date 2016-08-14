//
//  DetailViewController.m
//  Homepwner
//
//  Created by ladmin on 22/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MealDetailVC.h"
#import "SDCImageStore.h"
#import "SDCMealStore.h"
#import "SDCMealExtraDetailsVC.h"
#import "SDCAppDelegate.h"
#import "SDCConstants.h"

@implementation MealDetailVC

@synthesize meal;
@synthesize dismissBlock;
id pickImageSender;

-(void) cancel:(id)sender
{
    //If the user cancelled,then remove the meal form the store
    [[SDCMealStore sharedStore] removeMeal:meal];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)save:(id)sender
{
    //Cuando presento una vista modal,es quien la presenta,quien la ha de despedir,es decir
    // que itemviewcontroller ha de hacer el dismiss. PresentingViewController apunta al uiViewController
    //que la presenta
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
    [self.navigationController popViewControllerAnimated:YES];
    [self saveFields];

}

-(void)saveFields{
    
    //Save changes to item
    [meal setMealName:[mealDetailNameField text]];
    [meal setRationValue:[[NSNumber alloc]initWithInt:[[mealDetailCarboRationField text]intValue]]];
    [meal setUnitValue:[[NSNumber alloc]initWithInt:[[mealDetailUnitValueField text]intValue]]];
    
    if (mealDetailActionKindSegmentedControl.selectedSegmentIndex>=0 )
        [meal setActionKind:[mealDetailActionKindSegmentedControl titleForSegmentAtIndex:[mealDetailActionKindSegmentedControl selectedSegmentIndex]]];
    if ( mealDetailUnitSegmentedControl.selectedSegmentIndex>=0)  // Solo grabo segmentos si hay selección
        [meal setUnitKind:[mealDetailUnitSegmentedControl titleForSegmentAtIndex:[mealDetailUnitSegmentedControl selectedSegmentIndex]]];
          
}



//Making ilegal designated initializer

-(id) initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Must use initForNewItem" userInfo:nil];
    return nil;
}

-(id)initForNewMeal:(BOOL)isNew
{
    
    if ([deviceString isEqualToString:@"iPhone5"]) {
        self=[super initWithNibName:@"MealDetailVC_iPhone5" bundle:nil];
    }else{
        self=[super initWithNibName:@"MealDetailVC" bundle:nil];
    }
    if(self){
                if(isNew){
            
            UIBarButtonItem *doneItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
            
            
        }else{
            // Le pongo el boton done en cualquier caso ya que siempre es editable
            UIBarButtonItem *doneItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
        }
        
    }
    
    return self;           

}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        return YES;
    }else{
        return (io==UIInterfaceOrientationPortrait);
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)setMeal:(SDCMeal *)i
{
    // AQUI la tabla me pasa que alimento muestra la vista detallada. además le pone título
    meal=i;
    
    // Titulo de arriba - bar
    if ([[meal mealName]isEqual:@""]) {
        [[self navigationItem] setTitle:@"Nuevo alimento"];
    }else{
        [[self navigationItem] setTitle:[meal mealName]];
    }
    
}



-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Campos de edición si no existen vacios y si existen, los cargo
    [mealDetailNameField setText:[meal mealName]];
    if ([[meal mealName]isEqual:@""]) {
        [mealDetailCarboRationField setText:@""];
        [mealDetailUnitValueField setText:@""];
        [mealDetailNameField setText:@""];
        [mealDetailActionKindSegmentedControl setSelected:NO];
        [mealDetailUnitSegmentedControl setSelected:NO];
    }else{
    [mealDetailUnitValueField setText:[NSString stringWithFormat:@"%@",[meal unitValue]]];
    [mealDetailCarboRationField setText:[NSString stringWithFormat:@"%@",[meal rationValue]]];
    [mealDetailNameField setText:[NSString stringWithFormat:@"%@",[meal mealName]]];
    
        if ([[meal unitKind] isEqualToString:@"gr."]) {
            [mealDetailUnitSegmentedControl setSelectedSegmentIndex:0];
        }else if([[meal unitKind] isEqualToString:@"ml."]) {
            [mealDetailUnitSegmentedControl setSelectedSegmentIndex:1];
        }else{
            [mealDetailUnitSegmentedControl setSelectedSegmentIndex:-1];
        }
        
        if ([[meal actionKind] isEqualToString:@"Lenta"]) {
            [mealDetailActionKindSegmentedControl setSelectedSegmentIndex:0];
        }else if ([[meal actionKind] isEqualToString:@"Rápida"]) {
            [mealDetailActionKindSegmentedControl setSelectedSegmentIndex:1];
        }else{
            [mealDetailActionKindSegmentedControl setSelectedSegmentIndex:-1];// Si no hay dato des-selecciono
        }
        
    }
    //Create NSDateFormatter that will turn a date into a sample dateString
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //Use filtered NSDate object to set dateLabel contents
    [mealDetailDateLabel setText:[dateFormatter stringFromDate:[meal dateCreated]]];
    [mealDetailActionKindLabel setText:@"Tipo de acción: "];
    
    NSString *imageKey=[meal imageKey];
    
    if(imageKey)
    {
        //Get imagee for imageKey from image  Store
        UIImage *imageToDisplay=[[SDCImageStore sharedStore] imageForKey:imageKey];
        
        //use that image to put on the screen in imageView
        [mealDetailImageView setImage:imageToDisplay];
        
    }else{
        //Clear imageView
        [mealDetailImageView setImage:nil];
        
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //Clear first Responder
    [[self view] endEditing:YES];
    [self saveFields];
    
}


-(void) viewDidLoad
{
    [super viewDidLoad];
    
    // Elemento accesorio de teclado
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancelar" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    // Le añado la barra a los numberpad textfield
    mealDetailCarboRationField.inputAccessoryView = numberToolbar;
    mealDetailUnitValueField.inputAccessoryView=numberToolbar;
    //Cambio color fondo
    UIColor *clr=nil;
    clr=[UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    
    [[self view] setBackgroundColor:clr];
    // Establezco los labels
    [mealDetailCarboLabel setText:@"raciones de carbohidratos cada:"];
    [mealDetailNameLabel setText:@"Alimento:"];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:10], UITextAttributeFont, nil];
    [mealDetailUnitSegmentedControl setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    [mealDetailUnitSegmentedControl setTitle:@"gr." forSegmentAtIndex:0];
    [mealDetailUnitSegmentedControl setTitle:@"ml." forSegmentAtIndex:1];

    
    [mealDetailActionKindSegmentedControl setTitle:@"Lenta" forSegmentAtIndex:0];
    [mealDetailActionKindSegmentedControl setTitle:@"Rápida" forSegmentAtIndex:1];
    
    [mealDetailExtraDetailsButton setTitle:@"Información adicional" forState:UIControlStateNormal];

}

- (IBAction)takePicture:(id)sender {
    
    pickImageSender=sender;
    
    // Primero guardo los valores que habían en los campos
    [self saveFields];
    
    if([mealDetailImagePickerPopover isPopoverVisible]){
        //If the popOver is already up,get rid of it
        [mealDetailImagePickerPopover dismissPopoverAnimated:YES];
        mealDetailImagePickerPopover=nil;
        return;
    }

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Cargar imagen de:"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Cámara", @"Galería", nil];
    [actionSheet showInView:self.view];
    

    
}

-(void)pickImageFrom:(NSString*)s{
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
        
    
    if ([s isEqualToString:@"Cámara"]) {
        //If our device has camera, we want to take a picture,otherwise,we just pick from a photo library
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }else
        {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }

    }
    
    if ([s isEqualToString:@"Galería"]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    if ([s isEqualToString:@"Cancel"]) {
        
            
    }

        //This line of code will generate a warning right now,ignore it
        [imagePicker setDelegate:self];
        // Place image picker on the screen
        //Check for ipad device before instantiating the popOver Controller
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        {
        //Create a new popover controller that will display the imagePicker
            mealDetailImagePickerPopover=[[UIPopoverController alloc] initWithContentViewController:imagePicker];
    
            [mealDetailImagePickerPopover setDelegate:self];
           //Display the popover controoller, sender
            // is the camera bar button item
            [mealDetailImagePickerPopover presentPopoverFromBarButtonItem:pickImageSender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else{

            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"Cámara"]) {
        NSLog(@"Cámara");
        [self pickImageFrom:@"Cámara"];
    }
    if ([buttonTitle isEqualToString:@"Galería"]) {
        NSLog(@"Galería");
        [self pickImageFrom:@"Galería"];

    }
    
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"\n\n\nCancelar pressed --> Cancel ActionSheet");
    
    }
}


-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    mealDetailImagePickerPopover=nil;
    
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

- (IBAction)mealDetailExtraDetailsButton:(id)sender {
    SDCMealExtraDetailsVC *extraVC=[[SDCMealExtraDetailsVC alloc]init];
    [extraVC setMeal:meal];
    [[self navigationController]pushViewController:extraVC animated:YES];
    
    
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *oldKey=[meal imageKey];
    
    //Did the item already have an image?
    if(oldKey){
        //Delete the old image
        [[SDCImageStore sharedStore] deleteImageForKey:oldKey];
    }
    //Get picked image from the dictionary
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    [meal setThumbnailDataFromImage:image];
    [meal setThumbnailDataFromImageForSetMenu:image];
    
    //Create a CFUUID object - it knows how tocreate unique identifier strings
    CFUUIDRef newUniqueID=CFUUIDCreate(kCFAllocatorDefault);
    //Create a String from unique identifier
    CFStringRef newUniqueIDString=CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    //Use that unique ID to set our item's image key
    NSString *key=(__bridge NSString *) newUniqueIDString;
    [meal setImageKey:key];
    
//    //// REPITO para imagen menu
//    //Create a CFUUID object - it knows how tocreate unique identifier strings
//    CFUUIDRef newUniqueID2=CFUUIDCreate(kCFAllocatorDefault);
//    //Create a String from unique identifier
//    CFStringRef newUniqueIDString2=CFUUIDCreateString(kCFAllocatorDefault, newUniqueID2);
//    //Use that unique ID to set our item's image key
//    NSString *key2=(__bridge NSString *) newUniqueIDString2;
//    [meal setMenuImageKey:key2];
    
    // If you don't call CFRelease beforeLosing a pointer, 
    //the pointed-to object still thinks it has an owner
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
//    CFRelease(newUniqueIDString2);
//    CFRelease(newUniqueID2);
    
    
    //Store image in the BNRImageStore with this key
    [[SDCImageStore sharedStore] setImage:image forKey:[meal imageKey]];
    
    // Me he guardado las copias pequeñas. Ahora muestro en detalle la imagen escogida tal cual
    //Put that image onto the screen in our image view
    [mealDetailImageView setImage:image];
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
       {    //Take image picker off the creen - 
           //you must call this dismiss method
            [self dismissViewControllerAnimated:YES completion:nil];
       }else{
           //If on the pad,the image picker is in the popover.Dismiss the popover
           [mealDetailImagePickerPopover dismissPopoverAnimated:YES];
           mealDetailImagePickerPopover=nil;
       }
       
    
    
   
}


// Evento del tab del number pad
// Las dos acciones de elemento accesorio de teclado
-(void)cancelNumberPad{
    if (mealDetailCarboRationField.editing) {
        [mealDetailCarboRationField resignFirstResponder];
        mealDetailCarboRationField.text = @"";
    }
    if (mealDetailUnitValueField) {
        [mealDetailUnitValueField resignFirstResponder];
        mealDetailUnitValueField.text = @"";
    }
   
}

-(void)doneWithNumberPad{
    if (mealDetailCarboRationField.editing) {
        [mealDetailCarboRationField resignFirstResponder];
    }
    if (mealDetailUnitValueField) {
        [mealDetailUnitValueField resignFirstResponder];
    }

}

- (void)viewDidUnload {
    mealDetailTakePicture = nil;
    [super viewDidUnload];
}
@end
