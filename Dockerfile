## Simple docker file which will copy the current directory
## and run the image rotate command

FROM ubuntu:18.04 AS builder
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN mkdir /app
WORKDIR /app
COPY . /app
RUN chmod +x ./deps.sh \
         && ./deps.sh \
         && mkdir build \
         && cd build \
         && cmake .. \
         && make

FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN mkdir /app
WORKDIR /app
COPY --from=builder /app/deps.sh  /app/.
COPY --from=builder /app/build/image_rotate /app/.
COPY --from=builder /app/plane.jpg /app/.
RUN chmod +x ./deps.sh \ 
         && ./deps.sh 
CMD ["./image_rotate","../plane.jpg", "plane_out.jpg"]

