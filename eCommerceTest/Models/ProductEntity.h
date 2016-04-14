//
//  Product.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 10/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductCategoryEntity.h"

@interface ProductEntity : NSObject

@property (nonatomic, assign) int productID;
@property (nonatomic, assign) int productOrder;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productImageURL;
@property (nonatomic, assign) double productPrice;
@property (nonatomic, strong) ProductCategoryEntity *productCategory;
@property (nonatomic, readonly, getter=getProductData) NSDictionary* productDictionaryData;

- (instancetype)initWithProductID:(int)productID Name:(NSString *)productName Image:(NSString *)productImageURL Price:(double)productPrice Category:(ProductCategoryEntity *)productCategory andProductOrder:(int)productOrder;

- (instancetype)initWithProductDictionaryData:(NSDictionary*)productDictionaryData;

@end
