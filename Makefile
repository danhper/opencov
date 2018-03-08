REGISTRY	= registry.bukalapak.io/bukalapak
VERSION		=	0.1.0

all: build push

build:
	docker build -t $(REGISTRY)/opencov:$(VERSION) .

push:
	docker push $(REGISTRY)/opencov:$(VERSION)
