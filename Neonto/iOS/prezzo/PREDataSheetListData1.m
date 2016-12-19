#import "PREDataSheetListData1.h"

@implementation PREDataSheetListData1

- (id)init
{
    self = [super initWithSheetId:@"listData1"];
    
    // This data sheet doesn't have local persistence enabled in Neonto Studio,
    // so write the default data each time.
    [self writeDefaultRowData];

    return self;
}

- (void)writeDefaultRowData
{
    // This is the data from the sheet in the Neonto Studio project.
    
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableDictionary *row;

    row = [NSMutableDictionary dictionary];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column2"];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column3"];
    {
        NSString *key = @"list";
        NSString *json = @"";
        NSError *jsonErr = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonErr];
        if (jsonErr) {
            NSLog(@"** could not load json object for data sheet key '%@'", key);
        } else {
            [row setObject:@{ @"type": @"json", @"value": obj } forKey:key];
        }
    }
    [arr addObject:row];

    row = [NSMutableDictionary dictionary];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column2"];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column3"];
    {
        NSString *key = @"list";
        NSString *json = @"";
        NSError *jsonErr = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonErr];
        if (jsonErr) {
            NSLog(@"** could not load json object for data sheet key '%@'", key);
        } else {
            [row setObject:@{ @"type": @"json", @"value": obj } forKey:key];
        }
    }
    [arr addObject:row];

    row = [NSMutableDictionary dictionary];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column2"];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column3"];
    {
        NSString *key = @"list";
        NSString *json = @"";
        NSError *jsonErr = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonErr];
        if (jsonErr) {
            NSLog(@"** could not load json object for data sheet key '%@'", key);
        } else {
            [row setObject:@{ @"type": @"json", @"value": obj } forKey:key];
        }
    }
    [arr addObject:row];

    row = [NSMutableDictionary dictionary];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column2"];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column3"];
    {
        NSString *key = @"list";
        NSString *json = @"";
        NSError *jsonErr = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonErr];
        if (jsonErr) {
            NSLog(@"** could not load json object for data sheet key '%@'", key);
        } else {
            [row setObject:@{ @"type": @"json", @"value": obj } forKey:key];
        }
    }
    [arr addObject:row];

    row = [NSMutableDictionary dictionary];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column3"];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column2"];
    {
        NSString *key = @"list";
        NSString *json = @"";
        NSError *jsonErr = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonErr];
        if (jsonErr) {
            NSLog(@"** could not load json object for data sheet key '%@'", key);
        } else {
            [row setObject:@{ @"type": @"json", @"value": obj } forKey:key];
        }
    }
    [arr addObject:row];

    row = [NSMutableDictionary dictionary];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column2"];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column3"];
    {
        NSString *key = @"list";
        NSString *json = @"";
        NSError *jsonErr = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonErr];
        if (jsonErr) {
            NSLog(@"** could not load json object for data sheet key '%@'", key);
        } else {
            [row setObject:@{ @"type": @"json", @"value": obj } forKey:key];
        }
    }
    [arr addObject:row];

    row = [NSMutableDictionary dictionary];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column2"];
    [row setObject:@{ @"type": @"text", @"value": @"" } forKey:@"column3"];
    {
        NSString *key = @"list";
        NSString *json = @"";
        NSError *jsonErr = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonErr];
        if (jsonErr) {
            NSLog(@"** could not load json object for data sheet key '%@'", key);
        } else {
            [row setObject:@{ @"type": @"json", @"value": obj } forKey:key];
        }
    }
    [arr addObject:row];
    
    self.rows = arr;
}

@end
