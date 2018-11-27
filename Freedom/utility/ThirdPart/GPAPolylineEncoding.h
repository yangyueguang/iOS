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
- (NSArray<NSValue  *> *)decodePolyline:(NSString *)encodedPolyline;
@end
