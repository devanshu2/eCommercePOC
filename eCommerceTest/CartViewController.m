//
//  CartViewController.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import "CartViewController.h"
#import "CartManager.h"
#import "ProductEntity.h"

#define KEY_PRODUCT @"product"
#define KEY_QUANTITY @"quantity"

@interface CartViewController (){
    NSInteger pickerNumberOfRows;
}

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewItems];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setViewControllerNavigationBar];
    [self setupCart];
}

#pragma mark - Private Methods

- (void)setupCart{
    NSArray *products = [[CartManager sharedInstance] getProductsInCart];
    NSMutableArray *tableData = [@[] mutableCopy];
    for (NSDictionary *productData in products) {
        ProductEntity *product = [[ProductEntity alloc] initWithProductDictionaryData:productData];
        NSDictionary *dataElement = @{KEY_PRODUCT : product, KEY_QUANTITY : [productData objectForKey:COLUMN_CART_QUANTITY]};
        [tableData addObject:dataElement];
    }
    NSLog(@"%@", products);
}

- (void)initViewItems{
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    pickerNumberOfRows = 1;
}

- (void)setViewControllerNavigationBar{
    self.navigationItem.title = @"Cart";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonAction)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)cancelButtonAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pickerNumberOfRows;
}

#pragma mark - UIPickerViewDelegate Methods

// returns width of column and height of row for each component.
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld", (long)row];
}

@end
