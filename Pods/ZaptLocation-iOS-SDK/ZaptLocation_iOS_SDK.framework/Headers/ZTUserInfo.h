//
//  ZTUserInfo.h
//  ZaptLocation-iOS-SDK
//
//  Created by BRUNO CARNEIRO on 28/07/19.
//  Copyright © 2019 Zapt Tech. All rights reserved.
//

@interface ZTUserInfo: NSObject {
    
}

@property (retain) NSString* userId;
@property (retain) NSString* userName;
@property (retain) NSString* deviceId;
@property (retain) NSDictionary* categories;

- (NSString*) getUserId;
- (NSString*) getUserName;
- (NSString*) getDeviceId;
- (NSDictionary*) getCategories;
- (void) commit;
+ (ZTUserInfo*) recover;

@end
