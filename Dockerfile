# ──────────── 1) Build stage ────────────
# Maven + JDK 21 (apa pun vendor) untuk compile; di sini pakai Eclipse Temurin.
FROM maven:3.9.7-eclipse-temurin-21 AS build

WORKDIR /app
COPY pom.xml mvnw* ./
COPY .mvn .mvn
COPY src src

# Build jar – skip test agar cepat; hilangkan opsi ini jika perlu menjalankan test.
RUN mvn -B -DskipTests clean package

# ──────────── 2) Runtime stage ────────────
# BellSoft Liberica **runtime** (hanya JRE) Java 21, varian Alpine musl (≈ 60 MB).
FROM bellsoft/liberica-runtime-container:jre-21-slim-musl AS runtime

# (Opsional) tambahkan user non-root demi keamanan
RUN addgroup -S spring && adduser -S spring -G spring
USER spring

WORKDIR /app
COPY --from=build /app/target/*-SNAPSHOT.jar app.jar

# Lingkungan & tunable dasar
ENV TZ=Asia/Jakarta \
    JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport"

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
