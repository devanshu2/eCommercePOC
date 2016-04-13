//
//  Category.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 10/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import "ProductCategory.h"

@implementation ProductCategory

- (instancetype)initWithID:(int)categoryID Name:(NSString *)categoryName andSortOrder:(int)categorySortOrder{
    self = [super init];
    if (self) {
        _categoryID = categoryID;
        _categoryName = categoryName;
        _categorySortOrder = categorySortOrder;
    }
    return self;
}

@end
