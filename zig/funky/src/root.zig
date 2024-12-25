const std = @import("std");
const Allocator = std.mem.Allocator;
const testing = std.testing;

pub fn map(comptime X: type, comptime Y: type, allocator: Allocator, fun: fn (X) Y, in: []const X) ![]const Y {
    var result: []Y = try allocator.alloc(Y, in.len);
    for (in, 0..) |elem, i| {
        result[i] = fun(elem);
    }
    return result;
}

fn dec(x: u32) i64 {
    const val: i64 = @intCast(x);
    return val - 1;
}

pub fn map_no_alloc(comptime X: type, comptime Y: type, fun: fn (X) Y, in: []const X, out: []Y) void {
    for (in, 0..) |elem, i| {
        out[i] = fun(elem);
    }
}

test "map basic example" {
    const entry = [_]u32{ 1, 2, 3, 4 };
    const result = try map(u32, i64, testing.allocator, dec, &entry);
    try testing.expect(result[3] == 3);
    testing.allocator.free(result);
}

test "map_no_alloc basic example" {
    const entry = [_]u32{ 1, 2, 3, 4 };
    var result: [4]i64 = undefined;
    map_no_alloc(u32, i64, dec, &entry, &result);
    try testing.expect(result[3] == 3);
}
