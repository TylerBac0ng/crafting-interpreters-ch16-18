CC ?= cc
CFLAGS ?= -std=c99 -Wall -O2

build/clox: src/*.c src/*.h
	mkdir -p build
	$(CC) $(CFLAGS) src/*.c -o $@

# The reduced instruction set from 18.1.
minimal: src/*.c src/*.h
	mkdir -p build
	$(CC) $(CFLAGS) -DMINIMAL_INSTRUCTIONS src/*.c -o build/clox-minimal

# Prints the bytecode, then the stack and each instruction as it runs.
trace: src/*.c src/*.h
	mkdir -p build
	$(CC) $(CFLAGS) -DDEBUG_PRINT_CODE -DDEBUG_TRACE_EXECUTION src/*.c -o build/clox-trace

# Prints each call to the parsing functions (17.1).
parse-trace: src/*.c src/*.h
	mkdir -p build
	$(CC) $(CFLAGS) -DDEBUG_TRACE_PARSE src/*.c -o build/clox-parse-trace

test:
	./run_tests.sh

clean:
	rm -rf build

.PHONY: minimal trace parse-trace test clean
