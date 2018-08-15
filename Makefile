.PHONY: build test

build:
	zasm src/MiniRPG.asm -o dist
	python scripts/pack86.py dist/MiniRPG.rom

test:
	zasm src/maptest.asm -o dist
	python scripts/pack86.py dist/maptest.rom
