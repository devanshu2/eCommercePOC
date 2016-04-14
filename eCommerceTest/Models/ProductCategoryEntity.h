//
//  Category.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 10/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCategoryEntity : NSObject

@property (nonatomic, assign) int categoryID;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, assign) int categorySortOrder;

- (instancetype)initWithID:(int)categoryID Name:(NSString *)categoryName andSortOrder:(int)categorySortOrder;

@end
