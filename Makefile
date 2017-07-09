all: build

build: 
	@docker build --tag=vin0x64/e2guardian .

nocache: 
	@docker build --no-cache --tag=vin0x64/e2guardian .
