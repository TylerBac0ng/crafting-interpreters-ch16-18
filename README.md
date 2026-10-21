# Crafting Interpreters — Chapters 16, 17 & 18 Challenges

Solutions to the end-of-chapter challenges from [_Crafting Interpreters_](https://craftinginterpreters.com/) by Robert Nystrom, chapters **16 (Scanning on Demand)**, **17 (Compiling Expressions)** and **18 (Types of Values)**. This is clox, the bytecode virtual machine in C, with the complete code through chapter 18: it scans, compiles and runs a single expression with numbers, booleans and `nil`.

## Build and run

```sh
make                  # builds build/clox (a REPL, or pass a file)
make minimal          # build/clox-minimal, the reduced instruction set (18.1)
make trace            # prints the bytecode and each instruction as it runs
make parse-trace      # prints each call to the parsing functions (17.1)
./run_tests.sh        # runs the tests
```

## Chapter 16 — Scanning on Demand

1. **String interpolation.** Implemented in the scanner. A new
   `TOKEN_INTERPOLATION` is a piece of a string that ends with `${`, and
   `TOKEN_STRING` is a plain string or the last piece. The scanner keeps a
   stack of open-brace counts, one per interpolation, so it knows which `}`
   ends one. The compiler can't use these tokens until clox has strings
   (chapter 19). See `tests/ch16_interpolation.c`.
2. **`>>` and generics.** Written answer (submitted separately).
3. **Contextual keywords.** Written answer (submitted separately).

## Chapter 17 — Compiling Expressions

1. **Parser trace.** Building with `-DDEBUG_TRACE_PARSE` prints every call
   to `expression()`, `parsePrecedence()` and the parse functions, nested.
   `tests/ch17_trace.c` checks the trace for `(-1 + 2) * 3 - -4`.
2. **Prefix and infix tokens.** Written answer (submitted separately).
3. **The conditional operator `?:`.** New `?` and `:` tokens, a
   `PREC_CONDITIONAL` level, and a `conditional()` infix rule. It also
   generates bytecode (`OP_JUMP_IF_FALSE`, `OP_JUMP` and `OP_POP`, as in
   chapter 23), so only one branch runs. Right associative, like C. See
   `tests/ch17_conditional.c`.

## Chapter 18 — Types of Values

1. **Fewer instructions.** With `-DMINIMAL_INSTRUCTIONS`, clox has 8
   instructions instead of the book's 14. `OP_NIL`, `OP_TRUE` and `OP_FALSE`
   become constants, `-x` becomes `x * -1`, `a - b` becomes `a + b * -1`, and
   `a > b` becomes `-a < -b`. The removed opcodes are left out of the enum, so
   using one is a compile error.
2. **More specific instructions.** The normal build adds `OP_NOT_EQUAL`,
   `OP_GREATER_EQUAL` and `OP_LESS_EQUAL`, so `!=`, `>=` and `<=` are one
   instruction instead of two. This also makes `NaN <= 1` false, as in IEEE
   754, where the book's `!(a > b)` gives true.

`tests/ch18_instructions.c` runs the same expressions in both builds, and
`tests/ch18_code.c` prints the bytecode for each operator.

## Files changed from the book's chapter 18 code

| File | Change |
|---|---|
| `scanner.h`, `scanner.c` | `TOKEN_INTERPOLATION` and the brace stack (16.1); `?` and `:` tokens (17.3) |
| `compiler.c` | Parse trace (17.1); `conditional()` and `PREC_CONDITIONAL` (17.3); minimal code generation (18.1); new comparison instructions (18.2) |
| `chunk.h`, `debug.c`, `vm.c` | Jump instructions (17.3); opcodes removed in the minimal build (18.1); `OP_NOT_EQUAL`, `OP_GREATER_EQUAL`, `OP_LESS_EQUAL` (18.2) |
| `common.h` | Debug flags are build options instead of `#define`s |

## Tests

`./run_tests.sh` builds every program in `tests/`, runs it, and compares its
output with its `.expected` file. Everything runs twice, once with the
normal instruction set and once with `-DMINIMAL_INSTRUCTIONS`, where a test
uses `<name>.minimal.expected` if it has one. All 10 tests pass.
