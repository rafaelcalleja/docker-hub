default: image

all: image

image:
	docker build -f Dockerfile \
	--cache-from rafaelcalleja/guestbuilder \
	-t rafaelcalleja/guestbuilder \
	--compress .

