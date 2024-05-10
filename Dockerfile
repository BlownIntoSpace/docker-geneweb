FROM ubuntu:latest

# Geneweb install directory
ARG GENEWEB_DOWNLOAD_NAME=geneweb-linux.zip
ARG GENEWEB_URL=https://github.com/geneweb/geneweb/releases/latest/download/${GENEWEB_DOWNLOAD_NAME}

# Geneweb config arguments
# ENV LANGUAGE en
# ENV HOST_IP 172.17.0.1


ENV GENEWEB_INSTALL_DIR=/opt/geneweb
ENV GENEWEB_DIR = /geneweb
ENV PATH = $PATH:$GENEWEB_INSTALL_DIR/gw

# Install dependencies
RUN apt-get update && \ apt-get -y upgrade
RUN apt-get -y install curl zip

# Copy scripts to local bin folder
COPY bin/*.sh /usr/local/bin/

# Make scripts executable
RUN chmod a+x /usr/local/bin/*.sh

# Install geneweb
RUN curl -L $package_url -o /tmp/${GENEWEB_DOWNLOAD_NAME}
RUN mkdir -p ${GENEWEB_INSTALL_DIR}
RUN unzip /tmp/${GENEWEB_DOWNLOAD_NAME} -d ${GENEWEB_INSTALL_DIR}
RUN rm /tmp/${GENEWEB_DOWNLOAD_NAME}

# Create geneweb directories
RUN mkdir -p ${GENEWEB_DIR}

# Create geneweb user
RUN useradd -d ${GENEWEB_DIR} geneweb

# Ensure that the geneweb user own every geneweb files
RUN chown -R geneweb ${GENEWEB_INSTALL_DIR}
RUN chown -R geneweb ${GENEWEB_DIR}

# Create a volume on the container
VOLUME ${GENEWEB_INSTALL_DIR}
VOLUME ${GENEWEB_DIR}

# Expose the geneweb and gwsetup ports to the docker host
EXPOSE 2317
EXPOSE 2316

# Run the container as the geneweb user
USER geneweb

ENTRYPOINT ["main.sh"]
CMD ["start-all"]
