FROM openjdk:8
COPY target/*.jar /
EXPOSE 8000
CMD ["java","-jar","target/*.jar"]
