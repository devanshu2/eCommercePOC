//
//  Product.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 10/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import "ProductEntity.h"

@implementation ProductEntity

- (instancetype)initWithProductID:(int)productID Name:(NSString *)productName Image:(NSString *)productImageURL Price:(double)productPrice Category:(ProductCategoryEntity *)productCategory andProductOrder:(int)productOrder{
    self = [super init];
    if (self) {
        _productID = productID;
        _productName = productName;
        _productImageURL = productImageURL;
        _productPrice = productPrice;
        _productCategory = productCategory;
        _productOrder = productOrder;
    }
    return self;
}

@end
