.PHONY: all compile deploy test

REGISTRY  = registry.bukalapak.io/bukalapak
DDIR      = deploy
ODIR      = $(DDIR)/_output
VERSION   = $(shell git show -q --format=%h)
DEFENV    = production canary sandbox
DIRS      = $(shell cd deploy && ls -d */ | grep -v "_")
SQUAD     = default
PROJECT   = opencov
SERVICES ?= $(DIRS:/=)
ENV      ?= $(DEFENV)
FILE     ?= deployment

ACTION  = $(CREATE) || $(REPLACE)
CREATE  = kubectl --namespace=$(SQUAD) create -f $(ODIR)/$(var)/$(ENV)/$(FILE).yml
REPLACE = kubectl --namespace=$(SQUAD) replace -f $(ODIR)/$(var)/$(ENV)/$(FILE).yml

DATE       = $(shell date +'%Y%m%d-%H%M%S')
DEPLOY_TAG = deploy-$(ENV)-$(DATE)
BRANCH     = $(shell git rev-parse --abbrev-ref HEAD)

all: consul compile build push kubefile deploy

test:
	sh cover.sh

dep:
	mix deps.get

db-setup:
	mix ecto.setup

compile:
	mix assets.compile

$(ODIR):
	mkdir -p $(ODIR)

consul: $(ODIR)
	wget -O consul.tgz https://releases.hashicorp.com/envconsul/0.6.2/envconsul_0.6.2_linux_amd64.tgz
	tar -xf consul.tgz -C $(ODIR)/
	rm consul.tgz

build:
	$(foreach var, $(SERVICES), docker build -t $(REGISTRY)/$(PROJECT)/$(var):$(VERSION) -f ./deploy/$(var)/Dockerfile .;)

push:
	$(foreach var, $(SERVICES), docker push $(REGISTRY)/$(PROJECT)/$(var):$(VERSION);)

kubefile: $(ODIR)
ifeq ($(ENV),$(DEFENV))
	kubelize deployment -v $(VERSION) $(SERVICES)
else
	kubelize deployment -e $(ENV) -v $(VERSION) $(SERVICES)
endif

deploy:
	$(foreach var, $(SERVICES), $(ACTION);)

deploy-tag:
	git tag -a $(DEPLOY_TAG) -m "from $(BRANCH)"
	git push origin $(DEPLOY_TAG)

setup:
	docker run --rm -it --network host -v $PWD/db:/app/db -v $PWD/.env:/app/.env registry.bukalapak.io/sre/migration:0.0.1 db:create
	docker run --rm -it --network host -v $PWD/db:/app/db -v $PWD/.env:/app/.env registry.bukalapak.io/sre/migration:0.0.1 db:migrate

migrate:
	docker run --rm -it --network host -v $PWD/db:/app/db -v $PWD/.env:/app/.env registry.bukalapak.io/sre/migration:0.0.1 db:migrate
