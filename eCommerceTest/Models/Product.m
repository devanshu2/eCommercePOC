//
//  Product.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 10/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import "Product.h"

@implementation Product

- (instancetype)initWithProductID:(int)productID Name:(NSString *)productName Image:(NSString *)productImageURL Price:(double)productPrice andCategory:(ProductCategory *)productCategory{
    self = [super init];
    if (self) {
        _productID = productID;
        _productName = productName;
        _productImageURL = productImageURL;
        _productPrice = productPrice;
        _productCategory = productCategory;
    }
    return self;
}

@end
