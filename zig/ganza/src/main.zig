const std = @import("std");
const root = @import("root.zig");
const draw = @import("draw.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const stdout = std.io.getStdOut();
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);
    const file = try std.fs.cwd().openFile(args[1], .{});
    defer file.close();
    var buffer: [10000]u8 = undefined;
    const file_size = try file.readAll(&buffer);
    buffer[file_size] = 0;
    const buffer_0: [:0]const u8 = buffer[0..file_size :0];

    const tree = try std.zig.Ast.parse(allocator, buffer_0, std.zig.Ast.Mode.zig);

    try draw.draw_mermaid(allocator, tree, stdout);
}
