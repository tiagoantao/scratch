pub fn dec(comptime X: type, comptime Y: type, x: X) Y {
    const val: Y = @intCast(x);
    return val - 1;
}

fn decFn(comptime T: type) fn (T) T {
    return struct {
        fn inner(x: T) T {
            return dec(T, T, x);
        }
    }.inner;
}

pub const dec_i64 = decFn(i64);
pub const dec_i32 = decFn(i32);
