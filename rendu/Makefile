all:compilateur biblio

compilateur:
	@echo -n "Génération du compilateur LLVM.. "
	@make -C src -s
	@echo "terminée."

llvm:compilateur
	@echo -n "Génération de la représentation intermédiaire LLVM du robot.. "
	@src/compilateur src/robotDescription > driver/src/drive.ll
	@echo "terminée."

biblio:llvm
	@echo -n "Génération de la bibliothèque enseirBOT.so.. "
	@make -C driver -s
	@echo "terminée."

clean:
	@echo -n "Nettoyage des fichiers temporaires.. "
	@make clean -C src -s
	@make clean -C driver -s
	@rm -f driver/src/drive.ll
	@echo "terminé."

mrproper:
	@echo -n "Nettoyage des fichiers générés.. "
	@make mrproper -C src -s
	@make mrproper -C driver -s
	@echo "terminé."