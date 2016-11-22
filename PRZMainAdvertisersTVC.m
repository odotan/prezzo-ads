//
//  PRZMainAdvertisersTVC.m
//  PREZZO
//
//  Created by Itay Pincas on 11/21/16.
//  Copyright © 2016 Itay Pincas. All rights reserved.
//

#import "PRZMainAdvertisersTVC.h"
#import "PRZMainAdvertiserCell.h"

@interface PRZMainAdvertisersTVC () {
    
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSString *element;
    NSString *imageURL;
    NSMutableString *description;
    NSMutableDictionary *rowInfo;
    
    NSMutableArray *contentList,*searchResults,*tableList;
    NSMutableData *responseData;
    NSMutableDictionary *imageList;
    NSMutableDictionary *contentListDict;
    
    
}



@end

@implementation PRZMainAdvertisersTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar-icon-mini.png"]];
    
    contentList=[[NSMutableArray alloc] init];
    imageList=[[NSMutableDictionary alloc] init];
    
    [self.refreshControl beginRefreshing];
    
    [self loadJSONFromServer];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    rowInfo = [contentList objectAtIndex:indexPath.row];
    
//    NSString *itemURL = [rowInfo objectForKey:@"url"];
//    itemURL = [itemURL stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//    itemURL = [itemURL stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    itemURL = [itemURL stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    NSLog(@"itemURL: *%@*", itemURL);
//    
//    [[NSUserDefaults standardUserDefaults] setObject:itemURL forKey:@"currentItemLink"];
//    NSString *titleLabelStr = [[rowInfo objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
//    [[NSUserDefaults standardUserDefaults] setObject:titleLabelStr forKey:@"currentItemTitle"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"this is being called");
    
    static NSString *CellIdentifier = @"Cell";
    PRZMainAdvertiserCell *cell = (PRZMainAdvertiserCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        //cell = [[ItayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSLog(@"untill here");
    
    rowInfo = [contentList objectAtIndex:indexPath.row];
    
    NSLog(@"rowInfo: %@", rowInfo);
    
//    NSString *titleLabelStr = [[rowInfo objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
//    titleLabelStr = [titleLabelStr stringByReplacingOccurrencesOfString:@"&#8211;" withString:@""];
//    
//    [cell.cellTitleLabel setText:titleLabelStr];
//    
//    NSString *descriptionLabelStr = [[rowInfo objectForKey:@"excerpt"] stringByReplacingOccurrencesOfString:@"ת&#34;א" withString:@"ת״א"];
//    
//    descriptionLabelStr = [descriptionLabelStr stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
//    descriptionLabelStr = [descriptionLabelStr stringByReplacingOccurrencesOfString:@";&quot" withString:@"\""];
//    descriptionLabelStr = [descriptionLabelStr stringByReplacingOccurrencesOfString:@"</p>" withString:@"\""];
//    descriptionLabelStr = [descriptionLabelStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
//    descriptionLabelStr = [descriptionLabelStr stringByReplacingOccurrencesOfString:@"&#8211;" withString:@""];
//    descriptionLabelStr = [descriptionLabelStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    
//    
//    
//    
//    [cell.cellDescriptionLabel setText:descriptionLabelStr];
//    
//    
//    
//    UIImage *img=[imageList objectForKey:[rowInfo objectForKey:@"thumbnail"] ];
//    NSString *imageOriginalLink = [rowInfo objectForKey:@"thumbnail"];
//    
//    if ([imageOriginalLink rangeOfString:@"null"].location == NSNotFound) {
//        NSLog(@"There is a picture for the user");
//        
//        if (img) {
//            
//            [cell.thmbnailView setImage:img];
//        } else {
//            cell.thmbnailView.image = [UIImage imageNamed:@"hta-news-default-200px.png"];
//            
//            [self loadImage:[rowInfo objectForKey:@"thumbnail"] forIndexPath:indexPath];
//            
//        }
//        
//    }else {
//        cell.thmbnailView.image = [UIImage imageNamed:@"hta-news-default-200px.png"];
//    }
    
    return cell;
}

//////// --- loading json methods --- ////////

-(void)loadImage:(NSString *)url forIndexPath:(NSIndexPath *)indexPath{
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        
        NSLog(@"downloading %@",url);
        NSURL *percentEscapedImageURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        NSData *data=[[NSData alloc] initWithContentsOfURL:percentEscapedImageURL];
        UIImage *img=[UIImage imageWithData:data];
        
        if (img) {
            
            [imageList setObject:img forKey:url];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // app crashes here
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
        }
        
    }];
    
}


// connection methods //



-(void)loadJSONFromServer{
    NSLog(@"hello");
    NSMutableURLRequest *httpRequest=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://firebasestorage.googleapis.com/v0/b/prezzo-4e452.appspot.com/o/advertisers.json?alt=media&token=eb70376a-5b14-48e2-acef-c1e2fca410db"]];
    
    [httpRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [httpRequest setHTTPMethod:@"GET"];
    NSString *hostURL = @"https://firebasestorage.googleapis.com";
    [httpRequest setAllowsAnyHTTPSCertificate:YES forHost:hostURL];

    
    NSURLConnection *con=[[NSURLConnection alloc] initWithRequest:httpRequest delegate:self];
    
    [con start];
    
}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *error;
    contentListDict = [[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"error : %@",error.localizedDescription);
        
        
    } else {
        contentListDict = [contentListDict objectForKey:@"posts"];
        NSLog(@"contentListDict: %@", contentListDict);
        contentList = contentListDict;
        
        [self.tableView reloadData];
    }
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"connection error : %@",error.localizedDescription);
    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Can't load the data..." message:@"The Internet connection appears to be offline. Check your connection or try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alertError show];
    
}

-(void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    [self loadJSONFromServer];
    
    // End the refreshing
    if (self.refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
        
    }
}


@end
