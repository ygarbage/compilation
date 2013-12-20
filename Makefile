all:driver/lib/enseirbBOT.so

driver/lib/enseirbBOT.so:driver/src/drive.ll
	@echo "Compiling enseirBOT.so .."
	@make -C driver
	@echo "enseirBOT.so compiled"

driver/src/drive.ll:src/parse
	@echo "Generating driver/src/drive.ll using parser .."
	@make drive -C src
	@echo "driver/src/drive.ll generated"

src/parse:
	@echo "Creating parser .."
	@make -C src
	@echo "Parser created"

clean:
	@echo "Cleaning driver"
	@make clean -C driver
	@echo "Cleaning src"	
	@make clean -C src

torcs-1.3.5/src/drivers/enseirBOT/enseirBOT.so:driver/lib/enseirbBOT.so
	@make copy -C driver