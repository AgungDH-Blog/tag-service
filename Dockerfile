# ──────────── 1) Build stage ────────────
FROM bellsoft/liberica-openjdk-alpine:21 AS build

WORKDIR /app

# Salin Maven wrapper lebih dulu lalu beri izin eksekusi
COPY mvnw ./
RUN chmod +x mvnw
COPY .mvn .mvn
COPY pom.xml ./

# Ambil dependensi dulu agar cache efektif
RUN ./mvnw -B -DskipTests dependency:go-offline

# Salin kode sumber & build
COPY src src
RUN ./mvnw -B -DskipTests clean package

# ──────────── 2) Runtime stage ────────────
FROM bellsoft/liberica-runtime-container:jre-21-slim-musl AS runtime

# (Opsional) jalankan sebagai non-root demi keamanan
RUN addgroup -S spring && adduser -S spring -G spring
USER spring

WORKDIR /app
COPY --from=build /app/target/*-SNAPSHOT.jar app.jar

# Lingkungan dasar JVM
ENV TZ=Asia/Jakarta \
    JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport"

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
