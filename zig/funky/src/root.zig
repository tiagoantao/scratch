//! Funky core functions.
//! map, filter, foldr,foldl
const std = @import("std");
const Allocator = std.mem.Allocator;
const testing = std.testing;
const op = @import("op.zig");

// Think about this:
// pub fn map(comptime X: type, comptime Y: type, allocator: Allocator, fun: fn (type, type, X) Y, in: []const X) ![]const Y {
// Can we have an alternative signature to support the above and below?

/// map function.
/// Output needs to be deallocated
pub fn map(comptime X: type, comptime Y: type, allocator: Allocator, fun: fn (X) Y, in: []const X) ![]const Y {
    var result: []Y = try allocator.alloc(Y, in.len);
    for (in, 0..) |elem, i| {
        result[i] = fun(elem);
    }
    return result;
}

test map {
    const entry = [_]i32{ 1, 2, 3, 4 };
    const result = try map(i32, i32, testing.allocator, op.dec_i32, &entry);
    defer testing.allocator.free(result);
    try testing.expect(result[3] == 3);
}

/// map function.
/// No allocation is done by this code.
pub fn map_no_alloc(comptime X: type, comptime Y: type, fun: fn (X) Y, in: []const X, out: []Y) void {
    for (in, 0..) |elem, i| {
        out[i] = fun(elem);
    }
}

/// filter function.
pub fn filter(comptime X: type, allocator: Allocator, fun: fn (X) bool, in: []const X) ![]X {
    var go_forward: []bool = try allocator.alloc(bool, in.len);
    defer allocator.free(go_forward);
    var num_forward: u64 = 0;
    for (in, 0..) |elem, i| {
        const keep = fun(elem);
        if (keep) {
            num_forward += 1;
        }
        go_forward[i] = keep;
    }
    const result: []X = try allocator.alloc(X, num_forward);
    var curr_pos: usize = 0;
    for (go_forward, 0..) |go, i| {
        if (go) {
            result[curr_pos] = in[i];
            curr_pos += 1;
        }
    }
    return result;
}

test map_no_alloc {
    const entry = [_]i32{ 1, 2, 3, 4 };
    var result: [4]i32 = undefined;
    map_no_alloc(i32, i32, op.dec_i32, &entry, &result);
    try testing.expect(result[3] == 3);
}

pub fn foldl(comptime X: type, fun: fn (X, X) X, in: []const X, initial: X) X {
    var accumulator: X = initial;
    for (in) |element| {
        accumulator = fun(accumulator, element);
    }
    return accumulator;
}

pub fn foldr(comptime X: type, fun: fn (X, X) X, in: []const X, initial: X) X {
    var accumulator: X = initial;
    for (0..in.len) |i| {
        accumulator = fun(in[in.len - (i + 1)], accumulator);
    }
    return accumulator;
}

pub fn chain(comptime T: type, allocator: Allocator, ins: []const []const T) ![]T {
    var total_len: usize = 0;
    for (ins) |in| {
        total_len += in.len;
    }
    const result: []T = try allocator.alloc(T, total_len);
    var pos: usize = 0;
    for (ins) |in| {
        for (in) |elem| {
            result[pos] = elem;
            pos += 1;
        }
    }
    return result;
}

//infinite count/cycle

// *****
// TESTS
// *****

//Do a test with a map type change

test "filter example" {
    const entry = [_]u32{ 1, 2, 3, 4 };
    const result = try filter(u32, testing.allocator, op.gt_val(u32, 1), &entry);
    defer testing.allocator.free(result);
    try testing.expect(result.len == 3);
    try testing.expect(result[0] == 2);
    try testing.expect(result[2] == 4);
}

test "left fold - foldl" {
    const entry = [_]i32{ 1, 2, 3, 4 };
    const result = foldl(i32, op.sub_i32, &entry, 0);
    try testing.expect(result == -10);
}

test "right fold - foldr" {
    const entry = [_]i32{ 1, 2, 3, 4 };
    const result = foldr(i32, op.sub_i32, &entry, 0);
    try testing.expect(result == -2);
}

test "chain" {
    const entry1 = [_]u32{ 1, 2, 3, 4 };
    const entry2 = [_]u32{ 5, 6, 7 };
    const entry: []const []const u32 = &.{ &entry1, &entry2 };
    const result = try chain(u32, testing.allocator, entry);
    defer testing.allocator.free(result);
    try testing.expect(result.len == 7);
    try testing.expect(result[0] == 1);
    try testing.expect(result[6] == 7);
}
