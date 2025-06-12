#!/bin/bash
cd "$(dirname "$0")"

# Create venv if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate the venv before any pip commands
source venv/bin/activate

# Upgrade/install dependencies inside the venv
echo "Upgrading/installing dependencies..."
pip install -U pip
pip install -U fontmake gftools
pip install -U "fontbakery[googlefonts]"


rm -rf build/ fonts/
gftools builder sources/config.yaml


# # info: how to build static and variable fonts with fontmake if not with config.yaml
# echo "Building static and variable TTF fonts..."

# # Loop through all .glyphs files
# for glyphs_file in sources/*.glyphs; do
#     echo "Building $glyphs_file..."
#     fontmake -g "$glyphs_file" -o ttf --output-dir fonts/ -f
#     fontmake -g "$glyphs_file" -o variable --output-dir fonts/ -f
# done

# Validate fonts
echo "Running FontBakery checks..."
mkdir -p reports
fontbakery check-googlefonts fonts/variable/*.ttf --html reports/fontbakery-report.html -F

# Report location
echo "Validation report saved to reports/fontbakery-report.html"
open reports/fontbakery-report.html
