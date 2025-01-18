# funky - a functional library for Zig

Implementation not recursive

## Development


Test code is at the end of the file _save for_ a test basically
showing example usage, which is immediately below,

iterator?
into_iter?
collect

for_each
fn for_each() {
    let v = vec!["Hello", "World", "!"].into_iter();

    v.for_each(|word| {
        println!("{}", word);
    });
}


from_iter pair -> hash



## Support

inspect

filter_map

Maybe

## Research

- match/case
- memoize
- sort
- partial
- persistent data structures https://github.com/tobgu/pyrsistent
- callback https://www.haible.de/bruno/documentation/ffcall/callback/callback.html
- infinite iterators


## Future

- parallel iterators
- streams (async)


## References

- https://kerkour.com/rust-functional-programming
- https://research.utwente.nl/en/publications/functional-c
