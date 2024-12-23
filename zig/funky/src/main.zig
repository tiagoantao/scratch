const std = @import("std");
const root = @import("root.zig");

fn double(x: i32) i32 {
    return x * 2;
}

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    const numbers = [_]i32{ 1, 2, 3, 4, 5 };
    var buffer: [100]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    const doubles = try root.map(i32, i32, allocator, double, &numbers);
    for (doubles) |d| {
        try stdout.print("{d} ", .{d});
    }

    try bw.flush(); // don't forget to flush!
}
