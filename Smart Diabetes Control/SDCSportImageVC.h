//
//  ImageViewController.h
//  Homepwner
//
//  Created by ladmin on 03/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDCSportImageVC : UIViewController {
    
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIScrollView *scrollView;
    
}
@property (nonatomic,strong) UIImage *image;

@end
