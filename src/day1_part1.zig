// Day 1: Secret Entrance
// https://adventofcode.com/2025/day/1

const std = @import("std");

const Dial = struct {
    currentPointer: i32,
    maxValue: u7,

    pub fn rotateLeft(self: *Dial, amountToRotate: u10) void {
        self.currentPointer = @mod((self.currentPointer - @as(i32, amountToRotate) + @as(i32, self.maxValue)), @as(i32, self.maxValue));
    }

    pub fn rotateRight(self: *Dial, amountToRotate: u10) void {
        self.currentPointer = @mod((self.currentPointer + @as(i32, amountToRotate)), @as(i32, self.maxValue));
    }

    pub fn isPointingAtZero(self: *Dial) bool {
        return self.currentPointer == 0;
    }
};

fn getInput(allocator: std.mem.Allocator) ![]const u8 {
    const file = try std.fs.cwd().openFile("src/day1_part1_input.txt", .{});
    defer file.close();

    const data = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
    return data;
}

pub fn secretEntrance(data: []const u8) !u32 {
    var iter = std.mem.splitScalar(u8, data, '\n');

    var dial = Dial{ .currentPointer = 50, .maxValue = 100 };

    var secret: u32 = 0;
    while (iter.next()) |line| {
        if (iter.peek() == null) {
            break;
        }
        const unparsedValue = line[1..line.len];
        const amountToRotate = try std.fmt.parseInt(u10, unparsedValue, 10);

        if (line[0] == 'L') {
            dial.rotateLeft(amountToRotate);
        } else {
            dial.rotateRight(amountToRotate);
        }

        if (dial.isPointingAtZero()) {
            secret += 1;
        }
    }

    return secret;
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
    std.debug.print("Secret: {d}\n", .{value});
    try std.testing.expect(value == 3);
}

test "secret entrance my input" {
    const allocator = std.heap.page_allocator;
    const data = try getInput(allocator);
    defer allocator.free(data);

    const value = try secretEntrance(data);
    std.debug.print("Secret: {d}\n", .{value});
    try std.testing.expect(value == 1007);
}
