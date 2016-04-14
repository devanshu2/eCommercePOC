//
//  AppOptions.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppOptions : NSObject

+(instancetype)sharedInstance;

- (NSString*)getOptionValueForKey:(NSString*)key;

@end
