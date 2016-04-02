//
//  webServiceHelper.m
//  Employee
//
//  Created by Country Club on 02/11/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import "webServiceHelper.h"
#import "SalesViewController.h"

@implementation webServiceHelper
#define URL1            @"http://www.ccilsupport.com/empapp/ejson.php"  // change this URL
#define URlAtt @"http://192.168.1.40/attendence.php?"

//http://www.ccilsupport.com/empapp/ejson.php?username=cci1235&db=ccindia
+(instancetype)sharedWebService
{
    static webServiceHelper *_sharedWS = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWS = [[webServiceHelper alloc] init];
    });
    return _sharedWS;
}


#define salesurl @"http://countryclubworld.com/badriapp/index.php/add_details"

 // @"http://countryclubworld.com/badriapp/index.php"
-(void)postSalesDataDic:(NSDictionary *)dic completionBlock:(void(^)(NSMutableArray *array,NSInteger stastuscode, NSError *err))completionHandler;
 
{
    
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

    
    //NSLog(@"dic bbbbbb is %@ ",dic);
    
    [_gAppDelegate showLoadingView:YES activityTitle:@"Loading"];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *uid=app.string_uid;
    //NSLog(@"dic bbbbbb is %@ ",uid);

    
    
        NSMutableDictionary *jsonDict=[NSMutableDictionary new];
        
        [jsonDict setObject:[dic objectForKey:@"DOB"] forKey:@"dob"];
        [jsonDict setObject:[dic objectForKey:@"Member Name"] forKey:@"mem_name"];
        [jsonDict setObject:[dic objectForKey:@"Address Line1"] forKey:@"add1"];
       [jsonDict setObject:[dic objectForKey:@"Address Line2"] forKey:@"add2"];
    [jsonDict setObject:[dic objectForKey:@"Pincode"] forKey:@"pincode"];
    [jsonDict setObject:[dic objectForKey:@"intro Member"] forKey:@"intro"];
    [jsonDict setObject:[dic objectForKey:@"Agreement No"] forKey:@"agreement"];
    [jsonDict setObject:[dic objectForKey:@"Additional Benfits"] forKey:@"benifit"];
    [jsonDict setObject:[dic objectForKey:@"Mobile"] forKey:@"mobile"];
    [jsonDict setObject:[dic objectForKey:@"Spouse Name"] forKey:@"spouse"];
    [jsonDict setObject:[dic objectForKey:@"Father Name"] forKey:@"parent"];
    [jsonDict setObject:[dic objectForKey:@"Child1 Name"] forKey:@"child"];
    [jsonDict setObject:[dic objectForKey:@"Email"] forKey:@"email"];
    [jsonDict setObject:uid forKey:@"userid"];
    [jsonDict setObject:[dic objectForKey:@"Venue"] forKey:@"venue"];
    [jsonDict setObject:[dic objectForKey:@"club"] forKey:@"cat"];
    [jsonDict setObject:[dic objectForKey:@"Mem Fee"] forKey:@"price"];
    [jsonDict setObject:[dic objectForKey:@"Towards Mem Fee No"] forKey:@"tmf"];
    [jsonDict setObject:[dic objectForKey:@"Total price"] forKey:@"totalprice"];
    [jsonDict setObject:[dic objectForKey:@"Mother Name"] forKey:@"mother"];
    [jsonDict setObject:[dic objectForKey:@"Child2 Name"] forKey:@"child2"];
     [jsonDict setObject:[dic objectForKey:@"Child3 Name"] forKey:@"child3"];
  // [jsonDict setObject:@"1" forKey:@"child3"];
    [jsonDict setObject:[dic objectForKey:@"AMC"] forKey:@"amc"];
    [jsonDict setObject:[dic objectForKey:@"Spouse Dob"] forKey:@"spousedob"];
    [jsonDict setObject:[dic objectForKey:@"Child1 Dob"] forKey:@"child1dob"];
    [jsonDict setObject:[dic objectForKey:@"child2 Dob"] forKey:@"child2dob"];
   [jsonDict setObject:[dic objectForKey:@"Child3 Dob"] forKey:@"child3dob"];
    [jsonDict setObject:[dic objectForKey:@"Initial Amount Paid"] forKey:@"amountpaid"];

        NSURL *url=[NSURL URLWithString:salesurl];
        NSMutableString *bodyString = [[NSMutableString alloc]init];
        for (id currentKey in jsonDict.allKeys)
        {
            if([[jsonDict valueForKey:currentKey] isKindOfClass:[NSString class]])
            {
                NSString *keyObject = (NSString *)currentKey;
                [bodyString appendFormat:@"%@=%@&",keyObject,[jsonDict valueForKey:keyObject]];
            }
        }
        NSData *inputData = [[NSData alloc]initWithBytes:[bodyString UTF8String] length:[bodyString length]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request setHTTPBody:inputData];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[inputData length]] forHTTPHeaderField:@"Content-Length"];
         //NSLog(@"the data posting is %@", bodyString);
        NSURLSession *session=[NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
                                          {
            id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                              NSDictionary *jsonDictionary=obj;
                                              //NSLog(@"dat sales  %@ ",[jsonDictionary objectForKey:@"id"]);
                                              
                                              //NSLog(@"dat sales  %@ ",[error description]);
                                             
                                              NSString *str=[jsonDictionary objectForKey:@"id"];
                                              if ([str isEqualToString:@"-1"])
                                              {
                                                  [_gAppDelegate showAlertView:YES message:@"Submission Failed"];
                                                  
                                              }
                                              else
                                              {
                                              
                                                  [_gAppDelegate showAlertView:YES message:@"Data Sent Successfully"];
                                              
                                              }
                                              
                                          }];
        
        [dataTask resume];
        
    [_gAppDelegate showLoadingView:NO activityTitle:nil];
    }


// register PROFILE number


-(void)ProfileEmpNumber:(NSString*)empid completionBlock:(void(^)(NSMutableDictionary *responseDictionry,NSInteger statuscode, NSError *err))completionHandler
{


    
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

    NSString *db=[[NSUserDefaults standardUserDefaults]objectForKey:@"city"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?username=%@&db=%@",URL1,empid,db];

    
    NSURL *url =[NSURL URLWithString:urlString];
    
    NSURLSession *session =[NSURLSession sharedSession];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
                                      {
                                          
                                         id object=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;

                                          if (httpResponse.statusCode == 200)
                                          {
                                              completionHandler(object,httpResponse.statusCode,error);
                                              return;
                                              
                                          }
                                          else if (error==0)
                                              
                                          {
                                              
                                              completionHandler(nil, httpResponse.statusCode,error);

                                              return;
                                              
                                          }
                                          
                                          
                                      }];
    [dataTask resume];


}
#define venueUrl @"http://countryclubworld.com/badriapp/index.php/add_details/getVenues/"

-(void)GetVenues:(NSString*)uid completionBlock:(void(^)(NSMutableArray *responseDictionry,NSInteger statuscode, NSError *err))completionHandler;

{
    
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

    [_gAppDelegate showLoadingView:YES activityTitle:@"Loading"];
    
    NSURL *url=[NSURL URLWithString:venueUrl];
    NSString *parameter = [NSString stringWithFormat:@"uid=%@",uid];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPBody:[parameter dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[parameter length]] forHTTPHeaderField:@"Content-Length"];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
                                      {
                                          id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                          NSDictionary *jsonDictionary=obj;
                                          NSMutableArray *array_venues=[NSMutableArray new];
                                          NSArray *arr=[jsonDictionary objectForKey:@"venue_names"];
                                          for (int i=0; i<arr.count; i++)
                                          {
                                              NSString *dic=[[arr objectAtIndex:i] valueForKey:@"vname"];
                                             // //NSLog(@"%@",dic);
                                              [array_venues addObject:dic];
                                          }
                                          
                                          NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                          [userDefaults setObject:array_venues forKey:@"venues"];
                                          [userDefaults synchronize];
                                         // //NSLog(@"%@",array_venues);
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                          });
                                      }];
    [dataTask resume];
    [_gAppDelegate showLoadingView:NO activityTitle:nil];
    
    
}

#define GetCategoriesurl @"http://countryclubworld.com/badriapp/index.php/add_details/getCats/"

-(void)GetCategories:(NSString *)uid
{
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

    
    
    [_gAppDelegate showLoadingView:YES activityTitle:@"Loading"];
    
    NSURL *url=[NSURL URLWithString:GetCategoriesurl];
    NSString *parameter = [NSString stringWithFormat:@"uid=%@",uid];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPBody:[parameter dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[parameter length]] forHTTPHeaderField:@"Content-Length"];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
                                      {
                                          id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                          NSDictionary *jsonDictionary=obj;
                                          NSMutableArray *array_venues=[NSMutableArray new];
                                          NSArray *arr=[jsonDictionary objectForKey:@"cat_names"];
                                          for (int i=0; i<arr.count; i++)
                                          {
                                              NSString *cat_name=[[arr objectAtIndex:i] valueForKey:@"cat_name"];
                                           //   //NSLog(@"%@",dic);
                                              [array_venues addObject:cat_name];
                                          }
                                          
                                          NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                          [userDefaults setObject:array_venues forKey:@"catgs"];
                                          [userDefaults setObject:arr forKey:@"salesinfo"];
                                          [userDefaults synchronize];
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                          });
                                      }];
    [dataTask resume];
    [_gAppDelegate showLoadingView:NO activityTitle:nil];
    
}

#define historyUrl @"http://countryclubworld.com/badriapp/index.php/add_details/getHistory/"

-(void)GetHistory:(NSString *)uid Utype:(NSString *)utype completionBlock:(void(^)(NSArray *responseDictionry,NSInteger statuscode, NSError *err))completionHandler
{
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }


    [_gAppDelegate showLoadingView:YES activityTitle:@"Loading"];
    
    NSMutableDictionary *jsonDict=[NSMutableDictionary new];
    
    [jsonDict setObject:uid forKey:@"uid"];
    [jsonDict setObject:utype forKey:@"utype"];
    
    NSURL *url=[NSURL URLWithString:historyUrl];
    NSMutableString *bodyString = [[NSMutableString alloc]init];
    for (id currentKey in jsonDict.allKeys)
    {
        if([[jsonDict valueForKey:currentKey] isKindOfClass:[NSString class]])
        {
            NSString *keyObject = (NSString *)currentKey;
            [bodyString appendFormat:@"%@=%@&",keyObject,[jsonDict valueForKey:keyObject]];
        }
    }
    NSData *inputData = [[NSData alloc]initWithBytes:[bodyString UTF8String] length:[bodyString length]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPBody:inputData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[inputData length]] forHTTPHeaderField:@"Content-Length"];
    //NSLog(@"the data posting is %@", bodyString);
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
                                      {
            id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    NSDictionary *jsonDictionary=obj;
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;

                                     //  //NSLog(@"history  is %@ ",jsonDictionary);
                        NSArray *arr_kyc=[jsonDictionary objectForKey:@"kyc"];
                                          
                                          
                                completionHandler(arr_kyc,httpResponse.statusCode,error);
                                          return;
                                      }];
    [dataTask resume];
    [_gAppDelegate showLoadingView:NO activityTitle:nil];

}


@end
