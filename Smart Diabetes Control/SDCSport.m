//
//  BNRItem.m
//  RandomPossesionns
//
//  Created by ladmin on 13/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SDCSport.h"

@implementation SDCSport

@synthesize sportName;
@synthesize dateCreated;
@synthesize imageKey;
@synthesize usualIntensity;

@synthesize thumbnail,thumbnailForSetMenu,thumbnailData,thumbnailDataForSetMenu;

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
        thumbnailForSetMenu=[UIImage imageWithData:thumbnailDataForSetMenu scale:(2.0)];    }
    return thumbnailForSetMenu;
}



-(void) encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"Codificando deporte");
    [aCoder encodeObject:sportName forKey:@"sportName"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    [aCoder encodeObject:thumbnailData forKey:@"thumbnailData"];
    [aCoder encodeObject:thumbnailDataForSetMenu forKey:@"thumbnailDataForSetMenu"];
    [aCoder encodeObject:usualIntensity forKey:@"usualIntensity"];

}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if (self){
        NSLog(@"Decodificando deporte");
        [self setSportName:[aDecoder decodeObjectForKey:@"sportName"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        dateCreated=[aDecoder decodeObjectForKey:@"dateCreated"];
        thumbnailData=[aDecoder decodeObjectForKey:@"thumbnailData"];
        thumbnailDataForSetMenu=[aDecoder decodeObjectForKey:@"thumbnailDataForSetMenu"];
         usualIntensity=[aDecoder decodeObjectForKey:@"usualIntensity"];
    }
    return self;
}

-(id)init {
    return [self initWithSportName:@"" dateCreated:[NSDate date]];
}

 -(id) initWithSportName:(NSString *)sport dateCreated:(NSDate *)dc 
{   
     // Call the SuperClass's designated initializer
     self=[super init];
      
     // Disd the superclass's designated initializer succed?
     if(self){
         
     //Give the instance variables initial values
     [self setSportName:sport];
     dateCreated=dc;
    
     }
     // Return the adress of the newly initialized object
     return self;
 }

-(NSString *) description{
    NSString *descriptionString=
    [[NSString alloc]initWithFormat:@"\n Deporte:%@ Fecha:%@",sportName,dateCreated];
    return descriptionString;
}
@end
