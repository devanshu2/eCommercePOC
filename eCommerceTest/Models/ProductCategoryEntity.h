//
//  Category.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 10/04/16.
//  Copyright © 2016 Devanshu Saini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface ProductCategoryEntity : NSObject

@property (nonatomic, assign) int categoryID;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, assign) int categorySortOrder;

/*!
 * @discussion Instance of class using its attributes
 * @param categoryID of type int
 * @param categoryName of type NSString
 * @param categorySortOrder of type int
 * @return ProductCategoryEntity instance
 */
- (instancetype)initWithID:(int)categoryID Name:(NSString *)categoryName andSortOrder:(int)categorySortOrder;

@end
