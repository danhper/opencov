REGISTRY	= registry.bukalapak.io/bukalapak
VERSION		=	0.1.0

all: build

build:
	docker build -t $(REGISTRY)/opencov:$(VERSION) .

