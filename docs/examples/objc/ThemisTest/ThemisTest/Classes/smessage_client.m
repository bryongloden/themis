//#import <objcthemis/smessage.h>
//#import <objcthemis/ssession.h>
//
//
//@interface Smessage_CI_client ()
//@end
//
//
//@implementation Smessage_CI_client
//
//- (NSData *)postRequest:(NSString *)URL message:(NSData *)message {
//
//    NSURL * url = [NSURL URLWithString:URL];
//    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
//    NSString * params = [NSString stringWithFormat:@"message=%@", [message base64EncodedStringWithOptions:0]];
//    [urlRequest setHTTPMethod:@"POST"];
//    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
//
//    NSData * postdata = [params dataUsingEncoding:NSUTF8StringEncoding];
//    [urlRequest setHTTPBody:postdata];
//    [urlRequest setValue:[NSString stringWithFormat:@"%li", postdata.length] forHTTPHeaderField:@"Content-Length"];
//
//    __block NSData * res = nil;
//    NSURLResponse * response = nil;
//    NSError * error = nil;
//    res = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
//    if (error || ((NSHTTPURLResponse *) response).statusCode != 200) {
//        NSLog(@"Error:%@ %@\n", response, error);
//        return nil;
//    }
//    NSLog(@"Response:%@\n", res);
//    return res;
//}
//
//
//- (void)secure_message_ci_test {
//    NSString * userid = @"bnqExvLDcULvBOb";
//    NSData * server_pub_key = [[NSData alloc] initWithBase64EncodedString:@"VUVDMgAAAC1upTUcA0gwpCXbyM4etES8u7eZvbDJUDGjVDfPwz+qqIVUHEAm" options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    NSData * client_priv_key = [[NSData alloc] initWithBase64EncodedString:@"UkVDMgAAAC1whm6SAJ7vIP18Kq5QXgLd413DMjnb6Z5jAeiRgUeekMqMC0+x" options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    TSMessage * encrypter = [[TSMessage alloc] initInEncryptModeWithPrivateKey:client_priv_key peerPublicKey:server_pub_key];
//    NSString * message = @"This is test message";
//    NSError * themisError = NULL;
//    NSData * encryptedMessage = [encrypter wrapData:[message dataUsingEncoding:NSUTF8StringEncoding] error:&themisError];
//    if (themisError) {
//        NSLog(@"AA: %@", themisError);
//        return;
//    }
//    NSData * responseMessage = [encrypter unwrapData:[self postRequest:[NSString stringWithFormat:@"%@%@/", @"https://themis.cossacklabs.com/api/", userid] message:encryptedMessage] error:&themisError];
//    if (themisError) {
//        NSLog(@"AA: %@", themisError);
//        return;
//    }
//    NSLog(@"Response: %@", [[NSString alloc] initWithData:responseMessage encoding:NSUTF8StringEncoding]);
//}
//
//@end
