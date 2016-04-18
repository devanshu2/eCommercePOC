//
//  Products.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devanshu Saini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductEntity.h"
#import "DBManager.h"

@interface Products : NSObject

/*!
 * @discussion Get all products with category in attrubute from the database
 * @return Array of the products of type NSArray
 */
+ (NSArray*)getProductsWithCategory;

@end
