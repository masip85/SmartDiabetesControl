//
//  customCell.m
//  Collection View Example
//
//  Created by Mederi on 21/05/13.
//  Copyright (c) 2013 Mederi. All rights reserved.
//

#import "CustomCell.h"
NSIndexPath *indexPath;;

@implementation CustomCell

- (id)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc]
                      initWithFrame:CGRectMake(10, 10, 80, 60)
                      ];
        self.label.textColor = [UIColor whiteColor];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
