DEFAULT_CPP = g++
CPP      	= mpicxx
MAKE     	= make --no-print-directory
SHELL    	= /bin/sh
CFLAGS   	= -Wall -pedantic -std=c++11
#OPTI     	= -g
OPTI     	= -O2
LDFLAGS	 	= -L $(HPC_GSL_LIB) $(TACC_GSL_LIB)
INCLUDES 	= -I $(HPC_GSL_INC) $(TACC_GSL_INC)
LIBS     	= -lm -lgsl -lgslcblas
DEFINES  	= -DVERBOSE 

default: model

all_mpi: mpi_model

all_no_mpi: CPP=$(DEFAULT_CPP)
all_no_mpi: model

model: $(OBJS) Makefile simulator.h Person.o Location.o Mosquito.o Community.o driver.o Parameters.o Utility.o
	$(CPP) $(CFLAGS) $(OPTI) -o model Person.o Location.o Mosquito.o Community.o driver.o Parameters.o Utility.o $(OBJS) $(LDFLAGS) $(LIBS)

mpi_model: $(OBJS) Makefile simulator.h Person.o Location.o Mosquito.o Community.o mpi_driver.o Parameters.o Utility.o
	$(CPP) $(CFLAGS) $(OPTI) -o mpi_model Person.o Location.o Mosquito.o Community.o mpi_driver.o Parameters.o Utility.o $(OBJS) $(LDFLAGS) $(LIBS)


%.o: %.cpp Community.h Location.h Mosquito.h Utility.h Parameters.h Person.h Makefile
	$(CPP) $(CFLAGS) $(OPTI) $(INCLUDES) $(DEFINES) -c $<

zip: *.cpp *.h Makefile README LICENSE.txt HISTORY.txt *-bangphae.txt
	cd ..; zip denguemodelcode/denguemodel.zip denguemodelcode/README denguemodelcode/LICENSE.txt denguemodelcode/HISTORY.txt denguemodelcode/gpl.txt denguemodelcode/Makefile denguemodelcode/*.cpp denguemodelcode/*.h denguemodelcode/*-bangphae.txt

emacs:
	emacs Makefile *.h *.cpp README LICENSE.txt HISTORY.txt &

clean:
	rm -f *.o model *~
