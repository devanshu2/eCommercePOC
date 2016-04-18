//
//  Products.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import "Products.h"

@implementation Products

+ (NSArray*)getProductsWithCategory{
    NSString *sqlQuery = @"SELECT * FROM product left join category on product_category = cat_id order by cat_order, product_order";
    NSArray *dbData = [[DBManager sharedInstance] loadDataFromDB:sqlQuery];
    NSMutableDictionary *productData = [@{} mutableCopy];
    NSMutableDictionary *categoryData = [@{} mutableCopy];
    for (NSDictionary *dataElement in dbData) {
        ProductCategoryEntity *theCategory = [[ProductCategoryEntity alloc] initWithID:[[dataElement objectForKey:COLUMN_CATEGORY_ID] intValue] Name:[dataElement objectForKey:COLUMN_CATEGORY_NAME] andSortOrder:[[dataElement objectForKey:COLUMN_CATEGORY_ORDER] intValue]];
        
        ProductEntity *theProduct = [[ProductEntity alloc] initWithProductID:[[dataElement objectForKey:COLUMN_PRODUCT_ID] intValue] Name:[dataElement objectForKey:COLUMN_PRODUCT_NAME] Image:[dataElement objectForKey:COLUMN_PRODUCT_IMAGE_URL] LocalImage:[dataElement objectForKey:COLUMN_PRODUCT_LOCAL_IMAGE] MaxQuantity:[[dataElement objectForKey:COLUMN_PRODUCT_MAX_QUANTITY] intValue] Price:[[dataElement objectForKey:COLUMN_PRODUCT_PRICE] doubleValue] Category:theCategory andProductOrder:[[dataElement objectForKey:COLUMN_PRODUCT_ORDER] intValue]];
        NSString *catIDString = [NSString stringWithFormat:@"%d",theCategory.categoryID];
        if ([productData objectForKey:catIDString]) {
            NSMutableArray *theProducts = [productData objectForKey:catIDString];
            [theProducts addObject:theProduct];
            [productData setObject:theProducts forKey:catIDString];
        }
        else{
            [productData setObject:[@[theProduct] mutableCopy] forKey:catIDString];
            [categoryData setObject:theCategory forKey:catIDString];
        }
    }
    return @[categoryData, productData];
}

@end
