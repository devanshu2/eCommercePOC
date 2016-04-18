//
//  ViewController.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 09/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeProductListTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AppOptions.h"
#import "ProductDetailViewController.h"
#import "CartNavItem.h"
#import "CartManager.h"

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCartButtonInNavigationBar:) name:CART_COUNT_NOTIFICATION object:nil];
    [self setViewControllerNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CART_COUNT_NOTIFICATION object:nil];
}

#pragma mark - Private Methods

- (void)setViewControllerNavigationBar{
    self.navigationItem.title = @"Home";
    [self updateCartButtonInNavigationBar:nil];
}

- (void)updateCartButtonInNavigationBar:(NSNotification*)notification{
    NSInteger cartCount = notification ? [notification.object integerValue] : [[[CartManager sharedInstance] getProductsInCart] count];
    CartNavItem *cartNavBar = (CartNavItem*)[[[NSBundle mainBundle] loadNibNamed:@"CartNavItem" owner:self options:nil] firstObject];
    [cartNavBar setCartCount:cartCount];
    [cartNavBar setFrame:CGRectMake(0.0, 0.0, [cartNavBar getViewWidth], 30.0)];
    UITapGestureRecognizer *cartTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentModalOfCart)];
    cartTap.numberOfTapsRequired = 1;
    [cartNavBar addGestureRecognizer:cartTap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cartNavBar];
}

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
    if (USE_LOCAL_PRODUCT_IMAGES) {
        [cell.productImageView setImage:[UIImage imageNamed:productData.productLocalImage]];
    }
    else{
        [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:productData.productImageURL] placeholderImage:[UIImage imageNamed:PRODUCT_PLACEHOLDER_IMAGE_NAME]];
    }
    cell.name.text = productData.productName;
    cell.price.text = [NSString stringWithFormat:@"%@ %.02f", CURRENCY_SYMBOL, productData.productPrice];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *keyCat = [[categoriesData allKeys] objectAtIndex:section];
    ProductCategoryEntity *productCategory = [categoriesData objectForKey:keyCat];
    return productCategory.categoryName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *keyCat = [[productsData allKeys] objectAtIndex:indexPath.section];
    ProductEntity *productData = [[productsData objectForKey:keyCat] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"productDetailSegue" sender:productData];
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"productDetailSegue"])
    {
        ProductDetailViewController *productDetailController = segue.destinationViewController;
        productDetailController.theProduct = (ProductEntity*)sender;
    }
    else if ([[segue identifier] isEqualToString:@"modalSegue1"])
    {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navController = segue.destinationViewController;
            if ([navController.childViewControllers lastObject]) {
                CartViewController *cartViewController = [navController.childViewControllers lastObject];
                cartViewController.delegate = self;
            }
        }
    }
}

- (void)presentModalOfCart{
    [self performSegueWithIdentifier:@"modalSegue1" sender:nil];
}

#pragma mark - CartViewProductDelegate Methods

- (void)moveToProductPageForProduct:(ProductEntity*)product{
    [self performSegueWithIdentifier:@"productDetailSegue" sender:product];
}

@end
