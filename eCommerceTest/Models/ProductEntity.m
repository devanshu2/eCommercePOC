//
//  Product.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 10/04/16.
//  Copyright © 2016 Devanshu Saini. All rights reserved.
//

#import "ProductEntity.h"

@implementation ProductEntity

- (instancetype)initWithProductID:(int)productID Name:(NSString *)productName Image:(NSString *)productImageURL LocalImage:(NSString*)productLocalImage MaxQuantity:(int)productMaxQuantity Price:(double)productPrice Category:(ProductCategoryEntity *)productCategory andProductOrder:(int)productOrder{
    self = [super init];
    if (self) {
        _productID = productID;
        _productName = productName;
        _productImageURL = productImageURL;
        _productLocalImage = productLocalImage;
        _productMaxQuantity = productMaxQuantity;
        _productPrice = productPrice;
        _productCategory = productCategory;
        _productOrder = productOrder;
    }
    return self;
}

- (instancetype)initWithProductDictionaryData:(NSDictionary*)productDictionaryData{
    self = [super init];
    if (self) {
        _productID = [[productDictionaryData objectForKey:COLUMN_PRODUCT_ID] intValue];
        _productName = [productDictionaryData objectForKey:COLUMN_PRODUCT_NAME];
        _productImageURL = [productDictionaryData objectForKey:COLUMN_PRODUCT_IMAGE_URL];
        _productPrice = [[productDictionaryData objectForKey:COLUMN_PRODUCT_PRICE] doubleValue];
        _productLocalImage = [productDictionaryData objectForKey:COLUMN_PRODUCT_LOCAL_IMAGE];
        _productMaxQuantity = [[productDictionaryData objectForKey:COLUMN_PRODUCT_MAX_QUANTITY] intValue];
        _productCategory = [[ProductCategoryEntity alloc] initWithID:[[[productDictionaryData objectForKey:TABLE_CATEGORY] objectForKey:COLUMN_CATEGORY_ID] intValue] Name:[[productDictionaryData objectForKey:TABLE_CATEGORY] objectForKey:COLUMN_CATEGORY_NAME] andSortOrder:[[[productDictionaryData objectForKey:TABLE_CATEGORY] objectForKey:COLUMN_CATEGORY_ORDER] intValue]];
        _productOrder = [[productDictionaryData objectForKey:COLUMN_PRODUCT_ORDER] intValue];
    }
    return self;
}

- (NSDictionary*)getProductData{
    return @{
             COLUMN_PRODUCT_ID : [NSNumber numberWithInt:_productID],
             COLUMN_PRODUCT_NAME : _productName,
             COLUMN_PRODUCT_IMAGE_URL : _productImageURL,
             COLUMN_PRODUCT_LOCAL_IMAGE : _productLocalImage,
             COLUMN_PRODUCT_PRICE : [NSNumber numberWithDouble:_productPrice],
             COLUMN_PRODUCT_ORDER : [NSNumber numberWithInt:_productOrder],
             COLUMN_PRODUCT_MAX_QUANTITY : [NSNumber numberWithInt:_productMaxQuantity],
             TABLE_CATEGORY : @{
                     COLUMN_CATEGORY_ID: [NSNumber numberWithInt:_productCategory.categoryID],
                     COLUMN_CATEGORY_NAME: _productCategory.categoryName,
                     COLUMN_CATEGORY_ORDER: [NSNumber numberWithInt:_productCategory.categorySortOrder]
                     }
             };
}

@end
