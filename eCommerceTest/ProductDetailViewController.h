//
//  ProductDetailViewController.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devanshu Saini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductEntity.h"
#import "CartViewController.h"

@interface ProductDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, CartViewProductDelegate>

@property (nonatomic, strong) IBOutlet UITableView *theTable;
@property (nonatomic, weak) IBOutlet UIButton *addToCartButton;
@property (nonatomic, strong) ProductEntity *theProduct;
@property (weak, nonatomic) IBOutlet UILabel *productQuantity;


@end
