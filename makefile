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
PATHU = unity/src/
PATHS = src/
PATHI = include/
PATHT = test/
PATHB = build/
PATHD = $(PATHB)depends/
PATHDS = $(PATHD)src/
PATHDT = $(PATHD)test/
PATHO = $(PATHB)objs/
PATHOS = $(PATHO)src/
PATHOT = $(PATHO)test/
PATHOU = $(PATHO)unity/
PATHR = $(PATHB)results/
PATHE = $(PATHB)executables/

# Find source code recursively
SRCT = $(shell find $(PATHT) -name "*.c")
SRCS = $(shell find $(PATHS) -name "*.c" -not -name "main.c")
# Get list of objects
SRCOS = $(patsubst $(PATHS)%.c,$(PATHOS)%.o,$(SRCS))
SRCOT = $(patsubst $(PATHT)%.c,$(PATHOT)%.o,$(SRCT))
# Get list of depends files
DEPENDS = $(patsubst $(PATHOS)%.o,$(PATHDS)%.d,$(SRCOS))
DEPENDT = $(patsubst $(PATHOT)%.o,$(PATHDT)%.d,$(SRCOT))
ALLDEPEND = $(DEPENDS) $(DEPENDT)

# Compiler Flags
CC = gcc
CFLAGS = -I$(PATHU) -I$(PATHI) -DTEST
CPPFLAGS = -MMD -MF
COMPILE = $(CC) -c
LINK = $(CC)



RESULTS = $(patsubst $(PATHT)%Test.c,$(PATHR)%Test.txt,$(SRCT))

PASSED = `grep -r -s PASS $(PATHR)`
FAIL = `grep -r -s FAIL $(PATHR)`
IGNORE = `grep -r -s IGNORE $(PATHR)`

test: $(RESULTS)
	@echo "-----------------------\nIGNORES:\n-----------------------"
	@echo "$(IGNORE)"
	@echo "-----------------------\nFAILURES:\n-----------------------"
	@echo "$(FAIL)"
	@echo "-----------------------\nPASSED:\n-----------------------"
	@echo "$(PASSED)"
	@echo "\nDONE"

$(PATHR)%.txt: $(PATHE)%.$(TARGET_EXTENSION)
	@$(MKDIR) $(dir $@)
	-./$< > $@ 2>&1

$(PATHE)%Test.$(TARGET_EXTENSION): $(PATHOT)%Test.o $(PATHOU)unity.o $(SRCOS)
	@$(MKDIR) $(dir $@)
	$(LINK) -o $@ $^

$(PATHOT)%.o: $(PATHT)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) $(CPPFLAGS) "$(@:$(PATHOT)%.o=$(PATHDT)%.d)" $< -o $@

$(PATHOS)%.o: $(PATHS)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) $(CPPFLAGS) "$(@:$(PATHOS)%.o=$(PATHDS)%.d)" $< -o $@

$(PATHOU)%.o:: $(PATHU)%.c $(PATHU)%.h
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) $< -o $@

$(DEPENDS):
	@$(MKDIR) $(PATHB)
	@$(MKDIR) $(dir $@)

$(DEPENDT):
	@$(MKDIR) $(PATHB)
	@$(MKDIR) $(dir $@)

-include $(ALLDEPEND)

clean:
	$(CLEANUP) $(PATHB)
	@echo "cleaned"

.PRECIOUS: $(PATHE)%Test.$(TARGET_EXTENSION)
.PRECIOUS: $(PATHD)%.d
.PRECIOUS: $(PATHOS)%.o
.PRECIOUS: $(PATHOT)%.o
.PRECIOUS: $(PATHOU)%.o
.PRECIOUS: $(PATHR)%.txt