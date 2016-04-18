//
//  AppOptions.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devanshu Saini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppOptions : NSObject

/*!
 * @discussion Singleton instance of class
 * @return AppOptions shared instance
 */
+ (instancetype)sharedInstance;


/*!
 * @discussion Get option value for key from Table option
 * @param Key of type NSString
 * @return Value of type NSString
 */
- (NSString*)getOptionValueForKey:(NSString*)key;

@end
