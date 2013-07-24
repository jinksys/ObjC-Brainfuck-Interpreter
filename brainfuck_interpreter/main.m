//
//  main.m
//  brainfuck_interpreter
//
//  Created by Stephen Melvin on 11/16/12.
//  Copyright (c) 2012 Stephen Melvin. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    unsigned int *zero = 0x0;
    
    NSString *bf_prog = @">+++++++4+[>++++++<-]>++++.----.++++.";
    
    NSMutableData *data = [NSMutableData dataWithLength:30000];
    
    unsigned int ip = 0;
    int dp = 0;
    
    while(ip < bf_prog.length){
        if ([bf_prog characterAtIndex:ip] == '>') {
            dp++;
            if(dp >= data.length){
                [data appendBytes:zero length:30000];
            }
        }
        else if ([bf_prog characterAtIndex:ip] == '<'){
            if(dp>=0){
                dp--;
            }
        }
        else if ([bf_prog characterAtIndex:ip] == '+'){
            unsigned char byteToIncrement;
            [data getBytes:&byteToIncrement range:NSMakeRange(dp, 1)];
            if(byteToIncrement<0xFF){
                byteToIncrement++;
            }
            [data replaceBytesInRange:NSMakeRange(dp, 1) withBytes:&byteToIncrement];
        }
        else if ([bf_prog characterAtIndex:ip] == '-'){
            unsigned char byteToDecrement;
            [data getBytes:&byteToDecrement range:NSMakeRange(dp, 1)];
            if(byteToDecrement>0){
                byteToDecrement--;
            }
            [data replaceBytesInRange:NSMakeRange(dp, 1) withBytes:&byteToDecrement];
        }
        else if ([bf_prog characterAtIndex:ip] == '.'){
            unsigned char byteToPrint;
            [data getBytes:&byteToPrint range:NSMakeRange(dp, 1)];
            printf("%c", byteToPrint);
        }
        else if ([bf_prog characterAtIndex:ip] == ','){
            
        }
        else if ([bf_prog characterAtIndex:ip] == '['){
            unsigned char byteAtPointer;
            [data getBytes:&byteAtPointer range:NSMakeRange(dp, 1)];
            if(byteAtPointer == 0){
                ip = (unsigned int)[bf_prog rangeOfString:@"]" options:NSLiteralSearch range:NSMakeRange(ip, bf_prog.length - ip)].location + 1;
                continue;
            }
        }
        else if ([bf_prog characterAtIndex:ip] == ']'){
            unsigned char byteAtPointer;
            [data getBytes:&byteAtPointer range:NSMakeRange(dp, 1)];
            if(byteAtPointer != 0){
                ip = (unsigned int)[bf_prog rangeOfString:@"[" options:NSBackwardsSearch|NSLiteralSearch range:NSMakeRange(0, ip)].location + 1;
                continue;
            }
        }
        ip++;
    }

return 0;
}

