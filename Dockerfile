FROM ubuntu:22.04

ARG FILE_NAME=teamtalk-v5.20-ubuntu22-x86_64
ARG URL=https://bearware.dk/teamtalk/v5.20/teamtalk-v5.20-ubuntu22-x86_64.tgz

# Atualize o gerenciador de pacotes e instale o wget
RUN apt update && apt install wget -y && \
apt clean

# Baixe e descompacte o TeamTalk
RUN wget ${URL} && \
    gunzip ${FILE_NAME}.tgz && \
    tar xf ${FILE_NAME}.tar && \
    rm ${FILE_NAME}.tar

# Copie o servidor para o diretório corrente e remova os arquivos desnecessários
RUN cp -r ${FILE_NAME}/server . && rm -rf ${FILE_NAME}

# Defina as portas TCP e UDP 10333 como expostas
EXPOSE 10333/tcp 10333/udp

# Defina o diretório de trabalho como o diretório do servidor
WORKDIR /server

RUN useradd -r -d /server -s /usr/sbin/nologin teamtalk && \
    chown -R teamtalk:teamtalk /server
USER teamtalk

# Crie o diretório "data"
RUN mkdir data

CMD ./tt5srv -wd ./data -nd