#!/bin/bash
# Builds every test in tests/ against the clox sources, runs it, and compares
# its output with tests/<name>.expected. Everything runs twice: once with the
# normal instruction set and once with -DMINIMAL_INSTRUCTIONS (18.1). In the
# minimal build, a test uses tests/<name>.minimal.expected if there is one.
# A test can ask for extra compiler flags with a "// flags:" first line.
cd "$(dirname "$0")"
CC=${CC:-cc}
CFLAGS="-std=c99 -Wall -Wextra -Wno-unused-parameter -O2"
SOURCES=$(ls src/*.c | grep -v main.c)
mkdir -p build
pass=0
fail=0

check() {
  local name=$1 expected=$2 actual=$3
  if diff -u "$expected" "$actual" > build/diff.txt; then
    echo "PASS $name"
    pass=$((pass + 1))
  else
    echo "FAIL $name"
    cat build/diff.txt
    fail=$((fail + 1))
  fi
}

for mode in default minimal; do
  flags=$CFLAGS
  [ $mode = minimal ] && flags="$flags -DMINIMAL_INSTRUCTIONS"

  $CC $flags src/*.c -o build/clox-$mode || exit 1

  for test in tests/*.c; do
    name=$(basename "$test" .c)
    extra=$(sed -n '1s|^// flags: ||p' "$test")
    $CC $flags $extra $SOURCES "$test" -o build/$name-$mode || exit 1
    build/$name-$mode > build/$name.out 2>&1
    expected=tests/$name.expected
    if [ $mode = minimal ] && [ -f tests/$name.minimal.expected ]; then
      expected=tests/$name.minimal.expected
    fi
    check "$name ($mode)" $expected build/$name.out
  done
done

echo "$pass passed, $fail failed"
[ $fail -eq 0 ]
