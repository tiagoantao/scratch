const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn head(comptime T: type, allocator: Allocator, in: []const T, n: u32) ![]T {
    const result_size = @min(in.len, n);
    const result: []T = try allocator.alloc(T, result_size);
    for (0..result_size) |i| {
        result[i] = in[i];
    }
    return result;
}

//take_while
