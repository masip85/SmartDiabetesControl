//
//  BNRItem.m
//  RandomPossesionns
//
//  Created by ladmin on 13/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SDCMeal.h"

@implementation SDCMeal

@synthesize mealName;
@synthesize rationValue,dateCreated,unitKind,unitValue,actionKind;
@synthesize imageKey;
@synthesize thumbnail,thumbnailData;
@synthesize thumbnailForSetMenu,thumbnailDataForSetMenu;

- (void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    // The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    // Figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,newRect.size.height / origImageSize.height);
    // Create a transparent bitmap context with a scaling factor
    // equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    // Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    // Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    // Draw the image on it
    [image drawInRect:projectRect];
    // Get the image from the image context, keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    // Get the PNG representation of the image and set it as our archivable data
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    // Cleanup image context resources, we're done
    UIGraphicsEndImageContext();
    
}

- (void)setThumbnailDataFromImageForSetMenu:(UIImage *)image
{
    CGSize origImageSize = [image size];
    // The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0, 0, 100, 80);
    // Figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,newRect.size.height / origImageSize.height);
    // Create a transparent bitmap context with a scaling factor
    // equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    // Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    // Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    // Draw the image on it
    [image drawInRect:projectRect];
    // Get the image from the image context, keep it as our thumbnailForSetMenu
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnailForSetMenu:smallImage];
    // Get the PNG representation of the image and set it as our archivable data
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailDataForSetMenu:data];
    // Cleanup image context resources, we're done
    UIGraphicsEndImageContext();
    
}

-(UIImage *)thumbnail
{
    //if there is no thumbnailDta,then I have no thumbnail to return
    if(!thumbnailData){
        return nil;
    }
    //If I have no yet created my thumbnail image from my data,do so now
    if(!thumbnail){
        //Create the image from the data
        thumbnail=[UIImage imageWithData:thumbnailData];
    }
    return thumbnail;
}

-(UIImage *)thumbnailForSetMenu
{
    //if there is no thumbnailDta,then I have no thumbnail to return
    if(!thumbnailDataForSetMenu){
        return nil;
    }
    //If I have no yet created my thumbnail image from my data,do so now
    if(!thumbnailForSetMenu){
        //Create the image from the data
        thumbnailForSetMenu=[UIImage imageWithData:thumbnailDataForSetMenu scale:(2.0)]; // No sé porque hay que escalar esto.¡Apaño! quitar para ver efecto contrario!
    }
    return thumbnailForSetMenu;
}



-(void) encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"Codificando alimentos");
    [aCoder encodeObject:mealName forKey:@"mealName"];
    [aCoder encodeObject:unitValue forKey:@"unitValue"];
    [aCoder encodeObject:unitKind forKey:@"unitKind"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    [aCoder encodeObject:rationValue forKey:@"rationValue"];
    [aCoder encodeObject:actionKind forKey:@"actionKind"];
    [aCoder encodeObject:thumbnailDataForSetMenu forKey:@"thumbnailDataForSetMenu"];
    [aCoder encodeObject:thumbnailData forKey:@"thumbnailData"];
  

}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if (self){
        NSLog(@"Decodificando alimentos");
        [self setMealName:[aDecoder decodeObjectForKey:@"mealName"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        [self setUnitKind:[aDecoder decodeObjectForKey:@"unitKind"]];
        [self setUnitValue:[aDecoder decodeObjectForKey:@"unitValue"]];
        [self setActionKind:[aDecoder decodeObjectForKey:@"actionKind"]];
        rationValue=[aDecoder decodeObjectForKey:@"rationValue"];
    
        [self setThumbnailDataForSetMenu:[aDecoder decodeObjectForKey:@"thumbnailDataForSetMenu"]];
        thumbnailData=[aDecoder decodeObjectForKey:@"thumbnailData"];
        dateCreated=[aDecoder decodeObjectForKey:@"dateCreated"];
    }
    return self;
}

-(id)init {
    return [self initWithMealName:@"" rationValue:0 unitKind:@"unidades de" unitValue:0 actionKind:@""dateCreated:[NSDate date]];
}

 -(id) initWithMealName:(NSString *)meal rationValue:(NSNumber *)cv unitKind:(NSString *)uk unitValue:(NSNumber *)uv actionKind:(NSString *)ak dateCreated:(NSDate *)dc
{
     // Call the SuperClass's designated initializer
     self=[super init];
      
     // Disd the superclass's designated initializer succed?
     if(self){
         
     //Give the instance variables initial values
     [self setMealName:meal];
     [self setRationValue:cv];
     dateCreated=[[NSDate alloc]init];
     [self setUnitKind:uk];
     [self setActionKind:ak];
     [self setUnitValue:uv];
         
         
     }
     // Return the adress of the newly initialized object
     return self;
 }

-(NSString *) description{
    NSString *descriptionString=
    [[NSString alloc]initWithFormat:@"\n Alimento:%@ Fecha:%@ - Tipo carbo:%@ - Numero de raciones %@ de CHO/%@  %@",mealName,dateCreated,actionKind,rationValue,unitValue,unitKind];
    return descriptionString;
}
@end
