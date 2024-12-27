const std = @import("std");
const Allocator = std.mem.Allocator;
const testing = std.testing;
const op = @import("op.zig");

// Think about this:
// pub fn map(comptime X: type, comptime Y: type, allocator: Allocator, fun: fn (type, type, X) Y, in: []const X) ![]const Y {
// Can we have an alternative signature to support the above and below?
pub fn map(comptime X: type, comptime Y: type, allocator: Allocator, fun: fn (X) Y, in: []const X) ![]const Y {
    var result: []Y = try allocator.alloc(Y, in.len);
    for (in, 0..) |elem, i| {
        result[i] = fun(elem);
    }
    return result;
}

pub fn map_no_alloc(comptime X: type, comptime Y: type, fun: fn (X) Y, in: []const X, out: []Y) void {
    for (in, 0..) |elem, i| {
        out[i] = fun(elem);
    }
}

pub fn filter(comptime X: type, allocator: Allocator, fun: fn (X) bool, in: []const X) ![]X {
    var go_forward: []bool = try allocator.alloc(bool, in.len);
    var num_forward: u64 = 0;
    for (in, 0..) |elem, i| {
        const filter_out = fun(elem);
        if (!filter_out) {
            num_forward += 1;
        }
        go_forward[i] = !filter_out;
    }
    try allocator.free(go_forward);
    const result: []X = try allocator.alloc(X, num_forward);
    var curr_pos = 0;
    for (go_forward, 0..) |go, i| {
        if (go) {
            result[curr_pos] = in[i];
            curr_pos += 1;
        }
    }
    return result;
}

pub fn foldl(comptime X: type, fun: fn (X, X) X, in: []const X, initial: X) X {
    var accumulator: X = initial;
    for (in) |element| {
        accumulator = fun(accumulator, element);
    }
    return accumulator;
}

test "map basic example" {
    const entry = [_]i32{ 1, 2, 3, 4 };
    const result = try map(i32, i32, testing.allocator, op.dec_i32, &entry);
    try testing.expect(result[3] == 3);
    testing.allocator.free(result);
}

test "map_no_alloc basic example" {
    const test_dec = struct {
        fn test_dec(x: u32) i64 {
            return @as(i64, @intCast(x)) - 1;
        }
    }.test_dec;
    const entry = [_]u32{ 1, 2, 3, 4 };
    var result: [4]i64 = undefined;
    map_no_alloc(u32, i64, test_dec, &entry, &result);
    try testing.expect(result[3] == 3);
}

// Create a test case that shows that foldl different from foldr
