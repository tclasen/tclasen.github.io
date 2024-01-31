.PHONY: all
all: test

.PHONY: test
test: install
	pre-commit run --all-files

.PHONY: build
build: result
	docker run \
		-e LANG=C.UTF-8 -e LC_ALL=C.UTF-8 \
		-v $$PWD:/data \
		sridca/emanote emanote -L "/data" gen result

.PHONY: run
run:
	@echo "Running server on http://0.0.0.0:1337"
	docker run \
		-e LANG=C.UTF-8 -e LC_ALL=C.UTF-8 \
		-v $$PWD:/data -p 1337:1337 \
		sridca/emanote emanote -L "/data" run --host=0.0.0.0 --port=1337

result:
	mkdir -p result

.PHONY: install
install: .git/hooks/pre-commit

.git/hooks/pre-commit: .pre-commit-config.yaml
	pre-commit install \
		--hook-type commit-msg \
		--hook-type pre-push

.PHONY: clean
clean:
	pre-commit clean
	git clean -dfX
