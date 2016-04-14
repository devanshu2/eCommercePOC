//
//  Product.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 10/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductCategory.h"

@interface ProductEntity : NSObject

@property (nonatomic, assign) int productID;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productImageURL;
@property (nonatomic, assign) double productPrice;
@property (nonatomic, strong) ProductCategory *productCategory;

- (instancetype)initWithProductID:(int)productID Name:(NSString *)productName Image:(NSString *)productImageURL Price:(double)productPrice andCategory:(ProductCategory *)productCategory;

@end
