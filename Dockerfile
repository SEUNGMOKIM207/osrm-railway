FROM osrm/osrm-backend

WORKDIR /data

# ✅ 오래된 stretch-updates 라인 제거하고 curl 설치
RUN sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y curl

# ✅ .pbf 다운로드 및 OSRM 준비
RUN curl -o south-korea-latest.osm.pbf https://download.geofabrik.de/asia/south-korea-latest.osm.pbf && \
    osrm-extract -p /opt/bicycle.lua south-korea-latest.osm.pbf && \
    osrm-partition south-korea-latest.osrm && \
    osrm-customize south-korea-latest.osrm

EXPOSE 5000

CMD ["osrm-routed", "--algorithm", "mld", "/data/south-korea-latest.osrm", "-i", "0.0.0.0"]
