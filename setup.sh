# Install the downloader, but you have to add it to the path manually
# Must also add session cookie to home dir config file.
# go install github.com/GreenLightning/advent-of-code-downloader/aocdl@latest

# Script for starting each day
mkdir day$1
cp utils.jl day$1
cp -r ./utils day$1/utils
cp main-templ.jl day$1/main.jl
cd day$1

aocdl -wait
