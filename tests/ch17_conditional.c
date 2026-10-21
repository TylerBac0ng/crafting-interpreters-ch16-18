// 17.3: the conditional operator.
#include <stdio.h>

#include "../src/vm.h"

static void run(const char* source) {
  printf("%-32s => ", source);
  interpret(source);
}

int main(void) {
  setvbuf(stdout, NULL, _IONBF, 0);
  initVM();
  run("true ? 1 : 2");
  run("false ? 1 : 2");
  run("nil ? 1 : 2");          // nil and false are the only falsey values.
  run("0 ? 1 : 2");
  // Lower precedence than everything else, so this is (1 + 1 == 2) ? ...
  run("1 + 1 == 2 ? 10 : 20");
  run("1 < 2 ? 3 : 4 + 5");    // The else branch is 4 + 5.
  run("(false ? 1 : 2) + 3");
  // Right associative: a ? b : (c ? d : e).
  run("false ? 1 : false ? 2 : 3");
  run("false ? 1 : true ? 2 : 3");
  // The middle operand can be another conditional.
  run("true ? false ? 1 : 2 : 3");
  // Only one branch runs: -nil would be a runtime error.
  run("true ? 1 : -nil");
  run("false ? -nil : 2");
  run("true ? -nil : 2");
  // Compile errors.
  run("true ? 1");
  run("true ? : 2");
  freeVM();
  return 0;
}
