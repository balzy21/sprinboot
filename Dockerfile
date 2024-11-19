# Use an official Maven image to build the app, then copy the artifact to a smaller base image
FROM ubuntu AS build

# Set the working directory for the build process
WORKDIR /springboot

# Copy the Maven project files into the container
COPY . .

RUN apt-get update && apt-get install -y openjdk-17-jdk maven

# Build the application using Maven
RUN mvn clean package

# Use a minimal JRE-only image to run the app
FROM openjdk:17-jdk-slim

# Set the working directory for the running container
WORKDIR /app

# Copy the built artifact from the build stage
COPY --from=build /springboot/target/*.jar app.jar

# Expose the application port
EXPOSE 9090

# Run the Spring Boot application
CMD ["java", "-jar", "app.jar"]

