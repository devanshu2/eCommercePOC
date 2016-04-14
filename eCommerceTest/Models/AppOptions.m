//
//  AppOptions.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import "AppOptions.h"
#import "DBManager.h"

@interface AppOptions(){
    NSMutableDictionary *options;
}

@end

@implementation AppOptions

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static AppOptions *theInstance;
    dispatch_once(&onceToken, ^{
        theInstance = [[AppOptions alloc] init];
    });
    return theInstance;
}

- (NSString*)getOptionValueForKey:(NSString *)key{
    if ([options objectForKey:key]) {
        return [options objectForKey:key];
    }
    else{
        NSString *query = [NSString stringWithFormat:@"select %@ from %@ where %@ = '%@'", COLUMN_OPTIONS_VALUE, TABLE_OPTIONS, COLUMN_OPTIONS_KEY, key];
        NSString *theValue = [[[[DBManager sharedInstance] loadDataFromDB:query] firstObject] objectForKey:COLUMN_OPTIONS_VALUE];
        if(!options){
            options = [@{} mutableCopy];
        }
        [options setObject:theValue forKey:key];
        return theValue;
    }
}

@end
