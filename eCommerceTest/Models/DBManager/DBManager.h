//
//  DBManager.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 09/04/16.
//  Copyright © 2016 Devanshu Saini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constants.h"

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

/*!
 * @discussion Singleton instance of class
 * @return DBManager shared instance
 */
+ (instancetype)sharedInstance;

/*!
 * @discussion Instance of class using a dbfile file
 * @param dbFilename of type NSString
 * @return DBManager instance
 */
- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

/*!
 * @discussion load data from database using a query
 * @param query of type NSString
 * @return loaded data from database NSArray
 */
- (NSArray *)loadDataFromDB:(NSString *)query;

/*!
 * @discussion execute a query in the database using a query
 * @param query of type NSString
 */
- (void)executeQuery:(NSString *)query;

@end
