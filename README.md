docker run -p 8080:8080 \
-e SPRING_DATASOURCE_URL="jdbc:mariadb://172.17.0.1:3306/tag" \
-e SPRING_DATASOURCE_USERNAME="admin" \
-e SPRING_DATASOURCE_PASSWORD="admin" \
myapp