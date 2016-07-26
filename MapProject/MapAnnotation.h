//  MapAnnotation.h
//  MapProject
//  Created by Andrew Shabunko on 7/26/16.
//  Copyright © 2016 Andrew. All rights reserved.

#import <Foundation/Foundation.h>
#import <Mapkit/MKAnnotation.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end