//
//  GPAPolylineEncoding.h
//  GooglePolylineApp
//
//  Created by Lukas Oslislo on 11/12/15.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface GPAPolylineEncoding : NSObject
/*
 NSString *encodedPolyline = @"_p~iF~ps|U_ulLnnqC_mqNvxq`@";
 Polyline *p = [[Polyline alloc]init];
 NSArray *arry =  [p decodePolyline:encodedPolyline];
 for (int i = 0; i <arry.count; i++) {
 CLLocationCoordinate2D last = [(NSValue *)arry[i] MKCoordinateValue];
 NSLog(@"lat = %f lon = %f",last.latitude,last.longitude);
 }
 */
+ (NSArray<NSNumber *> *)decodePolyline: (NSString *)polylineString;
/**
 *  根据谷歌的decoded Polyline 获取 解压后的 经纬度
 *  @param encodedPolyline 谷歌的压缩的 polyline 字符串 （@"_p~iF~ps|U_ulLnnqC_mqNvxq`@"）
 *  @return 经纬度数组
 */
- (NSArray<NSValue  *> *)decodePolyline:(NSString *)encodedPolyline;
@end
