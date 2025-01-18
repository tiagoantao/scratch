// Arithmetic ops
pub fn dec(comptime T: type, x: T) T {
    return x - 1;
}
fn decFn(comptime T: type) fn (T) T {
    return struct {
        fn inner(x: T) T {
            return dec(T, x);
        }
    }.inner;
}
pub const dec_i32 = decFn(i32);
pub const dec_i64 = decFn(i64);

pub fn sub(comptime T: type, x1: T, x2: T) T {
    return x1 - x2;
}
fn subFn(comptime T: type) fn (T, T) T {
    return struct {
        fn inner(x1: T, x2: T) T {
            return sub(T, x1, x2);
        }
    }.inner;
}
pub const sub_i32 = subFn(i32);
pub const sub_i64 = subFn(i64);

// Boolean outputs

pub fn gt(comptime T: type, x1: T, x2: T) bool {
    return x1 > x2;
}
pub fn gt_val(comptime T: type, val: T) fn (T) bool {
    return struct {
        fn inner(x: T) bool {
            return gt(T, x, val);
        }
    }.inner;
}
fn gtFn(comptime T: type) fn (T, T) bool {
    return struct {
        fn inner(x1: T, x2: T) bool {
            return gt(T, x1, x2);
        }
    }.inner;
}
pub const gt_i32 = gtFn(i32);
pub const gt_i64 = gtFn(i64);
