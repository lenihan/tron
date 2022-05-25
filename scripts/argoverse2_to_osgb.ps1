# Convert Argoverse 2 json vector map files to OpenSceneGraph .osgb. 
# See 'Test' under 'Argoverse 2 Motion Forecasting Dataset' on this page: 
# https://www.argoverse.org/av2.html#download-link");

$ROOT = "$PSScriptRoot\.."

# Download test.tar: ~6GB, about an hour
Invoke-WebRequest -Uri https://s3.amazonaws.com/argoai-argoverse/av2/tars/motion-forecasting/test.tar -OutFile ~/Downloads/test.tar
tar -xvf $HOME/Downloads/test.tar --directory $HOME/Downloads

# Install PSParquet 
Install-Module PSParquet
Import-Module PSParquet

# Create city folders with .json files
$parquet_files = Get-ChildItem $HOME/Downloads/test -Recurse -Filter *.parquet
$parquet_files | ForEach-Object {
    $i = $parquet_files.IndexOf($_)
    $count = $parquet_files.Count
    Write-Progress -Activity "Copy .json to city directories" -PercentComplete ($i/$count*100) -Status "$i of $count"   
    $city = (Import-Parquet $_)[0].city
    mkdir $HOME/Downloads/cities/$city -ea Ignore
    Copy-Item "$HOME/Downloads/test/$($_.Directory.name)/*.json" $HOME/Downloads/cities/$city 
}

# Create test_json_to_osgb.exe
cmake -S $ROOT -B $ROOT/build
cmake --build $ROOT/build --config Release --target test_json_to_osgb

# Create .osgb in $ROOT/assets/vector_map/cities
$json_files =  Get-ChildItem $HOME/Downloads/cities -Filter *.json -Recurse
$json_files | ForEach-Object {
    $source = $_
    $city = $source.Directory.Name
    $destination = "$ROOT/assets/vector_map/cities/$city" 
    mkdir $destination -e Ignore
    & "$ROOT/build/bin/test_json_to_osgb.exe" $source $destination 
}