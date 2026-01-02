// Day 2: Gift Shop
// https://adventofcode.com/2025/day/2
const std = @import("std");
const fs = @import("fs.zig");

fn pow10(n: u32) u64 {
    var p: u64 = 1;
    var i: u32 = 0;
    while (i < n) : (i += 1) p *= 10;
    return p;
}

fn getNbDigits(n: u64) u32 {
    if (n == 0) return 0;

    var x = n;
    var digits: u32 = 0;

    while (x != 0) : (x /= 10) {
        digits += 1;
    }

    return digits;
}

fn isOdd(nbDigits: u32) bool {
    return (nbDigits & 1) == 1;
}

fn isInvalid(value: u64, n: u32) bool {
    const divisor: u64 = pow10(n / 2);

    return (value / divisor) == (value % divisor);
}
fn sumInvalidDigits(startValue: u64, endValue: u64) u64 {
    const startNbDigits = getNbDigits(startValue);
    const endNbDigits = getNbDigits(endValue);

    if (startNbDigits == endNbDigits and isOdd(startNbDigits)) {
        return 0;
    }

    var sum: u64 = 0;
    var step = startValue;
    while (step <= endValue) : (step += 1) {
        if (isInvalid(step, getNbDigits(step))) {
            sum += step;
        }
    }

    return sum;
}

pub fn giftShop(data: []const u8) !u64 {
    var rangeIter = std.mem.splitScalar(u8, data, ',');
    var total: u64 = 0;
    while (rangeIter.next()) |range| {
        var iter = std.mem.splitScalar(u8, range, '-');
        const startBuffer = std.mem.trim(u8, iter.next().?, "\n");
        const endBuffer = std.mem.trim(u8, iter.next().?, "\n");

        const startValue: u64 = try std.fmt.parseUnsigned(u64, startBuffer, 10);
        const endValue: u64 = try std.fmt.parseUnsigned(u64, endBuffer, 10);

        total += sumInvalidDigits(startValue, endValue);
    }

    return total;
}

test "should return invalid for 11" {
    try std.testing.expectEqual(true, isInvalid(11, 2));
}

test "should return 11 and 22 for 11-22" {
    const startValue: u64 = 11;
    const endValue: u64 = 22;

    const total = sumInvalidDigits(startValue, endValue);

    try std.testing.expectEqual(33, total);
}

test "should return invalid for 38593859" {
    try std.testing.expectEqual(true, isInvalid(38593859, 8));
}

test "should return 38593859 for 38593856-38593862" {
    const total = sumInvalidDigits(38593856, 38593862);

    try std.testing.expectEqual(38593859, total);
}

test "should work with example input" {
    const exampleInput = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    const value = try giftShop(exampleInput);
    try std.testing.expectEqual(1227775554, value);
}

test "secret entrance my input" {
    const allocator = std.heap.page_allocator;
    const data = try fs.getInput("inputs/day2_part1_input.txt", allocator);

    defer allocator.free(data);

    const value = try giftShop(data);
    try std.testing.expectEqual(5820, value);
}
