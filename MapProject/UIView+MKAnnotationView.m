//  UIView+MKAnnotationView.m
//  MapProject
//  Created by Andrew Shabunko on 7/28/16.
//  Copyright © 2016 Andrew. All rights reserved.

#import "UIView+MKAnnotationView.h"
#import <MapKit/MKAnnotationView.h>

@implementation UIView (MKAnnotationView)

- (MKAnnotationView*) superAnnotationView {
    
    if ([self.superview isKindOfClass:[MKAnnotationView class]]) {
        return (MKAnnotationView*)self.superview;
    }
    
    if (!self.superview) {
        return nil;
    }
    return [self.superview superAnnotationView];
}

@end