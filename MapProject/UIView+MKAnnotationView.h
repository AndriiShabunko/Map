//  UIView+MKAnnotationView.h
//  MapProject
//  Created by Andrew Shabunko on 7/28/16.
//  Copyright © 2016 Andrew. All rights reserved.

#import <UIKit/UIKit.h>

@class MKAnnotationView;

@interface UIView (MKAnnotationView)

- (MKAnnotationView*) superAnnotationView;

@end