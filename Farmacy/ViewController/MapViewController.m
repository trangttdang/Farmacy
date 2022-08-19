//
//  MapViewController.m
//  Farmacy
//
//  Created by Trang Dang on 8/14/22.
//

#import "MapViewController.h"
#import "GoogleMaps/GoogleMaps.h"
@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    [GMSServices provideAPIKey:[dict objectForKey:@"google_maps_api_key"]];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6.0];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = mapView;
}

- (void) getCurrentLocation{
    
}


@end
