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

PATHU = unity/src/
PATHS = src/
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
PATHI = include/



# Find source code recursively
SRCT = $(shell find $(PATHT) -name "*.c")
SRCS = $(shell find $(PATHS) -name "*.c")
SRCSNOTMAIN = $(shell find $(PATHS) -name "*.c" -not -name "main.c")
SRCOS = $(patsubst $(PATHS)%.c,$(PATHOS)%.o,$(SRCSNOTMAIN))
SRCOT = $(patsubst $(PATHT)%.c,$(PATHOT)%.o,$(SRCT))
DEPENDS = $(patsubst $(PATHOS)%.o,$(PATHDS)%.d,$(SRCOS))
DEPENDT = $(patsubst $(PATHOT)%.o,$(PATHDT)%.d,$(SRCOT))






COMPILE=gcc -c
LINK=gcc
DEPEND=gcc -MM -MG -MF

CFLAGS=-I. -I$(PATHU) -I$(PATHS) -I$(PATHI) -DTEST

RESULTS = $(patsubst $(PATHT)%Test.c,$(PATHR)%Test.txt,$(SRCT))
#SRCOBJECTSNOTMAIN = $(patsubst $(PATHS)%.c,$(PATHOS)%.o,$(SRCSNOTMAIN))



PASSED = `grep -r -s PASS $(PATHR)`
FAIL = `grep -r -s FAIL $(PATHR)`
IGNORE = `grep -r -s IGNORE $(PATHR)`

test: $(DEPENDS) $(DEPENDT) $(RESULTS)
	@echo "-----------------------\nIGNORES:\n-----------------------"
	@echo "$(IGNORE)"
	@echo "-----------------------\nFAILURES:\n-----------------------"
	@echo "$(FAIL)"
	@echo "-----------------------\nPASSED:\n-----------------------"
	@echo "$(PASSED)"
	@echo "\nDONE"

$(PATHR)%.txt: $(PATHE)%.$(TARGET_EXTENSION)
	@echo $(DEPENDS)
	@$(MKDIR) $(dir $@)
	-./$< > $@ 2>&1

$(PATHE)%Test.$(TARGET_EXTENSION): $(PATHOT)%Test.o $(PATHOS)%.o $(PATHOU)unity.o $(PATHOS)utils/math.o #$(SRCOBJECTSNOTMAIN) #$(PATHD)Test%.d
	@$(MKDIR) $(dir $@)
	$(LINK) -o $@ $^

$(PATHOT)%.o: $(PATHT)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) -MMD -MF"$(@:$(PATHOT)%.o=$(PATHDT)%.d)" $^ -o $@

$(PATHOS)%.o: $(PATHS)%.c 
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) -MMD -MF"$(@:$(PATHOS)%.o=$(PATHDS)%.d)" $< -o $@

$(PATHOU)%.o:: $(PATHU)%.c $(PATHU)%.h
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) $< -o $@

$(DEPENDS):
	@$(MKDIR) $(PATHB)
	@$(MKDIR) $(dir $@)
	touch $@

$(DEPENDT):
	@$(MKDIR) $(PATHB)
	@$(MKDIR) $(dir $@)
	touch $@

#$(PATHD)%.d:: $(PATHT)%.c
#	@$(MKDIR) $(dir $@)
#	$(DEPEND) $@ $<

-include $(DEPENDS)
-include $(DEPENDT)

clean:
	$(CLEANUP) $(PATHB)
	@echo "cleaned"

.PRECIOUS: $(PATHE)%Test.$(TARGET_EXTENSION)
.PRECIOUS: $(PATHD)%.d
.PRECIOUS: $(PATHOS)%.o
.PRECIOUS: $(PATHOT)%.o
.PRECIOUS: $(PATHOU)%.o
.PRECIOUS: $(PATHR)%.txt