#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

ENV ASPNETCORE_ENVIRONMENT=Development

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ProductTracker/ProductTracker.csproj", "ProductTracker/"]
RUN dotnet restore "ProductTracker/ProductTracker.csproj"
COPY . .
WORKDIR "/src/ProductTracker"
RUN dotnet build "ProductTracker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ProductTracker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ProductTracker.dll"]