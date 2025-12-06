
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a5010113          	addi	sp,sp,-1456 # 80008a50 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	8be70713          	addi	a4,a4,-1858 # 80008910 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	dbc78793          	addi	a5,a5,-580 # 80005e20 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbca7f>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	ec678793          	addi	a5,a5,-314 # 80000f74 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000102:	715d                	addi	sp,sp,-80
    80000104:	e486                	sd	ra,72(sp)
    80000106:	e0a2                	sd	s0,64(sp)
    80000108:	fc26                	sd	s1,56(sp)
    8000010a:	f84a                	sd	s2,48(sp)
    8000010c:	f44e                	sd	s3,40(sp)
    8000010e:	f052                	sd	s4,32(sp)
    80000110:	ec56                	sd	s5,24(sp)
    80000112:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000114:	04c05663          	blez	a2,80000160 <consolewrite+0x5e>
    80000118:	8a2a                	mv	s4,a0
    8000011a:	84ae                	mv	s1,a1
    8000011c:	89b2                	mv	s3,a2
    8000011e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000120:	5afd                	li	s5,-1
    80000122:	4685                	li	a3,1
    80000124:	8626                	mv	a2,s1
    80000126:	85d2                	mv	a1,s4
    80000128:	fbf40513          	addi	a0,s0,-65
    8000012c:	00002097          	auipc	ra,0x2
    80000130:	5f4080e7          	jalr	1524(ra) # 80002720 <either_copyin>
    80000134:	01550c63          	beq	a0,s5,8000014c <consolewrite+0x4a>
      break;
    uartputc(c);
    80000138:	fbf44503          	lbu	a0,-65(s0)
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	780080e7          	jalr	1920(ra) # 800008bc <uartputc>
  for(i = 0; i < n; i++){
    80000144:	2905                	addiw	s2,s2,1
    80000146:	0485                	addi	s1,s1,1
    80000148:	fd299de3          	bne	s3,s2,80000122 <consolewrite+0x20>
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4a>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	8c650513          	addi	a0,a0,-1850 # 80010a50 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	b40080e7          	jalr	-1216(ra) # 80000cd2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	8b648493          	addi	s1,s1,-1866 # 80010a50 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	94690913          	addi	s2,s2,-1722 # 80010ae8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
      if(killed(myproc())){
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	a56080e7          	jalr	-1450(ra) # 80001c16 <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	3a2080e7          	jalr	930(ra) # 8000256a <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	0ec080e7          	jalr	236(ra) # 800022c2 <sleep>
    while(cons.r == cons.w){
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	4b8080e7          	jalr	1208(ra) # 800026ca <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	82a50513          	addi	a0,a0,-2006 # 80010a50 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	b58080e7          	jalr	-1192(ra) # 80000d86 <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	81450513          	addi	a0,a0,-2028 # 80010a50 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	b42080e7          	jalr	-1214(ra) # 80000d86 <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
      if(n < target){
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
        cons.r--;
    80000272:	00011717          	auipc	a4,0x11
    80000276:	86f72b23          	sw	a5,-1930(a4) # 80010ae8 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	55e080e7          	jalr	1374(ra) # 800007ea <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	54c080e7          	jalr	1356(ra) # 800007ea <uartputc_sync>
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	540080e7          	jalr	1344(ra) # 800007ea <uartputc_sync>
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	536080e7          	jalr	1334(ra) # 800007ea <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002cc:	00010517          	auipc	a0,0x10
    800002d0:	78450513          	addi	a0,a0,1924 # 80010a50 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	9fe080e7          	jalr	-1538(ra) # 80000cd2 <acquire>

  switch(c){
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	484080e7          	jalr	1156(ra) # 80002776 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	75650513          	addi	a0,a0,1878 # 80010a50 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	a84080e7          	jalr	-1404(ra) # 80000d86 <release>
}
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
  switch(c){
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031e:	00010717          	auipc	a4,0x10
    80000322:	73270713          	addi	a4,a4,1842 # 80010a50 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
      consputc(c);
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000348:	00010797          	auipc	a5,0x10
    8000034c:	70878793          	addi	a5,a5,1800 # 80010a50 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00010797          	auipc	a5,0x10
    8000037a:	7727a783          	lw	a5,1906(a5) # 80010ae8 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	6c670713          	addi	a4,a4,1734 # 80010a50 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	6b648493          	addi	s1,s1,1718 # 80010a50 <cons>
    while(cons.e != cons.w &&
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
      cons.e--;
    800003b8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    while(cons.e != cons.w &&
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	67a70713          	addi	a4,a4,1658 # 80010a50 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	70f72223          	sw	a5,1796(a4) # 80010af0 <cons+0xa0>
      consputc(BACKSPACE);
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
      consputc(c);
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000412:	00010797          	auipc	a5,0x10
    80000416:	63e78793          	addi	a5,a5,1598 # 80010a50 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00010797          	auipc	a5,0x10
    8000043a:	6ac7ab23          	sw	a2,1718(a5) # 80010aec <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	6aa50513          	addi	a0,a0,1706 # 80010ae8 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	ee0080e7          	jalr	-288(ra) # 80002326 <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:

void
consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80008010 <etext+0x10>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	5f050513          	addi	a0,a0,1520 # 80010a50 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	7da080e7          	jalr	2010(ra) # 80000c42 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32a080e7          	jalr	810(ra) # 8000079a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00240797          	auipc	a5,0x240
    8000047c:	77078793          	addi	a5,a5,1904 # 80240be8 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7870713          	addi	a4,a4,-904 # 80000102 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054663          	bltz	a0,80000536 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b8:	2581                	sext.w	a1,a1
    800004ba:	00008617          	auipc	a2,0x8
    800004be:	b8660613          	addi	a2,a2,-1146 # 80008040 <digits>
    800004c2:	883a                	mv	a6,a4
    800004c4:	2705                	addiw	a4,a4,1
    800004c6:	02b577bb          	remuw	a5,a0,a1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	97b2                	add	a5,a5,a2
    800004d0:	0007c783          	lbu	a5,0(a5)
    800004d4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>

  if(sign)
    800004e6:	00088b63          	beqz	a7,800004fc <printint+0x60>
    buf[i++] = '-';
    800004ea:	fe040793          	addi	a5,s0,-32
    800004ee:	973e                	add	a4,a4,a5
    800004f0:	02d00793          	li	a5,45
    800004f4:	fef70823          	sb	a5,-16(a4)
    800004f8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fc:	02e05763          	blez	a4,8000052a <printint+0x8e>
    80000500:	fd040793          	addi	a5,s0,-48
    80000504:	00e784b3          	add	s1,a5,a4
    80000508:	fff78913          	addi	s2,a5,-1
    8000050c:	993a                	add	s2,s2,a4
    8000050e:	377d                	addiw	a4,a4,-1
    80000510:	1702                	slli	a4,a4,0x20
    80000512:	9301                	srli	a4,a4,0x20
    80000514:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000518:	fff4c503          	lbu	a0,-1(s1)
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	d60080e7          	jalr	-672(ra) # 8000027c <consputc>
  while(--i >= 0)
    80000524:	14fd                	addi	s1,s1,-1
    80000526:	ff2499e3          	bne	s1,s2,80000518 <printint+0x7c>
}
    8000052a:	70a2                	ld	ra,40(sp)
    8000052c:	7402                	ld	s0,32(sp)
    8000052e:	64e2                	ld	s1,24(sp)
    80000530:	6942                	ld	s2,16(sp)
    80000532:	6145                	addi	sp,sp,48
    80000534:	8082                	ret
    x = -xx;
    80000536:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053a:	4885                	li	a7,1
    x = -xx;
    8000053c:	bf9d                	j	800004b2 <printint+0x16>

000000008000053e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053e:	1101                	addi	sp,sp,-32
    80000540:	ec06                	sd	ra,24(sp)
    80000542:	e822                	sd	s0,16(sp)
    80000544:	e426                	sd	s1,8(sp)
    80000546:	1000                	addi	s0,sp,32
    80000548:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054a:	00010797          	auipc	a5,0x10
    8000054e:	5c07a323          	sw	zero,1478(a5) # 80010b10 <pr+0x18>
  printf("panic: ");
    80000552:	00008517          	auipc	a0,0x8
    80000556:	ac650513          	addi	a0,a0,-1338 # 80008018 <etext+0x18>
    8000055a:	00000097          	auipc	ra,0x0
    8000055e:	02e080e7          	jalr	46(ra) # 80000588 <printf>
  printf(s);
    80000562:	8526                	mv	a0,s1
    80000564:	00000097          	auipc	ra,0x0
    80000568:	024080e7          	jalr	36(ra) # 80000588 <printf>
  printf("\n");
    8000056c:	00008517          	auipc	a0,0x8
    80000570:	b5c50513          	addi	a0,a0,-1188 # 800080c8 <digits+0x88>
    80000574:	00000097          	auipc	ra,0x0
    80000578:	014080e7          	jalr	20(ra) # 80000588 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057c:	4785                	li	a5,1
    8000057e:	00008717          	auipc	a4,0x8
    80000582:	34f72923          	sw	a5,850(a4) # 800088d0 <panicked>
  for(;;)
    80000586:	a001                	j	80000586 <panic+0x48>

0000000080000588 <printf>:
{
    80000588:	7131                	addi	sp,sp,-192
    8000058a:	fc86                	sd	ra,120(sp)
    8000058c:	f8a2                	sd	s0,112(sp)
    8000058e:	f4a6                	sd	s1,104(sp)
    80000590:	f0ca                	sd	s2,96(sp)
    80000592:	ecce                	sd	s3,88(sp)
    80000594:	e8d2                	sd	s4,80(sp)
    80000596:	e4d6                	sd	s5,72(sp)
    80000598:	e0da                	sd	s6,64(sp)
    8000059a:	fc5e                	sd	s7,56(sp)
    8000059c:	f862                	sd	s8,48(sp)
    8000059e:	f466                	sd	s9,40(sp)
    800005a0:	f06a                	sd	s10,32(sp)
    800005a2:	ec6e                	sd	s11,24(sp)
    800005a4:	0100                	addi	s0,sp,128
    800005a6:	8a2a                	mv	s4,a0
    800005a8:	e40c                	sd	a1,8(s0)
    800005aa:	e810                	sd	a2,16(s0)
    800005ac:	ec14                	sd	a3,24(s0)
    800005ae:	f018                	sd	a4,32(s0)
    800005b0:	f41c                	sd	a5,40(s0)
    800005b2:	03043823          	sd	a6,48(s0)
    800005b6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ba:	00010d97          	auipc	s11,0x10
    800005be:	556dad83          	lw	s11,1366(s11) # 80010b10 <pr+0x18>
  if(locking)
    800005c2:	020d9b63          	bnez	s11,800005f8 <printf+0x70>
  if (fmt == 0)
    800005c6:	040a0263          	beqz	s4,8000060a <printf+0x82>
  va_start(ap, fmt);
    800005ca:	00840793          	addi	a5,s0,8
    800005ce:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d2:	000a4503          	lbu	a0,0(s4)
    800005d6:	14050f63          	beqz	a0,80000734 <printf+0x1ac>
    800005da:	4981                	li	s3,0
    if(c != '%'){
    800005dc:	02500a93          	li	s5,37
    switch(c){
    800005e0:	07000b93          	li	s7,112
  consputc('x');
    800005e4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e6:	00008b17          	auipc	s6,0x8
    800005ea:	a5ab0b13          	addi	s6,s6,-1446 # 80008040 <digits>
    switch(c){
    800005ee:	07300c93          	li	s9,115
    800005f2:	06400c13          	li	s8,100
    800005f6:	a82d                	j	80000630 <printf+0xa8>
    acquire(&pr.lock);
    800005f8:	00010517          	auipc	a0,0x10
    800005fc:	50050513          	addi	a0,a0,1280 # 80010af8 <pr>
    80000600:	00000097          	auipc	ra,0x0
    80000604:	6d2080e7          	jalr	1746(ra) # 80000cd2 <acquire>
    80000608:	bf7d                	j	800005c6 <printf+0x3e>
    panic("null fmt");
    8000060a:	00008517          	auipc	a0,0x8
    8000060e:	a1e50513          	addi	a0,a0,-1506 # 80008028 <etext+0x28>
    80000612:	00000097          	auipc	ra,0x0
    80000616:	f2c080e7          	jalr	-212(ra) # 8000053e <panic>
      consputc(c);
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	c62080e7          	jalr	-926(ra) # 8000027c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000622:	2985                	addiw	s3,s3,1
    80000624:	013a07b3          	add	a5,s4,s3
    80000628:	0007c503          	lbu	a0,0(a5)
    8000062c:	10050463          	beqz	a0,80000734 <printf+0x1ac>
    if(c != '%'){
    80000630:	ff5515e3          	bne	a0,s5,8000061a <printf+0x92>
    c = fmt[++i] & 0xff;
    80000634:	2985                	addiw	s3,s3,1
    80000636:	013a07b3          	add	a5,s4,s3
    8000063a:	0007c783          	lbu	a5,0(a5)
    8000063e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000642:	cbed                	beqz	a5,80000734 <printf+0x1ac>
    switch(c){
    80000644:	05778a63          	beq	a5,s7,80000698 <printf+0x110>
    80000648:	02fbf663          	bgeu	s7,a5,80000674 <printf+0xec>
    8000064c:	09978863          	beq	a5,s9,800006dc <printf+0x154>
    80000650:	07800713          	li	a4,120
    80000654:	0ce79563          	bne	a5,a4,8000071e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4605                	li	a2,1
    80000666:	85ea                	mv	a1,s10
    80000668:	4388                	lw	a0,0(a5)
    8000066a:	00000097          	auipc	ra,0x0
    8000066e:	e32080e7          	jalr	-462(ra) # 8000049c <printint>
      break;
    80000672:	bf45                	j	80000622 <printf+0x9a>
    switch(c){
    80000674:	09578f63          	beq	a5,s5,80000712 <printf+0x18a>
    80000678:	0b879363          	bne	a5,s8,8000071e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067c:	f8843783          	ld	a5,-120(s0)
    80000680:	00878713          	addi	a4,a5,8
    80000684:	f8e43423          	sd	a4,-120(s0)
    80000688:	4605                	li	a2,1
    8000068a:	45a9                	li	a1,10
    8000068c:	4388                	lw	a0,0(a5)
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	e0e080e7          	jalr	-498(ra) # 8000049c <printint>
      break;
    80000696:	b771                	j	80000622 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000698:	f8843783          	ld	a5,-120(s0)
    8000069c:	00878713          	addi	a4,a5,8
    800006a0:	f8e43423          	sd	a4,-120(s0)
    800006a4:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a8:	03000513          	li	a0,48
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	bd0080e7          	jalr	-1072(ra) # 8000027c <consputc>
  consputc('x');
    800006b4:	07800513          	li	a0,120
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bc4080e7          	jalr	-1084(ra) # 8000027c <consputc>
    800006c0:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c2:	03c95793          	srli	a5,s2,0x3c
    800006c6:	97da                	add	a5,a5,s6
    800006c8:	0007c503          	lbu	a0,0(a5)
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	bb0080e7          	jalr	-1104(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d4:	0912                	slli	s2,s2,0x4
    800006d6:	34fd                	addiw	s1,s1,-1
    800006d8:	f4ed                	bnez	s1,800006c2 <printf+0x13a>
    800006da:	b7a1                	j	80000622 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006dc:	f8843783          	ld	a5,-120(s0)
    800006e0:	00878713          	addi	a4,a5,8
    800006e4:	f8e43423          	sd	a4,-120(s0)
    800006e8:	6384                	ld	s1,0(a5)
    800006ea:	cc89                	beqz	s1,80000704 <printf+0x17c>
      for(; *s; s++)
    800006ec:	0004c503          	lbu	a0,0(s1)
    800006f0:	d90d                	beqz	a0,80000622 <printf+0x9a>
        consputc(*s);
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	b8a080e7          	jalr	-1142(ra) # 8000027c <consputc>
      for(; *s; s++)
    800006fa:	0485                	addi	s1,s1,1
    800006fc:	0004c503          	lbu	a0,0(s1)
    80000700:	f96d                	bnez	a0,800006f2 <printf+0x16a>
    80000702:	b705                	j	80000622 <printf+0x9a>
        s = "(null)";
    80000704:	00008497          	auipc	s1,0x8
    80000708:	91c48493          	addi	s1,s1,-1764 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000070c:	02800513          	li	a0,40
    80000710:	b7cd                	j	800006f2 <printf+0x16a>
      consputc('%');
    80000712:	8556                	mv	a0,s5
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b68080e7          	jalr	-1176(ra) # 8000027c <consputc>
      break;
    8000071c:	b719                	j	80000622 <printf+0x9a>
      consputc('%');
    8000071e:	8556                	mv	a0,s5
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b5c080e7          	jalr	-1188(ra) # 8000027c <consputc>
      consputc(c);
    80000728:	8526                	mv	a0,s1
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	b52080e7          	jalr	-1198(ra) # 8000027c <consputc>
      break;
    80000732:	bdc5                	j	80000622 <printf+0x9a>
  if(locking)
    80000734:	020d9163          	bnez	s11,80000756 <printf+0x1ce>
}
    80000738:	70e6                	ld	ra,120(sp)
    8000073a:	7446                	ld	s0,112(sp)
    8000073c:	74a6                	ld	s1,104(sp)
    8000073e:	7906                	ld	s2,96(sp)
    80000740:	69e6                	ld	s3,88(sp)
    80000742:	6a46                	ld	s4,80(sp)
    80000744:	6aa6                	ld	s5,72(sp)
    80000746:	6b06                	ld	s6,64(sp)
    80000748:	7be2                	ld	s7,56(sp)
    8000074a:	7c42                	ld	s8,48(sp)
    8000074c:	7ca2                	ld	s9,40(sp)
    8000074e:	7d02                	ld	s10,32(sp)
    80000750:	6de2                	ld	s11,24(sp)
    80000752:	6129                	addi	sp,sp,192
    80000754:	8082                	ret
    release(&pr.lock);
    80000756:	00010517          	auipc	a0,0x10
    8000075a:	3a250513          	addi	a0,a0,930 # 80010af8 <pr>
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	628080e7          	jalr	1576(ra) # 80000d86 <release>
}
    80000766:	bfc9                	j	80000738 <printf+0x1b0>

0000000080000768 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000768:	1101                	addi	sp,sp,-32
    8000076a:	ec06                	sd	ra,24(sp)
    8000076c:	e822                	sd	s0,16(sp)
    8000076e:	e426                	sd	s1,8(sp)
    80000770:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000772:	00010497          	auipc	s1,0x10
    80000776:	38648493          	addi	s1,s1,902 # 80010af8 <pr>
    8000077a:	00008597          	auipc	a1,0x8
    8000077e:	8be58593          	addi	a1,a1,-1858 # 80008038 <etext+0x38>
    80000782:	8526                	mv	a0,s1
    80000784:	00000097          	auipc	ra,0x0
    80000788:	4be080e7          	jalr	1214(ra) # 80000c42 <initlock>
  pr.locking = 1;
    8000078c:	4785                	li	a5,1
    8000078e:	cc9c                	sw	a5,24(s1)
}
    80000790:	60e2                	ld	ra,24(sp)
    80000792:	6442                	ld	s0,16(sp)
    80000794:	64a2                	ld	s1,8(sp)
    80000796:	6105                	addi	sp,sp,32
    80000798:	8082                	ret

000000008000079a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079a:	1141                	addi	sp,sp,-16
    8000079c:	e406                	sd	ra,8(sp)
    8000079e:	e022                	sd	s0,0(sp)
    800007a0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a2:	100007b7          	lui	a5,0x10000
    800007a6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007aa:	f8000713          	li	a4,-128
    800007ae:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b2:	470d                	li	a4,3
    800007b4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007bc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c0:	469d                	li	a3,7
    800007c2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ca:	00008597          	auipc	a1,0x8
    800007ce:	88e58593          	addi	a1,a1,-1906 # 80008058 <digits+0x18>
    800007d2:	00010517          	auipc	a0,0x10
    800007d6:	34650513          	addi	a0,a0,838 # 80010b18 <uart_tx_lock>
    800007da:	00000097          	auipc	ra,0x0
    800007de:	468080e7          	jalr	1128(ra) # 80000c42 <initlock>
}
    800007e2:	60a2                	ld	ra,8(sp)
    800007e4:	6402                	ld	s0,0(sp)
    800007e6:	0141                	addi	sp,sp,16
    800007e8:	8082                	ret

00000000800007ea <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ea:	1101                	addi	sp,sp,-32
    800007ec:	ec06                	sd	ra,24(sp)
    800007ee:	e822                	sd	s0,16(sp)
    800007f0:	e426                	sd	s1,8(sp)
    800007f2:	1000                	addi	s0,sp,32
    800007f4:	84aa                	mv	s1,a0
  push_off();
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	490080e7          	jalr	1168(ra) # 80000c86 <push_off>

  if(panicked){
    800007fe:	00008797          	auipc	a5,0x8
    80000802:	0d27a783          	lw	a5,210(a5) # 800088d0 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000806:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080a:	c391                	beqz	a5,8000080e <uartputc_sync+0x24>
    for(;;)
    8000080c:	a001                	j	8000080c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000812:	0207f793          	andi	a5,a5,32
    80000816:	dfe5                	beqz	a5,8000080e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000818:	0ff4f513          	zext.b	a0,s1
    8000081c:	100007b7          	lui	a5,0x10000
    80000820:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000824:	00000097          	auipc	ra,0x0
    80000828:	502080e7          	jalr	1282(ra) # 80000d26 <pop_off>
}
    8000082c:	60e2                	ld	ra,24(sp)
    8000082e:	6442                	ld	s0,16(sp)
    80000830:	64a2                	ld	s1,8(sp)
    80000832:	6105                	addi	sp,sp,32
    80000834:	8082                	ret

0000000080000836 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000836:	00008797          	auipc	a5,0x8
    8000083a:	0a27b783          	ld	a5,162(a5) # 800088d8 <uart_tx_r>
    8000083e:	00008717          	auipc	a4,0x8
    80000842:	0a273703          	ld	a4,162(a4) # 800088e0 <uart_tx_w>
    80000846:	06f70a63          	beq	a4,a5,800008ba <uartstart+0x84>
{
    8000084a:	7139                	addi	sp,sp,-64
    8000084c:	fc06                	sd	ra,56(sp)
    8000084e:	f822                	sd	s0,48(sp)
    80000850:	f426                	sd	s1,40(sp)
    80000852:	f04a                	sd	s2,32(sp)
    80000854:	ec4e                	sd	s3,24(sp)
    80000856:	e852                	sd	s4,16(sp)
    80000858:	e456                	sd	s5,8(sp)
    8000085a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000860:	00010a17          	auipc	s4,0x10
    80000864:	2b8a0a13          	addi	s4,s4,696 # 80010b18 <uart_tx_lock>
    uart_tx_r += 1;
    80000868:	00008497          	auipc	s1,0x8
    8000086c:	07048493          	addi	s1,s1,112 # 800088d8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000870:	00008997          	auipc	s3,0x8
    80000874:	07098993          	addi	s3,s3,112 # 800088e0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000878:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087c:	02077713          	andi	a4,a4,32
    80000880:	c705                	beqz	a4,800008a8 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000882:	01f7f713          	andi	a4,a5,31
    80000886:	9752                	add	a4,a4,s4
    80000888:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088c:	0785                	addi	a5,a5,1
    8000088e:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000890:	8526                	mv	a0,s1
    80000892:	00002097          	auipc	ra,0x2
    80000896:	a94080e7          	jalr	-1388(ra) # 80002326 <wakeup>
    
    WriteReg(THR, c);
    8000089a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089e:	609c                	ld	a5,0(s1)
    800008a0:	0009b703          	ld	a4,0(s3)
    800008a4:	fcf71ae3          	bne	a4,a5,80000878 <uartstart+0x42>
  }
}
    800008a8:	70e2                	ld	ra,56(sp)
    800008aa:	7442                	ld	s0,48(sp)
    800008ac:	74a2                	ld	s1,40(sp)
    800008ae:	7902                	ld	s2,32(sp)
    800008b0:	69e2                	ld	s3,24(sp)
    800008b2:	6a42                	ld	s4,16(sp)
    800008b4:	6aa2                	ld	s5,8(sp)
    800008b6:	6121                	addi	sp,sp,64
    800008b8:	8082                	ret
    800008ba:	8082                	ret

00000000800008bc <uartputc>:
{
    800008bc:	7179                	addi	sp,sp,-48
    800008be:	f406                	sd	ra,40(sp)
    800008c0:	f022                	sd	s0,32(sp)
    800008c2:	ec26                	sd	s1,24(sp)
    800008c4:	e84a                	sd	s2,16(sp)
    800008c6:	e44e                	sd	s3,8(sp)
    800008c8:	e052                	sd	s4,0(sp)
    800008ca:	1800                	addi	s0,sp,48
    800008cc:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ce:	00010517          	auipc	a0,0x10
    800008d2:	24a50513          	addi	a0,a0,586 # 80010b18 <uart_tx_lock>
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	3fc080e7          	jalr	1020(ra) # 80000cd2 <acquire>
  if(panicked){
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	ff27a783          	lw	a5,-14(a5) # 800088d0 <panicked>
    800008e6:	e7c9                	bnez	a5,80000970 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e8:	00008717          	auipc	a4,0x8
    800008ec:	ff873703          	ld	a4,-8(a4) # 800088e0 <uart_tx_w>
    800008f0:	00008797          	auipc	a5,0x8
    800008f4:	fe87b783          	ld	a5,-24(a5) # 800088d8 <uart_tx_r>
    800008f8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fc:	00010997          	auipc	s3,0x10
    80000900:	21c98993          	addi	s3,s3,540 # 80010b18 <uart_tx_lock>
    80000904:	00008497          	auipc	s1,0x8
    80000908:	fd448493          	addi	s1,s1,-44 # 800088d8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090c:	00008917          	auipc	s2,0x8
    80000910:	fd490913          	addi	s2,s2,-44 # 800088e0 <uart_tx_w>
    80000914:	00e79f63          	bne	a5,a4,80000932 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000918:	85ce                	mv	a1,s3
    8000091a:	8526                	mv	a0,s1
    8000091c:	00002097          	auipc	ra,0x2
    80000920:	9a6080e7          	jalr	-1626(ra) # 800022c2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000924:	00093703          	ld	a4,0(s2)
    80000928:	609c                	ld	a5,0(s1)
    8000092a:	02078793          	addi	a5,a5,32
    8000092e:	fee785e3          	beq	a5,a4,80000918 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000932:	00010497          	auipc	s1,0x10
    80000936:	1e648493          	addi	s1,s1,486 # 80010b18 <uart_tx_lock>
    8000093a:	01f77793          	andi	a5,a4,31
    8000093e:	97a6                	add	a5,a5,s1
    80000940:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000944:	0705                	addi	a4,a4,1
    80000946:	00008797          	auipc	a5,0x8
    8000094a:	f8e7bd23          	sd	a4,-102(a5) # 800088e0 <uart_tx_w>
  uartstart();
    8000094e:	00000097          	auipc	ra,0x0
    80000952:	ee8080e7          	jalr	-280(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    80000956:	8526                	mv	a0,s1
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	42e080e7          	jalr	1070(ra) # 80000d86 <release>
}
    80000960:	70a2                	ld	ra,40(sp)
    80000962:	7402                	ld	s0,32(sp)
    80000964:	64e2                	ld	s1,24(sp)
    80000966:	6942                	ld	s2,16(sp)
    80000968:	69a2                	ld	s3,8(sp)
    8000096a:	6a02                	ld	s4,0(sp)
    8000096c:	6145                	addi	sp,sp,48
    8000096e:	8082                	ret
    for(;;)
    80000970:	a001                	j	80000970 <uartputc+0xb4>

0000000080000972 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000972:	1141                	addi	sp,sp,-16
    80000974:	e422                	sd	s0,8(sp)
    80000976:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000978:	100007b7          	lui	a5,0x10000
    8000097c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000980:	8b85                	andi	a5,a5,1
    80000982:	cb91                	beqz	a5,80000996 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000984:	100007b7          	lui	a5,0x10000
    80000988:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000098c:	0ff57513          	zext.b	a0,a0
  } else {
    return -1;
  }
}
    80000990:	6422                	ld	s0,8(sp)
    80000992:	0141                	addi	sp,sp,16
    80000994:	8082                	ret
    return -1;
    80000996:	557d                	li	a0,-1
    80000998:	bfe5                	j	80000990 <uartgetc+0x1e>

000000008000099a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000099a:	1101                	addi	sp,sp,-32
    8000099c:	ec06                	sd	ra,24(sp)
    8000099e:	e822                	sd	s0,16(sp)
    800009a0:	e426                	sd	s1,8(sp)
    800009a2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a4:	54fd                	li	s1,-1
    800009a6:	a029                	j	800009b0 <uartintr+0x16>
      break;
    consoleintr(c);
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	916080e7          	jalr	-1770(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	fc2080e7          	jalr	-62(ra) # 80000972 <uartgetc>
    if(c == -1)
    800009b8:	fe9518e3          	bne	a0,s1,800009a8 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009bc:	00010497          	auipc	s1,0x10
    800009c0:	15c48493          	addi	s1,s1,348 # 80010b18 <uart_tx_lock>
    800009c4:	8526                	mv	a0,s1
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	30c080e7          	jalr	780(ra) # 80000cd2 <acquire>
  uartstart();
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	e68080e7          	jalr	-408(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    800009d6:	8526                	mv	a0,s1
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	3ae080e7          	jalr	942(ra) # 80000d86 <release>
}
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret

00000000800009ea <pageref>:
static int pa_idx(uint64 pa) { return pa >> 12; }
static int kva_idx(void *kva) { return pa_idx((uint64)kva); }

int
pageref(uint64 pa)      
{
    800009ea:	1141                	addi	sp,sp,-16
    800009ec:	e422                	sd	s0,8(sp)
    800009ee:	0800                	addi	s0,sp,16
static int pa_idx(uint64 pa) { return pa >> 12; }
    800009f0:	8131                	srli	a0,a0,0xc
  return reference_count[pa_idx(pa)];
    800009f2:	2501                	sext.w	a0,a0
    800009f4:	050a                	slli	a0,a0,0x2
    800009f6:	00010797          	auipc	a5,0x10
    800009fa:	17a78793          	addi	a5,a5,378 # 80010b70 <reference_count>
    800009fe:	953e                	add	a0,a0,a5
}
    80000a00:	4108                	lw	a0,0(a0)
    80000a02:	6422                	ld	s0,8(sp)
    80000a04:	0141                	addi	sp,sp,16
    80000a06:	8082                	ret

0000000080000a08 <addref>:

void
addref(uint64 pa)        
{
    80000a08:	1101                	addi	sp,sp,-32
    80000a0a:	ec06                	sd	ra,24(sp)
    80000a0c:	e822                	sd	s0,16(sp)
    80000a0e:	e426                	sd	s1,8(sp)
    80000a10:	e04a                	sd	s2,0(sp)
    80000a12:	1000                	addi	s0,sp,32
    80000a14:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    80000a16:	00010917          	auipc	s2,0x10
    80000a1a:	13a90913          	addi	s2,s2,314 # 80010b50 <kmem>
    80000a1e:	854a                	mv	a0,s2
    80000a20:	00000097          	auipc	ra,0x0
    80000a24:	2b2080e7          	jalr	690(ra) # 80000cd2 <acquire>
static int pa_idx(uint64 pa) { return pa >> 12; }
    80000a28:	80b1                	srli	s1,s1,0xc
    80000a2a:	2481                	sext.w	s1,s1
  reference_count[pa_idx(pa)]++;
    80000a2c:	048a                	slli	s1,s1,0x2
    80000a2e:	00010797          	auipc	a5,0x10
    80000a32:	14278793          	addi	a5,a5,322 # 80010b70 <reference_count>
    80000a36:	94be                	add	s1,s1,a5
    80000a38:	409c                	lw	a5,0(s1)
    80000a3a:	2785                	addiw	a5,a5,1
    80000a3c:	c09c                	sw	a5,0(s1)
  release(&kmem.lock);
    80000a3e:	854a                	mv	a0,s2
    80000a40:	00000097          	auipc	ra,0x0
    80000a44:	346080e7          	jalr	838(ra) # 80000d86 <release>
}
    80000a48:	60e2                	ld	ra,24(sp)
    80000a4a:	6442                	ld	s0,16(sp)
    80000a4c:	64a2                	ld	s1,8(sp)
    80000a4e:	6902                	ld	s2,0(sp)
    80000a50:	6105                	addi	sp,sp,32
    80000a52:	8082                	ret

0000000080000a54 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a54:	1101                	addi	sp,sp,-32
    80000a56:	ec06                	sd	ra,24(sp)
    80000a58:	e822                	sd	s0,16(sp)
    80000a5a:	e426                	sd	s1,8(sp)
    80000a5c:	e04a                	sd	s2,0(sp)
    80000a5e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a60:	03451793          	slli	a5,a0,0x34
    80000a64:	e7b5                	bnez	a5,80000ad0 <kfree+0x7c>
    80000a66:	84aa                	mv	s1,a0
    80000a68:	00241797          	auipc	a5,0x241
    80000a6c:	31878793          	addi	a5,a5,792 # 80241d80 <end>
    80000a70:	06f56063          	bltu	a0,a5,80000ad0 <kfree+0x7c>
    80000a74:	47c5                	li	a5,17
    80000a76:	07ee                	slli	a5,a5,0x1b
    80000a78:	04f57c63          	bgeu	a0,a5,80000ad0 <kfree+0x7c>
    panic("kfree");


  acquire(&kmem.lock);
    80000a7c:	00010517          	auipc	a0,0x10
    80000a80:	0d450513          	addi	a0,a0,212 # 80010b50 <kmem>
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	24e080e7          	jalr	590(ra) # 80000cd2 <acquire>
static int pa_idx(uint64 pa) { return pa >> 12; }
    80000a8c:	00c4d793          	srli	a5,s1,0xc
    80000a90:	2781                	sext.w	a5,a5
  int idx = kva_idx(pa); 
  if(reference_count[idx] >0)
    80000a92:	00279693          	slli	a3,a5,0x2
    80000a96:	00010717          	auipc	a4,0x10
    80000a9a:	0da70713          	addi	a4,a4,218 # 80010b70 <reference_count>
    80000a9e:	9736                	add	a4,a4,a3
    80000aa0:	4318                	lw	a4,0(a4)
    80000aa2:	02e05f63          	blez	a4,80000ae0 <kfree+0x8c>
    reference_count[idx]--;
    80000aa6:	377d                	addiw	a4,a4,-1
    80000aa8:	0007061b          	sext.w	a2,a4
    80000aac:	87b6                	mv	a5,a3
    80000aae:	00010697          	auipc	a3,0x10
    80000ab2:	0c268693          	addi	a3,a3,194 # 80010b70 <reference_count>
    80000ab6:	97b6                	add	a5,a5,a3
    80000ab8:	c398                	sw	a4,0(a5)
  if(reference_count[idx] > 0){
    80000aba:	02c05363          	blez	a2,80000ae0 <kfree+0x8c>
    release(&kmem.lock);
    80000abe:	00010517          	auipc	a0,0x10
    80000ac2:	09250513          	addi	a0,a0,146 # 80010b50 <kmem>
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	2c0080e7          	jalr	704(ra) # 80000d86 <release>
    return;
    80000ace:	a881                	j	80000b1e <kfree+0xca>
    panic("kfree");
    80000ad0:	00007517          	auipc	a0,0x7
    80000ad4:	59050513          	addi	a0,a0,1424 # 80008060 <digits+0x20>
    80000ad8:	00000097          	auipc	ra,0x0
    80000adc:	a66080e7          	jalr	-1434(ra) # 8000053e <panic>
  }
  release(&kmem.lock);
    80000ae0:	00010917          	auipc	s2,0x10
    80000ae4:	07090913          	addi	s2,s2,112 # 80010b50 <kmem>
    80000ae8:	854a                	mv	a0,s2
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	29c080e7          	jalr	668(ra) # 80000d86 <release>
  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000af2:	6605                	lui	a2,0x1
    80000af4:	4585                	li	a1,1
    80000af6:	8526                	mv	a0,s1
    80000af8:	00000097          	auipc	ra,0x0
    80000afc:	2d6080e7          	jalr	726(ra) # 80000dce <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000b00:	854a                	mv	a0,s2
    80000b02:	00000097          	auipc	ra,0x0
    80000b06:	1d0080e7          	jalr	464(ra) # 80000cd2 <acquire>
  r->next = kmem.freelist;
    80000b0a:	01893783          	ld	a5,24(s2)
    80000b0e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000b10:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000b14:	854a                	mv	a0,s2
    80000b16:	00000097          	auipc	ra,0x0
    80000b1a:	270080e7          	jalr	624(ra) # 80000d86 <release>
}
    80000b1e:	60e2                	ld	ra,24(sp)
    80000b20:	6442                	ld	s0,16(sp)
    80000b22:	64a2                	ld	s1,8(sp)
    80000b24:	6902                	ld	s2,0(sp)
    80000b26:	6105                	addi	sp,sp,32
    80000b28:	8082                	ret

0000000080000b2a <freerange>:
{
    80000b2a:	7179                	addi	sp,sp,-48
    80000b2c:	f406                	sd	ra,40(sp)
    80000b2e:	f022                	sd	s0,32(sp)
    80000b30:	ec26                	sd	s1,24(sp)
    80000b32:	e84a                	sd	s2,16(sp)
    80000b34:	e44e                	sd	s3,8(sp)
    80000b36:	e052                	sd	s4,0(sp)
    80000b38:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000b3a:	6785                	lui	a5,0x1
    80000b3c:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000b40:	94aa                	add	s1,s1,a0
    80000b42:	757d                	lui	a0,0xfffff
    80000b44:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b46:	94be                	add	s1,s1,a5
    80000b48:	0095ee63          	bltu	a1,s1,80000b64 <freerange+0x3a>
    80000b4c:	892e                	mv	s2,a1
    kfree(p);
    80000b4e:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b50:	6985                	lui	s3,0x1
    kfree(p);
    80000b52:	01448533          	add	a0,s1,s4
    80000b56:	00000097          	auipc	ra,0x0
    80000b5a:	efe080e7          	jalr	-258(ra) # 80000a54 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b5e:	94ce                	add	s1,s1,s3
    80000b60:	fe9979e3          	bgeu	s2,s1,80000b52 <freerange+0x28>
}
    80000b64:	70a2                	ld	ra,40(sp)
    80000b66:	7402                	ld	s0,32(sp)
    80000b68:	64e2                	ld	s1,24(sp)
    80000b6a:	6942                	ld	s2,16(sp)
    80000b6c:	69a2                	ld	s3,8(sp)
    80000b6e:	6a02                	ld	s4,0(sp)
    80000b70:	6145                	addi	sp,sp,48
    80000b72:	8082                	ret

0000000080000b74 <kinit>:
{
    80000b74:	1141                	addi	sp,sp,-16
    80000b76:	e406                	sd	ra,8(sp)
    80000b78:	e022                	sd	s0,0(sp)
    80000b7a:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b7c:	00007597          	auipc	a1,0x7
    80000b80:	4ec58593          	addi	a1,a1,1260 # 80008068 <digits+0x28>
    80000b84:	00010517          	auipc	a0,0x10
    80000b88:	fcc50513          	addi	a0,a0,-52 # 80010b50 <kmem>
    80000b8c:	00000097          	auipc	ra,0x0
    80000b90:	0b6080e7          	jalr	182(ra) # 80000c42 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b94:	45c5                	li	a1,17
    80000b96:	05ee                	slli	a1,a1,0x1b
    80000b98:	00241517          	auipc	a0,0x241
    80000b9c:	1e850513          	addi	a0,a0,488 # 80241d80 <end>
    80000ba0:	00000097          	auipc	ra,0x0
    80000ba4:	f8a080e7          	jalr	-118(ra) # 80000b2a <freerange>
}
    80000ba8:	60a2                	ld	ra,8(sp)
    80000baa:	6402                	ld	s0,0(sp)
    80000bac:	0141                	addi	sp,sp,16
    80000bae:	8082                	ret

0000000080000bb0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000bb0:	1101                	addi	sp,sp,-32
    80000bb2:	ec06                	sd	ra,24(sp)
    80000bb4:	e822                	sd	s0,16(sp)
    80000bb6:	e426                	sd	s1,8(sp)
    80000bb8:	e04a                	sd	s2,0(sp)
    80000bba:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000bbc:	00010497          	auipc	s1,0x10
    80000bc0:	f9448493          	addi	s1,s1,-108 # 80010b50 <kmem>
    80000bc4:	8526                	mv	a0,s1
    80000bc6:	00000097          	auipc	ra,0x0
    80000bca:	10c080e7          	jalr	268(ra) # 80000cd2 <acquire>
  r = kmem.freelist;
    80000bce:	6c84                	ld	s1,24(s1)
  if(r)
    80000bd0:	c0a5                	beqz	s1,80000c30 <kalloc+0x80>
    kmem.freelist = r->next;
    80000bd2:	609c                	ld	a5,0(s1)
    80000bd4:	00010917          	auipc	s2,0x10
    80000bd8:	f7c90913          	addi	s2,s2,-132 # 80010b50 <kmem>
    80000bdc:	00f93c23          	sd	a5,24(s2)
  release(&kmem.lock);
    80000be0:	854a                	mv	a0,s2
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	1a4080e7          	jalr	420(ra) # 80000d86 <release>

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000bea:	6605                	lui	a2,0x1
    80000bec:	4595                	li	a1,5
    80000bee:	8526                	mv	a0,s1
    80000bf0:	00000097          	auipc	ra,0x0
    80000bf4:	1de080e7          	jalr	478(ra) # 80000dce <memset>
    acquire(&kmem.lock);
    80000bf8:	854a                	mv	a0,s2
    80000bfa:	00000097          	auipc	ra,0x0
    80000bfe:	0d8080e7          	jalr	216(ra) # 80000cd2 <acquire>
static int pa_idx(uint64 pa) { return pa >> 12; }
    80000c02:	00c4d793          	srli	a5,s1,0xc
    reference_count[kva_idx(r)] = 1;
    80000c06:	2781                	sext.w	a5,a5
    80000c08:	078a                	slli	a5,a5,0x2
    80000c0a:	00010717          	auipc	a4,0x10
    80000c0e:	f6670713          	addi	a4,a4,-154 # 80010b70 <reference_count>
    80000c12:	97ba                	add	a5,a5,a4
    80000c14:	4705                	li	a4,1
    80000c16:	c398                	sw	a4,0(a5)
    release(&kmem.lock);
    80000c18:	854a                	mv	a0,s2
    80000c1a:	00000097          	auipc	ra,0x0
    80000c1e:	16c080e7          	jalr	364(ra) # 80000d86 <release>
  }
  return (void*)r;
}
    80000c22:	8526                	mv	a0,s1
    80000c24:	60e2                	ld	ra,24(sp)
    80000c26:	6442                	ld	s0,16(sp)
    80000c28:	64a2                	ld	s1,8(sp)
    80000c2a:	6902                	ld	s2,0(sp)
    80000c2c:	6105                	addi	sp,sp,32
    80000c2e:	8082                	ret
  release(&kmem.lock);
    80000c30:	00010517          	auipc	a0,0x10
    80000c34:	f2050513          	addi	a0,a0,-224 # 80010b50 <kmem>
    80000c38:	00000097          	auipc	ra,0x0
    80000c3c:	14e080e7          	jalr	334(ra) # 80000d86 <release>
  if(r){
    80000c40:	b7cd                	j	80000c22 <kalloc+0x72>

0000000080000c42 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000c42:	1141                	addi	sp,sp,-16
    80000c44:	e422                	sd	s0,8(sp)
    80000c46:	0800                	addi	s0,sp,16
  lk->name = name;
    80000c48:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000c4a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000c4e:	00053823          	sd	zero,16(a0)
}
    80000c52:	6422                	ld	s0,8(sp)
    80000c54:	0141                	addi	sp,sp,16
    80000c56:	8082                	ret

0000000080000c58 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000c58:	411c                	lw	a5,0(a0)
    80000c5a:	e399                	bnez	a5,80000c60 <holding+0x8>
    80000c5c:	4501                	li	a0,0
  return r;
}
    80000c5e:	8082                	ret
{
    80000c60:	1101                	addi	sp,sp,-32
    80000c62:	ec06                	sd	ra,24(sp)
    80000c64:	e822                	sd	s0,16(sp)
    80000c66:	e426                	sd	s1,8(sp)
    80000c68:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000c6a:	6904                	ld	s1,16(a0)
    80000c6c:	00001097          	auipc	ra,0x1
    80000c70:	f8e080e7          	jalr	-114(ra) # 80001bfa <mycpu>
    80000c74:	40a48533          	sub	a0,s1,a0
    80000c78:	00153513          	seqz	a0,a0
}
    80000c7c:	60e2                	ld	ra,24(sp)
    80000c7e:	6442                	ld	s0,16(sp)
    80000c80:	64a2                	ld	s1,8(sp)
    80000c82:	6105                	addi	sp,sp,32
    80000c84:	8082                	ret

0000000080000c86 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c86:	1101                	addi	sp,sp,-32
    80000c88:	ec06                	sd	ra,24(sp)
    80000c8a:	e822                	sd	s0,16(sp)
    80000c8c:	e426                	sd	s1,8(sp)
    80000c8e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c90:	100024f3          	csrr	s1,sstatus
    80000c94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c98:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c9a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c9e:	00001097          	auipc	ra,0x1
    80000ca2:	f5c080e7          	jalr	-164(ra) # 80001bfa <mycpu>
    80000ca6:	5d3c                	lw	a5,120(a0)
    80000ca8:	cf89                	beqz	a5,80000cc2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000caa:	00001097          	auipc	ra,0x1
    80000cae:	f50080e7          	jalr	-176(ra) # 80001bfa <mycpu>
    80000cb2:	5d3c                	lw	a5,120(a0)
    80000cb4:	2785                	addiw	a5,a5,1
    80000cb6:	dd3c                	sw	a5,120(a0)
}
    80000cb8:	60e2                	ld	ra,24(sp)
    80000cba:	6442                	ld	s0,16(sp)
    80000cbc:	64a2                	ld	s1,8(sp)
    80000cbe:	6105                	addi	sp,sp,32
    80000cc0:	8082                	ret
    mycpu()->intena = old;
    80000cc2:	00001097          	auipc	ra,0x1
    80000cc6:	f38080e7          	jalr	-200(ra) # 80001bfa <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000cca:	8085                	srli	s1,s1,0x1
    80000ccc:	8885                	andi	s1,s1,1
    80000cce:	dd64                	sw	s1,124(a0)
    80000cd0:	bfe9                	j	80000caa <push_off+0x24>

0000000080000cd2 <acquire>:
{
    80000cd2:	1101                	addi	sp,sp,-32
    80000cd4:	ec06                	sd	ra,24(sp)
    80000cd6:	e822                	sd	s0,16(sp)
    80000cd8:	e426                	sd	s1,8(sp)
    80000cda:	1000                	addi	s0,sp,32
    80000cdc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000cde:	00000097          	auipc	ra,0x0
    80000ce2:	fa8080e7          	jalr	-88(ra) # 80000c86 <push_off>
  if(holding(lk))
    80000ce6:	8526                	mv	a0,s1
    80000ce8:	00000097          	auipc	ra,0x0
    80000cec:	f70080e7          	jalr	-144(ra) # 80000c58 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000cf0:	4705                	li	a4,1
  if(holding(lk))
    80000cf2:	e115                	bnez	a0,80000d16 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000cf4:	87ba                	mv	a5,a4
    80000cf6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000cfa:	2781                	sext.w	a5,a5
    80000cfc:	ffe5                	bnez	a5,80000cf4 <acquire+0x22>
  __sync_synchronize();
    80000cfe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000d02:	00001097          	auipc	ra,0x1
    80000d06:	ef8080e7          	jalr	-264(ra) # 80001bfa <mycpu>
    80000d0a:	e888                	sd	a0,16(s1)
}
    80000d0c:	60e2                	ld	ra,24(sp)
    80000d0e:	6442                	ld	s0,16(sp)
    80000d10:	64a2                	ld	s1,8(sp)
    80000d12:	6105                	addi	sp,sp,32
    80000d14:	8082                	ret
    panic("acquire");
    80000d16:	00007517          	auipc	a0,0x7
    80000d1a:	35a50513          	addi	a0,a0,858 # 80008070 <digits+0x30>
    80000d1e:	00000097          	auipc	ra,0x0
    80000d22:	820080e7          	jalr	-2016(ra) # 8000053e <panic>

0000000080000d26 <pop_off>:

void
pop_off(void)
{
    80000d26:	1141                	addi	sp,sp,-16
    80000d28:	e406                	sd	ra,8(sp)
    80000d2a:	e022                	sd	s0,0(sp)
    80000d2c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000d2e:	00001097          	auipc	ra,0x1
    80000d32:	ecc080e7          	jalr	-308(ra) # 80001bfa <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d36:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000d3a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000d3c:	e78d                	bnez	a5,80000d66 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000d3e:	5d3c                	lw	a5,120(a0)
    80000d40:	02f05b63          	blez	a5,80000d76 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000d44:	37fd                	addiw	a5,a5,-1
    80000d46:	0007871b          	sext.w	a4,a5
    80000d4a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000d4c:	eb09                	bnez	a4,80000d5e <pop_off+0x38>
    80000d4e:	5d7c                	lw	a5,124(a0)
    80000d50:	c799                	beqz	a5,80000d5e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000d56:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000d5a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000d5e:	60a2                	ld	ra,8(sp)
    80000d60:	6402                	ld	s0,0(sp)
    80000d62:	0141                	addi	sp,sp,16
    80000d64:	8082                	ret
    panic("pop_off - interruptible");
    80000d66:	00007517          	auipc	a0,0x7
    80000d6a:	31250513          	addi	a0,a0,786 # 80008078 <digits+0x38>
    80000d6e:	fffff097          	auipc	ra,0xfffff
    80000d72:	7d0080e7          	jalr	2000(ra) # 8000053e <panic>
    panic("pop_off");
    80000d76:	00007517          	auipc	a0,0x7
    80000d7a:	31a50513          	addi	a0,a0,794 # 80008090 <digits+0x50>
    80000d7e:	fffff097          	auipc	ra,0xfffff
    80000d82:	7c0080e7          	jalr	1984(ra) # 8000053e <panic>

0000000080000d86 <release>:
{
    80000d86:	1101                	addi	sp,sp,-32
    80000d88:	ec06                	sd	ra,24(sp)
    80000d8a:	e822                	sd	s0,16(sp)
    80000d8c:	e426                	sd	s1,8(sp)
    80000d8e:	1000                	addi	s0,sp,32
    80000d90:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000d92:	00000097          	auipc	ra,0x0
    80000d96:	ec6080e7          	jalr	-314(ra) # 80000c58 <holding>
    80000d9a:	c115                	beqz	a0,80000dbe <release+0x38>
  lk->cpu = 0;
    80000d9c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000da0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000da4:	0f50000f          	fence	iorw,ow
    80000da8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000dac:	00000097          	auipc	ra,0x0
    80000db0:	f7a080e7          	jalr	-134(ra) # 80000d26 <pop_off>
}
    80000db4:	60e2                	ld	ra,24(sp)
    80000db6:	6442                	ld	s0,16(sp)
    80000db8:	64a2                	ld	s1,8(sp)
    80000dba:	6105                	addi	sp,sp,32
    80000dbc:	8082                	ret
    panic("release");
    80000dbe:	00007517          	auipc	a0,0x7
    80000dc2:	2da50513          	addi	a0,a0,730 # 80008098 <digits+0x58>
    80000dc6:	fffff097          	auipc	ra,0xfffff
    80000dca:	778080e7          	jalr	1912(ra) # 8000053e <panic>

0000000080000dce <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000dce:	1141                	addi	sp,sp,-16
    80000dd0:	e422                	sd	s0,8(sp)
    80000dd2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000dd4:	ca19                	beqz	a2,80000dea <memset+0x1c>
    80000dd6:	87aa                	mv	a5,a0
    80000dd8:	1602                	slli	a2,a2,0x20
    80000dda:	9201                	srli	a2,a2,0x20
    80000ddc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000de0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000de4:	0785                	addi	a5,a5,1
    80000de6:	fee79de3          	bne	a5,a4,80000de0 <memset+0x12>
  }
  return dst;
}
    80000dea:	6422                	ld	s0,8(sp)
    80000dec:	0141                	addi	sp,sp,16
    80000dee:	8082                	ret

0000000080000df0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000df0:	1141                	addi	sp,sp,-16
    80000df2:	e422                	sd	s0,8(sp)
    80000df4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000df6:	ca05                	beqz	a2,80000e26 <memcmp+0x36>
    80000df8:	fff6069b          	addiw	a3,a2,-1
    80000dfc:	1682                	slli	a3,a3,0x20
    80000dfe:	9281                	srli	a3,a3,0x20
    80000e00:	0685                	addi	a3,a3,1
    80000e02:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000e04:	00054783          	lbu	a5,0(a0)
    80000e08:	0005c703          	lbu	a4,0(a1)
    80000e0c:	00e79863          	bne	a5,a4,80000e1c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000e10:	0505                	addi	a0,a0,1
    80000e12:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000e14:	fed518e3          	bne	a0,a3,80000e04 <memcmp+0x14>
  }

  return 0;
    80000e18:	4501                	li	a0,0
    80000e1a:	a019                	j	80000e20 <memcmp+0x30>
      return *s1 - *s2;
    80000e1c:	40e7853b          	subw	a0,a5,a4
}
    80000e20:	6422                	ld	s0,8(sp)
    80000e22:	0141                	addi	sp,sp,16
    80000e24:	8082                	ret
  return 0;
    80000e26:	4501                	li	a0,0
    80000e28:	bfe5                	j	80000e20 <memcmp+0x30>

0000000080000e2a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000e2a:	1141                	addi	sp,sp,-16
    80000e2c:	e422                	sd	s0,8(sp)
    80000e2e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000e30:	c205                	beqz	a2,80000e50 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e32:	02a5e263          	bltu	a1,a0,80000e56 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e36:	1602                	slli	a2,a2,0x20
    80000e38:	9201                	srli	a2,a2,0x20
    80000e3a:	00c587b3          	add	a5,a1,a2
{
    80000e3e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000e40:	0585                	addi	a1,a1,1
    80000e42:	0705                	addi	a4,a4,1
    80000e44:	fff5c683          	lbu	a3,-1(a1)
    80000e48:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000e4c:	fef59ae3          	bne	a1,a5,80000e40 <memmove+0x16>

  return dst;
}
    80000e50:	6422                	ld	s0,8(sp)
    80000e52:	0141                	addi	sp,sp,16
    80000e54:	8082                	ret
  if(s < d && s + n > d){
    80000e56:	02061693          	slli	a3,a2,0x20
    80000e5a:	9281                	srli	a3,a3,0x20
    80000e5c:	00d58733          	add	a4,a1,a3
    80000e60:	fce57be3          	bgeu	a0,a4,80000e36 <memmove+0xc>
    d += n;
    80000e64:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000e66:	fff6079b          	addiw	a5,a2,-1
    80000e6a:	1782                	slli	a5,a5,0x20
    80000e6c:	9381                	srli	a5,a5,0x20
    80000e6e:	fff7c793          	not	a5,a5
    80000e72:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000e74:	177d                	addi	a4,a4,-1
    80000e76:	16fd                	addi	a3,a3,-1
    80000e78:	00074603          	lbu	a2,0(a4)
    80000e7c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000e80:	fee79ae3          	bne	a5,a4,80000e74 <memmove+0x4a>
    80000e84:	b7f1                	j	80000e50 <memmove+0x26>

0000000080000e86 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e86:	1141                	addi	sp,sp,-16
    80000e88:	e406                	sd	ra,8(sp)
    80000e8a:	e022                	sd	s0,0(sp)
    80000e8c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e8e:	00000097          	auipc	ra,0x0
    80000e92:	f9c080e7          	jalr	-100(ra) # 80000e2a <memmove>
}
    80000e96:	60a2                	ld	ra,8(sp)
    80000e98:	6402                	ld	s0,0(sp)
    80000e9a:	0141                	addi	sp,sp,16
    80000e9c:	8082                	ret

0000000080000e9e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e9e:	1141                	addi	sp,sp,-16
    80000ea0:	e422                	sd	s0,8(sp)
    80000ea2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000ea4:	ce11                	beqz	a2,80000ec0 <strncmp+0x22>
    80000ea6:	00054783          	lbu	a5,0(a0)
    80000eaa:	cf89                	beqz	a5,80000ec4 <strncmp+0x26>
    80000eac:	0005c703          	lbu	a4,0(a1)
    80000eb0:	00f71a63          	bne	a4,a5,80000ec4 <strncmp+0x26>
    n--, p++, q++;
    80000eb4:	367d                	addiw	a2,a2,-1
    80000eb6:	0505                	addi	a0,a0,1
    80000eb8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000eba:	f675                	bnez	a2,80000ea6 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000ebc:	4501                	li	a0,0
    80000ebe:	a809                	j	80000ed0 <strncmp+0x32>
    80000ec0:	4501                	li	a0,0
    80000ec2:	a039                	j	80000ed0 <strncmp+0x32>
  if(n == 0)
    80000ec4:	ca09                	beqz	a2,80000ed6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000ec6:	00054503          	lbu	a0,0(a0)
    80000eca:	0005c783          	lbu	a5,0(a1)
    80000ece:	9d1d                	subw	a0,a0,a5
}
    80000ed0:	6422                	ld	s0,8(sp)
    80000ed2:	0141                	addi	sp,sp,16
    80000ed4:	8082                	ret
    return 0;
    80000ed6:	4501                	li	a0,0
    80000ed8:	bfe5                	j	80000ed0 <strncmp+0x32>

0000000080000eda <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000eda:	1141                	addi	sp,sp,-16
    80000edc:	e422                	sd	s0,8(sp)
    80000ede:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000ee0:	872a                	mv	a4,a0
    80000ee2:	8832                	mv	a6,a2
    80000ee4:	367d                	addiw	a2,a2,-1
    80000ee6:	01005963          	blez	a6,80000ef8 <strncpy+0x1e>
    80000eea:	0705                	addi	a4,a4,1
    80000eec:	0005c783          	lbu	a5,0(a1)
    80000ef0:	fef70fa3          	sb	a5,-1(a4)
    80000ef4:	0585                	addi	a1,a1,1
    80000ef6:	f7f5                	bnez	a5,80000ee2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000ef8:	86ba                	mv	a3,a4
    80000efa:	00c05c63          	blez	a2,80000f12 <strncpy+0x38>
    *s++ = 0;
    80000efe:	0685                	addi	a3,a3,1
    80000f00:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000f04:	fff6c793          	not	a5,a3
    80000f08:	9fb9                	addw	a5,a5,a4
    80000f0a:	010787bb          	addw	a5,a5,a6
    80000f0e:	fef048e3          	bgtz	a5,80000efe <strncpy+0x24>
  return os;
}
    80000f12:	6422                	ld	s0,8(sp)
    80000f14:	0141                	addi	sp,sp,16
    80000f16:	8082                	ret

0000000080000f18 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f18:	1141                	addi	sp,sp,-16
    80000f1a:	e422                	sd	s0,8(sp)
    80000f1c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f1e:	02c05363          	blez	a2,80000f44 <safestrcpy+0x2c>
    80000f22:	fff6069b          	addiw	a3,a2,-1
    80000f26:	1682                	slli	a3,a3,0x20
    80000f28:	9281                	srli	a3,a3,0x20
    80000f2a:	96ae                	add	a3,a3,a1
    80000f2c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f2e:	00d58963          	beq	a1,a3,80000f40 <safestrcpy+0x28>
    80000f32:	0585                	addi	a1,a1,1
    80000f34:	0785                	addi	a5,a5,1
    80000f36:	fff5c703          	lbu	a4,-1(a1)
    80000f3a:	fee78fa3          	sb	a4,-1(a5)
    80000f3e:	fb65                	bnez	a4,80000f2e <safestrcpy+0x16>
    ;
  *s = 0;
    80000f40:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f44:	6422                	ld	s0,8(sp)
    80000f46:	0141                	addi	sp,sp,16
    80000f48:	8082                	ret

0000000080000f4a <strlen>:

int
strlen(const char *s)
{
    80000f4a:	1141                	addi	sp,sp,-16
    80000f4c:	e422                	sd	s0,8(sp)
    80000f4e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000f50:	00054783          	lbu	a5,0(a0)
    80000f54:	cf91                	beqz	a5,80000f70 <strlen+0x26>
    80000f56:	0505                	addi	a0,a0,1
    80000f58:	87aa                	mv	a5,a0
    80000f5a:	4685                	li	a3,1
    80000f5c:	9e89                	subw	a3,a3,a0
    80000f5e:	00f6853b          	addw	a0,a3,a5
    80000f62:	0785                	addi	a5,a5,1
    80000f64:	fff7c703          	lbu	a4,-1(a5)
    80000f68:	fb7d                	bnez	a4,80000f5e <strlen+0x14>
    ;
  return n;
}
    80000f6a:	6422                	ld	s0,8(sp)
    80000f6c:	0141                	addi	sp,sp,16
    80000f6e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f70:	4501                	li	a0,0
    80000f72:	bfe5                	j	80000f6a <strlen+0x20>

0000000080000f74 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f74:	1141                	addi	sp,sp,-16
    80000f76:	e406                	sd	ra,8(sp)
    80000f78:	e022                	sd	s0,0(sp)
    80000f7a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f7c:	00001097          	auipc	ra,0x1
    80000f80:	c6e080e7          	jalr	-914(ra) # 80001bea <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f84:	00008717          	auipc	a4,0x8
    80000f88:	96470713          	addi	a4,a4,-1692 # 800088e8 <started>
  if(cpuid() == 0){
    80000f8c:	c139                	beqz	a0,80000fd2 <main+0x5e>
    while(started == 0)
    80000f8e:	431c                	lw	a5,0(a4)
    80000f90:	2781                	sext.w	a5,a5
    80000f92:	dff5                	beqz	a5,80000f8e <main+0x1a>
      ;
    __sync_synchronize();
    80000f94:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f98:	00001097          	auipc	ra,0x1
    80000f9c:	c52080e7          	jalr	-942(ra) # 80001bea <cpuid>
    80000fa0:	85aa                	mv	a1,a0
    80000fa2:	00007517          	auipc	a0,0x7
    80000fa6:	11650513          	addi	a0,a0,278 # 800080b8 <digits+0x78>
    80000faa:	fffff097          	auipc	ra,0xfffff
    80000fae:	5de080e7          	jalr	1502(ra) # 80000588 <printf>
    kvminithart();    // turn on paging
    80000fb2:	00000097          	auipc	ra,0x0
    80000fb6:	0d8080e7          	jalr	216(ra) # 8000108a <kvminithart>
    trapinithart();   // install kernel trap vector
    80000fba:	00002097          	auipc	ra,0x2
    80000fbe:	8fe080e7          	jalr	-1794(ra) # 800028b8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000fc2:	00005097          	auipc	ra,0x5
    80000fc6:	e9e080e7          	jalr	-354(ra) # 80005e60 <plicinithart>
  }

  scheduler();        
    80000fca:	00001097          	auipc	ra,0x1
    80000fce:	146080e7          	jalr	326(ra) # 80002110 <scheduler>
    consoleinit();
    80000fd2:	fffff097          	auipc	ra,0xfffff
    80000fd6:	47e080e7          	jalr	1150(ra) # 80000450 <consoleinit>
    printfinit();
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	78e080e7          	jalr	1934(ra) # 80000768 <printfinit>
    printf("\n");
    80000fe2:	00007517          	auipc	a0,0x7
    80000fe6:	0e650513          	addi	a0,a0,230 # 800080c8 <digits+0x88>
    80000fea:	fffff097          	auipc	ra,0xfffff
    80000fee:	59e080e7          	jalr	1438(ra) # 80000588 <printf>
    printf("xv6 kernel is booting\n");
    80000ff2:	00007517          	auipc	a0,0x7
    80000ff6:	0ae50513          	addi	a0,a0,174 # 800080a0 <digits+0x60>
    80000ffa:	fffff097          	auipc	ra,0xfffff
    80000ffe:	58e080e7          	jalr	1422(ra) # 80000588 <printf>
    printf("\n");
    80001002:	00007517          	auipc	a0,0x7
    80001006:	0c650513          	addi	a0,a0,198 # 800080c8 <digits+0x88>
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	57e080e7          	jalr	1406(ra) # 80000588 <printf>
    kinit();         // physical page allocator
    80001012:	00000097          	auipc	ra,0x0
    80001016:	b62080e7          	jalr	-1182(ra) # 80000b74 <kinit>
    kvminit();       // create kernel page table
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	34a080e7          	jalr	842(ra) # 80001364 <kvminit>
    kvminithart();   // turn on paging
    80001022:	00000097          	auipc	ra,0x0
    80001026:	068080e7          	jalr	104(ra) # 8000108a <kvminithart>
    procinit();      // process table
    8000102a:	00001097          	auipc	ra,0x1
    8000102e:	b0c080e7          	jalr	-1268(ra) # 80001b36 <procinit>
    trapinit();      // trap vectors
    80001032:	00002097          	auipc	ra,0x2
    80001036:	85e080e7          	jalr	-1954(ra) # 80002890 <trapinit>
    trapinithart();  // install kernel trap vector
    8000103a:	00002097          	auipc	ra,0x2
    8000103e:	87e080e7          	jalr	-1922(ra) # 800028b8 <trapinithart>
    plicinit();      // set up interrupt controller
    80001042:	00005097          	auipc	ra,0x5
    80001046:	e08080e7          	jalr	-504(ra) # 80005e4a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000104a:	00005097          	auipc	ra,0x5
    8000104e:	e16080e7          	jalr	-490(ra) # 80005e60 <plicinithart>
    binit();         // buffer cache
    80001052:	00002097          	auipc	ra,0x2
    80001056:	fdc080e7          	jalr	-36(ra) # 8000302e <binit>
    iinit();         // inode table
    8000105a:	00002097          	auipc	ra,0x2
    8000105e:	682080e7          	jalr	1666(ra) # 800036dc <iinit>
    fileinit();      // file table
    80001062:	00003097          	auipc	ra,0x3
    80001066:	624080e7          	jalr	1572(ra) # 80004686 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000106a:	00005097          	auipc	ra,0x5
    8000106e:	efe080e7          	jalr	-258(ra) # 80005f68 <virtio_disk_init>
    userinit();      // first user process
    80001072:	00001097          	auipc	ra,0x1
    80001076:	e80080e7          	jalr	-384(ra) # 80001ef2 <userinit>
    __sync_synchronize();
    8000107a:	0ff0000f          	fence
    started = 1;
    8000107e:	4785                	li	a5,1
    80001080:	00008717          	auipc	a4,0x8
    80001084:	86f72423          	sw	a5,-1944(a4) # 800088e8 <started>
    80001088:	b789                	j	80000fca <main+0x56>

000000008000108a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000108a:	1141                	addi	sp,sp,-16
    8000108c:	e422                	sd	s0,8(sp)
    8000108e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001090:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001094:	00008797          	auipc	a5,0x8
    80001098:	85c7b783          	ld	a5,-1956(a5) # 800088f0 <kernel_pagetable>
    8000109c:	83b1                	srli	a5,a5,0xc
    8000109e:	577d                	li	a4,-1
    800010a0:	177e                	slli	a4,a4,0x3f
    800010a2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800010a4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800010a8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800010ac:	6422                	ld	s0,8(sp)
    800010ae:	0141                	addi	sp,sp,16
    800010b0:	8082                	ret

00000000800010b2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800010b2:	7139                	addi	sp,sp,-64
    800010b4:	fc06                	sd	ra,56(sp)
    800010b6:	f822                	sd	s0,48(sp)
    800010b8:	f426                	sd	s1,40(sp)
    800010ba:	f04a                	sd	s2,32(sp)
    800010bc:	ec4e                	sd	s3,24(sp)
    800010be:	e852                	sd	s4,16(sp)
    800010c0:	e456                	sd	s5,8(sp)
    800010c2:	e05a                	sd	s6,0(sp)
    800010c4:	0080                	addi	s0,sp,64
    800010c6:	84aa                	mv	s1,a0
    800010c8:	89ae                	mv	s3,a1
    800010ca:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800010cc:	57fd                	li	a5,-1
    800010ce:	83e9                	srli	a5,a5,0x1a
    800010d0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800010d2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800010d4:	04b7f263          	bgeu	a5,a1,80001118 <walk+0x66>
    panic("walk");
    800010d8:	00007517          	auipc	a0,0x7
    800010dc:	ff850513          	addi	a0,a0,-8 # 800080d0 <digits+0x90>
    800010e0:	fffff097          	auipc	ra,0xfffff
    800010e4:	45e080e7          	jalr	1118(ra) # 8000053e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010e8:	060a8663          	beqz	s5,80001154 <walk+0xa2>
    800010ec:	00000097          	auipc	ra,0x0
    800010f0:	ac4080e7          	jalr	-1340(ra) # 80000bb0 <kalloc>
    800010f4:	84aa                	mv	s1,a0
    800010f6:	c529                	beqz	a0,80001140 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800010f8:	6605                	lui	a2,0x1
    800010fa:	4581                	li	a1,0
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	cd2080e7          	jalr	-814(ra) # 80000dce <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001104:	00c4d793          	srli	a5,s1,0xc
    80001108:	07aa                	slli	a5,a5,0xa
    8000110a:	0017e793          	ori	a5,a5,1
    8000110e:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001112:	3a5d                	addiw	s4,s4,-9
    80001114:	036a0063          	beq	s4,s6,80001134 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001118:	0149d933          	srl	s2,s3,s4
    8000111c:	1ff97913          	andi	s2,s2,511
    80001120:	090e                	slli	s2,s2,0x3
    80001122:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001124:	00093483          	ld	s1,0(s2)
    80001128:	0014f793          	andi	a5,s1,1
    8000112c:	dfd5                	beqz	a5,800010e8 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000112e:	80a9                	srli	s1,s1,0xa
    80001130:	04b2                	slli	s1,s1,0xc
    80001132:	b7c5                	j	80001112 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001134:	00c9d513          	srli	a0,s3,0xc
    80001138:	1ff57513          	andi	a0,a0,511
    8000113c:	050e                	slli	a0,a0,0x3
    8000113e:	9526                	add	a0,a0,s1
}
    80001140:	70e2                	ld	ra,56(sp)
    80001142:	7442                	ld	s0,48(sp)
    80001144:	74a2                	ld	s1,40(sp)
    80001146:	7902                	ld	s2,32(sp)
    80001148:	69e2                	ld	s3,24(sp)
    8000114a:	6a42                	ld	s4,16(sp)
    8000114c:	6aa2                	ld	s5,8(sp)
    8000114e:	6b02                	ld	s6,0(sp)
    80001150:	6121                	addi	sp,sp,64
    80001152:	8082                	ret
        return 0;
    80001154:	4501                	li	a0,0
    80001156:	b7ed                	j	80001140 <walk+0x8e>

0000000080001158 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001158:	57fd                	li	a5,-1
    8000115a:	83e9                	srli	a5,a5,0x1a
    8000115c:	00b7f463          	bgeu	a5,a1,80001164 <walkaddr+0xc>
    return 0;
    80001160:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001162:	8082                	ret
{
    80001164:	1141                	addi	sp,sp,-16
    80001166:	e406                	sd	ra,8(sp)
    80001168:	e022                	sd	s0,0(sp)
    8000116a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000116c:	4601                	li	a2,0
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	f44080e7          	jalr	-188(ra) # 800010b2 <walk>
  if(pte == 0)
    80001176:	c105                	beqz	a0,80001196 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001178:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000117a:	0117f693          	andi	a3,a5,17
    8000117e:	4745                	li	a4,17
    return 0;
    80001180:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001182:	00e68663          	beq	a3,a4,8000118e <walkaddr+0x36>
}
    80001186:	60a2                	ld	ra,8(sp)
    80001188:	6402                	ld	s0,0(sp)
    8000118a:	0141                	addi	sp,sp,16
    8000118c:	8082                	ret
  pa = PTE2PA(*pte);
    8000118e:	00a7d513          	srli	a0,a5,0xa
    80001192:	0532                	slli	a0,a0,0xc
  return pa;
    80001194:	bfcd                	j	80001186 <walkaddr+0x2e>
    return 0;
    80001196:	4501                	li	a0,0
    80001198:	b7fd                	j	80001186 <walkaddr+0x2e>

000000008000119a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000119a:	715d                	addi	sp,sp,-80
    8000119c:	e486                	sd	ra,72(sp)
    8000119e:	e0a2                	sd	s0,64(sp)
    800011a0:	fc26                	sd	s1,56(sp)
    800011a2:	f84a                	sd	s2,48(sp)
    800011a4:	f44e                	sd	s3,40(sp)
    800011a6:	f052                	sd	s4,32(sp)
    800011a8:	ec56                	sd	s5,24(sp)
    800011aa:	e85a                	sd	s6,16(sp)
    800011ac:	e45e                	sd	s7,8(sp)
    800011ae:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011b0:	03459793          	slli	a5,a1,0x34
    800011b4:	e7b9                	bnez	a5,80001202 <mappages+0x68>
    800011b6:	8aaa                	mv	s5,a0
    800011b8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800011ba:	03461793          	slli	a5,a2,0x34
    800011be:	ebb1                	bnez	a5,80001212 <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    800011c0:	c22d                	beqz	a2,80001222 <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800011c2:	79fd                	lui	s3,0xfffff
    800011c4:	964e                	add	a2,a2,s3
    800011c6:	00b609b3          	add	s3,a2,a1
  a = va;
    800011ca:	892e                	mv	s2,a1
    800011cc:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800011d0:	6b85                	lui	s7,0x1
    800011d2:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800011d6:	4605                	li	a2,1
    800011d8:	85ca                	mv	a1,s2
    800011da:	8556                	mv	a0,s5
    800011dc:	00000097          	auipc	ra,0x0
    800011e0:	ed6080e7          	jalr	-298(ra) # 800010b2 <walk>
    800011e4:	cd39                	beqz	a0,80001242 <mappages+0xa8>
    if(*pte & PTE_V)
    800011e6:	611c                	ld	a5,0(a0)
    800011e8:	8b85                	andi	a5,a5,1
    800011ea:	e7a1                	bnez	a5,80001232 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800011ec:	80b1                	srli	s1,s1,0xc
    800011ee:	04aa                	slli	s1,s1,0xa
    800011f0:	0164e4b3          	or	s1,s1,s6
    800011f4:	0014e493          	ori	s1,s1,1
    800011f8:	e104                	sd	s1,0(a0)
    if(a == last)
    800011fa:	07390063          	beq	s2,s3,8000125a <mappages+0xc0>
    a += PGSIZE;
    800011fe:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001200:	bfc9                	j	800011d2 <mappages+0x38>
    panic("mappages: va not aligned");
    80001202:	00007517          	auipc	a0,0x7
    80001206:	ed650513          	addi	a0,a0,-298 # 800080d8 <digits+0x98>
    8000120a:	fffff097          	auipc	ra,0xfffff
    8000120e:	334080e7          	jalr	820(ra) # 8000053e <panic>
    panic("mappages: size not aligned");
    80001212:	00007517          	auipc	a0,0x7
    80001216:	ee650513          	addi	a0,a0,-282 # 800080f8 <digits+0xb8>
    8000121a:	fffff097          	auipc	ra,0xfffff
    8000121e:	324080e7          	jalr	804(ra) # 8000053e <panic>
    panic("mappages: size");
    80001222:	00007517          	auipc	a0,0x7
    80001226:	ef650513          	addi	a0,a0,-266 # 80008118 <digits+0xd8>
    8000122a:	fffff097          	auipc	ra,0xfffff
    8000122e:	314080e7          	jalr	788(ra) # 8000053e <panic>
      panic("mappages: remap");
    80001232:	00007517          	auipc	a0,0x7
    80001236:	ef650513          	addi	a0,a0,-266 # 80008128 <digits+0xe8>
    8000123a:	fffff097          	auipc	ra,0xfffff
    8000123e:	304080e7          	jalr	772(ra) # 8000053e <panic>
      return -1;
    80001242:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001244:	60a6                	ld	ra,72(sp)
    80001246:	6406                	ld	s0,64(sp)
    80001248:	74e2                	ld	s1,56(sp)
    8000124a:	7942                	ld	s2,48(sp)
    8000124c:	79a2                	ld	s3,40(sp)
    8000124e:	7a02                	ld	s4,32(sp)
    80001250:	6ae2                	ld	s5,24(sp)
    80001252:	6b42                	ld	s6,16(sp)
    80001254:	6ba2                	ld	s7,8(sp)
    80001256:	6161                	addi	sp,sp,80
    80001258:	8082                	ret
  return 0;
    8000125a:	4501                	li	a0,0
    8000125c:	b7e5                	j	80001244 <mappages+0xaa>

000000008000125e <kvmmap>:
{
    8000125e:	1141                	addi	sp,sp,-16
    80001260:	e406                	sd	ra,8(sp)
    80001262:	e022                	sd	s0,0(sp)
    80001264:	0800                	addi	s0,sp,16
    80001266:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001268:	86b2                	mv	a3,a2
    8000126a:	863e                	mv	a2,a5
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	f2e080e7          	jalr	-210(ra) # 8000119a <mappages>
    80001274:	e509                	bnez	a0,8000127e <kvmmap+0x20>
}
    80001276:	60a2                	ld	ra,8(sp)
    80001278:	6402                	ld	s0,0(sp)
    8000127a:	0141                	addi	sp,sp,16
    8000127c:	8082                	ret
    panic("kvmmap");
    8000127e:	00007517          	auipc	a0,0x7
    80001282:	eba50513          	addi	a0,a0,-326 # 80008138 <digits+0xf8>
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	2b8080e7          	jalr	696(ra) # 8000053e <panic>

000000008000128e <kvmmake>:
{
    8000128e:	1101                	addi	sp,sp,-32
    80001290:	ec06                	sd	ra,24(sp)
    80001292:	e822                	sd	s0,16(sp)
    80001294:	e426                	sd	s1,8(sp)
    80001296:	e04a                	sd	s2,0(sp)
    80001298:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000129a:	00000097          	auipc	ra,0x0
    8000129e:	916080e7          	jalr	-1770(ra) # 80000bb0 <kalloc>
    800012a2:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800012a4:	6605                	lui	a2,0x1
    800012a6:	4581                	li	a1,0
    800012a8:	00000097          	auipc	ra,0x0
    800012ac:	b26080e7          	jalr	-1242(ra) # 80000dce <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800012b0:	4719                	li	a4,6
    800012b2:	6685                	lui	a3,0x1
    800012b4:	10000637          	lui	a2,0x10000
    800012b8:	100005b7          	lui	a1,0x10000
    800012bc:	8526                	mv	a0,s1
    800012be:	00000097          	auipc	ra,0x0
    800012c2:	fa0080e7          	jalr	-96(ra) # 8000125e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800012c6:	4719                	li	a4,6
    800012c8:	6685                	lui	a3,0x1
    800012ca:	10001637          	lui	a2,0x10001
    800012ce:	100015b7          	lui	a1,0x10001
    800012d2:	8526                	mv	a0,s1
    800012d4:	00000097          	auipc	ra,0x0
    800012d8:	f8a080e7          	jalr	-118(ra) # 8000125e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800012dc:	4719                	li	a4,6
    800012de:	004006b7          	lui	a3,0x400
    800012e2:	0c000637          	lui	a2,0xc000
    800012e6:	0c0005b7          	lui	a1,0xc000
    800012ea:	8526                	mv	a0,s1
    800012ec:	00000097          	auipc	ra,0x0
    800012f0:	f72080e7          	jalr	-142(ra) # 8000125e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800012f4:	00007917          	auipc	s2,0x7
    800012f8:	d0c90913          	addi	s2,s2,-756 # 80008000 <etext>
    800012fc:	4729                	li	a4,10
    800012fe:	80007697          	auipc	a3,0x80007
    80001302:	d0268693          	addi	a3,a3,-766 # 8000 <_entry-0x7fff8000>
    80001306:	4605                	li	a2,1
    80001308:	067e                	slli	a2,a2,0x1f
    8000130a:	85b2                	mv	a1,a2
    8000130c:	8526                	mv	a0,s1
    8000130e:	00000097          	auipc	ra,0x0
    80001312:	f50080e7          	jalr	-176(ra) # 8000125e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001316:	4719                	li	a4,6
    80001318:	46c5                	li	a3,17
    8000131a:	06ee                	slli	a3,a3,0x1b
    8000131c:	412686b3          	sub	a3,a3,s2
    80001320:	864a                	mv	a2,s2
    80001322:	85ca                	mv	a1,s2
    80001324:	8526                	mv	a0,s1
    80001326:	00000097          	auipc	ra,0x0
    8000132a:	f38080e7          	jalr	-200(ra) # 8000125e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000132e:	4729                	li	a4,10
    80001330:	6685                	lui	a3,0x1
    80001332:	00006617          	auipc	a2,0x6
    80001336:	cce60613          	addi	a2,a2,-818 # 80007000 <_trampoline>
    8000133a:	040005b7          	lui	a1,0x4000
    8000133e:	15fd                	addi	a1,a1,-1
    80001340:	05b2                	slli	a1,a1,0xc
    80001342:	8526                	mv	a0,s1
    80001344:	00000097          	auipc	ra,0x0
    80001348:	f1a080e7          	jalr	-230(ra) # 8000125e <kvmmap>
  proc_mapstacks(kpgtbl);
    8000134c:	8526                	mv	a0,s1
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	752080e7          	jalr	1874(ra) # 80001aa0 <proc_mapstacks>
}
    80001356:	8526                	mv	a0,s1
    80001358:	60e2                	ld	ra,24(sp)
    8000135a:	6442                	ld	s0,16(sp)
    8000135c:	64a2                	ld	s1,8(sp)
    8000135e:	6902                	ld	s2,0(sp)
    80001360:	6105                	addi	sp,sp,32
    80001362:	8082                	ret

0000000080001364 <kvminit>:
{
    80001364:	1141                	addi	sp,sp,-16
    80001366:	e406                	sd	ra,8(sp)
    80001368:	e022                	sd	s0,0(sp)
    8000136a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000136c:	00000097          	auipc	ra,0x0
    80001370:	f22080e7          	jalr	-222(ra) # 8000128e <kvmmake>
    80001374:	00007797          	auipc	a5,0x7
    80001378:	56a7be23          	sd	a0,1404(a5) # 800088f0 <kernel_pagetable>
}
    8000137c:	60a2                	ld	ra,8(sp)
    8000137e:	6402                	ld	s0,0(sp)
    80001380:	0141                	addi	sp,sp,16
    80001382:	8082                	ret

0000000080001384 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001384:	715d                	addi	sp,sp,-80
    80001386:	e486                	sd	ra,72(sp)
    80001388:	e0a2                	sd	s0,64(sp)
    8000138a:	fc26                	sd	s1,56(sp)
    8000138c:	f84a                	sd	s2,48(sp)
    8000138e:	f44e                	sd	s3,40(sp)
    80001390:	f052                	sd	s4,32(sp)
    80001392:	ec56                	sd	s5,24(sp)
    80001394:	e85a                	sd	s6,16(sp)
    80001396:	e45e                	sd	s7,8(sp)
    80001398:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000139a:	03459793          	slli	a5,a1,0x34
    8000139e:	e795                	bnez	a5,800013ca <uvmunmap+0x46>
    800013a0:	8a2a                	mv	s4,a0
    800013a2:	892e                	mv	s2,a1
    800013a4:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013a6:	0632                	slli	a2,a2,0xc
    800013a8:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800013ac:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013ae:	6b05                	lui	s6,0x1
    800013b0:	0735e263          	bltu	a1,s3,80001414 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800013b4:	60a6                	ld	ra,72(sp)
    800013b6:	6406                	ld	s0,64(sp)
    800013b8:	74e2                	ld	s1,56(sp)
    800013ba:	7942                	ld	s2,48(sp)
    800013bc:	79a2                	ld	s3,40(sp)
    800013be:	7a02                	ld	s4,32(sp)
    800013c0:	6ae2                	ld	s5,24(sp)
    800013c2:	6b42                	ld	s6,16(sp)
    800013c4:	6ba2                	ld	s7,8(sp)
    800013c6:	6161                	addi	sp,sp,80
    800013c8:	8082                	ret
    panic("uvmunmap: not aligned");
    800013ca:	00007517          	auipc	a0,0x7
    800013ce:	d7650513          	addi	a0,a0,-650 # 80008140 <digits+0x100>
    800013d2:	fffff097          	auipc	ra,0xfffff
    800013d6:	16c080e7          	jalr	364(ra) # 8000053e <panic>
      panic("uvmunmap: walk");
    800013da:	00007517          	auipc	a0,0x7
    800013de:	d7e50513          	addi	a0,a0,-642 # 80008158 <digits+0x118>
    800013e2:	fffff097          	auipc	ra,0xfffff
    800013e6:	15c080e7          	jalr	348(ra) # 8000053e <panic>
      panic("uvmunmap: not mapped");
    800013ea:	00007517          	auipc	a0,0x7
    800013ee:	d7e50513          	addi	a0,a0,-642 # 80008168 <digits+0x128>
    800013f2:	fffff097          	auipc	ra,0xfffff
    800013f6:	14c080e7          	jalr	332(ra) # 8000053e <panic>
      panic("uvmunmap: not a leaf");
    800013fa:	00007517          	auipc	a0,0x7
    800013fe:	d8650513          	addi	a0,a0,-634 # 80008180 <digits+0x140>
    80001402:	fffff097          	auipc	ra,0xfffff
    80001406:	13c080e7          	jalr	316(ra) # 8000053e <panic>
    *pte = 0;
    8000140a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000140e:	995a                	add	s2,s2,s6
    80001410:	fb3972e3          	bgeu	s2,s3,800013b4 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001414:	4601                	li	a2,0
    80001416:	85ca                	mv	a1,s2
    80001418:	8552                	mv	a0,s4
    8000141a:	00000097          	auipc	ra,0x0
    8000141e:	c98080e7          	jalr	-872(ra) # 800010b2 <walk>
    80001422:	84aa                	mv	s1,a0
    80001424:	d95d                	beqz	a0,800013da <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001426:	6108                	ld	a0,0(a0)
    80001428:	00157793          	andi	a5,a0,1
    8000142c:	dfdd                	beqz	a5,800013ea <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000142e:	3ff57793          	andi	a5,a0,1023
    80001432:	fd7784e3          	beq	a5,s7,800013fa <uvmunmap+0x76>
    if(do_free){
    80001436:	fc0a8ae3          	beqz	s5,8000140a <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000143a:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000143c:	0532                	slli	a0,a0,0xc
    8000143e:	fffff097          	auipc	ra,0xfffff
    80001442:	616080e7          	jalr	1558(ra) # 80000a54 <kfree>
    80001446:	b7d1                	j	8000140a <uvmunmap+0x86>

0000000080001448 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001448:	1101                	addi	sp,sp,-32
    8000144a:	ec06                	sd	ra,24(sp)
    8000144c:	e822                	sd	s0,16(sp)
    8000144e:	e426                	sd	s1,8(sp)
    80001450:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001452:	fffff097          	auipc	ra,0xfffff
    80001456:	75e080e7          	jalr	1886(ra) # 80000bb0 <kalloc>
    8000145a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000145c:	c519                	beqz	a0,8000146a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000145e:	6605                	lui	a2,0x1
    80001460:	4581                	li	a1,0
    80001462:	00000097          	auipc	ra,0x0
    80001466:	96c080e7          	jalr	-1684(ra) # 80000dce <memset>
  return pagetable;
}
    8000146a:	8526                	mv	a0,s1
    8000146c:	60e2                	ld	ra,24(sp)
    8000146e:	6442                	ld	s0,16(sp)
    80001470:	64a2                	ld	s1,8(sp)
    80001472:	6105                	addi	sp,sp,32
    80001474:	8082                	ret

0000000080001476 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001476:	7179                	addi	sp,sp,-48
    80001478:	f406                	sd	ra,40(sp)
    8000147a:	f022                	sd	s0,32(sp)
    8000147c:	ec26                	sd	s1,24(sp)
    8000147e:	e84a                	sd	s2,16(sp)
    80001480:	e44e                	sd	s3,8(sp)
    80001482:	e052                	sd	s4,0(sp)
    80001484:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001486:	6785                	lui	a5,0x1
    80001488:	04f67863          	bgeu	a2,a5,800014d8 <uvmfirst+0x62>
    8000148c:	8a2a                	mv	s4,a0
    8000148e:	89ae                	mv	s3,a1
    80001490:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001492:	fffff097          	auipc	ra,0xfffff
    80001496:	71e080e7          	jalr	1822(ra) # 80000bb0 <kalloc>
    8000149a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000149c:	6605                	lui	a2,0x1
    8000149e:	4581                	li	a1,0
    800014a0:	00000097          	auipc	ra,0x0
    800014a4:	92e080e7          	jalr	-1746(ra) # 80000dce <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800014a8:	4779                	li	a4,30
    800014aa:	86ca                	mv	a3,s2
    800014ac:	6605                	lui	a2,0x1
    800014ae:	4581                	li	a1,0
    800014b0:	8552                	mv	a0,s4
    800014b2:	00000097          	auipc	ra,0x0
    800014b6:	ce8080e7          	jalr	-792(ra) # 8000119a <mappages>
  memmove(mem, src, sz);
    800014ba:	8626                	mv	a2,s1
    800014bc:	85ce                	mv	a1,s3
    800014be:	854a                	mv	a0,s2
    800014c0:	00000097          	auipc	ra,0x0
    800014c4:	96a080e7          	jalr	-1686(ra) # 80000e2a <memmove>
}
    800014c8:	70a2                	ld	ra,40(sp)
    800014ca:	7402                	ld	s0,32(sp)
    800014cc:	64e2                	ld	s1,24(sp)
    800014ce:	6942                	ld	s2,16(sp)
    800014d0:	69a2                	ld	s3,8(sp)
    800014d2:	6a02                	ld	s4,0(sp)
    800014d4:	6145                	addi	sp,sp,48
    800014d6:	8082                	ret
    panic("uvmfirst: more than a page");
    800014d8:	00007517          	auipc	a0,0x7
    800014dc:	cc050513          	addi	a0,a0,-832 # 80008198 <digits+0x158>
    800014e0:	fffff097          	auipc	ra,0xfffff
    800014e4:	05e080e7          	jalr	94(ra) # 8000053e <panic>

00000000800014e8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800014e8:	1101                	addi	sp,sp,-32
    800014ea:	ec06                	sd	ra,24(sp)
    800014ec:	e822                	sd	s0,16(sp)
    800014ee:	e426                	sd	s1,8(sp)
    800014f0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800014f2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800014f4:	00b67d63          	bgeu	a2,a1,8000150e <uvmdealloc+0x26>
    800014f8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800014fa:	6785                	lui	a5,0x1
    800014fc:	17fd                	addi	a5,a5,-1
    800014fe:	00f60733          	add	a4,a2,a5
    80001502:	767d                	lui	a2,0xfffff
    80001504:	8f71                	and	a4,a4,a2
    80001506:	97ae                	add	a5,a5,a1
    80001508:	8ff1                	and	a5,a5,a2
    8000150a:	00f76863          	bltu	a4,a5,8000151a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000150e:	8526                	mv	a0,s1
    80001510:	60e2                	ld	ra,24(sp)
    80001512:	6442                	ld	s0,16(sp)
    80001514:	64a2                	ld	s1,8(sp)
    80001516:	6105                	addi	sp,sp,32
    80001518:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000151a:	8f99                	sub	a5,a5,a4
    8000151c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000151e:	4685                	li	a3,1
    80001520:	0007861b          	sext.w	a2,a5
    80001524:	85ba                	mv	a1,a4
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	e5e080e7          	jalr	-418(ra) # 80001384 <uvmunmap>
    8000152e:	b7c5                	j	8000150e <uvmdealloc+0x26>

0000000080001530 <uvmalloc>:
  if(newsz < oldsz)
    80001530:	0ab66563          	bltu	a2,a1,800015da <uvmalloc+0xaa>
{
    80001534:	7139                	addi	sp,sp,-64
    80001536:	fc06                	sd	ra,56(sp)
    80001538:	f822                	sd	s0,48(sp)
    8000153a:	f426                	sd	s1,40(sp)
    8000153c:	f04a                	sd	s2,32(sp)
    8000153e:	ec4e                	sd	s3,24(sp)
    80001540:	e852                	sd	s4,16(sp)
    80001542:	e456                	sd	s5,8(sp)
    80001544:	e05a                	sd	s6,0(sp)
    80001546:	0080                	addi	s0,sp,64
    80001548:	8aaa                	mv	s5,a0
    8000154a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000154c:	6985                	lui	s3,0x1
    8000154e:	19fd                	addi	s3,s3,-1
    80001550:	95ce                	add	a1,a1,s3
    80001552:	79fd                	lui	s3,0xfffff
    80001554:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001558:	08c9f363          	bgeu	s3,a2,800015de <uvmalloc+0xae>
    8000155c:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000155e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001562:	fffff097          	auipc	ra,0xfffff
    80001566:	64e080e7          	jalr	1614(ra) # 80000bb0 <kalloc>
    8000156a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000156c:	c51d                	beqz	a0,8000159a <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000156e:	6605                	lui	a2,0x1
    80001570:	4581                	li	a1,0
    80001572:	00000097          	auipc	ra,0x0
    80001576:	85c080e7          	jalr	-1956(ra) # 80000dce <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000157a:	875a                	mv	a4,s6
    8000157c:	86a6                	mv	a3,s1
    8000157e:	6605                	lui	a2,0x1
    80001580:	85ca                	mv	a1,s2
    80001582:	8556                	mv	a0,s5
    80001584:	00000097          	auipc	ra,0x0
    80001588:	c16080e7          	jalr	-1002(ra) # 8000119a <mappages>
    8000158c:	e90d                	bnez	a0,800015be <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000158e:	6785                	lui	a5,0x1
    80001590:	993e                	add	s2,s2,a5
    80001592:	fd4968e3          	bltu	s2,s4,80001562 <uvmalloc+0x32>
  return newsz;
    80001596:	8552                	mv	a0,s4
    80001598:	a809                	j	800015aa <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000159a:	864e                	mv	a2,s3
    8000159c:	85ca                	mv	a1,s2
    8000159e:	8556                	mv	a0,s5
    800015a0:	00000097          	auipc	ra,0x0
    800015a4:	f48080e7          	jalr	-184(ra) # 800014e8 <uvmdealloc>
      return 0;
    800015a8:	4501                	li	a0,0
}
    800015aa:	70e2                	ld	ra,56(sp)
    800015ac:	7442                	ld	s0,48(sp)
    800015ae:	74a2                	ld	s1,40(sp)
    800015b0:	7902                	ld	s2,32(sp)
    800015b2:	69e2                	ld	s3,24(sp)
    800015b4:	6a42                	ld	s4,16(sp)
    800015b6:	6aa2                	ld	s5,8(sp)
    800015b8:	6b02                	ld	s6,0(sp)
    800015ba:	6121                	addi	sp,sp,64
    800015bc:	8082                	ret
      kfree(mem);
    800015be:	8526                	mv	a0,s1
    800015c0:	fffff097          	auipc	ra,0xfffff
    800015c4:	494080e7          	jalr	1172(ra) # 80000a54 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800015c8:	864e                	mv	a2,s3
    800015ca:	85ca                	mv	a1,s2
    800015cc:	8556                	mv	a0,s5
    800015ce:	00000097          	auipc	ra,0x0
    800015d2:	f1a080e7          	jalr	-230(ra) # 800014e8 <uvmdealloc>
      return 0;
    800015d6:	4501                	li	a0,0
    800015d8:	bfc9                	j	800015aa <uvmalloc+0x7a>
    return oldsz;
    800015da:	852e                	mv	a0,a1
}
    800015dc:	8082                	ret
  return newsz;
    800015de:	8532                	mv	a0,a2
    800015e0:	b7e9                	j	800015aa <uvmalloc+0x7a>

00000000800015e2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800015e2:	7179                	addi	sp,sp,-48
    800015e4:	f406                	sd	ra,40(sp)
    800015e6:	f022                	sd	s0,32(sp)
    800015e8:	ec26                	sd	s1,24(sp)
    800015ea:	e84a                	sd	s2,16(sp)
    800015ec:	e44e                	sd	s3,8(sp)
    800015ee:	e052                	sd	s4,0(sp)
    800015f0:	1800                	addi	s0,sp,48
    800015f2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800015f4:	84aa                	mv	s1,a0
    800015f6:	6905                	lui	s2,0x1
    800015f8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015fa:	4985                	li	s3,1
    800015fc:	a821                	j	80001614 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800015fe:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001600:	0532                	slli	a0,a0,0xc
    80001602:	00000097          	auipc	ra,0x0
    80001606:	fe0080e7          	jalr	-32(ra) # 800015e2 <freewalk>
      pagetable[i] = 0;
    8000160a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000160e:	04a1                	addi	s1,s1,8
    80001610:	03248163          	beq	s1,s2,80001632 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001614:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001616:	00f57793          	andi	a5,a0,15
    8000161a:	ff3782e3          	beq	a5,s3,800015fe <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000161e:	8905                	andi	a0,a0,1
    80001620:	d57d                	beqz	a0,8000160e <freewalk+0x2c>
      panic("freewalk: leaf");
    80001622:	00007517          	auipc	a0,0x7
    80001626:	b9650513          	addi	a0,a0,-1130 # 800081b8 <digits+0x178>
    8000162a:	fffff097          	auipc	ra,0xfffff
    8000162e:	f14080e7          	jalr	-236(ra) # 8000053e <panic>
    }
  }
  kfree((void*)pagetable);
    80001632:	8552                	mv	a0,s4
    80001634:	fffff097          	auipc	ra,0xfffff
    80001638:	420080e7          	jalr	1056(ra) # 80000a54 <kfree>
}
    8000163c:	70a2                	ld	ra,40(sp)
    8000163e:	7402                	ld	s0,32(sp)
    80001640:	64e2                	ld	s1,24(sp)
    80001642:	6942                	ld	s2,16(sp)
    80001644:	69a2                	ld	s3,8(sp)
    80001646:	6a02                	ld	s4,0(sp)
    80001648:	6145                	addi	sp,sp,48
    8000164a:	8082                	ret

000000008000164c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000164c:	1101                	addi	sp,sp,-32
    8000164e:	ec06                	sd	ra,24(sp)
    80001650:	e822                	sd	s0,16(sp)
    80001652:	e426                	sd	s1,8(sp)
    80001654:	1000                	addi	s0,sp,32
    80001656:	84aa                	mv	s1,a0
  if(sz > 0)
    80001658:	e999                	bnez	a1,8000166e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000165a:	8526                	mv	a0,s1
    8000165c:	00000097          	auipc	ra,0x0
    80001660:	f86080e7          	jalr	-122(ra) # 800015e2 <freewalk>
}
    80001664:	60e2                	ld	ra,24(sp)
    80001666:	6442                	ld	s0,16(sp)
    80001668:	64a2                	ld	s1,8(sp)
    8000166a:	6105                	addi	sp,sp,32
    8000166c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000166e:	6605                	lui	a2,0x1
    80001670:	167d                	addi	a2,a2,-1
    80001672:	962e                	add	a2,a2,a1
    80001674:	4685                	li	a3,1
    80001676:	8231                	srli	a2,a2,0xc
    80001678:	4581                	li	a1,0
    8000167a:	00000097          	auipc	ra,0x0
    8000167e:	d0a080e7          	jalr	-758(ra) # 80001384 <uvmunmap>
    80001682:	bfe1                	j	8000165a <uvmfree+0xe>

0000000080001684 <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80001684:	10060363          	beqz	a2,8000178a <uvmcopy+0x106>
{
    80001688:	711d                	addi	sp,sp,-96
    8000168a:	ec86                	sd	ra,88(sp)
    8000168c:	e8a2                	sd	s0,80(sp)
    8000168e:	e4a6                	sd	s1,72(sp)
    80001690:	e0ca                	sd	s2,64(sp)
    80001692:	fc4e                	sd	s3,56(sp)
    80001694:	f852                	sd	s4,48(sp)
    80001696:	f456                	sd	s5,40(sp)
    80001698:	f05a                	sd	s6,32(sp)
    8000169a:	ec5e                	sd	s7,24(sp)
    8000169c:	e862                	sd	s8,16(sp)
    8000169e:	e466                	sd	s9,8(sp)
    800016a0:	1080                	addi	s0,sp,96
    800016a2:	8baa                	mv	s7,a0
    800016a4:	8b2e                	mv	s6,a1
    800016a6:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    800016a8:	4981                	li	s3,0
    flags = PTE_FLAGS(*pte);
    if (flags & PTE_W){
      uint64 perm = ((flags & ~(PTE_W|PTE_V)) | PTE_COW);
      if(mappages(new, i, PGSIZE, pa, perm) != 0)
        goto err;
      *pte = PA2PTE(pa) | ((flags & ~PTE_W) | PTE_COW);
    800016aa:	7c7d                	lui	s8,0xfffff
    800016ac:	002c5c13          	srli	s8,s8,0x2
    800016b0:	a0a9                	j	800016fa <uvmcopy+0x76>
      panic("uvmcopy: pte should exist");
    800016b2:	00007517          	auipc	a0,0x7
    800016b6:	b1650513          	addi	a0,a0,-1258 # 800081c8 <digits+0x188>
    800016ba:	fffff097          	auipc	ra,0xfffff
    800016be:	e84080e7          	jalr	-380(ra) # 8000053e <panic>
      panic("uvmcopy: page not present");
    800016c2:	00007517          	auipc	a0,0x7
    800016c6:	b2650513          	addi	a0,a0,-1242 # 800081e8 <digits+0x1a8>
    800016ca:	fffff097          	auipc	ra,0xfffff
    800016ce:	e74080e7          	jalr	-396(ra) # 8000053e <panic>
    } 
    else {
      uint64 perm = (flags& ~PTE_V);
      if(mappages(new, i, PGSIZE, pa, perm) != 0)
    800016d2:	3fecf713          	andi	a4,s9,1022
    800016d6:	86d2                	mv	a3,s4
    800016d8:	6605                	lui	a2,0x1
    800016da:	85ce                	mv	a1,s3
    800016dc:	855a                	mv	a0,s6
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	abc080e7          	jalr	-1348(ra) # 8000119a <mappages>
    800016e6:	e559                	bnez	a0,80001774 <uvmcopy+0xf0>
        goto err;
    }
    addref(pa);
    800016e8:	8552                	mv	a0,s4
    800016ea:	fffff097          	auipc	ra,0xfffff
    800016ee:	31e080e7          	jalr	798(ra) # 80000a08 <addref>
  for(i = 0; i < sz; i += PGSIZE){
    800016f2:	6785                	lui	a5,0x1
    800016f4:	99be                	add	s3,s3,a5
    800016f6:	0559ff63          	bgeu	s3,s5,80001754 <uvmcopy+0xd0>
    if((pte = walk(old, i, 0)) == 0)
    800016fa:	4601                	li	a2,0
    800016fc:	85ce                	mv	a1,s3
    800016fe:	855e                	mv	a0,s7
    80001700:	00000097          	auipc	ra,0x0
    80001704:	9b2080e7          	jalr	-1614(ra) # 800010b2 <walk>
    80001708:	892a                	mv	s2,a0
    8000170a:	d545                	beqz	a0,800016b2 <uvmcopy+0x2e>
    if((*pte & PTE_V) == 0)
    8000170c:	6104                	ld	s1,0(a0)
    8000170e:	0014f793          	andi	a5,s1,1
    80001712:	dbc5                	beqz	a5,800016c2 <uvmcopy+0x3e>
    pa = PTE2PA(*pte);
    80001714:	00a4da13          	srli	s4,s1,0xa
    80001718:	0a32                	slli	s4,s4,0xc
    flags = PTE_FLAGS(*pte);
    8000171a:	3ff4fc93          	andi	s9,s1,1023
    if (flags & PTE_W){
    8000171e:	0044f793          	andi	a5,s1,4
    80001722:	dbc5                	beqz	a5,800016d2 <uvmcopy+0x4e>
      uint64 perm = ((flags & ~(PTE_W|PTE_V)) | PTE_COW);
    80001724:	2facf713          	andi	a4,s9,762
      if(mappages(new, i, PGSIZE, pa, perm) != 0)
    80001728:	10076713          	ori	a4,a4,256
    8000172c:	86d2                	mv	a3,s4
    8000172e:	6605                	lui	a2,0x1
    80001730:	85ce                	mv	a1,s3
    80001732:	855a                	mv	a0,s6
    80001734:	00000097          	auipc	ra,0x0
    80001738:	a66080e7          	jalr	-1434(ra) # 8000119a <mappages>
    8000173c:	ed05                	bnez	a0,80001774 <uvmcopy+0xf0>
      *pte = PA2PTE(pa) | ((flags & ~PTE_W) | PTE_COW);
    8000173e:	0184f4b3          	and	s1,s1,s8
    80001742:	2fbcfc93          	andi	s9,s9,763
    80001746:	0194e4b3          	or	s1,s1,s9
    8000174a:	1004e493          	ori	s1,s1,256
    8000174e:	00993023          	sd	s1,0(s2) # 1000 <_entry-0x7ffff000>
    80001752:	bf59                	j	800016e8 <uvmcopy+0x64>
    80001754:	12000073          	sfence.vma
  }
  sfence_vma();
  return 0;
    80001758:	4501                	li	a0,0

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
  return -1;
}
    8000175a:	60e6                	ld	ra,88(sp)
    8000175c:	6446                	ld	s0,80(sp)
    8000175e:	64a6                	ld	s1,72(sp)
    80001760:	6906                	ld	s2,64(sp)
    80001762:	79e2                	ld	s3,56(sp)
    80001764:	7a42                	ld	s4,48(sp)
    80001766:	7aa2                	ld	s5,40(sp)
    80001768:	7b02                	ld	s6,32(sp)
    8000176a:	6be2                	ld	s7,24(sp)
    8000176c:	6c42                	ld	s8,16(sp)
    8000176e:	6ca2                	ld	s9,8(sp)
    80001770:	6125                	addi	sp,sp,96
    80001772:	8082                	ret
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001774:	4685                	li	a3,1
    80001776:	00c9d613          	srli	a2,s3,0xc
    8000177a:	4581                	li	a1,0
    8000177c:	855a                	mv	a0,s6
    8000177e:	00000097          	auipc	ra,0x0
    80001782:	c06080e7          	jalr	-1018(ra) # 80001384 <uvmunmap>
  return -1;
    80001786:	557d                	li	a0,-1
    80001788:	bfc9                	j	8000175a <uvmcopy+0xd6>
    8000178a:	12000073          	sfence.vma
  return 0;
    8000178e:	4501                	li	a0,0
}
    80001790:	8082                	ret

0000000080001792 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001792:	1141                	addi	sp,sp,-16
    80001794:	e406                	sd	ra,8(sp)
    80001796:	e022                	sd	s0,0(sp)
    80001798:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000179a:	4601                	li	a2,0
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	916080e7          	jalr	-1770(ra) # 800010b2 <walk>
  if(pte == 0)
    800017a4:	c901                	beqz	a0,800017b4 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800017a6:	611c                	ld	a5,0(a0)
    800017a8:	9bbd                	andi	a5,a5,-17
    800017aa:	e11c                	sd	a5,0(a0)
}
    800017ac:	60a2                	ld	ra,8(sp)
    800017ae:	6402                	ld	s0,0(sp)
    800017b0:	0141                	addi	sp,sp,16
    800017b2:	8082                	ret
    panic("uvmclear");
    800017b4:	00007517          	auipc	a0,0x7
    800017b8:	a5450513          	addi	a0,a0,-1452 # 80008208 <digits+0x1c8>
    800017bc:	fffff097          	auipc	ra,0xfffff
    800017c0:	d82080e7          	jalr	-638(ra) # 8000053e <panic>

00000000800017c4 <allocate_cow>:


int
allocate_cow(pagetable_t pagetable, uint64 va)
{
  if (va>=MAXVA) 
    800017c4:	57fd                	li	a5,-1
    800017c6:	83e9                	srli	a5,a5,0x1a
    800017c8:	08b7e663          	bltu	a5,a1,80001854 <allocate_cow+0x90>
{
    800017cc:	7179                	addi	sp,sp,-48
    800017ce:	f406                	sd	ra,40(sp)
    800017d0:	f022                	sd	s0,32(sp)
    800017d2:	ec26                	sd	s1,24(sp)
    800017d4:	e84a                	sd	s2,16(sp)
    800017d6:	e44e                	sd	s3,8(sp)
    800017d8:	e052                	sd	s4,0(sp)
    800017da:	1800                	addi	s0,sp,48
    return -1;
  va = PGROUNDDOWN(va);
  pte_t *pte = walk(pagetable, va, 0);
    800017dc:	4601                	li	a2,0
    800017de:	77fd                	lui	a5,0xfffff
    800017e0:	8dfd                	and	a1,a1,a5
    800017e2:	00000097          	auipc	ra,0x0
    800017e6:	8d0080e7          	jalr	-1840(ra) # 800010b2 <walk>
    800017ea:	89aa                	mv	s3,a0
  if(pte == 0) return -1;
    800017ec:	c535                	beqz	a0,80001858 <allocate_cow+0x94>
  if((*pte & PTE_V) == 0 || (*pte & PTE_U) == 0) return -1;
    800017ee:	00053903          	ld	s2,0(a0)
    800017f2:	01197713          	andi	a4,s2,17
    800017f6:	47c5                	li	a5,17
    800017f8:	06f71263          	bne	a4,a5,8000185c <allocate_cow+0x98>
  if((*pte & PTE_COW) == 0) return -1;           
    800017fc:	10097793          	andi	a5,s2,256
    80001800:	c3a5                	beqz	a5,80001860 <allocate_cow+0x9c>

  uint64 oldpa = PTE2PA(*pte);
    80001802:	00a95a13          	srli	s4,s2,0xa
    80001806:	0a32                	slli	s4,s4,0xc
  uint64 flags = PTE_FLAGS(*pte);

  void *mem = kalloc();
    80001808:	fffff097          	auipc	ra,0xfffff
    8000180c:	3a8080e7          	jalr	936(ra) # 80000bb0 <kalloc>
    80001810:	84aa                	mv	s1,a0
  if(mem == 0)
    80001812:	c929                	beqz	a0,80001864 <allocate_cow+0xa0>
    return -1;

  memmove(mem, (void*)(oldpa), PGSIZE);
    80001814:	6605                	lui	a2,0x1
    80001816:	85d2                	mv	a1,s4
    80001818:	fffff097          	auipc	ra,0xfffff
    8000181c:	612080e7          	jalr	1554(ra) # 80000e2a <memmove>

  uint64 newpa =(uint64)(mem);
  *pte = PA2PTE(newpa) | ((flags | PTE_W) & ~PTE_COW);
    80001820:	80b1                	srli	s1,s1,0xc
    80001822:	04aa                	slli	s1,s1,0xa
    80001824:	2fb97913          	andi	s2,s2,763
    80001828:	0124e4b3          	or	s1,s1,s2
    8000182c:	0044e493          	ori	s1,s1,4
    80001830:	0099b023          	sd	s1,0(s3) # fffffffffffff000 <end+0xffffffff7fdbd280>

  kfree((void*)(oldpa));
    80001834:	8552                	mv	a0,s4
    80001836:	fffff097          	auipc	ra,0xfffff
    8000183a:	21e080e7          	jalr	542(ra) # 80000a54 <kfree>
    8000183e:	12000073          	sfence.vma

  sfence_vma();
  return 0;
    80001842:	4501                	li	a0,0
}
    80001844:	70a2                	ld	ra,40(sp)
    80001846:	7402                	ld	s0,32(sp)
    80001848:	64e2                	ld	s1,24(sp)
    8000184a:	6942                	ld	s2,16(sp)
    8000184c:	69a2                	ld	s3,8(sp)
    8000184e:	6a02                	ld	s4,0(sp)
    80001850:	6145                	addi	sp,sp,48
    80001852:	8082                	ret
    return -1;
    80001854:	557d                	li	a0,-1
}
    80001856:	8082                	ret
  if(pte == 0) return -1;
    80001858:	557d                	li	a0,-1
    8000185a:	b7ed                	j	80001844 <allocate_cow+0x80>
  if((*pte & PTE_V) == 0 || (*pte & PTE_U) == 0) return -1;
    8000185c:	557d                	li	a0,-1
    8000185e:	b7dd                	j	80001844 <allocate_cow+0x80>
  if((*pte & PTE_COW) == 0) return -1;           
    80001860:	557d                	li	a0,-1
    80001862:	b7cd                	j	80001844 <allocate_cow+0x80>
    return -1;
    80001864:	557d                	li	a0,-1
    80001866:	bff9                	j	80001844 <allocate_cow+0x80>

0000000080001868 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001868:	c2e1                	beqz	a3,80001928 <copyout+0xc0>
{
    8000186a:	711d                	addi	sp,sp,-96
    8000186c:	ec86                	sd	ra,88(sp)
    8000186e:	e8a2                	sd	s0,80(sp)
    80001870:	e4a6                	sd	s1,72(sp)
    80001872:	e0ca                	sd	s2,64(sp)
    80001874:	fc4e                	sd	s3,56(sp)
    80001876:	f852                	sd	s4,48(sp)
    80001878:	f456                	sd	s5,40(sp)
    8000187a:	f05a                	sd	s6,32(sp)
    8000187c:	ec5e                	sd	s7,24(sp)
    8000187e:	e862                	sd	s8,16(sp)
    80001880:	e466                	sd	s9,8(sp)
    80001882:	e06a                	sd	s10,0(sp)
    80001884:	1080                	addi	s0,sp,96
    80001886:	8b2a                	mv	s6,a0
    80001888:	89ae                	mv	s3,a1
    8000188a:	8ab2                	mv	s5,a2
    8000188c:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    8000188e:	74fd                	lui	s1,0xfffff
    80001890:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001892:	57fd                	li	a5,-1
    80001894:	83e9                	srli	a5,a5,0x1a
    80001896:	0897eb63          	bltu	a5,s1,8000192c <copyout+0xc4>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    8000189a:	4c45                	li	s8,17
      }else{
        return -1;
      }
    }
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    8000189c:	6c85                	lui	s9,0x1
    va0 = PGROUNDDOWN(dstva);
    8000189e:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    800018a0:	8bbe                	mv	s7,a5
    800018a2:	a805                	j	800018d2 <copyout+0x6a>
    pa0 = PTE2PA(*pte);
    800018a4:	611c                	ld	a5,0(a0)
    800018a6:	83a9                	srli	a5,a5,0xa
    800018a8:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800018aa:	40998533          	sub	a0,s3,s1
    800018ae:	0009061b          	sext.w	a2,s2
    800018b2:	85d6                	mv	a1,s5
    800018b4:	953e                	add	a0,a0,a5
    800018b6:	fffff097          	auipc	ra,0xfffff
    800018ba:	574080e7          	jalr	1396(ra) # 80000e2a <memmove>

    len -= n;
    800018be:	412a0a33          	sub	s4,s4,s2
    src += n;
    800018c2:	9aca                	add	s5,s5,s2
    dstva += n;
    800018c4:	99ca                	add	s3,s3,s2
  while(len > 0){
    800018c6:	040a0f63          	beqz	s4,80001924 <copyout+0xbc>
    va0 = PGROUNDDOWN(dstva);
    800018ca:	01a9f4b3          	and	s1,s3,s10
    if(va0 >= MAXVA)
    800018ce:	069be163          	bltu	s7,s1,80001930 <copyout+0xc8>
    pte = walk(pagetable, va0, 0);
    800018d2:	4601                	li	a2,0
    800018d4:	85a6                	mv	a1,s1
    800018d6:	855a                	mv	a0,s6
    800018d8:	fffff097          	auipc	ra,0xfffff
    800018dc:	7da080e7          	jalr	2010(ra) # 800010b2 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    800018e0:	c931                	beqz	a0,80001934 <copyout+0xcc>
    800018e2:	611c                	ld	a5,0(a0)
    800018e4:	0117f713          	andi	a4,a5,17
    800018e8:	07871563          	bne	a4,s8,80001952 <copyout+0xea>
    if((*pte & PTE_W) == 0){
    800018ec:	0047f713          	andi	a4,a5,4
    800018f0:	e315                	bnez	a4,80001914 <copyout+0xac>
      if((*pte & PTE_COW) && allocate_cow(pagetable, va0) == 0){
    800018f2:	1007f793          	andi	a5,a5,256
    800018f6:	c3a5                	beqz	a5,80001956 <copyout+0xee>
    800018f8:	85a6                	mv	a1,s1
    800018fa:	855a                	mv	a0,s6
    800018fc:	00000097          	auipc	ra,0x0
    80001900:	ec8080e7          	jalr	-312(ra) # 800017c4 <allocate_cow>
    80001904:	e939                	bnez	a0,8000195a <copyout+0xf2>
        pte = walk(pagetable, va0, 0);
    80001906:	4601                	li	a2,0
    80001908:	85a6                	mv	a1,s1
    8000190a:	855a                	mv	a0,s6
    8000190c:	fffff097          	auipc	ra,0xfffff
    80001910:	7a6080e7          	jalr	1958(ra) # 800010b2 <walk>
    n = PGSIZE - (dstva - va0);
    80001914:	01948933          	add	s2,s1,s9
    80001918:	41390933          	sub	s2,s2,s3
    if(n > len)
    8000191c:	f92a74e3          	bgeu	s4,s2,800018a4 <copyout+0x3c>
    80001920:	8952                	mv	s2,s4
    80001922:	b749                	j	800018a4 <copyout+0x3c>
  }
  return 0;
    80001924:	4501                	li	a0,0
    80001926:	a801                	j	80001936 <copyout+0xce>
    80001928:	4501                	li	a0,0
}
    8000192a:	8082                	ret
      return -1;
    8000192c:	557d                	li	a0,-1
    8000192e:	a021                	j	80001936 <copyout+0xce>
    80001930:	557d                	li	a0,-1
    80001932:	a011                	j	80001936 <copyout+0xce>
      return -1;
    80001934:	557d                	li	a0,-1
}
    80001936:	60e6                	ld	ra,88(sp)
    80001938:	6446                	ld	s0,80(sp)
    8000193a:	64a6                	ld	s1,72(sp)
    8000193c:	6906                	ld	s2,64(sp)
    8000193e:	79e2                	ld	s3,56(sp)
    80001940:	7a42                	ld	s4,48(sp)
    80001942:	7aa2                	ld	s5,40(sp)
    80001944:	7b02                	ld	s6,32(sp)
    80001946:	6be2                	ld	s7,24(sp)
    80001948:	6c42                	ld	s8,16(sp)
    8000194a:	6ca2                	ld	s9,8(sp)
    8000194c:	6d02                	ld	s10,0(sp)
    8000194e:	6125                	addi	sp,sp,96
    80001950:	8082                	ret
      return -1;
    80001952:	557d                	li	a0,-1
    80001954:	b7cd                	j	80001936 <copyout+0xce>
        return -1;
    80001956:	557d                	li	a0,-1
    80001958:	bff9                	j	80001936 <copyout+0xce>
    8000195a:	557d                	li	a0,-1
    8000195c:	bfe9                	j	80001936 <copyout+0xce>

000000008000195e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000195e:	caa5                	beqz	a3,800019ce <copyin+0x70>
{
    80001960:	715d                	addi	sp,sp,-80
    80001962:	e486                	sd	ra,72(sp)
    80001964:	e0a2                	sd	s0,64(sp)
    80001966:	fc26                	sd	s1,56(sp)
    80001968:	f84a                	sd	s2,48(sp)
    8000196a:	f44e                	sd	s3,40(sp)
    8000196c:	f052                	sd	s4,32(sp)
    8000196e:	ec56                	sd	s5,24(sp)
    80001970:	e85a                	sd	s6,16(sp)
    80001972:	e45e                	sd	s7,8(sp)
    80001974:	e062                	sd	s8,0(sp)
    80001976:	0880                	addi	s0,sp,80
    80001978:	8b2a                	mv	s6,a0
    8000197a:	8a2e                	mv	s4,a1
    8000197c:	8c32                	mv	s8,a2
    8000197e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001980:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001982:	6a85                	lui	s5,0x1
    80001984:	a01d                	j	800019aa <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001986:	018505b3          	add	a1,a0,s8
    8000198a:	0004861b          	sext.w	a2,s1
    8000198e:	412585b3          	sub	a1,a1,s2
    80001992:	8552                	mv	a0,s4
    80001994:	fffff097          	auipc	ra,0xfffff
    80001998:	496080e7          	jalr	1174(ra) # 80000e2a <memmove>

    len -= n;
    8000199c:	409989b3          	sub	s3,s3,s1
    dst += n;
    800019a0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800019a2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800019a6:	02098263          	beqz	s3,800019ca <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800019aa:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800019ae:	85ca                	mv	a1,s2
    800019b0:	855a                	mv	a0,s6
    800019b2:	fffff097          	auipc	ra,0xfffff
    800019b6:	7a6080e7          	jalr	1958(ra) # 80001158 <walkaddr>
    if(pa0 == 0)
    800019ba:	cd01                	beqz	a0,800019d2 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800019bc:	418904b3          	sub	s1,s2,s8
    800019c0:	94d6                	add	s1,s1,s5
    if(n > len)
    800019c2:	fc99f2e3          	bgeu	s3,s1,80001986 <copyin+0x28>
    800019c6:	84ce                	mv	s1,s3
    800019c8:	bf7d                	j	80001986 <copyin+0x28>
  }
  return 0;
    800019ca:	4501                	li	a0,0
    800019cc:	a021                	j	800019d4 <copyin+0x76>
    800019ce:	4501                	li	a0,0
}
    800019d0:	8082                	ret
      return -1;
    800019d2:	557d                	li	a0,-1
}
    800019d4:	60a6                	ld	ra,72(sp)
    800019d6:	6406                	ld	s0,64(sp)
    800019d8:	74e2                	ld	s1,56(sp)
    800019da:	7942                	ld	s2,48(sp)
    800019dc:	79a2                	ld	s3,40(sp)
    800019de:	7a02                	ld	s4,32(sp)
    800019e0:	6ae2                	ld	s5,24(sp)
    800019e2:	6b42                	ld	s6,16(sp)
    800019e4:	6ba2                	ld	s7,8(sp)
    800019e6:	6c02                	ld	s8,0(sp)
    800019e8:	6161                	addi	sp,sp,80
    800019ea:	8082                	ret

00000000800019ec <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800019ec:	c6c5                	beqz	a3,80001a94 <copyinstr+0xa8>
{
    800019ee:	715d                	addi	sp,sp,-80
    800019f0:	e486                	sd	ra,72(sp)
    800019f2:	e0a2                	sd	s0,64(sp)
    800019f4:	fc26                	sd	s1,56(sp)
    800019f6:	f84a                	sd	s2,48(sp)
    800019f8:	f44e                	sd	s3,40(sp)
    800019fa:	f052                	sd	s4,32(sp)
    800019fc:	ec56                	sd	s5,24(sp)
    800019fe:	e85a                	sd	s6,16(sp)
    80001a00:	e45e                	sd	s7,8(sp)
    80001a02:	0880                	addi	s0,sp,80
    80001a04:	8a2a                	mv	s4,a0
    80001a06:	8b2e                	mv	s6,a1
    80001a08:	8bb2                	mv	s7,a2
    80001a0a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001a0c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001a0e:	6985                	lui	s3,0x1
    80001a10:	a035                	j	80001a3c <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001a12:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7fdbd280>
    80001a16:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001a18:	0017b793          	seqz	a5,a5
    80001a1c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001a20:	60a6                	ld	ra,72(sp)
    80001a22:	6406                	ld	s0,64(sp)
    80001a24:	74e2                	ld	s1,56(sp)
    80001a26:	7942                	ld	s2,48(sp)
    80001a28:	79a2                	ld	s3,40(sp)
    80001a2a:	7a02                	ld	s4,32(sp)
    80001a2c:	6ae2                	ld	s5,24(sp)
    80001a2e:	6b42                	ld	s6,16(sp)
    80001a30:	6ba2                	ld	s7,8(sp)
    80001a32:	6161                	addi	sp,sp,80
    80001a34:	8082                	ret
    srcva = va0 + PGSIZE;
    80001a36:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001a3a:	c8a9                	beqz	s1,80001a8c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80001a3c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001a40:	85ca                	mv	a1,s2
    80001a42:	8552                	mv	a0,s4
    80001a44:	fffff097          	auipc	ra,0xfffff
    80001a48:	714080e7          	jalr	1812(ra) # 80001158 <walkaddr>
    if(pa0 == 0)
    80001a4c:	c131                	beqz	a0,80001a90 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001a4e:	41790833          	sub	a6,s2,s7
    80001a52:	984e                	add	a6,a6,s3
    if(n > max)
    80001a54:	0104f363          	bgeu	s1,a6,80001a5a <copyinstr+0x6e>
    80001a58:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001a5a:	955e                	add	a0,a0,s7
    80001a5c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001a60:	fc080be3          	beqz	a6,80001a36 <copyinstr+0x4a>
    80001a64:	985a                	add	a6,a6,s6
    80001a66:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001a68:	41650633          	sub	a2,a0,s6
    80001a6c:	14fd                	addi	s1,s1,-1
    80001a6e:	9b26                	add	s6,s6,s1
    80001a70:	00f60733          	add	a4,a2,a5
    80001a74:	00074703          	lbu	a4,0(a4)
    80001a78:	df49                	beqz	a4,80001a12 <copyinstr+0x26>
        *dst = *p;
    80001a7a:	00e78023          	sb	a4,0(a5)
      --max;
    80001a7e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001a82:	0785                	addi	a5,a5,1
    while(n > 0){
    80001a84:	ff0796e3          	bne	a5,a6,80001a70 <copyinstr+0x84>
      dst++;
    80001a88:	8b42                	mv	s6,a6
    80001a8a:	b775                	j	80001a36 <copyinstr+0x4a>
    80001a8c:	4781                	li	a5,0
    80001a8e:	b769                	j	80001a18 <copyinstr+0x2c>
      return -1;
    80001a90:	557d                	li	a0,-1
    80001a92:	b779                	j	80001a20 <copyinstr+0x34>
  int got_null = 0;
    80001a94:	4781                	li	a5,0
  if(got_null){
    80001a96:	0017b793          	seqz	a5,a5
    80001a9a:	40f00533          	neg	a0,a5
}
    80001a9e:	8082                	ret

0000000080001aa0 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001aa0:	7139                	addi	sp,sp,-64
    80001aa2:	fc06                	sd	ra,56(sp)
    80001aa4:	f822                	sd	s0,48(sp)
    80001aa6:	f426                	sd	s1,40(sp)
    80001aa8:	f04a                	sd	s2,32(sp)
    80001aaa:	ec4e                	sd	s3,24(sp)
    80001aac:	e852                	sd	s4,16(sp)
    80001aae:	e456                	sd	s5,8(sp)
    80001ab0:	e05a                	sd	s6,0(sp)
    80001ab2:	0080                	addi	s0,sp,64
    80001ab4:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ab6:	0022f497          	auipc	s1,0x22f
    80001aba:	4ea48493          	addi	s1,s1,1258 # 80230fa0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001abe:	8b26                	mv	s6,s1
    80001ac0:	00006a97          	auipc	s5,0x6
    80001ac4:	540a8a93          	addi	s5,s5,1344 # 80008000 <etext>
    80001ac8:	04000937          	lui	s2,0x4000
    80001acc:	197d                	addi	s2,s2,-1
    80001ace:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ad0:	00235a17          	auipc	s4,0x235
    80001ad4:	ed0a0a13          	addi	s4,s4,-304 # 802369a0 <tickslock>
    char *pa = kalloc();
    80001ad8:	fffff097          	auipc	ra,0xfffff
    80001adc:	0d8080e7          	jalr	216(ra) # 80000bb0 <kalloc>
    80001ae0:	862a                	mv	a2,a0
    if(pa == 0)
    80001ae2:	c131                	beqz	a0,80001b26 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001ae4:	416485b3          	sub	a1,s1,s6
    80001ae8:	858d                	srai	a1,a1,0x3
    80001aea:	000ab783          	ld	a5,0(s5)
    80001aee:	02f585b3          	mul	a1,a1,a5
    80001af2:	2585                	addiw	a1,a1,1
    80001af4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001af8:	4719                	li	a4,6
    80001afa:	6685                	lui	a3,0x1
    80001afc:	40b905b3          	sub	a1,s2,a1
    80001b00:	854e                	mv	a0,s3
    80001b02:	fffff097          	auipc	ra,0xfffff
    80001b06:	75c080e7          	jalr	1884(ra) # 8000125e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b0a:	16848493          	addi	s1,s1,360
    80001b0e:	fd4495e3          	bne	s1,s4,80001ad8 <proc_mapstacks+0x38>
  }
}
    80001b12:	70e2                	ld	ra,56(sp)
    80001b14:	7442                	ld	s0,48(sp)
    80001b16:	74a2                	ld	s1,40(sp)
    80001b18:	7902                	ld	s2,32(sp)
    80001b1a:	69e2                	ld	s3,24(sp)
    80001b1c:	6a42                	ld	s4,16(sp)
    80001b1e:	6aa2                	ld	s5,8(sp)
    80001b20:	6b02                	ld	s6,0(sp)
    80001b22:	6121                	addi	sp,sp,64
    80001b24:	8082                	ret
      panic("kalloc");
    80001b26:	00006517          	auipc	a0,0x6
    80001b2a:	6f250513          	addi	a0,a0,1778 # 80008218 <digits+0x1d8>
    80001b2e:	fffff097          	auipc	ra,0xfffff
    80001b32:	a10080e7          	jalr	-1520(ra) # 8000053e <panic>

0000000080001b36 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001b36:	7139                	addi	sp,sp,-64
    80001b38:	fc06                	sd	ra,56(sp)
    80001b3a:	f822                	sd	s0,48(sp)
    80001b3c:	f426                	sd	s1,40(sp)
    80001b3e:	f04a                	sd	s2,32(sp)
    80001b40:	ec4e                	sd	s3,24(sp)
    80001b42:	e852                	sd	s4,16(sp)
    80001b44:	e456                	sd	s5,8(sp)
    80001b46:	e05a                	sd	s6,0(sp)
    80001b48:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001b4a:	00006597          	auipc	a1,0x6
    80001b4e:	6d658593          	addi	a1,a1,1750 # 80008220 <digits+0x1e0>
    80001b52:	0022f517          	auipc	a0,0x22f
    80001b56:	01e50513          	addi	a0,a0,30 # 80230b70 <pid_lock>
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	0e8080e7          	jalr	232(ra) # 80000c42 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001b62:	00006597          	auipc	a1,0x6
    80001b66:	6c658593          	addi	a1,a1,1734 # 80008228 <digits+0x1e8>
    80001b6a:	0022f517          	auipc	a0,0x22f
    80001b6e:	01e50513          	addi	a0,a0,30 # 80230b88 <wait_lock>
    80001b72:	fffff097          	auipc	ra,0xfffff
    80001b76:	0d0080e7          	jalr	208(ra) # 80000c42 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b7a:	0022f497          	auipc	s1,0x22f
    80001b7e:	42648493          	addi	s1,s1,1062 # 80230fa0 <proc>
      initlock(&p->lock, "proc");
    80001b82:	00006b17          	auipc	s6,0x6
    80001b86:	6b6b0b13          	addi	s6,s6,1718 # 80008238 <digits+0x1f8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001b8a:	8aa6                	mv	s5,s1
    80001b8c:	00006a17          	auipc	s4,0x6
    80001b90:	474a0a13          	addi	s4,s4,1140 # 80008000 <etext>
    80001b94:	04000937          	lui	s2,0x4000
    80001b98:	197d                	addi	s2,s2,-1
    80001b9a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b9c:	00235997          	auipc	s3,0x235
    80001ba0:	e0498993          	addi	s3,s3,-508 # 802369a0 <tickslock>
      initlock(&p->lock, "proc");
    80001ba4:	85da                	mv	a1,s6
    80001ba6:	8526                	mv	a0,s1
    80001ba8:	fffff097          	auipc	ra,0xfffff
    80001bac:	09a080e7          	jalr	154(ra) # 80000c42 <initlock>
      p->state = UNUSED;
    80001bb0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001bb4:	415487b3          	sub	a5,s1,s5
    80001bb8:	878d                	srai	a5,a5,0x3
    80001bba:	000a3703          	ld	a4,0(s4)
    80001bbe:	02e787b3          	mul	a5,a5,a4
    80001bc2:	2785                	addiw	a5,a5,1
    80001bc4:	00d7979b          	slliw	a5,a5,0xd
    80001bc8:	40f907b3          	sub	a5,s2,a5
    80001bcc:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bce:	16848493          	addi	s1,s1,360
    80001bd2:	fd3499e3          	bne	s1,s3,80001ba4 <procinit+0x6e>
  }
}
    80001bd6:	70e2                	ld	ra,56(sp)
    80001bd8:	7442                	ld	s0,48(sp)
    80001bda:	74a2                	ld	s1,40(sp)
    80001bdc:	7902                	ld	s2,32(sp)
    80001bde:	69e2                	ld	s3,24(sp)
    80001be0:	6a42                	ld	s4,16(sp)
    80001be2:	6aa2                	ld	s5,8(sp)
    80001be4:	6b02                	ld	s6,0(sp)
    80001be6:	6121                	addi	sp,sp,64
    80001be8:	8082                	ret

0000000080001bea <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001bea:	1141                	addi	sp,sp,-16
    80001bec:	e422                	sd	s0,8(sp)
    80001bee:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bf0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001bf2:	2501                	sext.w	a0,a0
    80001bf4:	6422                	ld	s0,8(sp)
    80001bf6:	0141                	addi	sp,sp,16
    80001bf8:	8082                	ret

0000000080001bfa <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001bfa:	1141                	addi	sp,sp,-16
    80001bfc:	e422                	sd	s0,8(sp)
    80001bfe:	0800                	addi	s0,sp,16
    80001c00:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001c02:	2781                	sext.w	a5,a5
    80001c04:	079e                	slli	a5,a5,0x7
  return c;
}
    80001c06:	0022f517          	auipc	a0,0x22f
    80001c0a:	f9a50513          	addi	a0,a0,-102 # 80230ba0 <cpus>
    80001c0e:	953e                	add	a0,a0,a5
    80001c10:	6422                	ld	s0,8(sp)
    80001c12:	0141                	addi	sp,sp,16
    80001c14:	8082                	ret

0000000080001c16 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001c16:	1101                	addi	sp,sp,-32
    80001c18:	ec06                	sd	ra,24(sp)
    80001c1a:	e822                	sd	s0,16(sp)
    80001c1c:	e426                	sd	s1,8(sp)
    80001c1e:	1000                	addi	s0,sp,32
  push_off();
    80001c20:	fffff097          	auipc	ra,0xfffff
    80001c24:	066080e7          	jalr	102(ra) # 80000c86 <push_off>
    80001c28:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001c2a:	2781                	sext.w	a5,a5
    80001c2c:	079e                	slli	a5,a5,0x7
    80001c2e:	0022f717          	auipc	a4,0x22f
    80001c32:	f4270713          	addi	a4,a4,-190 # 80230b70 <pid_lock>
    80001c36:	97ba                	add	a5,a5,a4
    80001c38:	7b84                	ld	s1,48(a5)
  pop_off();
    80001c3a:	fffff097          	auipc	ra,0xfffff
    80001c3e:	0ec080e7          	jalr	236(ra) # 80000d26 <pop_off>
  return p;
}
    80001c42:	8526                	mv	a0,s1
    80001c44:	60e2                	ld	ra,24(sp)
    80001c46:	6442                	ld	s0,16(sp)
    80001c48:	64a2                	ld	s1,8(sp)
    80001c4a:	6105                	addi	sp,sp,32
    80001c4c:	8082                	ret

0000000080001c4e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001c4e:	1141                	addi	sp,sp,-16
    80001c50:	e406                	sd	ra,8(sp)
    80001c52:	e022                	sd	s0,0(sp)
    80001c54:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001c56:	00000097          	auipc	ra,0x0
    80001c5a:	fc0080e7          	jalr	-64(ra) # 80001c16 <myproc>
    80001c5e:	fffff097          	auipc	ra,0xfffff
    80001c62:	128080e7          	jalr	296(ra) # 80000d86 <release>

  if (first) {
    80001c66:	00007797          	auipc	a5,0x7
    80001c6a:	c1a7a783          	lw	a5,-998(a5) # 80008880 <first.1>
    80001c6e:	eb89                	bnez	a5,80001c80 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001c70:	00001097          	auipc	ra,0x1
    80001c74:	c60080e7          	jalr	-928(ra) # 800028d0 <usertrapret>
}
    80001c78:	60a2                	ld	ra,8(sp)
    80001c7a:	6402                	ld	s0,0(sp)
    80001c7c:	0141                	addi	sp,sp,16
    80001c7e:	8082                	ret
    fsinit(ROOTDEV);
    80001c80:	4505                	li	a0,1
    80001c82:	00002097          	auipc	ra,0x2
    80001c86:	9da080e7          	jalr	-1574(ra) # 8000365c <fsinit>
    first = 0;
    80001c8a:	00007797          	auipc	a5,0x7
    80001c8e:	be07ab23          	sw	zero,-1034(a5) # 80008880 <first.1>
    __sync_synchronize();
    80001c92:	0ff0000f          	fence
    80001c96:	bfe9                	j	80001c70 <forkret+0x22>

0000000080001c98 <allocpid>:
{
    80001c98:	1101                	addi	sp,sp,-32
    80001c9a:	ec06                	sd	ra,24(sp)
    80001c9c:	e822                	sd	s0,16(sp)
    80001c9e:	e426                	sd	s1,8(sp)
    80001ca0:	e04a                	sd	s2,0(sp)
    80001ca2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001ca4:	0022f917          	auipc	s2,0x22f
    80001ca8:	ecc90913          	addi	s2,s2,-308 # 80230b70 <pid_lock>
    80001cac:	854a                	mv	a0,s2
    80001cae:	fffff097          	auipc	ra,0xfffff
    80001cb2:	024080e7          	jalr	36(ra) # 80000cd2 <acquire>
  pid = nextpid;
    80001cb6:	00007797          	auipc	a5,0x7
    80001cba:	bce78793          	addi	a5,a5,-1074 # 80008884 <nextpid>
    80001cbe:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001cc0:	0014871b          	addiw	a4,s1,1
    80001cc4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001cc6:	854a                	mv	a0,s2
    80001cc8:	fffff097          	auipc	ra,0xfffff
    80001ccc:	0be080e7          	jalr	190(ra) # 80000d86 <release>
}
    80001cd0:	8526                	mv	a0,s1
    80001cd2:	60e2                	ld	ra,24(sp)
    80001cd4:	6442                	ld	s0,16(sp)
    80001cd6:	64a2                	ld	s1,8(sp)
    80001cd8:	6902                	ld	s2,0(sp)
    80001cda:	6105                	addi	sp,sp,32
    80001cdc:	8082                	ret

0000000080001cde <proc_pagetable>:
{
    80001cde:	1101                	addi	sp,sp,-32
    80001ce0:	ec06                	sd	ra,24(sp)
    80001ce2:	e822                	sd	s0,16(sp)
    80001ce4:	e426                	sd	s1,8(sp)
    80001ce6:	e04a                	sd	s2,0(sp)
    80001ce8:	1000                	addi	s0,sp,32
    80001cea:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001cec:	fffff097          	auipc	ra,0xfffff
    80001cf0:	75c080e7          	jalr	1884(ra) # 80001448 <uvmcreate>
    80001cf4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001cf6:	c121                	beqz	a0,80001d36 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001cf8:	4729                	li	a4,10
    80001cfa:	00005697          	auipc	a3,0x5
    80001cfe:	30668693          	addi	a3,a3,774 # 80007000 <_trampoline>
    80001d02:	6605                	lui	a2,0x1
    80001d04:	040005b7          	lui	a1,0x4000
    80001d08:	15fd                	addi	a1,a1,-1
    80001d0a:	05b2                	slli	a1,a1,0xc
    80001d0c:	fffff097          	auipc	ra,0xfffff
    80001d10:	48e080e7          	jalr	1166(ra) # 8000119a <mappages>
    80001d14:	02054863          	bltz	a0,80001d44 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001d18:	4719                	li	a4,6
    80001d1a:	05893683          	ld	a3,88(s2)
    80001d1e:	6605                	lui	a2,0x1
    80001d20:	020005b7          	lui	a1,0x2000
    80001d24:	15fd                	addi	a1,a1,-1
    80001d26:	05b6                	slli	a1,a1,0xd
    80001d28:	8526                	mv	a0,s1
    80001d2a:	fffff097          	auipc	ra,0xfffff
    80001d2e:	470080e7          	jalr	1136(ra) # 8000119a <mappages>
    80001d32:	02054163          	bltz	a0,80001d54 <proc_pagetable+0x76>
}
    80001d36:	8526                	mv	a0,s1
    80001d38:	60e2                	ld	ra,24(sp)
    80001d3a:	6442                	ld	s0,16(sp)
    80001d3c:	64a2                	ld	s1,8(sp)
    80001d3e:	6902                	ld	s2,0(sp)
    80001d40:	6105                	addi	sp,sp,32
    80001d42:	8082                	ret
    uvmfree(pagetable, 0);
    80001d44:	4581                	li	a1,0
    80001d46:	8526                	mv	a0,s1
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	904080e7          	jalr	-1788(ra) # 8000164c <uvmfree>
    return 0;
    80001d50:	4481                	li	s1,0
    80001d52:	b7d5                	j	80001d36 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d54:	4681                	li	a3,0
    80001d56:	4605                	li	a2,1
    80001d58:	040005b7          	lui	a1,0x4000
    80001d5c:	15fd                	addi	a1,a1,-1
    80001d5e:	05b2                	slli	a1,a1,0xc
    80001d60:	8526                	mv	a0,s1
    80001d62:	fffff097          	auipc	ra,0xfffff
    80001d66:	622080e7          	jalr	1570(ra) # 80001384 <uvmunmap>
    uvmfree(pagetable, 0);
    80001d6a:	4581                	li	a1,0
    80001d6c:	8526                	mv	a0,s1
    80001d6e:	00000097          	auipc	ra,0x0
    80001d72:	8de080e7          	jalr	-1826(ra) # 8000164c <uvmfree>
    return 0;
    80001d76:	4481                	li	s1,0
    80001d78:	bf7d                	j	80001d36 <proc_pagetable+0x58>

0000000080001d7a <proc_freepagetable>:
{
    80001d7a:	1101                	addi	sp,sp,-32
    80001d7c:	ec06                	sd	ra,24(sp)
    80001d7e:	e822                	sd	s0,16(sp)
    80001d80:	e426                	sd	s1,8(sp)
    80001d82:	e04a                	sd	s2,0(sp)
    80001d84:	1000                	addi	s0,sp,32
    80001d86:	84aa                	mv	s1,a0
    80001d88:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d8a:	4681                	li	a3,0
    80001d8c:	4605                	li	a2,1
    80001d8e:	040005b7          	lui	a1,0x4000
    80001d92:	15fd                	addi	a1,a1,-1
    80001d94:	05b2                	slli	a1,a1,0xc
    80001d96:	fffff097          	auipc	ra,0xfffff
    80001d9a:	5ee080e7          	jalr	1518(ra) # 80001384 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001d9e:	4681                	li	a3,0
    80001da0:	4605                	li	a2,1
    80001da2:	020005b7          	lui	a1,0x2000
    80001da6:	15fd                	addi	a1,a1,-1
    80001da8:	05b6                	slli	a1,a1,0xd
    80001daa:	8526                	mv	a0,s1
    80001dac:	fffff097          	auipc	ra,0xfffff
    80001db0:	5d8080e7          	jalr	1496(ra) # 80001384 <uvmunmap>
  uvmfree(pagetable, sz);
    80001db4:	85ca                	mv	a1,s2
    80001db6:	8526                	mv	a0,s1
    80001db8:	00000097          	auipc	ra,0x0
    80001dbc:	894080e7          	jalr	-1900(ra) # 8000164c <uvmfree>
}
    80001dc0:	60e2                	ld	ra,24(sp)
    80001dc2:	6442                	ld	s0,16(sp)
    80001dc4:	64a2                	ld	s1,8(sp)
    80001dc6:	6902                	ld	s2,0(sp)
    80001dc8:	6105                	addi	sp,sp,32
    80001dca:	8082                	ret

0000000080001dcc <freeproc>:
{
    80001dcc:	1101                	addi	sp,sp,-32
    80001dce:	ec06                	sd	ra,24(sp)
    80001dd0:	e822                	sd	s0,16(sp)
    80001dd2:	e426                	sd	s1,8(sp)
    80001dd4:	1000                	addi	s0,sp,32
    80001dd6:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001dd8:	6d28                	ld	a0,88(a0)
    80001dda:	c509                	beqz	a0,80001de4 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001ddc:	fffff097          	auipc	ra,0xfffff
    80001de0:	c78080e7          	jalr	-904(ra) # 80000a54 <kfree>
  p->trapframe = 0;
    80001de4:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001de8:	68a8                	ld	a0,80(s1)
    80001dea:	c511                	beqz	a0,80001df6 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001dec:	64ac                	ld	a1,72(s1)
    80001dee:	00000097          	auipc	ra,0x0
    80001df2:	f8c080e7          	jalr	-116(ra) # 80001d7a <proc_freepagetable>
  p->pagetable = 0;
    80001df6:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001dfa:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001dfe:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001e02:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001e06:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001e0a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001e0e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001e12:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001e16:	0004ac23          	sw	zero,24(s1)
}
    80001e1a:	60e2                	ld	ra,24(sp)
    80001e1c:	6442                	ld	s0,16(sp)
    80001e1e:	64a2                	ld	s1,8(sp)
    80001e20:	6105                	addi	sp,sp,32
    80001e22:	8082                	ret

0000000080001e24 <allocproc>:
{
    80001e24:	1101                	addi	sp,sp,-32
    80001e26:	ec06                	sd	ra,24(sp)
    80001e28:	e822                	sd	s0,16(sp)
    80001e2a:	e426                	sd	s1,8(sp)
    80001e2c:	e04a                	sd	s2,0(sp)
    80001e2e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e30:	0022f497          	auipc	s1,0x22f
    80001e34:	17048493          	addi	s1,s1,368 # 80230fa0 <proc>
    80001e38:	00235917          	auipc	s2,0x235
    80001e3c:	b6890913          	addi	s2,s2,-1176 # 802369a0 <tickslock>
    acquire(&p->lock);
    80001e40:	8526                	mv	a0,s1
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	e90080e7          	jalr	-368(ra) # 80000cd2 <acquire>
    if(p->state == UNUSED) {
    80001e4a:	4c9c                	lw	a5,24(s1)
    80001e4c:	cf81                	beqz	a5,80001e64 <allocproc+0x40>
      release(&p->lock);
    80001e4e:	8526                	mv	a0,s1
    80001e50:	fffff097          	auipc	ra,0xfffff
    80001e54:	f36080e7          	jalr	-202(ra) # 80000d86 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e58:	16848493          	addi	s1,s1,360
    80001e5c:	ff2492e3          	bne	s1,s2,80001e40 <allocproc+0x1c>
  return 0;
    80001e60:	4481                	li	s1,0
    80001e62:	a889                	j	80001eb4 <allocproc+0x90>
  p->pid = allocpid();
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	e34080e7          	jalr	-460(ra) # 80001c98 <allocpid>
    80001e6c:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001e6e:	4785                	li	a5,1
    80001e70:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001e72:	fffff097          	auipc	ra,0xfffff
    80001e76:	d3e080e7          	jalr	-706(ra) # 80000bb0 <kalloc>
    80001e7a:	892a                	mv	s2,a0
    80001e7c:	eca8                	sd	a0,88(s1)
    80001e7e:	c131                	beqz	a0,80001ec2 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001e80:	8526                	mv	a0,s1
    80001e82:	00000097          	auipc	ra,0x0
    80001e86:	e5c080e7          	jalr	-420(ra) # 80001cde <proc_pagetable>
    80001e8a:	892a                	mv	s2,a0
    80001e8c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001e8e:	c531                	beqz	a0,80001eda <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001e90:	07000613          	li	a2,112
    80001e94:	4581                	li	a1,0
    80001e96:	06048513          	addi	a0,s1,96
    80001e9a:	fffff097          	auipc	ra,0xfffff
    80001e9e:	f34080e7          	jalr	-204(ra) # 80000dce <memset>
  p->context.ra = (uint64)forkret;
    80001ea2:	00000797          	auipc	a5,0x0
    80001ea6:	dac78793          	addi	a5,a5,-596 # 80001c4e <forkret>
    80001eaa:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001eac:	60bc                	ld	a5,64(s1)
    80001eae:	6705                	lui	a4,0x1
    80001eb0:	97ba                	add	a5,a5,a4
    80001eb2:	f4bc                	sd	a5,104(s1)
}
    80001eb4:	8526                	mv	a0,s1
    80001eb6:	60e2                	ld	ra,24(sp)
    80001eb8:	6442                	ld	s0,16(sp)
    80001eba:	64a2                	ld	s1,8(sp)
    80001ebc:	6902                	ld	s2,0(sp)
    80001ebe:	6105                	addi	sp,sp,32
    80001ec0:	8082                	ret
    freeproc(p);
    80001ec2:	8526                	mv	a0,s1
    80001ec4:	00000097          	auipc	ra,0x0
    80001ec8:	f08080e7          	jalr	-248(ra) # 80001dcc <freeproc>
    release(&p->lock);
    80001ecc:	8526                	mv	a0,s1
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	eb8080e7          	jalr	-328(ra) # 80000d86 <release>
    return 0;
    80001ed6:	84ca                	mv	s1,s2
    80001ed8:	bff1                	j	80001eb4 <allocproc+0x90>
    freeproc(p);
    80001eda:	8526                	mv	a0,s1
    80001edc:	00000097          	auipc	ra,0x0
    80001ee0:	ef0080e7          	jalr	-272(ra) # 80001dcc <freeproc>
    release(&p->lock);
    80001ee4:	8526                	mv	a0,s1
    80001ee6:	fffff097          	auipc	ra,0xfffff
    80001eea:	ea0080e7          	jalr	-352(ra) # 80000d86 <release>
    return 0;
    80001eee:	84ca                	mv	s1,s2
    80001ef0:	b7d1                	j	80001eb4 <allocproc+0x90>

0000000080001ef2 <userinit>:
{
    80001ef2:	1101                	addi	sp,sp,-32
    80001ef4:	ec06                	sd	ra,24(sp)
    80001ef6:	e822                	sd	s0,16(sp)
    80001ef8:	e426                	sd	s1,8(sp)
    80001efa:	1000                	addi	s0,sp,32
  p = allocproc();
    80001efc:	00000097          	auipc	ra,0x0
    80001f00:	f28080e7          	jalr	-216(ra) # 80001e24 <allocproc>
    80001f04:	84aa                	mv	s1,a0
  initproc = p;
    80001f06:	00007797          	auipc	a5,0x7
    80001f0a:	9ea7b923          	sd	a0,-1550(a5) # 800088f8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001f0e:	03400613          	li	a2,52
    80001f12:	00007597          	auipc	a1,0x7
    80001f16:	97e58593          	addi	a1,a1,-1666 # 80008890 <initcode>
    80001f1a:	6928                	ld	a0,80(a0)
    80001f1c:	fffff097          	auipc	ra,0xfffff
    80001f20:	55a080e7          	jalr	1370(ra) # 80001476 <uvmfirst>
  p->sz = PGSIZE;
    80001f24:	6785                	lui	a5,0x1
    80001f26:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001f28:	6cb8                	ld	a4,88(s1)
    80001f2a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001f2e:	6cb8                	ld	a4,88(s1)
    80001f30:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f32:	4641                	li	a2,16
    80001f34:	00006597          	auipc	a1,0x6
    80001f38:	30c58593          	addi	a1,a1,780 # 80008240 <digits+0x200>
    80001f3c:	15848513          	addi	a0,s1,344
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	fd8080e7          	jalr	-40(ra) # 80000f18 <safestrcpy>
  p->cwd = namei("/");
    80001f48:	00006517          	auipc	a0,0x6
    80001f4c:	30850513          	addi	a0,a0,776 # 80008250 <digits+0x210>
    80001f50:	00002097          	auipc	ra,0x2
    80001f54:	12e080e7          	jalr	302(ra) # 8000407e <namei>
    80001f58:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001f5c:	478d                	li	a5,3
    80001f5e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001f60:	8526                	mv	a0,s1
    80001f62:	fffff097          	auipc	ra,0xfffff
    80001f66:	e24080e7          	jalr	-476(ra) # 80000d86 <release>
}
    80001f6a:	60e2                	ld	ra,24(sp)
    80001f6c:	6442                	ld	s0,16(sp)
    80001f6e:	64a2                	ld	s1,8(sp)
    80001f70:	6105                	addi	sp,sp,32
    80001f72:	8082                	ret

0000000080001f74 <growproc>:
{
    80001f74:	1101                	addi	sp,sp,-32
    80001f76:	ec06                	sd	ra,24(sp)
    80001f78:	e822                	sd	s0,16(sp)
    80001f7a:	e426                	sd	s1,8(sp)
    80001f7c:	e04a                	sd	s2,0(sp)
    80001f7e:	1000                	addi	s0,sp,32
    80001f80:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001f82:	00000097          	auipc	ra,0x0
    80001f86:	c94080e7          	jalr	-876(ra) # 80001c16 <myproc>
    80001f8a:	84aa                	mv	s1,a0
  sz = p->sz;
    80001f8c:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001f8e:	01204c63          	bgtz	s2,80001fa6 <growproc+0x32>
  } else if(n < 0){
    80001f92:	02094663          	bltz	s2,80001fbe <growproc+0x4a>
  p->sz = sz;
    80001f96:	e4ac                	sd	a1,72(s1)
  return 0;
    80001f98:	4501                	li	a0,0
}
    80001f9a:	60e2                	ld	ra,24(sp)
    80001f9c:	6442                	ld	s0,16(sp)
    80001f9e:	64a2                	ld	s1,8(sp)
    80001fa0:	6902                	ld	s2,0(sp)
    80001fa2:	6105                	addi	sp,sp,32
    80001fa4:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001fa6:	4691                	li	a3,4
    80001fa8:	00b90633          	add	a2,s2,a1
    80001fac:	6928                	ld	a0,80(a0)
    80001fae:	fffff097          	auipc	ra,0xfffff
    80001fb2:	582080e7          	jalr	1410(ra) # 80001530 <uvmalloc>
    80001fb6:	85aa                	mv	a1,a0
    80001fb8:	fd79                	bnez	a0,80001f96 <growproc+0x22>
      return -1;
    80001fba:	557d                	li	a0,-1
    80001fbc:	bff9                	j	80001f9a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001fbe:	00b90633          	add	a2,s2,a1
    80001fc2:	6928                	ld	a0,80(a0)
    80001fc4:	fffff097          	auipc	ra,0xfffff
    80001fc8:	524080e7          	jalr	1316(ra) # 800014e8 <uvmdealloc>
    80001fcc:	85aa                	mv	a1,a0
    80001fce:	b7e1                	j	80001f96 <growproc+0x22>

0000000080001fd0 <fork>:
{
    80001fd0:	7139                	addi	sp,sp,-64
    80001fd2:	fc06                	sd	ra,56(sp)
    80001fd4:	f822                	sd	s0,48(sp)
    80001fd6:	f426                	sd	s1,40(sp)
    80001fd8:	f04a                	sd	s2,32(sp)
    80001fda:	ec4e                	sd	s3,24(sp)
    80001fdc:	e852                	sd	s4,16(sp)
    80001fde:	e456                	sd	s5,8(sp)
    80001fe0:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	c34080e7          	jalr	-972(ra) # 80001c16 <myproc>
    80001fea:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001fec:	00000097          	auipc	ra,0x0
    80001ff0:	e38080e7          	jalr	-456(ra) # 80001e24 <allocproc>
    80001ff4:	10050c63          	beqz	a0,8000210c <fork+0x13c>
    80001ff8:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001ffa:	048ab603          	ld	a2,72(s5)
    80001ffe:	692c                	ld	a1,80(a0)
    80002000:	050ab503          	ld	a0,80(s5)
    80002004:	fffff097          	auipc	ra,0xfffff
    80002008:	680080e7          	jalr	1664(ra) # 80001684 <uvmcopy>
    8000200c:	04054863          	bltz	a0,8000205c <fork+0x8c>
  np->sz = p->sz;
    80002010:	048ab783          	ld	a5,72(s5)
    80002014:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80002018:	058ab683          	ld	a3,88(s5)
    8000201c:	87b6                	mv	a5,a3
    8000201e:	058a3703          	ld	a4,88(s4)
    80002022:	12068693          	addi	a3,a3,288
    80002026:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000202a:	6788                	ld	a0,8(a5)
    8000202c:	6b8c                	ld	a1,16(a5)
    8000202e:	6f90                	ld	a2,24(a5)
    80002030:	01073023          	sd	a6,0(a4)
    80002034:	e708                	sd	a0,8(a4)
    80002036:	eb0c                	sd	a1,16(a4)
    80002038:	ef10                	sd	a2,24(a4)
    8000203a:	02078793          	addi	a5,a5,32
    8000203e:	02070713          	addi	a4,a4,32
    80002042:	fed792e3          	bne	a5,a3,80002026 <fork+0x56>
  np->trapframe->a0 = 0;
    80002046:	058a3783          	ld	a5,88(s4)
    8000204a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000204e:	0d0a8493          	addi	s1,s5,208
    80002052:	0d0a0913          	addi	s2,s4,208
    80002056:	150a8993          	addi	s3,s5,336
    8000205a:	a00d                	j	8000207c <fork+0xac>
    freeproc(np);
    8000205c:	8552                	mv	a0,s4
    8000205e:	00000097          	auipc	ra,0x0
    80002062:	d6e080e7          	jalr	-658(ra) # 80001dcc <freeproc>
    release(&np->lock);
    80002066:	8552                	mv	a0,s4
    80002068:	fffff097          	auipc	ra,0xfffff
    8000206c:	d1e080e7          	jalr	-738(ra) # 80000d86 <release>
    return -1;
    80002070:	597d                	li	s2,-1
    80002072:	a059                	j	800020f8 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80002074:	04a1                	addi	s1,s1,8
    80002076:	0921                	addi	s2,s2,8
    80002078:	01348b63          	beq	s1,s3,8000208e <fork+0xbe>
    if(p->ofile[i])
    8000207c:	6088                	ld	a0,0(s1)
    8000207e:	d97d                	beqz	a0,80002074 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80002080:	00002097          	auipc	ra,0x2
    80002084:	698080e7          	jalr	1688(ra) # 80004718 <filedup>
    80002088:	00a93023          	sd	a0,0(s2)
    8000208c:	b7e5                	j	80002074 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000208e:	150ab503          	ld	a0,336(s5)
    80002092:	00002097          	auipc	ra,0x2
    80002096:	808080e7          	jalr	-2040(ra) # 8000389a <idup>
    8000209a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000209e:	4641                	li	a2,16
    800020a0:	158a8593          	addi	a1,s5,344
    800020a4:	158a0513          	addi	a0,s4,344
    800020a8:	fffff097          	auipc	ra,0xfffff
    800020ac:	e70080e7          	jalr	-400(ra) # 80000f18 <safestrcpy>
  pid = np->pid;
    800020b0:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800020b4:	8552                	mv	a0,s4
    800020b6:	fffff097          	auipc	ra,0xfffff
    800020ba:	cd0080e7          	jalr	-816(ra) # 80000d86 <release>
  acquire(&wait_lock);
    800020be:	0022f497          	auipc	s1,0x22f
    800020c2:	aca48493          	addi	s1,s1,-1334 # 80230b88 <wait_lock>
    800020c6:	8526                	mv	a0,s1
    800020c8:	fffff097          	auipc	ra,0xfffff
    800020cc:	c0a080e7          	jalr	-1014(ra) # 80000cd2 <acquire>
  np->parent = p;
    800020d0:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800020d4:	8526                	mv	a0,s1
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	cb0080e7          	jalr	-848(ra) # 80000d86 <release>
  acquire(&np->lock);
    800020de:	8552                	mv	a0,s4
    800020e0:	fffff097          	auipc	ra,0xfffff
    800020e4:	bf2080e7          	jalr	-1038(ra) # 80000cd2 <acquire>
  np->state = RUNNABLE;
    800020e8:	478d                	li	a5,3
    800020ea:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800020ee:	8552                	mv	a0,s4
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	c96080e7          	jalr	-874(ra) # 80000d86 <release>
}
    800020f8:	854a                	mv	a0,s2
    800020fa:	70e2                	ld	ra,56(sp)
    800020fc:	7442                	ld	s0,48(sp)
    800020fe:	74a2                	ld	s1,40(sp)
    80002100:	7902                	ld	s2,32(sp)
    80002102:	69e2                	ld	s3,24(sp)
    80002104:	6a42                	ld	s4,16(sp)
    80002106:	6aa2                	ld	s5,8(sp)
    80002108:	6121                	addi	sp,sp,64
    8000210a:	8082                	ret
    return -1;
    8000210c:	597d                	li	s2,-1
    8000210e:	b7ed                	j	800020f8 <fork+0x128>

0000000080002110 <scheduler>:
{
    80002110:	7139                	addi	sp,sp,-64
    80002112:	fc06                	sd	ra,56(sp)
    80002114:	f822                	sd	s0,48(sp)
    80002116:	f426                	sd	s1,40(sp)
    80002118:	f04a                	sd	s2,32(sp)
    8000211a:	ec4e                	sd	s3,24(sp)
    8000211c:	e852                	sd	s4,16(sp)
    8000211e:	e456                	sd	s5,8(sp)
    80002120:	e05a                	sd	s6,0(sp)
    80002122:	0080                	addi	s0,sp,64
    80002124:	8792                	mv	a5,tp
  int id = r_tp();
    80002126:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002128:	00779a93          	slli	s5,a5,0x7
    8000212c:	0022f717          	auipc	a4,0x22f
    80002130:	a4470713          	addi	a4,a4,-1468 # 80230b70 <pid_lock>
    80002134:	9756                	add	a4,a4,s5
    80002136:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000213a:	0022f717          	auipc	a4,0x22f
    8000213e:	a6e70713          	addi	a4,a4,-1426 # 80230ba8 <cpus+0x8>
    80002142:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80002144:	498d                	li	s3,3
        p->state = RUNNING;
    80002146:	4b11                	li	s6,4
        c->proc = p;
    80002148:	079e                	slli	a5,a5,0x7
    8000214a:	0022fa17          	auipc	s4,0x22f
    8000214e:	a26a0a13          	addi	s4,s4,-1498 # 80230b70 <pid_lock>
    80002152:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002154:	00235917          	auipc	s2,0x235
    80002158:	84c90913          	addi	s2,s2,-1972 # 802369a0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000215c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002160:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002164:	10079073          	csrw	sstatus,a5
    80002168:	0022f497          	auipc	s1,0x22f
    8000216c:	e3848493          	addi	s1,s1,-456 # 80230fa0 <proc>
    80002170:	a811                	j	80002184 <scheduler+0x74>
      release(&p->lock);
    80002172:	8526                	mv	a0,s1
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	c12080e7          	jalr	-1006(ra) # 80000d86 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000217c:	16848493          	addi	s1,s1,360
    80002180:	fd248ee3          	beq	s1,s2,8000215c <scheduler+0x4c>
      acquire(&p->lock);
    80002184:	8526                	mv	a0,s1
    80002186:	fffff097          	auipc	ra,0xfffff
    8000218a:	b4c080e7          	jalr	-1204(ra) # 80000cd2 <acquire>
      if(p->state == RUNNABLE) {
    8000218e:	4c9c                	lw	a5,24(s1)
    80002190:	ff3791e3          	bne	a5,s3,80002172 <scheduler+0x62>
        p->state = RUNNING;
    80002194:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002198:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000219c:	06048593          	addi	a1,s1,96
    800021a0:	8556                	mv	a0,s5
    800021a2:	00000097          	auipc	ra,0x0
    800021a6:	684080e7          	jalr	1668(ra) # 80002826 <swtch>
        c->proc = 0;
    800021aa:	020a3823          	sd	zero,48(s4)
    800021ae:	b7d1                	j	80002172 <scheduler+0x62>

00000000800021b0 <sched>:
{
    800021b0:	7179                	addi	sp,sp,-48
    800021b2:	f406                	sd	ra,40(sp)
    800021b4:	f022                	sd	s0,32(sp)
    800021b6:	ec26                	sd	s1,24(sp)
    800021b8:	e84a                	sd	s2,16(sp)
    800021ba:	e44e                	sd	s3,8(sp)
    800021bc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800021be:	00000097          	auipc	ra,0x0
    800021c2:	a58080e7          	jalr	-1448(ra) # 80001c16 <myproc>
    800021c6:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	a90080e7          	jalr	-1392(ra) # 80000c58 <holding>
    800021d0:	c93d                	beqz	a0,80002246 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800021d2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800021d4:	2781                	sext.w	a5,a5
    800021d6:	079e                	slli	a5,a5,0x7
    800021d8:	0022f717          	auipc	a4,0x22f
    800021dc:	99870713          	addi	a4,a4,-1640 # 80230b70 <pid_lock>
    800021e0:	97ba                	add	a5,a5,a4
    800021e2:	0a87a703          	lw	a4,168(a5)
    800021e6:	4785                	li	a5,1
    800021e8:	06f71763          	bne	a4,a5,80002256 <sched+0xa6>
  if(p->state == RUNNING)
    800021ec:	4c98                	lw	a4,24(s1)
    800021ee:	4791                	li	a5,4
    800021f0:	06f70b63          	beq	a4,a5,80002266 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800021f4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800021f8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800021fa:	efb5                	bnez	a5,80002276 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800021fc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800021fe:	0022f917          	auipc	s2,0x22f
    80002202:	97290913          	addi	s2,s2,-1678 # 80230b70 <pid_lock>
    80002206:	2781                	sext.w	a5,a5
    80002208:	079e                	slli	a5,a5,0x7
    8000220a:	97ca                	add	a5,a5,s2
    8000220c:	0ac7a983          	lw	s3,172(a5)
    80002210:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002212:	2781                	sext.w	a5,a5
    80002214:	079e                	slli	a5,a5,0x7
    80002216:	0022f597          	auipc	a1,0x22f
    8000221a:	99258593          	addi	a1,a1,-1646 # 80230ba8 <cpus+0x8>
    8000221e:	95be                	add	a1,a1,a5
    80002220:	06048513          	addi	a0,s1,96
    80002224:	00000097          	auipc	ra,0x0
    80002228:	602080e7          	jalr	1538(ra) # 80002826 <swtch>
    8000222c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000222e:	2781                	sext.w	a5,a5
    80002230:	079e                	slli	a5,a5,0x7
    80002232:	97ca                	add	a5,a5,s2
    80002234:	0b37a623          	sw	s3,172(a5)
}
    80002238:	70a2                	ld	ra,40(sp)
    8000223a:	7402                	ld	s0,32(sp)
    8000223c:	64e2                	ld	s1,24(sp)
    8000223e:	6942                	ld	s2,16(sp)
    80002240:	69a2                	ld	s3,8(sp)
    80002242:	6145                	addi	sp,sp,48
    80002244:	8082                	ret
    panic("sched p->lock");
    80002246:	00006517          	auipc	a0,0x6
    8000224a:	01250513          	addi	a0,a0,18 # 80008258 <digits+0x218>
    8000224e:	ffffe097          	auipc	ra,0xffffe
    80002252:	2f0080e7          	jalr	752(ra) # 8000053e <panic>
    panic("sched locks");
    80002256:	00006517          	auipc	a0,0x6
    8000225a:	01250513          	addi	a0,a0,18 # 80008268 <digits+0x228>
    8000225e:	ffffe097          	auipc	ra,0xffffe
    80002262:	2e0080e7          	jalr	736(ra) # 8000053e <panic>
    panic("sched running");
    80002266:	00006517          	auipc	a0,0x6
    8000226a:	01250513          	addi	a0,a0,18 # 80008278 <digits+0x238>
    8000226e:	ffffe097          	auipc	ra,0xffffe
    80002272:	2d0080e7          	jalr	720(ra) # 8000053e <panic>
    panic("sched interruptible");
    80002276:	00006517          	auipc	a0,0x6
    8000227a:	01250513          	addi	a0,a0,18 # 80008288 <digits+0x248>
    8000227e:	ffffe097          	auipc	ra,0xffffe
    80002282:	2c0080e7          	jalr	704(ra) # 8000053e <panic>

0000000080002286 <yield>:
{
    80002286:	1101                	addi	sp,sp,-32
    80002288:	ec06                	sd	ra,24(sp)
    8000228a:	e822                	sd	s0,16(sp)
    8000228c:	e426                	sd	s1,8(sp)
    8000228e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002290:	00000097          	auipc	ra,0x0
    80002294:	986080e7          	jalr	-1658(ra) # 80001c16 <myproc>
    80002298:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000229a:	fffff097          	auipc	ra,0xfffff
    8000229e:	a38080e7          	jalr	-1480(ra) # 80000cd2 <acquire>
  p->state = RUNNABLE;
    800022a2:	478d                	li	a5,3
    800022a4:	cc9c                	sw	a5,24(s1)
  sched();
    800022a6:	00000097          	auipc	ra,0x0
    800022aa:	f0a080e7          	jalr	-246(ra) # 800021b0 <sched>
  release(&p->lock);
    800022ae:	8526                	mv	a0,s1
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	ad6080e7          	jalr	-1322(ra) # 80000d86 <release>
}
    800022b8:	60e2                	ld	ra,24(sp)
    800022ba:	6442                	ld	s0,16(sp)
    800022bc:	64a2                	ld	s1,8(sp)
    800022be:	6105                	addi	sp,sp,32
    800022c0:	8082                	ret

00000000800022c2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800022c2:	7179                	addi	sp,sp,-48
    800022c4:	f406                	sd	ra,40(sp)
    800022c6:	f022                	sd	s0,32(sp)
    800022c8:	ec26                	sd	s1,24(sp)
    800022ca:	e84a                	sd	s2,16(sp)
    800022cc:	e44e                	sd	s3,8(sp)
    800022ce:	1800                	addi	s0,sp,48
    800022d0:	89aa                	mv	s3,a0
    800022d2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800022d4:	00000097          	auipc	ra,0x0
    800022d8:	942080e7          	jalr	-1726(ra) # 80001c16 <myproc>
    800022dc:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800022de:	fffff097          	auipc	ra,0xfffff
    800022e2:	9f4080e7          	jalr	-1548(ra) # 80000cd2 <acquire>
  release(lk);
    800022e6:	854a                	mv	a0,s2
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	a9e080e7          	jalr	-1378(ra) # 80000d86 <release>

  // Go to sleep.
  p->chan = chan;
    800022f0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800022f4:	4789                	li	a5,2
    800022f6:	cc9c                	sw	a5,24(s1)

  sched();
    800022f8:	00000097          	auipc	ra,0x0
    800022fc:	eb8080e7          	jalr	-328(ra) # 800021b0 <sched>

  // Tidy up.
  p->chan = 0;
    80002300:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002304:	8526                	mv	a0,s1
    80002306:	fffff097          	auipc	ra,0xfffff
    8000230a:	a80080e7          	jalr	-1408(ra) # 80000d86 <release>
  acquire(lk);
    8000230e:	854a                	mv	a0,s2
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	9c2080e7          	jalr	-1598(ra) # 80000cd2 <acquire>
}
    80002318:	70a2                	ld	ra,40(sp)
    8000231a:	7402                	ld	s0,32(sp)
    8000231c:	64e2                	ld	s1,24(sp)
    8000231e:	6942                	ld	s2,16(sp)
    80002320:	69a2                	ld	s3,8(sp)
    80002322:	6145                	addi	sp,sp,48
    80002324:	8082                	ret

0000000080002326 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002326:	7139                	addi	sp,sp,-64
    80002328:	fc06                	sd	ra,56(sp)
    8000232a:	f822                	sd	s0,48(sp)
    8000232c:	f426                	sd	s1,40(sp)
    8000232e:	f04a                	sd	s2,32(sp)
    80002330:	ec4e                	sd	s3,24(sp)
    80002332:	e852                	sd	s4,16(sp)
    80002334:	e456                	sd	s5,8(sp)
    80002336:	0080                	addi	s0,sp,64
    80002338:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000233a:	0022f497          	auipc	s1,0x22f
    8000233e:	c6648493          	addi	s1,s1,-922 # 80230fa0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002342:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002344:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002346:	00234917          	auipc	s2,0x234
    8000234a:	65a90913          	addi	s2,s2,1626 # 802369a0 <tickslock>
    8000234e:	a811                	j	80002362 <wakeup+0x3c>
      }
      release(&p->lock);
    80002350:	8526                	mv	a0,s1
    80002352:	fffff097          	auipc	ra,0xfffff
    80002356:	a34080e7          	jalr	-1484(ra) # 80000d86 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000235a:	16848493          	addi	s1,s1,360
    8000235e:	03248663          	beq	s1,s2,8000238a <wakeup+0x64>
    if(p != myproc()){
    80002362:	00000097          	auipc	ra,0x0
    80002366:	8b4080e7          	jalr	-1868(ra) # 80001c16 <myproc>
    8000236a:	fea488e3          	beq	s1,a0,8000235a <wakeup+0x34>
      acquire(&p->lock);
    8000236e:	8526                	mv	a0,s1
    80002370:	fffff097          	auipc	ra,0xfffff
    80002374:	962080e7          	jalr	-1694(ra) # 80000cd2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002378:	4c9c                	lw	a5,24(s1)
    8000237a:	fd379be3          	bne	a5,s3,80002350 <wakeup+0x2a>
    8000237e:	709c                	ld	a5,32(s1)
    80002380:	fd4798e3          	bne	a5,s4,80002350 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002384:	0154ac23          	sw	s5,24(s1)
    80002388:	b7e1                	j	80002350 <wakeup+0x2a>
    }
  }
}
    8000238a:	70e2                	ld	ra,56(sp)
    8000238c:	7442                	ld	s0,48(sp)
    8000238e:	74a2                	ld	s1,40(sp)
    80002390:	7902                	ld	s2,32(sp)
    80002392:	69e2                	ld	s3,24(sp)
    80002394:	6a42                	ld	s4,16(sp)
    80002396:	6aa2                	ld	s5,8(sp)
    80002398:	6121                	addi	sp,sp,64
    8000239a:	8082                	ret

000000008000239c <reparent>:
{
    8000239c:	7179                	addi	sp,sp,-48
    8000239e:	f406                	sd	ra,40(sp)
    800023a0:	f022                	sd	s0,32(sp)
    800023a2:	ec26                	sd	s1,24(sp)
    800023a4:	e84a                	sd	s2,16(sp)
    800023a6:	e44e                	sd	s3,8(sp)
    800023a8:	e052                	sd	s4,0(sp)
    800023aa:	1800                	addi	s0,sp,48
    800023ac:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800023ae:	0022f497          	auipc	s1,0x22f
    800023b2:	bf248493          	addi	s1,s1,-1038 # 80230fa0 <proc>
      pp->parent = initproc;
    800023b6:	00006a17          	auipc	s4,0x6
    800023ba:	542a0a13          	addi	s4,s4,1346 # 800088f8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800023be:	00234997          	auipc	s3,0x234
    800023c2:	5e298993          	addi	s3,s3,1506 # 802369a0 <tickslock>
    800023c6:	a029                	j	800023d0 <reparent+0x34>
    800023c8:	16848493          	addi	s1,s1,360
    800023cc:	01348d63          	beq	s1,s3,800023e6 <reparent+0x4a>
    if(pp->parent == p){
    800023d0:	7c9c                	ld	a5,56(s1)
    800023d2:	ff279be3          	bne	a5,s2,800023c8 <reparent+0x2c>
      pp->parent = initproc;
    800023d6:	000a3503          	ld	a0,0(s4)
    800023da:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800023dc:	00000097          	auipc	ra,0x0
    800023e0:	f4a080e7          	jalr	-182(ra) # 80002326 <wakeup>
    800023e4:	b7d5                	j	800023c8 <reparent+0x2c>
}
    800023e6:	70a2                	ld	ra,40(sp)
    800023e8:	7402                	ld	s0,32(sp)
    800023ea:	64e2                	ld	s1,24(sp)
    800023ec:	6942                	ld	s2,16(sp)
    800023ee:	69a2                	ld	s3,8(sp)
    800023f0:	6a02                	ld	s4,0(sp)
    800023f2:	6145                	addi	sp,sp,48
    800023f4:	8082                	ret

00000000800023f6 <exit>:
{
    800023f6:	7179                	addi	sp,sp,-48
    800023f8:	f406                	sd	ra,40(sp)
    800023fa:	f022                	sd	s0,32(sp)
    800023fc:	ec26                	sd	s1,24(sp)
    800023fe:	e84a                	sd	s2,16(sp)
    80002400:	e44e                	sd	s3,8(sp)
    80002402:	e052                	sd	s4,0(sp)
    80002404:	1800                	addi	s0,sp,48
    80002406:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002408:	00000097          	auipc	ra,0x0
    8000240c:	80e080e7          	jalr	-2034(ra) # 80001c16 <myproc>
    80002410:	89aa                	mv	s3,a0
  if(p == initproc)
    80002412:	00006797          	auipc	a5,0x6
    80002416:	4e67b783          	ld	a5,1254(a5) # 800088f8 <initproc>
    8000241a:	0d050493          	addi	s1,a0,208
    8000241e:	15050913          	addi	s2,a0,336
    80002422:	02a79363          	bne	a5,a0,80002448 <exit+0x52>
    panic("init exiting");
    80002426:	00006517          	auipc	a0,0x6
    8000242a:	e7a50513          	addi	a0,a0,-390 # 800082a0 <digits+0x260>
    8000242e:	ffffe097          	auipc	ra,0xffffe
    80002432:	110080e7          	jalr	272(ra) # 8000053e <panic>
      fileclose(f);
    80002436:	00002097          	auipc	ra,0x2
    8000243a:	334080e7          	jalr	820(ra) # 8000476a <fileclose>
      p->ofile[fd] = 0;
    8000243e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002442:	04a1                	addi	s1,s1,8
    80002444:	01248563          	beq	s1,s2,8000244e <exit+0x58>
    if(p->ofile[fd]){
    80002448:	6088                	ld	a0,0(s1)
    8000244a:	f575                	bnez	a0,80002436 <exit+0x40>
    8000244c:	bfdd                	j	80002442 <exit+0x4c>
  begin_op();
    8000244e:	00002097          	auipc	ra,0x2
    80002452:	e50080e7          	jalr	-432(ra) # 8000429e <begin_op>
  iput(p->cwd);
    80002456:	1509b503          	ld	a0,336(s3)
    8000245a:	00001097          	auipc	ra,0x1
    8000245e:	638080e7          	jalr	1592(ra) # 80003a92 <iput>
  end_op();
    80002462:	00002097          	auipc	ra,0x2
    80002466:	ebc080e7          	jalr	-324(ra) # 8000431e <end_op>
  p->cwd = 0;
    8000246a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000246e:	0022e497          	auipc	s1,0x22e
    80002472:	71a48493          	addi	s1,s1,1818 # 80230b88 <wait_lock>
    80002476:	8526                	mv	a0,s1
    80002478:	fffff097          	auipc	ra,0xfffff
    8000247c:	85a080e7          	jalr	-1958(ra) # 80000cd2 <acquire>
  reparent(p);
    80002480:	854e                	mv	a0,s3
    80002482:	00000097          	auipc	ra,0x0
    80002486:	f1a080e7          	jalr	-230(ra) # 8000239c <reparent>
  wakeup(p->parent);
    8000248a:	0389b503          	ld	a0,56(s3)
    8000248e:	00000097          	auipc	ra,0x0
    80002492:	e98080e7          	jalr	-360(ra) # 80002326 <wakeup>
  acquire(&p->lock);
    80002496:	854e                	mv	a0,s3
    80002498:	fffff097          	auipc	ra,0xfffff
    8000249c:	83a080e7          	jalr	-1990(ra) # 80000cd2 <acquire>
  p->xstate = status;
    800024a0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800024a4:	4795                	li	a5,5
    800024a6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800024aa:	8526                	mv	a0,s1
    800024ac:	fffff097          	auipc	ra,0xfffff
    800024b0:	8da080e7          	jalr	-1830(ra) # 80000d86 <release>
  sched();
    800024b4:	00000097          	auipc	ra,0x0
    800024b8:	cfc080e7          	jalr	-772(ra) # 800021b0 <sched>
  panic("zombie exit");
    800024bc:	00006517          	auipc	a0,0x6
    800024c0:	df450513          	addi	a0,a0,-524 # 800082b0 <digits+0x270>
    800024c4:	ffffe097          	auipc	ra,0xffffe
    800024c8:	07a080e7          	jalr	122(ra) # 8000053e <panic>

00000000800024cc <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800024cc:	7179                	addi	sp,sp,-48
    800024ce:	f406                	sd	ra,40(sp)
    800024d0:	f022                	sd	s0,32(sp)
    800024d2:	ec26                	sd	s1,24(sp)
    800024d4:	e84a                	sd	s2,16(sp)
    800024d6:	e44e                	sd	s3,8(sp)
    800024d8:	1800                	addi	s0,sp,48
    800024da:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800024dc:	0022f497          	auipc	s1,0x22f
    800024e0:	ac448493          	addi	s1,s1,-1340 # 80230fa0 <proc>
    800024e4:	00234997          	auipc	s3,0x234
    800024e8:	4bc98993          	addi	s3,s3,1212 # 802369a0 <tickslock>
    acquire(&p->lock);
    800024ec:	8526                	mv	a0,s1
    800024ee:	ffffe097          	auipc	ra,0xffffe
    800024f2:	7e4080e7          	jalr	2020(ra) # 80000cd2 <acquire>
    if(p->pid == pid){
    800024f6:	589c                	lw	a5,48(s1)
    800024f8:	01278d63          	beq	a5,s2,80002512 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800024fc:	8526                	mv	a0,s1
    800024fe:	fffff097          	auipc	ra,0xfffff
    80002502:	888080e7          	jalr	-1912(ra) # 80000d86 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002506:	16848493          	addi	s1,s1,360
    8000250a:	ff3491e3          	bne	s1,s3,800024ec <kill+0x20>
  }
  return -1;
    8000250e:	557d                	li	a0,-1
    80002510:	a829                	j	8000252a <kill+0x5e>
      p->killed = 1;
    80002512:	4785                	li	a5,1
    80002514:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002516:	4c98                	lw	a4,24(s1)
    80002518:	4789                	li	a5,2
    8000251a:	00f70f63          	beq	a4,a5,80002538 <kill+0x6c>
      release(&p->lock);
    8000251e:	8526                	mv	a0,s1
    80002520:	fffff097          	auipc	ra,0xfffff
    80002524:	866080e7          	jalr	-1946(ra) # 80000d86 <release>
      return 0;
    80002528:	4501                	li	a0,0
}
    8000252a:	70a2                	ld	ra,40(sp)
    8000252c:	7402                	ld	s0,32(sp)
    8000252e:	64e2                	ld	s1,24(sp)
    80002530:	6942                	ld	s2,16(sp)
    80002532:	69a2                	ld	s3,8(sp)
    80002534:	6145                	addi	sp,sp,48
    80002536:	8082                	ret
        p->state = RUNNABLE;
    80002538:	478d                	li	a5,3
    8000253a:	cc9c                	sw	a5,24(s1)
    8000253c:	b7cd                	j	8000251e <kill+0x52>

000000008000253e <setkilled>:

void
setkilled(struct proc *p)
{
    8000253e:	1101                	addi	sp,sp,-32
    80002540:	ec06                	sd	ra,24(sp)
    80002542:	e822                	sd	s0,16(sp)
    80002544:	e426                	sd	s1,8(sp)
    80002546:	1000                	addi	s0,sp,32
    80002548:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000254a:	ffffe097          	auipc	ra,0xffffe
    8000254e:	788080e7          	jalr	1928(ra) # 80000cd2 <acquire>
  p->killed = 1;
    80002552:	4785                	li	a5,1
    80002554:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002556:	8526                	mv	a0,s1
    80002558:	fffff097          	auipc	ra,0xfffff
    8000255c:	82e080e7          	jalr	-2002(ra) # 80000d86 <release>
}
    80002560:	60e2                	ld	ra,24(sp)
    80002562:	6442                	ld	s0,16(sp)
    80002564:	64a2                	ld	s1,8(sp)
    80002566:	6105                	addi	sp,sp,32
    80002568:	8082                	ret

000000008000256a <killed>:

int
killed(struct proc *p)
{
    8000256a:	1101                	addi	sp,sp,-32
    8000256c:	ec06                	sd	ra,24(sp)
    8000256e:	e822                	sd	s0,16(sp)
    80002570:	e426                	sd	s1,8(sp)
    80002572:	e04a                	sd	s2,0(sp)
    80002574:	1000                	addi	s0,sp,32
    80002576:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002578:	ffffe097          	auipc	ra,0xffffe
    8000257c:	75a080e7          	jalr	1882(ra) # 80000cd2 <acquire>
  k = p->killed;
    80002580:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002584:	8526                	mv	a0,s1
    80002586:	fffff097          	auipc	ra,0xfffff
    8000258a:	800080e7          	jalr	-2048(ra) # 80000d86 <release>
  return k;
}
    8000258e:	854a                	mv	a0,s2
    80002590:	60e2                	ld	ra,24(sp)
    80002592:	6442                	ld	s0,16(sp)
    80002594:	64a2                	ld	s1,8(sp)
    80002596:	6902                	ld	s2,0(sp)
    80002598:	6105                	addi	sp,sp,32
    8000259a:	8082                	ret

000000008000259c <wait>:
{
    8000259c:	715d                	addi	sp,sp,-80
    8000259e:	e486                	sd	ra,72(sp)
    800025a0:	e0a2                	sd	s0,64(sp)
    800025a2:	fc26                	sd	s1,56(sp)
    800025a4:	f84a                	sd	s2,48(sp)
    800025a6:	f44e                	sd	s3,40(sp)
    800025a8:	f052                	sd	s4,32(sp)
    800025aa:	ec56                	sd	s5,24(sp)
    800025ac:	e85a                	sd	s6,16(sp)
    800025ae:	e45e                	sd	s7,8(sp)
    800025b0:	e062                	sd	s8,0(sp)
    800025b2:	0880                	addi	s0,sp,80
    800025b4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800025b6:	fffff097          	auipc	ra,0xfffff
    800025ba:	660080e7          	jalr	1632(ra) # 80001c16 <myproc>
    800025be:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800025c0:	0022e517          	auipc	a0,0x22e
    800025c4:	5c850513          	addi	a0,a0,1480 # 80230b88 <wait_lock>
    800025c8:	ffffe097          	auipc	ra,0xffffe
    800025cc:	70a080e7          	jalr	1802(ra) # 80000cd2 <acquire>
    havekids = 0;
    800025d0:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800025d2:	4a15                	li	s4,5
        havekids = 1;
    800025d4:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800025d6:	00234997          	auipc	s3,0x234
    800025da:	3ca98993          	addi	s3,s3,970 # 802369a0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800025de:	0022ec17          	auipc	s8,0x22e
    800025e2:	5aac0c13          	addi	s8,s8,1450 # 80230b88 <wait_lock>
    havekids = 0;
    800025e6:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800025e8:	0022f497          	auipc	s1,0x22f
    800025ec:	9b848493          	addi	s1,s1,-1608 # 80230fa0 <proc>
    800025f0:	a0bd                	j	8000265e <wait+0xc2>
          pid = pp->pid;
    800025f2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800025f6:	000b0e63          	beqz	s6,80002612 <wait+0x76>
    800025fa:	4691                	li	a3,4
    800025fc:	02c48613          	addi	a2,s1,44
    80002600:	85da                	mv	a1,s6
    80002602:	05093503          	ld	a0,80(s2)
    80002606:	fffff097          	auipc	ra,0xfffff
    8000260a:	262080e7          	jalr	610(ra) # 80001868 <copyout>
    8000260e:	02054563          	bltz	a0,80002638 <wait+0x9c>
          freeproc(pp);
    80002612:	8526                	mv	a0,s1
    80002614:	fffff097          	auipc	ra,0xfffff
    80002618:	7b8080e7          	jalr	1976(ra) # 80001dcc <freeproc>
          release(&pp->lock);
    8000261c:	8526                	mv	a0,s1
    8000261e:	ffffe097          	auipc	ra,0xffffe
    80002622:	768080e7          	jalr	1896(ra) # 80000d86 <release>
          release(&wait_lock);
    80002626:	0022e517          	auipc	a0,0x22e
    8000262a:	56250513          	addi	a0,a0,1378 # 80230b88 <wait_lock>
    8000262e:	ffffe097          	auipc	ra,0xffffe
    80002632:	758080e7          	jalr	1880(ra) # 80000d86 <release>
          return pid;
    80002636:	a0b5                	j	800026a2 <wait+0x106>
            release(&pp->lock);
    80002638:	8526                	mv	a0,s1
    8000263a:	ffffe097          	auipc	ra,0xffffe
    8000263e:	74c080e7          	jalr	1868(ra) # 80000d86 <release>
            release(&wait_lock);
    80002642:	0022e517          	auipc	a0,0x22e
    80002646:	54650513          	addi	a0,a0,1350 # 80230b88 <wait_lock>
    8000264a:	ffffe097          	auipc	ra,0xffffe
    8000264e:	73c080e7          	jalr	1852(ra) # 80000d86 <release>
            return -1;
    80002652:	59fd                	li	s3,-1
    80002654:	a0b9                	j	800026a2 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002656:	16848493          	addi	s1,s1,360
    8000265a:	03348463          	beq	s1,s3,80002682 <wait+0xe6>
      if(pp->parent == p){
    8000265e:	7c9c                	ld	a5,56(s1)
    80002660:	ff279be3          	bne	a5,s2,80002656 <wait+0xba>
        acquire(&pp->lock);
    80002664:	8526                	mv	a0,s1
    80002666:	ffffe097          	auipc	ra,0xffffe
    8000266a:	66c080e7          	jalr	1644(ra) # 80000cd2 <acquire>
        if(pp->state == ZOMBIE){
    8000266e:	4c9c                	lw	a5,24(s1)
    80002670:	f94781e3          	beq	a5,s4,800025f2 <wait+0x56>
        release(&pp->lock);
    80002674:	8526                	mv	a0,s1
    80002676:	ffffe097          	auipc	ra,0xffffe
    8000267a:	710080e7          	jalr	1808(ra) # 80000d86 <release>
        havekids = 1;
    8000267e:	8756                	mv	a4,s5
    80002680:	bfd9                	j	80002656 <wait+0xba>
    if(!havekids || killed(p)){
    80002682:	c719                	beqz	a4,80002690 <wait+0xf4>
    80002684:	854a                	mv	a0,s2
    80002686:	00000097          	auipc	ra,0x0
    8000268a:	ee4080e7          	jalr	-284(ra) # 8000256a <killed>
    8000268e:	c51d                	beqz	a0,800026bc <wait+0x120>
      release(&wait_lock);
    80002690:	0022e517          	auipc	a0,0x22e
    80002694:	4f850513          	addi	a0,a0,1272 # 80230b88 <wait_lock>
    80002698:	ffffe097          	auipc	ra,0xffffe
    8000269c:	6ee080e7          	jalr	1774(ra) # 80000d86 <release>
      return -1;
    800026a0:	59fd                	li	s3,-1
}
    800026a2:	854e                	mv	a0,s3
    800026a4:	60a6                	ld	ra,72(sp)
    800026a6:	6406                	ld	s0,64(sp)
    800026a8:	74e2                	ld	s1,56(sp)
    800026aa:	7942                	ld	s2,48(sp)
    800026ac:	79a2                	ld	s3,40(sp)
    800026ae:	7a02                	ld	s4,32(sp)
    800026b0:	6ae2                	ld	s5,24(sp)
    800026b2:	6b42                	ld	s6,16(sp)
    800026b4:	6ba2                	ld	s7,8(sp)
    800026b6:	6c02                	ld	s8,0(sp)
    800026b8:	6161                	addi	sp,sp,80
    800026ba:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800026bc:	85e2                	mv	a1,s8
    800026be:	854a                	mv	a0,s2
    800026c0:	00000097          	auipc	ra,0x0
    800026c4:	c02080e7          	jalr	-1022(ra) # 800022c2 <sleep>
    havekids = 0;
    800026c8:	bf39                	j	800025e6 <wait+0x4a>

00000000800026ca <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800026ca:	7179                	addi	sp,sp,-48
    800026cc:	f406                	sd	ra,40(sp)
    800026ce:	f022                	sd	s0,32(sp)
    800026d0:	ec26                	sd	s1,24(sp)
    800026d2:	e84a                	sd	s2,16(sp)
    800026d4:	e44e                	sd	s3,8(sp)
    800026d6:	e052                	sd	s4,0(sp)
    800026d8:	1800                	addi	s0,sp,48
    800026da:	84aa                	mv	s1,a0
    800026dc:	892e                	mv	s2,a1
    800026de:	89b2                	mv	s3,a2
    800026e0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800026e2:	fffff097          	auipc	ra,0xfffff
    800026e6:	534080e7          	jalr	1332(ra) # 80001c16 <myproc>
  if(user_dst){
    800026ea:	c08d                	beqz	s1,8000270c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800026ec:	86d2                	mv	a3,s4
    800026ee:	864e                	mv	a2,s3
    800026f0:	85ca                	mv	a1,s2
    800026f2:	6928                	ld	a0,80(a0)
    800026f4:	fffff097          	auipc	ra,0xfffff
    800026f8:	174080e7          	jalr	372(ra) # 80001868 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800026fc:	70a2                	ld	ra,40(sp)
    800026fe:	7402                	ld	s0,32(sp)
    80002700:	64e2                	ld	s1,24(sp)
    80002702:	6942                	ld	s2,16(sp)
    80002704:	69a2                	ld	s3,8(sp)
    80002706:	6a02                	ld	s4,0(sp)
    80002708:	6145                	addi	sp,sp,48
    8000270a:	8082                	ret
    memmove((char *)dst, src, len);
    8000270c:	000a061b          	sext.w	a2,s4
    80002710:	85ce                	mv	a1,s3
    80002712:	854a                	mv	a0,s2
    80002714:	ffffe097          	auipc	ra,0xffffe
    80002718:	716080e7          	jalr	1814(ra) # 80000e2a <memmove>
    return 0;
    8000271c:	8526                	mv	a0,s1
    8000271e:	bff9                	j	800026fc <either_copyout+0x32>

0000000080002720 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002720:	7179                	addi	sp,sp,-48
    80002722:	f406                	sd	ra,40(sp)
    80002724:	f022                	sd	s0,32(sp)
    80002726:	ec26                	sd	s1,24(sp)
    80002728:	e84a                	sd	s2,16(sp)
    8000272a:	e44e                	sd	s3,8(sp)
    8000272c:	e052                	sd	s4,0(sp)
    8000272e:	1800                	addi	s0,sp,48
    80002730:	892a                	mv	s2,a0
    80002732:	84ae                	mv	s1,a1
    80002734:	89b2                	mv	s3,a2
    80002736:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002738:	fffff097          	auipc	ra,0xfffff
    8000273c:	4de080e7          	jalr	1246(ra) # 80001c16 <myproc>
  if(user_src){
    80002740:	c08d                	beqz	s1,80002762 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002742:	86d2                	mv	a3,s4
    80002744:	864e                	mv	a2,s3
    80002746:	85ca                	mv	a1,s2
    80002748:	6928                	ld	a0,80(a0)
    8000274a:	fffff097          	auipc	ra,0xfffff
    8000274e:	214080e7          	jalr	532(ra) # 8000195e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002752:	70a2                	ld	ra,40(sp)
    80002754:	7402                	ld	s0,32(sp)
    80002756:	64e2                	ld	s1,24(sp)
    80002758:	6942                	ld	s2,16(sp)
    8000275a:	69a2                	ld	s3,8(sp)
    8000275c:	6a02                	ld	s4,0(sp)
    8000275e:	6145                	addi	sp,sp,48
    80002760:	8082                	ret
    memmove(dst, (char*)src, len);
    80002762:	000a061b          	sext.w	a2,s4
    80002766:	85ce                	mv	a1,s3
    80002768:	854a                	mv	a0,s2
    8000276a:	ffffe097          	auipc	ra,0xffffe
    8000276e:	6c0080e7          	jalr	1728(ra) # 80000e2a <memmove>
    return 0;
    80002772:	8526                	mv	a0,s1
    80002774:	bff9                	j	80002752 <either_copyin+0x32>

0000000080002776 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002776:	715d                	addi	sp,sp,-80
    80002778:	e486                	sd	ra,72(sp)
    8000277a:	e0a2                	sd	s0,64(sp)
    8000277c:	fc26                	sd	s1,56(sp)
    8000277e:	f84a                	sd	s2,48(sp)
    80002780:	f44e                	sd	s3,40(sp)
    80002782:	f052                	sd	s4,32(sp)
    80002784:	ec56                	sd	s5,24(sp)
    80002786:	e85a                	sd	s6,16(sp)
    80002788:	e45e                	sd	s7,8(sp)
    8000278a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000278c:	00006517          	auipc	a0,0x6
    80002790:	93c50513          	addi	a0,a0,-1732 # 800080c8 <digits+0x88>
    80002794:	ffffe097          	auipc	ra,0xffffe
    80002798:	df4080e7          	jalr	-524(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000279c:	0022f497          	auipc	s1,0x22f
    800027a0:	95c48493          	addi	s1,s1,-1700 # 802310f8 <proc+0x158>
    800027a4:	00234917          	auipc	s2,0x234
    800027a8:	35490913          	addi	s2,s2,852 # 80236af8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027ac:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800027ae:	00006997          	auipc	s3,0x6
    800027b2:	b1298993          	addi	s3,s3,-1262 # 800082c0 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    800027b6:	00006a97          	auipc	s5,0x6
    800027ba:	b12a8a93          	addi	s5,s5,-1262 # 800082c8 <digits+0x288>
    printf("\n");
    800027be:	00006a17          	auipc	s4,0x6
    800027c2:	90aa0a13          	addi	s4,s4,-1782 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027c6:	00006b97          	auipc	s7,0x6
    800027ca:	b42b8b93          	addi	s7,s7,-1214 # 80008308 <states.0>
    800027ce:	a00d                	j	800027f0 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800027d0:	ed86a583          	lw	a1,-296(a3)
    800027d4:	8556                	mv	a0,s5
    800027d6:	ffffe097          	auipc	ra,0xffffe
    800027da:	db2080e7          	jalr	-590(ra) # 80000588 <printf>
    printf("\n");
    800027de:	8552                	mv	a0,s4
    800027e0:	ffffe097          	auipc	ra,0xffffe
    800027e4:	da8080e7          	jalr	-600(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800027e8:	16848493          	addi	s1,s1,360
    800027ec:	03248263          	beq	s1,s2,80002810 <procdump+0x9a>
    if(p->state == UNUSED)
    800027f0:	86a6                	mv	a3,s1
    800027f2:	ec04a783          	lw	a5,-320(s1)
    800027f6:	dbed                	beqz	a5,800027e8 <procdump+0x72>
      state = "???";
    800027f8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027fa:	fcfb6be3          	bltu	s6,a5,800027d0 <procdump+0x5a>
    800027fe:	02079713          	slli	a4,a5,0x20
    80002802:	01d75793          	srli	a5,a4,0x1d
    80002806:	97de                	add	a5,a5,s7
    80002808:	6390                	ld	a2,0(a5)
    8000280a:	f279                	bnez	a2,800027d0 <procdump+0x5a>
      state = "???";
    8000280c:	864e                	mv	a2,s3
    8000280e:	b7c9                	j	800027d0 <procdump+0x5a>
  }
}
    80002810:	60a6                	ld	ra,72(sp)
    80002812:	6406                	ld	s0,64(sp)
    80002814:	74e2                	ld	s1,56(sp)
    80002816:	7942                	ld	s2,48(sp)
    80002818:	79a2                	ld	s3,40(sp)
    8000281a:	7a02                	ld	s4,32(sp)
    8000281c:	6ae2                	ld	s5,24(sp)
    8000281e:	6b42                	ld	s6,16(sp)
    80002820:	6ba2                	ld	s7,8(sp)
    80002822:	6161                	addi	sp,sp,80
    80002824:	8082                	ret

0000000080002826 <swtch>:
    80002826:	00153023          	sd	ra,0(a0)
    8000282a:	00253423          	sd	sp,8(a0)
    8000282e:	e900                	sd	s0,16(a0)
    80002830:	ed04                	sd	s1,24(a0)
    80002832:	03253023          	sd	s2,32(a0)
    80002836:	03353423          	sd	s3,40(a0)
    8000283a:	03453823          	sd	s4,48(a0)
    8000283e:	03553c23          	sd	s5,56(a0)
    80002842:	05653023          	sd	s6,64(a0)
    80002846:	05753423          	sd	s7,72(a0)
    8000284a:	05853823          	sd	s8,80(a0)
    8000284e:	05953c23          	sd	s9,88(a0)
    80002852:	07a53023          	sd	s10,96(a0)
    80002856:	07b53423          	sd	s11,104(a0)
    8000285a:	0005b083          	ld	ra,0(a1)
    8000285e:	0085b103          	ld	sp,8(a1)
    80002862:	6980                	ld	s0,16(a1)
    80002864:	6d84                	ld	s1,24(a1)
    80002866:	0205b903          	ld	s2,32(a1)
    8000286a:	0285b983          	ld	s3,40(a1)
    8000286e:	0305ba03          	ld	s4,48(a1)
    80002872:	0385ba83          	ld	s5,56(a1)
    80002876:	0405bb03          	ld	s6,64(a1)
    8000287a:	0485bb83          	ld	s7,72(a1)
    8000287e:	0505bc03          	ld	s8,80(a1)
    80002882:	0585bc83          	ld	s9,88(a1)
    80002886:	0605bd03          	ld	s10,96(a1)
    8000288a:	0685bd83          	ld	s11,104(a1)
    8000288e:	8082                	ret

0000000080002890 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002890:	1141                	addi	sp,sp,-16
    80002892:	e406                	sd	ra,8(sp)
    80002894:	e022                	sd	s0,0(sp)
    80002896:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002898:	00006597          	auipc	a1,0x6
    8000289c:	aa058593          	addi	a1,a1,-1376 # 80008338 <states.0+0x30>
    800028a0:	00234517          	auipc	a0,0x234
    800028a4:	10050513          	addi	a0,a0,256 # 802369a0 <tickslock>
    800028a8:	ffffe097          	auipc	ra,0xffffe
    800028ac:	39a080e7          	jalr	922(ra) # 80000c42 <initlock>
}
    800028b0:	60a2                	ld	ra,8(sp)
    800028b2:	6402                	ld	s0,0(sp)
    800028b4:	0141                	addi	sp,sp,16
    800028b6:	8082                	ret

00000000800028b8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800028b8:	1141                	addi	sp,sp,-16
    800028ba:	e422                	sd	s0,8(sp)
    800028bc:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028be:	00003797          	auipc	a5,0x3
    800028c2:	50278793          	addi	a5,a5,1282 # 80005dc0 <kernelvec>
    800028c6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800028ca:	6422                	ld	s0,8(sp)
    800028cc:	0141                	addi	sp,sp,16
    800028ce:	8082                	ret

00000000800028d0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800028d0:	1141                	addi	sp,sp,-16
    800028d2:	e406                	sd	ra,8(sp)
    800028d4:	e022                	sd	s0,0(sp)
    800028d6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800028d8:	fffff097          	auipc	ra,0xfffff
    800028dc:	33e080e7          	jalr	830(ra) # 80001c16 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028e0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800028e4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028e6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800028ea:	00004617          	auipc	a2,0x4
    800028ee:	71660613          	addi	a2,a2,1814 # 80007000 <_trampoline>
    800028f2:	00004697          	auipc	a3,0x4
    800028f6:	70e68693          	addi	a3,a3,1806 # 80007000 <_trampoline>
    800028fa:	8e91                	sub	a3,a3,a2
    800028fc:	040007b7          	lui	a5,0x4000
    80002900:	17fd                	addi	a5,a5,-1
    80002902:	07b2                	slli	a5,a5,0xc
    80002904:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002906:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000290a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000290c:	180026f3          	csrr	a3,satp
    80002910:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002912:	6d38                	ld	a4,88(a0)
    80002914:	6134                	ld	a3,64(a0)
    80002916:	6585                	lui	a1,0x1
    80002918:	96ae                	add	a3,a3,a1
    8000291a:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000291c:	6d38                	ld	a4,88(a0)
    8000291e:	00000697          	auipc	a3,0x0
    80002922:	13068693          	addi	a3,a3,304 # 80002a4e <usertrap>
    80002926:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002928:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000292a:	8692                	mv	a3,tp
    8000292c:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000292e:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002932:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002936:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000293a:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000293e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002940:	6f18                	ld	a4,24(a4)
    80002942:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002946:	6928                	ld	a0,80(a0)
    80002948:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000294a:	00004717          	auipc	a4,0x4
    8000294e:	75270713          	addi	a4,a4,1874 # 8000709c <userret>
    80002952:	8f11                	sub	a4,a4,a2
    80002954:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002956:	577d                	li	a4,-1
    80002958:	177e                	slli	a4,a4,0x3f
    8000295a:	8d59                	or	a0,a0,a4
    8000295c:	9782                	jalr	a5
}
    8000295e:	60a2                	ld	ra,8(sp)
    80002960:	6402                	ld	s0,0(sp)
    80002962:	0141                	addi	sp,sp,16
    80002964:	8082                	ret

0000000080002966 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002966:	1101                	addi	sp,sp,-32
    80002968:	ec06                	sd	ra,24(sp)
    8000296a:	e822                	sd	s0,16(sp)
    8000296c:	e426                	sd	s1,8(sp)
    8000296e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002970:	00234497          	auipc	s1,0x234
    80002974:	03048493          	addi	s1,s1,48 # 802369a0 <tickslock>
    80002978:	8526                	mv	a0,s1
    8000297a:	ffffe097          	auipc	ra,0xffffe
    8000297e:	358080e7          	jalr	856(ra) # 80000cd2 <acquire>
  ticks++;
    80002982:	00006517          	auipc	a0,0x6
    80002986:	f7e50513          	addi	a0,a0,-130 # 80008900 <ticks>
    8000298a:	411c                	lw	a5,0(a0)
    8000298c:	2785                	addiw	a5,a5,1
    8000298e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002990:	00000097          	auipc	ra,0x0
    80002994:	996080e7          	jalr	-1642(ra) # 80002326 <wakeup>
  release(&tickslock);
    80002998:	8526                	mv	a0,s1
    8000299a:	ffffe097          	auipc	ra,0xffffe
    8000299e:	3ec080e7          	jalr	1004(ra) # 80000d86 <release>
}
    800029a2:	60e2                	ld	ra,24(sp)
    800029a4:	6442                	ld	s0,16(sp)
    800029a6:	64a2                	ld	s1,8(sp)
    800029a8:	6105                	addi	sp,sp,32
    800029aa:	8082                	ret

00000000800029ac <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800029ac:	1101                	addi	sp,sp,-32
    800029ae:	ec06                	sd	ra,24(sp)
    800029b0:	e822                	sd	s0,16(sp)
    800029b2:	e426                	sd	s1,8(sp)
    800029b4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029b6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800029ba:	00074d63          	bltz	a4,800029d4 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800029be:	57fd                	li	a5,-1
    800029c0:	17fe                	slli	a5,a5,0x3f
    800029c2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800029c4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800029c6:	06f70363          	beq	a4,a5,80002a2c <devintr+0x80>
  }
}
    800029ca:	60e2                	ld	ra,24(sp)
    800029cc:	6442                	ld	s0,16(sp)
    800029ce:	64a2                	ld	s1,8(sp)
    800029d0:	6105                	addi	sp,sp,32
    800029d2:	8082                	ret
     (scause & 0xff) == 9){
    800029d4:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    800029d8:	46a5                	li	a3,9
    800029da:	fed792e3          	bne	a5,a3,800029be <devintr+0x12>
    int irq = plic_claim();
    800029de:	00003097          	auipc	ra,0x3
    800029e2:	4ba080e7          	jalr	1210(ra) # 80005e98 <plic_claim>
    800029e6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800029e8:	47a9                	li	a5,10
    800029ea:	02f50763          	beq	a0,a5,80002a18 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    800029ee:	4785                	li	a5,1
    800029f0:	02f50963          	beq	a0,a5,80002a22 <devintr+0x76>
    return 1;
    800029f4:	4505                	li	a0,1
    } else if(irq){
    800029f6:	d8f1                	beqz	s1,800029ca <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    800029f8:	85a6                	mv	a1,s1
    800029fa:	00006517          	auipc	a0,0x6
    800029fe:	94650513          	addi	a0,a0,-1722 # 80008340 <states.0+0x38>
    80002a02:	ffffe097          	auipc	ra,0xffffe
    80002a06:	b86080e7          	jalr	-1146(ra) # 80000588 <printf>
      plic_complete(irq);
    80002a0a:	8526                	mv	a0,s1
    80002a0c:	00003097          	auipc	ra,0x3
    80002a10:	4b0080e7          	jalr	1200(ra) # 80005ebc <plic_complete>
    return 1;
    80002a14:	4505                	li	a0,1
    80002a16:	bf55                	j	800029ca <devintr+0x1e>
      uartintr();
    80002a18:	ffffe097          	auipc	ra,0xffffe
    80002a1c:	f82080e7          	jalr	-126(ra) # 8000099a <uartintr>
    80002a20:	b7ed                	j	80002a0a <devintr+0x5e>
      virtio_disk_intr();
    80002a22:	00004097          	auipc	ra,0x4
    80002a26:	966080e7          	jalr	-1690(ra) # 80006388 <virtio_disk_intr>
    80002a2a:	b7c5                	j	80002a0a <devintr+0x5e>
    if(cpuid() == 0){
    80002a2c:	fffff097          	auipc	ra,0xfffff
    80002a30:	1be080e7          	jalr	446(ra) # 80001bea <cpuid>
    80002a34:	c901                	beqz	a0,80002a44 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002a36:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002a3a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002a3c:	14479073          	csrw	sip,a5
    return 2;
    80002a40:	4509                	li	a0,2
    80002a42:	b761                	j	800029ca <devintr+0x1e>
      clockintr();
    80002a44:	00000097          	auipc	ra,0x0
    80002a48:	f22080e7          	jalr	-222(ra) # 80002966 <clockintr>
    80002a4c:	b7ed                	j	80002a36 <devintr+0x8a>

0000000080002a4e <usertrap>:
{
    80002a4e:	1101                	addi	sp,sp,-32
    80002a50:	ec06                	sd	ra,24(sp)
    80002a52:	e822                	sd	s0,16(sp)
    80002a54:	e426                	sd	s1,8(sp)
    80002a56:	e04a                	sd	s2,0(sp)
    80002a58:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a5a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002a5e:	1007f793          	andi	a5,a5,256
    80002a62:	e7b9                	bnez	a5,80002ab0 <usertrap+0x62>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a64:	00003797          	auipc	a5,0x3
    80002a68:	35c78793          	addi	a5,a5,860 # 80005dc0 <kernelvec>
    80002a6c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002a70:	fffff097          	auipc	ra,0xfffff
    80002a74:	1a6080e7          	jalr	422(ra) # 80001c16 <myproc>
    80002a78:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002a7a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a7c:	14102773          	csrr	a4,sepc
    80002a80:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a82:	14202773          	csrr	a4,scause
  if (r_scause()==15){
    80002a86:	47bd                	li	a5,15
    80002a88:	02f70c63          	beq	a4,a5,80002ac0 <usertrap+0x72>
    80002a8c:	14202773          	csrr	a4,scause
  else if(r_scause() == 8){
    80002a90:	47a1                	li	a5,8
    80002a92:	06f70763          	beq	a4,a5,80002b00 <usertrap+0xb2>
  } else if((which_dev = devintr()) != 0){
    80002a96:	00000097          	auipc	ra,0x0
    80002a9a:	f16080e7          	jalr	-234(ra) # 800029ac <devintr>
    80002a9e:	892a                	mv	s2,a0
    80002aa0:	c951                	beqz	a0,80002b34 <usertrap+0xe6>
  if(killed(p))
    80002aa2:	8526                	mv	a0,s1
    80002aa4:	00000097          	auipc	ra,0x0
    80002aa8:	ac6080e7          	jalr	-1338(ra) # 8000256a <killed>
    80002aac:	c579                	beqz	a0,80002b7a <usertrap+0x12c>
    80002aae:	a0c9                	j	80002b70 <usertrap+0x122>
    panic("usertrap: not from user mode");
    80002ab0:	00006517          	auipc	a0,0x6
    80002ab4:	8b050513          	addi	a0,a0,-1872 # 80008360 <states.0+0x58>
    80002ab8:	ffffe097          	auipc	ra,0xffffe
    80002abc:	a86080e7          	jalr	-1402(ra) # 8000053e <panic>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ac0:	143025f3          	csrr	a1,stval
    if(va>=MAXVA || allocate_cow(p->pagetable, va) <0){
    80002ac4:	57fd                	li	a5,-1
    80002ac6:	83e9                	srli	a5,a5,0x1a
    80002ac8:	02b7f463          	bgeu	a5,a1,80002af0 <usertrap+0xa2>
      p->killed = 1;
    80002acc:	4785                	li	a5,1
    80002ace:	d49c                	sw	a5,40(s1)
  if(killed(p))
    80002ad0:	8526                	mv	a0,s1
    80002ad2:	00000097          	auipc	ra,0x0
    80002ad6:	a98080e7          	jalr	-1384(ra) # 8000256a <killed>
    80002ada:	e951                	bnez	a0,80002b6e <usertrap+0x120>
  usertrapret();
    80002adc:	00000097          	auipc	ra,0x0
    80002ae0:	df4080e7          	jalr	-524(ra) # 800028d0 <usertrapret>
}
    80002ae4:	60e2                	ld	ra,24(sp)
    80002ae6:	6442                	ld	s0,16(sp)
    80002ae8:	64a2                	ld	s1,8(sp)
    80002aea:	6902                	ld	s2,0(sp)
    80002aec:	6105                	addi	sp,sp,32
    80002aee:	8082                	ret
    if(va>=MAXVA || allocate_cow(p->pagetable, va) <0){
    80002af0:	6928                	ld	a0,80(a0)
    80002af2:	fffff097          	auipc	ra,0xfffff
    80002af6:	cd2080e7          	jalr	-814(ra) # 800017c4 <allocate_cow>
    80002afa:	fc055be3          	bgez	a0,80002ad0 <usertrap+0x82>
    80002afe:	b7f9                	j	80002acc <usertrap+0x7e>
    if(killed(p))
    80002b00:	00000097          	auipc	ra,0x0
    80002b04:	a6a080e7          	jalr	-1430(ra) # 8000256a <killed>
    80002b08:	e105                	bnez	a0,80002b28 <usertrap+0xda>
    p->trapframe->epc += 4;
    80002b0a:	6cb8                	ld	a4,88(s1)
    80002b0c:	6f1c                	ld	a5,24(a4)
    80002b0e:	0791                	addi	a5,a5,4
    80002b10:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b12:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002b16:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b1a:	10079073          	csrw	sstatus,a5
    syscall();
    80002b1e:	00000097          	auipc	ra,0x0
    80002b22:	2b6080e7          	jalr	694(ra) # 80002dd4 <syscall>
    80002b26:	b76d                	j	80002ad0 <usertrap+0x82>
      exit(-1);
    80002b28:	557d                	li	a0,-1
    80002b2a:	00000097          	auipc	ra,0x0
    80002b2e:	8cc080e7          	jalr	-1844(ra) # 800023f6 <exit>
    80002b32:	bfe1                	j	80002b0a <usertrap+0xbc>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b34:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002b38:	5890                	lw	a2,48(s1)
    80002b3a:	00006517          	auipc	a0,0x6
    80002b3e:	84650513          	addi	a0,a0,-1978 # 80008380 <states.0+0x78>
    80002b42:	ffffe097          	auipc	ra,0xffffe
    80002b46:	a46080e7          	jalr	-1466(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b4a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002b4e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002b52:	00006517          	auipc	a0,0x6
    80002b56:	85e50513          	addi	a0,a0,-1954 # 800083b0 <states.0+0xa8>
    80002b5a:	ffffe097          	auipc	ra,0xffffe
    80002b5e:	a2e080e7          	jalr	-1490(ra) # 80000588 <printf>
    setkilled(p);
    80002b62:	8526                	mv	a0,s1
    80002b64:	00000097          	auipc	ra,0x0
    80002b68:	9da080e7          	jalr	-1574(ra) # 8000253e <setkilled>
    80002b6c:	b795                	j	80002ad0 <usertrap+0x82>
  if(killed(p))
    80002b6e:	4901                	li	s2,0
    exit(-1);
    80002b70:	557d                	li	a0,-1
    80002b72:	00000097          	auipc	ra,0x0
    80002b76:	884080e7          	jalr	-1916(ra) # 800023f6 <exit>
  if(which_dev == 2)
    80002b7a:	4789                	li	a5,2
    80002b7c:	f6f910e3          	bne	s2,a5,80002adc <usertrap+0x8e>
    yield();
    80002b80:	fffff097          	auipc	ra,0xfffff
    80002b84:	706080e7          	jalr	1798(ra) # 80002286 <yield>
    80002b88:	bf91                	j	80002adc <usertrap+0x8e>

0000000080002b8a <kerneltrap>:
{
    80002b8a:	7179                	addi	sp,sp,-48
    80002b8c:	f406                	sd	ra,40(sp)
    80002b8e:	f022                	sd	s0,32(sp)
    80002b90:	ec26                	sd	s1,24(sp)
    80002b92:	e84a                	sd	s2,16(sp)
    80002b94:	e44e                	sd	s3,8(sp)
    80002b96:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b98:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b9c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ba0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002ba4:	1004f793          	andi	a5,s1,256
    80002ba8:	cb85                	beqz	a5,80002bd8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002baa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002bae:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002bb0:	ef85                	bnez	a5,80002be8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002bb2:	00000097          	auipc	ra,0x0
    80002bb6:	dfa080e7          	jalr	-518(ra) # 800029ac <devintr>
    80002bba:	cd1d                	beqz	a0,80002bf8 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002bbc:	4789                	li	a5,2
    80002bbe:	06f50a63          	beq	a0,a5,80002c32 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002bc2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bc6:	10049073          	csrw	sstatus,s1
}
    80002bca:	70a2                	ld	ra,40(sp)
    80002bcc:	7402                	ld	s0,32(sp)
    80002bce:	64e2                	ld	s1,24(sp)
    80002bd0:	6942                	ld	s2,16(sp)
    80002bd2:	69a2                	ld	s3,8(sp)
    80002bd4:	6145                	addi	sp,sp,48
    80002bd6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002bd8:	00005517          	auipc	a0,0x5
    80002bdc:	7f850513          	addi	a0,a0,2040 # 800083d0 <states.0+0xc8>
    80002be0:	ffffe097          	auipc	ra,0xffffe
    80002be4:	95e080e7          	jalr	-1698(ra) # 8000053e <panic>
    panic("kerneltrap: interrupts enabled");
    80002be8:	00006517          	auipc	a0,0x6
    80002bec:	81050513          	addi	a0,a0,-2032 # 800083f8 <states.0+0xf0>
    80002bf0:	ffffe097          	auipc	ra,0xffffe
    80002bf4:	94e080e7          	jalr	-1714(ra) # 8000053e <panic>
    printf("scause %p\n", scause);
    80002bf8:	85ce                	mv	a1,s3
    80002bfa:	00006517          	auipc	a0,0x6
    80002bfe:	81e50513          	addi	a0,a0,-2018 # 80008418 <states.0+0x110>
    80002c02:	ffffe097          	auipc	ra,0xffffe
    80002c06:	986080e7          	jalr	-1658(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c0a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002c0e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002c12:	00006517          	auipc	a0,0x6
    80002c16:	81650513          	addi	a0,a0,-2026 # 80008428 <states.0+0x120>
    80002c1a:	ffffe097          	auipc	ra,0xffffe
    80002c1e:	96e080e7          	jalr	-1682(ra) # 80000588 <printf>
    panic("kerneltrap");
    80002c22:	00006517          	auipc	a0,0x6
    80002c26:	81e50513          	addi	a0,a0,-2018 # 80008440 <states.0+0x138>
    80002c2a:	ffffe097          	auipc	ra,0xffffe
    80002c2e:	914080e7          	jalr	-1772(ra) # 8000053e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002c32:	fffff097          	auipc	ra,0xfffff
    80002c36:	fe4080e7          	jalr	-28(ra) # 80001c16 <myproc>
    80002c3a:	d541                	beqz	a0,80002bc2 <kerneltrap+0x38>
    80002c3c:	fffff097          	auipc	ra,0xfffff
    80002c40:	fda080e7          	jalr	-38(ra) # 80001c16 <myproc>
    80002c44:	4d18                	lw	a4,24(a0)
    80002c46:	4791                	li	a5,4
    80002c48:	f6f71de3          	bne	a4,a5,80002bc2 <kerneltrap+0x38>
    yield();
    80002c4c:	fffff097          	auipc	ra,0xfffff
    80002c50:	63a080e7          	jalr	1594(ra) # 80002286 <yield>
    80002c54:	b7bd                	j	80002bc2 <kerneltrap+0x38>

0000000080002c56 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002c56:	1101                	addi	sp,sp,-32
    80002c58:	ec06                	sd	ra,24(sp)
    80002c5a:	e822                	sd	s0,16(sp)
    80002c5c:	e426                	sd	s1,8(sp)
    80002c5e:	1000                	addi	s0,sp,32
    80002c60:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002c62:	fffff097          	auipc	ra,0xfffff
    80002c66:	fb4080e7          	jalr	-76(ra) # 80001c16 <myproc>
  switch (n) {
    80002c6a:	4795                	li	a5,5
    80002c6c:	0497e163          	bltu	a5,s1,80002cae <argraw+0x58>
    80002c70:	048a                	slli	s1,s1,0x2
    80002c72:	00006717          	auipc	a4,0x6
    80002c76:	80670713          	addi	a4,a4,-2042 # 80008478 <states.0+0x170>
    80002c7a:	94ba                	add	s1,s1,a4
    80002c7c:	409c                	lw	a5,0(s1)
    80002c7e:	97ba                	add	a5,a5,a4
    80002c80:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002c82:	6d3c                	ld	a5,88(a0)
    80002c84:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002c86:	60e2                	ld	ra,24(sp)
    80002c88:	6442                	ld	s0,16(sp)
    80002c8a:	64a2                	ld	s1,8(sp)
    80002c8c:	6105                	addi	sp,sp,32
    80002c8e:	8082                	ret
    return p->trapframe->a1;
    80002c90:	6d3c                	ld	a5,88(a0)
    80002c92:	7fa8                	ld	a0,120(a5)
    80002c94:	bfcd                	j	80002c86 <argraw+0x30>
    return p->trapframe->a2;
    80002c96:	6d3c                	ld	a5,88(a0)
    80002c98:	63c8                	ld	a0,128(a5)
    80002c9a:	b7f5                	j	80002c86 <argraw+0x30>
    return p->trapframe->a3;
    80002c9c:	6d3c                	ld	a5,88(a0)
    80002c9e:	67c8                	ld	a0,136(a5)
    80002ca0:	b7dd                	j	80002c86 <argraw+0x30>
    return p->trapframe->a4;
    80002ca2:	6d3c                	ld	a5,88(a0)
    80002ca4:	6bc8                	ld	a0,144(a5)
    80002ca6:	b7c5                	j	80002c86 <argraw+0x30>
    return p->trapframe->a5;
    80002ca8:	6d3c                	ld	a5,88(a0)
    80002caa:	6fc8                	ld	a0,152(a5)
    80002cac:	bfe9                	j	80002c86 <argraw+0x30>
  panic("argraw");
    80002cae:	00005517          	auipc	a0,0x5
    80002cb2:	7a250513          	addi	a0,a0,1954 # 80008450 <states.0+0x148>
    80002cb6:	ffffe097          	auipc	ra,0xffffe
    80002cba:	888080e7          	jalr	-1912(ra) # 8000053e <panic>

0000000080002cbe <fetchaddr>:
{
    80002cbe:	1101                	addi	sp,sp,-32
    80002cc0:	ec06                	sd	ra,24(sp)
    80002cc2:	e822                	sd	s0,16(sp)
    80002cc4:	e426                	sd	s1,8(sp)
    80002cc6:	e04a                	sd	s2,0(sp)
    80002cc8:	1000                	addi	s0,sp,32
    80002cca:	84aa                	mv	s1,a0
    80002ccc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002cce:	fffff097          	auipc	ra,0xfffff
    80002cd2:	f48080e7          	jalr	-184(ra) # 80001c16 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002cd6:	653c                	ld	a5,72(a0)
    80002cd8:	02f4f863          	bgeu	s1,a5,80002d08 <fetchaddr+0x4a>
    80002cdc:	00848713          	addi	a4,s1,8
    80002ce0:	02e7e663          	bltu	a5,a4,80002d0c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002ce4:	46a1                	li	a3,8
    80002ce6:	8626                	mv	a2,s1
    80002ce8:	85ca                	mv	a1,s2
    80002cea:	6928                	ld	a0,80(a0)
    80002cec:	fffff097          	auipc	ra,0xfffff
    80002cf0:	c72080e7          	jalr	-910(ra) # 8000195e <copyin>
    80002cf4:	00a03533          	snez	a0,a0
    80002cf8:	40a00533          	neg	a0,a0
}
    80002cfc:	60e2                	ld	ra,24(sp)
    80002cfe:	6442                	ld	s0,16(sp)
    80002d00:	64a2                	ld	s1,8(sp)
    80002d02:	6902                	ld	s2,0(sp)
    80002d04:	6105                	addi	sp,sp,32
    80002d06:	8082                	ret
    return -1;
    80002d08:	557d                	li	a0,-1
    80002d0a:	bfcd                	j	80002cfc <fetchaddr+0x3e>
    80002d0c:	557d                	li	a0,-1
    80002d0e:	b7fd                	j	80002cfc <fetchaddr+0x3e>

0000000080002d10 <fetchstr>:
{
    80002d10:	7179                	addi	sp,sp,-48
    80002d12:	f406                	sd	ra,40(sp)
    80002d14:	f022                	sd	s0,32(sp)
    80002d16:	ec26                	sd	s1,24(sp)
    80002d18:	e84a                	sd	s2,16(sp)
    80002d1a:	e44e                	sd	s3,8(sp)
    80002d1c:	1800                	addi	s0,sp,48
    80002d1e:	892a                	mv	s2,a0
    80002d20:	84ae                	mv	s1,a1
    80002d22:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002d24:	fffff097          	auipc	ra,0xfffff
    80002d28:	ef2080e7          	jalr	-270(ra) # 80001c16 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002d2c:	86ce                	mv	a3,s3
    80002d2e:	864a                	mv	a2,s2
    80002d30:	85a6                	mv	a1,s1
    80002d32:	6928                	ld	a0,80(a0)
    80002d34:	fffff097          	auipc	ra,0xfffff
    80002d38:	cb8080e7          	jalr	-840(ra) # 800019ec <copyinstr>
    80002d3c:	00054e63          	bltz	a0,80002d58 <fetchstr+0x48>
  return strlen(buf);
    80002d40:	8526                	mv	a0,s1
    80002d42:	ffffe097          	auipc	ra,0xffffe
    80002d46:	208080e7          	jalr	520(ra) # 80000f4a <strlen>
}
    80002d4a:	70a2                	ld	ra,40(sp)
    80002d4c:	7402                	ld	s0,32(sp)
    80002d4e:	64e2                	ld	s1,24(sp)
    80002d50:	6942                	ld	s2,16(sp)
    80002d52:	69a2                	ld	s3,8(sp)
    80002d54:	6145                	addi	sp,sp,48
    80002d56:	8082                	ret
    return -1;
    80002d58:	557d                	li	a0,-1
    80002d5a:	bfc5                	j	80002d4a <fetchstr+0x3a>

0000000080002d5c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002d5c:	1101                	addi	sp,sp,-32
    80002d5e:	ec06                	sd	ra,24(sp)
    80002d60:	e822                	sd	s0,16(sp)
    80002d62:	e426                	sd	s1,8(sp)
    80002d64:	1000                	addi	s0,sp,32
    80002d66:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002d68:	00000097          	auipc	ra,0x0
    80002d6c:	eee080e7          	jalr	-274(ra) # 80002c56 <argraw>
    80002d70:	c088                	sw	a0,0(s1)
}
    80002d72:	60e2                	ld	ra,24(sp)
    80002d74:	6442                	ld	s0,16(sp)
    80002d76:	64a2                	ld	s1,8(sp)
    80002d78:	6105                	addi	sp,sp,32
    80002d7a:	8082                	ret

0000000080002d7c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002d7c:	1101                	addi	sp,sp,-32
    80002d7e:	ec06                	sd	ra,24(sp)
    80002d80:	e822                	sd	s0,16(sp)
    80002d82:	e426                	sd	s1,8(sp)
    80002d84:	1000                	addi	s0,sp,32
    80002d86:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002d88:	00000097          	auipc	ra,0x0
    80002d8c:	ece080e7          	jalr	-306(ra) # 80002c56 <argraw>
    80002d90:	e088                	sd	a0,0(s1)
}
    80002d92:	60e2                	ld	ra,24(sp)
    80002d94:	6442                	ld	s0,16(sp)
    80002d96:	64a2                	ld	s1,8(sp)
    80002d98:	6105                	addi	sp,sp,32
    80002d9a:	8082                	ret

0000000080002d9c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002d9c:	7179                	addi	sp,sp,-48
    80002d9e:	f406                	sd	ra,40(sp)
    80002da0:	f022                	sd	s0,32(sp)
    80002da2:	ec26                	sd	s1,24(sp)
    80002da4:	e84a                	sd	s2,16(sp)
    80002da6:	1800                	addi	s0,sp,48
    80002da8:	84ae                	mv	s1,a1
    80002daa:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002dac:	fd840593          	addi	a1,s0,-40
    80002db0:	00000097          	auipc	ra,0x0
    80002db4:	fcc080e7          	jalr	-52(ra) # 80002d7c <argaddr>
  return fetchstr(addr, buf, max);
    80002db8:	864a                	mv	a2,s2
    80002dba:	85a6                	mv	a1,s1
    80002dbc:	fd843503          	ld	a0,-40(s0)
    80002dc0:	00000097          	auipc	ra,0x0
    80002dc4:	f50080e7          	jalr	-176(ra) # 80002d10 <fetchstr>
}
    80002dc8:	70a2                	ld	ra,40(sp)
    80002dca:	7402                	ld	s0,32(sp)
    80002dcc:	64e2                	ld	s1,24(sp)
    80002dce:	6942                	ld	s2,16(sp)
    80002dd0:	6145                	addi	sp,sp,48
    80002dd2:	8082                	ret

0000000080002dd4 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002dd4:	1101                	addi	sp,sp,-32
    80002dd6:	ec06                	sd	ra,24(sp)
    80002dd8:	e822                	sd	s0,16(sp)
    80002dda:	e426                	sd	s1,8(sp)
    80002ddc:	e04a                	sd	s2,0(sp)
    80002dde:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002de0:	fffff097          	auipc	ra,0xfffff
    80002de4:	e36080e7          	jalr	-458(ra) # 80001c16 <myproc>
    80002de8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002dea:	05853903          	ld	s2,88(a0)
    80002dee:	0a893783          	ld	a5,168(s2)
    80002df2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002df6:	37fd                	addiw	a5,a5,-1
    80002df8:	4751                	li	a4,20
    80002dfa:	00f76f63          	bltu	a4,a5,80002e18 <syscall+0x44>
    80002dfe:	00369713          	slli	a4,a3,0x3
    80002e02:	00005797          	auipc	a5,0x5
    80002e06:	68e78793          	addi	a5,a5,1678 # 80008490 <syscalls>
    80002e0a:	97ba                	add	a5,a5,a4
    80002e0c:	639c                	ld	a5,0(a5)
    80002e0e:	c789                	beqz	a5,80002e18 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002e10:	9782                	jalr	a5
    80002e12:	06a93823          	sd	a0,112(s2)
    80002e16:	a839                	j	80002e34 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002e18:	15848613          	addi	a2,s1,344
    80002e1c:	588c                	lw	a1,48(s1)
    80002e1e:	00005517          	auipc	a0,0x5
    80002e22:	63a50513          	addi	a0,a0,1594 # 80008458 <states.0+0x150>
    80002e26:	ffffd097          	auipc	ra,0xffffd
    80002e2a:	762080e7          	jalr	1890(ra) # 80000588 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002e2e:	6cbc                	ld	a5,88(s1)
    80002e30:	577d                	li	a4,-1
    80002e32:	fbb8                	sd	a4,112(a5)
  }
}
    80002e34:	60e2                	ld	ra,24(sp)
    80002e36:	6442                	ld	s0,16(sp)
    80002e38:	64a2                	ld	s1,8(sp)
    80002e3a:	6902                	ld	s2,0(sp)
    80002e3c:	6105                	addi	sp,sp,32
    80002e3e:	8082                	ret

0000000080002e40 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002e40:	1101                	addi	sp,sp,-32
    80002e42:	ec06                	sd	ra,24(sp)
    80002e44:	e822                	sd	s0,16(sp)
    80002e46:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002e48:	fec40593          	addi	a1,s0,-20
    80002e4c:	4501                	li	a0,0
    80002e4e:	00000097          	auipc	ra,0x0
    80002e52:	f0e080e7          	jalr	-242(ra) # 80002d5c <argint>
  exit(n);
    80002e56:	fec42503          	lw	a0,-20(s0)
    80002e5a:	fffff097          	auipc	ra,0xfffff
    80002e5e:	59c080e7          	jalr	1436(ra) # 800023f6 <exit>
  return 0;  // not reached
}
    80002e62:	4501                	li	a0,0
    80002e64:	60e2                	ld	ra,24(sp)
    80002e66:	6442                	ld	s0,16(sp)
    80002e68:	6105                	addi	sp,sp,32
    80002e6a:	8082                	ret

0000000080002e6c <sys_getpid>:

uint64
sys_getpid(void)
{
    80002e6c:	1141                	addi	sp,sp,-16
    80002e6e:	e406                	sd	ra,8(sp)
    80002e70:	e022                	sd	s0,0(sp)
    80002e72:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002e74:	fffff097          	auipc	ra,0xfffff
    80002e78:	da2080e7          	jalr	-606(ra) # 80001c16 <myproc>
}
    80002e7c:	5908                	lw	a0,48(a0)
    80002e7e:	60a2                	ld	ra,8(sp)
    80002e80:	6402                	ld	s0,0(sp)
    80002e82:	0141                	addi	sp,sp,16
    80002e84:	8082                	ret

0000000080002e86 <sys_fork>:

uint64
sys_fork(void)
{
    80002e86:	1141                	addi	sp,sp,-16
    80002e88:	e406                	sd	ra,8(sp)
    80002e8a:	e022                	sd	s0,0(sp)
    80002e8c:	0800                	addi	s0,sp,16
  return fork();
    80002e8e:	fffff097          	auipc	ra,0xfffff
    80002e92:	142080e7          	jalr	322(ra) # 80001fd0 <fork>
}
    80002e96:	60a2                	ld	ra,8(sp)
    80002e98:	6402                	ld	s0,0(sp)
    80002e9a:	0141                	addi	sp,sp,16
    80002e9c:	8082                	ret

0000000080002e9e <sys_wait>:

uint64
sys_wait(void)
{
    80002e9e:	1101                	addi	sp,sp,-32
    80002ea0:	ec06                	sd	ra,24(sp)
    80002ea2:	e822                	sd	s0,16(sp)
    80002ea4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002ea6:	fe840593          	addi	a1,s0,-24
    80002eaa:	4501                	li	a0,0
    80002eac:	00000097          	auipc	ra,0x0
    80002eb0:	ed0080e7          	jalr	-304(ra) # 80002d7c <argaddr>
  return wait(p);
    80002eb4:	fe843503          	ld	a0,-24(s0)
    80002eb8:	fffff097          	auipc	ra,0xfffff
    80002ebc:	6e4080e7          	jalr	1764(ra) # 8000259c <wait>
}
    80002ec0:	60e2                	ld	ra,24(sp)
    80002ec2:	6442                	ld	s0,16(sp)
    80002ec4:	6105                	addi	sp,sp,32
    80002ec6:	8082                	ret

0000000080002ec8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002ec8:	7179                	addi	sp,sp,-48
    80002eca:	f406                	sd	ra,40(sp)
    80002ecc:	f022                	sd	s0,32(sp)
    80002ece:	ec26                	sd	s1,24(sp)
    80002ed0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002ed2:	fdc40593          	addi	a1,s0,-36
    80002ed6:	4501                	li	a0,0
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	e84080e7          	jalr	-380(ra) # 80002d5c <argint>
  addr = myproc()->sz;
    80002ee0:	fffff097          	auipc	ra,0xfffff
    80002ee4:	d36080e7          	jalr	-714(ra) # 80001c16 <myproc>
    80002ee8:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002eea:	fdc42503          	lw	a0,-36(s0)
    80002eee:	fffff097          	auipc	ra,0xfffff
    80002ef2:	086080e7          	jalr	134(ra) # 80001f74 <growproc>
    80002ef6:	00054863          	bltz	a0,80002f06 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002efa:	8526                	mv	a0,s1
    80002efc:	70a2                	ld	ra,40(sp)
    80002efe:	7402                	ld	s0,32(sp)
    80002f00:	64e2                	ld	s1,24(sp)
    80002f02:	6145                	addi	sp,sp,48
    80002f04:	8082                	ret
    return -1;
    80002f06:	54fd                	li	s1,-1
    80002f08:	bfcd                	j	80002efa <sys_sbrk+0x32>

0000000080002f0a <sys_sleep>:

uint64
sys_sleep(void)
{
    80002f0a:	7139                	addi	sp,sp,-64
    80002f0c:	fc06                	sd	ra,56(sp)
    80002f0e:	f822                	sd	s0,48(sp)
    80002f10:	f426                	sd	s1,40(sp)
    80002f12:	f04a                	sd	s2,32(sp)
    80002f14:	ec4e                	sd	s3,24(sp)
    80002f16:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002f18:	fcc40593          	addi	a1,s0,-52
    80002f1c:	4501                	li	a0,0
    80002f1e:	00000097          	auipc	ra,0x0
    80002f22:	e3e080e7          	jalr	-450(ra) # 80002d5c <argint>
  if(n < 0)
    80002f26:	fcc42783          	lw	a5,-52(s0)
    80002f2a:	0607cf63          	bltz	a5,80002fa8 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002f2e:	00234517          	auipc	a0,0x234
    80002f32:	a7250513          	addi	a0,a0,-1422 # 802369a0 <tickslock>
    80002f36:	ffffe097          	auipc	ra,0xffffe
    80002f3a:	d9c080e7          	jalr	-612(ra) # 80000cd2 <acquire>
  ticks0 = ticks;
    80002f3e:	00006917          	auipc	s2,0x6
    80002f42:	9c292903          	lw	s2,-1598(s2) # 80008900 <ticks>
  while(ticks - ticks0 < n){
    80002f46:	fcc42783          	lw	a5,-52(s0)
    80002f4a:	cf9d                	beqz	a5,80002f88 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002f4c:	00234997          	auipc	s3,0x234
    80002f50:	a5498993          	addi	s3,s3,-1452 # 802369a0 <tickslock>
    80002f54:	00006497          	auipc	s1,0x6
    80002f58:	9ac48493          	addi	s1,s1,-1620 # 80008900 <ticks>
    if(killed(myproc())){
    80002f5c:	fffff097          	auipc	ra,0xfffff
    80002f60:	cba080e7          	jalr	-838(ra) # 80001c16 <myproc>
    80002f64:	fffff097          	auipc	ra,0xfffff
    80002f68:	606080e7          	jalr	1542(ra) # 8000256a <killed>
    80002f6c:	e129                	bnez	a0,80002fae <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002f6e:	85ce                	mv	a1,s3
    80002f70:	8526                	mv	a0,s1
    80002f72:	fffff097          	auipc	ra,0xfffff
    80002f76:	350080e7          	jalr	848(ra) # 800022c2 <sleep>
  while(ticks - ticks0 < n){
    80002f7a:	409c                	lw	a5,0(s1)
    80002f7c:	412787bb          	subw	a5,a5,s2
    80002f80:	fcc42703          	lw	a4,-52(s0)
    80002f84:	fce7ece3          	bltu	a5,a4,80002f5c <sys_sleep+0x52>
  }
  release(&tickslock);
    80002f88:	00234517          	auipc	a0,0x234
    80002f8c:	a1850513          	addi	a0,a0,-1512 # 802369a0 <tickslock>
    80002f90:	ffffe097          	auipc	ra,0xffffe
    80002f94:	df6080e7          	jalr	-522(ra) # 80000d86 <release>
  return 0;
    80002f98:	4501                	li	a0,0
}
    80002f9a:	70e2                	ld	ra,56(sp)
    80002f9c:	7442                	ld	s0,48(sp)
    80002f9e:	74a2                	ld	s1,40(sp)
    80002fa0:	7902                	ld	s2,32(sp)
    80002fa2:	69e2                	ld	s3,24(sp)
    80002fa4:	6121                	addi	sp,sp,64
    80002fa6:	8082                	ret
    n = 0;
    80002fa8:	fc042623          	sw	zero,-52(s0)
    80002fac:	b749                	j	80002f2e <sys_sleep+0x24>
      release(&tickslock);
    80002fae:	00234517          	auipc	a0,0x234
    80002fb2:	9f250513          	addi	a0,a0,-1550 # 802369a0 <tickslock>
    80002fb6:	ffffe097          	auipc	ra,0xffffe
    80002fba:	dd0080e7          	jalr	-560(ra) # 80000d86 <release>
      return -1;
    80002fbe:	557d                	li	a0,-1
    80002fc0:	bfe9                	j	80002f9a <sys_sleep+0x90>

0000000080002fc2 <sys_kill>:

uint64
sys_kill(void)
{
    80002fc2:	1101                	addi	sp,sp,-32
    80002fc4:	ec06                	sd	ra,24(sp)
    80002fc6:	e822                	sd	s0,16(sp)
    80002fc8:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002fca:	fec40593          	addi	a1,s0,-20
    80002fce:	4501                	li	a0,0
    80002fd0:	00000097          	auipc	ra,0x0
    80002fd4:	d8c080e7          	jalr	-628(ra) # 80002d5c <argint>
  return kill(pid);
    80002fd8:	fec42503          	lw	a0,-20(s0)
    80002fdc:	fffff097          	auipc	ra,0xfffff
    80002fe0:	4f0080e7          	jalr	1264(ra) # 800024cc <kill>
}
    80002fe4:	60e2                	ld	ra,24(sp)
    80002fe6:	6442                	ld	s0,16(sp)
    80002fe8:	6105                	addi	sp,sp,32
    80002fea:	8082                	ret

0000000080002fec <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002fec:	1101                	addi	sp,sp,-32
    80002fee:	ec06                	sd	ra,24(sp)
    80002ff0:	e822                	sd	s0,16(sp)
    80002ff2:	e426                	sd	s1,8(sp)
    80002ff4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002ff6:	00234517          	auipc	a0,0x234
    80002ffa:	9aa50513          	addi	a0,a0,-1622 # 802369a0 <tickslock>
    80002ffe:	ffffe097          	auipc	ra,0xffffe
    80003002:	cd4080e7          	jalr	-812(ra) # 80000cd2 <acquire>
  xticks = ticks;
    80003006:	00006497          	auipc	s1,0x6
    8000300a:	8fa4a483          	lw	s1,-1798(s1) # 80008900 <ticks>
  release(&tickslock);
    8000300e:	00234517          	auipc	a0,0x234
    80003012:	99250513          	addi	a0,a0,-1646 # 802369a0 <tickslock>
    80003016:	ffffe097          	auipc	ra,0xffffe
    8000301a:	d70080e7          	jalr	-656(ra) # 80000d86 <release>
  return xticks;
}
    8000301e:	02049513          	slli	a0,s1,0x20
    80003022:	9101                	srli	a0,a0,0x20
    80003024:	60e2                	ld	ra,24(sp)
    80003026:	6442                	ld	s0,16(sp)
    80003028:	64a2                	ld	s1,8(sp)
    8000302a:	6105                	addi	sp,sp,32
    8000302c:	8082                	ret

000000008000302e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000302e:	7179                	addi	sp,sp,-48
    80003030:	f406                	sd	ra,40(sp)
    80003032:	f022                	sd	s0,32(sp)
    80003034:	ec26                	sd	s1,24(sp)
    80003036:	e84a                	sd	s2,16(sp)
    80003038:	e44e                	sd	s3,8(sp)
    8000303a:	e052                	sd	s4,0(sp)
    8000303c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000303e:	00005597          	auipc	a1,0x5
    80003042:	50258593          	addi	a1,a1,1282 # 80008540 <syscalls+0xb0>
    80003046:	00234517          	auipc	a0,0x234
    8000304a:	97250513          	addi	a0,a0,-1678 # 802369b8 <bcache>
    8000304e:	ffffe097          	auipc	ra,0xffffe
    80003052:	bf4080e7          	jalr	-1036(ra) # 80000c42 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003056:	0023c797          	auipc	a5,0x23c
    8000305a:	96278793          	addi	a5,a5,-1694 # 8023e9b8 <bcache+0x8000>
    8000305e:	0023c717          	auipc	a4,0x23c
    80003062:	bc270713          	addi	a4,a4,-1086 # 8023ec20 <bcache+0x8268>
    80003066:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000306a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000306e:	00234497          	auipc	s1,0x234
    80003072:	96248493          	addi	s1,s1,-1694 # 802369d0 <bcache+0x18>
    b->next = bcache.head.next;
    80003076:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003078:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000307a:	00005a17          	auipc	s4,0x5
    8000307e:	4cea0a13          	addi	s4,s4,1230 # 80008548 <syscalls+0xb8>
    b->next = bcache.head.next;
    80003082:	2b893783          	ld	a5,696(s2)
    80003086:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003088:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000308c:	85d2                	mv	a1,s4
    8000308e:	01048513          	addi	a0,s1,16
    80003092:	00001097          	auipc	ra,0x1
    80003096:	4ca080e7          	jalr	1226(ra) # 8000455c <initsleeplock>
    bcache.head.next->prev = b;
    8000309a:	2b893783          	ld	a5,696(s2)
    8000309e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800030a0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800030a4:	45848493          	addi	s1,s1,1112
    800030a8:	fd349de3          	bne	s1,s3,80003082 <binit+0x54>
  }
}
    800030ac:	70a2                	ld	ra,40(sp)
    800030ae:	7402                	ld	s0,32(sp)
    800030b0:	64e2                	ld	s1,24(sp)
    800030b2:	6942                	ld	s2,16(sp)
    800030b4:	69a2                	ld	s3,8(sp)
    800030b6:	6a02                	ld	s4,0(sp)
    800030b8:	6145                	addi	sp,sp,48
    800030ba:	8082                	ret

00000000800030bc <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800030bc:	7179                	addi	sp,sp,-48
    800030be:	f406                	sd	ra,40(sp)
    800030c0:	f022                	sd	s0,32(sp)
    800030c2:	ec26                	sd	s1,24(sp)
    800030c4:	e84a                	sd	s2,16(sp)
    800030c6:	e44e                	sd	s3,8(sp)
    800030c8:	1800                	addi	s0,sp,48
    800030ca:	892a                	mv	s2,a0
    800030cc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800030ce:	00234517          	auipc	a0,0x234
    800030d2:	8ea50513          	addi	a0,a0,-1814 # 802369b8 <bcache>
    800030d6:	ffffe097          	auipc	ra,0xffffe
    800030da:	bfc080e7          	jalr	-1028(ra) # 80000cd2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800030de:	0023c497          	auipc	s1,0x23c
    800030e2:	b924b483          	ld	s1,-1134(s1) # 8023ec70 <bcache+0x82b8>
    800030e6:	0023c797          	auipc	a5,0x23c
    800030ea:	b3a78793          	addi	a5,a5,-1222 # 8023ec20 <bcache+0x8268>
    800030ee:	02f48f63          	beq	s1,a5,8000312c <bread+0x70>
    800030f2:	873e                	mv	a4,a5
    800030f4:	a021                	j	800030fc <bread+0x40>
    800030f6:	68a4                	ld	s1,80(s1)
    800030f8:	02e48a63          	beq	s1,a4,8000312c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800030fc:	449c                	lw	a5,8(s1)
    800030fe:	ff279ce3          	bne	a5,s2,800030f6 <bread+0x3a>
    80003102:	44dc                	lw	a5,12(s1)
    80003104:	ff3799e3          	bne	a5,s3,800030f6 <bread+0x3a>
      b->reference_count++;
    80003108:	40bc                	lw	a5,64(s1)
    8000310a:	2785                	addiw	a5,a5,1
    8000310c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000310e:	00234517          	auipc	a0,0x234
    80003112:	8aa50513          	addi	a0,a0,-1878 # 802369b8 <bcache>
    80003116:	ffffe097          	auipc	ra,0xffffe
    8000311a:	c70080e7          	jalr	-912(ra) # 80000d86 <release>
      acquiresleep(&b->lock);
    8000311e:	01048513          	addi	a0,s1,16
    80003122:	00001097          	auipc	ra,0x1
    80003126:	474080e7          	jalr	1140(ra) # 80004596 <acquiresleep>
      return b;
    8000312a:	a8b9                	j	80003188 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000312c:	0023c497          	auipc	s1,0x23c
    80003130:	b3c4b483          	ld	s1,-1220(s1) # 8023ec68 <bcache+0x82b0>
    80003134:	0023c797          	auipc	a5,0x23c
    80003138:	aec78793          	addi	a5,a5,-1300 # 8023ec20 <bcache+0x8268>
    8000313c:	00f48863          	beq	s1,a5,8000314c <bread+0x90>
    80003140:	873e                	mv	a4,a5
    if(b->reference_count == 0) {
    80003142:	40bc                	lw	a5,64(s1)
    80003144:	cf81                	beqz	a5,8000315c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003146:	64a4                	ld	s1,72(s1)
    80003148:	fee49de3          	bne	s1,a4,80003142 <bread+0x86>
  panic("bget: no buffers");
    8000314c:	00005517          	auipc	a0,0x5
    80003150:	40450513          	addi	a0,a0,1028 # 80008550 <syscalls+0xc0>
    80003154:	ffffd097          	auipc	ra,0xffffd
    80003158:	3ea080e7          	jalr	1002(ra) # 8000053e <panic>
      b->dev = dev;
    8000315c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003160:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003164:	0004a023          	sw	zero,0(s1)
      b->reference_count = 1;
    80003168:	4785                	li	a5,1
    8000316a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000316c:	00234517          	auipc	a0,0x234
    80003170:	84c50513          	addi	a0,a0,-1972 # 802369b8 <bcache>
    80003174:	ffffe097          	auipc	ra,0xffffe
    80003178:	c12080e7          	jalr	-1006(ra) # 80000d86 <release>
      acquiresleep(&b->lock);
    8000317c:	01048513          	addi	a0,s1,16
    80003180:	00001097          	auipc	ra,0x1
    80003184:	416080e7          	jalr	1046(ra) # 80004596 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003188:	409c                	lw	a5,0(s1)
    8000318a:	cb89                	beqz	a5,8000319c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000318c:	8526                	mv	a0,s1
    8000318e:	70a2                	ld	ra,40(sp)
    80003190:	7402                	ld	s0,32(sp)
    80003192:	64e2                	ld	s1,24(sp)
    80003194:	6942                	ld	s2,16(sp)
    80003196:	69a2                	ld	s3,8(sp)
    80003198:	6145                	addi	sp,sp,48
    8000319a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000319c:	4581                	li	a1,0
    8000319e:	8526                	mv	a0,s1
    800031a0:	00003097          	auipc	ra,0x3
    800031a4:	fb4080e7          	jalr	-76(ra) # 80006154 <virtio_disk_rw>
    b->valid = 1;
    800031a8:	4785                	li	a5,1
    800031aa:	c09c                	sw	a5,0(s1)
  return b;
    800031ac:	b7c5                	j	8000318c <bread+0xd0>

00000000800031ae <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800031ae:	1101                	addi	sp,sp,-32
    800031b0:	ec06                	sd	ra,24(sp)
    800031b2:	e822                	sd	s0,16(sp)
    800031b4:	e426                	sd	s1,8(sp)
    800031b6:	1000                	addi	s0,sp,32
    800031b8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031ba:	0541                	addi	a0,a0,16
    800031bc:	00001097          	auipc	ra,0x1
    800031c0:	474080e7          	jalr	1140(ra) # 80004630 <holdingsleep>
    800031c4:	cd01                	beqz	a0,800031dc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800031c6:	4585                	li	a1,1
    800031c8:	8526                	mv	a0,s1
    800031ca:	00003097          	auipc	ra,0x3
    800031ce:	f8a080e7          	jalr	-118(ra) # 80006154 <virtio_disk_rw>
}
    800031d2:	60e2                	ld	ra,24(sp)
    800031d4:	6442                	ld	s0,16(sp)
    800031d6:	64a2                	ld	s1,8(sp)
    800031d8:	6105                	addi	sp,sp,32
    800031da:	8082                	ret
    panic("bwrite");
    800031dc:	00005517          	auipc	a0,0x5
    800031e0:	38c50513          	addi	a0,a0,908 # 80008568 <syscalls+0xd8>
    800031e4:	ffffd097          	auipc	ra,0xffffd
    800031e8:	35a080e7          	jalr	858(ra) # 8000053e <panic>

00000000800031ec <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800031ec:	1101                	addi	sp,sp,-32
    800031ee:	ec06                	sd	ra,24(sp)
    800031f0:	e822                	sd	s0,16(sp)
    800031f2:	e426                	sd	s1,8(sp)
    800031f4:	e04a                	sd	s2,0(sp)
    800031f6:	1000                	addi	s0,sp,32
    800031f8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031fa:	01050913          	addi	s2,a0,16
    800031fe:	854a                	mv	a0,s2
    80003200:	00001097          	auipc	ra,0x1
    80003204:	430080e7          	jalr	1072(ra) # 80004630 <holdingsleep>
    80003208:	c92d                	beqz	a0,8000327a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000320a:	854a                	mv	a0,s2
    8000320c:	00001097          	auipc	ra,0x1
    80003210:	3e0080e7          	jalr	992(ra) # 800045ec <releasesleep>

  acquire(&bcache.lock);
    80003214:	00233517          	auipc	a0,0x233
    80003218:	7a450513          	addi	a0,a0,1956 # 802369b8 <bcache>
    8000321c:	ffffe097          	auipc	ra,0xffffe
    80003220:	ab6080e7          	jalr	-1354(ra) # 80000cd2 <acquire>
  b->reference_count--;
    80003224:	40bc                	lw	a5,64(s1)
    80003226:	37fd                	addiw	a5,a5,-1
    80003228:	0007871b          	sext.w	a4,a5
    8000322c:	c0bc                	sw	a5,64(s1)
  if (b->reference_count == 0) {
    8000322e:	eb05                	bnez	a4,8000325e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003230:	68bc                	ld	a5,80(s1)
    80003232:	64b8                	ld	a4,72(s1)
    80003234:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003236:	64bc                	ld	a5,72(s1)
    80003238:	68b8                	ld	a4,80(s1)
    8000323a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000323c:	0023b797          	auipc	a5,0x23b
    80003240:	77c78793          	addi	a5,a5,1916 # 8023e9b8 <bcache+0x8000>
    80003244:	2b87b703          	ld	a4,696(a5)
    80003248:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000324a:	0023c717          	auipc	a4,0x23c
    8000324e:	9d670713          	addi	a4,a4,-1578 # 8023ec20 <bcache+0x8268>
    80003252:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003254:	2b87b703          	ld	a4,696(a5)
    80003258:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000325a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000325e:	00233517          	auipc	a0,0x233
    80003262:	75a50513          	addi	a0,a0,1882 # 802369b8 <bcache>
    80003266:	ffffe097          	auipc	ra,0xffffe
    8000326a:	b20080e7          	jalr	-1248(ra) # 80000d86 <release>
}
    8000326e:	60e2                	ld	ra,24(sp)
    80003270:	6442                	ld	s0,16(sp)
    80003272:	64a2                	ld	s1,8(sp)
    80003274:	6902                	ld	s2,0(sp)
    80003276:	6105                	addi	sp,sp,32
    80003278:	8082                	ret
    panic("brelse");
    8000327a:	00005517          	auipc	a0,0x5
    8000327e:	2f650513          	addi	a0,a0,758 # 80008570 <syscalls+0xe0>
    80003282:	ffffd097          	auipc	ra,0xffffd
    80003286:	2bc080e7          	jalr	700(ra) # 8000053e <panic>

000000008000328a <bpin>:

void
bpin(struct buf *b) {
    8000328a:	1101                	addi	sp,sp,-32
    8000328c:	ec06                	sd	ra,24(sp)
    8000328e:	e822                	sd	s0,16(sp)
    80003290:	e426                	sd	s1,8(sp)
    80003292:	1000                	addi	s0,sp,32
    80003294:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003296:	00233517          	auipc	a0,0x233
    8000329a:	72250513          	addi	a0,a0,1826 # 802369b8 <bcache>
    8000329e:	ffffe097          	auipc	ra,0xffffe
    800032a2:	a34080e7          	jalr	-1484(ra) # 80000cd2 <acquire>
  b->reference_count++;
    800032a6:	40bc                	lw	a5,64(s1)
    800032a8:	2785                	addiw	a5,a5,1
    800032aa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800032ac:	00233517          	auipc	a0,0x233
    800032b0:	70c50513          	addi	a0,a0,1804 # 802369b8 <bcache>
    800032b4:	ffffe097          	auipc	ra,0xffffe
    800032b8:	ad2080e7          	jalr	-1326(ra) # 80000d86 <release>
}
    800032bc:	60e2                	ld	ra,24(sp)
    800032be:	6442                	ld	s0,16(sp)
    800032c0:	64a2                	ld	s1,8(sp)
    800032c2:	6105                	addi	sp,sp,32
    800032c4:	8082                	ret

00000000800032c6 <bunpin>:

void
bunpin(struct buf *b) {
    800032c6:	1101                	addi	sp,sp,-32
    800032c8:	ec06                	sd	ra,24(sp)
    800032ca:	e822                	sd	s0,16(sp)
    800032cc:	e426                	sd	s1,8(sp)
    800032ce:	1000                	addi	s0,sp,32
    800032d0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800032d2:	00233517          	auipc	a0,0x233
    800032d6:	6e650513          	addi	a0,a0,1766 # 802369b8 <bcache>
    800032da:	ffffe097          	auipc	ra,0xffffe
    800032de:	9f8080e7          	jalr	-1544(ra) # 80000cd2 <acquire>
  b->reference_count--;
    800032e2:	40bc                	lw	a5,64(s1)
    800032e4:	37fd                	addiw	a5,a5,-1
    800032e6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800032e8:	00233517          	auipc	a0,0x233
    800032ec:	6d050513          	addi	a0,a0,1744 # 802369b8 <bcache>
    800032f0:	ffffe097          	auipc	ra,0xffffe
    800032f4:	a96080e7          	jalr	-1386(ra) # 80000d86 <release>
}
    800032f8:	60e2                	ld	ra,24(sp)
    800032fa:	6442                	ld	s0,16(sp)
    800032fc:	64a2                	ld	s1,8(sp)
    800032fe:	6105                	addi	sp,sp,32
    80003300:	8082                	ret

0000000080003302 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003302:	1101                	addi	sp,sp,-32
    80003304:	ec06                	sd	ra,24(sp)
    80003306:	e822                	sd	s0,16(sp)
    80003308:	e426                	sd	s1,8(sp)
    8000330a:	e04a                	sd	s2,0(sp)
    8000330c:	1000                	addi	s0,sp,32
    8000330e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003310:	00d5d59b          	srliw	a1,a1,0xd
    80003314:	0023c797          	auipc	a5,0x23c
    80003318:	d807a783          	lw	a5,-640(a5) # 8023f094 <sb+0x1c>
    8000331c:	9dbd                	addw	a1,a1,a5
    8000331e:	00000097          	auipc	ra,0x0
    80003322:	d9e080e7          	jalr	-610(ra) # 800030bc <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003326:	0074f713          	andi	a4,s1,7
    8000332a:	4785                	li	a5,1
    8000332c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003330:	14ce                	slli	s1,s1,0x33
    80003332:	90d9                	srli	s1,s1,0x36
    80003334:	00950733          	add	a4,a0,s1
    80003338:	05874703          	lbu	a4,88(a4)
    8000333c:	00e7f6b3          	and	a3,a5,a4
    80003340:	c69d                	beqz	a3,8000336e <bfree+0x6c>
    80003342:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003344:	94aa                	add	s1,s1,a0
    80003346:	fff7c793          	not	a5,a5
    8000334a:	8ff9                	and	a5,a5,a4
    8000334c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003350:	00001097          	auipc	ra,0x1
    80003354:	126080e7          	jalr	294(ra) # 80004476 <log_write>
  brelse(bp);
    80003358:	854a                	mv	a0,s2
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	e92080e7          	jalr	-366(ra) # 800031ec <brelse>
}
    80003362:	60e2                	ld	ra,24(sp)
    80003364:	6442                	ld	s0,16(sp)
    80003366:	64a2                	ld	s1,8(sp)
    80003368:	6902                	ld	s2,0(sp)
    8000336a:	6105                	addi	sp,sp,32
    8000336c:	8082                	ret
    panic("freeing free block");
    8000336e:	00005517          	auipc	a0,0x5
    80003372:	20a50513          	addi	a0,a0,522 # 80008578 <syscalls+0xe8>
    80003376:	ffffd097          	auipc	ra,0xffffd
    8000337a:	1c8080e7          	jalr	456(ra) # 8000053e <panic>

000000008000337e <balloc>:
{
    8000337e:	711d                	addi	sp,sp,-96
    80003380:	ec86                	sd	ra,88(sp)
    80003382:	e8a2                	sd	s0,80(sp)
    80003384:	e4a6                	sd	s1,72(sp)
    80003386:	e0ca                	sd	s2,64(sp)
    80003388:	fc4e                	sd	s3,56(sp)
    8000338a:	f852                	sd	s4,48(sp)
    8000338c:	f456                	sd	s5,40(sp)
    8000338e:	f05a                	sd	s6,32(sp)
    80003390:	ec5e                	sd	s7,24(sp)
    80003392:	e862                	sd	s8,16(sp)
    80003394:	e466                	sd	s9,8(sp)
    80003396:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003398:	0023c797          	auipc	a5,0x23c
    8000339c:	ce47a783          	lw	a5,-796(a5) # 8023f07c <sb+0x4>
    800033a0:	10078163          	beqz	a5,800034a2 <balloc+0x124>
    800033a4:	8baa                	mv	s7,a0
    800033a6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800033a8:	0023cb17          	auipc	s6,0x23c
    800033ac:	cd0b0b13          	addi	s6,s6,-816 # 8023f078 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033b0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800033b2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033b4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800033b6:	6c89                	lui	s9,0x2
    800033b8:	a061                	j	80003440 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800033ba:	974a                	add	a4,a4,s2
    800033bc:	8fd5                	or	a5,a5,a3
    800033be:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800033c2:	854a                	mv	a0,s2
    800033c4:	00001097          	auipc	ra,0x1
    800033c8:	0b2080e7          	jalr	178(ra) # 80004476 <log_write>
        brelse(bp);
    800033cc:	854a                	mv	a0,s2
    800033ce:	00000097          	auipc	ra,0x0
    800033d2:	e1e080e7          	jalr	-482(ra) # 800031ec <brelse>
  bp = bread(dev, bno);
    800033d6:	85a6                	mv	a1,s1
    800033d8:	855e                	mv	a0,s7
    800033da:	00000097          	auipc	ra,0x0
    800033de:	ce2080e7          	jalr	-798(ra) # 800030bc <bread>
    800033e2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800033e4:	40000613          	li	a2,1024
    800033e8:	4581                	li	a1,0
    800033ea:	05850513          	addi	a0,a0,88
    800033ee:	ffffe097          	auipc	ra,0xffffe
    800033f2:	9e0080e7          	jalr	-1568(ra) # 80000dce <memset>
  log_write(bp);
    800033f6:	854a                	mv	a0,s2
    800033f8:	00001097          	auipc	ra,0x1
    800033fc:	07e080e7          	jalr	126(ra) # 80004476 <log_write>
  brelse(bp);
    80003400:	854a                	mv	a0,s2
    80003402:	00000097          	auipc	ra,0x0
    80003406:	dea080e7          	jalr	-534(ra) # 800031ec <brelse>
}
    8000340a:	8526                	mv	a0,s1
    8000340c:	60e6                	ld	ra,88(sp)
    8000340e:	6446                	ld	s0,80(sp)
    80003410:	64a6                	ld	s1,72(sp)
    80003412:	6906                	ld	s2,64(sp)
    80003414:	79e2                	ld	s3,56(sp)
    80003416:	7a42                	ld	s4,48(sp)
    80003418:	7aa2                	ld	s5,40(sp)
    8000341a:	7b02                	ld	s6,32(sp)
    8000341c:	6be2                	ld	s7,24(sp)
    8000341e:	6c42                	ld	s8,16(sp)
    80003420:	6ca2                	ld	s9,8(sp)
    80003422:	6125                	addi	sp,sp,96
    80003424:	8082                	ret
    brelse(bp);
    80003426:	854a                	mv	a0,s2
    80003428:	00000097          	auipc	ra,0x0
    8000342c:	dc4080e7          	jalr	-572(ra) # 800031ec <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003430:	015c87bb          	addw	a5,s9,s5
    80003434:	00078a9b          	sext.w	s5,a5
    80003438:	004b2703          	lw	a4,4(s6)
    8000343c:	06eaf363          	bgeu	s5,a4,800034a2 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80003440:	41fad79b          	sraiw	a5,s5,0x1f
    80003444:	0137d79b          	srliw	a5,a5,0x13
    80003448:	015787bb          	addw	a5,a5,s5
    8000344c:	40d7d79b          	sraiw	a5,a5,0xd
    80003450:	01cb2583          	lw	a1,28(s6)
    80003454:	9dbd                	addw	a1,a1,a5
    80003456:	855e                	mv	a0,s7
    80003458:	00000097          	auipc	ra,0x0
    8000345c:	c64080e7          	jalr	-924(ra) # 800030bc <bread>
    80003460:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003462:	004b2503          	lw	a0,4(s6)
    80003466:	000a849b          	sext.w	s1,s5
    8000346a:	8662                	mv	a2,s8
    8000346c:	faa4fde3          	bgeu	s1,a0,80003426 <balloc+0xa8>
      m = 1 << (bi % 8);
    80003470:	41f6579b          	sraiw	a5,a2,0x1f
    80003474:	01d7d69b          	srliw	a3,a5,0x1d
    80003478:	00c6873b          	addw	a4,a3,a2
    8000347c:	00777793          	andi	a5,a4,7
    80003480:	9f95                	subw	a5,a5,a3
    80003482:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003486:	4037571b          	sraiw	a4,a4,0x3
    8000348a:	00e906b3          	add	a3,s2,a4
    8000348e:	0586c683          	lbu	a3,88(a3)
    80003492:	00d7f5b3          	and	a1,a5,a3
    80003496:	d195                	beqz	a1,800033ba <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003498:	2605                	addiw	a2,a2,1
    8000349a:	2485                	addiw	s1,s1,1
    8000349c:	fd4618e3          	bne	a2,s4,8000346c <balloc+0xee>
    800034a0:	b759                	j	80003426 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800034a2:	00005517          	auipc	a0,0x5
    800034a6:	0ee50513          	addi	a0,a0,238 # 80008590 <syscalls+0x100>
    800034aa:	ffffd097          	auipc	ra,0xffffd
    800034ae:	0de080e7          	jalr	222(ra) # 80000588 <printf>
  return 0;
    800034b2:	4481                	li	s1,0
    800034b4:	bf99                	j	8000340a <balloc+0x8c>

00000000800034b6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800034b6:	7179                	addi	sp,sp,-48
    800034b8:	f406                	sd	ra,40(sp)
    800034ba:	f022                	sd	s0,32(sp)
    800034bc:	ec26                	sd	s1,24(sp)
    800034be:	e84a                	sd	s2,16(sp)
    800034c0:	e44e                	sd	s3,8(sp)
    800034c2:	e052                	sd	s4,0(sp)
    800034c4:	1800                	addi	s0,sp,48
    800034c6:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800034c8:	47ad                	li	a5,11
    800034ca:	02b7e863          	bltu	a5,a1,800034fa <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800034ce:	02059793          	slli	a5,a1,0x20
    800034d2:	01e7d593          	srli	a1,a5,0x1e
    800034d6:	00b504b3          	add	s1,a0,a1
    800034da:	0504a903          	lw	s2,80(s1)
    800034de:	06091e63          	bnez	s2,8000355a <bmap+0xa4>
      addr = balloc(ip->dev);
    800034e2:	4108                	lw	a0,0(a0)
    800034e4:	00000097          	auipc	ra,0x0
    800034e8:	e9a080e7          	jalr	-358(ra) # 8000337e <balloc>
    800034ec:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800034f0:	06090563          	beqz	s2,8000355a <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800034f4:	0524a823          	sw	s2,80(s1)
    800034f8:	a08d                	j	8000355a <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800034fa:	ff45849b          	addiw	s1,a1,-12
    800034fe:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003502:	0ff00793          	li	a5,255
    80003506:	08e7e563          	bltu	a5,a4,80003590 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000350a:	08052903          	lw	s2,128(a0)
    8000350e:	00091d63          	bnez	s2,80003528 <bmap+0x72>
      addr = balloc(ip->dev);
    80003512:	4108                	lw	a0,0(a0)
    80003514:	00000097          	auipc	ra,0x0
    80003518:	e6a080e7          	jalr	-406(ra) # 8000337e <balloc>
    8000351c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003520:	02090d63          	beqz	s2,8000355a <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003524:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003528:	85ca                	mv	a1,s2
    8000352a:	0009a503          	lw	a0,0(s3)
    8000352e:	00000097          	auipc	ra,0x0
    80003532:	b8e080e7          	jalr	-1138(ra) # 800030bc <bread>
    80003536:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003538:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000353c:	02049713          	slli	a4,s1,0x20
    80003540:	01e75593          	srli	a1,a4,0x1e
    80003544:	00b784b3          	add	s1,a5,a1
    80003548:	0004a903          	lw	s2,0(s1)
    8000354c:	02090063          	beqz	s2,8000356c <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003550:	8552                	mv	a0,s4
    80003552:	00000097          	auipc	ra,0x0
    80003556:	c9a080e7          	jalr	-870(ra) # 800031ec <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000355a:	854a                	mv	a0,s2
    8000355c:	70a2                	ld	ra,40(sp)
    8000355e:	7402                	ld	s0,32(sp)
    80003560:	64e2                	ld	s1,24(sp)
    80003562:	6942                	ld	s2,16(sp)
    80003564:	69a2                	ld	s3,8(sp)
    80003566:	6a02                	ld	s4,0(sp)
    80003568:	6145                	addi	sp,sp,48
    8000356a:	8082                	ret
      addr = balloc(ip->dev);
    8000356c:	0009a503          	lw	a0,0(s3)
    80003570:	00000097          	auipc	ra,0x0
    80003574:	e0e080e7          	jalr	-498(ra) # 8000337e <balloc>
    80003578:	0005091b          	sext.w	s2,a0
      if(addr){
    8000357c:	fc090ae3          	beqz	s2,80003550 <bmap+0x9a>
        a[bn] = addr;
    80003580:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003584:	8552                	mv	a0,s4
    80003586:	00001097          	auipc	ra,0x1
    8000358a:	ef0080e7          	jalr	-272(ra) # 80004476 <log_write>
    8000358e:	b7c9                	j	80003550 <bmap+0x9a>
  panic("bmap: out of range");
    80003590:	00005517          	auipc	a0,0x5
    80003594:	01850513          	addi	a0,a0,24 # 800085a8 <syscalls+0x118>
    80003598:	ffffd097          	auipc	ra,0xffffd
    8000359c:	fa6080e7          	jalr	-90(ra) # 8000053e <panic>

00000000800035a0 <iget>:
{
    800035a0:	7179                	addi	sp,sp,-48
    800035a2:	f406                	sd	ra,40(sp)
    800035a4:	f022                	sd	s0,32(sp)
    800035a6:	ec26                	sd	s1,24(sp)
    800035a8:	e84a                	sd	s2,16(sp)
    800035aa:	e44e                	sd	s3,8(sp)
    800035ac:	e052                	sd	s4,0(sp)
    800035ae:	1800                	addi	s0,sp,48
    800035b0:	89aa                	mv	s3,a0
    800035b2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800035b4:	0023c517          	auipc	a0,0x23c
    800035b8:	ae450513          	addi	a0,a0,-1308 # 8023f098 <itable>
    800035bc:	ffffd097          	auipc	ra,0xffffd
    800035c0:	716080e7          	jalr	1814(ra) # 80000cd2 <acquire>
  empty = 0;
    800035c4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800035c6:	0023c497          	auipc	s1,0x23c
    800035ca:	aea48493          	addi	s1,s1,-1302 # 8023f0b0 <itable+0x18>
    800035ce:	0023d697          	auipc	a3,0x23d
    800035d2:	57268693          	addi	a3,a3,1394 # 80240b40 <log>
    800035d6:	a039                	j	800035e4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800035d8:	02090b63          	beqz	s2,8000360e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800035dc:	08848493          	addi	s1,s1,136
    800035e0:	02d48a63          	beq	s1,a3,80003614 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800035e4:	449c                	lw	a5,8(s1)
    800035e6:	fef059e3          	blez	a5,800035d8 <iget+0x38>
    800035ea:	4098                	lw	a4,0(s1)
    800035ec:	ff3716e3          	bne	a4,s3,800035d8 <iget+0x38>
    800035f0:	40d8                	lw	a4,4(s1)
    800035f2:	ff4713e3          	bne	a4,s4,800035d8 <iget+0x38>
      ip->ref++;
    800035f6:	2785                	addiw	a5,a5,1
    800035f8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800035fa:	0023c517          	auipc	a0,0x23c
    800035fe:	a9e50513          	addi	a0,a0,-1378 # 8023f098 <itable>
    80003602:	ffffd097          	auipc	ra,0xffffd
    80003606:	784080e7          	jalr	1924(ra) # 80000d86 <release>
      return ip;
    8000360a:	8926                	mv	s2,s1
    8000360c:	a03d                	j	8000363a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000360e:	f7f9                	bnez	a5,800035dc <iget+0x3c>
    80003610:	8926                	mv	s2,s1
    80003612:	b7e9                	j	800035dc <iget+0x3c>
  if(empty == 0)
    80003614:	02090c63          	beqz	s2,8000364c <iget+0xac>
  ip->dev = dev;
    80003618:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000361c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003620:	4785                	li	a5,1
    80003622:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003626:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000362a:	0023c517          	auipc	a0,0x23c
    8000362e:	a6e50513          	addi	a0,a0,-1426 # 8023f098 <itable>
    80003632:	ffffd097          	auipc	ra,0xffffd
    80003636:	754080e7          	jalr	1876(ra) # 80000d86 <release>
}
    8000363a:	854a                	mv	a0,s2
    8000363c:	70a2                	ld	ra,40(sp)
    8000363e:	7402                	ld	s0,32(sp)
    80003640:	64e2                	ld	s1,24(sp)
    80003642:	6942                	ld	s2,16(sp)
    80003644:	69a2                	ld	s3,8(sp)
    80003646:	6a02                	ld	s4,0(sp)
    80003648:	6145                	addi	sp,sp,48
    8000364a:	8082                	ret
    panic("iget: no inodes");
    8000364c:	00005517          	auipc	a0,0x5
    80003650:	f7450513          	addi	a0,a0,-140 # 800085c0 <syscalls+0x130>
    80003654:	ffffd097          	auipc	ra,0xffffd
    80003658:	eea080e7          	jalr	-278(ra) # 8000053e <panic>

000000008000365c <fsinit>:
fsinit(int dev) {
    8000365c:	7179                	addi	sp,sp,-48
    8000365e:	f406                	sd	ra,40(sp)
    80003660:	f022                	sd	s0,32(sp)
    80003662:	ec26                	sd	s1,24(sp)
    80003664:	e84a                	sd	s2,16(sp)
    80003666:	e44e                	sd	s3,8(sp)
    80003668:	1800                	addi	s0,sp,48
    8000366a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000366c:	4585                	li	a1,1
    8000366e:	00000097          	auipc	ra,0x0
    80003672:	a4e080e7          	jalr	-1458(ra) # 800030bc <bread>
    80003676:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003678:	0023c997          	auipc	s3,0x23c
    8000367c:	a0098993          	addi	s3,s3,-1536 # 8023f078 <sb>
    80003680:	02000613          	li	a2,32
    80003684:	05850593          	addi	a1,a0,88
    80003688:	854e                	mv	a0,s3
    8000368a:	ffffd097          	auipc	ra,0xffffd
    8000368e:	7a0080e7          	jalr	1952(ra) # 80000e2a <memmove>
  brelse(bp);
    80003692:	8526                	mv	a0,s1
    80003694:	00000097          	auipc	ra,0x0
    80003698:	b58080e7          	jalr	-1192(ra) # 800031ec <brelse>
  if(sb.magic != FSMAGIC)
    8000369c:	0009a703          	lw	a4,0(s3)
    800036a0:	102037b7          	lui	a5,0x10203
    800036a4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800036a8:	02f71263          	bne	a4,a5,800036cc <fsinit+0x70>
  initlog(dev, &sb);
    800036ac:	0023c597          	auipc	a1,0x23c
    800036b0:	9cc58593          	addi	a1,a1,-1588 # 8023f078 <sb>
    800036b4:	854a                	mv	a0,s2
    800036b6:	00001097          	auipc	ra,0x1
    800036ba:	b42080e7          	jalr	-1214(ra) # 800041f8 <initlog>
}
    800036be:	70a2                	ld	ra,40(sp)
    800036c0:	7402                	ld	s0,32(sp)
    800036c2:	64e2                	ld	s1,24(sp)
    800036c4:	6942                	ld	s2,16(sp)
    800036c6:	69a2                	ld	s3,8(sp)
    800036c8:	6145                	addi	sp,sp,48
    800036ca:	8082                	ret
    panic("invalid file system");
    800036cc:	00005517          	auipc	a0,0x5
    800036d0:	f0450513          	addi	a0,a0,-252 # 800085d0 <syscalls+0x140>
    800036d4:	ffffd097          	auipc	ra,0xffffd
    800036d8:	e6a080e7          	jalr	-406(ra) # 8000053e <panic>

00000000800036dc <iinit>:
{
    800036dc:	7179                	addi	sp,sp,-48
    800036de:	f406                	sd	ra,40(sp)
    800036e0:	f022                	sd	s0,32(sp)
    800036e2:	ec26                	sd	s1,24(sp)
    800036e4:	e84a                	sd	s2,16(sp)
    800036e6:	e44e                	sd	s3,8(sp)
    800036e8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800036ea:	00005597          	auipc	a1,0x5
    800036ee:	efe58593          	addi	a1,a1,-258 # 800085e8 <syscalls+0x158>
    800036f2:	0023c517          	auipc	a0,0x23c
    800036f6:	9a650513          	addi	a0,a0,-1626 # 8023f098 <itable>
    800036fa:	ffffd097          	auipc	ra,0xffffd
    800036fe:	548080e7          	jalr	1352(ra) # 80000c42 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003702:	0023c497          	auipc	s1,0x23c
    80003706:	9be48493          	addi	s1,s1,-1602 # 8023f0c0 <itable+0x28>
    8000370a:	0023d997          	auipc	s3,0x23d
    8000370e:	44698993          	addi	s3,s3,1094 # 80240b50 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003712:	00005917          	auipc	s2,0x5
    80003716:	ede90913          	addi	s2,s2,-290 # 800085f0 <syscalls+0x160>
    8000371a:	85ca                	mv	a1,s2
    8000371c:	8526                	mv	a0,s1
    8000371e:	00001097          	auipc	ra,0x1
    80003722:	e3e080e7          	jalr	-450(ra) # 8000455c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003726:	08848493          	addi	s1,s1,136
    8000372a:	ff3498e3          	bne	s1,s3,8000371a <iinit+0x3e>
}
    8000372e:	70a2                	ld	ra,40(sp)
    80003730:	7402                	ld	s0,32(sp)
    80003732:	64e2                	ld	s1,24(sp)
    80003734:	6942                	ld	s2,16(sp)
    80003736:	69a2                	ld	s3,8(sp)
    80003738:	6145                	addi	sp,sp,48
    8000373a:	8082                	ret

000000008000373c <ialloc>:
{
    8000373c:	715d                	addi	sp,sp,-80
    8000373e:	e486                	sd	ra,72(sp)
    80003740:	e0a2                	sd	s0,64(sp)
    80003742:	fc26                	sd	s1,56(sp)
    80003744:	f84a                	sd	s2,48(sp)
    80003746:	f44e                	sd	s3,40(sp)
    80003748:	f052                	sd	s4,32(sp)
    8000374a:	ec56                	sd	s5,24(sp)
    8000374c:	e85a                	sd	s6,16(sp)
    8000374e:	e45e                	sd	s7,8(sp)
    80003750:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003752:	0023c717          	auipc	a4,0x23c
    80003756:	93272703          	lw	a4,-1742(a4) # 8023f084 <sb+0xc>
    8000375a:	4785                	li	a5,1
    8000375c:	04e7fa63          	bgeu	a5,a4,800037b0 <ialloc+0x74>
    80003760:	8aaa                	mv	s5,a0
    80003762:	8bae                	mv	s7,a1
    80003764:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003766:	0023ca17          	auipc	s4,0x23c
    8000376a:	912a0a13          	addi	s4,s4,-1774 # 8023f078 <sb>
    8000376e:	00048b1b          	sext.w	s6,s1
    80003772:	0044d793          	srli	a5,s1,0x4
    80003776:	018a2583          	lw	a1,24(s4)
    8000377a:	9dbd                	addw	a1,a1,a5
    8000377c:	8556                	mv	a0,s5
    8000377e:	00000097          	auipc	ra,0x0
    80003782:	93e080e7          	jalr	-1730(ra) # 800030bc <bread>
    80003786:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003788:	05850993          	addi	s3,a0,88
    8000378c:	00f4f793          	andi	a5,s1,15
    80003790:	079a                	slli	a5,a5,0x6
    80003792:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003794:	00099783          	lh	a5,0(s3)
    80003798:	c3a1                	beqz	a5,800037d8 <ialloc+0x9c>
    brelse(bp);
    8000379a:	00000097          	auipc	ra,0x0
    8000379e:	a52080e7          	jalr	-1454(ra) # 800031ec <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800037a2:	0485                	addi	s1,s1,1
    800037a4:	00ca2703          	lw	a4,12(s4)
    800037a8:	0004879b          	sext.w	a5,s1
    800037ac:	fce7e1e3          	bltu	a5,a4,8000376e <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800037b0:	00005517          	auipc	a0,0x5
    800037b4:	e4850513          	addi	a0,a0,-440 # 800085f8 <syscalls+0x168>
    800037b8:	ffffd097          	auipc	ra,0xffffd
    800037bc:	dd0080e7          	jalr	-560(ra) # 80000588 <printf>
  return 0;
    800037c0:	4501                	li	a0,0
}
    800037c2:	60a6                	ld	ra,72(sp)
    800037c4:	6406                	ld	s0,64(sp)
    800037c6:	74e2                	ld	s1,56(sp)
    800037c8:	7942                	ld	s2,48(sp)
    800037ca:	79a2                	ld	s3,40(sp)
    800037cc:	7a02                	ld	s4,32(sp)
    800037ce:	6ae2                	ld	s5,24(sp)
    800037d0:	6b42                	ld	s6,16(sp)
    800037d2:	6ba2                	ld	s7,8(sp)
    800037d4:	6161                	addi	sp,sp,80
    800037d6:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800037d8:	04000613          	li	a2,64
    800037dc:	4581                	li	a1,0
    800037de:	854e                	mv	a0,s3
    800037e0:	ffffd097          	auipc	ra,0xffffd
    800037e4:	5ee080e7          	jalr	1518(ra) # 80000dce <memset>
      dip->type = type;
    800037e8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800037ec:	854a                	mv	a0,s2
    800037ee:	00001097          	auipc	ra,0x1
    800037f2:	c88080e7          	jalr	-888(ra) # 80004476 <log_write>
      brelse(bp);
    800037f6:	854a                	mv	a0,s2
    800037f8:	00000097          	auipc	ra,0x0
    800037fc:	9f4080e7          	jalr	-1548(ra) # 800031ec <brelse>
      return iget(dev, inum);
    80003800:	85da                	mv	a1,s6
    80003802:	8556                	mv	a0,s5
    80003804:	00000097          	auipc	ra,0x0
    80003808:	d9c080e7          	jalr	-612(ra) # 800035a0 <iget>
    8000380c:	bf5d                	j	800037c2 <ialloc+0x86>

000000008000380e <iupdate>:
{
    8000380e:	1101                	addi	sp,sp,-32
    80003810:	ec06                	sd	ra,24(sp)
    80003812:	e822                	sd	s0,16(sp)
    80003814:	e426                	sd	s1,8(sp)
    80003816:	e04a                	sd	s2,0(sp)
    80003818:	1000                	addi	s0,sp,32
    8000381a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000381c:	415c                	lw	a5,4(a0)
    8000381e:	0047d79b          	srliw	a5,a5,0x4
    80003822:	0023c597          	auipc	a1,0x23c
    80003826:	86e5a583          	lw	a1,-1938(a1) # 8023f090 <sb+0x18>
    8000382a:	9dbd                	addw	a1,a1,a5
    8000382c:	4108                	lw	a0,0(a0)
    8000382e:	00000097          	auipc	ra,0x0
    80003832:	88e080e7          	jalr	-1906(ra) # 800030bc <bread>
    80003836:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003838:	05850793          	addi	a5,a0,88
    8000383c:	40c8                	lw	a0,4(s1)
    8000383e:	893d                	andi	a0,a0,15
    80003840:	051a                	slli	a0,a0,0x6
    80003842:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003844:	04449703          	lh	a4,68(s1)
    80003848:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    8000384c:	04649703          	lh	a4,70(s1)
    80003850:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003854:	04849703          	lh	a4,72(s1)
    80003858:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    8000385c:	04a49703          	lh	a4,74(s1)
    80003860:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003864:	44f8                	lw	a4,76(s1)
    80003866:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003868:	03400613          	li	a2,52
    8000386c:	05048593          	addi	a1,s1,80
    80003870:	0531                	addi	a0,a0,12
    80003872:	ffffd097          	auipc	ra,0xffffd
    80003876:	5b8080e7          	jalr	1464(ra) # 80000e2a <memmove>
  log_write(bp);
    8000387a:	854a                	mv	a0,s2
    8000387c:	00001097          	auipc	ra,0x1
    80003880:	bfa080e7          	jalr	-1030(ra) # 80004476 <log_write>
  brelse(bp);
    80003884:	854a                	mv	a0,s2
    80003886:	00000097          	auipc	ra,0x0
    8000388a:	966080e7          	jalr	-1690(ra) # 800031ec <brelse>
}
    8000388e:	60e2                	ld	ra,24(sp)
    80003890:	6442                	ld	s0,16(sp)
    80003892:	64a2                	ld	s1,8(sp)
    80003894:	6902                	ld	s2,0(sp)
    80003896:	6105                	addi	sp,sp,32
    80003898:	8082                	ret

000000008000389a <idup>:
{
    8000389a:	1101                	addi	sp,sp,-32
    8000389c:	ec06                	sd	ra,24(sp)
    8000389e:	e822                	sd	s0,16(sp)
    800038a0:	e426                	sd	s1,8(sp)
    800038a2:	1000                	addi	s0,sp,32
    800038a4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800038a6:	0023b517          	auipc	a0,0x23b
    800038aa:	7f250513          	addi	a0,a0,2034 # 8023f098 <itable>
    800038ae:	ffffd097          	auipc	ra,0xffffd
    800038b2:	424080e7          	jalr	1060(ra) # 80000cd2 <acquire>
  ip->ref++;
    800038b6:	449c                	lw	a5,8(s1)
    800038b8:	2785                	addiw	a5,a5,1
    800038ba:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800038bc:	0023b517          	auipc	a0,0x23b
    800038c0:	7dc50513          	addi	a0,a0,2012 # 8023f098 <itable>
    800038c4:	ffffd097          	auipc	ra,0xffffd
    800038c8:	4c2080e7          	jalr	1218(ra) # 80000d86 <release>
}
    800038cc:	8526                	mv	a0,s1
    800038ce:	60e2                	ld	ra,24(sp)
    800038d0:	6442                	ld	s0,16(sp)
    800038d2:	64a2                	ld	s1,8(sp)
    800038d4:	6105                	addi	sp,sp,32
    800038d6:	8082                	ret

00000000800038d8 <ilock>:
{
    800038d8:	1101                	addi	sp,sp,-32
    800038da:	ec06                	sd	ra,24(sp)
    800038dc:	e822                	sd	s0,16(sp)
    800038de:	e426                	sd	s1,8(sp)
    800038e0:	e04a                	sd	s2,0(sp)
    800038e2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800038e4:	c115                	beqz	a0,80003908 <ilock+0x30>
    800038e6:	84aa                	mv	s1,a0
    800038e8:	451c                	lw	a5,8(a0)
    800038ea:	00f05f63          	blez	a5,80003908 <ilock+0x30>
  acquiresleep(&ip->lock);
    800038ee:	0541                	addi	a0,a0,16
    800038f0:	00001097          	auipc	ra,0x1
    800038f4:	ca6080e7          	jalr	-858(ra) # 80004596 <acquiresleep>
  if(ip->valid == 0){
    800038f8:	40bc                	lw	a5,64(s1)
    800038fa:	cf99                	beqz	a5,80003918 <ilock+0x40>
}
    800038fc:	60e2                	ld	ra,24(sp)
    800038fe:	6442                	ld	s0,16(sp)
    80003900:	64a2                	ld	s1,8(sp)
    80003902:	6902                	ld	s2,0(sp)
    80003904:	6105                	addi	sp,sp,32
    80003906:	8082                	ret
    panic("ilock");
    80003908:	00005517          	auipc	a0,0x5
    8000390c:	d0850513          	addi	a0,a0,-760 # 80008610 <syscalls+0x180>
    80003910:	ffffd097          	auipc	ra,0xffffd
    80003914:	c2e080e7          	jalr	-978(ra) # 8000053e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003918:	40dc                	lw	a5,4(s1)
    8000391a:	0047d79b          	srliw	a5,a5,0x4
    8000391e:	0023b597          	auipc	a1,0x23b
    80003922:	7725a583          	lw	a1,1906(a1) # 8023f090 <sb+0x18>
    80003926:	9dbd                	addw	a1,a1,a5
    80003928:	4088                	lw	a0,0(s1)
    8000392a:	fffff097          	auipc	ra,0xfffff
    8000392e:	792080e7          	jalr	1938(ra) # 800030bc <bread>
    80003932:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003934:	05850593          	addi	a1,a0,88
    80003938:	40dc                	lw	a5,4(s1)
    8000393a:	8bbd                	andi	a5,a5,15
    8000393c:	079a                	slli	a5,a5,0x6
    8000393e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003940:	00059783          	lh	a5,0(a1)
    80003944:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003948:	00259783          	lh	a5,2(a1)
    8000394c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003950:	00459783          	lh	a5,4(a1)
    80003954:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003958:	00659783          	lh	a5,6(a1)
    8000395c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003960:	459c                	lw	a5,8(a1)
    80003962:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003964:	03400613          	li	a2,52
    80003968:	05b1                	addi	a1,a1,12
    8000396a:	05048513          	addi	a0,s1,80
    8000396e:	ffffd097          	auipc	ra,0xffffd
    80003972:	4bc080e7          	jalr	1212(ra) # 80000e2a <memmove>
    brelse(bp);
    80003976:	854a                	mv	a0,s2
    80003978:	00000097          	auipc	ra,0x0
    8000397c:	874080e7          	jalr	-1932(ra) # 800031ec <brelse>
    ip->valid = 1;
    80003980:	4785                	li	a5,1
    80003982:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003984:	04449783          	lh	a5,68(s1)
    80003988:	fbb5                	bnez	a5,800038fc <ilock+0x24>
      panic("ilock: no type");
    8000398a:	00005517          	auipc	a0,0x5
    8000398e:	c8e50513          	addi	a0,a0,-882 # 80008618 <syscalls+0x188>
    80003992:	ffffd097          	auipc	ra,0xffffd
    80003996:	bac080e7          	jalr	-1108(ra) # 8000053e <panic>

000000008000399a <iunlock>:
{
    8000399a:	1101                	addi	sp,sp,-32
    8000399c:	ec06                	sd	ra,24(sp)
    8000399e:	e822                	sd	s0,16(sp)
    800039a0:	e426                	sd	s1,8(sp)
    800039a2:	e04a                	sd	s2,0(sp)
    800039a4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800039a6:	c905                	beqz	a0,800039d6 <iunlock+0x3c>
    800039a8:	84aa                	mv	s1,a0
    800039aa:	01050913          	addi	s2,a0,16
    800039ae:	854a                	mv	a0,s2
    800039b0:	00001097          	auipc	ra,0x1
    800039b4:	c80080e7          	jalr	-896(ra) # 80004630 <holdingsleep>
    800039b8:	cd19                	beqz	a0,800039d6 <iunlock+0x3c>
    800039ba:	449c                	lw	a5,8(s1)
    800039bc:	00f05d63          	blez	a5,800039d6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800039c0:	854a                	mv	a0,s2
    800039c2:	00001097          	auipc	ra,0x1
    800039c6:	c2a080e7          	jalr	-982(ra) # 800045ec <releasesleep>
}
    800039ca:	60e2                	ld	ra,24(sp)
    800039cc:	6442                	ld	s0,16(sp)
    800039ce:	64a2                	ld	s1,8(sp)
    800039d0:	6902                	ld	s2,0(sp)
    800039d2:	6105                	addi	sp,sp,32
    800039d4:	8082                	ret
    panic("iunlock");
    800039d6:	00005517          	auipc	a0,0x5
    800039da:	c5250513          	addi	a0,a0,-942 # 80008628 <syscalls+0x198>
    800039de:	ffffd097          	auipc	ra,0xffffd
    800039e2:	b60080e7          	jalr	-1184(ra) # 8000053e <panic>

00000000800039e6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800039e6:	7179                	addi	sp,sp,-48
    800039e8:	f406                	sd	ra,40(sp)
    800039ea:	f022                	sd	s0,32(sp)
    800039ec:	ec26                	sd	s1,24(sp)
    800039ee:	e84a                	sd	s2,16(sp)
    800039f0:	e44e                	sd	s3,8(sp)
    800039f2:	e052                	sd	s4,0(sp)
    800039f4:	1800                	addi	s0,sp,48
    800039f6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800039f8:	05050493          	addi	s1,a0,80
    800039fc:	08050913          	addi	s2,a0,128
    80003a00:	a021                	j	80003a08 <itrunc+0x22>
    80003a02:	0491                	addi	s1,s1,4
    80003a04:	01248d63          	beq	s1,s2,80003a1e <itrunc+0x38>
    if(ip->addrs[i]){
    80003a08:	408c                	lw	a1,0(s1)
    80003a0a:	dde5                	beqz	a1,80003a02 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003a0c:	0009a503          	lw	a0,0(s3)
    80003a10:	00000097          	auipc	ra,0x0
    80003a14:	8f2080e7          	jalr	-1806(ra) # 80003302 <bfree>
      ip->addrs[i] = 0;
    80003a18:	0004a023          	sw	zero,0(s1)
    80003a1c:	b7dd                	j	80003a02 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003a1e:	0809a583          	lw	a1,128(s3)
    80003a22:	e185                	bnez	a1,80003a42 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003a24:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003a28:	854e                	mv	a0,s3
    80003a2a:	00000097          	auipc	ra,0x0
    80003a2e:	de4080e7          	jalr	-540(ra) # 8000380e <iupdate>
}
    80003a32:	70a2                	ld	ra,40(sp)
    80003a34:	7402                	ld	s0,32(sp)
    80003a36:	64e2                	ld	s1,24(sp)
    80003a38:	6942                	ld	s2,16(sp)
    80003a3a:	69a2                	ld	s3,8(sp)
    80003a3c:	6a02                	ld	s4,0(sp)
    80003a3e:	6145                	addi	sp,sp,48
    80003a40:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003a42:	0009a503          	lw	a0,0(s3)
    80003a46:	fffff097          	auipc	ra,0xfffff
    80003a4a:	676080e7          	jalr	1654(ra) # 800030bc <bread>
    80003a4e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003a50:	05850493          	addi	s1,a0,88
    80003a54:	45850913          	addi	s2,a0,1112
    80003a58:	a021                	j	80003a60 <itrunc+0x7a>
    80003a5a:	0491                	addi	s1,s1,4
    80003a5c:	01248b63          	beq	s1,s2,80003a72 <itrunc+0x8c>
      if(a[j])
    80003a60:	408c                	lw	a1,0(s1)
    80003a62:	dde5                	beqz	a1,80003a5a <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003a64:	0009a503          	lw	a0,0(s3)
    80003a68:	00000097          	auipc	ra,0x0
    80003a6c:	89a080e7          	jalr	-1894(ra) # 80003302 <bfree>
    80003a70:	b7ed                	j	80003a5a <itrunc+0x74>
    brelse(bp);
    80003a72:	8552                	mv	a0,s4
    80003a74:	fffff097          	auipc	ra,0xfffff
    80003a78:	778080e7          	jalr	1912(ra) # 800031ec <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003a7c:	0809a583          	lw	a1,128(s3)
    80003a80:	0009a503          	lw	a0,0(s3)
    80003a84:	00000097          	auipc	ra,0x0
    80003a88:	87e080e7          	jalr	-1922(ra) # 80003302 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003a8c:	0809a023          	sw	zero,128(s3)
    80003a90:	bf51                	j	80003a24 <itrunc+0x3e>

0000000080003a92 <iput>:
{
    80003a92:	1101                	addi	sp,sp,-32
    80003a94:	ec06                	sd	ra,24(sp)
    80003a96:	e822                	sd	s0,16(sp)
    80003a98:	e426                	sd	s1,8(sp)
    80003a9a:	e04a                	sd	s2,0(sp)
    80003a9c:	1000                	addi	s0,sp,32
    80003a9e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003aa0:	0023b517          	auipc	a0,0x23b
    80003aa4:	5f850513          	addi	a0,a0,1528 # 8023f098 <itable>
    80003aa8:	ffffd097          	auipc	ra,0xffffd
    80003aac:	22a080e7          	jalr	554(ra) # 80000cd2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ab0:	4498                	lw	a4,8(s1)
    80003ab2:	4785                	li	a5,1
    80003ab4:	02f70363          	beq	a4,a5,80003ada <iput+0x48>
  ip->ref--;
    80003ab8:	449c                	lw	a5,8(s1)
    80003aba:	37fd                	addiw	a5,a5,-1
    80003abc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003abe:	0023b517          	auipc	a0,0x23b
    80003ac2:	5da50513          	addi	a0,a0,1498 # 8023f098 <itable>
    80003ac6:	ffffd097          	auipc	ra,0xffffd
    80003aca:	2c0080e7          	jalr	704(ra) # 80000d86 <release>
}
    80003ace:	60e2                	ld	ra,24(sp)
    80003ad0:	6442                	ld	s0,16(sp)
    80003ad2:	64a2                	ld	s1,8(sp)
    80003ad4:	6902                	ld	s2,0(sp)
    80003ad6:	6105                	addi	sp,sp,32
    80003ad8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ada:	40bc                	lw	a5,64(s1)
    80003adc:	dff1                	beqz	a5,80003ab8 <iput+0x26>
    80003ade:	04a49783          	lh	a5,74(s1)
    80003ae2:	fbf9                	bnez	a5,80003ab8 <iput+0x26>
    acquiresleep(&ip->lock);
    80003ae4:	01048913          	addi	s2,s1,16
    80003ae8:	854a                	mv	a0,s2
    80003aea:	00001097          	auipc	ra,0x1
    80003aee:	aac080e7          	jalr	-1364(ra) # 80004596 <acquiresleep>
    release(&itable.lock);
    80003af2:	0023b517          	auipc	a0,0x23b
    80003af6:	5a650513          	addi	a0,a0,1446 # 8023f098 <itable>
    80003afa:	ffffd097          	auipc	ra,0xffffd
    80003afe:	28c080e7          	jalr	652(ra) # 80000d86 <release>
    itrunc(ip);
    80003b02:	8526                	mv	a0,s1
    80003b04:	00000097          	auipc	ra,0x0
    80003b08:	ee2080e7          	jalr	-286(ra) # 800039e6 <itrunc>
    ip->type = 0;
    80003b0c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003b10:	8526                	mv	a0,s1
    80003b12:	00000097          	auipc	ra,0x0
    80003b16:	cfc080e7          	jalr	-772(ra) # 8000380e <iupdate>
    ip->valid = 0;
    80003b1a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003b1e:	854a                	mv	a0,s2
    80003b20:	00001097          	auipc	ra,0x1
    80003b24:	acc080e7          	jalr	-1332(ra) # 800045ec <releasesleep>
    acquire(&itable.lock);
    80003b28:	0023b517          	auipc	a0,0x23b
    80003b2c:	57050513          	addi	a0,a0,1392 # 8023f098 <itable>
    80003b30:	ffffd097          	auipc	ra,0xffffd
    80003b34:	1a2080e7          	jalr	418(ra) # 80000cd2 <acquire>
    80003b38:	b741                	j	80003ab8 <iput+0x26>

0000000080003b3a <iunlockput>:
{
    80003b3a:	1101                	addi	sp,sp,-32
    80003b3c:	ec06                	sd	ra,24(sp)
    80003b3e:	e822                	sd	s0,16(sp)
    80003b40:	e426                	sd	s1,8(sp)
    80003b42:	1000                	addi	s0,sp,32
    80003b44:	84aa                	mv	s1,a0
  iunlock(ip);
    80003b46:	00000097          	auipc	ra,0x0
    80003b4a:	e54080e7          	jalr	-428(ra) # 8000399a <iunlock>
  iput(ip);
    80003b4e:	8526                	mv	a0,s1
    80003b50:	00000097          	auipc	ra,0x0
    80003b54:	f42080e7          	jalr	-190(ra) # 80003a92 <iput>
}
    80003b58:	60e2                	ld	ra,24(sp)
    80003b5a:	6442                	ld	s0,16(sp)
    80003b5c:	64a2                	ld	s1,8(sp)
    80003b5e:	6105                	addi	sp,sp,32
    80003b60:	8082                	ret

0000000080003b62 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003b62:	1141                	addi	sp,sp,-16
    80003b64:	e422                	sd	s0,8(sp)
    80003b66:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003b68:	411c                	lw	a5,0(a0)
    80003b6a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003b6c:	415c                	lw	a5,4(a0)
    80003b6e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003b70:	04451783          	lh	a5,68(a0)
    80003b74:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003b78:	04a51783          	lh	a5,74(a0)
    80003b7c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003b80:	04c56783          	lwu	a5,76(a0)
    80003b84:	e99c                	sd	a5,16(a1)
}
    80003b86:	6422                	ld	s0,8(sp)
    80003b88:	0141                	addi	sp,sp,16
    80003b8a:	8082                	ret

0000000080003b8c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b8c:	457c                	lw	a5,76(a0)
    80003b8e:	0ed7e963          	bltu	a5,a3,80003c80 <readi+0xf4>
{
    80003b92:	7159                	addi	sp,sp,-112
    80003b94:	f486                	sd	ra,104(sp)
    80003b96:	f0a2                	sd	s0,96(sp)
    80003b98:	eca6                	sd	s1,88(sp)
    80003b9a:	e8ca                	sd	s2,80(sp)
    80003b9c:	e4ce                	sd	s3,72(sp)
    80003b9e:	e0d2                	sd	s4,64(sp)
    80003ba0:	fc56                	sd	s5,56(sp)
    80003ba2:	f85a                	sd	s6,48(sp)
    80003ba4:	f45e                	sd	s7,40(sp)
    80003ba6:	f062                	sd	s8,32(sp)
    80003ba8:	ec66                	sd	s9,24(sp)
    80003baa:	e86a                	sd	s10,16(sp)
    80003bac:	e46e                	sd	s11,8(sp)
    80003bae:	1880                	addi	s0,sp,112
    80003bb0:	8b2a                	mv	s6,a0
    80003bb2:	8bae                	mv	s7,a1
    80003bb4:	8a32                	mv	s4,a2
    80003bb6:	84b6                	mv	s1,a3
    80003bb8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003bba:	9f35                	addw	a4,a4,a3
    return 0;
    80003bbc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003bbe:	0ad76063          	bltu	a4,a3,80003c5e <readi+0xd2>
  if(off + n > ip->size)
    80003bc2:	00e7f463          	bgeu	a5,a4,80003bca <readi+0x3e>
    n = ip->size - off;
    80003bc6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003bca:	0a0a8963          	beqz	s5,80003c7c <readi+0xf0>
    80003bce:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bd0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003bd4:	5c7d                	li	s8,-1
    80003bd6:	a82d                	j	80003c10 <readi+0x84>
    80003bd8:	020d1d93          	slli	s11,s10,0x20
    80003bdc:	020ddd93          	srli	s11,s11,0x20
    80003be0:	05890793          	addi	a5,s2,88
    80003be4:	86ee                	mv	a3,s11
    80003be6:	963e                	add	a2,a2,a5
    80003be8:	85d2                	mv	a1,s4
    80003bea:	855e                	mv	a0,s7
    80003bec:	fffff097          	auipc	ra,0xfffff
    80003bf0:	ade080e7          	jalr	-1314(ra) # 800026ca <either_copyout>
    80003bf4:	05850d63          	beq	a0,s8,80003c4e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003bf8:	854a                	mv	a0,s2
    80003bfa:	fffff097          	auipc	ra,0xfffff
    80003bfe:	5f2080e7          	jalr	1522(ra) # 800031ec <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003c02:	013d09bb          	addw	s3,s10,s3
    80003c06:	009d04bb          	addw	s1,s10,s1
    80003c0a:	9a6e                	add	s4,s4,s11
    80003c0c:	0559f763          	bgeu	s3,s5,80003c5a <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003c10:	00a4d59b          	srliw	a1,s1,0xa
    80003c14:	855a                	mv	a0,s6
    80003c16:	00000097          	auipc	ra,0x0
    80003c1a:	8a0080e7          	jalr	-1888(ra) # 800034b6 <bmap>
    80003c1e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003c22:	cd85                	beqz	a1,80003c5a <readi+0xce>
    bp = bread(ip->dev, addr);
    80003c24:	000b2503          	lw	a0,0(s6)
    80003c28:	fffff097          	auipc	ra,0xfffff
    80003c2c:	494080e7          	jalr	1172(ra) # 800030bc <bread>
    80003c30:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c32:	3ff4f613          	andi	a2,s1,1023
    80003c36:	40cc87bb          	subw	a5,s9,a2
    80003c3a:	413a873b          	subw	a4,s5,s3
    80003c3e:	8d3e                	mv	s10,a5
    80003c40:	2781                	sext.w	a5,a5
    80003c42:	0007069b          	sext.w	a3,a4
    80003c46:	f8f6f9e3          	bgeu	a3,a5,80003bd8 <readi+0x4c>
    80003c4a:	8d3a                	mv	s10,a4
    80003c4c:	b771                	j	80003bd8 <readi+0x4c>
      brelse(bp);
    80003c4e:	854a                	mv	a0,s2
    80003c50:	fffff097          	auipc	ra,0xfffff
    80003c54:	59c080e7          	jalr	1436(ra) # 800031ec <brelse>
      tot = -1;
    80003c58:	59fd                	li	s3,-1
  }
  return tot;
    80003c5a:	0009851b          	sext.w	a0,s3
}
    80003c5e:	70a6                	ld	ra,104(sp)
    80003c60:	7406                	ld	s0,96(sp)
    80003c62:	64e6                	ld	s1,88(sp)
    80003c64:	6946                	ld	s2,80(sp)
    80003c66:	69a6                	ld	s3,72(sp)
    80003c68:	6a06                	ld	s4,64(sp)
    80003c6a:	7ae2                	ld	s5,56(sp)
    80003c6c:	7b42                	ld	s6,48(sp)
    80003c6e:	7ba2                	ld	s7,40(sp)
    80003c70:	7c02                	ld	s8,32(sp)
    80003c72:	6ce2                	ld	s9,24(sp)
    80003c74:	6d42                	ld	s10,16(sp)
    80003c76:	6da2                	ld	s11,8(sp)
    80003c78:	6165                	addi	sp,sp,112
    80003c7a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003c7c:	89d6                	mv	s3,s5
    80003c7e:	bff1                	j	80003c5a <readi+0xce>
    return 0;
    80003c80:	4501                	li	a0,0
}
    80003c82:	8082                	ret

0000000080003c84 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c84:	457c                	lw	a5,76(a0)
    80003c86:	10d7e863          	bltu	a5,a3,80003d96 <writei+0x112>
{
    80003c8a:	7159                	addi	sp,sp,-112
    80003c8c:	f486                	sd	ra,104(sp)
    80003c8e:	f0a2                	sd	s0,96(sp)
    80003c90:	eca6                	sd	s1,88(sp)
    80003c92:	e8ca                	sd	s2,80(sp)
    80003c94:	e4ce                	sd	s3,72(sp)
    80003c96:	e0d2                	sd	s4,64(sp)
    80003c98:	fc56                	sd	s5,56(sp)
    80003c9a:	f85a                	sd	s6,48(sp)
    80003c9c:	f45e                	sd	s7,40(sp)
    80003c9e:	f062                	sd	s8,32(sp)
    80003ca0:	ec66                	sd	s9,24(sp)
    80003ca2:	e86a                	sd	s10,16(sp)
    80003ca4:	e46e                	sd	s11,8(sp)
    80003ca6:	1880                	addi	s0,sp,112
    80003ca8:	8aaa                	mv	s5,a0
    80003caa:	8bae                	mv	s7,a1
    80003cac:	8a32                	mv	s4,a2
    80003cae:	8936                	mv	s2,a3
    80003cb0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003cb2:	00e687bb          	addw	a5,a3,a4
    80003cb6:	0ed7e263          	bltu	a5,a3,80003d9a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003cba:	00043737          	lui	a4,0x43
    80003cbe:	0ef76063          	bltu	a4,a5,80003d9e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003cc2:	0c0b0863          	beqz	s6,80003d92 <writei+0x10e>
    80003cc6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003cc8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003ccc:	5c7d                	li	s8,-1
    80003cce:	a091                	j	80003d12 <writei+0x8e>
    80003cd0:	020d1d93          	slli	s11,s10,0x20
    80003cd4:	020ddd93          	srli	s11,s11,0x20
    80003cd8:	05848793          	addi	a5,s1,88
    80003cdc:	86ee                	mv	a3,s11
    80003cde:	8652                	mv	a2,s4
    80003ce0:	85de                	mv	a1,s7
    80003ce2:	953e                	add	a0,a0,a5
    80003ce4:	fffff097          	auipc	ra,0xfffff
    80003ce8:	a3c080e7          	jalr	-1476(ra) # 80002720 <either_copyin>
    80003cec:	07850263          	beq	a0,s8,80003d50 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003cf0:	8526                	mv	a0,s1
    80003cf2:	00000097          	auipc	ra,0x0
    80003cf6:	784080e7          	jalr	1924(ra) # 80004476 <log_write>
    brelse(bp);
    80003cfa:	8526                	mv	a0,s1
    80003cfc:	fffff097          	auipc	ra,0xfffff
    80003d00:	4f0080e7          	jalr	1264(ra) # 800031ec <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d04:	013d09bb          	addw	s3,s10,s3
    80003d08:	012d093b          	addw	s2,s10,s2
    80003d0c:	9a6e                	add	s4,s4,s11
    80003d0e:	0569f663          	bgeu	s3,s6,80003d5a <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003d12:	00a9559b          	srliw	a1,s2,0xa
    80003d16:	8556                	mv	a0,s5
    80003d18:	fffff097          	auipc	ra,0xfffff
    80003d1c:	79e080e7          	jalr	1950(ra) # 800034b6 <bmap>
    80003d20:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003d24:	c99d                	beqz	a1,80003d5a <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003d26:	000aa503          	lw	a0,0(s5)
    80003d2a:	fffff097          	auipc	ra,0xfffff
    80003d2e:	392080e7          	jalr	914(ra) # 800030bc <bread>
    80003d32:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d34:	3ff97513          	andi	a0,s2,1023
    80003d38:	40ac87bb          	subw	a5,s9,a0
    80003d3c:	413b073b          	subw	a4,s6,s3
    80003d40:	8d3e                	mv	s10,a5
    80003d42:	2781                	sext.w	a5,a5
    80003d44:	0007069b          	sext.w	a3,a4
    80003d48:	f8f6f4e3          	bgeu	a3,a5,80003cd0 <writei+0x4c>
    80003d4c:	8d3a                	mv	s10,a4
    80003d4e:	b749                	j	80003cd0 <writei+0x4c>
      brelse(bp);
    80003d50:	8526                	mv	a0,s1
    80003d52:	fffff097          	auipc	ra,0xfffff
    80003d56:	49a080e7          	jalr	1178(ra) # 800031ec <brelse>
  }

  if(off > ip->size)
    80003d5a:	04caa783          	lw	a5,76(s5)
    80003d5e:	0127f463          	bgeu	a5,s2,80003d66 <writei+0xe2>
    ip->size = off;
    80003d62:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003d66:	8556                	mv	a0,s5
    80003d68:	00000097          	auipc	ra,0x0
    80003d6c:	aa6080e7          	jalr	-1370(ra) # 8000380e <iupdate>

  return tot;
    80003d70:	0009851b          	sext.w	a0,s3
}
    80003d74:	70a6                	ld	ra,104(sp)
    80003d76:	7406                	ld	s0,96(sp)
    80003d78:	64e6                	ld	s1,88(sp)
    80003d7a:	6946                	ld	s2,80(sp)
    80003d7c:	69a6                	ld	s3,72(sp)
    80003d7e:	6a06                	ld	s4,64(sp)
    80003d80:	7ae2                	ld	s5,56(sp)
    80003d82:	7b42                	ld	s6,48(sp)
    80003d84:	7ba2                	ld	s7,40(sp)
    80003d86:	7c02                	ld	s8,32(sp)
    80003d88:	6ce2                	ld	s9,24(sp)
    80003d8a:	6d42                	ld	s10,16(sp)
    80003d8c:	6da2                	ld	s11,8(sp)
    80003d8e:	6165                	addi	sp,sp,112
    80003d90:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d92:	89da                	mv	s3,s6
    80003d94:	bfc9                	j	80003d66 <writei+0xe2>
    return -1;
    80003d96:	557d                	li	a0,-1
}
    80003d98:	8082                	ret
    return -1;
    80003d9a:	557d                	li	a0,-1
    80003d9c:	bfe1                	j	80003d74 <writei+0xf0>
    return -1;
    80003d9e:	557d                	li	a0,-1
    80003da0:	bfd1                	j	80003d74 <writei+0xf0>

0000000080003da2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003da2:	1141                	addi	sp,sp,-16
    80003da4:	e406                	sd	ra,8(sp)
    80003da6:	e022                	sd	s0,0(sp)
    80003da8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003daa:	4639                	li	a2,14
    80003dac:	ffffd097          	auipc	ra,0xffffd
    80003db0:	0f2080e7          	jalr	242(ra) # 80000e9e <strncmp>
}
    80003db4:	60a2                	ld	ra,8(sp)
    80003db6:	6402                	ld	s0,0(sp)
    80003db8:	0141                	addi	sp,sp,16
    80003dba:	8082                	ret

0000000080003dbc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003dbc:	7139                	addi	sp,sp,-64
    80003dbe:	fc06                	sd	ra,56(sp)
    80003dc0:	f822                	sd	s0,48(sp)
    80003dc2:	f426                	sd	s1,40(sp)
    80003dc4:	f04a                	sd	s2,32(sp)
    80003dc6:	ec4e                	sd	s3,24(sp)
    80003dc8:	e852                	sd	s4,16(sp)
    80003dca:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003dcc:	04451703          	lh	a4,68(a0)
    80003dd0:	4785                	li	a5,1
    80003dd2:	00f71a63          	bne	a4,a5,80003de6 <dirlookup+0x2a>
    80003dd6:	892a                	mv	s2,a0
    80003dd8:	89ae                	mv	s3,a1
    80003dda:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ddc:	457c                	lw	a5,76(a0)
    80003dde:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003de0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003de2:	e79d                	bnez	a5,80003e10 <dirlookup+0x54>
    80003de4:	a8a5                	j	80003e5c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003de6:	00005517          	auipc	a0,0x5
    80003dea:	84a50513          	addi	a0,a0,-1974 # 80008630 <syscalls+0x1a0>
    80003dee:	ffffc097          	auipc	ra,0xffffc
    80003df2:	750080e7          	jalr	1872(ra) # 8000053e <panic>
      panic("dirlookup read");
    80003df6:	00005517          	auipc	a0,0x5
    80003dfa:	85250513          	addi	a0,a0,-1966 # 80008648 <syscalls+0x1b8>
    80003dfe:	ffffc097          	auipc	ra,0xffffc
    80003e02:	740080e7          	jalr	1856(ra) # 8000053e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e06:	24c1                	addiw	s1,s1,16
    80003e08:	04c92783          	lw	a5,76(s2)
    80003e0c:	04f4f763          	bgeu	s1,a5,80003e5a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e10:	4741                	li	a4,16
    80003e12:	86a6                	mv	a3,s1
    80003e14:	fc040613          	addi	a2,s0,-64
    80003e18:	4581                	li	a1,0
    80003e1a:	854a                	mv	a0,s2
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	d70080e7          	jalr	-656(ra) # 80003b8c <readi>
    80003e24:	47c1                	li	a5,16
    80003e26:	fcf518e3          	bne	a0,a5,80003df6 <dirlookup+0x3a>
    if(de.inum == 0)
    80003e2a:	fc045783          	lhu	a5,-64(s0)
    80003e2e:	dfe1                	beqz	a5,80003e06 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003e30:	fc240593          	addi	a1,s0,-62
    80003e34:	854e                	mv	a0,s3
    80003e36:	00000097          	auipc	ra,0x0
    80003e3a:	f6c080e7          	jalr	-148(ra) # 80003da2 <namecmp>
    80003e3e:	f561                	bnez	a0,80003e06 <dirlookup+0x4a>
      if(poff)
    80003e40:	000a0463          	beqz	s4,80003e48 <dirlookup+0x8c>
        *poff = off;
    80003e44:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003e48:	fc045583          	lhu	a1,-64(s0)
    80003e4c:	00092503          	lw	a0,0(s2)
    80003e50:	fffff097          	auipc	ra,0xfffff
    80003e54:	750080e7          	jalr	1872(ra) # 800035a0 <iget>
    80003e58:	a011                	j	80003e5c <dirlookup+0xa0>
  return 0;
    80003e5a:	4501                	li	a0,0
}
    80003e5c:	70e2                	ld	ra,56(sp)
    80003e5e:	7442                	ld	s0,48(sp)
    80003e60:	74a2                	ld	s1,40(sp)
    80003e62:	7902                	ld	s2,32(sp)
    80003e64:	69e2                	ld	s3,24(sp)
    80003e66:	6a42                	ld	s4,16(sp)
    80003e68:	6121                	addi	sp,sp,64
    80003e6a:	8082                	ret

0000000080003e6c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003e6c:	711d                	addi	sp,sp,-96
    80003e6e:	ec86                	sd	ra,88(sp)
    80003e70:	e8a2                	sd	s0,80(sp)
    80003e72:	e4a6                	sd	s1,72(sp)
    80003e74:	e0ca                	sd	s2,64(sp)
    80003e76:	fc4e                	sd	s3,56(sp)
    80003e78:	f852                	sd	s4,48(sp)
    80003e7a:	f456                	sd	s5,40(sp)
    80003e7c:	f05a                	sd	s6,32(sp)
    80003e7e:	ec5e                	sd	s7,24(sp)
    80003e80:	e862                	sd	s8,16(sp)
    80003e82:	e466                	sd	s9,8(sp)
    80003e84:	1080                	addi	s0,sp,96
    80003e86:	84aa                	mv	s1,a0
    80003e88:	8aae                	mv	s5,a1
    80003e8a:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003e8c:	00054703          	lbu	a4,0(a0)
    80003e90:	02f00793          	li	a5,47
    80003e94:	02f70363          	beq	a4,a5,80003eba <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003e98:	ffffe097          	auipc	ra,0xffffe
    80003e9c:	d7e080e7          	jalr	-642(ra) # 80001c16 <myproc>
    80003ea0:	15053503          	ld	a0,336(a0)
    80003ea4:	00000097          	auipc	ra,0x0
    80003ea8:	9f6080e7          	jalr	-1546(ra) # 8000389a <idup>
    80003eac:	89aa                	mv	s3,a0
  while(*path == '/')
    80003eae:	02f00913          	li	s2,47
  len = path - s;
    80003eb2:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003eb4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003eb6:	4b85                	li	s7,1
    80003eb8:	a865                	j	80003f70 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003eba:	4585                	li	a1,1
    80003ebc:	4505                	li	a0,1
    80003ebe:	fffff097          	auipc	ra,0xfffff
    80003ec2:	6e2080e7          	jalr	1762(ra) # 800035a0 <iget>
    80003ec6:	89aa                	mv	s3,a0
    80003ec8:	b7dd                	j	80003eae <namex+0x42>
      iunlockput(ip);
    80003eca:	854e                	mv	a0,s3
    80003ecc:	00000097          	auipc	ra,0x0
    80003ed0:	c6e080e7          	jalr	-914(ra) # 80003b3a <iunlockput>
      return 0;
    80003ed4:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003ed6:	854e                	mv	a0,s3
    80003ed8:	60e6                	ld	ra,88(sp)
    80003eda:	6446                	ld	s0,80(sp)
    80003edc:	64a6                	ld	s1,72(sp)
    80003ede:	6906                	ld	s2,64(sp)
    80003ee0:	79e2                	ld	s3,56(sp)
    80003ee2:	7a42                	ld	s4,48(sp)
    80003ee4:	7aa2                	ld	s5,40(sp)
    80003ee6:	7b02                	ld	s6,32(sp)
    80003ee8:	6be2                	ld	s7,24(sp)
    80003eea:	6c42                	ld	s8,16(sp)
    80003eec:	6ca2                	ld	s9,8(sp)
    80003eee:	6125                	addi	sp,sp,96
    80003ef0:	8082                	ret
      iunlock(ip);
    80003ef2:	854e                	mv	a0,s3
    80003ef4:	00000097          	auipc	ra,0x0
    80003ef8:	aa6080e7          	jalr	-1370(ra) # 8000399a <iunlock>
      return ip;
    80003efc:	bfe9                	j	80003ed6 <namex+0x6a>
      iunlockput(ip);
    80003efe:	854e                	mv	a0,s3
    80003f00:	00000097          	auipc	ra,0x0
    80003f04:	c3a080e7          	jalr	-966(ra) # 80003b3a <iunlockput>
      return 0;
    80003f08:	89e6                	mv	s3,s9
    80003f0a:	b7f1                	j	80003ed6 <namex+0x6a>
  len = path - s;
    80003f0c:	40b48633          	sub	a2,s1,a1
    80003f10:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003f14:	099c5463          	bge	s8,s9,80003f9c <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003f18:	4639                	li	a2,14
    80003f1a:	8552                	mv	a0,s4
    80003f1c:	ffffd097          	auipc	ra,0xffffd
    80003f20:	f0e080e7          	jalr	-242(ra) # 80000e2a <memmove>
  while(*path == '/')
    80003f24:	0004c783          	lbu	a5,0(s1)
    80003f28:	01279763          	bne	a5,s2,80003f36 <namex+0xca>
    path++;
    80003f2c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003f2e:	0004c783          	lbu	a5,0(s1)
    80003f32:	ff278de3          	beq	a5,s2,80003f2c <namex+0xc0>
    ilock(ip);
    80003f36:	854e                	mv	a0,s3
    80003f38:	00000097          	auipc	ra,0x0
    80003f3c:	9a0080e7          	jalr	-1632(ra) # 800038d8 <ilock>
    if(ip->type != T_DIR){
    80003f40:	04499783          	lh	a5,68(s3)
    80003f44:	f97793e3          	bne	a5,s7,80003eca <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003f48:	000a8563          	beqz	s5,80003f52 <namex+0xe6>
    80003f4c:	0004c783          	lbu	a5,0(s1)
    80003f50:	d3cd                	beqz	a5,80003ef2 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003f52:	865a                	mv	a2,s6
    80003f54:	85d2                	mv	a1,s4
    80003f56:	854e                	mv	a0,s3
    80003f58:	00000097          	auipc	ra,0x0
    80003f5c:	e64080e7          	jalr	-412(ra) # 80003dbc <dirlookup>
    80003f60:	8caa                	mv	s9,a0
    80003f62:	dd51                	beqz	a0,80003efe <namex+0x92>
    iunlockput(ip);
    80003f64:	854e                	mv	a0,s3
    80003f66:	00000097          	auipc	ra,0x0
    80003f6a:	bd4080e7          	jalr	-1068(ra) # 80003b3a <iunlockput>
    ip = next;
    80003f6e:	89e6                	mv	s3,s9
  while(*path == '/')
    80003f70:	0004c783          	lbu	a5,0(s1)
    80003f74:	05279763          	bne	a5,s2,80003fc2 <namex+0x156>
    path++;
    80003f78:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003f7a:	0004c783          	lbu	a5,0(s1)
    80003f7e:	ff278de3          	beq	a5,s2,80003f78 <namex+0x10c>
  if(*path == 0)
    80003f82:	c79d                	beqz	a5,80003fb0 <namex+0x144>
    path++;
    80003f84:	85a6                	mv	a1,s1
  len = path - s;
    80003f86:	8cda                	mv	s9,s6
    80003f88:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003f8a:	01278963          	beq	a5,s2,80003f9c <namex+0x130>
    80003f8e:	dfbd                	beqz	a5,80003f0c <namex+0xa0>
    path++;
    80003f90:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003f92:	0004c783          	lbu	a5,0(s1)
    80003f96:	ff279ce3          	bne	a5,s2,80003f8e <namex+0x122>
    80003f9a:	bf8d                	j	80003f0c <namex+0xa0>
    memmove(name, s, len);
    80003f9c:	2601                	sext.w	a2,a2
    80003f9e:	8552                	mv	a0,s4
    80003fa0:	ffffd097          	auipc	ra,0xffffd
    80003fa4:	e8a080e7          	jalr	-374(ra) # 80000e2a <memmove>
    name[len] = 0;
    80003fa8:	9cd2                	add	s9,s9,s4
    80003faa:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003fae:	bf9d                	j	80003f24 <namex+0xb8>
  if(nameiparent){
    80003fb0:	f20a83e3          	beqz	s5,80003ed6 <namex+0x6a>
    iput(ip);
    80003fb4:	854e                	mv	a0,s3
    80003fb6:	00000097          	auipc	ra,0x0
    80003fba:	adc080e7          	jalr	-1316(ra) # 80003a92 <iput>
    return 0;
    80003fbe:	4981                	li	s3,0
    80003fc0:	bf19                	j	80003ed6 <namex+0x6a>
  if(*path == 0)
    80003fc2:	d7fd                	beqz	a5,80003fb0 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003fc4:	0004c783          	lbu	a5,0(s1)
    80003fc8:	85a6                	mv	a1,s1
    80003fca:	b7d1                	j	80003f8e <namex+0x122>

0000000080003fcc <dirlink>:
{
    80003fcc:	7139                	addi	sp,sp,-64
    80003fce:	fc06                	sd	ra,56(sp)
    80003fd0:	f822                	sd	s0,48(sp)
    80003fd2:	f426                	sd	s1,40(sp)
    80003fd4:	f04a                	sd	s2,32(sp)
    80003fd6:	ec4e                	sd	s3,24(sp)
    80003fd8:	e852                	sd	s4,16(sp)
    80003fda:	0080                	addi	s0,sp,64
    80003fdc:	892a                	mv	s2,a0
    80003fde:	8a2e                	mv	s4,a1
    80003fe0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003fe2:	4601                	li	a2,0
    80003fe4:	00000097          	auipc	ra,0x0
    80003fe8:	dd8080e7          	jalr	-552(ra) # 80003dbc <dirlookup>
    80003fec:	e93d                	bnez	a0,80004062 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fee:	04c92483          	lw	s1,76(s2)
    80003ff2:	c49d                	beqz	s1,80004020 <dirlink+0x54>
    80003ff4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ff6:	4741                	li	a4,16
    80003ff8:	86a6                	mv	a3,s1
    80003ffa:	fc040613          	addi	a2,s0,-64
    80003ffe:	4581                	li	a1,0
    80004000:	854a                	mv	a0,s2
    80004002:	00000097          	auipc	ra,0x0
    80004006:	b8a080e7          	jalr	-1142(ra) # 80003b8c <readi>
    8000400a:	47c1                	li	a5,16
    8000400c:	06f51163          	bne	a0,a5,8000406e <dirlink+0xa2>
    if(de.inum == 0)
    80004010:	fc045783          	lhu	a5,-64(s0)
    80004014:	c791                	beqz	a5,80004020 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004016:	24c1                	addiw	s1,s1,16
    80004018:	04c92783          	lw	a5,76(s2)
    8000401c:	fcf4ede3          	bltu	s1,a5,80003ff6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004020:	4639                	li	a2,14
    80004022:	85d2                	mv	a1,s4
    80004024:	fc240513          	addi	a0,s0,-62
    80004028:	ffffd097          	auipc	ra,0xffffd
    8000402c:	eb2080e7          	jalr	-334(ra) # 80000eda <strncpy>
  de.inum = inum;
    80004030:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004034:	4741                	li	a4,16
    80004036:	86a6                	mv	a3,s1
    80004038:	fc040613          	addi	a2,s0,-64
    8000403c:	4581                	li	a1,0
    8000403e:	854a                	mv	a0,s2
    80004040:	00000097          	auipc	ra,0x0
    80004044:	c44080e7          	jalr	-956(ra) # 80003c84 <writei>
    80004048:	1541                	addi	a0,a0,-16
    8000404a:	00a03533          	snez	a0,a0
    8000404e:	40a00533          	neg	a0,a0
}
    80004052:	70e2                	ld	ra,56(sp)
    80004054:	7442                	ld	s0,48(sp)
    80004056:	74a2                	ld	s1,40(sp)
    80004058:	7902                	ld	s2,32(sp)
    8000405a:	69e2                	ld	s3,24(sp)
    8000405c:	6a42                	ld	s4,16(sp)
    8000405e:	6121                	addi	sp,sp,64
    80004060:	8082                	ret
    iput(ip);
    80004062:	00000097          	auipc	ra,0x0
    80004066:	a30080e7          	jalr	-1488(ra) # 80003a92 <iput>
    return -1;
    8000406a:	557d                	li	a0,-1
    8000406c:	b7dd                	j	80004052 <dirlink+0x86>
      panic("dirlink read");
    8000406e:	00004517          	auipc	a0,0x4
    80004072:	5ea50513          	addi	a0,a0,1514 # 80008658 <syscalls+0x1c8>
    80004076:	ffffc097          	auipc	ra,0xffffc
    8000407a:	4c8080e7          	jalr	1224(ra) # 8000053e <panic>

000000008000407e <namei>:

struct inode*
namei(char *path)
{
    8000407e:	1101                	addi	sp,sp,-32
    80004080:	ec06                	sd	ra,24(sp)
    80004082:	e822                	sd	s0,16(sp)
    80004084:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004086:	fe040613          	addi	a2,s0,-32
    8000408a:	4581                	li	a1,0
    8000408c:	00000097          	auipc	ra,0x0
    80004090:	de0080e7          	jalr	-544(ra) # 80003e6c <namex>
}
    80004094:	60e2                	ld	ra,24(sp)
    80004096:	6442                	ld	s0,16(sp)
    80004098:	6105                	addi	sp,sp,32
    8000409a:	8082                	ret

000000008000409c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000409c:	1141                	addi	sp,sp,-16
    8000409e:	e406                	sd	ra,8(sp)
    800040a0:	e022                	sd	s0,0(sp)
    800040a2:	0800                	addi	s0,sp,16
    800040a4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800040a6:	4585                	li	a1,1
    800040a8:	00000097          	auipc	ra,0x0
    800040ac:	dc4080e7          	jalr	-572(ra) # 80003e6c <namex>
}
    800040b0:	60a2                	ld	ra,8(sp)
    800040b2:	6402                	ld	s0,0(sp)
    800040b4:	0141                	addi	sp,sp,16
    800040b6:	8082                	ret

00000000800040b8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800040b8:	1101                	addi	sp,sp,-32
    800040ba:	ec06                	sd	ra,24(sp)
    800040bc:	e822                	sd	s0,16(sp)
    800040be:	e426                	sd	s1,8(sp)
    800040c0:	e04a                	sd	s2,0(sp)
    800040c2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800040c4:	0023d917          	auipc	s2,0x23d
    800040c8:	a7c90913          	addi	s2,s2,-1412 # 80240b40 <log>
    800040cc:	01892583          	lw	a1,24(s2)
    800040d0:	02892503          	lw	a0,40(s2)
    800040d4:	fffff097          	auipc	ra,0xfffff
    800040d8:	fe8080e7          	jalr	-24(ra) # 800030bc <bread>
    800040dc:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800040de:	02c92683          	lw	a3,44(s2)
    800040e2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800040e4:	02d05863          	blez	a3,80004114 <write_head+0x5c>
    800040e8:	0023d797          	auipc	a5,0x23d
    800040ec:	a8878793          	addi	a5,a5,-1400 # 80240b70 <log+0x30>
    800040f0:	05c50713          	addi	a4,a0,92
    800040f4:	36fd                	addiw	a3,a3,-1
    800040f6:	02069613          	slli	a2,a3,0x20
    800040fa:	01e65693          	srli	a3,a2,0x1e
    800040fe:	0023d617          	auipc	a2,0x23d
    80004102:	a7660613          	addi	a2,a2,-1418 # 80240b74 <log+0x34>
    80004106:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004108:	4390                	lw	a2,0(a5)
    8000410a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000410c:	0791                	addi	a5,a5,4
    8000410e:	0711                	addi	a4,a4,4
    80004110:	fed79ce3          	bne	a5,a3,80004108 <write_head+0x50>
  }
  bwrite(buf);
    80004114:	8526                	mv	a0,s1
    80004116:	fffff097          	auipc	ra,0xfffff
    8000411a:	098080e7          	jalr	152(ra) # 800031ae <bwrite>
  brelse(buf);
    8000411e:	8526                	mv	a0,s1
    80004120:	fffff097          	auipc	ra,0xfffff
    80004124:	0cc080e7          	jalr	204(ra) # 800031ec <brelse>
}
    80004128:	60e2                	ld	ra,24(sp)
    8000412a:	6442                	ld	s0,16(sp)
    8000412c:	64a2                	ld	s1,8(sp)
    8000412e:	6902                	ld	s2,0(sp)
    80004130:	6105                	addi	sp,sp,32
    80004132:	8082                	ret

0000000080004134 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004134:	0023d797          	auipc	a5,0x23d
    80004138:	a387a783          	lw	a5,-1480(a5) # 80240b6c <log+0x2c>
    8000413c:	0af05d63          	blez	a5,800041f6 <install_trans+0xc2>
{
    80004140:	7139                	addi	sp,sp,-64
    80004142:	fc06                	sd	ra,56(sp)
    80004144:	f822                	sd	s0,48(sp)
    80004146:	f426                	sd	s1,40(sp)
    80004148:	f04a                	sd	s2,32(sp)
    8000414a:	ec4e                	sd	s3,24(sp)
    8000414c:	e852                	sd	s4,16(sp)
    8000414e:	e456                	sd	s5,8(sp)
    80004150:	e05a                	sd	s6,0(sp)
    80004152:	0080                	addi	s0,sp,64
    80004154:	8b2a                	mv	s6,a0
    80004156:	0023da97          	auipc	s5,0x23d
    8000415a:	a1aa8a93          	addi	s5,s5,-1510 # 80240b70 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000415e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004160:	0023d997          	auipc	s3,0x23d
    80004164:	9e098993          	addi	s3,s3,-1568 # 80240b40 <log>
    80004168:	a00d                	j	8000418a <install_trans+0x56>
    brelse(lbuf);
    8000416a:	854a                	mv	a0,s2
    8000416c:	fffff097          	auipc	ra,0xfffff
    80004170:	080080e7          	jalr	128(ra) # 800031ec <brelse>
    brelse(dbuf);
    80004174:	8526                	mv	a0,s1
    80004176:	fffff097          	auipc	ra,0xfffff
    8000417a:	076080e7          	jalr	118(ra) # 800031ec <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000417e:	2a05                	addiw	s4,s4,1
    80004180:	0a91                	addi	s5,s5,4
    80004182:	02c9a783          	lw	a5,44(s3)
    80004186:	04fa5e63          	bge	s4,a5,800041e2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000418a:	0189a583          	lw	a1,24(s3)
    8000418e:	014585bb          	addw	a1,a1,s4
    80004192:	2585                	addiw	a1,a1,1
    80004194:	0289a503          	lw	a0,40(s3)
    80004198:	fffff097          	auipc	ra,0xfffff
    8000419c:	f24080e7          	jalr	-220(ra) # 800030bc <bread>
    800041a0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800041a2:	000aa583          	lw	a1,0(s5)
    800041a6:	0289a503          	lw	a0,40(s3)
    800041aa:	fffff097          	auipc	ra,0xfffff
    800041ae:	f12080e7          	jalr	-238(ra) # 800030bc <bread>
    800041b2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800041b4:	40000613          	li	a2,1024
    800041b8:	05890593          	addi	a1,s2,88
    800041bc:	05850513          	addi	a0,a0,88
    800041c0:	ffffd097          	auipc	ra,0xffffd
    800041c4:	c6a080e7          	jalr	-918(ra) # 80000e2a <memmove>
    bwrite(dbuf);  // write dst to disk
    800041c8:	8526                	mv	a0,s1
    800041ca:	fffff097          	auipc	ra,0xfffff
    800041ce:	fe4080e7          	jalr	-28(ra) # 800031ae <bwrite>
    if(recovering == 0)
    800041d2:	f80b1ce3          	bnez	s6,8000416a <install_trans+0x36>
      bunpin(dbuf);
    800041d6:	8526                	mv	a0,s1
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	0ee080e7          	jalr	238(ra) # 800032c6 <bunpin>
    800041e0:	b769                	j	8000416a <install_trans+0x36>
}
    800041e2:	70e2                	ld	ra,56(sp)
    800041e4:	7442                	ld	s0,48(sp)
    800041e6:	74a2                	ld	s1,40(sp)
    800041e8:	7902                	ld	s2,32(sp)
    800041ea:	69e2                	ld	s3,24(sp)
    800041ec:	6a42                	ld	s4,16(sp)
    800041ee:	6aa2                	ld	s5,8(sp)
    800041f0:	6b02                	ld	s6,0(sp)
    800041f2:	6121                	addi	sp,sp,64
    800041f4:	8082                	ret
    800041f6:	8082                	ret

00000000800041f8 <initlog>:
{
    800041f8:	7179                	addi	sp,sp,-48
    800041fa:	f406                	sd	ra,40(sp)
    800041fc:	f022                	sd	s0,32(sp)
    800041fe:	ec26                	sd	s1,24(sp)
    80004200:	e84a                	sd	s2,16(sp)
    80004202:	e44e                	sd	s3,8(sp)
    80004204:	1800                	addi	s0,sp,48
    80004206:	892a                	mv	s2,a0
    80004208:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000420a:	0023d497          	auipc	s1,0x23d
    8000420e:	93648493          	addi	s1,s1,-1738 # 80240b40 <log>
    80004212:	00004597          	auipc	a1,0x4
    80004216:	45658593          	addi	a1,a1,1110 # 80008668 <syscalls+0x1d8>
    8000421a:	8526                	mv	a0,s1
    8000421c:	ffffd097          	auipc	ra,0xffffd
    80004220:	a26080e7          	jalr	-1498(ra) # 80000c42 <initlock>
  log.start = sb->logstart;
    80004224:	0149a583          	lw	a1,20(s3)
    80004228:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000422a:	0109a783          	lw	a5,16(s3)
    8000422e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004230:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004234:	854a                	mv	a0,s2
    80004236:	fffff097          	auipc	ra,0xfffff
    8000423a:	e86080e7          	jalr	-378(ra) # 800030bc <bread>
  log.lh.n = lh->n;
    8000423e:	4d34                	lw	a3,88(a0)
    80004240:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004242:	02d05663          	blez	a3,8000426e <initlog+0x76>
    80004246:	05c50793          	addi	a5,a0,92
    8000424a:	0023d717          	auipc	a4,0x23d
    8000424e:	92670713          	addi	a4,a4,-1754 # 80240b70 <log+0x30>
    80004252:	36fd                	addiw	a3,a3,-1
    80004254:	02069613          	slli	a2,a3,0x20
    80004258:	01e65693          	srli	a3,a2,0x1e
    8000425c:	06050613          	addi	a2,a0,96
    80004260:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004262:	4390                	lw	a2,0(a5)
    80004264:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004266:	0791                	addi	a5,a5,4
    80004268:	0711                	addi	a4,a4,4
    8000426a:	fed79ce3          	bne	a5,a3,80004262 <initlog+0x6a>
  brelse(buf);
    8000426e:	fffff097          	auipc	ra,0xfffff
    80004272:	f7e080e7          	jalr	-130(ra) # 800031ec <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004276:	4505                	li	a0,1
    80004278:	00000097          	auipc	ra,0x0
    8000427c:	ebc080e7          	jalr	-324(ra) # 80004134 <install_trans>
  log.lh.n = 0;
    80004280:	0023d797          	auipc	a5,0x23d
    80004284:	8e07a623          	sw	zero,-1812(a5) # 80240b6c <log+0x2c>
  write_head(); // clear the log
    80004288:	00000097          	auipc	ra,0x0
    8000428c:	e30080e7          	jalr	-464(ra) # 800040b8 <write_head>
}
    80004290:	70a2                	ld	ra,40(sp)
    80004292:	7402                	ld	s0,32(sp)
    80004294:	64e2                	ld	s1,24(sp)
    80004296:	6942                	ld	s2,16(sp)
    80004298:	69a2                	ld	s3,8(sp)
    8000429a:	6145                	addi	sp,sp,48
    8000429c:	8082                	ret

000000008000429e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000429e:	1101                	addi	sp,sp,-32
    800042a0:	ec06                	sd	ra,24(sp)
    800042a2:	e822                	sd	s0,16(sp)
    800042a4:	e426                	sd	s1,8(sp)
    800042a6:	e04a                	sd	s2,0(sp)
    800042a8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800042aa:	0023d517          	auipc	a0,0x23d
    800042ae:	89650513          	addi	a0,a0,-1898 # 80240b40 <log>
    800042b2:	ffffd097          	auipc	ra,0xffffd
    800042b6:	a20080e7          	jalr	-1504(ra) # 80000cd2 <acquire>
  while(1){
    if(log.committing){
    800042ba:	0023d497          	auipc	s1,0x23d
    800042be:	88648493          	addi	s1,s1,-1914 # 80240b40 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800042c2:	4979                	li	s2,30
    800042c4:	a039                	j	800042d2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800042c6:	85a6                	mv	a1,s1
    800042c8:	8526                	mv	a0,s1
    800042ca:	ffffe097          	auipc	ra,0xffffe
    800042ce:	ff8080e7          	jalr	-8(ra) # 800022c2 <sleep>
    if(log.committing){
    800042d2:	50dc                	lw	a5,36(s1)
    800042d4:	fbed                	bnez	a5,800042c6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800042d6:	509c                	lw	a5,32(s1)
    800042d8:	0017871b          	addiw	a4,a5,1
    800042dc:	0007069b          	sext.w	a3,a4
    800042e0:	0027179b          	slliw	a5,a4,0x2
    800042e4:	9fb9                	addw	a5,a5,a4
    800042e6:	0017979b          	slliw	a5,a5,0x1
    800042ea:	54d8                	lw	a4,44(s1)
    800042ec:	9fb9                	addw	a5,a5,a4
    800042ee:	00f95963          	bge	s2,a5,80004300 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800042f2:	85a6                	mv	a1,s1
    800042f4:	8526                	mv	a0,s1
    800042f6:	ffffe097          	auipc	ra,0xffffe
    800042fa:	fcc080e7          	jalr	-52(ra) # 800022c2 <sleep>
    800042fe:	bfd1                	j	800042d2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004300:	0023d517          	auipc	a0,0x23d
    80004304:	84050513          	addi	a0,a0,-1984 # 80240b40 <log>
    80004308:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000430a:	ffffd097          	auipc	ra,0xffffd
    8000430e:	a7c080e7          	jalr	-1412(ra) # 80000d86 <release>
      break;
    }
  }
}
    80004312:	60e2                	ld	ra,24(sp)
    80004314:	6442                	ld	s0,16(sp)
    80004316:	64a2                	ld	s1,8(sp)
    80004318:	6902                	ld	s2,0(sp)
    8000431a:	6105                	addi	sp,sp,32
    8000431c:	8082                	ret

000000008000431e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000431e:	7139                	addi	sp,sp,-64
    80004320:	fc06                	sd	ra,56(sp)
    80004322:	f822                	sd	s0,48(sp)
    80004324:	f426                	sd	s1,40(sp)
    80004326:	f04a                	sd	s2,32(sp)
    80004328:	ec4e                	sd	s3,24(sp)
    8000432a:	e852                	sd	s4,16(sp)
    8000432c:	e456                	sd	s5,8(sp)
    8000432e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004330:	0023d497          	auipc	s1,0x23d
    80004334:	81048493          	addi	s1,s1,-2032 # 80240b40 <log>
    80004338:	8526                	mv	a0,s1
    8000433a:	ffffd097          	auipc	ra,0xffffd
    8000433e:	998080e7          	jalr	-1640(ra) # 80000cd2 <acquire>
  log.outstanding -= 1;
    80004342:	509c                	lw	a5,32(s1)
    80004344:	37fd                	addiw	a5,a5,-1
    80004346:	0007891b          	sext.w	s2,a5
    8000434a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000434c:	50dc                	lw	a5,36(s1)
    8000434e:	e7b9                	bnez	a5,8000439c <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004350:	04091e63          	bnez	s2,800043ac <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004354:	0023c497          	auipc	s1,0x23c
    80004358:	7ec48493          	addi	s1,s1,2028 # 80240b40 <log>
    8000435c:	4785                	li	a5,1
    8000435e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004360:	8526                	mv	a0,s1
    80004362:	ffffd097          	auipc	ra,0xffffd
    80004366:	a24080e7          	jalr	-1500(ra) # 80000d86 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000436a:	54dc                	lw	a5,44(s1)
    8000436c:	06f04763          	bgtz	a5,800043da <end_op+0xbc>
    acquire(&log.lock);
    80004370:	0023c497          	auipc	s1,0x23c
    80004374:	7d048493          	addi	s1,s1,2000 # 80240b40 <log>
    80004378:	8526                	mv	a0,s1
    8000437a:	ffffd097          	auipc	ra,0xffffd
    8000437e:	958080e7          	jalr	-1704(ra) # 80000cd2 <acquire>
    log.committing = 0;
    80004382:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004386:	8526                	mv	a0,s1
    80004388:	ffffe097          	auipc	ra,0xffffe
    8000438c:	f9e080e7          	jalr	-98(ra) # 80002326 <wakeup>
    release(&log.lock);
    80004390:	8526                	mv	a0,s1
    80004392:	ffffd097          	auipc	ra,0xffffd
    80004396:	9f4080e7          	jalr	-1548(ra) # 80000d86 <release>
}
    8000439a:	a03d                	j	800043c8 <end_op+0xaa>
    panic("log.committing");
    8000439c:	00004517          	auipc	a0,0x4
    800043a0:	2d450513          	addi	a0,a0,724 # 80008670 <syscalls+0x1e0>
    800043a4:	ffffc097          	auipc	ra,0xffffc
    800043a8:	19a080e7          	jalr	410(ra) # 8000053e <panic>
    wakeup(&log);
    800043ac:	0023c497          	auipc	s1,0x23c
    800043b0:	79448493          	addi	s1,s1,1940 # 80240b40 <log>
    800043b4:	8526                	mv	a0,s1
    800043b6:	ffffe097          	auipc	ra,0xffffe
    800043ba:	f70080e7          	jalr	-144(ra) # 80002326 <wakeup>
  release(&log.lock);
    800043be:	8526                	mv	a0,s1
    800043c0:	ffffd097          	auipc	ra,0xffffd
    800043c4:	9c6080e7          	jalr	-1594(ra) # 80000d86 <release>
}
    800043c8:	70e2                	ld	ra,56(sp)
    800043ca:	7442                	ld	s0,48(sp)
    800043cc:	74a2                	ld	s1,40(sp)
    800043ce:	7902                	ld	s2,32(sp)
    800043d0:	69e2                	ld	s3,24(sp)
    800043d2:	6a42                	ld	s4,16(sp)
    800043d4:	6aa2                	ld	s5,8(sp)
    800043d6:	6121                	addi	sp,sp,64
    800043d8:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800043da:	0023ca97          	auipc	s5,0x23c
    800043de:	796a8a93          	addi	s5,s5,1942 # 80240b70 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800043e2:	0023ca17          	auipc	s4,0x23c
    800043e6:	75ea0a13          	addi	s4,s4,1886 # 80240b40 <log>
    800043ea:	018a2583          	lw	a1,24(s4)
    800043ee:	012585bb          	addw	a1,a1,s2
    800043f2:	2585                	addiw	a1,a1,1
    800043f4:	028a2503          	lw	a0,40(s4)
    800043f8:	fffff097          	auipc	ra,0xfffff
    800043fc:	cc4080e7          	jalr	-828(ra) # 800030bc <bread>
    80004400:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004402:	000aa583          	lw	a1,0(s5)
    80004406:	028a2503          	lw	a0,40(s4)
    8000440a:	fffff097          	auipc	ra,0xfffff
    8000440e:	cb2080e7          	jalr	-846(ra) # 800030bc <bread>
    80004412:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004414:	40000613          	li	a2,1024
    80004418:	05850593          	addi	a1,a0,88
    8000441c:	05848513          	addi	a0,s1,88
    80004420:	ffffd097          	auipc	ra,0xffffd
    80004424:	a0a080e7          	jalr	-1526(ra) # 80000e2a <memmove>
    bwrite(to);  // write the log
    80004428:	8526                	mv	a0,s1
    8000442a:	fffff097          	auipc	ra,0xfffff
    8000442e:	d84080e7          	jalr	-636(ra) # 800031ae <bwrite>
    brelse(from);
    80004432:	854e                	mv	a0,s3
    80004434:	fffff097          	auipc	ra,0xfffff
    80004438:	db8080e7          	jalr	-584(ra) # 800031ec <brelse>
    brelse(to);
    8000443c:	8526                	mv	a0,s1
    8000443e:	fffff097          	auipc	ra,0xfffff
    80004442:	dae080e7          	jalr	-594(ra) # 800031ec <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004446:	2905                	addiw	s2,s2,1
    80004448:	0a91                	addi	s5,s5,4
    8000444a:	02ca2783          	lw	a5,44(s4)
    8000444e:	f8f94ee3          	blt	s2,a5,800043ea <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004452:	00000097          	auipc	ra,0x0
    80004456:	c66080e7          	jalr	-922(ra) # 800040b8 <write_head>
    install_trans(0); // Now install writes to home locations
    8000445a:	4501                	li	a0,0
    8000445c:	00000097          	auipc	ra,0x0
    80004460:	cd8080e7          	jalr	-808(ra) # 80004134 <install_trans>
    log.lh.n = 0;
    80004464:	0023c797          	auipc	a5,0x23c
    80004468:	7007a423          	sw	zero,1800(a5) # 80240b6c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000446c:	00000097          	auipc	ra,0x0
    80004470:	c4c080e7          	jalr	-948(ra) # 800040b8 <write_head>
    80004474:	bdf5                	j	80004370 <end_op+0x52>

0000000080004476 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004476:	1101                	addi	sp,sp,-32
    80004478:	ec06                	sd	ra,24(sp)
    8000447a:	e822                	sd	s0,16(sp)
    8000447c:	e426                	sd	s1,8(sp)
    8000447e:	e04a                	sd	s2,0(sp)
    80004480:	1000                	addi	s0,sp,32
    80004482:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004484:	0023c917          	auipc	s2,0x23c
    80004488:	6bc90913          	addi	s2,s2,1724 # 80240b40 <log>
    8000448c:	854a                	mv	a0,s2
    8000448e:	ffffd097          	auipc	ra,0xffffd
    80004492:	844080e7          	jalr	-1980(ra) # 80000cd2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004496:	02c92603          	lw	a2,44(s2)
    8000449a:	47f5                	li	a5,29
    8000449c:	06c7c563          	blt	a5,a2,80004506 <log_write+0x90>
    800044a0:	0023c797          	auipc	a5,0x23c
    800044a4:	6bc7a783          	lw	a5,1724(a5) # 80240b5c <log+0x1c>
    800044a8:	37fd                	addiw	a5,a5,-1
    800044aa:	04f65e63          	bge	a2,a5,80004506 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800044ae:	0023c797          	auipc	a5,0x23c
    800044b2:	6b27a783          	lw	a5,1714(a5) # 80240b60 <log+0x20>
    800044b6:	06f05063          	blez	a5,80004516 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800044ba:	4781                	li	a5,0
    800044bc:	06c05563          	blez	a2,80004526 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800044c0:	44cc                	lw	a1,12(s1)
    800044c2:	0023c717          	auipc	a4,0x23c
    800044c6:	6ae70713          	addi	a4,a4,1710 # 80240b70 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800044ca:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800044cc:	4314                	lw	a3,0(a4)
    800044ce:	04b68c63          	beq	a3,a1,80004526 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800044d2:	2785                	addiw	a5,a5,1
    800044d4:	0711                	addi	a4,a4,4
    800044d6:	fef61be3          	bne	a2,a5,800044cc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800044da:	0621                	addi	a2,a2,8
    800044dc:	060a                	slli	a2,a2,0x2
    800044de:	0023c797          	auipc	a5,0x23c
    800044e2:	66278793          	addi	a5,a5,1634 # 80240b40 <log>
    800044e6:	963e                	add	a2,a2,a5
    800044e8:	44dc                	lw	a5,12(s1)
    800044ea:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800044ec:	8526                	mv	a0,s1
    800044ee:	fffff097          	auipc	ra,0xfffff
    800044f2:	d9c080e7          	jalr	-612(ra) # 8000328a <bpin>
    log.lh.n++;
    800044f6:	0023c717          	auipc	a4,0x23c
    800044fa:	64a70713          	addi	a4,a4,1610 # 80240b40 <log>
    800044fe:	575c                	lw	a5,44(a4)
    80004500:	2785                	addiw	a5,a5,1
    80004502:	d75c                	sw	a5,44(a4)
    80004504:	a835                	j	80004540 <log_write+0xca>
    panic("too big a transaction");
    80004506:	00004517          	auipc	a0,0x4
    8000450a:	17a50513          	addi	a0,a0,378 # 80008680 <syscalls+0x1f0>
    8000450e:	ffffc097          	auipc	ra,0xffffc
    80004512:	030080e7          	jalr	48(ra) # 8000053e <panic>
    panic("log_write outside of trans");
    80004516:	00004517          	auipc	a0,0x4
    8000451a:	18250513          	addi	a0,a0,386 # 80008698 <syscalls+0x208>
    8000451e:	ffffc097          	auipc	ra,0xffffc
    80004522:	020080e7          	jalr	32(ra) # 8000053e <panic>
  log.lh.block[i] = b->blockno;
    80004526:	00878713          	addi	a4,a5,8
    8000452a:	00271693          	slli	a3,a4,0x2
    8000452e:	0023c717          	auipc	a4,0x23c
    80004532:	61270713          	addi	a4,a4,1554 # 80240b40 <log>
    80004536:	9736                	add	a4,a4,a3
    80004538:	44d4                	lw	a3,12(s1)
    8000453a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000453c:	faf608e3          	beq	a2,a5,800044ec <log_write+0x76>
  }
  release(&log.lock);
    80004540:	0023c517          	auipc	a0,0x23c
    80004544:	60050513          	addi	a0,a0,1536 # 80240b40 <log>
    80004548:	ffffd097          	auipc	ra,0xffffd
    8000454c:	83e080e7          	jalr	-1986(ra) # 80000d86 <release>
}
    80004550:	60e2                	ld	ra,24(sp)
    80004552:	6442                	ld	s0,16(sp)
    80004554:	64a2                	ld	s1,8(sp)
    80004556:	6902                	ld	s2,0(sp)
    80004558:	6105                	addi	sp,sp,32
    8000455a:	8082                	ret

000000008000455c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000455c:	1101                	addi	sp,sp,-32
    8000455e:	ec06                	sd	ra,24(sp)
    80004560:	e822                	sd	s0,16(sp)
    80004562:	e426                	sd	s1,8(sp)
    80004564:	e04a                	sd	s2,0(sp)
    80004566:	1000                	addi	s0,sp,32
    80004568:	84aa                	mv	s1,a0
    8000456a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000456c:	00004597          	auipc	a1,0x4
    80004570:	14c58593          	addi	a1,a1,332 # 800086b8 <syscalls+0x228>
    80004574:	0521                	addi	a0,a0,8
    80004576:	ffffc097          	auipc	ra,0xffffc
    8000457a:	6cc080e7          	jalr	1740(ra) # 80000c42 <initlock>
  lk->name = name;
    8000457e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004582:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004586:	0204a423          	sw	zero,40(s1)
}
    8000458a:	60e2                	ld	ra,24(sp)
    8000458c:	6442                	ld	s0,16(sp)
    8000458e:	64a2                	ld	s1,8(sp)
    80004590:	6902                	ld	s2,0(sp)
    80004592:	6105                	addi	sp,sp,32
    80004594:	8082                	ret

0000000080004596 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004596:	1101                	addi	sp,sp,-32
    80004598:	ec06                	sd	ra,24(sp)
    8000459a:	e822                	sd	s0,16(sp)
    8000459c:	e426                	sd	s1,8(sp)
    8000459e:	e04a                	sd	s2,0(sp)
    800045a0:	1000                	addi	s0,sp,32
    800045a2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800045a4:	00850913          	addi	s2,a0,8
    800045a8:	854a                	mv	a0,s2
    800045aa:	ffffc097          	auipc	ra,0xffffc
    800045ae:	728080e7          	jalr	1832(ra) # 80000cd2 <acquire>
  while (lk->locked) {
    800045b2:	409c                	lw	a5,0(s1)
    800045b4:	cb89                	beqz	a5,800045c6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800045b6:	85ca                	mv	a1,s2
    800045b8:	8526                	mv	a0,s1
    800045ba:	ffffe097          	auipc	ra,0xffffe
    800045be:	d08080e7          	jalr	-760(ra) # 800022c2 <sleep>
  while (lk->locked) {
    800045c2:	409c                	lw	a5,0(s1)
    800045c4:	fbed                	bnez	a5,800045b6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800045c6:	4785                	li	a5,1
    800045c8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800045ca:	ffffd097          	auipc	ra,0xffffd
    800045ce:	64c080e7          	jalr	1612(ra) # 80001c16 <myproc>
    800045d2:	591c                	lw	a5,48(a0)
    800045d4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800045d6:	854a                	mv	a0,s2
    800045d8:	ffffc097          	auipc	ra,0xffffc
    800045dc:	7ae080e7          	jalr	1966(ra) # 80000d86 <release>
}
    800045e0:	60e2                	ld	ra,24(sp)
    800045e2:	6442                	ld	s0,16(sp)
    800045e4:	64a2                	ld	s1,8(sp)
    800045e6:	6902                	ld	s2,0(sp)
    800045e8:	6105                	addi	sp,sp,32
    800045ea:	8082                	ret

00000000800045ec <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800045ec:	1101                	addi	sp,sp,-32
    800045ee:	ec06                	sd	ra,24(sp)
    800045f0:	e822                	sd	s0,16(sp)
    800045f2:	e426                	sd	s1,8(sp)
    800045f4:	e04a                	sd	s2,0(sp)
    800045f6:	1000                	addi	s0,sp,32
    800045f8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800045fa:	00850913          	addi	s2,a0,8
    800045fe:	854a                	mv	a0,s2
    80004600:	ffffc097          	auipc	ra,0xffffc
    80004604:	6d2080e7          	jalr	1746(ra) # 80000cd2 <acquire>
  lk->locked = 0;
    80004608:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000460c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004610:	8526                	mv	a0,s1
    80004612:	ffffe097          	auipc	ra,0xffffe
    80004616:	d14080e7          	jalr	-748(ra) # 80002326 <wakeup>
  release(&lk->lk);
    8000461a:	854a                	mv	a0,s2
    8000461c:	ffffc097          	auipc	ra,0xffffc
    80004620:	76a080e7          	jalr	1898(ra) # 80000d86 <release>
}
    80004624:	60e2                	ld	ra,24(sp)
    80004626:	6442                	ld	s0,16(sp)
    80004628:	64a2                	ld	s1,8(sp)
    8000462a:	6902                	ld	s2,0(sp)
    8000462c:	6105                	addi	sp,sp,32
    8000462e:	8082                	ret

0000000080004630 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004630:	7179                	addi	sp,sp,-48
    80004632:	f406                	sd	ra,40(sp)
    80004634:	f022                	sd	s0,32(sp)
    80004636:	ec26                	sd	s1,24(sp)
    80004638:	e84a                	sd	s2,16(sp)
    8000463a:	e44e                	sd	s3,8(sp)
    8000463c:	1800                	addi	s0,sp,48
    8000463e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004640:	00850913          	addi	s2,a0,8
    80004644:	854a                	mv	a0,s2
    80004646:	ffffc097          	auipc	ra,0xffffc
    8000464a:	68c080e7          	jalr	1676(ra) # 80000cd2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000464e:	409c                	lw	a5,0(s1)
    80004650:	ef99                	bnez	a5,8000466e <holdingsleep+0x3e>
    80004652:	4481                	li	s1,0
  release(&lk->lk);
    80004654:	854a                	mv	a0,s2
    80004656:	ffffc097          	auipc	ra,0xffffc
    8000465a:	730080e7          	jalr	1840(ra) # 80000d86 <release>
  return r;
}
    8000465e:	8526                	mv	a0,s1
    80004660:	70a2                	ld	ra,40(sp)
    80004662:	7402                	ld	s0,32(sp)
    80004664:	64e2                	ld	s1,24(sp)
    80004666:	6942                	ld	s2,16(sp)
    80004668:	69a2                	ld	s3,8(sp)
    8000466a:	6145                	addi	sp,sp,48
    8000466c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000466e:	0284a983          	lw	s3,40(s1)
    80004672:	ffffd097          	auipc	ra,0xffffd
    80004676:	5a4080e7          	jalr	1444(ra) # 80001c16 <myproc>
    8000467a:	5904                	lw	s1,48(a0)
    8000467c:	413484b3          	sub	s1,s1,s3
    80004680:	0014b493          	seqz	s1,s1
    80004684:	bfc1                	j	80004654 <holdingsleep+0x24>

0000000080004686 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004686:	1141                	addi	sp,sp,-16
    80004688:	e406                	sd	ra,8(sp)
    8000468a:	e022                	sd	s0,0(sp)
    8000468c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000468e:	00004597          	auipc	a1,0x4
    80004692:	03a58593          	addi	a1,a1,58 # 800086c8 <syscalls+0x238>
    80004696:	0023c517          	auipc	a0,0x23c
    8000469a:	5f250513          	addi	a0,a0,1522 # 80240c88 <ftable>
    8000469e:	ffffc097          	auipc	ra,0xffffc
    800046a2:	5a4080e7          	jalr	1444(ra) # 80000c42 <initlock>
}
    800046a6:	60a2                	ld	ra,8(sp)
    800046a8:	6402                	ld	s0,0(sp)
    800046aa:	0141                	addi	sp,sp,16
    800046ac:	8082                	ret

00000000800046ae <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800046ae:	1101                	addi	sp,sp,-32
    800046b0:	ec06                	sd	ra,24(sp)
    800046b2:	e822                	sd	s0,16(sp)
    800046b4:	e426                	sd	s1,8(sp)
    800046b6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800046b8:	0023c517          	auipc	a0,0x23c
    800046bc:	5d050513          	addi	a0,a0,1488 # 80240c88 <ftable>
    800046c0:	ffffc097          	auipc	ra,0xffffc
    800046c4:	612080e7          	jalr	1554(ra) # 80000cd2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800046c8:	0023c497          	auipc	s1,0x23c
    800046cc:	5d848493          	addi	s1,s1,1496 # 80240ca0 <ftable+0x18>
    800046d0:	0023d717          	auipc	a4,0x23d
    800046d4:	57070713          	addi	a4,a4,1392 # 80241c40 <disk>
    if(f->ref == 0){
    800046d8:	40dc                	lw	a5,4(s1)
    800046da:	cf99                	beqz	a5,800046f8 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800046dc:	02848493          	addi	s1,s1,40
    800046e0:	fee49ce3          	bne	s1,a4,800046d8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800046e4:	0023c517          	auipc	a0,0x23c
    800046e8:	5a450513          	addi	a0,a0,1444 # 80240c88 <ftable>
    800046ec:	ffffc097          	auipc	ra,0xffffc
    800046f0:	69a080e7          	jalr	1690(ra) # 80000d86 <release>
  return 0;
    800046f4:	4481                	li	s1,0
    800046f6:	a819                	j	8000470c <filealloc+0x5e>
      f->ref = 1;
    800046f8:	4785                	li	a5,1
    800046fa:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800046fc:	0023c517          	auipc	a0,0x23c
    80004700:	58c50513          	addi	a0,a0,1420 # 80240c88 <ftable>
    80004704:	ffffc097          	auipc	ra,0xffffc
    80004708:	682080e7          	jalr	1666(ra) # 80000d86 <release>
}
    8000470c:	8526                	mv	a0,s1
    8000470e:	60e2                	ld	ra,24(sp)
    80004710:	6442                	ld	s0,16(sp)
    80004712:	64a2                	ld	s1,8(sp)
    80004714:	6105                	addi	sp,sp,32
    80004716:	8082                	ret

0000000080004718 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004718:	1101                	addi	sp,sp,-32
    8000471a:	ec06                	sd	ra,24(sp)
    8000471c:	e822                	sd	s0,16(sp)
    8000471e:	e426                	sd	s1,8(sp)
    80004720:	1000                	addi	s0,sp,32
    80004722:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004724:	0023c517          	auipc	a0,0x23c
    80004728:	56450513          	addi	a0,a0,1380 # 80240c88 <ftable>
    8000472c:	ffffc097          	auipc	ra,0xffffc
    80004730:	5a6080e7          	jalr	1446(ra) # 80000cd2 <acquire>
  if(f->ref < 1)
    80004734:	40dc                	lw	a5,4(s1)
    80004736:	02f05263          	blez	a5,8000475a <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000473a:	2785                	addiw	a5,a5,1
    8000473c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000473e:	0023c517          	auipc	a0,0x23c
    80004742:	54a50513          	addi	a0,a0,1354 # 80240c88 <ftable>
    80004746:	ffffc097          	auipc	ra,0xffffc
    8000474a:	640080e7          	jalr	1600(ra) # 80000d86 <release>
  return f;
}
    8000474e:	8526                	mv	a0,s1
    80004750:	60e2                	ld	ra,24(sp)
    80004752:	6442                	ld	s0,16(sp)
    80004754:	64a2                	ld	s1,8(sp)
    80004756:	6105                	addi	sp,sp,32
    80004758:	8082                	ret
    panic("filedup");
    8000475a:	00004517          	auipc	a0,0x4
    8000475e:	f7650513          	addi	a0,a0,-138 # 800086d0 <syscalls+0x240>
    80004762:	ffffc097          	auipc	ra,0xffffc
    80004766:	ddc080e7          	jalr	-548(ra) # 8000053e <panic>

000000008000476a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000476a:	7139                	addi	sp,sp,-64
    8000476c:	fc06                	sd	ra,56(sp)
    8000476e:	f822                	sd	s0,48(sp)
    80004770:	f426                	sd	s1,40(sp)
    80004772:	f04a                	sd	s2,32(sp)
    80004774:	ec4e                	sd	s3,24(sp)
    80004776:	e852                	sd	s4,16(sp)
    80004778:	e456                	sd	s5,8(sp)
    8000477a:	0080                	addi	s0,sp,64
    8000477c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000477e:	0023c517          	auipc	a0,0x23c
    80004782:	50a50513          	addi	a0,a0,1290 # 80240c88 <ftable>
    80004786:	ffffc097          	auipc	ra,0xffffc
    8000478a:	54c080e7          	jalr	1356(ra) # 80000cd2 <acquire>
  if(f->ref < 1)
    8000478e:	40dc                	lw	a5,4(s1)
    80004790:	06f05163          	blez	a5,800047f2 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004794:	37fd                	addiw	a5,a5,-1
    80004796:	0007871b          	sext.w	a4,a5
    8000479a:	c0dc                	sw	a5,4(s1)
    8000479c:	06e04363          	bgtz	a4,80004802 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800047a0:	0004a903          	lw	s2,0(s1)
    800047a4:	0094ca83          	lbu	s5,9(s1)
    800047a8:	0104ba03          	ld	s4,16(s1)
    800047ac:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800047b0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800047b4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800047b8:	0023c517          	auipc	a0,0x23c
    800047bc:	4d050513          	addi	a0,a0,1232 # 80240c88 <ftable>
    800047c0:	ffffc097          	auipc	ra,0xffffc
    800047c4:	5c6080e7          	jalr	1478(ra) # 80000d86 <release>

  if(ff.type == FD_PIPE){
    800047c8:	4785                	li	a5,1
    800047ca:	04f90d63          	beq	s2,a5,80004824 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800047ce:	3979                	addiw	s2,s2,-2
    800047d0:	4785                	li	a5,1
    800047d2:	0527e063          	bltu	a5,s2,80004812 <fileclose+0xa8>
    begin_op();
    800047d6:	00000097          	auipc	ra,0x0
    800047da:	ac8080e7          	jalr	-1336(ra) # 8000429e <begin_op>
    iput(ff.ip);
    800047de:	854e                	mv	a0,s3
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	2b2080e7          	jalr	690(ra) # 80003a92 <iput>
    end_op();
    800047e8:	00000097          	auipc	ra,0x0
    800047ec:	b36080e7          	jalr	-1226(ra) # 8000431e <end_op>
    800047f0:	a00d                	j	80004812 <fileclose+0xa8>
    panic("fileclose");
    800047f2:	00004517          	auipc	a0,0x4
    800047f6:	ee650513          	addi	a0,a0,-282 # 800086d8 <syscalls+0x248>
    800047fa:	ffffc097          	auipc	ra,0xffffc
    800047fe:	d44080e7          	jalr	-700(ra) # 8000053e <panic>
    release(&ftable.lock);
    80004802:	0023c517          	auipc	a0,0x23c
    80004806:	48650513          	addi	a0,a0,1158 # 80240c88 <ftable>
    8000480a:	ffffc097          	auipc	ra,0xffffc
    8000480e:	57c080e7          	jalr	1404(ra) # 80000d86 <release>
  }
}
    80004812:	70e2                	ld	ra,56(sp)
    80004814:	7442                	ld	s0,48(sp)
    80004816:	74a2                	ld	s1,40(sp)
    80004818:	7902                	ld	s2,32(sp)
    8000481a:	69e2                	ld	s3,24(sp)
    8000481c:	6a42                	ld	s4,16(sp)
    8000481e:	6aa2                	ld	s5,8(sp)
    80004820:	6121                	addi	sp,sp,64
    80004822:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004824:	85d6                	mv	a1,s5
    80004826:	8552                	mv	a0,s4
    80004828:	00000097          	auipc	ra,0x0
    8000482c:	34c080e7          	jalr	844(ra) # 80004b74 <pipeclose>
    80004830:	b7cd                	j	80004812 <fileclose+0xa8>

0000000080004832 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004832:	715d                	addi	sp,sp,-80
    80004834:	e486                	sd	ra,72(sp)
    80004836:	e0a2                	sd	s0,64(sp)
    80004838:	fc26                	sd	s1,56(sp)
    8000483a:	f84a                	sd	s2,48(sp)
    8000483c:	f44e                	sd	s3,40(sp)
    8000483e:	0880                	addi	s0,sp,80
    80004840:	84aa                	mv	s1,a0
    80004842:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004844:	ffffd097          	auipc	ra,0xffffd
    80004848:	3d2080e7          	jalr	978(ra) # 80001c16 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000484c:	409c                	lw	a5,0(s1)
    8000484e:	37f9                	addiw	a5,a5,-2
    80004850:	4705                	li	a4,1
    80004852:	04f76763          	bltu	a4,a5,800048a0 <filestat+0x6e>
    80004856:	892a                	mv	s2,a0
    ilock(f->ip);
    80004858:	6c88                	ld	a0,24(s1)
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	07e080e7          	jalr	126(ra) # 800038d8 <ilock>
    stati(f->ip, &st);
    80004862:	fb840593          	addi	a1,s0,-72
    80004866:	6c88                	ld	a0,24(s1)
    80004868:	fffff097          	auipc	ra,0xfffff
    8000486c:	2fa080e7          	jalr	762(ra) # 80003b62 <stati>
    iunlock(f->ip);
    80004870:	6c88                	ld	a0,24(s1)
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	128080e7          	jalr	296(ra) # 8000399a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000487a:	46e1                	li	a3,24
    8000487c:	fb840613          	addi	a2,s0,-72
    80004880:	85ce                	mv	a1,s3
    80004882:	05093503          	ld	a0,80(s2)
    80004886:	ffffd097          	auipc	ra,0xffffd
    8000488a:	fe2080e7          	jalr	-30(ra) # 80001868 <copyout>
    8000488e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004892:	60a6                	ld	ra,72(sp)
    80004894:	6406                	ld	s0,64(sp)
    80004896:	74e2                	ld	s1,56(sp)
    80004898:	7942                	ld	s2,48(sp)
    8000489a:	79a2                	ld	s3,40(sp)
    8000489c:	6161                	addi	sp,sp,80
    8000489e:	8082                	ret
  return -1;
    800048a0:	557d                	li	a0,-1
    800048a2:	bfc5                	j	80004892 <filestat+0x60>

00000000800048a4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800048a4:	7179                	addi	sp,sp,-48
    800048a6:	f406                	sd	ra,40(sp)
    800048a8:	f022                	sd	s0,32(sp)
    800048aa:	ec26                	sd	s1,24(sp)
    800048ac:	e84a                	sd	s2,16(sp)
    800048ae:	e44e                	sd	s3,8(sp)
    800048b0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800048b2:	00854783          	lbu	a5,8(a0)
    800048b6:	c3d5                	beqz	a5,8000495a <fileread+0xb6>
    800048b8:	84aa                	mv	s1,a0
    800048ba:	89ae                	mv	s3,a1
    800048bc:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800048be:	411c                	lw	a5,0(a0)
    800048c0:	4705                	li	a4,1
    800048c2:	04e78963          	beq	a5,a4,80004914 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800048c6:	470d                	li	a4,3
    800048c8:	04e78d63          	beq	a5,a4,80004922 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800048cc:	4709                	li	a4,2
    800048ce:	06e79e63          	bne	a5,a4,8000494a <fileread+0xa6>
    ilock(f->ip);
    800048d2:	6d08                	ld	a0,24(a0)
    800048d4:	fffff097          	auipc	ra,0xfffff
    800048d8:	004080e7          	jalr	4(ra) # 800038d8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800048dc:	874a                	mv	a4,s2
    800048de:	5094                	lw	a3,32(s1)
    800048e0:	864e                	mv	a2,s3
    800048e2:	4585                	li	a1,1
    800048e4:	6c88                	ld	a0,24(s1)
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	2a6080e7          	jalr	678(ra) # 80003b8c <readi>
    800048ee:	892a                	mv	s2,a0
    800048f0:	00a05563          	blez	a0,800048fa <fileread+0x56>
      f->off += r;
    800048f4:	509c                	lw	a5,32(s1)
    800048f6:	9fa9                	addw	a5,a5,a0
    800048f8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800048fa:	6c88                	ld	a0,24(s1)
    800048fc:	fffff097          	auipc	ra,0xfffff
    80004900:	09e080e7          	jalr	158(ra) # 8000399a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004904:	854a                	mv	a0,s2
    80004906:	70a2                	ld	ra,40(sp)
    80004908:	7402                	ld	s0,32(sp)
    8000490a:	64e2                	ld	s1,24(sp)
    8000490c:	6942                	ld	s2,16(sp)
    8000490e:	69a2                	ld	s3,8(sp)
    80004910:	6145                	addi	sp,sp,48
    80004912:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004914:	6908                	ld	a0,16(a0)
    80004916:	00000097          	auipc	ra,0x0
    8000491a:	3c6080e7          	jalr	966(ra) # 80004cdc <piperead>
    8000491e:	892a                	mv	s2,a0
    80004920:	b7d5                	j	80004904 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004922:	02451783          	lh	a5,36(a0)
    80004926:	03079693          	slli	a3,a5,0x30
    8000492a:	92c1                	srli	a3,a3,0x30
    8000492c:	4725                	li	a4,9
    8000492e:	02d76863          	bltu	a4,a3,8000495e <fileread+0xba>
    80004932:	0792                	slli	a5,a5,0x4
    80004934:	0023c717          	auipc	a4,0x23c
    80004938:	2b470713          	addi	a4,a4,692 # 80240be8 <devsw>
    8000493c:	97ba                	add	a5,a5,a4
    8000493e:	639c                	ld	a5,0(a5)
    80004940:	c38d                	beqz	a5,80004962 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004942:	4505                	li	a0,1
    80004944:	9782                	jalr	a5
    80004946:	892a                	mv	s2,a0
    80004948:	bf75                	j	80004904 <fileread+0x60>
    panic("fileread");
    8000494a:	00004517          	auipc	a0,0x4
    8000494e:	d9e50513          	addi	a0,a0,-610 # 800086e8 <syscalls+0x258>
    80004952:	ffffc097          	auipc	ra,0xffffc
    80004956:	bec080e7          	jalr	-1044(ra) # 8000053e <panic>
    return -1;
    8000495a:	597d                	li	s2,-1
    8000495c:	b765                	j	80004904 <fileread+0x60>
      return -1;
    8000495e:	597d                	li	s2,-1
    80004960:	b755                	j	80004904 <fileread+0x60>
    80004962:	597d                	li	s2,-1
    80004964:	b745                	j	80004904 <fileread+0x60>

0000000080004966 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004966:	715d                	addi	sp,sp,-80
    80004968:	e486                	sd	ra,72(sp)
    8000496a:	e0a2                	sd	s0,64(sp)
    8000496c:	fc26                	sd	s1,56(sp)
    8000496e:	f84a                	sd	s2,48(sp)
    80004970:	f44e                	sd	s3,40(sp)
    80004972:	f052                	sd	s4,32(sp)
    80004974:	ec56                	sd	s5,24(sp)
    80004976:	e85a                	sd	s6,16(sp)
    80004978:	e45e                	sd	s7,8(sp)
    8000497a:	e062                	sd	s8,0(sp)
    8000497c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    8000497e:	00954783          	lbu	a5,9(a0)
    80004982:	10078663          	beqz	a5,80004a8e <filewrite+0x128>
    80004986:	892a                	mv	s2,a0
    80004988:	8aae                	mv	s5,a1
    8000498a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000498c:	411c                	lw	a5,0(a0)
    8000498e:	4705                	li	a4,1
    80004990:	02e78263          	beq	a5,a4,800049b4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004994:	470d                	li	a4,3
    80004996:	02e78663          	beq	a5,a4,800049c2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000499a:	4709                	li	a4,2
    8000499c:	0ee79163          	bne	a5,a4,80004a7e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800049a0:	0ac05d63          	blez	a2,80004a5a <filewrite+0xf4>
    int i = 0;
    800049a4:	4981                	li	s3,0
    800049a6:	6b05                	lui	s6,0x1
    800049a8:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800049ac:	6b85                	lui	s7,0x1
    800049ae:	c00b8b9b          	addiw	s7,s7,-1024
    800049b2:	a861                	j	80004a4a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    800049b4:	6908                	ld	a0,16(a0)
    800049b6:	00000097          	auipc	ra,0x0
    800049ba:	22e080e7          	jalr	558(ra) # 80004be4 <pipewrite>
    800049be:	8a2a                	mv	s4,a0
    800049c0:	a045                	j	80004a60 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800049c2:	02451783          	lh	a5,36(a0)
    800049c6:	03079693          	slli	a3,a5,0x30
    800049ca:	92c1                	srli	a3,a3,0x30
    800049cc:	4725                	li	a4,9
    800049ce:	0cd76263          	bltu	a4,a3,80004a92 <filewrite+0x12c>
    800049d2:	0792                	slli	a5,a5,0x4
    800049d4:	0023c717          	auipc	a4,0x23c
    800049d8:	21470713          	addi	a4,a4,532 # 80240be8 <devsw>
    800049dc:	97ba                	add	a5,a5,a4
    800049de:	679c                	ld	a5,8(a5)
    800049e0:	cbdd                	beqz	a5,80004a96 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    800049e2:	4505                	li	a0,1
    800049e4:	9782                	jalr	a5
    800049e6:	8a2a                	mv	s4,a0
    800049e8:	a8a5                	j	80004a60 <filewrite+0xfa>
    800049ea:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800049ee:	00000097          	auipc	ra,0x0
    800049f2:	8b0080e7          	jalr	-1872(ra) # 8000429e <begin_op>
      ilock(f->ip);
    800049f6:	01893503          	ld	a0,24(s2)
    800049fa:	fffff097          	auipc	ra,0xfffff
    800049fe:	ede080e7          	jalr	-290(ra) # 800038d8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004a02:	8762                	mv	a4,s8
    80004a04:	02092683          	lw	a3,32(s2)
    80004a08:	01598633          	add	a2,s3,s5
    80004a0c:	4585                	li	a1,1
    80004a0e:	01893503          	ld	a0,24(s2)
    80004a12:	fffff097          	auipc	ra,0xfffff
    80004a16:	272080e7          	jalr	626(ra) # 80003c84 <writei>
    80004a1a:	84aa                	mv	s1,a0
    80004a1c:	00a05763          	blez	a0,80004a2a <filewrite+0xc4>
        f->off += r;
    80004a20:	02092783          	lw	a5,32(s2)
    80004a24:	9fa9                	addw	a5,a5,a0
    80004a26:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004a2a:	01893503          	ld	a0,24(s2)
    80004a2e:	fffff097          	auipc	ra,0xfffff
    80004a32:	f6c080e7          	jalr	-148(ra) # 8000399a <iunlock>
      end_op();
    80004a36:	00000097          	auipc	ra,0x0
    80004a3a:	8e8080e7          	jalr	-1816(ra) # 8000431e <end_op>

      if(r != n1){
    80004a3e:	009c1f63          	bne	s8,s1,80004a5c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004a42:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004a46:	0149db63          	bge	s3,s4,80004a5c <filewrite+0xf6>
      int n1 = n - i;
    80004a4a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004a4e:	84be                	mv	s1,a5
    80004a50:	2781                	sext.w	a5,a5
    80004a52:	f8fb5ce3          	bge	s6,a5,800049ea <filewrite+0x84>
    80004a56:	84de                	mv	s1,s7
    80004a58:	bf49                	j	800049ea <filewrite+0x84>
    int i = 0;
    80004a5a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004a5c:	013a1f63          	bne	s4,s3,80004a7a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004a60:	8552                	mv	a0,s4
    80004a62:	60a6                	ld	ra,72(sp)
    80004a64:	6406                	ld	s0,64(sp)
    80004a66:	74e2                	ld	s1,56(sp)
    80004a68:	7942                	ld	s2,48(sp)
    80004a6a:	79a2                	ld	s3,40(sp)
    80004a6c:	7a02                	ld	s4,32(sp)
    80004a6e:	6ae2                	ld	s5,24(sp)
    80004a70:	6b42                	ld	s6,16(sp)
    80004a72:	6ba2                	ld	s7,8(sp)
    80004a74:	6c02                	ld	s8,0(sp)
    80004a76:	6161                	addi	sp,sp,80
    80004a78:	8082                	ret
    ret = (i == n ? n : -1);
    80004a7a:	5a7d                	li	s4,-1
    80004a7c:	b7d5                	j	80004a60 <filewrite+0xfa>
    panic("filewrite");
    80004a7e:	00004517          	auipc	a0,0x4
    80004a82:	c7a50513          	addi	a0,a0,-902 # 800086f8 <syscalls+0x268>
    80004a86:	ffffc097          	auipc	ra,0xffffc
    80004a8a:	ab8080e7          	jalr	-1352(ra) # 8000053e <panic>
    return -1;
    80004a8e:	5a7d                	li	s4,-1
    80004a90:	bfc1                	j	80004a60 <filewrite+0xfa>
      return -1;
    80004a92:	5a7d                	li	s4,-1
    80004a94:	b7f1                	j	80004a60 <filewrite+0xfa>
    80004a96:	5a7d                	li	s4,-1
    80004a98:	b7e1                	j	80004a60 <filewrite+0xfa>

0000000080004a9a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004a9a:	7179                	addi	sp,sp,-48
    80004a9c:	f406                	sd	ra,40(sp)
    80004a9e:	f022                	sd	s0,32(sp)
    80004aa0:	ec26                	sd	s1,24(sp)
    80004aa2:	e84a                	sd	s2,16(sp)
    80004aa4:	e44e                	sd	s3,8(sp)
    80004aa6:	e052                	sd	s4,0(sp)
    80004aa8:	1800                	addi	s0,sp,48
    80004aaa:	84aa                	mv	s1,a0
    80004aac:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004aae:	0005b023          	sd	zero,0(a1)
    80004ab2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004ab6:	00000097          	auipc	ra,0x0
    80004aba:	bf8080e7          	jalr	-1032(ra) # 800046ae <filealloc>
    80004abe:	e088                	sd	a0,0(s1)
    80004ac0:	c551                	beqz	a0,80004b4c <pipealloc+0xb2>
    80004ac2:	00000097          	auipc	ra,0x0
    80004ac6:	bec080e7          	jalr	-1044(ra) # 800046ae <filealloc>
    80004aca:	00aa3023          	sd	a0,0(s4)
    80004ace:	c92d                	beqz	a0,80004b40 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004ad0:	ffffc097          	auipc	ra,0xffffc
    80004ad4:	0e0080e7          	jalr	224(ra) # 80000bb0 <kalloc>
    80004ad8:	892a                	mv	s2,a0
    80004ada:	c125                	beqz	a0,80004b3a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004adc:	4985                	li	s3,1
    80004ade:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004ae2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004ae6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004aea:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004aee:	00004597          	auipc	a1,0x4
    80004af2:	c1a58593          	addi	a1,a1,-998 # 80008708 <syscalls+0x278>
    80004af6:	ffffc097          	auipc	ra,0xffffc
    80004afa:	14c080e7          	jalr	332(ra) # 80000c42 <initlock>
  (*f0)->type = FD_PIPE;
    80004afe:	609c                	ld	a5,0(s1)
    80004b00:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004b04:	609c                	ld	a5,0(s1)
    80004b06:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004b0a:	609c                	ld	a5,0(s1)
    80004b0c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004b10:	609c                	ld	a5,0(s1)
    80004b12:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004b16:	000a3783          	ld	a5,0(s4)
    80004b1a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004b1e:	000a3783          	ld	a5,0(s4)
    80004b22:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004b26:	000a3783          	ld	a5,0(s4)
    80004b2a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004b2e:	000a3783          	ld	a5,0(s4)
    80004b32:	0127b823          	sd	s2,16(a5)
  return 0;
    80004b36:	4501                	li	a0,0
    80004b38:	a025                	j	80004b60 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004b3a:	6088                	ld	a0,0(s1)
    80004b3c:	e501                	bnez	a0,80004b44 <pipealloc+0xaa>
    80004b3e:	a039                	j	80004b4c <pipealloc+0xb2>
    80004b40:	6088                	ld	a0,0(s1)
    80004b42:	c51d                	beqz	a0,80004b70 <pipealloc+0xd6>
    fileclose(*f0);
    80004b44:	00000097          	auipc	ra,0x0
    80004b48:	c26080e7          	jalr	-986(ra) # 8000476a <fileclose>
  if(*f1)
    80004b4c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004b50:	557d                	li	a0,-1
  if(*f1)
    80004b52:	c799                	beqz	a5,80004b60 <pipealloc+0xc6>
    fileclose(*f1);
    80004b54:	853e                	mv	a0,a5
    80004b56:	00000097          	auipc	ra,0x0
    80004b5a:	c14080e7          	jalr	-1004(ra) # 8000476a <fileclose>
  return -1;
    80004b5e:	557d                	li	a0,-1
}
    80004b60:	70a2                	ld	ra,40(sp)
    80004b62:	7402                	ld	s0,32(sp)
    80004b64:	64e2                	ld	s1,24(sp)
    80004b66:	6942                	ld	s2,16(sp)
    80004b68:	69a2                	ld	s3,8(sp)
    80004b6a:	6a02                	ld	s4,0(sp)
    80004b6c:	6145                	addi	sp,sp,48
    80004b6e:	8082                	ret
  return -1;
    80004b70:	557d                	li	a0,-1
    80004b72:	b7fd                	j	80004b60 <pipealloc+0xc6>

0000000080004b74 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004b74:	1101                	addi	sp,sp,-32
    80004b76:	ec06                	sd	ra,24(sp)
    80004b78:	e822                	sd	s0,16(sp)
    80004b7a:	e426                	sd	s1,8(sp)
    80004b7c:	e04a                	sd	s2,0(sp)
    80004b7e:	1000                	addi	s0,sp,32
    80004b80:	84aa                	mv	s1,a0
    80004b82:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004b84:	ffffc097          	auipc	ra,0xffffc
    80004b88:	14e080e7          	jalr	334(ra) # 80000cd2 <acquire>
  if(writable){
    80004b8c:	02090d63          	beqz	s2,80004bc6 <pipeclose+0x52>
    pi->writeopen = 0;
    80004b90:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004b94:	21848513          	addi	a0,s1,536
    80004b98:	ffffd097          	auipc	ra,0xffffd
    80004b9c:	78e080e7          	jalr	1934(ra) # 80002326 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004ba0:	2204b783          	ld	a5,544(s1)
    80004ba4:	eb95                	bnez	a5,80004bd8 <pipeclose+0x64>
    release(&pi->lock);
    80004ba6:	8526                	mv	a0,s1
    80004ba8:	ffffc097          	auipc	ra,0xffffc
    80004bac:	1de080e7          	jalr	478(ra) # 80000d86 <release>
    kfree((char*)pi);
    80004bb0:	8526                	mv	a0,s1
    80004bb2:	ffffc097          	auipc	ra,0xffffc
    80004bb6:	ea2080e7          	jalr	-350(ra) # 80000a54 <kfree>
  } else
    release(&pi->lock);
}
    80004bba:	60e2                	ld	ra,24(sp)
    80004bbc:	6442                	ld	s0,16(sp)
    80004bbe:	64a2                	ld	s1,8(sp)
    80004bc0:	6902                	ld	s2,0(sp)
    80004bc2:	6105                	addi	sp,sp,32
    80004bc4:	8082                	ret
    pi->readopen = 0;
    80004bc6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004bca:	21c48513          	addi	a0,s1,540
    80004bce:	ffffd097          	auipc	ra,0xffffd
    80004bd2:	758080e7          	jalr	1880(ra) # 80002326 <wakeup>
    80004bd6:	b7e9                	j	80004ba0 <pipeclose+0x2c>
    release(&pi->lock);
    80004bd8:	8526                	mv	a0,s1
    80004bda:	ffffc097          	auipc	ra,0xffffc
    80004bde:	1ac080e7          	jalr	428(ra) # 80000d86 <release>
}
    80004be2:	bfe1                	j	80004bba <pipeclose+0x46>

0000000080004be4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004be4:	711d                	addi	sp,sp,-96
    80004be6:	ec86                	sd	ra,88(sp)
    80004be8:	e8a2                	sd	s0,80(sp)
    80004bea:	e4a6                	sd	s1,72(sp)
    80004bec:	e0ca                	sd	s2,64(sp)
    80004bee:	fc4e                	sd	s3,56(sp)
    80004bf0:	f852                	sd	s4,48(sp)
    80004bf2:	f456                	sd	s5,40(sp)
    80004bf4:	f05a                	sd	s6,32(sp)
    80004bf6:	ec5e                	sd	s7,24(sp)
    80004bf8:	e862                	sd	s8,16(sp)
    80004bfa:	1080                	addi	s0,sp,96
    80004bfc:	84aa                	mv	s1,a0
    80004bfe:	8aae                	mv	s5,a1
    80004c00:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004c02:	ffffd097          	auipc	ra,0xffffd
    80004c06:	014080e7          	jalr	20(ra) # 80001c16 <myproc>
    80004c0a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004c0c:	8526                	mv	a0,s1
    80004c0e:	ffffc097          	auipc	ra,0xffffc
    80004c12:	0c4080e7          	jalr	196(ra) # 80000cd2 <acquire>
  while(i < n){
    80004c16:	0b405663          	blez	s4,80004cc2 <pipewrite+0xde>
  int i = 0;
    80004c1a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c1c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004c1e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004c22:	21c48b93          	addi	s7,s1,540
    80004c26:	a089                	j	80004c68 <pipewrite+0x84>
      release(&pi->lock);
    80004c28:	8526                	mv	a0,s1
    80004c2a:	ffffc097          	auipc	ra,0xffffc
    80004c2e:	15c080e7          	jalr	348(ra) # 80000d86 <release>
      return -1;
    80004c32:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004c34:	854a                	mv	a0,s2
    80004c36:	60e6                	ld	ra,88(sp)
    80004c38:	6446                	ld	s0,80(sp)
    80004c3a:	64a6                	ld	s1,72(sp)
    80004c3c:	6906                	ld	s2,64(sp)
    80004c3e:	79e2                	ld	s3,56(sp)
    80004c40:	7a42                	ld	s4,48(sp)
    80004c42:	7aa2                	ld	s5,40(sp)
    80004c44:	7b02                	ld	s6,32(sp)
    80004c46:	6be2                	ld	s7,24(sp)
    80004c48:	6c42                	ld	s8,16(sp)
    80004c4a:	6125                	addi	sp,sp,96
    80004c4c:	8082                	ret
      wakeup(&pi->nread);
    80004c4e:	8562                	mv	a0,s8
    80004c50:	ffffd097          	auipc	ra,0xffffd
    80004c54:	6d6080e7          	jalr	1750(ra) # 80002326 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004c58:	85a6                	mv	a1,s1
    80004c5a:	855e                	mv	a0,s7
    80004c5c:	ffffd097          	auipc	ra,0xffffd
    80004c60:	666080e7          	jalr	1638(ra) # 800022c2 <sleep>
  while(i < n){
    80004c64:	07495063          	bge	s2,s4,80004cc4 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004c68:	2204a783          	lw	a5,544(s1)
    80004c6c:	dfd5                	beqz	a5,80004c28 <pipewrite+0x44>
    80004c6e:	854e                	mv	a0,s3
    80004c70:	ffffe097          	auipc	ra,0xffffe
    80004c74:	8fa080e7          	jalr	-1798(ra) # 8000256a <killed>
    80004c78:	f945                	bnez	a0,80004c28 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004c7a:	2184a783          	lw	a5,536(s1)
    80004c7e:	21c4a703          	lw	a4,540(s1)
    80004c82:	2007879b          	addiw	a5,a5,512
    80004c86:	fcf704e3          	beq	a4,a5,80004c4e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c8a:	4685                	li	a3,1
    80004c8c:	01590633          	add	a2,s2,s5
    80004c90:	faf40593          	addi	a1,s0,-81
    80004c94:	0509b503          	ld	a0,80(s3)
    80004c98:	ffffd097          	auipc	ra,0xffffd
    80004c9c:	cc6080e7          	jalr	-826(ra) # 8000195e <copyin>
    80004ca0:	03650263          	beq	a0,s6,80004cc4 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004ca4:	21c4a783          	lw	a5,540(s1)
    80004ca8:	0017871b          	addiw	a4,a5,1
    80004cac:	20e4ae23          	sw	a4,540(s1)
    80004cb0:	1ff7f793          	andi	a5,a5,511
    80004cb4:	97a6                	add	a5,a5,s1
    80004cb6:	faf44703          	lbu	a4,-81(s0)
    80004cba:	00e78c23          	sb	a4,24(a5)
      i++;
    80004cbe:	2905                	addiw	s2,s2,1
    80004cc0:	b755                	j	80004c64 <pipewrite+0x80>
  int i = 0;
    80004cc2:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004cc4:	21848513          	addi	a0,s1,536
    80004cc8:	ffffd097          	auipc	ra,0xffffd
    80004ccc:	65e080e7          	jalr	1630(ra) # 80002326 <wakeup>
  release(&pi->lock);
    80004cd0:	8526                	mv	a0,s1
    80004cd2:	ffffc097          	auipc	ra,0xffffc
    80004cd6:	0b4080e7          	jalr	180(ra) # 80000d86 <release>
  return i;
    80004cda:	bfa9                	j	80004c34 <pipewrite+0x50>

0000000080004cdc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004cdc:	715d                	addi	sp,sp,-80
    80004cde:	e486                	sd	ra,72(sp)
    80004ce0:	e0a2                	sd	s0,64(sp)
    80004ce2:	fc26                	sd	s1,56(sp)
    80004ce4:	f84a                	sd	s2,48(sp)
    80004ce6:	f44e                	sd	s3,40(sp)
    80004ce8:	f052                	sd	s4,32(sp)
    80004cea:	ec56                	sd	s5,24(sp)
    80004cec:	e85a                	sd	s6,16(sp)
    80004cee:	0880                	addi	s0,sp,80
    80004cf0:	84aa                	mv	s1,a0
    80004cf2:	892e                	mv	s2,a1
    80004cf4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004cf6:	ffffd097          	auipc	ra,0xffffd
    80004cfa:	f20080e7          	jalr	-224(ra) # 80001c16 <myproc>
    80004cfe:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004d00:	8526                	mv	a0,s1
    80004d02:	ffffc097          	auipc	ra,0xffffc
    80004d06:	fd0080e7          	jalr	-48(ra) # 80000cd2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d0a:	2184a703          	lw	a4,536(s1)
    80004d0e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004d12:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d16:	02f71763          	bne	a4,a5,80004d44 <piperead+0x68>
    80004d1a:	2244a783          	lw	a5,548(s1)
    80004d1e:	c39d                	beqz	a5,80004d44 <piperead+0x68>
    if(killed(pr)){
    80004d20:	8552                	mv	a0,s4
    80004d22:	ffffe097          	auipc	ra,0xffffe
    80004d26:	848080e7          	jalr	-1976(ra) # 8000256a <killed>
    80004d2a:	e941                	bnez	a0,80004dba <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004d2c:	85a6                	mv	a1,s1
    80004d2e:	854e                	mv	a0,s3
    80004d30:	ffffd097          	auipc	ra,0xffffd
    80004d34:	592080e7          	jalr	1426(ra) # 800022c2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d38:	2184a703          	lw	a4,536(s1)
    80004d3c:	21c4a783          	lw	a5,540(s1)
    80004d40:	fcf70de3          	beq	a4,a5,80004d1a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d44:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004d46:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d48:	05505363          	blez	s5,80004d8e <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004d4c:	2184a783          	lw	a5,536(s1)
    80004d50:	21c4a703          	lw	a4,540(s1)
    80004d54:	02f70d63          	beq	a4,a5,80004d8e <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004d58:	0017871b          	addiw	a4,a5,1
    80004d5c:	20e4ac23          	sw	a4,536(s1)
    80004d60:	1ff7f793          	andi	a5,a5,511
    80004d64:	97a6                	add	a5,a5,s1
    80004d66:	0187c783          	lbu	a5,24(a5)
    80004d6a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004d6e:	4685                	li	a3,1
    80004d70:	fbf40613          	addi	a2,s0,-65
    80004d74:	85ca                	mv	a1,s2
    80004d76:	050a3503          	ld	a0,80(s4)
    80004d7a:	ffffd097          	auipc	ra,0xffffd
    80004d7e:	aee080e7          	jalr	-1298(ra) # 80001868 <copyout>
    80004d82:	01650663          	beq	a0,s6,80004d8e <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d86:	2985                	addiw	s3,s3,1
    80004d88:	0905                	addi	s2,s2,1
    80004d8a:	fd3a91e3          	bne	s5,s3,80004d4c <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004d8e:	21c48513          	addi	a0,s1,540
    80004d92:	ffffd097          	auipc	ra,0xffffd
    80004d96:	594080e7          	jalr	1428(ra) # 80002326 <wakeup>
  release(&pi->lock);
    80004d9a:	8526                	mv	a0,s1
    80004d9c:	ffffc097          	auipc	ra,0xffffc
    80004da0:	fea080e7          	jalr	-22(ra) # 80000d86 <release>
  return i;
}
    80004da4:	854e                	mv	a0,s3
    80004da6:	60a6                	ld	ra,72(sp)
    80004da8:	6406                	ld	s0,64(sp)
    80004daa:	74e2                	ld	s1,56(sp)
    80004dac:	7942                	ld	s2,48(sp)
    80004dae:	79a2                	ld	s3,40(sp)
    80004db0:	7a02                	ld	s4,32(sp)
    80004db2:	6ae2                	ld	s5,24(sp)
    80004db4:	6b42                	ld	s6,16(sp)
    80004db6:	6161                	addi	sp,sp,80
    80004db8:	8082                	ret
      release(&pi->lock);
    80004dba:	8526                	mv	a0,s1
    80004dbc:	ffffc097          	auipc	ra,0xffffc
    80004dc0:	fca080e7          	jalr	-54(ra) # 80000d86 <release>
      return -1;
    80004dc4:	59fd                	li	s3,-1
    80004dc6:	bff9                	j	80004da4 <piperead+0xc8>

0000000080004dc8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004dc8:	1141                	addi	sp,sp,-16
    80004dca:	e422                	sd	s0,8(sp)
    80004dcc:	0800                	addi	s0,sp,16
    80004dce:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004dd0:	8905                	andi	a0,a0,1
    80004dd2:	c111                	beqz	a0,80004dd6 <flags2perm+0xe>
      perm = PTE_X;
    80004dd4:	4521                	li	a0,8
    if(flags & 0x2)
    80004dd6:	8b89                	andi	a5,a5,2
    80004dd8:	c399                	beqz	a5,80004dde <flags2perm+0x16>
      perm |= PTE_W;
    80004dda:	00456513          	ori	a0,a0,4
    return perm;
}
    80004dde:	6422                	ld	s0,8(sp)
    80004de0:	0141                	addi	sp,sp,16
    80004de2:	8082                	ret

0000000080004de4 <exec>:

int
exec(char *path, char **argv)
{
    80004de4:	de010113          	addi	sp,sp,-544
    80004de8:	20113c23          	sd	ra,536(sp)
    80004dec:	20813823          	sd	s0,528(sp)
    80004df0:	20913423          	sd	s1,520(sp)
    80004df4:	21213023          	sd	s2,512(sp)
    80004df8:	ffce                	sd	s3,504(sp)
    80004dfa:	fbd2                	sd	s4,496(sp)
    80004dfc:	f7d6                	sd	s5,488(sp)
    80004dfe:	f3da                	sd	s6,480(sp)
    80004e00:	efde                	sd	s7,472(sp)
    80004e02:	ebe2                	sd	s8,464(sp)
    80004e04:	e7e6                	sd	s9,456(sp)
    80004e06:	e3ea                	sd	s10,448(sp)
    80004e08:	ff6e                	sd	s11,440(sp)
    80004e0a:	1400                	addi	s0,sp,544
    80004e0c:	892a                	mv	s2,a0
    80004e0e:	dea43423          	sd	a0,-536(s0)
    80004e12:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	e00080e7          	jalr	-512(ra) # 80001c16 <myproc>
    80004e1e:	84aa                	mv	s1,a0

  begin_op();
    80004e20:	fffff097          	auipc	ra,0xfffff
    80004e24:	47e080e7          	jalr	1150(ra) # 8000429e <begin_op>

  if((ip = namei(path)) == 0){
    80004e28:	854a                	mv	a0,s2
    80004e2a:	fffff097          	auipc	ra,0xfffff
    80004e2e:	254080e7          	jalr	596(ra) # 8000407e <namei>
    80004e32:	c93d                	beqz	a0,80004ea8 <exec+0xc4>
    80004e34:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004e36:	fffff097          	auipc	ra,0xfffff
    80004e3a:	aa2080e7          	jalr	-1374(ra) # 800038d8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004e3e:	04000713          	li	a4,64
    80004e42:	4681                	li	a3,0
    80004e44:	e5040613          	addi	a2,s0,-432
    80004e48:	4581                	li	a1,0
    80004e4a:	8556                	mv	a0,s5
    80004e4c:	fffff097          	auipc	ra,0xfffff
    80004e50:	d40080e7          	jalr	-704(ra) # 80003b8c <readi>
    80004e54:	04000793          	li	a5,64
    80004e58:	00f51a63          	bne	a0,a5,80004e6c <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004e5c:	e5042703          	lw	a4,-432(s0)
    80004e60:	464c47b7          	lui	a5,0x464c4
    80004e64:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004e68:	04f70663          	beq	a4,a5,80004eb4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004e6c:	8556                	mv	a0,s5
    80004e6e:	fffff097          	auipc	ra,0xfffff
    80004e72:	ccc080e7          	jalr	-820(ra) # 80003b3a <iunlockput>
    end_op();
    80004e76:	fffff097          	auipc	ra,0xfffff
    80004e7a:	4a8080e7          	jalr	1192(ra) # 8000431e <end_op>
  }
  return -1;
    80004e7e:	557d                	li	a0,-1
}
    80004e80:	21813083          	ld	ra,536(sp)
    80004e84:	21013403          	ld	s0,528(sp)
    80004e88:	20813483          	ld	s1,520(sp)
    80004e8c:	20013903          	ld	s2,512(sp)
    80004e90:	79fe                	ld	s3,504(sp)
    80004e92:	7a5e                	ld	s4,496(sp)
    80004e94:	7abe                	ld	s5,488(sp)
    80004e96:	7b1e                	ld	s6,480(sp)
    80004e98:	6bfe                	ld	s7,472(sp)
    80004e9a:	6c5e                	ld	s8,464(sp)
    80004e9c:	6cbe                	ld	s9,456(sp)
    80004e9e:	6d1e                	ld	s10,448(sp)
    80004ea0:	7dfa                	ld	s11,440(sp)
    80004ea2:	22010113          	addi	sp,sp,544
    80004ea6:	8082                	ret
    end_op();
    80004ea8:	fffff097          	auipc	ra,0xfffff
    80004eac:	476080e7          	jalr	1142(ra) # 8000431e <end_op>
    return -1;
    80004eb0:	557d                	li	a0,-1
    80004eb2:	b7f9                	j	80004e80 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004eb4:	8526                	mv	a0,s1
    80004eb6:	ffffd097          	auipc	ra,0xffffd
    80004eba:	e28080e7          	jalr	-472(ra) # 80001cde <proc_pagetable>
    80004ebe:	8b2a                	mv	s6,a0
    80004ec0:	d555                	beqz	a0,80004e6c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004ec2:	e7042783          	lw	a5,-400(s0)
    80004ec6:	e8845703          	lhu	a4,-376(s0)
    80004eca:	c735                	beqz	a4,80004f36 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004ecc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004ece:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004ed2:	6a05                	lui	s4,0x1
    80004ed4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004ed8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004edc:	6d85                	lui	s11,0x1
    80004ede:	7d7d                	lui	s10,0xfffff
    80004ee0:	a481                	j	80005120 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004ee2:	00004517          	auipc	a0,0x4
    80004ee6:	82e50513          	addi	a0,a0,-2002 # 80008710 <syscalls+0x280>
    80004eea:	ffffb097          	auipc	ra,0xffffb
    80004eee:	654080e7          	jalr	1620(ra) # 8000053e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004ef2:	874a                	mv	a4,s2
    80004ef4:	009c86bb          	addw	a3,s9,s1
    80004ef8:	4581                	li	a1,0
    80004efa:	8556                	mv	a0,s5
    80004efc:	fffff097          	auipc	ra,0xfffff
    80004f00:	c90080e7          	jalr	-880(ra) # 80003b8c <readi>
    80004f04:	2501                	sext.w	a0,a0
    80004f06:	1aa91a63          	bne	s2,a0,800050ba <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    80004f0a:	009d84bb          	addw	s1,s11,s1
    80004f0e:	013d09bb          	addw	s3,s10,s3
    80004f12:	1f74f763          	bgeu	s1,s7,80005100 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    80004f16:	02049593          	slli	a1,s1,0x20
    80004f1a:	9181                	srli	a1,a1,0x20
    80004f1c:	95e2                	add	a1,a1,s8
    80004f1e:	855a                	mv	a0,s6
    80004f20:	ffffc097          	auipc	ra,0xffffc
    80004f24:	238080e7          	jalr	568(ra) # 80001158 <walkaddr>
    80004f28:	862a                	mv	a2,a0
    if(pa == 0)
    80004f2a:	dd45                	beqz	a0,80004ee2 <exec+0xfe>
      n = PGSIZE;
    80004f2c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004f2e:	fd49f2e3          	bgeu	s3,s4,80004ef2 <exec+0x10e>
      n = sz - i;
    80004f32:	894e                	mv	s2,s3
    80004f34:	bf7d                	j	80004ef2 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004f36:	4901                	li	s2,0
  iunlockput(ip);
    80004f38:	8556                	mv	a0,s5
    80004f3a:	fffff097          	auipc	ra,0xfffff
    80004f3e:	c00080e7          	jalr	-1024(ra) # 80003b3a <iunlockput>
  end_op();
    80004f42:	fffff097          	auipc	ra,0xfffff
    80004f46:	3dc080e7          	jalr	988(ra) # 8000431e <end_op>
  p = myproc();
    80004f4a:	ffffd097          	auipc	ra,0xffffd
    80004f4e:	ccc080e7          	jalr	-820(ra) # 80001c16 <myproc>
    80004f52:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004f54:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004f58:	6785                	lui	a5,0x1
    80004f5a:	17fd                	addi	a5,a5,-1
    80004f5c:	993e                	add	s2,s2,a5
    80004f5e:	77fd                	lui	a5,0xfffff
    80004f60:	00f977b3          	and	a5,s2,a5
    80004f64:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004f68:	4691                	li	a3,4
    80004f6a:	6609                	lui	a2,0x2
    80004f6c:	963e                	add	a2,a2,a5
    80004f6e:	85be                	mv	a1,a5
    80004f70:	855a                	mv	a0,s6
    80004f72:	ffffc097          	auipc	ra,0xffffc
    80004f76:	5be080e7          	jalr	1470(ra) # 80001530 <uvmalloc>
    80004f7a:	8c2a                	mv	s8,a0
  ip = 0;
    80004f7c:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004f7e:	12050e63          	beqz	a0,800050ba <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004f82:	75f9                	lui	a1,0xffffe
    80004f84:	95aa                	add	a1,a1,a0
    80004f86:	855a                	mv	a0,s6
    80004f88:	ffffd097          	auipc	ra,0xffffd
    80004f8c:	80a080e7          	jalr	-2038(ra) # 80001792 <uvmclear>
  stackbase = sp - PGSIZE;
    80004f90:	7afd                	lui	s5,0xfffff
    80004f92:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004f94:	df043783          	ld	a5,-528(s0)
    80004f98:	6388                	ld	a0,0(a5)
    80004f9a:	c925                	beqz	a0,8000500a <exec+0x226>
    80004f9c:	e9040993          	addi	s3,s0,-368
    80004fa0:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004fa4:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004fa6:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004fa8:	ffffc097          	auipc	ra,0xffffc
    80004fac:	fa2080e7          	jalr	-94(ra) # 80000f4a <strlen>
    80004fb0:	0015079b          	addiw	a5,a0,1
    80004fb4:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004fb8:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004fbc:	13596663          	bltu	s2,s5,800050e8 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004fc0:	df043d83          	ld	s11,-528(s0)
    80004fc4:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004fc8:	8552                	mv	a0,s4
    80004fca:	ffffc097          	auipc	ra,0xffffc
    80004fce:	f80080e7          	jalr	-128(ra) # 80000f4a <strlen>
    80004fd2:	0015069b          	addiw	a3,a0,1
    80004fd6:	8652                	mv	a2,s4
    80004fd8:	85ca                	mv	a1,s2
    80004fda:	855a                	mv	a0,s6
    80004fdc:	ffffd097          	auipc	ra,0xffffd
    80004fe0:	88c080e7          	jalr	-1908(ra) # 80001868 <copyout>
    80004fe4:	10054663          	bltz	a0,800050f0 <exec+0x30c>
    ustack[argc] = sp;
    80004fe8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004fec:	0485                	addi	s1,s1,1
    80004fee:	008d8793          	addi	a5,s11,8
    80004ff2:	def43823          	sd	a5,-528(s0)
    80004ff6:	008db503          	ld	a0,8(s11)
    80004ffa:	c911                	beqz	a0,8000500e <exec+0x22a>
    if(argc >= MAXARG)
    80004ffc:	09a1                	addi	s3,s3,8
    80004ffe:	fb3c95e3          	bne	s9,s3,80004fa8 <exec+0x1c4>
  sz = sz1;
    80005002:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005006:	4a81                	li	s5,0
    80005008:	a84d                	j	800050ba <exec+0x2d6>
  sp = sz;
    8000500a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000500c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000500e:	00349793          	slli	a5,s1,0x3
    80005012:	f9040713          	addi	a4,s0,-112
    80005016:	97ba                	add	a5,a5,a4
    80005018:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7fdbd180>
  sp -= (argc+1) * sizeof(uint64);
    8000501c:	00148693          	addi	a3,s1,1
    80005020:	068e                	slli	a3,a3,0x3
    80005022:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005026:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000502a:	01597663          	bgeu	s2,s5,80005036 <exec+0x252>
  sz = sz1;
    8000502e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005032:	4a81                	li	s5,0
    80005034:	a059                	j	800050ba <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005036:	e9040613          	addi	a2,s0,-368
    8000503a:	85ca                	mv	a1,s2
    8000503c:	855a                	mv	a0,s6
    8000503e:	ffffd097          	auipc	ra,0xffffd
    80005042:	82a080e7          	jalr	-2006(ra) # 80001868 <copyout>
    80005046:	0a054963          	bltz	a0,800050f8 <exec+0x314>
  p->trapframe->a1 = sp;
    8000504a:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    8000504e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005052:	de843783          	ld	a5,-536(s0)
    80005056:	0007c703          	lbu	a4,0(a5)
    8000505a:	cf11                	beqz	a4,80005076 <exec+0x292>
    8000505c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000505e:	02f00693          	li	a3,47
    80005062:	a039                	j	80005070 <exec+0x28c>
      last = s+1;
    80005064:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005068:	0785                	addi	a5,a5,1
    8000506a:	fff7c703          	lbu	a4,-1(a5)
    8000506e:	c701                	beqz	a4,80005076 <exec+0x292>
    if(*s == '/')
    80005070:	fed71ce3          	bne	a4,a3,80005068 <exec+0x284>
    80005074:	bfc5                	j	80005064 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    80005076:	4641                	li	a2,16
    80005078:	de843583          	ld	a1,-536(s0)
    8000507c:	158b8513          	addi	a0,s7,344
    80005080:	ffffc097          	auipc	ra,0xffffc
    80005084:	e98080e7          	jalr	-360(ra) # 80000f18 <safestrcpy>
  oldpagetable = p->pagetable;
    80005088:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000508c:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005090:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005094:	058bb783          	ld	a5,88(s7)
    80005098:	e6843703          	ld	a4,-408(s0)
    8000509c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000509e:	058bb783          	ld	a5,88(s7)
    800050a2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800050a6:	85ea                	mv	a1,s10
    800050a8:	ffffd097          	auipc	ra,0xffffd
    800050ac:	cd2080e7          	jalr	-814(ra) # 80001d7a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800050b0:	0004851b          	sext.w	a0,s1
    800050b4:	b3f1                	j	80004e80 <exec+0x9c>
    800050b6:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800050ba:	df843583          	ld	a1,-520(s0)
    800050be:	855a                	mv	a0,s6
    800050c0:	ffffd097          	auipc	ra,0xffffd
    800050c4:	cba080e7          	jalr	-838(ra) # 80001d7a <proc_freepagetable>
  if(ip){
    800050c8:	da0a92e3          	bnez	s5,80004e6c <exec+0x88>
  return -1;
    800050cc:	557d                	li	a0,-1
    800050ce:	bb4d                	j	80004e80 <exec+0x9c>
    800050d0:	df243c23          	sd	s2,-520(s0)
    800050d4:	b7dd                	j	800050ba <exec+0x2d6>
    800050d6:	df243c23          	sd	s2,-520(s0)
    800050da:	b7c5                	j	800050ba <exec+0x2d6>
    800050dc:	df243c23          	sd	s2,-520(s0)
    800050e0:	bfe9                	j	800050ba <exec+0x2d6>
    800050e2:	df243c23          	sd	s2,-520(s0)
    800050e6:	bfd1                	j	800050ba <exec+0x2d6>
  sz = sz1;
    800050e8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800050ec:	4a81                	li	s5,0
    800050ee:	b7f1                	j	800050ba <exec+0x2d6>
  sz = sz1;
    800050f0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800050f4:	4a81                	li	s5,0
    800050f6:	b7d1                	j	800050ba <exec+0x2d6>
  sz = sz1;
    800050f8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800050fc:	4a81                	li	s5,0
    800050fe:	bf75                	j	800050ba <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005100:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005104:	e0843783          	ld	a5,-504(s0)
    80005108:	0017869b          	addiw	a3,a5,1
    8000510c:	e0d43423          	sd	a3,-504(s0)
    80005110:	e0043783          	ld	a5,-512(s0)
    80005114:	0387879b          	addiw	a5,a5,56
    80005118:	e8845703          	lhu	a4,-376(s0)
    8000511c:	e0e6dee3          	bge	a3,a4,80004f38 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005120:	2781                	sext.w	a5,a5
    80005122:	e0f43023          	sd	a5,-512(s0)
    80005126:	03800713          	li	a4,56
    8000512a:	86be                	mv	a3,a5
    8000512c:	e1840613          	addi	a2,s0,-488
    80005130:	4581                	li	a1,0
    80005132:	8556                	mv	a0,s5
    80005134:	fffff097          	auipc	ra,0xfffff
    80005138:	a58080e7          	jalr	-1448(ra) # 80003b8c <readi>
    8000513c:	03800793          	li	a5,56
    80005140:	f6f51be3          	bne	a0,a5,800050b6 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    80005144:	e1842783          	lw	a5,-488(s0)
    80005148:	4705                	li	a4,1
    8000514a:	fae79de3          	bne	a5,a4,80005104 <exec+0x320>
    if(ph.memsz < ph.filesz)
    8000514e:	e4043483          	ld	s1,-448(s0)
    80005152:	e3843783          	ld	a5,-456(s0)
    80005156:	f6f4ede3          	bltu	s1,a5,800050d0 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000515a:	e2843783          	ld	a5,-472(s0)
    8000515e:	94be                	add	s1,s1,a5
    80005160:	f6f4ebe3          	bltu	s1,a5,800050d6 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    80005164:	de043703          	ld	a4,-544(s0)
    80005168:	8ff9                	and	a5,a5,a4
    8000516a:	fbad                	bnez	a5,800050dc <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000516c:	e1c42503          	lw	a0,-484(s0)
    80005170:	00000097          	auipc	ra,0x0
    80005174:	c58080e7          	jalr	-936(ra) # 80004dc8 <flags2perm>
    80005178:	86aa                	mv	a3,a0
    8000517a:	8626                	mv	a2,s1
    8000517c:	85ca                	mv	a1,s2
    8000517e:	855a                	mv	a0,s6
    80005180:	ffffc097          	auipc	ra,0xffffc
    80005184:	3b0080e7          	jalr	944(ra) # 80001530 <uvmalloc>
    80005188:	dea43c23          	sd	a0,-520(s0)
    8000518c:	d939                	beqz	a0,800050e2 <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000518e:	e2843c03          	ld	s8,-472(s0)
    80005192:	e2042c83          	lw	s9,-480(s0)
    80005196:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000519a:	f60b83e3          	beqz	s7,80005100 <exec+0x31c>
    8000519e:	89de                	mv	s3,s7
    800051a0:	4481                	li	s1,0
    800051a2:	bb95                	j	80004f16 <exec+0x132>

00000000800051a4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800051a4:	7179                	addi	sp,sp,-48
    800051a6:	f406                	sd	ra,40(sp)
    800051a8:	f022                	sd	s0,32(sp)
    800051aa:	ec26                	sd	s1,24(sp)
    800051ac:	e84a                	sd	s2,16(sp)
    800051ae:	1800                	addi	s0,sp,48
    800051b0:	892e                	mv	s2,a1
    800051b2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800051b4:	fdc40593          	addi	a1,s0,-36
    800051b8:	ffffe097          	auipc	ra,0xffffe
    800051bc:	ba4080e7          	jalr	-1116(ra) # 80002d5c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800051c0:	fdc42703          	lw	a4,-36(s0)
    800051c4:	47bd                	li	a5,15
    800051c6:	02e7eb63          	bltu	a5,a4,800051fc <argfd+0x58>
    800051ca:	ffffd097          	auipc	ra,0xffffd
    800051ce:	a4c080e7          	jalr	-1460(ra) # 80001c16 <myproc>
    800051d2:	fdc42703          	lw	a4,-36(s0)
    800051d6:	01a70793          	addi	a5,a4,26
    800051da:	078e                	slli	a5,a5,0x3
    800051dc:	953e                	add	a0,a0,a5
    800051de:	611c                	ld	a5,0(a0)
    800051e0:	c385                	beqz	a5,80005200 <argfd+0x5c>
    return -1;
  if(pfd)
    800051e2:	00090463          	beqz	s2,800051ea <argfd+0x46>
    *pfd = fd;
    800051e6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800051ea:	4501                	li	a0,0
  if(pf)
    800051ec:	c091                	beqz	s1,800051f0 <argfd+0x4c>
    *pf = f;
    800051ee:	e09c                	sd	a5,0(s1)
}
    800051f0:	70a2                	ld	ra,40(sp)
    800051f2:	7402                	ld	s0,32(sp)
    800051f4:	64e2                	ld	s1,24(sp)
    800051f6:	6942                	ld	s2,16(sp)
    800051f8:	6145                	addi	sp,sp,48
    800051fa:	8082                	ret
    return -1;
    800051fc:	557d                	li	a0,-1
    800051fe:	bfcd                	j	800051f0 <argfd+0x4c>
    80005200:	557d                	li	a0,-1
    80005202:	b7fd                	j	800051f0 <argfd+0x4c>

0000000080005204 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005204:	1101                	addi	sp,sp,-32
    80005206:	ec06                	sd	ra,24(sp)
    80005208:	e822                	sd	s0,16(sp)
    8000520a:	e426                	sd	s1,8(sp)
    8000520c:	1000                	addi	s0,sp,32
    8000520e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005210:	ffffd097          	auipc	ra,0xffffd
    80005214:	a06080e7          	jalr	-1530(ra) # 80001c16 <myproc>
    80005218:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000521a:	0d050793          	addi	a5,a0,208
    8000521e:	4501                	li	a0,0
    80005220:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005222:	6398                	ld	a4,0(a5)
    80005224:	cb19                	beqz	a4,8000523a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005226:	2505                	addiw	a0,a0,1
    80005228:	07a1                	addi	a5,a5,8
    8000522a:	fed51ce3          	bne	a0,a3,80005222 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000522e:	557d                	li	a0,-1
}
    80005230:	60e2                	ld	ra,24(sp)
    80005232:	6442                	ld	s0,16(sp)
    80005234:	64a2                	ld	s1,8(sp)
    80005236:	6105                	addi	sp,sp,32
    80005238:	8082                	ret
      p->ofile[fd] = f;
    8000523a:	01a50793          	addi	a5,a0,26
    8000523e:	078e                	slli	a5,a5,0x3
    80005240:	963e                	add	a2,a2,a5
    80005242:	e204                	sd	s1,0(a2)
      return fd;
    80005244:	b7f5                	j	80005230 <fdalloc+0x2c>

0000000080005246 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005246:	715d                	addi	sp,sp,-80
    80005248:	e486                	sd	ra,72(sp)
    8000524a:	e0a2                	sd	s0,64(sp)
    8000524c:	fc26                	sd	s1,56(sp)
    8000524e:	f84a                	sd	s2,48(sp)
    80005250:	f44e                	sd	s3,40(sp)
    80005252:	f052                	sd	s4,32(sp)
    80005254:	ec56                	sd	s5,24(sp)
    80005256:	e85a                	sd	s6,16(sp)
    80005258:	0880                	addi	s0,sp,80
    8000525a:	8b2e                	mv	s6,a1
    8000525c:	89b2                	mv	s3,a2
    8000525e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005260:	fb040593          	addi	a1,s0,-80
    80005264:	fffff097          	auipc	ra,0xfffff
    80005268:	e38080e7          	jalr	-456(ra) # 8000409c <nameiparent>
    8000526c:	84aa                	mv	s1,a0
    8000526e:	14050f63          	beqz	a0,800053cc <create+0x186>
    return 0;

  ilock(dp);
    80005272:	ffffe097          	auipc	ra,0xffffe
    80005276:	666080e7          	jalr	1638(ra) # 800038d8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000527a:	4601                	li	a2,0
    8000527c:	fb040593          	addi	a1,s0,-80
    80005280:	8526                	mv	a0,s1
    80005282:	fffff097          	auipc	ra,0xfffff
    80005286:	b3a080e7          	jalr	-1222(ra) # 80003dbc <dirlookup>
    8000528a:	8aaa                	mv	s5,a0
    8000528c:	c931                	beqz	a0,800052e0 <create+0x9a>
    iunlockput(dp);
    8000528e:	8526                	mv	a0,s1
    80005290:	fffff097          	auipc	ra,0xfffff
    80005294:	8aa080e7          	jalr	-1878(ra) # 80003b3a <iunlockput>
    ilock(ip);
    80005298:	8556                	mv	a0,s5
    8000529a:	ffffe097          	auipc	ra,0xffffe
    8000529e:	63e080e7          	jalr	1598(ra) # 800038d8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800052a2:	000b059b          	sext.w	a1,s6
    800052a6:	4789                	li	a5,2
    800052a8:	02f59563          	bne	a1,a5,800052d2 <create+0x8c>
    800052ac:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7fdbd2c4>
    800052b0:	37f9                	addiw	a5,a5,-2
    800052b2:	17c2                	slli	a5,a5,0x30
    800052b4:	93c1                	srli	a5,a5,0x30
    800052b6:	4705                	li	a4,1
    800052b8:	00f76d63          	bltu	a4,a5,800052d2 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800052bc:	8556                	mv	a0,s5
    800052be:	60a6                	ld	ra,72(sp)
    800052c0:	6406                	ld	s0,64(sp)
    800052c2:	74e2                	ld	s1,56(sp)
    800052c4:	7942                	ld	s2,48(sp)
    800052c6:	79a2                	ld	s3,40(sp)
    800052c8:	7a02                	ld	s4,32(sp)
    800052ca:	6ae2                	ld	s5,24(sp)
    800052cc:	6b42                	ld	s6,16(sp)
    800052ce:	6161                	addi	sp,sp,80
    800052d0:	8082                	ret
    iunlockput(ip);
    800052d2:	8556                	mv	a0,s5
    800052d4:	fffff097          	auipc	ra,0xfffff
    800052d8:	866080e7          	jalr	-1946(ra) # 80003b3a <iunlockput>
    return 0;
    800052dc:	4a81                	li	s5,0
    800052de:	bff9                	j	800052bc <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800052e0:	85da                	mv	a1,s6
    800052e2:	4088                	lw	a0,0(s1)
    800052e4:	ffffe097          	auipc	ra,0xffffe
    800052e8:	458080e7          	jalr	1112(ra) # 8000373c <ialloc>
    800052ec:	8a2a                	mv	s4,a0
    800052ee:	c539                	beqz	a0,8000533c <create+0xf6>
  ilock(ip);
    800052f0:	ffffe097          	auipc	ra,0xffffe
    800052f4:	5e8080e7          	jalr	1512(ra) # 800038d8 <ilock>
  ip->major = major;
    800052f8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800052fc:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005300:	4905                	li	s2,1
    80005302:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005306:	8552                	mv	a0,s4
    80005308:	ffffe097          	auipc	ra,0xffffe
    8000530c:	506080e7          	jalr	1286(ra) # 8000380e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005310:	000b059b          	sext.w	a1,s6
    80005314:	03258b63          	beq	a1,s2,8000534a <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80005318:	004a2603          	lw	a2,4(s4)
    8000531c:	fb040593          	addi	a1,s0,-80
    80005320:	8526                	mv	a0,s1
    80005322:	fffff097          	auipc	ra,0xfffff
    80005326:	caa080e7          	jalr	-854(ra) # 80003fcc <dirlink>
    8000532a:	06054f63          	bltz	a0,800053a8 <create+0x162>
  iunlockput(dp);
    8000532e:	8526                	mv	a0,s1
    80005330:	fffff097          	auipc	ra,0xfffff
    80005334:	80a080e7          	jalr	-2038(ra) # 80003b3a <iunlockput>
  return ip;
    80005338:	8ad2                	mv	s5,s4
    8000533a:	b749                	j	800052bc <create+0x76>
    iunlockput(dp);
    8000533c:	8526                	mv	a0,s1
    8000533e:	ffffe097          	auipc	ra,0xffffe
    80005342:	7fc080e7          	jalr	2044(ra) # 80003b3a <iunlockput>
    return 0;
    80005346:	8ad2                	mv	s5,s4
    80005348:	bf95                	j	800052bc <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000534a:	004a2603          	lw	a2,4(s4)
    8000534e:	00003597          	auipc	a1,0x3
    80005352:	3e258593          	addi	a1,a1,994 # 80008730 <syscalls+0x2a0>
    80005356:	8552                	mv	a0,s4
    80005358:	fffff097          	auipc	ra,0xfffff
    8000535c:	c74080e7          	jalr	-908(ra) # 80003fcc <dirlink>
    80005360:	04054463          	bltz	a0,800053a8 <create+0x162>
    80005364:	40d0                	lw	a2,4(s1)
    80005366:	00003597          	auipc	a1,0x3
    8000536a:	3d258593          	addi	a1,a1,978 # 80008738 <syscalls+0x2a8>
    8000536e:	8552                	mv	a0,s4
    80005370:	fffff097          	auipc	ra,0xfffff
    80005374:	c5c080e7          	jalr	-932(ra) # 80003fcc <dirlink>
    80005378:	02054863          	bltz	a0,800053a8 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    8000537c:	004a2603          	lw	a2,4(s4)
    80005380:	fb040593          	addi	a1,s0,-80
    80005384:	8526                	mv	a0,s1
    80005386:	fffff097          	auipc	ra,0xfffff
    8000538a:	c46080e7          	jalr	-954(ra) # 80003fcc <dirlink>
    8000538e:	00054d63          	bltz	a0,800053a8 <create+0x162>
    dp->nlink++;  // for ".."
    80005392:	04a4d783          	lhu	a5,74(s1)
    80005396:	2785                	addiw	a5,a5,1
    80005398:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000539c:	8526                	mv	a0,s1
    8000539e:	ffffe097          	auipc	ra,0xffffe
    800053a2:	470080e7          	jalr	1136(ra) # 8000380e <iupdate>
    800053a6:	b761                	j	8000532e <create+0xe8>
  ip->nlink = 0;
    800053a8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800053ac:	8552                	mv	a0,s4
    800053ae:	ffffe097          	auipc	ra,0xffffe
    800053b2:	460080e7          	jalr	1120(ra) # 8000380e <iupdate>
  iunlockput(ip);
    800053b6:	8552                	mv	a0,s4
    800053b8:	ffffe097          	auipc	ra,0xffffe
    800053bc:	782080e7          	jalr	1922(ra) # 80003b3a <iunlockput>
  iunlockput(dp);
    800053c0:	8526                	mv	a0,s1
    800053c2:	ffffe097          	auipc	ra,0xffffe
    800053c6:	778080e7          	jalr	1912(ra) # 80003b3a <iunlockput>
  return 0;
    800053ca:	bdcd                	j	800052bc <create+0x76>
    return 0;
    800053cc:	8aaa                	mv	s5,a0
    800053ce:	b5fd                	j	800052bc <create+0x76>

00000000800053d0 <sys_dup>:
{
    800053d0:	7179                	addi	sp,sp,-48
    800053d2:	f406                	sd	ra,40(sp)
    800053d4:	f022                	sd	s0,32(sp)
    800053d6:	ec26                	sd	s1,24(sp)
    800053d8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800053da:	fd840613          	addi	a2,s0,-40
    800053de:	4581                	li	a1,0
    800053e0:	4501                	li	a0,0
    800053e2:	00000097          	auipc	ra,0x0
    800053e6:	dc2080e7          	jalr	-574(ra) # 800051a4 <argfd>
    return -1;
    800053ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800053ec:	02054363          	bltz	a0,80005412 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800053f0:	fd843503          	ld	a0,-40(s0)
    800053f4:	00000097          	auipc	ra,0x0
    800053f8:	e10080e7          	jalr	-496(ra) # 80005204 <fdalloc>
    800053fc:	84aa                	mv	s1,a0
    return -1;
    800053fe:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005400:	00054963          	bltz	a0,80005412 <sys_dup+0x42>
  filedup(f);
    80005404:	fd843503          	ld	a0,-40(s0)
    80005408:	fffff097          	auipc	ra,0xfffff
    8000540c:	310080e7          	jalr	784(ra) # 80004718 <filedup>
  return fd;
    80005410:	87a6                	mv	a5,s1
}
    80005412:	853e                	mv	a0,a5
    80005414:	70a2                	ld	ra,40(sp)
    80005416:	7402                	ld	s0,32(sp)
    80005418:	64e2                	ld	s1,24(sp)
    8000541a:	6145                	addi	sp,sp,48
    8000541c:	8082                	ret

000000008000541e <sys_read>:
{
    8000541e:	7179                	addi	sp,sp,-48
    80005420:	f406                	sd	ra,40(sp)
    80005422:	f022                	sd	s0,32(sp)
    80005424:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005426:	fd840593          	addi	a1,s0,-40
    8000542a:	4505                	li	a0,1
    8000542c:	ffffe097          	auipc	ra,0xffffe
    80005430:	950080e7          	jalr	-1712(ra) # 80002d7c <argaddr>
  argint(2, &n);
    80005434:	fe440593          	addi	a1,s0,-28
    80005438:	4509                	li	a0,2
    8000543a:	ffffe097          	auipc	ra,0xffffe
    8000543e:	922080e7          	jalr	-1758(ra) # 80002d5c <argint>
  if(argfd(0, 0, &f) < 0)
    80005442:	fe840613          	addi	a2,s0,-24
    80005446:	4581                	li	a1,0
    80005448:	4501                	li	a0,0
    8000544a:	00000097          	auipc	ra,0x0
    8000544e:	d5a080e7          	jalr	-678(ra) # 800051a4 <argfd>
    80005452:	87aa                	mv	a5,a0
    return -1;
    80005454:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005456:	0007cc63          	bltz	a5,8000546e <sys_read+0x50>
  return fileread(f, p, n);
    8000545a:	fe442603          	lw	a2,-28(s0)
    8000545e:	fd843583          	ld	a1,-40(s0)
    80005462:	fe843503          	ld	a0,-24(s0)
    80005466:	fffff097          	auipc	ra,0xfffff
    8000546a:	43e080e7          	jalr	1086(ra) # 800048a4 <fileread>
}
    8000546e:	70a2                	ld	ra,40(sp)
    80005470:	7402                	ld	s0,32(sp)
    80005472:	6145                	addi	sp,sp,48
    80005474:	8082                	ret

0000000080005476 <sys_write>:
{
    80005476:	7179                	addi	sp,sp,-48
    80005478:	f406                	sd	ra,40(sp)
    8000547a:	f022                	sd	s0,32(sp)
    8000547c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000547e:	fd840593          	addi	a1,s0,-40
    80005482:	4505                	li	a0,1
    80005484:	ffffe097          	auipc	ra,0xffffe
    80005488:	8f8080e7          	jalr	-1800(ra) # 80002d7c <argaddr>
  argint(2, &n);
    8000548c:	fe440593          	addi	a1,s0,-28
    80005490:	4509                	li	a0,2
    80005492:	ffffe097          	auipc	ra,0xffffe
    80005496:	8ca080e7          	jalr	-1846(ra) # 80002d5c <argint>
  if(argfd(0, 0, &f) < 0)
    8000549a:	fe840613          	addi	a2,s0,-24
    8000549e:	4581                	li	a1,0
    800054a0:	4501                	li	a0,0
    800054a2:	00000097          	auipc	ra,0x0
    800054a6:	d02080e7          	jalr	-766(ra) # 800051a4 <argfd>
    800054aa:	87aa                	mv	a5,a0
    return -1;
    800054ac:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800054ae:	0007cc63          	bltz	a5,800054c6 <sys_write+0x50>
  return filewrite(f, p, n);
    800054b2:	fe442603          	lw	a2,-28(s0)
    800054b6:	fd843583          	ld	a1,-40(s0)
    800054ba:	fe843503          	ld	a0,-24(s0)
    800054be:	fffff097          	auipc	ra,0xfffff
    800054c2:	4a8080e7          	jalr	1192(ra) # 80004966 <filewrite>
}
    800054c6:	70a2                	ld	ra,40(sp)
    800054c8:	7402                	ld	s0,32(sp)
    800054ca:	6145                	addi	sp,sp,48
    800054cc:	8082                	ret

00000000800054ce <sys_close>:
{
    800054ce:	1101                	addi	sp,sp,-32
    800054d0:	ec06                	sd	ra,24(sp)
    800054d2:	e822                	sd	s0,16(sp)
    800054d4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800054d6:	fe040613          	addi	a2,s0,-32
    800054da:	fec40593          	addi	a1,s0,-20
    800054de:	4501                	li	a0,0
    800054e0:	00000097          	auipc	ra,0x0
    800054e4:	cc4080e7          	jalr	-828(ra) # 800051a4 <argfd>
    return -1;
    800054e8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800054ea:	02054463          	bltz	a0,80005512 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800054ee:	ffffc097          	auipc	ra,0xffffc
    800054f2:	728080e7          	jalr	1832(ra) # 80001c16 <myproc>
    800054f6:	fec42783          	lw	a5,-20(s0)
    800054fa:	07e9                	addi	a5,a5,26
    800054fc:	078e                	slli	a5,a5,0x3
    800054fe:	97aa                	add	a5,a5,a0
    80005500:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005504:	fe043503          	ld	a0,-32(s0)
    80005508:	fffff097          	auipc	ra,0xfffff
    8000550c:	262080e7          	jalr	610(ra) # 8000476a <fileclose>
  return 0;
    80005510:	4781                	li	a5,0
}
    80005512:	853e                	mv	a0,a5
    80005514:	60e2                	ld	ra,24(sp)
    80005516:	6442                	ld	s0,16(sp)
    80005518:	6105                	addi	sp,sp,32
    8000551a:	8082                	ret

000000008000551c <sys_fstat>:
{
    8000551c:	1101                	addi	sp,sp,-32
    8000551e:	ec06                	sd	ra,24(sp)
    80005520:	e822                	sd	s0,16(sp)
    80005522:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005524:	fe040593          	addi	a1,s0,-32
    80005528:	4505                	li	a0,1
    8000552a:	ffffe097          	auipc	ra,0xffffe
    8000552e:	852080e7          	jalr	-1966(ra) # 80002d7c <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005532:	fe840613          	addi	a2,s0,-24
    80005536:	4581                	li	a1,0
    80005538:	4501                	li	a0,0
    8000553a:	00000097          	auipc	ra,0x0
    8000553e:	c6a080e7          	jalr	-918(ra) # 800051a4 <argfd>
    80005542:	87aa                	mv	a5,a0
    return -1;
    80005544:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005546:	0007ca63          	bltz	a5,8000555a <sys_fstat+0x3e>
  return filestat(f, st);
    8000554a:	fe043583          	ld	a1,-32(s0)
    8000554e:	fe843503          	ld	a0,-24(s0)
    80005552:	fffff097          	auipc	ra,0xfffff
    80005556:	2e0080e7          	jalr	736(ra) # 80004832 <filestat>
}
    8000555a:	60e2                	ld	ra,24(sp)
    8000555c:	6442                	ld	s0,16(sp)
    8000555e:	6105                	addi	sp,sp,32
    80005560:	8082                	ret

0000000080005562 <sys_link>:
{
    80005562:	7169                	addi	sp,sp,-304
    80005564:	f606                	sd	ra,296(sp)
    80005566:	f222                	sd	s0,288(sp)
    80005568:	ee26                	sd	s1,280(sp)
    8000556a:	ea4a                	sd	s2,272(sp)
    8000556c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000556e:	08000613          	li	a2,128
    80005572:	ed040593          	addi	a1,s0,-304
    80005576:	4501                	li	a0,0
    80005578:	ffffe097          	auipc	ra,0xffffe
    8000557c:	824080e7          	jalr	-2012(ra) # 80002d9c <argstr>
    return -1;
    80005580:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005582:	10054e63          	bltz	a0,8000569e <sys_link+0x13c>
    80005586:	08000613          	li	a2,128
    8000558a:	f5040593          	addi	a1,s0,-176
    8000558e:	4505                	li	a0,1
    80005590:	ffffe097          	auipc	ra,0xffffe
    80005594:	80c080e7          	jalr	-2036(ra) # 80002d9c <argstr>
    return -1;
    80005598:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000559a:	10054263          	bltz	a0,8000569e <sys_link+0x13c>
  begin_op();
    8000559e:	fffff097          	auipc	ra,0xfffff
    800055a2:	d00080e7          	jalr	-768(ra) # 8000429e <begin_op>
  if((ip = namei(old)) == 0){
    800055a6:	ed040513          	addi	a0,s0,-304
    800055aa:	fffff097          	auipc	ra,0xfffff
    800055ae:	ad4080e7          	jalr	-1324(ra) # 8000407e <namei>
    800055b2:	84aa                	mv	s1,a0
    800055b4:	c551                	beqz	a0,80005640 <sys_link+0xde>
  ilock(ip);
    800055b6:	ffffe097          	auipc	ra,0xffffe
    800055ba:	322080e7          	jalr	802(ra) # 800038d8 <ilock>
  if(ip->type == T_DIR){
    800055be:	04449703          	lh	a4,68(s1)
    800055c2:	4785                	li	a5,1
    800055c4:	08f70463          	beq	a4,a5,8000564c <sys_link+0xea>
  ip->nlink++;
    800055c8:	04a4d783          	lhu	a5,74(s1)
    800055cc:	2785                	addiw	a5,a5,1
    800055ce:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800055d2:	8526                	mv	a0,s1
    800055d4:	ffffe097          	auipc	ra,0xffffe
    800055d8:	23a080e7          	jalr	570(ra) # 8000380e <iupdate>
  iunlock(ip);
    800055dc:	8526                	mv	a0,s1
    800055de:	ffffe097          	auipc	ra,0xffffe
    800055e2:	3bc080e7          	jalr	956(ra) # 8000399a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800055e6:	fd040593          	addi	a1,s0,-48
    800055ea:	f5040513          	addi	a0,s0,-176
    800055ee:	fffff097          	auipc	ra,0xfffff
    800055f2:	aae080e7          	jalr	-1362(ra) # 8000409c <nameiparent>
    800055f6:	892a                	mv	s2,a0
    800055f8:	c935                	beqz	a0,8000566c <sys_link+0x10a>
  ilock(dp);
    800055fa:	ffffe097          	auipc	ra,0xffffe
    800055fe:	2de080e7          	jalr	734(ra) # 800038d8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005602:	00092703          	lw	a4,0(s2)
    80005606:	409c                	lw	a5,0(s1)
    80005608:	04f71d63          	bne	a4,a5,80005662 <sys_link+0x100>
    8000560c:	40d0                	lw	a2,4(s1)
    8000560e:	fd040593          	addi	a1,s0,-48
    80005612:	854a                	mv	a0,s2
    80005614:	fffff097          	auipc	ra,0xfffff
    80005618:	9b8080e7          	jalr	-1608(ra) # 80003fcc <dirlink>
    8000561c:	04054363          	bltz	a0,80005662 <sys_link+0x100>
  iunlockput(dp);
    80005620:	854a                	mv	a0,s2
    80005622:	ffffe097          	auipc	ra,0xffffe
    80005626:	518080e7          	jalr	1304(ra) # 80003b3a <iunlockput>
  iput(ip);
    8000562a:	8526                	mv	a0,s1
    8000562c:	ffffe097          	auipc	ra,0xffffe
    80005630:	466080e7          	jalr	1126(ra) # 80003a92 <iput>
  end_op();
    80005634:	fffff097          	auipc	ra,0xfffff
    80005638:	cea080e7          	jalr	-790(ra) # 8000431e <end_op>
  return 0;
    8000563c:	4781                	li	a5,0
    8000563e:	a085                	j	8000569e <sys_link+0x13c>
    end_op();
    80005640:	fffff097          	auipc	ra,0xfffff
    80005644:	cde080e7          	jalr	-802(ra) # 8000431e <end_op>
    return -1;
    80005648:	57fd                	li	a5,-1
    8000564a:	a891                	j	8000569e <sys_link+0x13c>
    iunlockput(ip);
    8000564c:	8526                	mv	a0,s1
    8000564e:	ffffe097          	auipc	ra,0xffffe
    80005652:	4ec080e7          	jalr	1260(ra) # 80003b3a <iunlockput>
    end_op();
    80005656:	fffff097          	auipc	ra,0xfffff
    8000565a:	cc8080e7          	jalr	-824(ra) # 8000431e <end_op>
    return -1;
    8000565e:	57fd                	li	a5,-1
    80005660:	a83d                	j	8000569e <sys_link+0x13c>
    iunlockput(dp);
    80005662:	854a                	mv	a0,s2
    80005664:	ffffe097          	auipc	ra,0xffffe
    80005668:	4d6080e7          	jalr	1238(ra) # 80003b3a <iunlockput>
  ilock(ip);
    8000566c:	8526                	mv	a0,s1
    8000566e:	ffffe097          	auipc	ra,0xffffe
    80005672:	26a080e7          	jalr	618(ra) # 800038d8 <ilock>
  ip->nlink--;
    80005676:	04a4d783          	lhu	a5,74(s1)
    8000567a:	37fd                	addiw	a5,a5,-1
    8000567c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005680:	8526                	mv	a0,s1
    80005682:	ffffe097          	auipc	ra,0xffffe
    80005686:	18c080e7          	jalr	396(ra) # 8000380e <iupdate>
  iunlockput(ip);
    8000568a:	8526                	mv	a0,s1
    8000568c:	ffffe097          	auipc	ra,0xffffe
    80005690:	4ae080e7          	jalr	1198(ra) # 80003b3a <iunlockput>
  end_op();
    80005694:	fffff097          	auipc	ra,0xfffff
    80005698:	c8a080e7          	jalr	-886(ra) # 8000431e <end_op>
  return -1;
    8000569c:	57fd                	li	a5,-1
}
    8000569e:	853e                	mv	a0,a5
    800056a0:	70b2                	ld	ra,296(sp)
    800056a2:	7412                	ld	s0,288(sp)
    800056a4:	64f2                	ld	s1,280(sp)
    800056a6:	6952                	ld	s2,272(sp)
    800056a8:	6155                	addi	sp,sp,304
    800056aa:	8082                	ret

00000000800056ac <sys_unlink>:
{
    800056ac:	7151                	addi	sp,sp,-240
    800056ae:	f586                	sd	ra,232(sp)
    800056b0:	f1a2                	sd	s0,224(sp)
    800056b2:	eda6                	sd	s1,216(sp)
    800056b4:	e9ca                	sd	s2,208(sp)
    800056b6:	e5ce                	sd	s3,200(sp)
    800056b8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800056ba:	08000613          	li	a2,128
    800056be:	f3040593          	addi	a1,s0,-208
    800056c2:	4501                	li	a0,0
    800056c4:	ffffd097          	auipc	ra,0xffffd
    800056c8:	6d8080e7          	jalr	1752(ra) # 80002d9c <argstr>
    800056cc:	18054163          	bltz	a0,8000584e <sys_unlink+0x1a2>
  begin_op();
    800056d0:	fffff097          	auipc	ra,0xfffff
    800056d4:	bce080e7          	jalr	-1074(ra) # 8000429e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800056d8:	fb040593          	addi	a1,s0,-80
    800056dc:	f3040513          	addi	a0,s0,-208
    800056e0:	fffff097          	auipc	ra,0xfffff
    800056e4:	9bc080e7          	jalr	-1604(ra) # 8000409c <nameiparent>
    800056e8:	84aa                	mv	s1,a0
    800056ea:	c979                	beqz	a0,800057c0 <sys_unlink+0x114>
  ilock(dp);
    800056ec:	ffffe097          	auipc	ra,0xffffe
    800056f0:	1ec080e7          	jalr	492(ra) # 800038d8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800056f4:	00003597          	auipc	a1,0x3
    800056f8:	03c58593          	addi	a1,a1,60 # 80008730 <syscalls+0x2a0>
    800056fc:	fb040513          	addi	a0,s0,-80
    80005700:	ffffe097          	auipc	ra,0xffffe
    80005704:	6a2080e7          	jalr	1698(ra) # 80003da2 <namecmp>
    80005708:	14050a63          	beqz	a0,8000585c <sys_unlink+0x1b0>
    8000570c:	00003597          	auipc	a1,0x3
    80005710:	02c58593          	addi	a1,a1,44 # 80008738 <syscalls+0x2a8>
    80005714:	fb040513          	addi	a0,s0,-80
    80005718:	ffffe097          	auipc	ra,0xffffe
    8000571c:	68a080e7          	jalr	1674(ra) # 80003da2 <namecmp>
    80005720:	12050e63          	beqz	a0,8000585c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005724:	f2c40613          	addi	a2,s0,-212
    80005728:	fb040593          	addi	a1,s0,-80
    8000572c:	8526                	mv	a0,s1
    8000572e:	ffffe097          	auipc	ra,0xffffe
    80005732:	68e080e7          	jalr	1678(ra) # 80003dbc <dirlookup>
    80005736:	892a                	mv	s2,a0
    80005738:	12050263          	beqz	a0,8000585c <sys_unlink+0x1b0>
  ilock(ip);
    8000573c:	ffffe097          	auipc	ra,0xffffe
    80005740:	19c080e7          	jalr	412(ra) # 800038d8 <ilock>
  if(ip->nlink < 1)
    80005744:	04a91783          	lh	a5,74(s2)
    80005748:	08f05263          	blez	a5,800057cc <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000574c:	04491703          	lh	a4,68(s2)
    80005750:	4785                	li	a5,1
    80005752:	08f70563          	beq	a4,a5,800057dc <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005756:	4641                	li	a2,16
    80005758:	4581                	li	a1,0
    8000575a:	fc040513          	addi	a0,s0,-64
    8000575e:	ffffb097          	auipc	ra,0xffffb
    80005762:	670080e7          	jalr	1648(ra) # 80000dce <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005766:	4741                	li	a4,16
    80005768:	f2c42683          	lw	a3,-212(s0)
    8000576c:	fc040613          	addi	a2,s0,-64
    80005770:	4581                	li	a1,0
    80005772:	8526                	mv	a0,s1
    80005774:	ffffe097          	auipc	ra,0xffffe
    80005778:	510080e7          	jalr	1296(ra) # 80003c84 <writei>
    8000577c:	47c1                	li	a5,16
    8000577e:	0af51563          	bne	a0,a5,80005828 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005782:	04491703          	lh	a4,68(s2)
    80005786:	4785                	li	a5,1
    80005788:	0af70863          	beq	a4,a5,80005838 <sys_unlink+0x18c>
  iunlockput(dp);
    8000578c:	8526                	mv	a0,s1
    8000578e:	ffffe097          	auipc	ra,0xffffe
    80005792:	3ac080e7          	jalr	940(ra) # 80003b3a <iunlockput>
  ip->nlink--;
    80005796:	04a95783          	lhu	a5,74(s2)
    8000579a:	37fd                	addiw	a5,a5,-1
    8000579c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800057a0:	854a                	mv	a0,s2
    800057a2:	ffffe097          	auipc	ra,0xffffe
    800057a6:	06c080e7          	jalr	108(ra) # 8000380e <iupdate>
  iunlockput(ip);
    800057aa:	854a                	mv	a0,s2
    800057ac:	ffffe097          	auipc	ra,0xffffe
    800057b0:	38e080e7          	jalr	910(ra) # 80003b3a <iunlockput>
  end_op();
    800057b4:	fffff097          	auipc	ra,0xfffff
    800057b8:	b6a080e7          	jalr	-1174(ra) # 8000431e <end_op>
  return 0;
    800057bc:	4501                	li	a0,0
    800057be:	a84d                	j	80005870 <sys_unlink+0x1c4>
    end_op();
    800057c0:	fffff097          	auipc	ra,0xfffff
    800057c4:	b5e080e7          	jalr	-1186(ra) # 8000431e <end_op>
    return -1;
    800057c8:	557d                	li	a0,-1
    800057ca:	a05d                	j	80005870 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800057cc:	00003517          	auipc	a0,0x3
    800057d0:	f7450513          	addi	a0,a0,-140 # 80008740 <syscalls+0x2b0>
    800057d4:	ffffb097          	auipc	ra,0xffffb
    800057d8:	d6a080e7          	jalr	-662(ra) # 8000053e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800057dc:	04c92703          	lw	a4,76(s2)
    800057e0:	02000793          	li	a5,32
    800057e4:	f6e7f9e3          	bgeu	a5,a4,80005756 <sys_unlink+0xaa>
    800057e8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800057ec:	4741                	li	a4,16
    800057ee:	86ce                	mv	a3,s3
    800057f0:	f1840613          	addi	a2,s0,-232
    800057f4:	4581                	li	a1,0
    800057f6:	854a                	mv	a0,s2
    800057f8:	ffffe097          	auipc	ra,0xffffe
    800057fc:	394080e7          	jalr	916(ra) # 80003b8c <readi>
    80005800:	47c1                	li	a5,16
    80005802:	00f51b63          	bne	a0,a5,80005818 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005806:	f1845783          	lhu	a5,-232(s0)
    8000580a:	e7a1                	bnez	a5,80005852 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000580c:	29c1                	addiw	s3,s3,16
    8000580e:	04c92783          	lw	a5,76(s2)
    80005812:	fcf9ede3          	bltu	s3,a5,800057ec <sys_unlink+0x140>
    80005816:	b781                	j	80005756 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005818:	00003517          	auipc	a0,0x3
    8000581c:	f4050513          	addi	a0,a0,-192 # 80008758 <syscalls+0x2c8>
    80005820:	ffffb097          	auipc	ra,0xffffb
    80005824:	d1e080e7          	jalr	-738(ra) # 8000053e <panic>
    panic("unlink: writei");
    80005828:	00003517          	auipc	a0,0x3
    8000582c:	f4850513          	addi	a0,a0,-184 # 80008770 <syscalls+0x2e0>
    80005830:	ffffb097          	auipc	ra,0xffffb
    80005834:	d0e080e7          	jalr	-754(ra) # 8000053e <panic>
    dp->nlink--;
    80005838:	04a4d783          	lhu	a5,74(s1)
    8000583c:	37fd                	addiw	a5,a5,-1
    8000583e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005842:	8526                	mv	a0,s1
    80005844:	ffffe097          	auipc	ra,0xffffe
    80005848:	fca080e7          	jalr	-54(ra) # 8000380e <iupdate>
    8000584c:	b781                	j	8000578c <sys_unlink+0xe0>
    return -1;
    8000584e:	557d                	li	a0,-1
    80005850:	a005                	j	80005870 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005852:	854a                	mv	a0,s2
    80005854:	ffffe097          	auipc	ra,0xffffe
    80005858:	2e6080e7          	jalr	742(ra) # 80003b3a <iunlockput>
  iunlockput(dp);
    8000585c:	8526                	mv	a0,s1
    8000585e:	ffffe097          	auipc	ra,0xffffe
    80005862:	2dc080e7          	jalr	732(ra) # 80003b3a <iunlockput>
  end_op();
    80005866:	fffff097          	auipc	ra,0xfffff
    8000586a:	ab8080e7          	jalr	-1352(ra) # 8000431e <end_op>
  return -1;
    8000586e:	557d                	li	a0,-1
}
    80005870:	70ae                	ld	ra,232(sp)
    80005872:	740e                	ld	s0,224(sp)
    80005874:	64ee                	ld	s1,216(sp)
    80005876:	694e                	ld	s2,208(sp)
    80005878:	69ae                	ld	s3,200(sp)
    8000587a:	616d                	addi	sp,sp,240
    8000587c:	8082                	ret

000000008000587e <sys_open>:

uint64
sys_open(void)
{
    8000587e:	7131                	addi	sp,sp,-192
    80005880:	fd06                	sd	ra,184(sp)
    80005882:	f922                	sd	s0,176(sp)
    80005884:	f526                	sd	s1,168(sp)
    80005886:	f14a                	sd	s2,160(sp)
    80005888:	ed4e                	sd	s3,152(sp)
    8000588a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000588c:	f4c40593          	addi	a1,s0,-180
    80005890:	4505                	li	a0,1
    80005892:	ffffd097          	auipc	ra,0xffffd
    80005896:	4ca080e7          	jalr	1226(ra) # 80002d5c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000589a:	08000613          	li	a2,128
    8000589e:	f5040593          	addi	a1,s0,-176
    800058a2:	4501                	li	a0,0
    800058a4:	ffffd097          	auipc	ra,0xffffd
    800058a8:	4f8080e7          	jalr	1272(ra) # 80002d9c <argstr>
    800058ac:	87aa                	mv	a5,a0
    return -1;
    800058ae:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800058b0:	0a07c963          	bltz	a5,80005962 <sys_open+0xe4>

  begin_op();
    800058b4:	fffff097          	auipc	ra,0xfffff
    800058b8:	9ea080e7          	jalr	-1558(ra) # 8000429e <begin_op>

  if(omode & O_CREATE){
    800058bc:	f4c42783          	lw	a5,-180(s0)
    800058c0:	2007f793          	andi	a5,a5,512
    800058c4:	cfc5                	beqz	a5,8000597c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800058c6:	4681                	li	a3,0
    800058c8:	4601                	li	a2,0
    800058ca:	4589                	li	a1,2
    800058cc:	f5040513          	addi	a0,s0,-176
    800058d0:	00000097          	auipc	ra,0x0
    800058d4:	976080e7          	jalr	-1674(ra) # 80005246 <create>
    800058d8:	84aa                	mv	s1,a0
    if(ip == 0){
    800058da:	c959                	beqz	a0,80005970 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800058dc:	04449703          	lh	a4,68(s1)
    800058e0:	478d                	li	a5,3
    800058e2:	00f71763          	bne	a4,a5,800058f0 <sys_open+0x72>
    800058e6:	0464d703          	lhu	a4,70(s1)
    800058ea:	47a5                	li	a5,9
    800058ec:	0ce7ed63          	bltu	a5,a4,800059c6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800058f0:	fffff097          	auipc	ra,0xfffff
    800058f4:	dbe080e7          	jalr	-578(ra) # 800046ae <filealloc>
    800058f8:	89aa                	mv	s3,a0
    800058fa:	10050363          	beqz	a0,80005a00 <sys_open+0x182>
    800058fe:	00000097          	auipc	ra,0x0
    80005902:	906080e7          	jalr	-1786(ra) # 80005204 <fdalloc>
    80005906:	892a                	mv	s2,a0
    80005908:	0e054763          	bltz	a0,800059f6 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000590c:	04449703          	lh	a4,68(s1)
    80005910:	478d                	li	a5,3
    80005912:	0cf70563          	beq	a4,a5,800059dc <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005916:	4789                	li	a5,2
    80005918:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000591c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005920:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005924:	f4c42783          	lw	a5,-180(s0)
    80005928:	0017c713          	xori	a4,a5,1
    8000592c:	8b05                	andi	a4,a4,1
    8000592e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005932:	0037f713          	andi	a4,a5,3
    80005936:	00e03733          	snez	a4,a4
    8000593a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000593e:	4007f793          	andi	a5,a5,1024
    80005942:	c791                	beqz	a5,8000594e <sys_open+0xd0>
    80005944:	04449703          	lh	a4,68(s1)
    80005948:	4789                	li	a5,2
    8000594a:	0af70063          	beq	a4,a5,800059ea <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    8000594e:	8526                	mv	a0,s1
    80005950:	ffffe097          	auipc	ra,0xffffe
    80005954:	04a080e7          	jalr	74(ra) # 8000399a <iunlock>
  end_op();
    80005958:	fffff097          	auipc	ra,0xfffff
    8000595c:	9c6080e7          	jalr	-1594(ra) # 8000431e <end_op>

  return fd;
    80005960:	854a                	mv	a0,s2
}
    80005962:	70ea                	ld	ra,184(sp)
    80005964:	744a                	ld	s0,176(sp)
    80005966:	74aa                	ld	s1,168(sp)
    80005968:	790a                	ld	s2,160(sp)
    8000596a:	69ea                	ld	s3,152(sp)
    8000596c:	6129                	addi	sp,sp,192
    8000596e:	8082                	ret
      end_op();
    80005970:	fffff097          	auipc	ra,0xfffff
    80005974:	9ae080e7          	jalr	-1618(ra) # 8000431e <end_op>
      return -1;
    80005978:	557d                	li	a0,-1
    8000597a:	b7e5                	j	80005962 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    8000597c:	f5040513          	addi	a0,s0,-176
    80005980:	ffffe097          	auipc	ra,0xffffe
    80005984:	6fe080e7          	jalr	1790(ra) # 8000407e <namei>
    80005988:	84aa                	mv	s1,a0
    8000598a:	c905                	beqz	a0,800059ba <sys_open+0x13c>
    ilock(ip);
    8000598c:	ffffe097          	auipc	ra,0xffffe
    80005990:	f4c080e7          	jalr	-180(ra) # 800038d8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005994:	04449703          	lh	a4,68(s1)
    80005998:	4785                	li	a5,1
    8000599a:	f4f711e3          	bne	a4,a5,800058dc <sys_open+0x5e>
    8000599e:	f4c42783          	lw	a5,-180(s0)
    800059a2:	d7b9                	beqz	a5,800058f0 <sys_open+0x72>
      iunlockput(ip);
    800059a4:	8526                	mv	a0,s1
    800059a6:	ffffe097          	auipc	ra,0xffffe
    800059aa:	194080e7          	jalr	404(ra) # 80003b3a <iunlockput>
      end_op();
    800059ae:	fffff097          	auipc	ra,0xfffff
    800059b2:	970080e7          	jalr	-1680(ra) # 8000431e <end_op>
      return -1;
    800059b6:	557d                	li	a0,-1
    800059b8:	b76d                	j	80005962 <sys_open+0xe4>
      end_op();
    800059ba:	fffff097          	auipc	ra,0xfffff
    800059be:	964080e7          	jalr	-1692(ra) # 8000431e <end_op>
      return -1;
    800059c2:	557d                	li	a0,-1
    800059c4:	bf79                	j	80005962 <sys_open+0xe4>
    iunlockput(ip);
    800059c6:	8526                	mv	a0,s1
    800059c8:	ffffe097          	auipc	ra,0xffffe
    800059cc:	172080e7          	jalr	370(ra) # 80003b3a <iunlockput>
    end_op();
    800059d0:	fffff097          	auipc	ra,0xfffff
    800059d4:	94e080e7          	jalr	-1714(ra) # 8000431e <end_op>
    return -1;
    800059d8:	557d                	li	a0,-1
    800059da:	b761                	j	80005962 <sys_open+0xe4>
    f->type = FD_DEVICE;
    800059dc:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800059e0:	04649783          	lh	a5,70(s1)
    800059e4:	02f99223          	sh	a5,36(s3)
    800059e8:	bf25                	j	80005920 <sys_open+0xa2>
    itrunc(ip);
    800059ea:	8526                	mv	a0,s1
    800059ec:	ffffe097          	auipc	ra,0xffffe
    800059f0:	ffa080e7          	jalr	-6(ra) # 800039e6 <itrunc>
    800059f4:	bfa9                	j	8000594e <sys_open+0xd0>
      fileclose(f);
    800059f6:	854e                	mv	a0,s3
    800059f8:	fffff097          	auipc	ra,0xfffff
    800059fc:	d72080e7          	jalr	-654(ra) # 8000476a <fileclose>
    iunlockput(ip);
    80005a00:	8526                	mv	a0,s1
    80005a02:	ffffe097          	auipc	ra,0xffffe
    80005a06:	138080e7          	jalr	312(ra) # 80003b3a <iunlockput>
    end_op();
    80005a0a:	fffff097          	auipc	ra,0xfffff
    80005a0e:	914080e7          	jalr	-1772(ra) # 8000431e <end_op>
    return -1;
    80005a12:	557d                	li	a0,-1
    80005a14:	b7b9                	j	80005962 <sys_open+0xe4>

0000000080005a16 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005a16:	7175                	addi	sp,sp,-144
    80005a18:	e506                	sd	ra,136(sp)
    80005a1a:	e122                	sd	s0,128(sp)
    80005a1c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005a1e:	fffff097          	auipc	ra,0xfffff
    80005a22:	880080e7          	jalr	-1920(ra) # 8000429e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005a26:	08000613          	li	a2,128
    80005a2a:	f7040593          	addi	a1,s0,-144
    80005a2e:	4501                	li	a0,0
    80005a30:	ffffd097          	auipc	ra,0xffffd
    80005a34:	36c080e7          	jalr	876(ra) # 80002d9c <argstr>
    80005a38:	02054963          	bltz	a0,80005a6a <sys_mkdir+0x54>
    80005a3c:	4681                	li	a3,0
    80005a3e:	4601                	li	a2,0
    80005a40:	4585                	li	a1,1
    80005a42:	f7040513          	addi	a0,s0,-144
    80005a46:	00000097          	auipc	ra,0x0
    80005a4a:	800080e7          	jalr	-2048(ra) # 80005246 <create>
    80005a4e:	cd11                	beqz	a0,80005a6a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005a50:	ffffe097          	auipc	ra,0xffffe
    80005a54:	0ea080e7          	jalr	234(ra) # 80003b3a <iunlockput>
  end_op();
    80005a58:	fffff097          	auipc	ra,0xfffff
    80005a5c:	8c6080e7          	jalr	-1850(ra) # 8000431e <end_op>
  return 0;
    80005a60:	4501                	li	a0,0
}
    80005a62:	60aa                	ld	ra,136(sp)
    80005a64:	640a                	ld	s0,128(sp)
    80005a66:	6149                	addi	sp,sp,144
    80005a68:	8082                	ret
    end_op();
    80005a6a:	fffff097          	auipc	ra,0xfffff
    80005a6e:	8b4080e7          	jalr	-1868(ra) # 8000431e <end_op>
    return -1;
    80005a72:	557d                	li	a0,-1
    80005a74:	b7fd                	j	80005a62 <sys_mkdir+0x4c>

0000000080005a76 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005a76:	7135                	addi	sp,sp,-160
    80005a78:	ed06                	sd	ra,152(sp)
    80005a7a:	e922                	sd	s0,144(sp)
    80005a7c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005a7e:	fffff097          	auipc	ra,0xfffff
    80005a82:	820080e7          	jalr	-2016(ra) # 8000429e <begin_op>
  argint(1, &major);
    80005a86:	f6c40593          	addi	a1,s0,-148
    80005a8a:	4505                	li	a0,1
    80005a8c:	ffffd097          	auipc	ra,0xffffd
    80005a90:	2d0080e7          	jalr	720(ra) # 80002d5c <argint>
  argint(2, &minor);
    80005a94:	f6840593          	addi	a1,s0,-152
    80005a98:	4509                	li	a0,2
    80005a9a:	ffffd097          	auipc	ra,0xffffd
    80005a9e:	2c2080e7          	jalr	706(ra) # 80002d5c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005aa2:	08000613          	li	a2,128
    80005aa6:	f7040593          	addi	a1,s0,-144
    80005aaa:	4501                	li	a0,0
    80005aac:	ffffd097          	auipc	ra,0xffffd
    80005ab0:	2f0080e7          	jalr	752(ra) # 80002d9c <argstr>
    80005ab4:	02054b63          	bltz	a0,80005aea <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005ab8:	f6841683          	lh	a3,-152(s0)
    80005abc:	f6c41603          	lh	a2,-148(s0)
    80005ac0:	458d                	li	a1,3
    80005ac2:	f7040513          	addi	a0,s0,-144
    80005ac6:	fffff097          	auipc	ra,0xfffff
    80005aca:	780080e7          	jalr	1920(ra) # 80005246 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005ace:	cd11                	beqz	a0,80005aea <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005ad0:	ffffe097          	auipc	ra,0xffffe
    80005ad4:	06a080e7          	jalr	106(ra) # 80003b3a <iunlockput>
  end_op();
    80005ad8:	fffff097          	auipc	ra,0xfffff
    80005adc:	846080e7          	jalr	-1978(ra) # 8000431e <end_op>
  return 0;
    80005ae0:	4501                	li	a0,0
}
    80005ae2:	60ea                	ld	ra,152(sp)
    80005ae4:	644a                	ld	s0,144(sp)
    80005ae6:	610d                	addi	sp,sp,160
    80005ae8:	8082                	ret
    end_op();
    80005aea:	fffff097          	auipc	ra,0xfffff
    80005aee:	834080e7          	jalr	-1996(ra) # 8000431e <end_op>
    return -1;
    80005af2:	557d                	li	a0,-1
    80005af4:	b7fd                	j	80005ae2 <sys_mknod+0x6c>

0000000080005af6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005af6:	7135                	addi	sp,sp,-160
    80005af8:	ed06                	sd	ra,152(sp)
    80005afa:	e922                	sd	s0,144(sp)
    80005afc:	e526                	sd	s1,136(sp)
    80005afe:	e14a                	sd	s2,128(sp)
    80005b00:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005b02:	ffffc097          	auipc	ra,0xffffc
    80005b06:	114080e7          	jalr	276(ra) # 80001c16 <myproc>
    80005b0a:	892a                	mv	s2,a0
  
  begin_op();
    80005b0c:	ffffe097          	auipc	ra,0xffffe
    80005b10:	792080e7          	jalr	1938(ra) # 8000429e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005b14:	08000613          	li	a2,128
    80005b18:	f6040593          	addi	a1,s0,-160
    80005b1c:	4501                	li	a0,0
    80005b1e:	ffffd097          	auipc	ra,0xffffd
    80005b22:	27e080e7          	jalr	638(ra) # 80002d9c <argstr>
    80005b26:	04054b63          	bltz	a0,80005b7c <sys_chdir+0x86>
    80005b2a:	f6040513          	addi	a0,s0,-160
    80005b2e:	ffffe097          	auipc	ra,0xffffe
    80005b32:	550080e7          	jalr	1360(ra) # 8000407e <namei>
    80005b36:	84aa                	mv	s1,a0
    80005b38:	c131                	beqz	a0,80005b7c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005b3a:	ffffe097          	auipc	ra,0xffffe
    80005b3e:	d9e080e7          	jalr	-610(ra) # 800038d8 <ilock>
  if(ip->type != T_DIR){
    80005b42:	04449703          	lh	a4,68(s1)
    80005b46:	4785                	li	a5,1
    80005b48:	04f71063          	bne	a4,a5,80005b88 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005b4c:	8526                	mv	a0,s1
    80005b4e:	ffffe097          	auipc	ra,0xffffe
    80005b52:	e4c080e7          	jalr	-436(ra) # 8000399a <iunlock>
  iput(p->cwd);
    80005b56:	15093503          	ld	a0,336(s2)
    80005b5a:	ffffe097          	auipc	ra,0xffffe
    80005b5e:	f38080e7          	jalr	-200(ra) # 80003a92 <iput>
  end_op();
    80005b62:	ffffe097          	auipc	ra,0xffffe
    80005b66:	7bc080e7          	jalr	1980(ra) # 8000431e <end_op>
  p->cwd = ip;
    80005b6a:	14993823          	sd	s1,336(s2)
  return 0;
    80005b6e:	4501                	li	a0,0
}
    80005b70:	60ea                	ld	ra,152(sp)
    80005b72:	644a                	ld	s0,144(sp)
    80005b74:	64aa                	ld	s1,136(sp)
    80005b76:	690a                	ld	s2,128(sp)
    80005b78:	610d                	addi	sp,sp,160
    80005b7a:	8082                	ret
    end_op();
    80005b7c:	ffffe097          	auipc	ra,0xffffe
    80005b80:	7a2080e7          	jalr	1954(ra) # 8000431e <end_op>
    return -1;
    80005b84:	557d                	li	a0,-1
    80005b86:	b7ed                	j	80005b70 <sys_chdir+0x7a>
    iunlockput(ip);
    80005b88:	8526                	mv	a0,s1
    80005b8a:	ffffe097          	auipc	ra,0xffffe
    80005b8e:	fb0080e7          	jalr	-80(ra) # 80003b3a <iunlockput>
    end_op();
    80005b92:	ffffe097          	auipc	ra,0xffffe
    80005b96:	78c080e7          	jalr	1932(ra) # 8000431e <end_op>
    return -1;
    80005b9a:	557d                	li	a0,-1
    80005b9c:	bfd1                	j	80005b70 <sys_chdir+0x7a>

0000000080005b9e <sys_exec>:

uint64
sys_exec(void)
{
    80005b9e:	7145                	addi	sp,sp,-464
    80005ba0:	e786                	sd	ra,456(sp)
    80005ba2:	e3a2                	sd	s0,448(sp)
    80005ba4:	ff26                	sd	s1,440(sp)
    80005ba6:	fb4a                	sd	s2,432(sp)
    80005ba8:	f74e                	sd	s3,424(sp)
    80005baa:	f352                	sd	s4,416(sp)
    80005bac:	ef56                	sd	s5,408(sp)
    80005bae:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005bb0:	e3840593          	addi	a1,s0,-456
    80005bb4:	4505                	li	a0,1
    80005bb6:	ffffd097          	auipc	ra,0xffffd
    80005bba:	1c6080e7          	jalr	454(ra) # 80002d7c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005bbe:	08000613          	li	a2,128
    80005bc2:	f4040593          	addi	a1,s0,-192
    80005bc6:	4501                	li	a0,0
    80005bc8:	ffffd097          	auipc	ra,0xffffd
    80005bcc:	1d4080e7          	jalr	468(ra) # 80002d9c <argstr>
    80005bd0:	87aa                	mv	a5,a0
    return -1;
    80005bd2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005bd4:	0c07c263          	bltz	a5,80005c98 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005bd8:	10000613          	li	a2,256
    80005bdc:	4581                	li	a1,0
    80005bde:	e4040513          	addi	a0,s0,-448
    80005be2:	ffffb097          	auipc	ra,0xffffb
    80005be6:	1ec080e7          	jalr	492(ra) # 80000dce <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005bea:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005bee:	89a6                	mv	s3,s1
    80005bf0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005bf2:	02000a13          	li	s4,32
    80005bf6:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005bfa:	00391793          	slli	a5,s2,0x3
    80005bfe:	e3040593          	addi	a1,s0,-464
    80005c02:	e3843503          	ld	a0,-456(s0)
    80005c06:	953e                	add	a0,a0,a5
    80005c08:	ffffd097          	auipc	ra,0xffffd
    80005c0c:	0b6080e7          	jalr	182(ra) # 80002cbe <fetchaddr>
    80005c10:	02054a63          	bltz	a0,80005c44 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005c14:	e3043783          	ld	a5,-464(s0)
    80005c18:	c3b9                	beqz	a5,80005c5e <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005c1a:	ffffb097          	auipc	ra,0xffffb
    80005c1e:	f96080e7          	jalr	-106(ra) # 80000bb0 <kalloc>
    80005c22:	85aa                	mv	a1,a0
    80005c24:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005c28:	cd11                	beqz	a0,80005c44 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005c2a:	6605                	lui	a2,0x1
    80005c2c:	e3043503          	ld	a0,-464(s0)
    80005c30:	ffffd097          	auipc	ra,0xffffd
    80005c34:	0e0080e7          	jalr	224(ra) # 80002d10 <fetchstr>
    80005c38:	00054663          	bltz	a0,80005c44 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005c3c:	0905                	addi	s2,s2,1
    80005c3e:	09a1                	addi	s3,s3,8
    80005c40:	fb491be3          	bne	s2,s4,80005bf6 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c44:	10048913          	addi	s2,s1,256
    80005c48:	6088                	ld	a0,0(s1)
    80005c4a:	c531                	beqz	a0,80005c96 <sys_exec+0xf8>
    kfree(argv[i]);
    80005c4c:	ffffb097          	auipc	ra,0xffffb
    80005c50:	e08080e7          	jalr	-504(ra) # 80000a54 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c54:	04a1                	addi	s1,s1,8
    80005c56:	ff2499e3          	bne	s1,s2,80005c48 <sys_exec+0xaa>
  return -1;
    80005c5a:	557d                	li	a0,-1
    80005c5c:	a835                	j	80005c98 <sys_exec+0xfa>
      argv[i] = 0;
    80005c5e:	0a8e                	slli	s5,s5,0x3
    80005c60:	fc040793          	addi	a5,s0,-64
    80005c64:	9abe                	add	s5,s5,a5
    80005c66:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005c6a:	e4040593          	addi	a1,s0,-448
    80005c6e:	f4040513          	addi	a0,s0,-192
    80005c72:	fffff097          	auipc	ra,0xfffff
    80005c76:	172080e7          	jalr	370(ra) # 80004de4 <exec>
    80005c7a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c7c:	10048993          	addi	s3,s1,256
    80005c80:	6088                	ld	a0,0(s1)
    80005c82:	c901                	beqz	a0,80005c92 <sys_exec+0xf4>
    kfree(argv[i]);
    80005c84:	ffffb097          	auipc	ra,0xffffb
    80005c88:	dd0080e7          	jalr	-560(ra) # 80000a54 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c8c:	04a1                	addi	s1,s1,8
    80005c8e:	ff3499e3          	bne	s1,s3,80005c80 <sys_exec+0xe2>
  return ret;
    80005c92:	854a                	mv	a0,s2
    80005c94:	a011                	j	80005c98 <sys_exec+0xfa>
  return -1;
    80005c96:	557d                	li	a0,-1
}
    80005c98:	60be                	ld	ra,456(sp)
    80005c9a:	641e                	ld	s0,448(sp)
    80005c9c:	74fa                	ld	s1,440(sp)
    80005c9e:	795a                	ld	s2,432(sp)
    80005ca0:	79ba                	ld	s3,424(sp)
    80005ca2:	7a1a                	ld	s4,416(sp)
    80005ca4:	6afa                	ld	s5,408(sp)
    80005ca6:	6179                	addi	sp,sp,464
    80005ca8:	8082                	ret

0000000080005caa <sys_pipe>:

uint64
sys_pipe(void)
{
    80005caa:	7139                	addi	sp,sp,-64
    80005cac:	fc06                	sd	ra,56(sp)
    80005cae:	f822                	sd	s0,48(sp)
    80005cb0:	f426                	sd	s1,40(sp)
    80005cb2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005cb4:	ffffc097          	auipc	ra,0xffffc
    80005cb8:	f62080e7          	jalr	-158(ra) # 80001c16 <myproc>
    80005cbc:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005cbe:	fd840593          	addi	a1,s0,-40
    80005cc2:	4501                	li	a0,0
    80005cc4:	ffffd097          	auipc	ra,0xffffd
    80005cc8:	0b8080e7          	jalr	184(ra) # 80002d7c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005ccc:	fc840593          	addi	a1,s0,-56
    80005cd0:	fd040513          	addi	a0,s0,-48
    80005cd4:	fffff097          	auipc	ra,0xfffff
    80005cd8:	dc6080e7          	jalr	-570(ra) # 80004a9a <pipealloc>
    return -1;
    80005cdc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005cde:	0c054463          	bltz	a0,80005da6 <sys_pipe+0xfc>
  fd0 = -1;
    80005ce2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005ce6:	fd043503          	ld	a0,-48(s0)
    80005cea:	fffff097          	auipc	ra,0xfffff
    80005cee:	51a080e7          	jalr	1306(ra) # 80005204 <fdalloc>
    80005cf2:	fca42223          	sw	a0,-60(s0)
    80005cf6:	08054b63          	bltz	a0,80005d8c <sys_pipe+0xe2>
    80005cfa:	fc843503          	ld	a0,-56(s0)
    80005cfe:	fffff097          	auipc	ra,0xfffff
    80005d02:	506080e7          	jalr	1286(ra) # 80005204 <fdalloc>
    80005d06:	fca42023          	sw	a0,-64(s0)
    80005d0a:	06054863          	bltz	a0,80005d7a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005d0e:	4691                	li	a3,4
    80005d10:	fc440613          	addi	a2,s0,-60
    80005d14:	fd843583          	ld	a1,-40(s0)
    80005d18:	68a8                	ld	a0,80(s1)
    80005d1a:	ffffc097          	auipc	ra,0xffffc
    80005d1e:	b4e080e7          	jalr	-1202(ra) # 80001868 <copyout>
    80005d22:	02054063          	bltz	a0,80005d42 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005d26:	4691                	li	a3,4
    80005d28:	fc040613          	addi	a2,s0,-64
    80005d2c:	fd843583          	ld	a1,-40(s0)
    80005d30:	0591                	addi	a1,a1,4
    80005d32:	68a8                	ld	a0,80(s1)
    80005d34:	ffffc097          	auipc	ra,0xffffc
    80005d38:	b34080e7          	jalr	-1228(ra) # 80001868 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005d3c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005d3e:	06055463          	bgez	a0,80005da6 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005d42:	fc442783          	lw	a5,-60(s0)
    80005d46:	07e9                	addi	a5,a5,26
    80005d48:	078e                	slli	a5,a5,0x3
    80005d4a:	97a6                	add	a5,a5,s1
    80005d4c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005d50:	fc042503          	lw	a0,-64(s0)
    80005d54:	0569                	addi	a0,a0,26
    80005d56:	050e                	slli	a0,a0,0x3
    80005d58:	94aa                	add	s1,s1,a0
    80005d5a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005d5e:	fd043503          	ld	a0,-48(s0)
    80005d62:	fffff097          	auipc	ra,0xfffff
    80005d66:	a08080e7          	jalr	-1528(ra) # 8000476a <fileclose>
    fileclose(wf);
    80005d6a:	fc843503          	ld	a0,-56(s0)
    80005d6e:	fffff097          	auipc	ra,0xfffff
    80005d72:	9fc080e7          	jalr	-1540(ra) # 8000476a <fileclose>
    return -1;
    80005d76:	57fd                	li	a5,-1
    80005d78:	a03d                	j	80005da6 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005d7a:	fc442783          	lw	a5,-60(s0)
    80005d7e:	0007c763          	bltz	a5,80005d8c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005d82:	07e9                	addi	a5,a5,26
    80005d84:	078e                	slli	a5,a5,0x3
    80005d86:	94be                	add	s1,s1,a5
    80005d88:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005d8c:	fd043503          	ld	a0,-48(s0)
    80005d90:	fffff097          	auipc	ra,0xfffff
    80005d94:	9da080e7          	jalr	-1574(ra) # 8000476a <fileclose>
    fileclose(wf);
    80005d98:	fc843503          	ld	a0,-56(s0)
    80005d9c:	fffff097          	auipc	ra,0xfffff
    80005da0:	9ce080e7          	jalr	-1586(ra) # 8000476a <fileclose>
    return -1;
    80005da4:	57fd                	li	a5,-1
}
    80005da6:	853e                	mv	a0,a5
    80005da8:	70e2                	ld	ra,56(sp)
    80005daa:	7442                	ld	s0,48(sp)
    80005dac:	74a2                	ld	s1,40(sp)
    80005dae:	6121                	addi	sp,sp,64
    80005db0:	8082                	ret
	...

0000000080005dc0 <kernelvec>:
    80005dc0:	7111                	addi	sp,sp,-256
    80005dc2:	e006                	sd	ra,0(sp)
    80005dc4:	e40a                	sd	sp,8(sp)
    80005dc6:	e80e                	sd	gp,16(sp)
    80005dc8:	ec12                	sd	tp,24(sp)
    80005dca:	f016                	sd	t0,32(sp)
    80005dcc:	f41a                	sd	t1,40(sp)
    80005dce:	f81e                	sd	t2,48(sp)
    80005dd0:	e4aa                	sd	a0,72(sp)
    80005dd2:	e8ae                	sd	a1,80(sp)
    80005dd4:	ecb2                	sd	a2,88(sp)
    80005dd6:	f0b6                	sd	a3,96(sp)
    80005dd8:	f4ba                	sd	a4,104(sp)
    80005dda:	f8be                	sd	a5,112(sp)
    80005ddc:	fcc2                	sd	a6,120(sp)
    80005dde:	e146                	sd	a7,128(sp)
    80005de0:	edf2                	sd	t3,216(sp)
    80005de2:	f1f6                	sd	t4,224(sp)
    80005de4:	f5fa                	sd	t5,232(sp)
    80005de6:	f9fe                	sd	t6,240(sp)
    80005de8:	da3fc0ef          	jal	ra,80002b8a <kerneltrap>
    80005dec:	6082                	ld	ra,0(sp)
    80005dee:	6122                	ld	sp,8(sp)
    80005df0:	61c2                	ld	gp,16(sp)
    80005df2:	7282                	ld	t0,32(sp)
    80005df4:	7322                	ld	t1,40(sp)
    80005df6:	73c2                	ld	t2,48(sp)
    80005df8:	6526                	ld	a0,72(sp)
    80005dfa:	65c6                	ld	a1,80(sp)
    80005dfc:	6666                	ld	a2,88(sp)
    80005dfe:	7686                	ld	a3,96(sp)
    80005e00:	7726                	ld	a4,104(sp)
    80005e02:	77c6                	ld	a5,112(sp)
    80005e04:	7866                	ld	a6,120(sp)
    80005e06:	688a                	ld	a7,128(sp)
    80005e08:	6e6e                	ld	t3,216(sp)
    80005e0a:	7e8e                	ld	t4,224(sp)
    80005e0c:	7f2e                	ld	t5,232(sp)
    80005e0e:	7fce                	ld	t6,240(sp)
    80005e10:	6111                	addi	sp,sp,256
    80005e12:	10200073          	sret
    80005e16:	00000013          	nop
    80005e1a:	00000013          	nop
    80005e1e:	0001                	nop

0000000080005e20 <timervec>:
    80005e20:	34051573          	csrrw	a0,mscratch,a0
    80005e24:	e10c                	sd	a1,0(a0)
    80005e26:	e510                	sd	a2,8(a0)
    80005e28:	e914                	sd	a3,16(a0)
    80005e2a:	6d0c                	ld	a1,24(a0)
    80005e2c:	7110                	ld	a2,32(a0)
    80005e2e:	6194                	ld	a3,0(a1)
    80005e30:	96b2                	add	a3,a3,a2
    80005e32:	e194                	sd	a3,0(a1)
    80005e34:	4589                	li	a1,2
    80005e36:	14459073          	csrw	sip,a1
    80005e3a:	6914                	ld	a3,16(a0)
    80005e3c:	6510                	ld	a2,8(a0)
    80005e3e:	610c                	ld	a1,0(a0)
    80005e40:	34051573          	csrrw	a0,mscratch,a0
    80005e44:	30200073          	mret
	...

0000000080005e4a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005e4a:	1141                	addi	sp,sp,-16
    80005e4c:	e422                	sd	s0,8(sp)
    80005e4e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005e50:	0c0007b7          	lui	a5,0xc000
    80005e54:	4705                	li	a4,1
    80005e56:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005e58:	c3d8                	sw	a4,4(a5)
}
    80005e5a:	6422                	ld	s0,8(sp)
    80005e5c:	0141                	addi	sp,sp,16
    80005e5e:	8082                	ret

0000000080005e60 <plicinithart>:

void
plicinithart(void)
{
    80005e60:	1141                	addi	sp,sp,-16
    80005e62:	e406                	sd	ra,8(sp)
    80005e64:	e022                	sd	s0,0(sp)
    80005e66:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e68:	ffffc097          	auipc	ra,0xffffc
    80005e6c:	d82080e7          	jalr	-638(ra) # 80001bea <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005e70:	0085171b          	slliw	a4,a0,0x8
    80005e74:	0c0027b7          	lui	a5,0xc002
    80005e78:	97ba                	add	a5,a5,a4
    80005e7a:	40200713          	li	a4,1026
    80005e7e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005e82:	00d5151b          	slliw	a0,a0,0xd
    80005e86:	0c2017b7          	lui	a5,0xc201
    80005e8a:	953e                	add	a0,a0,a5
    80005e8c:	00052023          	sw	zero,0(a0)
}
    80005e90:	60a2                	ld	ra,8(sp)
    80005e92:	6402                	ld	s0,0(sp)
    80005e94:	0141                	addi	sp,sp,16
    80005e96:	8082                	ret

0000000080005e98 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005e98:	1141                	addi	sp,sp,-16
    80005e9a:	e406                	sd	ra,8(sp)
    80005e9c:	e022                	sd	s0,0(sp)
    80005e9e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005ea0:	ffffc097          	auipc	ra,0xffffc
    80005ea4:	d4a080e7          	jalr	-694(ra) # 80001bea <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005ea8:	00d5179b          	slliw	a5,a0,0xd
    80005eac:	0c201537          	lui	a0,0xc201
    80005eb0:	953e                	add	a0,a0,a5
  return irq;
}
    80005eb2:	4148                	lw	a0,4(a0)
    80005eb4:	60a2                	ld	ra,8(sp)
    80005eb6:	6402                	ld	s0,0(sp)
    80005eb8:	0141                	addi	sp,sp,16
    80005eba:	8082                	ret

0000000080005ebc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005ebc:	1101                	addi	sp,sp,-32
    80005ebe:	ec06                	sd	ra,24(sp)
    80005ec0:	e822                	sd	s0,16(sp)
    80005ec2:	e426                	sd	s1,8(sp)
    80005ec4:	1000                	addi	s0,sp,32
    80005ec6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005ec8:	ffffc097          	auipc	ra,0xffffc
    80005ecc:	d22080e7          	jalr	-734(ra) # 80001bea <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005ed0:	00d5151b          	slliw	a0,a0,0xd
    80005ed4:	0c2017b7          	lui	a5,0xc201
    80005ed8:	97aa                	add	a5,a5,a0
    80005eda:	c3c4                	sw	s1,4(a5)
}
    80005edc:	60e2                	ld	ra,24(sp)
    80005ede:	6442                	ld	s0,16(sp)
    80005ee0:	64a2                	ld	s1,8(sp)
    80005ee2:	6105                	addi	sp,sp,32
    80005ee4:	8082                	ret

0000000080005ee6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005ee6:	1141                	addi	sp,sp,-16
    80005ee8:	e406                	sd	ra,8(sp)
    80005eea:	e022                	sd	s0,0(sp)
    80005eec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005eee:	479d                	li	a5,7
    80005ef0:	04a7cc63          	blt	a5,a0,80005f48 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005ef4:	0023c797          	auipc	a5,0x23c
    80005ef8:	d4c78793          	addi	a5,a5,-692 # 80241c40 <disk>
    80005efc:	97aa                	add	a5,a5,a0
    80005efe:	0187c783          	lbu	a5,24(a5)
    80005f02:	ebb9                	bnez	a5,80005f58 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005f04:	00451613          	slli	a2,a0,0x4
    80005f08:	0023c797          	auipc	a5,0x23c
    80005f0c:	d3878793          	addi	a5,a5,-712 # 80241c40 <disk>
    80005f10:	6394                	ld	a3,0(a5)
    80005f12:	96b2                	add	a3,a3,a2
    80005f14:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005f18:	6398                	ld	a4,0(a5)
    80005f1a:	9732                	add	a4,a4,a2
    80005f1c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005f20:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005f24:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005f28:	953e                	add	a0,a0,a5
    80005f2a:	4785                	li	a5,1
    80005f2c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005f30:	0023c517          	auipc	a0,0x23c
    80005f34:	d2850513          	addi	a0,a0,-728 # 80241c58 <disk+0x18>
    80005f38:	ffffc097          	auipc	ra,0xffffc
    80005f3c:	3ee080e7          	jalr	1006(ra) # 80002326 <wakeup>
}
    80005f40:	60a2                	ld	ra,8(sp)
    80005f42:	6402                	ld	s0,0(sp)
    80005f44:	0141                	addi	sp,sp,16
    80005f46:	8082                	ret
    panic("free_desc 1");
    80005f48:	00003517          	auipc	a0,0x3
    80005f4c:	83850513          	addi	a0,a0,-1992 # 80008780 <syscalls+0x2f0>
    80005f50:	ffffa097          	auipc	ra,0xffffa
    80005f54:	5ee080e7          	jalr	1518(ra) # 8000053e <panic>
    panic("free_desc 2");
    80005f58:	00003517          	auipc	a0,0x3
    80005f5c:	83850513          	addi	a0,a0,-1992 # 80008790 <syscalls+0x300>
    80005f60:	ffffa097          	auipc	ra,0xffffa
    80005f64:	5de080e7          	jalr	1502(ra) # 8000053e <panic>

0000000080005f68 <virtio_disk_init>:
{
    80005f68:	1101                	addi	sp,sp,-32
    80005f6a:	ec06                	sd	ra,24(sp)
    80005f6c:	e822                	sd	s0,16(sp)
    80005f6e:	e426                	sd	s1,8(sp)
    80005f70:	e04a                	sd	s2,0(sp)
    80005f72:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005f74:	00003597          	auipc	a1,0x3
    80005f78:	82c58593          	addi	a1,a1,-2004 # 800087a0 <syscalls+0x310>
    80005f7c:	0023c517          	auipc	a0,0x23c
    80005f80:	dec50513          	addi	a0,a0,-532 # 80241d68 <disk+0x128>
    80005f84:	ffffb097          	auipc	ra,0xffffb
    80005f88:	cbe080e7          	jalr	-834(ra) # 80000c42 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f8c:	100017b7          	lui	a5,0x10001
    80005f90:	4398                	lw	a4,0(a5)
    80005f92:	2701                	sext.w	a4,a4
    80005f94:	747277b7          	lui	a5,0x74727
    80005f98:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005f9c:	14f71c63          	bne	a4,a5,800060f4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005fa0:	100017b7          	lui	a5,0x10001
    80005fa4:	43dc                	lw	a5,4(a5)
    80005fa6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005fa8:	4709                	li	a4,2
    80005faa:	14e79563          	bne	a5,a4,800060f4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005fae:	100017b7          	lui	a5,0x10001
    80005fb2:	479c                	lw	a5,8(a5)
    80005fb4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005fb6:	12e79f63          	bne	a5,a4,800060f4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005fba:	100017b7          	lui	a5,0x10001
    80005fbe:	47d8                	lw	a4,12(a5)
    80005fc0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005fc2:	554d47b7          	lui	a5,0x554d4
    80005fc6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005fca:	12f71563          	bne	a4,a5,800060f4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005fce:	100017b7          	lui	a5,0x10001
    80005fd2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005fd6:	4705                	li	a4,1
    80005fd8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005fda:	470d                	li	a4,3
    80005fdc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005fde:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005fe0:	c7ffe737          	lui	a4,0xc7ffe
    80005fe4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47dbc9df>
    80005fe8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005fea:	2701                	sext.w	a4,a4
    80005fec:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005fee:	472d                	li	a4,11
    80005ff0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005ff2:	5bbc                	lw	a5,112(a5)
    80005ff4:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005ff8:	8ba1                	andi	a5,a5,8
    80005ffa:	10078563          	beqz	a5,80006104 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005ffe:	100017b7          	lui	a5,0x10001
    80006002:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006006:	43fc                	lw	a5,68(a5)
    80006008:	2781                	sext.w	a5,a5
    8000600a:	10079563          	bnez	a5,80006114 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000600e:	100017b7          	lui	a5,0x10001
    80006012:	5bdc                	lw	a5,52(a5)
    80006014:	2781                	sext.w	a5,a5
  if(max == 0)
    80006016:	10078763          	beqz	a5,80006124 <virtio_disk_init+0x1bc>
  if(max < NUM)
    8000601a:	471d                	li	a4,7
    8000601c:	10f77c63          	bgeu	a4,a5,80006134 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80006020:	ffffb097          	auipc	ra,0xffffb
    80006024:	b90080e7          	jalr	-1136(ra) # 80000bb0 <kalloc>
    80006028:	0023c497          	auipc	s1,0x23c
    8000602c:	c1848493          	addi	s1,s1,-1000 # 80241c40 <disk>
    80006030:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006032:	ffffb097          	auipc	ra,0xffffb
    80006036:	b7e080e7          	jalr	-1154(ra) # 80000bb0 <kalloc>
    8000603a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000603c:	ffffb097          	auipc	ra,0xffffb
    80006040:	b74080e7          	jalr	-1164(ra) # 80000bb0 <kalloc>
    80006044:	87aa                	mv	a5,a0
    80006046:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006048:	6088                	ld	a0,0(s1)
    8000604a:	cd6d                	beqz	a0,80006144 <virtio_disk_init+0x1dc>
    8000604c:	0023c717          	auipc	a4,0x23c
    80006050:	bfc73703          	ld	a4,-1028(a4) # 80241c48 <disk+0x8>
    80006054:	cb65                	beqz	a4,80006144 <virtio_disk_init+0x1dc>
    80006056:	c7fd                	beqz	a5,80006144 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80006058:	6605                	lui	a2,0x1
    8000605a:	4581                	li	a1,0
    8000605c:	ffffb097          	auipc	ra,0xffffb
    80006060:	d72080e7          	jalr	-654(ra) # 80000dce <memset>
  memset(disk.avail, 0, PGSIZE);
    80006064:	0023c497          	auipc	s1,0x23c
    80006068:	bdc48493          	addi	s1,s1,-1060 # 80241c40 <disk>
    8000606c:	6605                	lui	a2,0x1
    8000606e:	4581                	li	a1,0
    80006070:	6488                	ld	a0,8(s1)
    80006072:	ffffb097          	auipc	ra,0xffffb
    80006076:	d5c080e7          	jalr	-676(ra) # 80000dce <memset>
  memset(disk.used, 0, PGSIZE);
    8000607a:	6605                	lui	a2,0x1
    8000607c:	4581                	li	a1,0
    8000607e:	6888                	ld	a0,16(s1)
    80006080:	ffffb097          	auipc	ra,0xffffb
    80006084:	d4e080e7          	jalr	-690(ra) # 80000dce <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006088:	100017b7          	lui	a5,0x10001
    8000608c:	4721                	li	a4,8
    8000608e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006090:	4098                	lw	a4,0(s1)
    80006092:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006096:	40d8                	lw	a4,4(s1)
    80006098:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000609c:	6498                	ld	a4,8(s1)
    8000609e:	0007069b          	sext.w	a3,a4
    800060a2:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800060a6:	9701                	srai	a4,a4,0x20
    800060a8:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800060ac:	6898                	ld	a4,16(s1)
    800060ae:	0007069b          	sext.w	a3,a4
    800060b2:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800060b6:	9701                	srai	a4,a4,0x20
    800060b8:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800060bc:	4705                	li	a4,1
    800060be:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800060c0:	00e48c23          	sb	a4,24(s1)
    800060c4:	00e48ca3          	sb	a4,25(s1)
    800060c8:	00e48d23          	sb	a4,26(s1)
    800060cc:	00e48da3          	sb	a4,27(s1)
    800060d0:	00e48e23          	sb	a4,28(s1)
    800060d4:	00e48ea3          	sb	a4,29(s1)
    800060d8:	00e48f23          	sb	a4,30(s1)
    800060dc:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800060e0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800060e4:	0727a823          	sw	s2,112(a5)
}
    800060e8:	60e2                	ld	ra,24(sp)
    800060ea:	6442                	ld	s0,16(sp)
    800060ec:	64a2                	ld	s1,8(sp)
    800060ee:	6902                	ld	s2,0(sp)
    800060f0:	6105                	addi	sp,sp,32
    800060f2:	8082                	ret
    panic("could not find virtio disk");
    800060f4:	00002517          	auipc	a0,0x2
    800060f8:	6bc50513          	addi	a0,a0,1724 # 800087b0 <syscalls+0x320>
    800060fc:	ffffa097          	auipc	ra,0xffffa
    80006100:	442080e7          	jalr	1090(ra) # 8000053e <panic>
    panic("virtio disk FEATURES_OK unset");
    80006104:	00002517          	auipc	a0,0x2
    80006108:	6cc50513          	addi	a0,a0,1740 # 800087d0 <syscalls+0x340>
    8000610c:	ffffa097          	auipc	ra,0xffffa
    80006110:	432080e7          	jalr	1074(ra) # 8000053e <panic>
    panic("virtio disk should not be ready");
    80006114:	00002517          	auipc	a0,0x2
    80006118:	6dc50513          	addi	a0,a0,1756 # 800087f0 <syscalls+0x360>
    8000611c:	ffffa097          	auipc	ra,0xffffa
    80006120:	422080e7          	jalr	1058(ra) # 8000053e <panic>
    panic("virtio disk has no queue 0");
    80006124:	00002517          	auipc	a0,0x2
    80006128:	6ec50513          	addi	a0,a0,1772 # 80008810 <syscalls+0x380>
    8000612c:	ffffa097          	auipc	ra,0xffffa
    80006130:	412080e7          	jalr	1042(ra) # 8000053e <panic>
    panic("virtio disk max queue too short");
    80006134:	00002517          	auipc	a0,0x2
    80006138:	6fc50513          	addi	a0,a0,1788 # 80008830 <syscalls+0x3a0>
    8000613c:	ffffa097          	auipc	ra,0xffffa
    80006140:	402080e7          	jalr	1026(ra) # 8000053e <panic>
    panic("virtio disk kalloc");
    80006144:	00002517          	auipc	a0,0x2
    80006148:	70c50513          	addi	a0,a0,1804 # 80008850 <syscalls+0x3c0>
    8000614c:	ffffa097          	auipc	ra,0xffffa
    80006150:	3f2080e7          	jalr	1010(ra) # 8000053e <panic>

0000000080006154 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006154:	7119                	addi	sp,sp,-128
    80006156:	fc86                	sd	ra,120(sp)
    80006158:	f8a2                	sd	s0,112(sp)
    8000615a:	f4a6                	sd	s1,104(sp)
    8000615c:	f0ca                	sd	s2,96(sp)
    8000615e:	ecce                	sd	s3,88(sp)
    80006160:	e8d2                	sd	s4,80(sp)
    80006162:	e4d6                	sd	s5,72(sp)
    80006164:	e0da                	sd	s6,64(sp)
    80006166:	fc5e                	sd	s7,56(sp)
    80006168:	f862                	sd	s8,48(sp)
    8000616a:	f466                	sd	s9,40(sp)
    8000616c:	f06a                	sd	s10,32(sp)
    8000616e:	ec6e                	sd	s11,24(sp)
    80006170:	0100                	addi	s0,sp,128
    80006172:	8aaa                	mv	s5,a0
    80006174:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006176:	00c52d03          	lw	s10,12(a0)
    8000617a:	001d1d1b          	slliw	s10,s10,0x1
    8000617e:	1d02                	slli	s10,s10,0x20
    80006180:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006184:	0023c517          	auipc	a0,0x23c
    80006188:	be450513          	addi	a0,a0,-1052 # 80241d68 <disk+0x128>
    8000618c:	ffffb097          	auipc	ra,0xffffb
    80006190:	b46080e7          	jalr	-1210(ra) # 80000cd2 <acquire>
  for(int i = 0; i < 3; i++){
    80006194:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006196:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006198:	0023cb97          	auipc	s7,0x23c
    8000619c:	aa8b8b93          	addi	s7,s7,-1368 # 80241c40 <disk>
  for(int i = 0; i < 3; i++){
    800061a0:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800061a2:	0023cc97          	auipc	s9,0x23c
    800061a6:	bc6c8c93          	addi	s9,s9,-1082 # 80241d68 <disk+0x128>
    800061aa:	a08d                	j	8000620c <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800061ac:	00fb8733          	add	a4,s7,a5
    800061b0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800061b4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800061b6:	0207c563          	bltz	a5,800061e0 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800061ba:	2905                	addiw	s2,s2,1
    800061bc:	0611                	addi	a2,a2,4
    800061be:	05690c63          	beq	s2,s6,80006216 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800061c2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800061c4:	0023c717          	auipc	a4,0x23c
    800061c8:	a7c70713          	addi	a4,a4,-1412 # 80241c40 <disk>
    800061cc:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800061ce:	01874683          	lbu	a3,24(a4)
    800061d2:	fee9                	bnez	a3,800061ac <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800061d4:	2785                	addiw	a5,a5,1
    800061d6:	0705                	addi	a4,a4,1
    800061d8:	fe979be3          	bne	a5,s1,800061ce <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800061dc:	57fd                	li	a5,-1
    800061de:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800061e0:	01205d63          	blez	s2,800061fa <virtio_disk_rw+0xa6>
    800061e4:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800061e6:	000a2503          	lw	a0,0(s4)
    800061ea:	00000097          	auipc	ra,0x0
    800061ee:	cfc080e7          	jalr	-772(ra) # 80005ee6 <free_desc>
      for(int j = 0; j < i; j++)
    800061f2:	2d85                	addiw	s11,s11,1
    800061f4:	0a11                	addi	s4,s4,4
    800061f6:	ffb918e3          	bne	s2,s11,800061e6 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800061fa:	85e6                	mv	a1,s9
    800061fc:	0023c517          	auipc	a0,0x23c
    80006200:	a5c50513          	addi	a0,a0,-1444 # 80241c58 <disk+0x18>
    80006204:	ffffc097          	auipc	ra,0xffffc
    80006208:	0be080e7          	jalr	190(ra) # 800022c2 <sleep>
  for(int i = 0; i < 3; i++){
    8000620c:	f8040a13          	addi	s4,s0,-128
{
    80006210:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006212:	894e                	mv	s2,s3
    80006214:	b77d                	j	800061c2 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006216:	f8042583          	lw	a1,-128(s0)
    8000621a:	00a58793          	addi	a5,a1,10
    8000621e:	0792                	slli	a5,a5,0x4

  if(write)
    80006220:	0023c617          	auipc	a2,0x23c
    80006224:	a2060613          	addi	a2,a2,-1504 # 80241c40 <disk>
    80006228:	00f60733          	add	a4,a2,a5
    8000622c:	018036b3          	snez	a3,s8
    80006230:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006232:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006236:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000623a:	f6078693          	addi	a3,a5,-160
    8000623e:	6218                	ld	a4,0(a2)
    80006240:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006242:	00878513          	addi	a0,a5,8
    80006246:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006248:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000624a:	6208                	ld	a0,0(a2)
    8000624c:	96aa                	add	a3,a3,a0
    8000624e:	4741                	li	a4,16
    80006250:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006252:	4705                	li	a4,1
    80006254:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80006258:	f8442703          	lw	a4,-124(s0)
    8000625c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006260:	0712                	slli	a4,a4,0x4
    80006262:	953a                	add	a0,a0,a4
    80006264:	058a8693          	addi	a3,s5,88
    80006268:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000626a:	6208                	ld	a0,0(a2)
    8000626c:	972a                	add	a4,a4,a0
    8000626e:	40000693          	li	a3,1024
    80006272:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006274:	001c3c13          	seqz	s8,s8
    80006278:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000627a:	001c6c13          	ori	s8,s8,1
    8000627e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006282:	f8842603          	lw	a2,-120(s0)
    80006286:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000628a:	0023c697          	auipc	a3,0x23c
    8000628e:	9b668693          	addi	a3,a3,-1610 # 80241c40 <disk>
    80006292:	00258713          	addi	a4,a1,2
    80006296:	0712                	slli	a4,a4,0x4
    80006298:	9736                	add	a4,a4,a3
    8000629a:	587d                	li	a6,-1
    8000629c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800062a0:	0612                	slli	a2,a2,0x4
    800062a2:	9532                	add	a0,a0,a2
    800062a4:	f9078793          	addi	a5,a5,-112
    800062a8:	97b6                	add	a5,a5,a3
    800062aa:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    800062ac:	629c                	ld	a5,0(a3)
    800062ae:	97b2                	add	a5,a5,a2
    800062b0:	4605                	li	a2,1
    800062b2:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800062b4:	4509                	li	a0,2
    800062b6:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    800062ba:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800062be:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800062c2:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800062c6:	6698                	ld	a4,8(a3)
    800062c8:	00275783          	lhu	a5,2(a4)
    800062cc:	8b9d                	andi	a5,a5,7
    800062ce:	0786                	slli	a5,a5,0x1
    800062d0:	97ba                	add	a5,a5,a4
    800062d2:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800062d6:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800062da:	6698                	ld	a4,8(a3)
    800062dc:	00275783          	lhu	a5,2(a4)
    800062e0:	2785                	addiw	a5,a5,1
    800062e2:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800062e6:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800062ea:	100017b7          	lui	a5,0x10001
    800062ee:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800062f2:	004aa783          	lw	a5,4(s5)
    800062f6:	02c79163          	bne	a5,a2,80006318 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800062fa:	0023c917          	auipc	s2,0x23c
    800062fe:	a6e90913          	addi	s2,s2,-1426 # 80241d68 <disk+0x128>
  while(b->disk == 1) {
    80006302:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006304:	85ca                	mv	a1,s2
    80006306:	8556                	mv	a0,s5
    80006308:	ffffc097          	auipc	ra,0xffffc
    8000630c:	fba080e7          	jalr	-70(ra) # 800022c2 <sleep>
  while(b->disk == 1) {
    80006310:	004aa783          	lw	a5,4(s5)
    80006314:	fe9788e3          	beq	a5,s1,80006304 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006318:	f8042903          	lw	s2,-128(s0)
    8000631c:	00290793          	addi	a5,s2,2
    80006320:	00479713          	slli	a4,a5,0x4
    80006324:	0023c797          	auipc	a5,0x23c
    80006328:	91c78793          	addi	a5,a5,-1764 # 80241c40 <disk>
    8000632c:	97ba                	add	a5,a5,a4
    8000632e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006332:	0023c997          	auipc	s3,0x23c
    80006336:	90e98993          	addi	s3,s3,-1778 # 80241c40 <disk>
    8000633a:	00491713          	slli	a4,s2,0x4
    8000633e:	0009b783          	ld	a5,0(s3)
    80006342:	97ba                	add	a5,a5,a4
    80006344:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006348:	854a                	mv	a0,s2
    8000634a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000634e:	00000097          	auipc	ra,0x0
    80006352:	b98080e7          	jalr	-1128(ra) # 80005ee6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006356:	8885                	andi	s1,s1,1
    80006358:	f0ed                	bnez	s1,8000633a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000635a:	0023c517          	auipc	a0,0x23c
    8000635e:	a0e50513          	addi	a0,a0,-1522 # 80241d68 <disk+0x128>
    80006362:	ffffb097          	auipc	ra,0xffffb
    80006366:	a24080e7          	jalr	-1500(ra) # 80000d86 <release>
}
    8000636a:	70e6                	ld	ra,120(sp)
    8000636c:	7446                	ld	s0,112(sp)
    8000636e:	74a6                	ld	s1,104(sp)
    80006370:	7906                	ld	s2,96(sp)
    80006372:	69e6                	ld	s3,88(sp)
    80006374:	6a46                	ld	s4,80(sp)
    80006376:	6aa6                	ld	s5,72(sp)
    80006378:	6b06                	ld	s6,64(sp)
    8000637a:	7be2                	ld	s7,56(sp)
    8000637c:	7c42                	ld	s8,48(sp)
    8000637e:	7ca2                	ld	s9,40(sp)
    80006380:	7d02                	ld	s10,32(sp)
    80006382:	6de2                	ld	s11,24(sp)
    80006384:	6109                	addi	sp,sp,128
    80006386:	8082                	ret

0000000080006388 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006388:	1101                	addi	sp,sp,-32
    8000638a:	ec06                	sd	ra,24(sp)
    8000638c:	e822                	sd	s0,16(sp)
    8000638e:	e426                	sd	s1,8(sp)
    80006390:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006392:	0023c497          	auipc	s1,0x23c
    80006396:	8ae48493          	addi	s1,s1,-1874 # 80241c40 <disk>
    8000639a:	0023c517          	auipc	a0,0x23c
    8000639e:	9ce50513          	addi	a0,a0,-1586 # 80241d68 <disk+0x128>
    800063a2:	ffffb097          	auipc	ra,0xffffb
    800063a6:	930080e7          	jalr	-1744(ra) # 80000cd2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800063aa:	10001737          	lui	a4,0x10001
    800063ae:	533c                	lw	a5,96(a4)
    800063b0:	8b8d                	andi	a5,a5,3
    800063b2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800063b4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800063b8:	689c                	ld	a5,16(s1)
    800063ba:	0204d703          	lhu	a4,32(s1)
    800063be:	0027d783          	lhu	a5,2(a5)
    800063c2:	04f70863          	beq	a4,a5,80006412 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800063c6:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800063ca:	6898                	ld	a4,16(s1)
    800063cc:	0204d783          	lhu	a5,32(s1)
    800063d0:	8b9d                	andi	a5,a5,7
    800063d2:	078e                	slli	a5,a5,0x3
    800063d4:	97ba                	add	a5,a5,a4
    800063d6:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800063d8:	00278713          	addi	a4,a5,2
    800063dc:	0712                	slli	a4,a4,0x4
    800063de:	9726                	add	a4,a4,s1
    800063e0:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800063e4:	e721                	bnez	a4,8000642c <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800063e6:	0789                	addi	a5,a5,2
    800063e8:	0792                	slli	a5,a5,0x4
    800063ea:	97a6                	add	a5,a5,s1
    800063ec:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800063ee:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800063f2:	ffffc097          	auipc	ra,0xffffc
    800063f6:	f34080e7          	jalr	-204(ra) # 80002326 <wakeup>

    disk.used_idx += 1;
    800063fa:	0204d783          	lhu	a5,32(s1)
    800063fe:	2785                	addiw	a5,a5,1
    80006400:	17c2                	slli	a5,a5,0x30
    80006402:	93c1                	srli	a5,a5,0x30
    80006404:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006408:	6898                	ld	a4,16(s1)
    8000640a:	00275703          	lhu	a4,2(a4)
    8000640e:	faf71ce3          	bne	a4,a5,800063c6 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006412:	0023c517          	auipc	a0,0x23c
    80006416:	95650513          	addi	a0,a0,-1706 # 80241d68 <disk+0x128>
    8000641a:	ffffb097          	auipc	ra,0xffffb
    8000641e:	96c080e7          	jalr	-1684(ra) # 80000d86 <release>
}
    80006422:	60e2                	ld	ra,24(sp)
    80006424:	6442                	ld	s0,16(sp)
    80006426:	64a2                	ld	s1,8(sp)
    80006428:	6105                	addi	sp,sp,32
    8000642a:	8082                	ret
      panic("virtio_disk_intr status");
    8000642c:	00002517          	auipc	a0,0x2
    80006430:	43c50513          	addi	a0,a0,1084 # 80008868 <syscalls+0x3d8>
    80006434:	ffffa097          	auipc	ra,0xffffa
    80006438:	10a080e7          	jalr	266(ra) # 8000053e <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
