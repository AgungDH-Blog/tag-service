#################### 1) Build stage ####################
FROM bellsoft/liberica-openjdk-alpine:21 AS build

WORKDIR /app
COPY mvnw ./
RUN chmod +x mvnw
COPY .mvn .mvn
COPY pom.xml ./
RUN ./mvnw -B -DskipTests dependency:go-offline

COPY src src
RUN ./mvnw -B -DskipTests clean package


#################### 2) Runtime stage ##################
FROM bellsoft/liberica-runtime-container:jre-21-slim-musl AS runtime

# (Opsional) jalankan sebagai non-root
RUN addgroup -S spring && adduser -S spring -G spring
USER spring

WORKDIR /app
COPY --from=build /app/target/*-SNAPSHOT.jar app.jar

# ---------- ENV dasar ----------
ENV TZ=Asia/Jakarta \
    JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport"
# -------------------------------

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget -qO- http://localhost:8081/actuator/health | grep -q '"status":"UP"' || exit 1

ENTRYPOINT ["java","-jar","/app/app.jar"]
