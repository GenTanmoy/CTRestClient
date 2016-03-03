//
//  CTRestClient.m
//  CTRestClient
//
//  Created by Tanmoy Khanra on 24/02/16.
//  Copyright © 2016 Tanmoy Khanra. All rights reserved.
//

#import "CTRestClient.h"

@interface CTRestClient()<NSURLSessionDataDelegate , NSURLSessionTaskDelegate>
//for http operation
@property(nonatomic) NSString *httpMethod;
@property(nonatomic) NSString *httpBody;
@property(nonatomic) NSString *urlString;
@property(nonatomic) NSString *contentType;
@property(nonatomic) NSString *authorizationValue;
@property(nonatomic) NSDictionary *headerFieldsAndValues;
@property (nonatomic) NSMutableData *receivedData;

@property(nonatomic)NSURLSessionUploadTask *uploadTask;

@end

@implementation CTRestClient

//init
- (id)init:(NSString *)url withBody:(NSString *)httpbody withMethod:(NSString *)method
{
    self = [super init];
    if (self)
    {
        self.httpBody = httpbody;
        self.urlString = url;
        self.httpMethod = method;
    }
    return self;
}

#pragma Get request for Retrieve Data

-(void)getJsonData:(CTHTTPResponseHandler)httpResponseHandler
{
    if (self.urlString) {
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
        
        [request setHTTPMethod:self.httpMethod];
        
        [request setHTTPBody:[self.httpBody? self.httpBody : @"" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setValue:self.authorizationValue? self.authorizationValue :@"" forHTTPHeaderField:@"Authorization"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                {
                                                    if (error == nil) {
                                                        [CTJsonSerialization getJsonResponseFromData:data onCompletion:^(NSDictionary *json, NSError *error) {
                                                            if (error) {
                                                                httpResponseHandler(nil,error);
                                                                
                                                            }else{
                                                                httpResponseHandler(json,nil);
                                                            }
                                                            
                                                        }];
                                                    }else{
                                                        httpResponseHandler(nil,error);
                                                    }
                                                    
                                                }];
        [dataTask resume];
    }
    
}

#pragma Post Operation with only param data

-(void)saveOnlyParamswithCompletion:(CTHTTPResponseHandler )httpResponseHandler{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    
    [request setHTTPMethod:self.httpMethod];
    
    [request setHTTPBody:[self.httpBody? self.httpBody : @"" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    [request setValue:self.authorizationValue? self.authorizationValue :@"" forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask =[defaultSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                          
                                                           if(error == nil)
                                                           {
                                                               [CTJsonSerialization getJsonResponseFromData:data  onCompletion:^(NSDictionary *json, NSError *error) {
                                                                   if (error) {
                                                                       httpResponseHandler(nil,error);
                                                                   }else {
                                                                       httpResponseHandler(json,nil);
                                                                   }
                                                                   
                                                               }];
                                                           }else{
                                                               
                                                               httpResponseHandler(nil,error);
                                                           }
                                                           
                                                       }];
    
    [dataTask resume];
    
}

#pragma fileupload

/*
 convert image - NSData *data = UIImageJPEGRepresentation(self.uploadImageView.image,0.5);
 */

-(void)saveDataWithParams:(NSData *)data withFileName:(NSString *)fileName fileKey:(NSString *)key otherData:(NSDictionary *)params withCompletion:(CTHTTPResponseHandler)httpResponseHandler
{
    NSString *boundary = @"14737809831466499882746641449";
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    
    [request setHTTPMethod:self.httpMethod];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:self.authorizationValue? self.authorizationValue :@"" forHTTPHeaderField:@"Authorization"];
    
    
    
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n",key,fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    
    
    NSURLSessionUploadTask *dataTask = [defaultSession uploadTaskWithRequest:request fromData:body completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if (!error && httpResp.statusCode == 200) {
            
            [CTJsonSerialization getJsonResponseFromData:data  onCompletion:^(NSDictionary *json, NSError *error) {
                if (error) {
                    httpResponseHandler(nil,error);
                }else {
                    httpResponseHandler(json,nil);
                }
                
            }];
            
        } else {
            
            // alert for error saving / updating note
           //NSLog(@"ERROR: %@ AND HTTPREST ERROR : %ld", error, (long)httpResp.statusCode);
            httpResponseHandler(nil,error);
        }
        
    }];
    
    [dataTask resume];
    
}




@end
