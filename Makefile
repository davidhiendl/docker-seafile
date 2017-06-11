default: image

docker-image = dhswt/seafile
docker-tag = pro-6.0.13

image:
	docker build --squash \
		-t $(docker-image):$(docker-tag) \
		.

test-image:
	docker build \
		-t $(docker-image):$(docker-tag)-test \
		.

test-enter:
	docker run \
		-ti \
		-e CONTAINER_DEBUG=1 \
		-e SERVER_NAME=TESTSERVER \
		-e SERVER_IP=localhost.localdomain \
		-e SEAFILE_ADMIN_MAIL=test@dhswt.de \
		-e SEAFILE_ADMIN_PASS=Temp12345 \
		-p 80:80 \
		--entrypoint bash \
		$(docker-image):$(docker-tag)-test
		
test-run:
	docker run \
		-ti \
		-e CONTAINER_DEBUG=1 \
		-e SERVER_NAME=TESTSERVER \
		-e SERVER_IP=localhost.localdomain \
		-e SEAFILE_ADMIN_MAIL=test@dhswt.de \
		-e SEAFILE_ADMIN_PASS=Temp12345 \
		-e SERVER_IP=localhost.localdomain \
		-p 80:80 \
		$(docker-image):$(docker-tag)-test

push:
	docker push $(docker-image):$(docker-tag)

show-images:
	docker images | grep "$(docker-image)"

# Remove dangling images
clean-images:
	docker images -a -q \
		--filter "reference=$(docker-image)" \
		--filter "dangling=true" \
	| xargs docker rmi

# Remove all images
clear-images:
	docker images -a -q \
		--filter "reference=$(docker-image)" \
	| xargs docker rmi
