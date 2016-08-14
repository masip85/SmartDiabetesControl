//
//  SDCEllipse.h
//  Smart Diabetes Control
//
//  Created by Mederi on 14/06/13.
//
//

#import <UIKit/UIKit.h>

@interface SDCEllipse : UIView

@property (nonatomic)int clusterIndex;
@property(nonatomic)bool selected;
@property(nonatomic)CGPoint framePointCenter;

@property(nonatomic)float varValue;
@property(nonatomic)float minValue;
@property(nonatomic)float maxValue;
@property(nonatomic)float meanValue;
@property(nonatomic)float hyperPercent;
@property(nonatomic)float normoPercent;
@property(nonatomic)float hypoPercent;
-(void) tap:(UIGestureRecognizer *)gr;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
@end
