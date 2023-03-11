default:
	@echo "No Default make command configured"
	@echo "Please use either"
	@echo "   - make curseforge"
	@echo "   - make multimc"
	@echo "   - make technic"
	@echo "   - make all"
	@echo ""
	@echo "Curseforge will make a curseforge compatible zip"
	@echo "Multimc will make a multimc zip file which contains"
	@echo "   the packwiz updater"
	@echo ""
	@echo "Technic will make a technic pack zip"
	@echo ""
	@echo "All will make all packs it can"
	@echo ""

PACKNAME := $(notdir $(CURDIR))

curseforge:
	-mkdir .build
	@echo "Making Curseforge pack"
	packwiz curseforge export --pack-file .minecraft/pack.toml
	mv ./*.zip ./.build/

modrinth:
	-mkdir .build
	@echo "Making Modrinth pack"
	packwiz modrinth export --pack-file .minecraft/pack.toml
	mv ./*.mrpack ./.build/

multimc:
	-mkdir .build
	@echo "Making MultiMC pack"
	7z d .build/${PACKNAME}-multimc.zip ./* -r
	7z d .build/${PACKNAME}-multimc.zip ./.minecraft -r
	7z a .build/${PACKNAME}-multimc.zip ./* -r
	7z a .build/${PACKNAME}-multimc.zip ./.minecraft -r
	7z d .build/${PACKNAME}-multimc.zip ./.build ./.minecraft/mods ./.minecraft/pack.toml ./.minecraft/index.toml -r

technic:
	-mkdir .build
	@echo "Making Technic pack"
	-rm -rf .technic
	-cp -r .minecraft .technic
	cp ${PACKNAME}_icon.png .technic/icon.png
	cd .technic && java -jar ../.minecraft/packwiz-installer-bootstrap.jar ../.minecraft/pack.toml && cd ..
	-rm -rf .technic/packwiz* .technic/index.toml .technic/pack.toml .technic/mods/*.toml
	7z d .build/${PACKNAME}-technic.zip ./* ./.* -r
	7z a .build/${PACKNAME}-technic.zip ./.technic/* -r

preClean:
	-rm -rf .build
postClean:
	-rm -rf .technic
	-git gc --aggressive --prune

all: preClean curseforge modrinth multimc technic postClean

update-packwiz:
	go install github.com/packwiz/packwiz@latest
	clear
	@echo "Packwiz has been Updated"