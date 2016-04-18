//
//  DBManager.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 09/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constants.h"

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

+(instancetype)sharedInstance;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

@end
