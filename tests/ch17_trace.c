// flags: -DDEBUG_TRACE_PARSE
// 17.1: prints the parse function calls for the expression from the
// challenge, and for a conditional expression (17.3).
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
  run("(-1 + 2) * 3 - -4");
  run("1 < 2 ? 3 : 4 + 5");
  freeVM();
  return 0;
}
