const std = @import("std");
const fs = @import("fs.zig");

const Dial = struct {
    currentPointer: i32,
    maxValue: u7,
    maxAmountToRotate: u10,
    clicks: i32,
    pub fn rotateLeft(self: *Dial, amountToRotate: u10) void {
        const tmp: i32 = (self.currentPointer - @as(i32, amountToRotate));
        const nbClicks: i32 = @divTrunc(tmp, -1 * @as(i32, self.maxValue)) + @as(i32, if (tmp <= 0 and self.currentPointer != 0) 1 else 0);
        self.currentPointer = @mod(tmp + @as(i32, self.maxAmountToRotate), @as(i32, self.maxValue));
        self.clicks += nbClicks;
    }

    pub fn rotateRight(self: *Dial, amountToRotate: u10) void {
        const tmp = self.currentPointer + @as(i32, amountToRotate);
        const nbClicks: i32 = @divTrunc(tmp, @as(i32, self.maxValue));
        self.clicks += nbClicks;
        self.currentPointer = @mod(tmp, @as(i32, self.maxValue));
    }
};

pub fn secretEntrance(data: []const u8) !i32 {
    var iter = std.mem.splitScalar(u8, data, '\n');

    var dial = Dial{ .currentPointer = 50, .maxValue = 100, .clicks = 0, .maxAmountToRotate = 1000 };

    while (iter.next()) |line| {
        if (line.len <= 1) {
            continue;
        }
        const unparsedValue = line[1..line.len];
        const amountToRotate = try std.fmt.parseInt(u10, unparsedValue, 10);

        if (line[0] == 'L') {
            dial.rotateLeft(amountToRotate);
        } else {
            dial.rotateRight(amountToRotate);
        }
        if (iter.peek() == null) {
            break;
        }
    }

    return dial.clicks;
}

test "secret entrance example input" {
    const exampleInput =
        \\L68
        \\L30
        \\R48
        \\L5
        \\R60
        \\L55
        \\L1
        \\L99
        \\R14
        \\L82
    ;

    const value = try secretEntrance(exampleInput);
    try std.testing.expectEqual(6, value);
}

test "secret entrance custom input" {
    // clicks = 50 - 999 / -100
    const exampleInput =
        \\L999
    ;

    const value = try secretEntrance(exampleInput);
    try std.testing.expectEqual(10, value);
}

test "secret entrance my input" {
    const allocator = std.heap.page_allocator;
    const data = try fs.getInput("inputs/day1_part1_input.txt", allocator);
    defer allocator.free(data);

    const value = try secretEntrance(data);
    try std.testing.expectEqual(5820, value);
}
