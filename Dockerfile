FROM osrm/osrm-backend

WORKDIR /data

# 다운로드로 처리 (최신 대한민국 지도)
RUN curl -o south-korea-latest.osm.pbf https://download.geofabrik.de/asia/south-korea-latest.osm.pbf && \
    osrm-extract -p /opt/bicycle.lua south-korea-latest.osm.pbf && \
    osrm-partition south-korea-latest.osrm && \
    osrm-customize south-korea-latest.osrm

EXPOSE 5000

CMD ["osrm-routed", "--algorithm", "mld", "/data/south-korea-latest.osrm", "-i", "0.0.0.0"]