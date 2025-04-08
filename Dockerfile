FROM osrm/osrm-backend

WORKDIR /data

# ✅ curl 먼저 설치
RUN apt-get update && apt-get install -y curl

# ✅ 서버에서 .pbf 다운로드 및 추출
RUN curl -o south-korea-latest.osm.pbf https://download.geofabrik.de/asia/south-korea-latest.osm.pbf && \
    osrm-extract -p /opt/bicycle.lua south-korea-latest.osm.pbf && \
    osrm-partition south-korea-latest.osrm && \
    osrm-customize south-korea-latest.osrm

EXPOSE 5000

CMD ["osrm-routed", "--algorithm", "mld", "/data/south-korea-latest.osrm", "-i", "0.0.0.0"]