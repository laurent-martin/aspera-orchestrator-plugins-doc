# Build plugin doc for IBM Aspera Orchestrator
# Laurent Martin

# working folder
BUILD_MAIN_DIR=build/$(VERSION)/
BUILD_SRC_DIR=$(BUILD_MAIN_DIR)src/
BUILD_OUT_DIR=$(BUILD_MAIN_DIR)out/

all: $(BUILD_OUT_DIR)doc.created

# requires: brew install wkhtmltopdf
$(BUILD_OUT_DIR)doc.created: $(BUILD_OUT_DIR)doc.html
	wkhtmltopdf --enable-local-file-access file://$$(pwd -P)/$(BUILD_OUT_DIR)doc.html $(BUILD_OUT_DIR)Orchestrator_$(VERSION)_Plugin_Manual.pdf
	wkhtmltopdf --enable-local-file-access file://$$(pwd -P)/$(BUILD_OUT_DIR)summary.html $(BUILD_OUT_DIR)Orchestrator_$(VERSION)_Plugin_List.pdf
	wkhtmltopdf --enable-local-file-access -O landscape file://$$(pwd -P)/$(BUILD_OUT_DIR)banner.html $(BUILD_OUT_DIR)Orchestrator_$(VERSION)_Plugin_Banner.pdf
	touch $@

# build doc (create latest link)
$(BUILD_OUT_DIR)doc.html: $(BUILD_MAIN_DIR)
	./generateAODoc.rb $(VERSION) $(BUILD_SRC_DIR) $(BUILD_OUT_DIR)
$(BUILD_MAIN_DIR):
	@echo "do: VERSION=xxx RPM=/path/to/rpm make extract_rpm  or  make extract_remote"
	@exit 1
extract_rpm:
	@if test -z "$(RPM)";then echo "set RPM env var";exit 1;fi
	@if test -z "$(VERSION)";then echo "set VERSION env var";exit 1;fi
	echo "Version: $(VERSION)"
	mkdir -p $(BUILD_MAIN_DIR)
	mkdir $(BUILD_OUT_DIR)
	mkdir -p $(BUILD_SRC_DIR)lib
	mkdir $(BUILD_MAIN_DIR)rpmout
	rpm2cpio $(RPM)|(cd $(BUILD_MAIN_DIR)rpmout && cpio -idv "*/actions/*" "*/lib/action_tools.rb")
	mv $(BUILD_MAIN_DIR)rpmout/opt/aspera/orchestrator*/actions $(BUILD_SRC_DIR)
	mv $(BUILD_MAIN_DIR)rpmout/opt/aspera/orchestrator*/lib/action_tools.rb $(BUILD_SRC_DIR)lib
	rm -fr $(BUILD_MAIN_DIR)rpmout
extract_remote:
	@if test -z "$(RPM)";then echo "set RPM env var";exit 1;fi
	@if test -z "$(VERSION)";then echo "set VERSION env var";exit 1;fi
	echo "Version: $(VERSION)"
	mkdir -p $(BUILD_MAIN_DIR)
	mkdir $(BUILD_OUT_DIR)
	mkdir -p $(BUILD_SRC_DIR)lib
	$(ASCP) -l 100m $(KEYS) -d --mode=recv --host=$(REMOTE_HOST) --user=$(REMOTE_USER) --src-base=/opt/aspera/orchestrator/actions /opt/aspera/orchestrator/actions $(BUILD_SRC_DIR)actions
	$(ASCP) -l 100m $(KEYS) -d --mode=recv --host=$(REMOTE_HOST) --user=$(REMOTE_USER) /opt/aspera/orchestrator/lib/action_tools.rb $(BUILD_SRC_DIR)lib
clean:
	rm -f $(BUILD_OUT_DIR)*.{html,pdf,created}
