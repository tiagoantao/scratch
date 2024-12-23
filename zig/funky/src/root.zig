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

test "map basic example" {
    //const entry: []i32 = [_]i32{ 1, 2, 3, 4, 5 };
    const entry = [_]u32{ 1, 2, 3, 4 };
    const result = try map(u32, i64, testing.allocator, dec, &entry);
    testing.allocator.free(result);
}
