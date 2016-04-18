//
//  Product.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 10/04/16.
//  Copyright © 2016 Devanshu Saini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductCategoryEntity.h"

@interface ProductEntity : NSObject

@property (nonatomic, assign) int productID;
@property (nonatomic, assign) int productOrder;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productImageURL;
@property (nonatomic, strong) NSString *productLocalImage;
@property (nonatomic, assign) double productPrice;
@property (nonatomic, assign) int productMaxQuantity;
@property (nonatomic, strong) ProductCategoryEntity *productCategory;
@property (nonatomic, readonly, getter=getProductData) NSDictionary* productDictionaryData;

/*!
 * @discussion Instance of class using its attributes
 * @param productID of type int
 * @param productOrder of type int
 * @param productName of type NSString
 * @param productImageURL of type NSString
 * @param productLocalImage of type NSString
 * @param productPrice of type double
 * @param productMaxQuantity of type int
 * @param productCategory of type ProductCategoryEntity
 * @return ProductEntity instance
 */
- (instancetype)initWithProductID:(int)productID Name:(NSString *)productName Image:(NSString *)productImageURL LocalImage:(NSString*)productLocalImage MaxQuantity:(int)productMaxQuantity Price:(double)productPrice Category:(ProductCategoryEntity *)productCategory andProductOrder:(int)productOrder;

/*!
 * @discussion Instance of class using its attributes dictionary
 * @param productDictionaryData of type NSDictionary
 * @return ProductEntity instance
 */
- (instancetype)initWithProductDictionaryData:(NSDictionary*)productDictionaryData;

@end
