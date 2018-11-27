//
//  RCAnnotationView.m
//  LocationSharer
//
//  Created by 杜立召 on 15/7/27.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//
#import "RCAnnotationView.h"
#import "UIImageView+WebCache.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@implementation RCAnnotation
- (id)initWithThumbnail:(RCLocationView *)thumbnail {
    self = [super init];
    if (self) {
        _coordinate = thumbnail.coordinate;
        _thumbnail = thumbnail;
        _view.userId = thumbnail.userId;
        _view.imageUrl = thumbnail.imageurl;
    }
    return self;
}
- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView {
    if (!_view) {
        _view = (RCAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"RCAnnotationView"];
        if (!_view)
            _view = [[RCAnnotationView alloc] initWithAnnotation:self];
    } else {
        _view.annotation = self;
    }
    [self updateThumbnail:_thumbnail animated:NO];
    return _view;
}
- (void)updateThumbnail:(RCLocationView *)thumbnail animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.33f animations:^{
             _coordinate = thumbnail.coordinate;
         }];
    } else {
        _coordinate = thumbnail.coordinate;
    }
    if (_view) {
        _view.coordinate = self.coordinate;
        _view.userId = thumbnail.userId;
        _view.imageUrl = thumbnail.imageurl;
        _view.tapBlock = thumbnail.tapBlock;
        if (thumbnail.isMyLocation) {
            _view.locationImageView.image = [UIImage imageNamed:@"mylocation.png"];
        } else {
            _view.locationImageView.image = [UIImage imageNamed:@"otherlocation.png"];
        }
//        if (_view.imageUrl&&_view.imageUrl.length>0) {
//            [_view refreshHead:_view.imageUrl];
//        }
    }
}
@end
@implementation RCLocationConvert
+ (double)transformLat:(double)x bdLon:(double)y {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y *y + 0.1 * x *y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}
+ (double)transformLon:(double)x bdLon:(double)y {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x *x + 0.1 * x *y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}
+ (BOOL)outOfChina:(double)lat bdLon:(double)lon {
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}
+ (CLLocationCoordinate2D)gcj02Encrypt:(double)ggLat bdLon:(double)ggLon {
    CLLocationCoordinate2D resPoint;
    double mgLat;
    double mgLon;
    if ([self outOfChina:ggLat bdLon:ggLon]) {
        resPoint.latitude = ggLat;
        resPoint.longitude = ggLon;
        return resPoint;
    }
    double dLat = [self transformLat:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
    double dLon = [self transformLon:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
    double radLat = ggLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - 0.00669342162296594323 * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((6378245.0 * (1 - 0.00669342162296594323)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (6378245.0 / sqrtMagic * cos(radLat) * M_PI);
    mgLat = ggLat + dLat;
    mgLon = ggLon + dLon;
    resPoint.latitude = mgLat;
    resPoint.longitude = mgLon;
    return resPoint;
}
+ (CLLocationCoordinate2D)gcj02Decrypt:(double)gjLat gjLon:(double)gjLon {
    CLLocationCoordinate2D gPt = [self gcj02Encrypt:gjLat bdLon:gjLon];
    double dLon = gPt.longitude - gjLon;
    double dLat = gPt.latitude - gjLat;
    CLLocationCoordinate2D pt;
    pt.latitude = gjLat - dLat;
    pt.longitude = gjLon - dLon;
    return pt;
}
+ (CLLocationCoordinate2D)bd09Decrypt:(double)bdLat bdLon:(double)bdLon {
    CLLocationCoordinate2D gcjPt;
    double x = bdLon - 0.0065, y = bdLat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * M_PI);
    gcjPt.longitude = z * cos(theta);
    gcjPt.latitude = z * sin(theta);
    return gcjPt;
}
+ (CLLocationCoordinate2D)bd09Encrypt:(double)ggLat bdLon:(double)ggLon {
    CLLocationCoordinate2D bdPt;
    double x = ggLon, y = ggLat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) + 0.000003 * cos(x * M_PI);
    bdPt.longitude = z * cos(theta) + 0.0065;
    bdPt.latitude = z * sin(theta) + 0.006;
    return bdPt;
}
+ (CLLocationCoordinate2D)wgs84ToGcj02:(CLLocationCoordinate2D)location {
    return [self gcj02Encrypt:location.latitude bdLon:location.longitude];
}
+ (CLLocationCoordinate2D)gcj02ToWgs84:(CLLocationCoordinate2D)location {
    return [self gcj02Decrypt:location.latitude gjLon:location.longitude];
}
+ (CLLocationCoordinate2D)wgs84ToBd09:(CLLocationCoordinate2D)location {
    CLLocationCoordinate2D gcj02Pt =
    [self gcj02Encrypt:location.latitude bdLon:location.longitude];
    return [self bd09Encrypt:gcj02Pt.latitude bdLon:gcj02Pt.longitude];
}
+ (CLLocationCoordinate2D)gcj02ToBd09:(CLLocationCoordinate2D)location {
    return [self bd09Encrypt:location.latitude bdLon:location.longitude];
}
+ (CLLocationCoordinate2D)bd09ToGcj02:(CLLocationCoordinate2D)location {
    return [self bd09Decrypt:location.latitude bdLon:location.longitude];
}
+ (CLLocationCoordinate2D)bd09ToWgs84:(CLLocationCoordinate2D)location {
 CLLocationCoordinate2D gcj02 = [self bd09ToGcj02:location];
    return [self gcj02Decrypt:gcj02.latitude gjLon:gcj02.longitude];
}
@end
@implementation RCLocationView
@end
@implementation RCAnnotationView
float fromValue = 0.0f;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation {
  self = [super initWithAnnotation:annotation reuseIdentifier:@"RCAnnotationView"];
  if (self) {
    self.canShowCallout = NO;
    self.frame = CGRectMake(0, 0, 40, 40);
    self.backgroundColor = [UIColor clearColor];
    self.centerOffset = CGPointMake(0, 0);
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -35, 40, 40)];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[FreedomTools imageNamed:@"default_portrait_msg" ofBundle:@"RongCloud.bundle"]];
    _imageView.layer.cornerRadius = 20.0;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _imageView.layer.borderWidth = 2;
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(12, -1, 16, 12)];
    arrow.image = [UIImage imageNamed:@"big_arrow.png"];
    _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 16, 16)];
    [self addObserver:self forKeyPath:@"imageUrl" options:NSKeyValueObservingOptionNew context:nil];
    [self addSubview:_locationImageView];
    [self addSubview:arrow];
    [self addSubview:_imageView];
    //        CABasicAnimation* rotationAnimation = [CABasicAnimation
    //        animationWithKeyPath:@"transform.rotation.z"];
    //        rotationAnimation.delegate = self;
    //        rotationAnimation.fromValue = [NSNumber
    //        numberWithFloat:fromValue]; // 起始角度
    //        rotationAnimation.toValue = [NSNumber numberWithFloat:2 *
    //        M_PI];//一圈
    //        rotationAnimation.duration = 1.0f;
    //        rotationAnimation.autoreverses = NO;
    //        rotationAnimation.timingFunction = [CAMediaTimingFunction
    //        functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //        rotationAnimation.removedOnCompletion = NO;
    //        rotationAnimation.fillMode = kCAFillModeBoth;
    //        [_locationImageView.layer addAnimation:rotationAnimation
    //        forKey:@"revItUpAnimation"];
  }
  return self;
}
//- (void)refreshHead:(NSString *)imageUrl{
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
//    placeholderImage:[FreedomTools imageNamed:@"default_portrait_msg"
//    ofBundle:@"RongCloud.bundle"]];
//}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"imageUrl"]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (![[change objectForKey:@"new"] isKindOfClass:[NSNull class]]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[change objectForKey:@"new"]] placeholderImage:[FreedomTools imageNamed:@"default_portrait_msg" ofBundle:@"RongCloud.bundle"]];
      }
    });
  }
}
#pragma mark 重写销毁方法
- (void)dealloc {
  [self removeObserver:self forKeyPath:@"imageUrl"];
}
- (void)didTapDisclosureButton:(id)sender {
  if (_tapBlock)
    _tapBlock();
}
- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView {
  [mapView setCenterCoordinate:_coordinate animated:YES];
}
- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView {
}
@end
