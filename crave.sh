          export PROJECTFOLDER="/crave-devspaces/Rising14"
          export PROJECTID="86"
          export REPO_INIT="repo init -u https://github.com/RisingTechOSS/android.git -b fourteen --git-lfs --depth=1"


#!/bin/bash

set -e
#Credit to Meghthedev for the initial script 

export PROJECTFOLDER="Rising14"
export PROJECTID="86"
export REPO_INIT="repo init -u https://github.com/RisingTechOSS/android.git -b fourteen --git-lfs --depth=1"
export BUILD_DIFFERENT_ROM="$REPO_INIT" # Change this if you'd like to build something else

# Destroy Old Clones
if (grep -q "$PROJECTFOLDER" <(crave clone list --json | jq -r '.clones[]."Cloned At"')) || [ "${DCDEVSPACE}" == "1" ]; then   
   crave clone destroy -y /crave-devspaces/$PROJECTFOLDER || echo "Error removing $PROJECTFOLDER"
else
   rm -rf $PROJECTFOLDER || true
fi

# Create New clone
if [ "${DCDEVSPACE}" == "1" ]; then
   crave clone create --projectID $PROJECTID /crave-devspaces/$PROJECTFOLDER || echo "Crave clone create failed!"
   cd /crave-devspaces/$PROJECTFOLDER
else
   mkdir $PROJECTFOLDER
   cd $PROJECTFOLDER
   echo "Running $REPO_INIT"
   $REPO_INIT
fi

# Run inside foss.crave.io devspace
# Remove existing local_manifests
crave run --no-patch -- "curl https://raw.githubusercontent.com/I-n-o-k/local_manifest/refs/heads/main/rising.sh | bash"

cd ..

# Clean up
if grep -q "$PROJECTFOLDER" <(crave clone list --json | jq -r '.clones[]."Cloned At"') || [ "${DCDEVSPACE}" == "1" ]; then
  crave clone destroy -y /crave-devspaces/$PROJECTFOLDER || echo "Error removing $PROJECTFOLDER"
else  
  rm -rf $PROJECTFOLDER || true
fi
# Upload zips to Telegram
/opt/crave/telegram/upload.sh