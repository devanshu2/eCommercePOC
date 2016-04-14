//
//  ProductDetailViewController.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductEntity.h"

@interface ProductDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *theTable;
@property (nonatomic, weak) IBOutlet UIButton *addToCartButton;
@property (nonatomic, weak) IBOutlet UILabel *cartMessageLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *addToCartButtonTopCons;
@property (nonatomic, strong) ProductEntity *theProduct;

@end
