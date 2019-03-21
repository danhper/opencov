.PHONY: all compile deploy test

IMAGE = $(CI_REGISTRY)/bukalapak/opencov/$(svc)
DIRS  = $(shell cd deploy && ls -d */ | grep -v "_output")
FILE ?= deployment
ODIR := deploy/_output
 
export VERSION            ?= $(shell git show -q --format=%h)
export VAR_SERVICES       ?= $(DIRS:/=)
export VAR_KUBE_NAMESPACE ?= default
export VAR_CONSUL_PREFIX  ?= opencov

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
	@mkdir -p $(ODIR)

consul: $(ODIR)
	wget -O consul.tgz https://releases.hashicorp.com/envconsul/0.6.2/envconsul_0.6.2_linux_amd64.tgz
	tar -xf consul.tgz -C $(ODIR)/
	rm consul.tgz

build:
	@$(foreach svc, $(VAR_SERVICES), \
		docker build -t $(IMAGE):$(VERSION) -f ./deploy/$(svc)/Dockerfile .;)
 
push:
	@$(foreach svc, $(VAR_SERVICES), \
		docker push $(IMAGE):$(VERSION);)

checkenv:
ifndef ENV
	$(error ENV must be set.)
endif
 
deploy: checkenv $(ODIR)
	@$(foreach svc, $(VAR_SERVICES), \
		echo deploying "$(svc)" to environment "$(ENV)" && \
		! kubelize genfile --overwrite -c ./ -s $(svc) -e $(ENV) deploy/$(svc)/$(FILE).yml $(ODIR)/$(svc)/ || \
		kubectl apply -f $(ODIR)/$(svc)/$(FILE).yml ;)
 
# only generate files from services
kubefile: checkenv $(ODIR)
	$(foreach svc, $(VAR_SERVICES), \
		$(foreach f, $(shell ls deploy/$(svc)/*.yml), \
			kubelize genfile --overwrite -c ./ -s $(svc) -e $(ENV) $(f) $(ODIR)/$(svc)/;))
