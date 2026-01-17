const std = @import("std");
const Ast = std.zig.Ast;
const root = @import("root.zig");

pub fn draw_mermaid(allocator: std.mem.Allocator, tree: Ast, out: std.fs.File) !void {
    var _bw = std.io.bufferedWriter(out.writer());
    const bw = _bw.writer();

    const parents: []const i32 = try root.get_parents(allocator, tree);
    const edges = try root.get_edges(allocator, tree);

    try bw.print("flowchart TD\n", .{});
    for (0..tree.nodes.len) |i| {
        if (parents[i] == -1 and i != 0) {
            continue;
        }
        try bw.print("    {}[{}]\n", .{ i, tree.nodes.get(i).tag });
    }
    for (edges) |edge| {
        try bw.print("    {d} --> {d}\n", .{ edge.start, edge.end });
    }
    try _bw.flush();
}
