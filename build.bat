@echo off
setlocal EnableDelayedExpansion

set PROJECT_DIR=%cd%
mkdir tmp
xcopy /e src tmp
copy .latexmkrc tmp
cd tmp
pandoc --filter pandoc-crossref --top-level-division=section -M "crossrefYaml=templates\config.yml" report.md -o main.tex
move templates\template.tex .\
latexmk template
rem python .\templates\merger.py cover.pdf template.pdf template.pdf
move template.pdf %PROJECT_DIR%/dest/output.pdf
cd %PROJECT_DIR%
rd /S /Q tmp
endlocal
pause
