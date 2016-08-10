//
//  ViewController.m
//  MapTest
//
//  Created by adan on 16/8/9.
//  Copyright © 2016年 adan. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "CustumAnnotationView.h"
#import <objc/runtime.h>
//#import "MAMapURLSearchConfig.h"


@interface ViewController ()<MAMapViewDelegate>

@property (nonatomic, strong)MAMapView *mapV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mapV = [[MAMapView alloc] initWithFrame:self.view.frame];
    self.mapV.delegate = self;
    self.mapV.showsUserLocation = YES;
    [self.mapV setUserTrackingMode:1];
    [self.view addSubview:self.mapV];
    
    [self.mapV setZoomLevel:16 animated:YES];
    
    unsigned int a;
    Ivar *b = class_copyIvarList([self class], &a);
    for (int i = 0; i < a; i ++) {
        NSLog(@"%s",ivar_getName(*(b+i)));
    }
}
//@synthesize name = aa ;
- (NSString *)name {
    
    return @"aa";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(40, 116.3435);
    point.title = @"五彩城";
    point.subtitle = @"沃尔玛超市";
    [self.mapV addAnnotation:point];
}

//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
//    
//    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
//        static NSString *ann = @"annotation";
//        MAPinAnnotationView *pin = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ann];
//        if (pin == nil) {
//            pin = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ann];
//        }
//        pin.canShowCallout = YES;
////        pin.animatesDrop = YES;
//        pin.draggable = YES;
////        pin.pinColor = MAPinAnnotationColorGreen;
//        pin.image = [UIImage imageNamed:@"s"];
//        pin.centerOffset = CGPointMake(0, -18);
//        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        img.image = [UIImage imageNamed:@"s"];
//        img.userInteractionEnabled = YES;
//        pin.leftCalloutAccessoryView = img;
//        return pin;
//    }
//    return nil;
//}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MAAnnotationView *view = views[0];
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        
        [self.mapV updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    if (updatingLocation) {
        NSLog(@"%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
//        mapView.showsUserLocation = NO;
    }
}

- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view
{
    if ([view isKindOfClass:[MAAnnotationView class]])
    {
        //配置导航参数
        AMapNaviConfig * config = [[AMapNaviConfig alloc] init];
        config.destination = view.annotation.coordinate;//终点坐标，Annotation的坐标
        config.appScheme = [self getApplicationScheme];//返回的Scheme，需手动设置
        config.appName = [self getApplicationName];//应用名称，需手动设置
        config.strategy = AMapDrivingStrategyShortest;
        //若未调起高德地图App,引导用户获取最新版本的
        if(![AMapURLSearch openAMapNavigation:config])
        {
            [AMapURLSearch getLatestAMapApp];
        }
    }
}

- (NSString *)getApplicationName
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"];
}

- (NSString *)getApplicationScheme
{
    NSDictionary *bundleInfo    = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *URLTypes           = [bundleInfo valueForKey:@"CFBundleURLTypes"];
    
    NSString *scheme;
    for (NSDictionary *dic in URLTypes)
    {
        NSString *URLName = [dic valueForKey:@"CFBundleURLName"];
        if ([URLName isEqualToString:bundleIdentifier])
        {
            scheme = [[dic valueForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
            break;
        }
    }
    
    return scheme;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
