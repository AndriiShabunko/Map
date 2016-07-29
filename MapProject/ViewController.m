//  ViewController.m
//  MapProject
//  Created by Andrew Shabunko on 7/26/16.
//  Copyright © 2016 Andrew. All rights reserved.

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#import "UIView+MKAnnotationView.h"

@interface ViewController () <MKMapViewDelegate>

@property (strong, nonatomic) CLGeocoder* geoCoder;
@property (strong, nonatomic) MKDirections* directions;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem* addPin = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddPin:)];
    UIBarButtonItem* showAllPins = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(actionShowAllPins:)];
    UIBarButtonItem* flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem* addpin2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(actionAddPin2:)];
    
    self.navigationItem.rightBarButtonItems = @[flexible,showAllPins,flexible];
    self.navigationItem.leftBarButtonItems = @[flexible,addPin,flexible];
    
    self.geoCoder = [[CLGeocoder alloc]init];
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    if ([self.geoCoder isGeocoding]) {
        [self.geoCoder cancelGeocode];
    }
    if ([self.directions isCalculating]) {
        [self.directions cancel];
}
}
#pragma mark - Action

- (void) actionAddPin:(UIBarButtonItem*) sender {
    MapAnnotation* annotation = [[MapAnnotation alloc] init];
    annotation.title = @"Test Title";
    annotation.subtitle = @"Test SubTitle";
    annotation.coordinate = self.mapView.region.center;
    
    [self.mapView addAnnotation:annotation];
}

//- (void) actionAddPin2:(UIBarButtonItem*) sender {
//    
//    MapAnnotation* annotation2 = [[MapAnnotation alloc] init];
//    annotation2.title = @"Test Title2";
//    annotation2.subtitle = @"Test SubTitle2";
//
//    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(49.832838, 23.997104);
//    
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
//    MKCoordinateRegion region = {coord, span};
//    
//  
//    [annotation2 setCoordinate:coord];
//    
//    [self.mapView setRegion:region];
//    [self.mapView addAnnotation:annotation2];
//
//}


- (void) actionShowAllPins:(UIBarButtonItem*) sender {
    MKMapRect zoomRect = MKMapRectNull;

    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        CLLocationCoordinate2D location = annotation.coordinate;
        MKMapPoint center = MKMapPointForCoordinate(location);
        static double delta = 20000;
        
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta*2, delta*2);
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) animated:YES];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    NSLog(@"regionWillChangeAnimated");
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"regionDidChangeAnimated");
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    NSLog(@"mapViewWillStartLoadingMap");
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    NSLog(@"mapViewDidFinishLoadingMap");
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    NSLog(@"mapViewDidFailLoadingMap");
}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView {
    NSLog(@"mapViewWillStartRenderingMap");
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    NSLog(@"mapViewDidFinishRenderingMap fullyRendered = %d", fullyRendered);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass: [MKUserLocation class]]) {
        return nil;
    }
    static NSString* identifier = @"Annotation";
    
    MKPinAnnotationView* pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!pin) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pin.pinColor = MKPinAnnotationColorGreen;
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        pin.draggable = YES;
        
        UIButton* descriptionButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [descriptionButton addTarget:self action:@selector(actionDescription:) forControlEvents:UIControlEventTouchUpInside];
        pin.rightCalloutAccessoryView = descriptionButton;
        
        UIButton* directionButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [directionButton addTarget:self action:@selector(actionDirection:) forControlEvents:UIControlEventTouchUpInside];
        pin.leftCalloutAccessoryView = directionButton;
    }
        else {
            pin.annotation=annotation;
        }
        return pin;
    }

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState {
    if (newState == MKAnnotationViewDragStateEnding) {
        CLLocationCoordinate2D location = view.annotation.coordinate;
        MKMapPoint point = MKMapPointForCoordinate(location);
        NSLog(@"\nlocation = {%f, %f}\npoint = %@", location.latitude, location.longitude, MKStringFromMapPoint(point));
    }
    
}


- (MKOverlayPathRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer* renderer = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
        renderer.lineWidth = 2.f;
        renderer.strokeColor = [UIColor colorWithRed:0.f green: 0.5f blue:1.f alpha:0.9f];
        
        return renderer;
    }
    return nil;
}

#pragma mark - Action

- (void) showAlertWithTitle: (NSString*) title andMessage:(NSString*) message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:message cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}

- (void) actionDescription:(UIButton*) sender {
    MKAnnotationView* annotationView = [sender superAnnotationView];
    
    if (!annotationView) {
        return;
    }
    
    CLLocationCoordinate2D coordinate = annotationView.annotation.coordinate;
    
    CLLocation* location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];

    
    if ([self.geoCoder isGeocoding]) {
    [self.geoCoder cancelGeocode];
    }
    
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        NSString* message = nil;
        
        if (error) {
            message = [error localizedDescription];
        }
        else {
            if ([placemarks count] > 0) {
                MKPlacemark* placeMark = [placemarks firstObject];
                message = [placeMark.addressDictionary description];
                
            }
            else {
                message = @"No Placemarks Found";
            }
        }
        
        [[[UIAlertView alloc] initWithTitle:@"Location" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    }];
}

- (void) actionDirection: (UIButton*) sender {
    MKAnnotationView* annotationView = [sender superAnnotationView];
    
    if (!annotationView) {
        return;
    }
    
    if ([self.directions isCalculating]) {
        [self.directions cancel];
        
    
    CLLocationCoordinate2D coordinate = annotationView.annotation.coordinate;
    MKDirectionsRequest* request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark* placemark =[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    request.destination = destination;
    request.transportType = MKDirectionsTransportTypeAutomobile;
        
        request.requestsAlternateRoutes = YES;
        
        
        self.directions = [[MKDirections alloc] initWithRequest:request];
            
    self.directions = [[MKDirections alloc] initWithRequest:request];
    
    [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * response, NSError *  error) {
        
        if (error) {
            [self showAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
        }
            else if ([response.routes count] == 0) {
                [self showAlertWithTitle:@"Error" andMessage:@"No routes found"];
            } else {
            
                [self.mapView removeOverlays:[self.mapView overlays]];
                
                NSMutableArray* array =[NSMutableArray alloc];
                for (MKRoute* route in response.routes) {
                    [array addObject:route.polyline];
                }
                
                [self.mapView addOverlays:array level: MKOverlayLevelAboveRoads];
            }
        }
        
        
    ];
}
}



@end