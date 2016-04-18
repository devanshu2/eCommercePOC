//
//  CartViewController.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EComButton.h"
#import "ProductEntity.h"

@protocol CartViewProductDelegate <NSObject>

- (void)moveToProductPageForProduct:(ProductEntity*)product;

@end

@interface CartViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIPickerView *quantityPicker;
@property (strong, nonatomic) IBOutlet UIButton *quantityPickerUpdate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pickerViewBottomCons;
@property (nonatomic, weak) id <CartViewProductDelegate> delegate;

@end
