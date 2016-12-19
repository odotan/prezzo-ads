#import "PREDataSheet.h"




@interface PREDataSheet ()
@property (atomic) NSMutableDictionary *cachedImages;

@end



static NSDictionary *convertJSONObjectToDataSheetRow(NSDictionary *obj)
{
    if ( ![obj isKindOfClass:[NSDictionary class]])
        return [NSDictionary dictionary];

    NSMutableDictionary *row = [NSMutableDictionary dictionary];
    
    for (NSString *key in obj) {
        id val = [obj objectForKey:key];
        
        NSString *colType;
        id cellValue;
        
        if ([val isKindOfClass:[NSArray class]]) {
            colType = @"json";
            cellValue = val;
        }
        else if ([val isKindOfClass:[NSDictionary class]]) {
            colType = @"json";
            cellValue = val;
        }
        else {
            colType = @"text";
            cellValue = [val description];
        }
        
        [row setObject:@{ @"type": colType, @"value": cellValue } forKey:key];
    }
    
    return row;
}

static NSDictionary *convertDataSheetRowToJSONObject(NSDictionary *row)
{
    if ( ![row isKindOfClass:[NSDictionary class]])
        return [NSDictionary dictionary];
    
    NSMutableDictionary *obj = [NSMutableDictionary dictionary];
    
    for (NSString *key in row) {
        id val = [row objectForKey:key];
        NSString *type = val[@"type"];
        id value = val[@"value"];
        
        id jsonValue;
        
        if ([type isEqualToString:@"image"]) {
            // ignore images when writing to JSON
        }
        else if ([type isEqualToString:@"json"]) {
            jsonValue = value;
        }
        else {
            jsonValue = [value description];
        }
        
        obj[key] = jsonValue;
    }
    
    return obj;
}


static NSString *stripDocumentsPath(NSString *path)
{
    return ([path hasPrefix:@"documents://"]) ? [path substringFromIndex:12] : nil;
}



@implementation PREDataSheet

- (id)initWithSheetId:(NSString *)sheetId
{
    self = [super init];

    _sheetId = sheetId;

    _rows = [NSMutableArray array];

    _documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

    self.cachedImages = [NSMutableDictionary dictionary];

    

    return self;
}

- (void)loadRowsWithPersistenceName:(NSString *)persistenceName
{
    _persistenceName = persistenceName;
    
    _dataSheetPath = [_documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"dataSheet_%@.dat", _persistenceName]];
    
    self.rows = [NSMutableArray arrayWithContentsOfFile:_dataSheetPath];
    if (!self.rows) {
        [self writeDefaultRowData];
    }
}

// This method is called by web service plugins when they've completed login
// and want to sync data to the service.
- (void)cloudLoginWasCompleted
{
    [self _save];
}

- (void)writeDefaultRowData
{
    NSMutableArray *arr = [NSMutableArray array];
    self.rows = arr;
}

- (NSArray *)rows
{
    return _rows;
}

- (void)setRows:(NSArray *)rows
{
    if (rows && ![rows isKindOfClass:[NSMutableArray class]])
        rows = [rows mutableCopy];
    
    _rows = (NSMutableArray *)rows;
}

- (id)loadImageForColumnNamed:(NSString *)col atRow:(NSInteger)rowIdx completionHandler:(void (^)(UIImage *image))done
{
    if ( !col || rowIdx < 0 || rowIdx >= self.rows.count) {
        done(nil);
        return nil;
    }
    
    NSDictionary *row = [self.rows objectAtIndex:rowIdx];
    NSDictionary *cell = [row objectForKey:col];
    if ( ![[cell objectForKey:@"type"] isEqualToString:@"image"]) {
        done(nil);
        return nil;
    }
    
    NSString *url = [cell objectForKey:@"value"];
    
    UIImage *image = [self.cachedImages objectForKey:url];
    if (image) {
        done(image);
        return nil;
    }

    if ([url hasPrefix:@"asset://"]) {
        done([UIImage imageNamed:[url substringFromIndex:8]]);
        return nil;
    }
    else if ([url hasPrefix:@"documents://"]) {
        done([UIImage imageWithContentsOfFile:[_documentsPath stringByAppendingPathComponent:stripDocumentsPath(url)]]);
        return nil;
    }
    else if ([url hasPrefix:@"http"]) {
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data) {
                //NSLog(@"loaded image data: %ld", (long)data.length);
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    [self.cachedImages setObject:image forKey:url];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    done(image);
                });
            }
        }];
        [task resume];
        return task;
    }
    done(nil);
    return nil;
}

- (void)notifyRowsModified
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataSheetModified" object:self];
}

- (void)takeRowsFromJSONArray:(NSArray *)jsonArr
{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (id obj in jsonArr) {
        [arr addObject:convertJSONObjectToDataSheetRow(obj)];
    }
    
    self.rows = arr;
}

- (NSArray *)JSONArrayFromRows
{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSDictionary *row in self.rows) {
        [arr addObject:convertDataSheetRowToJSONObject(row)];
    }
    
    return arr;
}


- (void)saveRowWithValues:(NSDictionary *)values
{
    [self updateRow:[_rows count] withValues:values];
}

- (void)updateRow:(NSInteger)row withValues:(NSDictionary *)values
{
    const BOOL newEntry = row >= [_rows count];
    
    NSMutableDictionary *rowDesc = (newEntry) ? [NSMutableDictionary dictionary] : [self.rows objectAtIndex:row];
    for (NSString *key in values) {
        id val = [values objectForKey:key];
        if ([val isKindOfClass:[NSString class]]) {
            [rowDesc setObject:@{ @"type": @"text", @"value": val } forKey:key];
        }
        else if ([val isKindOfClass:[UIImage class]]) {
            NSString *fileName = (newEntry) ? [self _determineFilenameForImageWithName:key] : stripDocumentsPath([[[_rows objectAtIndex:row] objectForKey:key] objectForKey:@"value"]);
            [UIImagePNGRepresentation([self _prepareImageForSaving:val]) writeToFile:[_documentsPath stringByAppendingPathComponent:fileName] options:0 error:nil];
            [rowDesc setObject:@{ @"type": @"image", @"value": [NSString stringWithFormat:@"documents://%@", fileName] } forKey:key];
        }
        else if ([val isKindOfClass:[NSArray class]] || [val isKindOfClass:[NSDictionary class]]) {
            [rowDesc setObject:@{ @"type": @"json", @"value": val } forKey:key];
        }
    }
    
    @synchronized(self) {
        if (newEntry) {
            [_rows insertObject:rowDesc atIndex:0];
        }
    }
    
    [self _save];
}

- (void)replaceRow:(NSInteger)row with:(NSDictionary *)rowDesc
{
    @synchronized(self) {
        [_rows replaceObjectAtIndex:row withObject:rowDesc];
    }
    
    [self _save];
}

- (void)deleteRow:(NSInteger)row
{
    // delete image files.
    NSDictionary *rowDesc = [_rows objectAtIndex:row];
    for (NSString *key in rowDesc) {
        NSDictionary *elementDesc = [rowDesc objectForKey:key];
        if ([[elementDesc objectForKey:@"type"] isEqualToString:@"image"]) {
            NSString *value = stripDocumentsPath([elementDesc objectForKey:@"value"]);
            if (value) {
                [[NSFileManager defaultManager] removeItemAtPath:[_documentsPath stringByAppendingPathComponent:value] error:NULL];
            }
        }
    }
    
    [_rows removeObjectAtIndex:row];
    
    [self _save];
}

- (void)releaseCachedData
{
    self.cachedImages = [NSMutableDictionary dictionary];
}

- (NSString *)_determineFilenameForImageWithName:(NSString *)name
{
    NSString *file = [NSString stringWithFormat:@"dataSheet_%@++%@++", _persistenceName, name];
    NSString *ext = @".png";
    
    long index = 0;
    for (NSDictionary *rowDesc in _rows) {
        for (NSString *key in rowDesc) {
            NSDictionary *elementDesc = [rowDesc objectForKey:key];
            if ([[elementDesc objectForKey:@"type"] isEqualToString:@"image"]) {
                NSString *value = stripDocumentsPath([elementDesc objectForKey:@"value"]);
                if (value) {
                    if ([value hasPrefix:file] && [value hasSuffix:ext]) {
                        index = MAX(index, [[value substringWithRange:NSMakeRange([file length], [value length]-[file length]-[ext length])] intValue]);
                    }
                }
            }
        }
    }
    
    return [NSString stringWithFormat:@"%@%ld%@", file, index+1, ext];
}

- (UIImage *)_prepareImageForSaving:(UIImage *)image
{
    const CGFloat maxDim = 1200;
    
    CGSize size = image.size;
    if (size.width > maxDim || size.height > maxDim) {
        CGFloat sc = MIN(maxDim / size.width, maxDim / size.height);
        size.width = floorf(size.width * sc);
        size.height = floorf(size.height * sc);
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

- (void)_save
{
    [self.rows writeToFile:_dataSheetPath atomically:YES];


}

@end
