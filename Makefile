IMAGE_NAME := waja/garbd

build:
	docker build --rm -t $(IMAGE_NAME) .
	
run:
	@echo docker run --rm -it $(IMAGE_NAME) 
	
shell:
	docker run --rm -it --entrypoint sh $(IMAGE_NAME) -l

test: build
	@if ! [ "$$(docker run --rm -it $(IMAGE_NAME) garbd -h | grep ^Usage | cut -d' ' -f2)" = "garbd" ]; then exit 1; fi
