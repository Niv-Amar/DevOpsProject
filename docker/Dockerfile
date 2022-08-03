FROM python:latest
# Coping and install the requirements.txt before copying the application to avoid ->
# Invalidating the Docker build cache every time you're copying the entire application into the image. ->
# This will also invalidate the cache for all subsequent build steps.
RUN mkdir /opt/app
COPY requirements.txt /opt/app/requirements.txt
WORKDIR /opt/app
RUN pip3 install -r requirements.txt
COPY api.py /opt/app/api.py
COPY data_base.py /opt/app/data_base.py
#app requirements
ENV MONGODB_USERNAME=root
ENV MONGODB_PASSWORD=pass123
ENV MONGODB_HOSTNAME=mongodb
#ENV MONGODB_DATABASE=drinks
ENV DB_PORT=27017
#The ports you will need to make sure are open
# 1)Flask running port. 2)Mongodb port.
EXPOSE 6000
EXPOSE 27017
CMD [ "python", "./api.py" ]
