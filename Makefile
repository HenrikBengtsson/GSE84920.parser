include .make/Makefile

vignettes/future-1-overview.md.rsp: inst/vignettes-static/future-1-overview.md.rsp.rsp
	$(CD) $(@D); \
	$(R_SCRIPT) -e "R.rsp::rfile" ../$< --postprocess=FALSE
	$(RM) README.md
	$(MAKE) README.md

vignettes: vignettes/future-1-overview.md.rsp

future.tests/%:
	$(R_SCRIPT) -e "future.tests::check" --args --test-plan=$*

future.tests: future.tests/sequential future.tests/multicore future.tests/multisession future.tests/cluster
