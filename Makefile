build: 
	monkeyc -d fr965 -f monkey.jungle -o space.prg
	monkeydo space.prg fr965

build_full: font build

font: clean
	build/fontbm --font-size 160 --chars 48-57 --font-file build/Oswald-Regular.ttf --output resources/fonts/minute
	build/fontbm --font-size 160 --chars 48-57 --font-file build/Oswald-Light.ttf --output resources/fonts/hour
	build/fontbm --font-size 30 --chars-file build/chars-file-date.txt --font-file build/Oswald-ExtraLight.ttf --output resources/fonts/date
	build/fontbm --font-size 16 --chars-file build/chars-file-data.txt --font-file build/Oswald-ExtraLight.ttf --output resources/fonts/data

clean: clean_cache
	rm -f resources/fonts/*.fnt
	rm -f resources/fonts/*.png

clean_cache:
	rm -rf gen/*
	rm -f space.prg
	rm -f space.prg.debug.xml
