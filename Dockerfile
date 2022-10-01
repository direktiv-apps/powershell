FROM golang:1.18.2-alpine as build

WORKDIR /src

COPY build/app/go.mod go.mod
COPY build/app/go.sum go.sum

RUN go mod download

COPY build/app/cmd cmd/
COPY build/app/models models/
COPY build/app/restapi restapi/

ENV CGO_LDFLAGS "-static -w -s"

RUN go build -tags osusergo,netgo -o /application cmd/powershell-server/main.go; 

FROM mcr.microsoft.com/powershell:debian-11

RUN pwsh -Command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted"

RUN pwsh -Command 'Install-Module -Name PowerShellGet'
RUN pwsh -Command 'Install-Module -Name PSWSMan'
RUN pwsh -Command 'Install-WSMan'

# additional plugins
RUN pwsh -Command 'Install-Module -Name powershell-yaml'
RUN pwsh -Command 'Install-Module -Name PSWriteHTML'
RUN pwsh -Command 'Install-Module -Name Az'
RUN pwsh -Command 'Install-Module -Name Posh-SSH'

# DON'T CHANGE BELOW 
COPY --from=build /application /bin/application

EXPOSE 8080

CMD ["/bin/application", "--port=8080", "--host=0.0.0.0", "--write-timeout=0"]