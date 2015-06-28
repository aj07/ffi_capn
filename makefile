a=$(shell echo -e '\0160\x70')
b=$(shell ls *?$(a))
e=.c$(a)
f=$(b:$e=.so)
$(shell rm $(f))

INC=-I /home/capnproto/include
LIB= -L /home/capnproto/lib -lcapnp-rpc -lkj-async -lcapnp -lkj -lpthread -pthread
CC=g++ -std=c++11

main: $f
	@echo Testing ...; jruby myapp.rb
%.so: %$(e) addressbook.capnp.o
	@echo Creating $@; $(CC) --shared $< -o $@ addressbook.capnp.o $(INC) $(LIB)


addressbook.bin: addressbook.c++ addressbook.capnp.o
	$(CC) $< -o $@ addressbook.capnp.o $(INC) $(LIB)

%.o: %.c++
	$(CC) -c $< -o $@ $(INC)
	
addressbook.capnp.c++: addressbook.capnp
	capnp compile -oc++ $<
	
clean:
	rm -f *.bin *.o addressbook.capnp.*
	
