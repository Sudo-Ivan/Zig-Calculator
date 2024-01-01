const std = @import("std");
const asc = std.ascii;
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    stdout.writeAll("Please enter two values seperated by an operator. (i.e. 5 + 4)\n") catch {};
    stdout.writeAll("Operators can be +, -, *, /, ^: \n") catch {};

    const line = try stdin.readUntilDelimiterAlloc(alloc, '\n', 100);
    const buf = std.mem.trim(u8, line, "\x20");

    var n: u32 = 0;
    var sp: u32 = 0;
    var cnt: u32 = 0;

    while (n < buf.len) {
        if (!asc.isDigit(buf[n]) and buf[n] != '.') {
            cnt += 1;
            if (cnt == 1) sp = n;
        }
        n += 1;
    }
    const op = std.mem.trim(u8, buf[sp .. sp + cnt], "\x20");
    const val1 = try std.fmt.parseFloat(f64, buf[0..sp]);
    const val2 = try std.fmt.parseFloat(f64, buf[sp + cnt ..]);

    switch (op[0]) {
        '+' => stdout.print("{d} + {d} = {d}\n", .{ val1, val2, val1 + val2 }) catch {},
        '-' => stdout.print("{d} - {d} = {d}\n", .{ val1, val2, val1 - val2 }) catch {},
        '*' => stdout.print("{d} * {d} = {d}\n", .{ val1, val2, val1 * val2 }) catch {},
        '/' => {
            if (val2 == 0) {
                try stdout.writeAll("Seriously, bro! You can't divide by zero!\n");
            } else stdout.print("{d} / {d} = {d}\n", .{ val1, val2, val1 / val2 }) catch {};
        },
        '^' => stdout.print("{d} ^ {d} = {d}\n", .{ val1, val2, std.math.pow(f64, val1, val2) }) catch {},
        else => stdout.print("An error has occured. :/\n", .{}) catch {},
    }
}
