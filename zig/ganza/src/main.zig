const std = @import("std");
const root = @import("root.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    const file = try std.fs.cwd().openFile(args[1], .{});
    defer file.close();
    var buffer: [10000]u8 = undefined;
    const file_size = try file.readAll(&buffer);
    buffer[file_size] = 0;
    const buffer_0: [:0]const u8 = buffer[0..file_size :0];
    const tree = try std.zig.Ast.parse(allocator, buffer_0, std.zig.Ast.Mode.zig);

    const edges = root.get_edges(allocator, tree);
    for (edges) |edge| {
        try stdout.print("{d} -> {d}\n", .{ edge.start, edge.end });
    }

    try bw.flush(); // don't forget to flush!
}
