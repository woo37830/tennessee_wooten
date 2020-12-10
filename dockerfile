#Create ubuntu as base image
FROM ubuntu

#Install packages
RUN apt-get -y update
RUN apt-get -y install vim
RUN apt-get -y install firefox
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get -y install python3.7

