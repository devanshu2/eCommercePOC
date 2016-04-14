//
//  Products.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductEntity.h"
#import "DBManager.h"

@interface Products : NSObject

+ (NSArray*)getProductsWithCategory;

@end
