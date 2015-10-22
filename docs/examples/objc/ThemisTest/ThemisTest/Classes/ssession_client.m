//#import <AFNetworking/AFNetworking.h>
//#import <objcthemis/ssession.h>
//
//NSString* const server_pub_key_str=@"VUVDMgAAAC1upTUcA0gwpCXbyM4etES8u7eZvbDJUDGjVDfPwz+qqIVUHEAm";
//NSString* const server_id=@"TtoxCbShsBVpDMn";
//NSString* const client_priv_key_str=@"UkVDMgAAAC1whm6SAJ7vIP18Kq5QXgLd413DMjnb6Z5jAeiRgUeekMqMC0+x";
//NSString* const client_id=@"bnqExvLDcULvBOb";
//
//@interface Transport : TSSessionTransportInterface
//@end
//
//@implementation Transport
//- (NSData *)publicKeyFor:(NSData *)binaryId error:(NSError **)error {
//    NSString * stringFromData = [[NSString alloc] initWithData:binaryId encoding:NSUTF8StringEncoding];
//    if ([stringFromData isEqualToString:server_id]) {
//        NSData * key = [[NSData alloc] initWithBase64EncodedString:server_pub_key_str options:NSDataBase64DecodingIgnoreUnknownCharacters];
//        return key;
//    }
//    return nil;
//}
//@end
//
//@interface Ssession_CI_client ()
//@property (nonatomic, strong) Transport * transport;
//@property (nonatomic, strong) TSSession * session;
//@end
//
//@implementation Ssession_CI_client
//
//- (NSData*) postRequest: (NSString*) URL message:(NSData*) message{
//    NSURL * url = [NSURL URLWithString:URL];
//    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
//    NSString * params =[NSString stringWithFormat:@"message=%@",[message base64EncodedStringWithOptions:0]];
//    [urlRequest setHTTPMethod:@"POST"];
//    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
//    NSData* postdata=[params dataUsingEncoding:NSUTF8StringEncoding];
//    [urlRequest setHTTPBody:postdata];
//    [urlRequest setValue:[NSString stringWithFormat: @"%li",  postdata.length] forHTTPHeaderField:@"Content-Length"];
//    __block NSData* res=nil;
//    NSURLResponse* response = nil;
//    NSError* error=nil;
//    res=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse: &response error: &error];
//    if (error || ((NSHTTPURLResponse *) response).statusCode !=200) {
//        NSLog(@"Error:%@ %@\n", response, error);
//        return nil;
//    }
//    NSLog(@"Response:%@\n", res);
//    return res;
//}
//
//- (void)secure_session_ci_test{
//    self.transport = [Transport new];
//    self.session = [[TSSession alloc] initWithUserId:[client_id dataUsingEncoding:NSUTF8StringEncoding]
//                                          privateKey:[[NSData alloc] initWithBase64EncodedString:client_priv_key_str options:NSDataBase64DecodingIgnoreUnknownCharacters]
//                                           callbacks:self.transport];
//    NSError * error = nil;
//    NSData* resp_data=nil;
//    NSData * req_data = [self.session connectRequest:&error];
//    if (error) {
//        NSLog(@"ERROR: %@", error);
//        return;
//    }
//    NSString* server_url=[NSString stringWithFormat:@"%@%@/", @"https://themis.cossacklabs.com/api/", client_id];
//    while (![self.session isSessionEstablished]) {
//        resp_data=[self postRequest:server_url message:req_data];
//        if (!resp_data){
//            return;
//        }
//        req_data = [self.session unwrapData:resp_data error:&error];
//        if (error) {
//            NSLog(@"Error on unwrapping message %@", error);
//            return;
//        }
//    }
//    req_data=[self.session wrapData:[@"This is test message" dataUsingEncoding:NSUTF8StringEncoding] error:&error];
//    if (error) {
//        NSLog(@"Error: %@", error);
//        return;
//    }
//    resp_data=[self postRequest:server_url message:req_data];
//    if (!resp_data){
//        return;
//    }
//    resp_data=[self.session unwrapData:resp_data error:&error];
//    if (error) {
//        NSLog(@"Error: %@", error);
//        return;
//    }
//    NSLog(@"%@", [[NSString alloc] initWithData:resp_data encoding:NSUTF8StringEncoding]);
//}
//@end
