const std = @import("std");
const Allocator = std.mem.Allocator;
const testing = std.testing;
const op = @import("op.zig");
const src = @import("select.zig");

test "head basic example" {
    const entry = [_]i32{ 1, 2, 3, 4 };
    const result = try src.head(i32, testing.allocator, &entry, 2);
    defer testing.allocator.free(result);
    try testing.expect(result.len == 2);
    try testing.expect(result[1] == 2);
}

test "head n > size" {
    const entry = [_]i32{ 1, 2, 3 };
    const result = try src.head(i32, testing.allocator, &entry, 4);
    defer testing.allocator.free(result);
    try testing.expect(result.len == 3);
    try testing.expect(result[2] == 3);
}
