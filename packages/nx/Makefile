SRCS = $(shell find nx -type f -name '*.scm')
OBJS = $(patsubst %.scm,%.go,$(SRCS))

.PHONY: all install

all: $(OBJS)

install: $(OBJS) nx.go
	mkdir -p $(ROOT)/bin
	cp nx.scm $(ROOT)/bin/nx

	for src in $(SRCS); do \
	  mkdir -p $(ROOT)/share/guile/site/3.0/$$(dirname $$src); \
	  cp $$src $(ROOT)/share/guile/site/3.0/$$(dirname $$src); \
	done

	for obj in $(OBJS); do \
	  mkdir -p $(ROOT)/lib/guile/3.0/site-ccache/$$(dirname $$obj); \
	  cp $$obj $(ROOT)/lib/guile/3.0/site-ccache/$$(dirname $$obj); \
	done

	cp nx.go $(ROOT)/lib/guile/3.0/site-ccache

%.go: %.scm
	guild compile --load-path=. -o $@ $<
