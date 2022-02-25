//
//  ZTLocationSDK.h
//  Pods
//
//  Created by BRUNO CARNEIRO on 25/07/19.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "ZTHttpService.h"
#import "ZTLogger.h"

//! Project version number for ZaptLocation_iOS_SDK.
FOUNDATION_EXPORT double ZaptLocation_iOS_SDKVersionNumber;

//! Project version string for ZaptLocation_iOS_SDK.
FOUNDATION_EXPORT const unsigned char ZaptLocation_iOS_SDKVersionString[];

@interface ZTLocationSDK: NSObject<CLLocationManagerDelegate> {
    
}

@property (retain) NSString *visitableId;

@property (retain) NSOperationQueue *queue;

@property (retain) CLLocationManager *locationManager;

@property (retain, readonly) ZTLogger *logger;

@property BOOL debugLogEnabled;

@property BOOL debugNotificationsEnabled;

@property (retain) ZTHttpService *notifier;

- (instancetype)initWithVisitableId :(NSString *)visitableId;
- (void)start;
- (void)stop;
- (NSString*)getMapLink;
- (NSString*)getInterestLink:(NSString *)interestId;


- (ZTLogger*) getLogger;

@end
