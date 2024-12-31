const std = @import("std");
const Allocator = std.myyem.Allocator;
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
