//  ViewController.h
//  MapProject
//  Created by Andrew Shabunko on 7/26/16.
//  Copyright © 2016 Andrew. All rights reserved.

#import <UIKit/UIKit.h>

@class MKMapView;

@interface ViewController : UIViewController 

@property (weak, nonatomic) IBOutlet MKMapView* mapView;

@end