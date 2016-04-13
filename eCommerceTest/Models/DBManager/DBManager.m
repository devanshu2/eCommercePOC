//
//  DBManager.m
//  SQLite3DBSample
//
//  Created by Gabriel Theodoropoulos on 25/6/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>


@interface DBManager()

@property (nonatomic, strong) NSString *documentsDirectory;

@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *arrResults;


-(void)copyDatabaseIntoDocumentsDirectory;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end


@implementation DBManager

#pragma mark - Initialization

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static DBManager *theInstance;
    dispatch_once(&onceToken, ^{
        theInstance = [[DBManager alloc] initWithDatabaseFilename:DBFileName];
    });
    return theInstance;
}

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self) {
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Keep the database filename.
        self.databaseFilename = dbFilename;
        
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

#pragma mark - Private method implementation

- (void)initWithSampleData{
    NSArray *categoryTableSampleData = @[
                                         @{COLUMN_CATEGORY_ID : @1, COLUMN_CATEGORY_NAME : @"Electronics", COLUMN_CATEGORY_ORDER : @0},
                                         @{COLUMN_CATEGORY_ID : @2, COLUMN_CATEGORY_NAME : @"Furniture", COLUMN_CATEGORY_ORDER : @1}
                                         ];
    NSArray *productsTableSampleData = @[
                                         @{COLUMN_PRODUCT_ID : @1, COLUMN_PRODUCT_NAME : @"Microwave oven", COLUMN_PRODUCT_IMAGE_URL : @"https://s20.postimg.org/em55k8szx/microwave-oven.jpg", COLUMN_PRODUCT_PRICE : @9499, COLUMN_PRODUCT_CATEGORY : @1},
                                         @{COLUMN_PRODUCT_ID : @2, COLUMN_PRODUCT_NAME : @"Television", COLUMN_PRODUCT_IMAGE_URL : @"https://s20.postimg.org/lo336fwlp/tv.jpg", COLUMN_PRODUCT_PRICE : @12000, COLUMN_PRODUCT_CATEGORY : @1},
                                         @{COLUMN_PRODUCT_ID : @3, COLUMN_PRODUCT_NAME : @"Vacuum Cleaner", COLUMN_PRODUCT_IMAGE_URL : @"https://s20.postimg.org/j5he5ravh/vacuum-cleaner.jpg", COLUMN_PRODUCT_PRICE : @6499, COLUMN_PRODUCT_CATEGORY : @1},
                                         @{COLUMN_PRODUCT_ID : @4, COLUMN_PRODUCT_NAME : @"Table", COLUMN_PRODUCT_IMAGE_URL : @"https://s20.postimg.org/rmcb2xq6l/table.jpg", COLUMN_PRODUCT_PRICE : @3999, COLUMN_PRODUCT_CATEGORY : @2},
                                         @{COLUMN_PRODUCT_ID : @5, COLUMN_PRODUCT_NAME : @"Chair", COLUMN_PRODUCT_IMAGE_URL : @"https://s20.postimg.org/tzl22gpu5/chair.jpg", COLUMN_PRODUCT_PRICE : @1499, COLUMN_PRODUCT_CATEGORY : @2},
                                         @{COLUMN_PRODUCT_ID : @6, COLUMN_PRODUCT_NAME : @"Almirah", COLUMN_PRODUCT_IMAGE_URL : @"https://s20.postimg.org/rxtrfp6ml/almirah.jpg", COLUMN_PRODUCT_PRICE : @8999, COLUMN_PRODUCT_CATEGORY : @2}
                                         ];
    for (NSDictionary *categoryData in categoryTableSampleData) {
        int categoryID = [[categoryData objectForKey:COLUMN_CATEGORY_ID] intValue];
        NSString *categoryName = [categoryData objectForKey:COLUMN_CATEGORY_NAME];
        int categorySortOrder = [[categoryData objectForKey:COLUMN_CATEGORY_ORDER] intValue];
        [self insertRecordInProductCategoryWithID:categoryID Name:categoryName andCategorySoryOrder:categorySortOrder];
    }
    
    for (NSDictionary *productData in productsTableSampleData) {
        int productID = [[productData objectForKey:COLUMN_PRODUCT_ID] intValue];
        NSString *productName = [productData objectForKey:COLUMN_PRODUCT_NAME];
        NSString *productImageURL = [productData objectForKey:COLUMN_PRODUCT_IMAGE_URL];
        double productPrice = [[productData objectForKey:COLUMN_PRODUCT_PRICE] doubleValue];
        int productCategoryID = [[productData objectForKey:COLUMN_PRODUCT_CATEGORY] intValue];
        [self insertRecordInProductWithID:productID Name:productName Image:productImageURL Price:productPrice andCategory:productCategoryID];
    }
}

-(void)insertRecordInProductCategoryWithID:(int)categoryID Name:(NSString *)categoryName andCategorySoryOrder:(int)categorySortOrder{
    // Create a sqlite object.
    sqlite3 *sqlite3Database;
    
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    NSString *theQuery = [NSString stringWithFormat:@"INSERT INTO %@(%@, %@, %@) VALUES(?,?,?)", TABLE_CATEGORY, COLUMN_CATEGORY_ID, COLUMN_CATEGORY_NAME, COLUMN_CATEGORY_ORDER];
    const char *query = [theQuery UTF8String];
    
    // Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        // Load all data from database to memory.
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            
            sqlite3_bind_int(compiledStatement, 1, categoryID);
            sqlite3_bind_text(compiledStatement, 2, [categoryName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 3, categorySortOrder);
            
            int executeQueryResults = sqlite3_step(compiledStatement);
            if (executeQueryResults == SQLITE_DONE) {
                // Keep the affected rows.
                self.affectedRows = sqlite3_changes(sqlite3Database);
                
                // Keep the last inserted row ID.
                self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                NSLog(@"last Inserted Row ID for Category: %lld", self.lastInsertedRowID);
            }
            else {
                // If could not execute the query show the error message on the debugger.
                NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Close the database.
    sqlite3_close(sqlite3Database);
}

-(void)insertRecordInProductWithID:(int)productID Name:(NSString *)productName Image:(NSString *)productImageURL Price:(double)productPrice andCategory:(int)productCategoryID{
    // Create a sqlite object.
    sqlite3 *sqlite3Database;
    
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    NSString *theQuery = [NSString stringWithFormat:@"INSERT INTO %@(%@, %@, %@, %@, %@) VALUES(?,?,?,?,?)", TABLE_PRODUCT, COLUMN_PRODUCT_ID, COLUMN_PRODUCT_NAME, COLUMN_PRODUCT_IMAGE_URL, COLUMN_PRODUCT_PRICE, COLUMN_PRODUCT_CATEGORY];
    const char *query = [theQuery UTF8String];
    
    // Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        // Load all data from database to memory.
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            
            sqlite3_bind_int(compiledStatement, 1, productID);
            sqlite3_bind_text(compiledStatement, 2, [productName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 3, [productImageURL UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_double(compiledStatement, 4, productPrice);
            sqlite3_bind_int(compiledStatement, 5, productCategoryID);
            
            int executeQueryResults = sqlite3_step(compiledStatement);
            if (executeQueryResults == SQLITE_DONE) {
                // Keep the affected rows.
                self.affectedRows = sqlite3_changes(sqlite3Database);
                
                // Keep the last inserted row ID.
                self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                NSLog(@"last Inserted Row ID for Product: %lld", self.lastInsertedRowID);
            }
            else {
                // If could not execute the query show the error message on the debugger.
                NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Close the database.
    sqlite3_close(sqlite3Database);
}

-(void)copyDatabaseIntoDocumentsDirectory{
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    NSLog(@"DB Path: %@", destinationPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            [self initWithSampleData];
        }
    }
}



-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
	// Create a sqlite object.
	sqlite3 *sqlite3Database;
	
    // Set the database file path.
	NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Initialize the results array.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
	self.arrResults = [[NSMutableArray alloc] init];
    
    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
	// Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
	if(openDatabaseResult == SQLITE_OK) {
		// Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
		sqlite3_stmt *compiledStatement;
		
        // Load all data from database to memory.
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
		if(prepareStatementResult == SQLITE_OK) {
			// Check if the query is non-executable.
			if (!queryExecutable){
                // In this case data must be loaded from the database.
                
                // Declare an array to keep the data for each fetched row.
                NSMutableArray *arrDataRow;
                
				// Loop through the results and add them to the results array row by row.
				while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
					// Initialize the mutable array that will contain the data of a fetched row.
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // Get the total number of columns.
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Go through all columns and fetch each column data.
					for (int i=0; i<totalColumns; i++){
                        // Convert the column data to text (characters).
						char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
						if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
							[arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
						}
                        
                        // Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
					
					// Store each fetched data row in the results array, but first check if there is actually data.
					if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
					}
				}
			}
			else {
                // This is the case of an executable query (insert, update, ...).
                
				// Execute the query.
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
				}
				else {
					// If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
				}
			}
		}
		else {
            // In the database cannot be opened then show the error message on the debugger.
			NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
		}
		
		// Release the compiled statement from memory.
		sqlite3_finalize(compiledStatement);
		
	}
    
    // Close the database.
	sqlite3_close(sqlite3Database);
}


#pragma mark - Public method implementation

-(NSArray *)loadDataFromDB:(NSString *)query{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Returned the loaded results.
    return (NSArray *)self.arrResults;
}


-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

@end
