//
//  ViewController.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 09/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeProductListTableViewCell.h"

@interface HomeViewController (){
    NSDictionary *productsData;
    NSDictionary *categoriesData;
}

@end

@implementation HomeViewController

static NSString *cellIdentifier = @"HomeProductList";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadProductData];
    [self initializeTableSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)initializeTableSettings{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 84.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeProductListTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadProductData{
    NSArray *productsAndCategoryData = [Products getProductsWithCategory];
    categoriesData = [productsAndCategoryData firstObject];
    productsData = [productsAndCategoryData lastObject];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[productsData allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *keyCat = [[productsData allKeys] objectAtIndex:section];
    return [[productsData objectForKey:keyCat] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSString *keyCat = [[productsData allKeys] objectAtIndex:indexPath.section];
    ProductEntity *productData = [[productsData objectForKey:keyCat] objectAtIndex:indexPath.row];
    [cell.productImageView setImage:[UIImage imageNamed:PRODUCT_PLACEHOLDER_IMAGE_NAME]];
    cell.name.text = productData.productName;
    cell.price.text = [NSString stringWithFormat:@"Rs %.02f", productData.productPrice];
    return cell;
}

@end
