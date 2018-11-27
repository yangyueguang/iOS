//
//  RCAnnotationView.h
//  LocationSharer
//
//  Created by 杜立召 on 15/7/27.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
typedef void (^TapActionBlock)();
@interface RCLocationConvert : NSObject
/**
 *    @brief    世界标准地理坐标(WGS-84) 转换成
 *中国国测局地理坐标（GCJ-02）<火星坐标>
 *  ####只在中国大陆的范围的坐标有效，以外直接返回世界标准坐标
 *    @param     location     世界标准地理坐标(WGS-84)
 *    @return    中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)wgs84ToGcj02:(CLLocationCoordinate2D)location;
/**
 *    @brief    中国国测局地理坐标（GCJ-02） 转换成 世界标准地理坐标（WGS-84）
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *    @param     location     中国国测局地理坐标（GCJ-02）
 *    @return    世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)gcj02ToWgs84:(CLLocationCoordinate2D)location;
/**
 *    @brief    世界标准地理坐标(WGS-84) 转换成 百度地理坐标（BD-09)
 *    @param     location     世界标准地理坐标(WGS-84)
 *    @return    百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)wgs84ToBd09:(CLLocationCoordinate2D)location;
/**
 *    @brief    中国国测局地理坐标（GCJ-02）<火星坐标> 转换成
 *百度地理坐标（BD-09)
 *    @param     location     中国国测局地理坐标（GCJ-02）<火星坐标>
 *    @return    百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)gcj02ToBd09:(CLLocationCoordinate2D)location;
/**
 *    @brief    百度地理坐标（BD-09) 转换成
 *中国国测局地理坐标（GCJ-02）<火星坐标>
 *    @param     location     百度地理坐标（BD-09)
 *    @return    中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)bd09ToGcj02:(CLLocationCoordinate2D)location;
/**
 *    @brief    百度地理坐标（BD-09) 转换成 世界标准地理坐标（WGS-84）
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *    @param     location     百度地理坐标（BD-09)
 *    @return    世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)bd09ToWgs84:(CLLocationCoordinate2D)location;
@end
@protocol RCAnnotationProtocol <NSObject>
- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView;
@end
@interface RCLocationView : NSObject
@property(nonatomic, copy) NSString *imageurl;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, assign) BOOL isMyLocation;
@property(nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) TapActionBlock tapBlock;
@end
@protocol RCAnnotationViewProtocol <NSObject>
- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView;
- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView;
@end
@interface RCAnnotationView : MKAnnotationView <RCAnnotationViewProtocol>
@property(nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, copy) NSString *imageUrl;
@property(nonatomic, strong) UIImageView *locationImageView;
//@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) UILabel *subtitleLabel;
@property(nonatomic, copy) TapActionBlock tapBlock;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation;
@end
@interface RCAnnotation : NSObject <MKAnnotation, RCAnnotationProtocol>
@property(nonatomic, strong) RCAnnotationView *view;
@property(nonatomic, strong) RCLocationView *thumbnail;
@property(nonatomic, readwrite) CLLocationCoordinate2D coordinate;
- (id)initWithThumbnail:(RCLocationView *)thumbnail;
- (void)updateThumbnail:(RCLocationView *)thumbnail animated:(BOOL)animated;
@end
