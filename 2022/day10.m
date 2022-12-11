// clang day10.m -fmodules -o day10 && ./day10

@import Foundation;

@interface CPUState: NSObject

@property (readonly, nonatomic) int signalSum;

- (void)noop;
- (void)addX: (int)value;

@end

@implementation CPUState {
    int x;
    int counter;
    int *nextSample;
}

static int samplePositions[] = {20, 60, 100, 140, 180, 220, -1};

- init;
{
    self = [super init];
    x = 1;
    counter = 0;
    nextSample = samplePositions;
    _signalSum = 0;
    return self;
}

- (void)step;
{
    counter++;
    if (counter == *nextSample) {
        _signalSum += counter * x;
        ++nextSample;
    }
}

- (void)noop;
{
    [self step];
}

- (void)addX: (int)value;
{
    [self step];
    [self step];
    x += value;
}

@end

    
int main() {
    
    NSScanner *scanner = [NSScanner scannerWithString: [NSString stringWithContentsOfFile: @"day10.input" encoding: NSUTF8StringEncoding error: NULL]];
    
    CPUState *state = [[CPUState alloc] init];
    
    while (![scanner isAtEnd]) {
        int argument = 0;
        if ([scanner scanString: @"noop" intoString: NULL]) {
            [state noop];
        } else if ([scanner scanString: @"addx" intoString: NULL] && [scanner scanInt: &argument]) {
            [state addX: argument];
        }
    }

    NSLog(@"Part 1: %d", state.signalSum);
    
}
