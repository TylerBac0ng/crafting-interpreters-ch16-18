// flags: -DDEBUG_PRINT_CODE
// 18.1 and 18.2: the bytecode for each operator in both builds.
#include <stdio.h>

#include "../src/vm.h"

static void run(const char* source) {
  printf("%s\n", source);
  interpret(source);
  printf("\n");
}

int main(void) {
  setvbuf(stdout, NULL, _IONBF, 0);
  initVM();
  run("1 != 2");
  run("1 > 2");
  run("1 >= 2");
  run("1 <= 2");
  run("3 - 2");
  run("-3");
  run("true == !nil");
  run("-1 - -1");             // The -1 constant is shared in the minimal build.
  run("true ? 1 : 2");
  freeVM();
  return 0;
}
