const std = @import("std");
const Ast = std.zig.Ast;
const testing = std.testing;

fn generate_offspring(full_ast: Ast, node_location: usize, parents: []i32) void {
    const node = full_ast.nodes[node_location];
    _ = switch (node.tag) {
        .root => {
            for (node.data.lhs..node.data.rhs) |i| {
                parents[i] = node_location;
            }
        },
        .@"usingnamespace" => {
            parents[node.data.rhs] = node_location;
        },
        else => null,
    };
}

pub fn get_parents(allocator: std.mem.Allocator, full_ast: Ast) []i32 {
    const parents: [full_ast.nodes.len]i32 = undefined;
    for (0..parents) |i| {
        parents[i] = -1; // no parent
    }
    for (0..parents) |i| {
        generate_offspring(full_ast, i, parents);
    }

    return parents;
}

const edge = struct {
    start: usize,
    end: usize,
};

pub fn get_edges(allocator: std.mem.Allocator, full_ast: Ast) []edge {
    const parents = get_parents(full_ast);
    var list = std.ArrayList(edge).init(allocator);

    for (0..parents) |i| {
        const parent = parents[i];
        if (parent != -1) {
            list.append(edge{ .start = parent, .end = i });
        }
    }

    const edges = list.toOwnedSlice();
    return edges;
}
