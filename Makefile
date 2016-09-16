USER=mbaltrusitis
NAME=nzbhydra
IMAGE=$(USER)/$(NAME)
DATA=v_$(NAME)
PORT=5075


build:
	docker build -t $(IMAGE) .

clean: clean-src clean-image

cleaner: clean-src clean-data clean-image

clean-data:
	@docker rm -f $(DATA)

clean-image:
	@docker rmi -f $(IMAGE)

clean-src:
	@docker rm -f $(NAME)

run:
	@docker run --name=$(DATA) $(IMAGE) /bin/true \
			&& docker run --restart=always --name=$(NAME) --volumes-from=$(DATA) \
			-p $(PORT):$(PORT) $(IMAGE) \
	|| echo 'Data volume container already exists. Reusing it.' \
			&& docker run --restart=always -d --name=$(NAME) --volumes-from=$(DATA) \
			-p $(PORT):$(PORT) $(IMAGE) \
	|| echo 'Application container already exists. Reusing it.' \
			&& docker start $(NAME)

stop:
	@docker stop $(NAME)

help:
	@echo "\nMakefile help for the $(IMAGE) container."
	@echo "    -build"
	@echo "        Build the Dockerfile."
	@echo "    -run"
	@echo "        Build and run the Dockerfile."
	@echo "    -clean-all"
	@echo "        Remove both the data-only and source containers."
	@echo "    -clean-src"
	@echo "        Remove the application source container."
	@echo "    -clean-data"
	@echo "        Remove the application persistent data container."
	@echo "        WARNING: This will remove any configurations."

