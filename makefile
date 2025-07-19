ifeq ($(OS),Windows_NT)
  ifeq ($(shell uname -s),) # not in a bash-like shell
	CLEANUP = rmdir /S /Q
	MKDIR = mkdir
  else # in a bash-like shell, like msys
	CLEANUP = rm -r
	MKDIR = mkdir -p
  endif
	TARGET_EXTENSION=exe
else
	CLEANUP = rm -r
	MKDIR = mkdir -p
	TARGET_EXTENSION=out
endif

.PHONY: clean
.PHONY: test

# Directory Paths
PATH_U = unity/src/
PATH_S = src/
PATH_I = include/
PATH_T = test/
PATH_TB = testbuild/
PATH_TB_D = $(PATH_TB)depends/
PATH_TB_D_S = $(PATH_TB_D)src/
PATH_TB_D_T = $(PATH_TB_D)test/
PATH_TB_O = $(PATH_TB)objs/
PATH_TB_O_S = $(PATH_TB_O)src/
PATH_TB_O_T = $(PATH_TB_O)test/
PATH_TB_O_U = $(PATH_TB_O)unity/
PATH_TB_R = $(PATH_TB)results/
PATH_TB_N = $(PATH_TB)bin/

# Find source code recursively
SRC_T = $(shell find $(PATH_T) -name "*.c")
SRC_S_NOMAIN = $(shell find $(PATH_S) -name "*.c" -not -name "main.c")
# Get list of objects
SRC_TB_O_S = $(patsubst $(PATH_S)%.c,$(PATH_TB_O_S)%.o,$(SRC_S_NOMAIN))
SRC_TB_O_T = $(patsubst $(PATH_T)%.c,$(PATH_TB_O_T)%.o,$(SRC_T))
# Get list of depends files
DEPEND_TB_S = $(patsubst $(PATH_TB_O_S)%.o,$(PATH_TB_D_S)%.d,$(SRC_TB_O_S))
DEPEND_TB_T = $(patsubst $(PATH_TB_O_T)%.o,$(PATH_TB_D_T)%.d,$(SRC_TB_O_T))
ALL_DEPEND_TB = $(DEPEND_TB_S) $(DEPEND_TB_T)

# Compiler Flags
CC = gcc
CFLAGS = -I$(PATH_I)
TCFLAGS = $(CFLAGS) -I$(PATH_U) -DTEST
CPPFLAGS = -MMD -MF
COMPILE = $(CC) -c
LINK = $(CC)



RESULTS = $(patsubst $(PATH_T)%Test.c,$(PATH_TB_R)%Test.txt,$(SRC_T))

PASSED = `grep -r -s PASS $(PATH_TB_R)`
FAIL = `grep -r -s FAIL $(PATH_TB_R)`
IGNORE = `grep -r -s IGNORE $(PATH_TB_R)`

test: $(RESULTS)
	@echo "-----------------------\nIGNORES:\n-----------------------"
	@echo "$(IGNORE)"
	@echo "-----------------------\nFAILURES:\n-----------------------"
	@echo "$(FAIL)"
	@echo "-----------------------\nPASSED:\n-----------------------"
	@echo "$(PASSED)"
	@echo "\nDONE"

$(PATH_TB_R)%.txt: $(PATH_TB_N)%.$(TARGET_EXTENSION)
	@$(MKDIR) $(dir $@)
	-./$< > $@ 2>&1

$(PATH_TB_N)%Test.$(TARGET_EXTENSION): $(PATH_TB_O_T)%Test.o $(PATH_TB_O_U)unity.o $(SRC_TB_O_S)
	@$(MKDIR) $(dir $@)
	$(LINK) -o $@ $^

$(PATH_TB_O_T)%.o: $(PATH_T)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(TCFLAGS) $(CPPFLAGS) "$(@:$(PATH_TB_O_T)%.o=$(PATH_TB_D_T)%.d)" $< -o $@

$(PATH_TB_O_S)%.o: $(PATH_S)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(TCFLAGS) $(CPPFLAGS) "$(@:$(PATH_TB_O_S)%.o=$(PATH_TB_D_S)%.d)" $< -o $@

$(PATH_TB_O_U)%.o:: $(PATH_U)%.c $(PATH_U)%.h
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(TCFLAGS) $< -o $@

$(ALL_DEPEND_TB):
	@$(MKDIR) $(PATH_TB)
	@$(MKDIR) $(dir $@)

-include $(ALL_DEPEND_TB)

clean:
	$(CLEANUP) $(PATH_TB)
	@echo "cleaned"

.PRECIOUS: $(PATH_TB_N)%Test.$(TARGET_EXTENSION)
.PRECIOUS: $(PATH_TB_D)%.d
.PRECIOUS: $(PATH_TB_O_S)%.o
.PRECIOUS: $(PATH_TB_O_T)%.o
.PRECIOUS: $(PATH_TB_O_U)%.o
.PRECIOUS: $(PATH_TB_R)%.txt