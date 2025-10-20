FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["NuGet.Server/Wan.SelfNuGets.NuGetServer/Wan.SelfNuGets.NuGetServer.csproj", "NuGet.Server/Wan.SelfNuGets.NuGetServer/"]
RUN dotnet restore "NuGet.Server/Wan.SelfNuGets.NuGetServer/Wan.SelfNuGets.NuGetServer.csproj"
COPY . .
WORKDIR "/src/NuGet.Server/Wan.SelfNuGets.NuGetServer"
RUN dotnet build "./Wan.SelfNuGets.NuGetServer.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Wan.SelfNuGets.NuGetServer.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Wan.SelfNuGets.NuGetServer.dll"]
