const std = @import("std");
const Ast = std.zig.Ast;
const testing = std.testing;

fn generate_offspring(full_ast: Ast, node_location: usize, parents: []i32) void {
    const node = full_ast.nodes.get(node_location);
    _ = switch (node.tag) {
        .root => {
            for (node.data.lhs..node.data.rhs) |i| {
                parents[full_ast.extra_data[i]] = @intCast(node_location);
            }
        },
        .@"usingnamespace" => {
            parents[node.data.rhs] = @intCast(node_location);
        },
        else => null,
    };
}

pub fn get_parents(allocator: std.mem.Allocator, full_ast: Ast) ![]const i32 {
    const parents: []i32 = try allocator.alloc(i32, full_ast.nodes.len);
    for (0..full_ast.nodes.len) |i| {
        parents[i] = -1; // no parent
    }
    for (0..full_ast.nodes.len) |i| {
        generate_offspring(full_ast, i, parents);
    }

    return parents;
}

const edge = struct {
    start: i32,
    end: i32,
};

pub fn get_edges(allocator: std.mem.Allocator, full_ast: Ast) ![]edge {
    const parents: []const i32 = try get_parents(allocator, full_ast);
    var list = std.ArrayList(edge).init(allocator);

    for (0..parents.len) |i| {
        const parent = parents[i];
        if (parent != -1) {
            try list.append(edge{ .start = parent, .end = @intCast(i) });
        }
    }

    const edges = list.toOwnedSlice();
    return edges;
}
