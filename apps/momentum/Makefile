.PHONY: all test build clean swift-test swift-build swift-format swift-lint format lint install-tools tail-logs

XCODE_DEVELOPER_PATH ?= /Applications/Xcode.app/Contents/Developer
XCODE_CLEAN_PATH = $(XCODE_DEVELOPER_PATH)/Toolchains/XcodeDefault.xctoolchain/usr/bin:$(XCODE_DEVELOPER_PATH)/usr/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$$PATH
XCODE_ENV = env -u CC -u CXX -u OBJC -u OBJCXX -u SDKROOT -u CPATH -u LIBRARY_PATH -u NIX_CFLAGS_COMPILE -u NIX_LDFLAGS -u NIX_CFLAGS_LINK -u NIX_CC -u CFLAGS -u CXXFLAGS -u OBJCFLAGS -u LDFLAGS -u CPPFLAGS -u DYLD_LIBRARY_PATH -u LD -u AR -u RANLIB PATH="$(XCODE_CLEAN_PATH)"

# Default target
all: build test

# Install required tools
install-tools:
	@echo "Building swift-format tooling..."
	@cd BuildTools && swift build

# Swift targets
swift-format:
	@echo "Formatting Swift code..."
	@./scripts/run-swift-format.sh format --recursive --in-place --configuration $(PWD)/.swift-format $(PWD)

swift-generate:
	@echo "Generating Xcode project..."
	@$(XCODE_ENV) DEVELOPER_DIR=$(XCODE_DEVELOPER_PATH) tuist generate

swift-build-only:
	@echo "Building Swift app..."
	@$(XCODE_ENV) DEVELOPER_DIR=$(XCODE_DEVELOPER_PATH) xcodebuild -workspace Momentum.xcworkspace \
		-scheme MomentumApp \
		-configuration Debug \
		build \
		-skipMacroValidation \
		-quiet

swift-lint:
	@echo "Checking Swift formatting..."
	@./scripts/run-swift-format.sh lint --recursive --configuration $(PWD)/.swift-format $(PWD)

swift-test-only:
	@echo "Running Swift tests..."
	@$(XCODE_ENV) DEVELOPER_DIR=$(XCODE_DEVELOPER_PATH) xcodebuild -workspace Momentum.xcworkspace \
		-scheme MomentumApp \
		-configuration Debug \
		test \
		-skipMacroValidation \
		-quiet

# Convenience targets that build everything
swift-build: swift-build-only

swift-test: swift-test-only

# Combined targets

lint: swift-lint

build: swift-generate swift-build

test: lint swift-test

# Clean build artifacts

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf MomentumApp/Resources/momentum
	@if [ -d "Momentum.xcworkspace" ]; then \
		xcodebuild -workspace Momentum.xcworkspace -scheme MomentumApp clean -quiet; \
	fi

# Tail logs from the Momentum app
tail-logs:
	@echo "Tailing Momentum app logs..."
	@log stream --predicate 'subsystem == "com.bkase.MomentumApp"' --level debug
