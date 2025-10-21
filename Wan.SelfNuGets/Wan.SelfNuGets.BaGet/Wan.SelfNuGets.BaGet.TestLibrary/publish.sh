#!/bin/bash

# Configuration
PROJECT_PATH="./Wan.SelfNuGets.BaGet.TestLibrary.csproj"
NUGET_SOURCE="http://localhost:5555/v3/index.json"
# API_KEY="your-api-key"
# We are not configuring security for now

# Calculate the next semantic version using GitVersion
echo "Calculating version using GitVersion..."
VERSION_INFO=$(dotnet-gitversion /output json /showvariable SemVer)
# For a pre-release version with branch name, you might use:
# VERSION_INFO=$(dotnet-gitversion /output json /showvariable NuGetVersionV2)

if [ -z "$VERSION_INFO" ]; then
    echo "Failed to calculate version."
    exit 1
fi

echo "Version to publish: $VERSION_INFO"

# Update the .csproj file with the new version.
# This uses `sed` (Linux/macOS). On Windows in Git Bash, it should also work.
sed -i "s/<Version>.*<\/Version>/<Version>$VERSION_INFO<\/Version>/g" $PROJECT_PATH

echo "Updated project file to version $VERSION_INFO"

# Build, Pack, and Push
dotnet build $PROJECT_PATH -c Release --nologo
dotnet pack $PROJECT_PATH -c Release --output ./nupkgs --no-build --nologo

# Find the specific .nupkg file we just created
NUPKG_FILE=$(find ./nupkgs -name "*$VERSION_INFO.nupkg" | head -n 1)

if [ -z "$NUPKG_FILE" ]; then
    echo "Could not find the generated .nupkg file."
    exit 1
fi

echo "Pushing $NUPKG_FILE to $NUGET_SOURCE..."
# dotnet nuget push "$NUPKG_FILE" --source $NUGET_SOURCE --api-key $API_KEY
dotnet nuget push "$NUPKG_FILE" --source $NUGET_SOURCE

echo "Done! Published $VERSION_INFO"
