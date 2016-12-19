/*
  This code was generated in Neonto Studio Personal Edition:
  
    http://www.neonto.com
  
  You may use this code ONLY for non-commercial purposes and evaluation.
  Reusing any part of this code for commercial purposes is not permitted.
  
  Would you like to remove this restriction?
  With Neonto's flexible licensing options, you can have your own copyright
  in all this code.
  
  Find out more -- click 'Upgrade to Pro' in Neonto Studio's toolbar.
  


  This is a base class for data sheets exported from Neonto Studio.
  It provides basic functionality for updating data and loading images.
  
*/



#import <UIKit/UIKit.h>

@interface PREDataSheet : NSObject {
    NSMutableArray *_rows;
    NSString *_dataSheetPath;
    NSString *_documentsPath;
    NSString *_persistenceName;
}

@property (atomic) NSString *sheetId;

@property (atomic) NSArray *rows;

@property (atomic) NSUUID *latestLoadId;  // used to detect whether a load is still valid on completion


- (id)initWithSheetId:(NSString *)sheetId;


// This method returns pointer to a data task object if the loading is
// asynchronous (i.e. image is loaded from a web source).
- (id)loadImageForColumnNamed:(NSString *)col
                        atRow:(NSInteger)rowIdx
            completionHandler:(void (^)(UIImage *image))done;

- (void)saveRowWithValues:(NSDictionary *)values;
- (void)updateRow:(NSInteger)row withValues:(NSDictionary *)values;
- (void)replaceRow:(NSInteger)row with:(NSDictionary *)rowDesc;
- (void)deleteRow:(NSInteger)row;

- (void)takeRowsFromJSONArray:(NSArray *)jsonArr;
- (NSArray *)JSONArrayFromRows;

- (void)cloudLoginWasCompleted;

- (void)releaseCachedData;

// methods for subclasses
- (void)notifyRowsModified;
- (void)loadRowsWithPersistenceName:(NSString *)persistenceName;
- (void)writeDefaultRowData;

@end
