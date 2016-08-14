//
//  DetailViewController.m
//  Homepwner
//
//  Created by ladmin on 22/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SportDetailVC.h"
#import "SDCImageStore.h"
#import "SDCSportStore.h"
#import "SDCConstants.h"


@implementation SportDetailVC

@synthesize sport;
@synthesize dismissBlock;
id pickImageSender;


-(void) cancel:(id)sender
{
    //If the user cancelled,then remove the sport form the store
    [[SDCSportStore sharedStore] removeSport:sport];
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
    [sport setSportName:[sportDetailNameField text]];
    [sport setUsualIntensity:[[NSNumber alloc]initWithFloat:[sportDetailIntensitySlider value]]];
}



//Making ilegal designated initializer

-(id) initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Must use initForNewSport" userInfo:nil];
    return nil;
}

- (IBAction)sliderValueChanged:(id)sender {
    
    if ([sportDetailIntensitySlider value]<33){
        [sportDetailIntensityLabel setText:@"Intensidad habitual: Suave"];
    }else    if ([sportDetailIntensitySlider value]<66){
        [sportDetailIntensityLabel setText:@"Intensidad habitual: Moderada"];
    } else{
        [sportDetailIntensityLabel setText:@"Intensidad habitual: Intensa"];
    }
}

-(id)initForNewSport:(BOOL)isNew
{
    if ([deviceString isEqualToString:@"iPhone5"]) {
        self=[super initWithNibName:@"SportDetailVC_iPhone5" bundle:nil];
    }else{
        
        self = [super initWithNibName:@"SportDetailVC"  bundle:nil];
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

-(void)setSport:(SDCSport *)i
{
    // AQUI la tabla me pasa que alimento muestra la vista detallada. además le pone título
    sport=i;
    
    // Titulo de arriba - bar
    if ([[sport sportName]isEqual:@""]) {
        [[self navigationItem] setTitle:@"Nuevo deporte"];
    }else{
        [[self navigationItem] setTitle:[sport sportName]];
    }
}



-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Campos de edición si no existen vacios y si existen, los cargo
    [sportDetailNameField setText:[sport sportName]];
    if ([[sport sportName]isEqual:@""]) {
        [sportDetailNameField setText:@""];
        [sportDetailIntensitySlider setValue:50.0];
        
    }else{

    [sportDetailNameField setText:[NSString stringWithFormat:@"%@",[sport sportName]]];
    [sportDetailIntensitySlider setValue:[[sport usualIntensity]floatValue]];
        if ([sportDetailIntensitySlider value]<33){
            [sportDetailIntensityLabel setText:@"Intensidad habitual: Suave"];
        }else    if ([sportDetailIntensitySlider value]<66){
            [sportDetailIntensityLabel setText:@"Intensidad habitual: Moderada"];
        } else{
            [sportDetailIntensityLabel setText:@"Intensidad habitual: Intensa"];
        }
     
    }
    //Create NSDateFormatter that will turn a date into a sample dateString
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //Use filtered NSDate object to set dateLabel contents
    [sportDetailDateLabel setText:[dateFormatter stringFromDate:[sport dateCreated]]];
    
    NSString *imageKey=[sport imageKey];
    
    if(imageKey)
    {
        //Get imagee for imageKey from image  Store
        UIImage *imageToDisplay=[[SDCImageStore sharedStore] imageForKey:imageKey];
        
        //use that image to put on the screen in imageView
        [sportDetailImageView setImage:imageToDisplay];
        
    }else{
        //Clear imageView
        [sportDetailImageView setImage:nil];
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
    //Cambio color fondo
    UIColor *clr=nil;
    clr=[UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    [[self view] setBackgroundColor:clr];
    [sportDetailIntensitySlider setMaximumValue:100.0];
    [sportDetailIntensitySlider setMinimumValue:0.0];
    [sportDetailIntensityLabel setText:@"Intensidad habitual: Moderada"];
    [sportDetailNameLabel setText:@"Deporte:"];



}

- (IBAction)takePicture:(id)sender {
    
    pickImageSender=sender;
    
    // Primero guardo los valores que habían en los campos
    [self saveFields];
    
    if([sportDetailImagePickerPopover isPopoverVisible]){
        //If the popOver is already up,get rid of it
        [sportDetailImagePickerPopover dismissPopoverAnimated:YES];
        sportDetailImagePickerPopover=nil;
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
        sportDetailImagePickerPopover=[[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        [sportDetailImagePickerPopover setDelegate:self];
        //Display the popover controoller, sender
        // is the camera bar button item
        [sportDetailImagePickerPopover presentPopoverFromBarButtonItem:pickImageSender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
    sportDetailImagePickerPopover=nil;
    
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *oldKey=[sport imageKey];
    
    //Did the item already have an image?
    if(oldKey){
        //Delete the old image
        [[SDCImageStore sharedStore] deleteImageForKey:oldKey];
    }
    //Get picked image from the dictionary
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    [sport setThumbnailDataFromImage:image];
    [sport setThumbnailDataFromImageForSetMenu:image];
    
    //Create a CFUUID object - it knows how tocreate unique identifier strings
    CFUUIDRef newUniqueID=CFUUIDCreate(kCFAllocatorDefault);
    //Create a String from unique identifier
    CFStringRef newUniqueIDString=CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    //Use that unique ID to set our item's image key
    NSString *key=(__bridge NSString *) newUniqueIDString;
    [sport setImageKey:key];
    
//    //// REPITO para imagen menu
//    //Create a CFUUID object - it knows how tocreate unique identifier strings
//    CFUUIDRef newUniqueID2=CFUUIDCreate(kCFAllocatorDefault);
//    //Create a String from unique identifier
//    CFStringRef newUniqueIDString2=CFUUIDCreateString(kCFAllocatorDefault, newUniqueID2);
//    //Use that unique ID to set our item's image key
//    NSString *key2=(__bridge NSString *) newUniqueIDString2;
//    [sport setMenuImageKey:key2];
    
    // If you don't call CFRelease beforeLosing a pointer, 
    //the pointed-to object still thinks it has an owner
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
//    CFRelease(newUniqueIDString2);
//    CFRelease(newUniqueID2);
    
    
    //Store image in the BNRImageStore with this key
    [[SDCImageStore sharedStore] setImage:image forKey:[sport imageKey]];
    
    // Me he guardado las copias pequeñas. Ahora muestro en detalle la imagen escogida tal cual
    //Put that image onto the screen in our image view
    [sportDetailImageView setImage:image];
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
       {    //Take image picker off the creen - 
           //you must call this dismiss method
            [self dismissViewControllerAnimated:YES completion:nil];
       }else{
           //If on the pad,the image picker is in the popover.Dismiss the popover
           [sportDetailImagePickerPopover dismissPopoverAnimated:YES];
           sportDetailImagePickerPopover=nil;
       }
       
    
    
   
}

// Evento del tab del number pad
// Las dos acciones de elemento accesorio de teclado
 


- (void)viewDidUnload {
    sportDetailTakePicture = nil;
    [super viewDidUnload];
}
@end
