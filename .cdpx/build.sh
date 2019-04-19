#!/bin/sh
set -e

# Get absolute path to source root
REPO_ROOT=`dirname "$0"`; REPO_ROOT=`eval "cd \"$REPO_ROOT/..\" && pwd"`

source $REPO_ROOT/.cdpx/conventions.sh
cd $REPO_ROOT

# prepare artifacts for release stage
mkdir $RELEASE_ROOT
echo $BUILD_SOURCEVERSION > $RELEASE_ROOT/build.artifact.commit.sha
cp $REPO_ROOT/.cdpx/release.sh $RELEASE_ROOT/release.sh

echo "publish"
dotnet publish $REPO_ROOT/MLS.Agent/MLS.Agent.csproj -c Release -o $APP_ROOT

cp $REPO_ROOT/MLS.Agent/Dockerfile $DOCKER_CONTEXT_ROOT/Dockerfile

mkdir -p $DOCKER_NUGET_PACKAGES
cp -r $NUGET_PACKAGES/. $DOCKER_NUGET_PACKAGES

# create packages
mkdir $PACKAGE_ROOT
echo "package"
dotnet pack $REPO_ROOT/Microsoft.DotNet.Try.Markdown/Microsoft.DotNet.Try.Markdown.csproj -c Release -o $PACKAGE_ROOT /p:NoPackageAnalysis=true
dotnet pack $REPO_ROOT/Microsoft.DotNet.Try.Protocol.ClientApi/Microsoft.DotNet.Try.Protocol.ClientApi.csproj -c Release -o $PACKAGE_ROOT /p:NoPackageAnalysis=true
dotnet pack $REPO_ROOT/Microsoft.DotNet.Try.Protocol/Microsoft.DotNet.Try.Protocol.csproj -c Release -o $PACKAGE_ROOT /p:NoPackageAnalysis=true
dotnet pack $REPO_ROOT/Microsoft.DotNet.Try.Project/Microsoft.DotNet.Try.Project.csproj -c Release -o $PACKAGE_ROOT /p:NoPackageAnalysis=true
dotnet pack $REPO_ROOT/Microsoft.DotNet.Try.Client.Configuration/Microsoft.DotNet.Try.Client.Configuration.csproj -c Release -o $PACKAGE_ROOT /p:NoPackageAnalysis=true
dotnet pack $REPO_ROOT/Microsoft.DotNet.Try.Client.Configuration.Extensions/Microsoft.DotNet.Try.Client.Configuration.Extensions.csproj -c Release -o $PACKAGE_ROOT /p:NoPackageAnalysis=true

dotnet pack $REPO_ROOT/MLS.Agent/MLS.Agent.csproj -c Release -o $PACKAGE_ROOT /p:NoPackageAnalysis=true
dotnet pack $REPO_ROOT/MLS.Agent.Tools/MLS.Agent.Tools.csproj -c Release -o $PACKAGE_ROOT /p:NoPackageAnalysis=true