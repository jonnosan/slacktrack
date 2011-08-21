AS=ca65
LD=ld65
CFLAGS=-Oirs -t $(TARGET)
AFLAGS= 

INCFILES= common.i

CFG= slacktrack.cfg

all: slacktrack.prg
	
%.o: %.s timestamp.rb
	ruby timestamp.rb > timestamp.i
	$(AS) $(AFLAGS) $<

%.prg: %.o $(CFG)
	$(LD) -m  $*.map -vm -C $(CFG) -o  $*.prg  $(AFLAGS) $< 
	
clean:
	rm -f *.o *.bin *.map *.prg *.d64

distclean: clean
	rm -f *~

