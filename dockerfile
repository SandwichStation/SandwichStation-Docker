# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Update and install necessary tools
RUN apt-get -y update && \
    apt-get -y install curl unzip wget git

# Clone and download repo
#RUN git clone https://github.com/space-wizards/SS14.Watchdog ss14-Watchdog
RUN git clone https://github.com/SandwichStation/SandwichStation ss14-Sandwich

# Server stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS server

#Setup "Watchdog"
#RUN cd Watchdog/SS14* && \
#    dotnet publish -c Release -r linux-x64 --no-self-contained && \
#    cp -r SS14.Watchdog/bin/Release/net7.0/linux-x64/publish /ss14-server

# Copy from the build stage
COPY --from=build /ss14-Sandwich /ss14-server

# Install necessary tools
RUN apt-get -y update && apt-get -y install unzip


# Expose necessary ports
EXPOSE 1212/tcp
EXPOSE 1212/udp
EXPOSE 5000/tcp
EXPOSE 5000/udp

# Set volume
VOLUME [ "/ss14-svr" ]

# Add configurations
ADD appsettings.yml /ss14-default/publish/appsettings.yml
ADD server_config.toml /ss14-default/publish/server_config.toml

COPY start.sh /start.sh
RUN chmod +x /start.sh

# Set the entry point for the container
ENTRYPOINT ["/start.sh"]
