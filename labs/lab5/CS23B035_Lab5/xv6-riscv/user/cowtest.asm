
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:
// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.
void
simpletest()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;

  printf("simple: ");
   e:	00001517          	auipc	a0,0x1
  12:	d7250513          	addi	a0,a0,-654 # d80 <malloc+0xe6>
  16:	00001097          	auipc	ra,0x1
  1a:	bc6080e7          	jalr	-1082(ra) # bdc <printf>
  
  char *p = sbrk(sz);
  1e:	05555537          	lui	a0,0x5555
  22:	55450513          	addi	a0,a0,1364 # 5555554 <base+0x5550544>
  26:	00001097          	auipc	ra,0x1
  2a:	8c6080e7          	jalr	-1850(ra) # 8ec <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  2e:	57fd                	li	a5,-1
  30:	06f50563          	beq	a0,a5,9a <simpletest+0x9a>
  34:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  for(char *q = p; q < p + sz; q += 4096){
  36:	05556937          	lui	s2,0x5556
  3a:	992a                	add	s2,s2,a0
  3c:	6985                	lui	s3,0x1
    *(int*)q = getpid();
  3e:	00001097          	auipc	ra,0x1
  42:	8a6080e7          	jalr	-1882(ra) # 8e4 <getpid>
  46:	c088                	sw	a0,0(s1)
  for(char *q = p; q < p + sz; q += 4096){
  48:	94ce                	add	s1,s1,s3
  4a:	fe991ae3          	bne	s2,s1,3e <simpletest+0x3e>
  }

  int pid = fork();
  4e:	00001097          	auipc	ra,0x1
  52:	80e080e7          	jalr	-2034(ra) # 85c <fork>
  if(pid < 0){
  56:	06054363          	bltz	a0,bc <simpletest+0xbc>
    printf("fork() failed\n");
    exit(-1);
  }

  if(pid == 0)
  5a:	cd35                	beqz	a0,d6 <simpletest+0xd6>
    exit(0);

  wait(0);
  5c:	4501                	li	a0,0
  5e:	00001097          	auipc	ra,0x1
  62:	80e080e7          	jalr	-2034(ra) # 86c <wait>

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
  66:	faaab537          	lui	a0,0xfaaab
  6a:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <base+0xfffffffffaaa5a9c>
  6e:	00001097          	auipc	ra,0x1
  72:	87e080e7          	jalr	-1922(ra) # 8ec <sbrk>
  76:	57fd                	li	a5,-1
  78:	06f50363          	beq	a0,a5,de <simpletest+0xde>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
  7c:	00001517          	auipc	a0,0x1
  80:	d5450513          	addi	a0,a0,-684 # dd0 <malloc+0x136>
  84:	00001097          	auipc	ra,0x1
  88:	b58080e7          	jalr	-1192(ra) # bdc <printf>
}
  8c:	70a2                	ld	ra,40(sp)
  8e:	7402                	ld	s0,32(sp)
  90:	64e2                	ld	s1,24(sp)
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	6145                	addi	sp,sp,48
  98:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  9a:	055555b7          	lui	a1,0x5555
  9e:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x5550544>
  a2:	00001517          	auipc	a0,0x1
  a6:	cee50513          	addi	a0,a0,-786 # d90 <malloc+0xf6>
  aa:	00001097          	auipc	ra,0x1
  ae:	b32080e7          	jalr	-1230(ra) # bdc <printf>
    exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	7b0080e7          	jalr	1968(ra) # 864 <exit>
    printf("fork() failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	cec50513          	addi	a0,a0,-788 # da8 <malloc+0x10e>
  c4:	00001097          	auipc	ra,0x1
  c8:	b18080e7          	jalr	-1256(ra) # bdc <printf>
    exit(-1);
  cc:	557d                	li	a0,-1
  ce:	00000097          	auipc	ra,0x0
  d2:	796080e7          	jalr	1942(ra) # 864 <exit>
    exit(0);
  d6:	00000097          	auipc	ra,0x0
  da:	78e080e7          	jalr	1934(ra) # 864 <exit>
    printf("sbrk(-%d) failed\n", sz);
  de:	055555b7          	lui	a1,0x5555
  e2:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x5550544>
  e6:	00001517          	auipc	a0,0x1
  ea:	cd250513          	addi	a0,a0,-814 # db8 <malloc+0x11e>
  ee:	00001097          	auipc	ra,0x1
  f2:	aee080e7          	jalr	-1298(ra) # bdc <printf>
    exit(-1);
  f6:	557d                	li	a0,-1
  f8:	00000097          	auipc	ra,0x0
  fc:	76c080e7          	jalr	1900(ra) # 864 <exit>

0000000000000100 <threetest>:
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
 100:	7179                	addi	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
 110:	00001517          	auipc	a0,0x1
 114:	cc850513          	addi	a0,a0,-824 # dd8 <malloc+0x13e>
 118:	00001097          	auipc	ra,0x1
 11c:	ac4080e7          	jalr	-1340(ra) # bdc <printf>
  
  char *p = sbrk(sz);
 120:	02000537          	lui	a0,0x2000
 124:	00000097          	auipc	ra,0x0
 128:	7c8080e7          	jalr	1992(ra) # 8ec <sbrk>
  if(p == (char*)0xffffffffffffffffL){
 12c:	57fd                	li	a5,-1
 12e:	08f50763          	beq	a0,a5,1bc <threetest+0xbc>
 132:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
 134:	00000097          	auipc	ra,0x0
 138:	728080e7          	jalr	1832(ra) # 85c <fork>
  if(pid1 < 0){
 13c:	08054f63          	bltz	a0,1da <threetest+0xda>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid1 == 0){
 140:	c955                	beqz	a0,1f4 <threetest+0xf4>
      *(int*)q = 9999;
    }
    exit(0);
  }

  for(char *q = p; q < p + sz; q += 4096){
 142:	020009b7          	lui	s3,0x2000
 146:	99a6                	add	s3,s3,s1
 148:	8926                	mv	s2,s1
 14a:	6a05                	lui	s4,0x1
    *(int*)q = getpid();
 14c:	00000097          	auipc	ra,0x0
 150:	798080e7          	jalr	1944(ra) # 8e4 <getpid>
 154:	00a92023          	sw	a0,0(s2) # 5556000 <base+0x5550ff0>
  for(char *q = p; q < p + sz; q += 4096){
 158:	9952                	add	s2,s2,s4
 15a:	ff3919e3          	bne	s2,s3,14c <threetest+0x4c>
  }

  wait(0);
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	70c080e7          	jalr	1804(ra) # 86c <wait>

  sleep(1);
 168:	4505                	li	a0,1
 16a:	00000097          	auipc	ra,0x0
 16e:	78a080e7          	jalr	1930(ra) # 8f4 <sleep>

  for(char *q = p; q < p + sz; q += 4096){
 172:	6a05                	lui	s4,0x1
    if(*(int*)q != getpid()){
 174:	0004a903          	lw	s2,0(s1)
 178:	00000097          	auipc	ra,0x0
 17c:	76c080e7          	jalr	1900(ra) # 8e4 <getpid>
 180:	10a91a63          	bne	s2,a0,294 <threetest+0x194>
  for(char *q = p; q < p + sz; q += 4096){
 184:	94d2                	add	s1,s1,s4
 186:	ff3497e3          	bne	s1,s3,174 <threetest+0x74>
      printf("wrong content\n");
      exit(-1);
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
 18a:	fe000537          	lui	a0,0xfe000
 18e:	00000097          	auipc	ra,0x0
 192:	75e080e7          	jalr	1886(ra) # 8ec <sbrk>
 196:	57fd                	li	a5,-1
 198:	10f50b63          	beq	a0,a5,2ae <threetest+0x1ae>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	c3450513          	addi	a0,a0,-972 # dd0 <malloc+0x136>
 1a4:	00001097          	auipc	ra,0x1
 1a8:	a38080e7          	jalr	-1480(ra) # bdc <printf>
}
 1ac:	70a2                	ld	ra,40(sp)
 1ae:	7402                	ld	s0,32(sp)
 1b0:	64e2                	ld	s1,24(sp)
 1b2:	6942                	ld	s2,16(sp)
 1b4:	69a2                	ld	s3,8(sp)
 1b6:	6a02                	ld	s4,0(sp)
 1b8:	6145                	addi	sp,sp,48
 1ba:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1bc:	020005b7          	lui	a1,0x2000
 1c0:	00001517          	auipc	a0,0x1
 1c4:	bd050513          	addi	a0,a0,-1072 # d90 <malloc+0xf6>
 1c8:	00001097          	auipc	ra,0x1
 1cc:	a14080e7          	jalr	-1516(ra) # bdc <printf>
    exit(-1);
 1d0:	557d                	li	a0,-1
 1d2:	00000097          	auipc	ra,0x0
 1d6:	692080e7          	jalr	1682(ra) # 864 <exit>
    printf("fork failed\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	c0650513          	addi	a0,a0,-1018 # de0 <malloc+0x146>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	9fa080e7          	jalr	-1542(ra) # bdc <printf>
    exit(-1);
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	678080e7          	jalr	1656(ra) # 864 <exit>
    pid2 = fork();
 1f4:	00000097          	auipc	ra,0x0
 1f8:	668080e7          	jalr	1640(ra) # 85c <fork>
    if(pid2 < 0){
 1fc:	04054263          	bltz	a0,240 <threetest+0x140>
    if(pid2 == 0){
 200:	ed29                	bnez	a0,25a <threetest+0x15a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 202:	0199a9b7          	lui	s3,0x199a
 206:	99a6                	add	s3,s3,s1
 208:	8926                	mv	s2,s1
 20a:	6a05                	lui	s4,0x1
        *(int*)q = getpid();
 20c:	00000097          	auipc	ra,0x0
 210:	6d8080e7          	jalr	1752(ra) # 8e4 <getpid>
 214:	00a92023          	sw	a0,0(s2)
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 218:	9952                	add	s2,s2,s4
 21a:	ff2999e3          	bne	s3,s2,20c <threetest+0x10c>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 21e:	6a05                	lui	s4,0x1
        if(*(int*)q != getpid()){
 220:	0004a903          	lw	s2,0(s1)
 224:	00000097          	auipc	ra,0x0
 228:	6c0080e7          	jalr	1728(ra) # 8e4 <getpid>
 22c:	04a91763          	bne	s2,a0,27a <threetest+0x17a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 230:	94d2                	add	s1,s1,s4
 232:	fe9997e3          	bne	s3,s1,220 <threetest+0x120>
      exit(-1);
 236:	557d                	li	a0,-1
 238:	00000097          	auipc	ra,0x0
 23c:	62c080e7          	jalr	1580(ra) # 864 <exit>
      printf("fork failed");
 240:	00001517          	auipc	a0,0x1
 244:	bb050513          	addi	a0,a0,-1104 # df0 <malloc+0x156>
 248:	00001097          	auipc	ra,0x1
 24c:	994080e7          	jalr	-1644(ra) # bdc <printf>
      exit(-1);
 250:	557d                	li	a0,-1
 252:	00000097          	auipc	ra,0x0
 256:	612080e7          	jalr	1554(ra) # 864 <exit>
    for(char *q = p; q < p + (sz/2); q += 4096){
 25a:	01000737          	lui	a4,0x1000
 25e:	9726                	add	a4,a4,s1
      *(int*)q = 9999;
 260:	6789                	lui	a5,0x2
 262:	70f78793          	addi	a5,a5,1807 # 270f <buf+0x6ff>
    for(char *q = p; q < p + (sz/2); q += 4096){
 266:	6685                	lui	a3,0x1
      *(int*)q = 9999;
 268:	c09c                	sw	a5,0(s1)
    for(char *q = p; q < p + (sz/2); q += 4096){
 26a:	94b6                	add	s1,s1,a3
 26c:	fee49ee3          	bne	s1,a4,268 <threetest+0x168>
    exit(0);
 270:	4501                	li	a0,0
 272:	00000097          	auipc	ra,0x0
 276:	5f2080e7          	jalr	1522(ra) # 864 <exit>
          printf("wrong content\n");
 27a:	00001517          	auipc	a0,0x1
 27e:	b8650513          	addi	a0,a0,-1146 # e00 <malloc+0x166>
 282:	00001097          	auipc	ra,0x1
 286:	95a080e7          	jalr	-1702(ra) # bdc <printf>
          exit(-1);
 28a:	557d                	li	a0,-1
 28c:	00000097          	auipc	ra,0x0
 290:	5d8080e7          	jalr	1496(ra) # 864 <exit>
      printf("wrong content\n");
 294:	00001517          	auipc	a0,0x1
 298:	b6c50513          	addi	a0,a0,-1172 # e00 <malloc+0x166>
 29c:	00001097          	auipc	ra,0x1
 2a0:	940080e7          	jalr	-1728(ra) # bdc <printf>
      exit(-1);
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	5be080e7          	jalr	1470(ra) # 864 <exit>
    printf("sbrk(-%d) failed\n", sz);
 2ae:	020005b7          	lui	a1,0x2000
 2b2:	00001517          	auipc	a0,0x1
 2b6:	b0650513          	addi	a0,a0,-1274 # db8 <malloc+0x11e>
 2ba:	00001097          	auipc	ra,0x1
 2be:	922080e7          	jalr	-1758(ra) # bdc <printf>
    exit(-1);
 2c2:	557d                	li	a0,-1
 2c4:	00000097          	auipc	ra,0x0
 2c8:	5a0080e7          	jalr	1440(ra) # 864 <exit>

00000000000002cc <filetest>:
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
 2cc:	7179                	addi	sp,sp,-48
 2ce:	f406                	sd	ra,40(sp)
 2d0:	f022                	sd	s0,32(sp)
 2d2:	ec26                	sd	s1,24(sp)
 2d4:	e84a                	sd	s2,16(sp)
 2d6:	1800                	addi	s0,sp,48
  printf("file: ");
 2d8:	00001517          	auipc	a0,0x1
 2dc:	b3850513          	addi	a0,a0,-1224 # e10 <malloc+0x176>
 2e0:	00001097          	auipc	ra,0x1
 2e4:	8fc080e7          	jalr	-1796(ra) # bdc <printf>
  
  buf[0] = 99;
 2e8:	06300793          	li	a5,99
 2ec:	00002717          	auipc	a4,0x2
 2f0:	d2f70223          	sb	a5,-732(a4) # 2010 <buf>

  for(int i = 0; i < 4; i++){
 2f4:	fc042c23          	sw	zero,-40(s0)
    if(pipe(fds) != 0){
 2f8:	00001497          	auipc	s1,0x1
 2fc:	d0848493          	addi	s1,s1,-760 # 1000 <fds>
  for(int i = 0; i < 4; i++){
 300:	490d                	li	s2,3
    if(pipe(fds) != 0){
 302:	8526                	mv	a0,s1
 304:	00000097          	auipc	ra,0x0
 308:	570080e7          	jalr	1392(ra) # 874 <pipe>
 30c:	e149                	bnez	a0,38e <filetest+0xc2>
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 30e:	00000097          	auipc	ra,0x0
 312:	54e080e7          	jalr	1358(ra) # 85c <fork>
    if(pid < 0){
 316:	08054963          	bltz	a0,3a8 <filetest+0xdc>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid == 0){
 31a:	c545                	beqz	a0,3c2 <filetest+0xf6>
        printf("error: read the wrong value\n");
        exit(1);
      }
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 31c:	4611                	li	a2,4
 31e:	fd840593          	addi	a1,s0,-40
 322:	40c8                	lw	a0,4(s1)
 324:	00000097          	auipc	ra,0x0
 328:	560080e7          	jalr	1376(ra) # 884 <write>
 32c:	4791                	li	a5,4
 32e:	10f51b63          	bne	a0,a5,444 <filetest+0x178>
  for(int i = 0; i < 4; i++){
 332:	fd842783          	lw	a5,-40(s0)
 336:	2785                	addiw	a5,a5,1
 338:	0007871b          	sext.w	a4,a5
 33c:	fcf42c23          	sw	a5,-40(s0)
 340:	fce951e3          	bge	s2,a4,302 <filetest+0x36>
      printf("error: write failed\n");
      exit(-1);
    }
  }

  int xstatus = 0;
 344:	fc042e23          	sw	zero,-36(s0)
 348:	4491                	li	s1,4
  for(int i = 0; i < 4; i++) {
    wait(&xstatus);
 34a:	fdc40513          	addi	a0,s0,-36
 34e:	00000097          	auipc	ra,0x0
 352:	51e080e7          	jalr	1310(ra) # 86c <wait>
    if(xstatus != 0) {
 356:	fdc42783          	lw	a5,-36(s0)
 35a:	10079263          	bnez	a5,45e <filetest+0x192>
  for(int i = 0; i < 4; i++) {
 35e:	34fd                	addiw	s1,s1,-1
 360:	f4ed                	bnez	s1,34a <filetest+0x7e>
      exit(1);
    }
  }

  if(buf[0] != 99){
 362:	00002717          	auipc	a4,0x2
 366:	cae74703          	lbu	a4,-850(a4) # 2010 <buf>
 36a:	06300793          	li	a5,99
 36e:	0ef71d63          	bne	a4,a5,468 <filetest+0x19c>
    printf("error: child overwrote parent\n");
    exit(1);
  }

  printf("ok\n");
 372:	00001517          	auipc	a0,0x1
 376:	a5e50513          	addi	a0,a0,-1442 # dd0 <malloc+0x136>
 37a:	00001097          	auipc	ra,0x1
 37e:	862080e7          	jalr	-1950(ra) # bdc <printf>
}
 382:	70a2                	ld	ra,40(sp)
 384:	7402                	ld	s0,32(sp)
 386:	64e2                	ld	s1,24(sp)
 388:	6942                	ld	s2,16(sp)
 38a:	6145                	addi	sp,sp,48
 38c:	8082                	ret
      printf("pipe() failed\n");
 38e:	00001517          	auipc	a0,0x1
 392:	a8a50513          	addi	a0,a0,-1398 # e18 <malloc+0x17e>
 396:	00001097          	auipc	ra,0x1
 39a:	846080e7          	jalr	-1978(ra) # bdc <printf>
      exit(-1);
 39e:	557d                	li	a0,-1
 3a0:	00000097          	auipc	ra,0x0
 3a4:	4c4080e7          	jalr	1220(ra) # 864 <exit>
      printf("fork failed\n");
 3a8:	00001517          	auipc	a0,0x1
 3ac:	a3850513          	addi	a0,a0,-1480 # de0 <malloc+0x146>
 3b0:	00001097          	auipc	ra,0x1
 3b4:	82c080e7          	jalr	-2004(ra) # bdc <printf>
      exit(-1);
 3b8:	557d                	li	a0,-1
 3ba:	00000097          	auipc	ra,0x0
 3be:	4aa080e7          	jalr	1194(ra) # 864 <exit>
      sleep(1);
 3c2:	4505                	li	a0,1
 3c4:	00000097          	auipc	ra,0x0
 3c8:	530080e7          	jalr	1328(ra) # 8f4 <sleep>
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
 3cc:	4611                	li	a2,4
 3ce:	00002597          	auipc	a1,0x2
 3d2:	c4258593          	addi	a1,a1,-958 # 2010 <buf>
 3d6:	00001517          	auipc	a0,0x1
 3da:	c2a52503          	lw	a0,-982(a0) # 1000 <fds>
 3de:	00000097          	auipc	ra,0x0
 3e2:	49e080e7          	jalr	1182(ra) # 87c <read>
 3e6:	4791                	li	a5,4
 3e8:	02f51c63          	bne	a0,a5,420 <filetest+0x154>
      sleep(1);
 3ec:	4505                	li	a0,1
 3ee:	00000097          	auipc	ra,0x0
 3f2:	506080e7          	jalr	1286(ra) # 8f4 <sleep>
      if(j != i){
 3f6:	fd842703          	lw	a4,-40(s0)
 3fa:	00002797          	auipc	a5,0x2
 3fe:	c167a783          	lw	a5,-1002(a5) # 2010 <buf>
 402:	02f70c63          	beq	a4,a5,43a <filetest+0x16e>
        printf("error: read the wrong value\n");
 406:	00001517          	auipc	a0,0x1
 40a:	a3a50513          	addi	a0,a0,-1478 # e40 <malloc+0x1a6>
 40e:	00000097          	auipc	ra,0x0
 412:	7ce080e7          	jalr	1998(ra) # bdc <printf>
        exit(1);
 416:	4505                	li	a0,1
 418:	00000097          	auipc	ra,0x0
 41c:	44c080e7          	jalr	1100(ra) # 864 <exit>
        printf("error: read failed\n");
 420:	00001517          	auipc	a0,0x1
 424:	a0850513          	addi	a0,a0,-1528 # e28 <malloc+0x18e>
 428:	00000097          	auipc	ra,0x0
 42c:	7b4080e7          	jalr	1972(ra) # bdc <printf>
        exit(1);
 430:	4505                	li	a0,1
 432:	00000097          	auipc	ra,0x0
 436:	432080e7          	jalr	1074(ra) # 864 <exit>
      exit(0);
 43a:	4501                	li	a0,0
 43c:	00000097          	auipc	ra,0x0
 440:	428080e7          	jalr	1064(ra) # 864 <exit>
      printf("error: write failed\n");
 444:	00001517          	auipc	a0,0x1
 448:	a1c50513          	addi	a0,a0,-1508 # e60 <malloc+0x1c6>
 44c:	00000097          	auipc	ra,0x0
 450:	790080e7          	jalr	1936(ra) # bdc <printf>
      exit(-1);
 454:	557d                	li	a0,-1
 456:	00000097          	auipc	ra,0x0
 45a:	40e080e7          	jalr	1038(ra) # 864 <exit>
      exit(1);
 45e:	4505                	li	a0,1
 460:	00000097          	auipc	ra,0x0
 464:	404080e7          	jalr	1028(ra) # 864 <exit>
    printf("error: child overwrote parent\n");
 468:	00001517          	auipc	a0,0x1
 46c:	a1050513          	addi	a0,a0,-1520 # e78 <malloc+0x1de>
 470:	00000097          	auipc	ra,0x0
 474:	76c080e7          	jalr	1900(ra) # bdc <printf>
    exit(1);
 478:	4505                	li	a0,1
 47a:	00000097          	auipc	ra,0x0
 47e:	3ea080e7          	jalr	1002(ra) # 864 <exit>

0000000000000482 <forkforktest>:
//
// try to expose races in page reference counting.
//
void
forkforktest()
{
 482:	7179                	addi	sp,sp,-48
 484:	f406                	sd	ra,40(sp)
 486:	f022                	sd	s0,32(sp)
 488:	ec26                	sd	s1,24(sp)
 48a:	e84a                	sd	s2,16(sp)
 48c:	1800                	addi	s0,sp,48
  printf("forkfork: ");
 48e:	00001517          	auipc	a0,0x1
 492:	a0a50513          	addi	a0,a0,-1526 # e98 <malloc+0x1fe>
 496:	00000097          	auipc	ra,0x0
 49a:	746080e7          	jalr	1862(ra) # bdc <printf>

  int sz = 256 * 4096;
  char *p = sbrk(sz);
 49e:	00100537          	lui	a0,0x100
 4a2:	00000097          	auipc	ra,0x0
 4a6:	44a080e7          	jalr	1098(ra) # 8ec <sbrk>
 4aa:	892a                	mv	s2,a0
  memset(p, 27, sz);
 4ac:	00100637          	lui	a2,0x100
 4b0:	45ed                	li	a1,27
 4b2:	00000097          	auipc	ra,0x0
 4b6:	1b6080e7          	jalr	438(ra) # 668 <memset>
 4ba:	06400493          	li	s1,100

  int children = 3;

  for(int iter = 0; iter < 100; iter++){
    for(int nc = 0; nc < children; nc++){
      if(fork() == 0){
 4be:	00000097          	auipc	ra,0x0
 4c2:	39e080e7          	jalr	926(ra) # 85c <fork>
 4c6:	cd3d                	beqz	a0,544 <forkforktest+0xc2>
 4c8:	00000097          	auipc	ra,0x0
 4cc:	394080e7          	jalr	916(ra) # 85c <fork>
 4d0:	c935                	beqz	a0,544 <forkforktest+0xc2>
 4d2:	00000097          	auipc	ra,0x0
 4d6:	38a080e7          	jalr	906(ra) # 85c <fork>
 4da:	c52d                	beqz	a0,544 <forkforktest+0xc2>
      }
    }

    for(int nc = 0; nc < children; nc++){
      int st;
      wait(&st);
 4dc:	fdc40513          	addi	a0,s0,-36
 4e0:	00000097          	auipc	ra,0x0
 4e4:	38c080e7          	jalr	908(ra) # 86c <wait>
 4e8:	fdc40513          	addi	a0,s0,-36
 4ec:	00000097          	auipc	ra,0x0
 4f0:	380080e7          	jalr	896(ra) # 86c <wait>
 4f4:	fdc40513          	addi	a0,s0,-36
 4f8:	00000097          	auipc	ra,0x0
 4fc:	374080e7          	jalr	884(ra) # 86c <wait>
  for(int iter = 0; iter < 100; iter++){
 500:	34fd                	addiw	s1,s1,-1
 502:	fcd5                	bnez	s1,4be <forkforktest+0x3c>
    }
  }

  sleep(5);
 504:	4515                	li	a0,5
 506:	00000097          	auipc	ra,0x0
 50a:	3ee080e7          	jalr	1006(ra) # 8f4 <sleep>
  for(int i = 0; i < sz; i += 4096){
 50e:	87ca                	mv	a5,s2
 510:	001006b7          	lui	a3,0x100
 514:	96ca                	add	a3,a3,s2
    if(p[i] != 27){
 516:	45ed                	li	a1,27
  for(int i = 0; i < sz; i += 4096){
 518:	6605                	lui	a2,0x1
    if(p[i] != 27){
 51a:	0007c703          	lbu	a4,0(a5)
 51e:	04b71563          	bne	a4,a1,568 <forkforktest+0xe6>
  for(int i = 0; i < sz; i += 4096){
 522:	97b2                	add	a5,a5,a2
 524:	fed79be3          	bne	a5,a3,51a <forkforktest+0x98>
      printf("error: parent's memory was modified!\n");
      exit(1);
    }
  }

  printf("ok\n");
 528:	00001517          	auipc	a0,0x1
 52c:	8a850513          	addi	a0,a0,-1880 # dd0 <malloc+0x136>
 530:	00000097          	auipc	ra,0x0
 534:	6ac080e7          	jalr	1708(ra) # bdc <printf>
}
 538:	70a2                	ld	ra,40(sp)
 53a:	7402                	ld	s0,32(sp)
 53c:	64e2                	ld	s1,24(sp)
 53e:	6942                	ld	s2,16(sp)
 540:	6145                	addi	sp,sp,48
 542:	8082                	ret
        sleep(2);
 544:	4509                	li	a0,2
 546:	00000097          	auipc	ra,0x0
 54a:	3ae080e7          	jalr	942(ra) # 8f4 <sleep>
        fork();
 54e:	00000097          	auipc	ra,0x0
 552:	30e080e7          	jalr	782(ra) # 85c <fork>
        fork();
 556:	00000097          	auipc	ra,0x0
 55a:	306080e7          	jalr	774(ra) # 85c <fork>
        exit(0);
 55e:	4501                	li	a0,0
 560:	00000097          	auipc	ra,0x0
 564:	304080e7          	jalr	772(ra) # 864 <exit>
      printf("error: parent's memory was modified!\n");
 568:	00001517          	auipc	a0,0x1
 56c:	94050513          	addi	a0,a0,-1728 # ea8 <malloc+0x20e>
 570:	00000097          	auipc	ra,0x0
 574:	66c080e7          	jalr	1644(ra) # bdc <printf>
      exit(1);
 578:	4505                	li	a0,1
 57a:	00000097          	auipc	ra,0x0
 57e:	2ea080e7          	jalr	746(ra) # 864 <exit>

0000000000000582 <main>:

int
main(int argc, char *argv[])
{
 582:	1141                	addi	sp,sp,-16
 584:	e406                	sd	ra,8(sp)
 586:	e022                	sd	s0,0(sp)
 588:	0800                	addi	s0,sp,16
  simpletest();
 58a:	00000097          	auipc	ra,0x0
 58e:	a76080e7          	jalr	-1418(ra) # 0 <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 592:	00000097          	auipc	ra,0x0
 596:	a6e080e7          	jalr	-1426(ra) # 0 <simpletest>

  threetest();
 59a:	00000097          	auipc	ra,0x0
 59e:	b66080e7          	jalr	-1178(ra) # 100 <threetest>
  threetest();
 5a2:	00000097          	auipc	ra,0x0
 5a6:	b5e080e7          	jalr	-1186(ra) # 100 <threetest>
  threetest();
 5aa:	00000097          	auipc	ra,0x0
 5ae:	b56080e7          	jalr	-1194(ra) # 100 <threetest>

  filetest();
 5b2:	00000097          	auipc	ra,0x0
 5b6:	d1a080e7          	jalr	-742(ra) # 2cc <filetest>

  forkforktest();
 5ba:	00000097          	auipc	ra,0x0
 5be:	ec8080e7          	jalr	-312(ra) # 482 <forkforktest>

  printf("ALL COW TESTS PASSED\n");
 5c2:	00001517          	auipc	a0,0x1
 5c6:	90e50513          	addi	a0,a0,-1778 # ed0 <malloc+0x236>
 5ca:	00000097          	auipc	ra,0x0
 5ce:	612080e7          	jalr	1554(ra) # bdc <printf>

  exit(0);
 5d2:	4501                	li	a0,0
 5d4:	00000097          	auipc	ra,0x0
 5d8:	290080e7          	jalr	656(ra) # 864 <exit>

00000000000005dc <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 5dc:	1141                	addi	sp,sp,-16
 5de:	e406                	sd	ra,8(sp)
 5e0:	e022                	sd	s0,0(sp)
 5e2:	0800                	addi	s0,sp,16
  extern int main();
  main();
 5e4:	00000097          	auipc	ra,0x0
 5e8:	f9e080e7          	jalr	-98(ra) # 582 <main>
  exit(0);
 5ec:	4501                	li	a0,0
 5ee:	00000097          	auipc	ra,0x0
 5f2:	276080e7          	jalr	630(ra) # 864 <exit>

00000000000005f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 5f6:	1141                	addi	sp,sp,-16
 5f8:	e422                	sd	s0,8(sp)
 5fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 5fc:	87aa                	mv	a5,a0
 5fe:	0585                	addi	a1,a1,1
 600:	0785                	addi	a5,a5,1
 602:	fff5c703          	lbu	a4,-1(a1)
 606:	fee78fa3          	sb	a4,-1(a5)
 60a:	fb75                	bnez	a4,5fe <strcpy+0x8>
    ;
  return os;
}
 60c:	6422                	ld	s0,8(sp)
 60e:	0141                	addi	sp,sp,16
 610:	8082                	ret

0000000000000612 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 612:	1141                	addi	sp,sp,-16
 614:	e422                	sd	s0,8(sp)
 616:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 618:	00054783          	lbu	a5,0(a0)
 61c:	cb91                	beqz	a5,630 <strcmp+0x1e>
 61e:	0005c703          	lbu	a4,0(a1)
 622:	00f71763          	bne	a4,a5,630 <strcmp+0x1e>
    p++, q++;
 626:	0505                	addi	a0,a0,1
 628:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 62a:	00054783          	lbu	a5,0(a0)
 62e:	fbe5                	bnez	a5,61e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 630:	0005c503          	lbu	a0,0(a1)
}
 634:	40a7853b          	subw	a0,a5,a0
 638:	6422                	ld	s0,8(sp)
 63a:	0141                	addi	sp,sp,16
 63c:	8082                	ret

000000000000063e <strlen>:

uint
strlen(const char *s)
{
 63e:	1141                	addi	sp,sp,-16
 640:	e422                	sd	s0,8(sp)
 642:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 644:	00054783          	lbu	a5,0(a0)
 648:	cf91                	beqz	a5,664 <strlen+0x26>
 64a:	0505                	addi	a0,a0,1
 64c:	87aa                	mv	a5,a0
 64e:	4685                	li	a3,1
 650:	9e89                	subw	a3,a3,a0
 652:	00f6853b          	addw	a0,a3,a5
 656:	0785                	addi	a5,a5,1
 658:	fff7c703          	lbu	a4,-1(a5)
 65c:	fb7d                	bnez	a4,652 <strlen+0x14>
    ;
  return n;
}
 65e:	6422                	ld	s0,8(sp)
 660:	0141                	addi	sp,sp,16
 662:	8082                	ret
  for(n = 0; s[n]; n++)
 664:	4501                	li	a0,0
 666:	bfe5                	j	65e <strlen+0x20>

0000000000000668 <memset>:

void*
memset(void *dst, int c, uint n)
{
 668:	1141                	addi	sp,sp,-16
 66a:	e422                	sd	s0,8(sp)
 66c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 66e:	ca19                	beqz	a2,684 <memset+0x1c>
 670:	87aa                	mv	a5,a0
 672:	1602                	slli	a2,a2,0x20
 674:	9201                	srli	a2,a2,0x20
 676:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 67a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 67e:	0785                	addi	a5,a5,1
 680:	fee79de3          	bne	a5,a4,67a <memset+0x12>
  }
  return dst;
}
 684:	6422                	ld	s0,8(sp)
 686:	0141                	addi	sp,sp,16
 688:	8082                	ret

000000000000068a <strchr>:

char*
strchr(const char *s, char c)
{
 68a:	1141                	addi	sp,sp,-16
 68c:	e422                	sd	s0,8(sp)
 68e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 690:	00054783          	lbu	a5,0(a0)
 694:	cb99                	beqz	a5,6aa <strchr+0x20>
    if(*s == c)
 696:	00f58763          	beq	a1,a5,6a4 <strchr+0x1a>
  for(; *s; s++)
 69a:	0505                	addi	a0,a0,1
 69c:	00054783          	lbu	a5,0(a0)
 6a0:	fbfd                	bnez	a5,696 <strchr+0xc>
      return (char*)s;
  return 0;
 6a2:	4501                	li	a0,0
}
 6a4:	6422                	ld	s0,8(sp)
 6a6:	0141                	addi	sp,sp,16
 6a8:	8082                	ret
  return 0;
 6aa:	4501                	li	a0,0
 6ac:	bfe5                	j	6a4 <strchr+0x1a>

00000000000006ae <gets>:

char*
gets(char *buf, int max)
{
 6ae:	711d                	addi	sp,sp,-96
 6b0:	ec86                	sd	ra,88(sp)
 6b2:	e8a2                	sd	s0,80(sp)
 6b4:	e4a6                	sd	s1,72(sp)
 6b6:	e0ca                	sd	s2,64(sp)
 6b8:	fc4e                	sd	s3,56(sp)
 6ba:	f852                	sd	s4,48(sp)
 6bc:	f456                	sd	s5,40(sp)
 6be:	f05a                	sd	s6,32(sp)
 6c0:	ec5e                	sd	s7,24(sp)
 6c2:	1080                	addi	s0,sp,96
 6c4:	8baa                	mv	s7,a0
 6c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6c8:	892a                	mv	s2,a0
 6ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 6cc:	4aa9                	li	s5,10
 6ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 6d0:	89a6                	mv	s3,s1
 6d2:	2485                	addiw	s1,s1,1
 6d4:	0344d863          	bge	s1,s4,704 <gets+0x56>
    cc = read(0, &c, 1);
 6d8:	4605                	li	a2,1
 6da:	faf40593          	addi	a1,s0,-81
 6de:	4501                	li	a0,0
 6e0:	00000097          	auipc	ra,0x0
 6e4:	19c080e7          	jalr	412(ra) # 87c <read>
    if(cc < 1)
 6e8:	00a05e63          	blez	a0,704 <gets+0x56>
    buf[i++] = c;
 6ec:	faf44783          	lbu	a5,-81(s0)
 6f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 6f4:	01578763          	beq	a5,s5,702 <gets+0x54>
 6f8:	0905                	addi	s2,s2,1
 6fa:	fd679be3          	bne	a5,s6,6d0 <gets+0x22>
  for(i=0; i+1 < max; ){
 6fe:	89a6                	mv	s3,s1
 700:	a011                	j	704 <gets+0x56>
 702:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 704:	99de                	add	s3,s3,s7
 706:	00098023          	sb	zero,0(s3) # 199a000 <base+0x1994ff0>
  return buf;
}
 70a:	855e                	mv	a0,s7
 70c:	60e6                	ld	ra,88(sp)
 70e:	6446                	ld	s0,80(sp)
 710:	64a6                	ld	s1,72(sp)
 712:	6906                	ld	s2,64(sp)
 714:	79e2                	ld	s3,56(sp)
 716:	7a42                	ld	s4,48(sp)
 718:	7aa2                	ld	s5,40(sp)
 71a:	7b02                	ld	s6,32(sp)
 71c:	6be2                	ld	s7,24(sp)
 71e:	6125                	addi	sp,sp,96
 720:	8082                	ret

0000000000000722 <stat>:

int
stat(const char *n, struct stat *st)
{
 722:	1101                	addi	sp,sp,-32
 724:	ec06                	sd	ra,24(sp)
 726:	e822                	sd	s0,16(sp)
 728:	e426                	sd	s1,8(sp)
 72a:	e04a                	sd	s2,0(sp)
 72c:	1000                	addi	s0,sp,32
 72e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 730:	4581                	li	a1,0
 732:	00000097          	auipc	ra,0x0
 736:	172080e7          	jalr	370(ra) # 8a4 <open>
  if(fd < 0)
 73a:	02054563          	bltz	a0,764 <stat+0x42>
 73e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 740:	85ca                	mv	a1,s2
 742:	00000097          	auipc	ra,0x0
 746:	17a080e7          	jalr	378(ra) # 8bc <fstat>
 74a:	892a                	mv	s2,a0
  close(fd);
 74c:	8526                	mv	a0,s1
 74e:	00000097          	auipc	ra,0x0
 752:	13e080e7          	jalr	318(ra) # 88c <close>
  return r;
}
 756:	854a                	mv	a0,s2
 758:	60e2                	ld	ra,24(sp)
 75a:	6442                	ld	s0,16(sp)
 75c:	64a2                	ld	s1,8(sp)
 75e:	6902                	ld	s2,0(sp)
 760:	6105                	addi	sp,sp,32
 762:	8082                	ret
    return -1;
 764:	597d                	li	s2,-1
 766:	bfc5                	j	756 <stat+0x34>

0000000000000768 <atoi>:

int
atoi(const char *s)
{
 768:	1141                	addi	sp,sp,-16
 76a:	e422                	sd	s0,8(sp)
 76c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 76e:	00054603          	lbu	a2,0(a0)
 772:	fd06079b          	addiw	a5,a2,-48
 776:	0ff7f793          	zext.b	a5,a5
 77a:	4725                	li	a4,9
 77c:	02f76963          	bltu	a4,a5,7ae <atoi+0x46>
 780:	86aa                	mv	a3,a0
  n = 0;
 782:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 784:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 786:	0685                	addi	a3,a3,1
 788:	0025179b          	slliw	a5,a0,0x2
 78c:	9fa9                	addw	a5,a5,a0
 78e:	0017979b          	slliw	a5,a5,0x1
 792:	9fb1                	addw	a5,a5,a2
 794:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 798:	0006c603          	lbu	a2,0(a3) # 100000 <base+0xfaff0>
 79c:	fd06071b          	addiw	a4,a2,-48
 7a0:	0ff77713          	zext.b	a4,a4
 7a4:	fee5f1e3          	bgeu	a1,a4,786 <atoi+0x1e>
  return n;
}
 7a8:	6422                	ld	s0,8(sp)
 7aa:	0141                	addi	sp,sp,16
 7ac:	8082                	ret
  n = 0;
 7ae:	4501                	li	a0,0
 7b0:	bfe5                	j	7a8 <atoi+0x40>

00000000000007b2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 7b2:	1141                	addi	sp,sp,-16
 7b4:	e422                	sd	s0,8(sp)
 7b6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 7b8:	02b57463          	bgeu	a0,a1,7e0 <memmove+0x2e>
    while(n-- > 0)
 7bc:	00c05f63          	blez	a2,7da <memmove+0x28>
 7c0:	1602                	slli	a2,a2,0x20
 7c2:	9201                	srli	a2,a2,0x20
 7c4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 7c8:	872a                	mv	a4,a0
      *dst++ = *src++;
 7ca:	0585                	addi	a1,a1,1
 7cc:	0705                	addi	a4,a4,1
 7ce:	fff5c683          	lbu	a3,-1(a1)
 7d2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 7d6:	fee79ae3          	bne	a5,a4,7ca <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 7da:	6422                	ld	s0,8(sp)
 7dc:	0141                	addi	sp,sp,16
 7de:	8082                	ret
    dst += n;
 7e0:	00c50733          	add	a4,a0,a2
    src += n;
 7e4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 7e6:	fec05ae3          	blez	a2,7da <memmove+0x28>
 7ea:	fff6079b          	addiw	a5,a2,-1
 7ee:	1782                	slli	a5,a5,0x20
 7f0:	9381                	srli	a5,a5,0x20
 7f2:	fff7c793          	not	a5,a5
 7f6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 7f8:	15fd                	addi	a1,a1,-1
 7fa:	177d                	addi	a4,a4,-1
 7fc:	0005c683          	lbu	a3,0(a1)
 800:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 804:	fee79ae3          	bne	a5,a4,7f8 <memmove+0x46>
 808:	bfc9                	j	7da <memmove+0x28>

000000000000080a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 80a:	1141                	addi	sp,sp,-16
 80c:	e422                	sd	s0,8(sp)
 80e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 810:	ca05                	beqz	a2,840 <memcmp+0x36>
 812:	fff6069b          	addiw	a3,a2,-1
 816:	1682                	slli	a3,a3,0x20
 818:	9281                	srli	a3,a3,0x20
 81a:	0685                	addi	a3,a3,1
 81c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 81e:	00054783          	lbu	a5,0(a0)
 822:	0005c703          	lbu	a4,0(a1)
 826:	00e79863          	bne	a5,a4,836 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 82a:	0505                	addi	a0,a0,1
    p2++;
 82c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 82e:	fed518e3          	bne	a0,a3,81e <memcmp+0x14>
  }
  return 0;
 832:	4501                	li	a0,0
 834:	a019                	j	83a <memcmp+0x30>
      return *p1 - *p2;
 836:	40e7853b          	subw	a0,a5,a4
}
 83a:	6422                	ld	s0,8(sp)
 83c:	0141                	addi	sp,sp,16
 83e:	8082                	ret
  return 0;
 840:	4501                	li	a0,0
 842:	bfe5                	j	83a <memcmp+0x30>

0000000000000844 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 844:	1141                	addi	sp,sp,-16
 846:	e406                	sd	ra,8(sp)
 848:	e022                	sd	s0,0(sp)
 84a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 84c:	00000097          	auipc	ra,0x0
 850:	f66080e7          	jalr	-154(ra) # 7b2 <memmove>
}
 854:	60a2                	ld	ra,8(sp)
 856:	6402                	ld	s0,0(sp)
 858:	0141                	addi	sp,sp,16
 85a:	8082                	ret

000000000000085c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 85c:	4885                	li	a7,1
 ecall
 85e:	00000073          	ecall
 ret
 862:	8082                	ret

0000000000000864 <exit>:
.global exit
exit:
 li a7, SYS_exit
 864:	4889                	li	a7,2
 ecall
 866:	00000073          	ecall
 ret
 86a:	8082                	ret

000000000000086c <wait>:
.global wait
wait:
 li a7, SYS_wait
 86c:	488d                	li	a7,3
 ecall
 86e:	00000073          	ecall
 ret
 872:	8082                	ret

0000000000000874 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 874:	4891                	li	a7,4
 ecall
 876:	00000073          	ecall
 ret
 87a:	8082                	ret

000000000000087c <read>:
.global read
read:
 li a7, SYS_read
 87c:	4895                	li	a7,5
 ecall
 87e:	00000073          	ecall
 ret
 882:	8082                	ret

0000000000000884 <write>:
.global write
write:
 li a7, SYS_write
 884:	48c1                	li	a7,16
 ecall
 886:	00000073          	ecall
 ret
 88a:	8082                	ret

000000000000088c <close>:
.global close
close:
 li a7, SYS_close
 88c:	48d5                	li	a7,21
 ecall
 88e:	00000073          	ecall
 ret
 892:	8082                	ret

0000000000000894 <kill>:
.global kill
kill:
 li a7, SYS_kill
 894:	4899                	li	a7,6
 ecall
 896:	00000073          	ecall
 ret
 89a:	8082                	ret

000000000000089c <exec>:
.global exec
exec:
 li a7, SYS_exec
 89c:	489d                	li	a7,7
 ecall
 89e:	00000073          	ecall
 ret
 8a2:	8082                	ret

00000000000008a4 <open>:
.global open
open:
 li a7, SYS_open
 8a4:	48bd                	li	a7,15
 ecall
 8a6:	00000073          	ecall
 ret
 8aa:	8082                	ret

00000000000008ac <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 8ac:	48c5                	li	a7,17
 ecall
 8ae:	00000073          	ecall
 ret
 8b2:	8082                	ret

00000000000008b4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 8b4:	48c9                	li	a7,18
 ecall
 8b6:	00000073          	ecall
 ret
 8ba:	8082                	ret

00000000000008bc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 8bc:	48a1                	li	a7,8
 ecall
 8be:	00000073          	ecall
 ret
 8c2:	8082                	ret

00000000000008c4 <link>:
.global link
link:
 li a7, SYS_link
 8c4:	48cd                	li	a7,19
 ecall
 8c6:	00000073          	ecall
 ret
 8ca:	8082                	ret

00000000000008cc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 8cc:	48d1                	li	a7,20
 ecall
 8ce:	00000073          	ecall
 ret
 8d2:	8082                	ret

00000000000008d4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 8d4:	48a5                	li	a7,9
 ecall
 8d6:	00000073          	ecall
 ret
 8da:	8082                	ret

00000000000008dc <dup>:
.global dup
dup:
 li a7, SYS_dup
 8dc:	48a9                	li	a7,10
 ecall
 8de:	00000073          	ecall
 ret
 8e2:	8082                	ret

00000000000008e4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 8e4:	48ad                	li	a7,11
 ecall
 8e6:	00000073          	ecall
 ret
 8ea:	8082                	ret

00000000000008ec <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 8ec:	48b1                	li	a7,12
 ecall
 8ee:	00000073          	ecall
 ret
 8f2:	8082                	ret

00000000000008f4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 8f4:	48b5                	li	a7,13
 ecall
 8f6:	00000073          	ecall
 ret
 8fa:	8082                	ret

00000000000008fc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 8fc:	48b9                	li	a7,14
 ecall
 8fe:	00000073          	ecall
 ret
 902:	8082                	ret

0000000000000904 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 904:	1101                	addi	sp,sp,-32
 906:	ec06                	sd	ra,24(sp)
 908:	e822                	sd	s0,16(sp)
 90a:	1000                	addi	s0,sp,32
 90c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 910:	4605                	li	a2,1
 912:	fef40593          	addi	a1,s0,-17
 916:	00000097          	auipc	ra,0x0
 91a:	f6e080e7          	jalr	-146(ra) # 884 <write>
}
 91e:	60e2                	ld	ra,24(sp)
 920:	6442                	ld	s0,16(sp)
 922:	6105                	addi	sp,sp,32
 924:	8082                	ret

0000000000000926 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 926:	7139                	addi	sp,sp,-64
 928:	fc06                	sd	ra,56(sp)
 92a:	f822                	sd	s0,48(sp)
 92c:	f426                	sd	s1,40(sp)
 92e:	f04a                	sd	s2,32(sp)
 930:	ec4e                	sd	s3,24(sp)
 932:	0080                	addi	s0,sp,64
 934:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 936:	c299                	beqz	a3,93c <printint+0x16>
 938:	0805c863          	bltz	a1,9c8 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 93c:	2581                	sext.w	a1,a1
  neg = 0;
 93e:	4881                	li	a7,0
 940:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 944:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 946:	2601                	sext.w	a2,a2
 948:	00000517          	auipc	a0,0x0
 94c:	5a850513          	addi	a0,a0,1448 # ef0 <digits>
 950:	883a                	mv	a6,a4
 952:	2705                	addiw	a4,a4,1
 954:	02c5f7bb          	remuw	a5,a1,a2
 958:	1782                	slli	a5,a5,0x20
 95a:	9381                	srli	a5,a5,0x20
 95c:	97aa                	add	a5,a5,a0
 95e:	0007c783          	lbu	a5,0(a5)
 962:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 966:	0005879b          	sext.w	a5,a1
 96a:	02c5d5bb          	divuw	a1,a1,a2
 96e:	0685                	addi	a3,a3,1
 970:	fec7f0e3          	bgeu	a5,a2,950 <printint+0x2a>
  if(neg)
 974:	00088b63          	beqz	a7,98a <printint+0x64>
    buf[i++] = '-';
 978:	fd040793          	addi	a5,s0,-48
 97c:	973e                	add	a4,a4,a5
 97e:	02d00793          	li	a5,45
 982:	fef70823          	sb	a5,-16(a4)
 986:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 98a:	02e05863          	blez	a4,9ba <printint+0x94>
 98e:	fc040793          	addi	a5,s0,-64
 992:	00e78933          	add	s2,a5,a4
 996:	fff78993          	addi	s3,a5,-1
 99a:	99ba                	add	s3,s3,a4
 99c:	377d                	addiw	a4,a4,-1
 99e:	1702                	slli	a4,a4,0x20
 9a0:	9301                	srli	a4,a4,0x20
 9a2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 9a6:	fff94583          	lbu	a1,-1(s2)
 9aa:	8526                	mv	a0,s1
 9ac:	00000097          	auipc	ra,0x0
 9b0:	f58080e7          	jalr	-168(ra) # 904 <putc>
  while(--i >= 0)
 9b4:	197d                	addi	s2,s2,-1
 9b6:	ff3918e3          	bne	s2,s3,9a6 <printint+0x80>
}
 9ba:	70e2                	ld	ra,56(sp)
 9bc:	7442                	ld	s0,48(sp)
 9be:	74a2                	ld	s1,40(sp)
 9c0:	7902                	ld	s2,32(sp)
 9c2:	69e2                	ld	s3,24(sp)
 9c4:	6121                	addi	sp,sp,64
 9c6:	8082                	ret
    x = -xx;
 9c8:	40b005bb          	negw	a1,a1
    neg = 1;
 9cc:	4885                	li	a7,1
    x = -xx;
 9ce:	bf8d                	j	940 <printint+0x1a>

00000000000009d0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 9d0:	7119                	addi	sp,sp,-128
 9d2:	fc86                	sd	ra,120(sp)
 9d4:	f8a2                	sd	s0,112(sp)
 9d6:	f4a6                	sd	s1,104(sp)
 9d8:	f0ca                	sd	s2,96(sp)
 9da:	ecce                	sd	s3,88(sp)
 9dc:	e8d2                	sd	s4,80(sp)
 9de:	e4d6                	sd	s5,72(sp)
 9e0:	e0da                	sd	s6,64(sp)
 9e2:	fc5e                	sd	s7,56(sp)
 9e4:	f862                	sd	s8,48(sp)
 9e6:	f466                	sd	s9,40(sp)
 9e8:	f06a                	sd	s10,32(sp)
 9ea:	ec6e                	sd	s11,24(sp)
 9ec:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 9ee:	0005c903          	lbu	s2,0(a1)
 9f2:	18090f63          	beqz	s2,b90 <vprintf+0x1c0>
 9f6:	8aaa                	mv	s5,a0
 9f8:	8b32                	mv	s6,a2
 9fa:	00158493          	addi	s1,a1,1
  state = 0;
 9fe:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 a00:	02500a13          	li	s4,37
      if(c == 'd'){
 a04:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 a08:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 a0c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 a10:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a14:	00000b97          	auipc	s7,0x0
 a18:	4dcb8b93          	addi	s7,s7,1244 # ef0 <digits>
 a1c:	a839                	j	a3a <vprintf+0x6a>
        putc(fd, c);
 a1e:	85ca                	mv	a1,s2
 a20:	8556                	mv	a0,s5
 a22:	00000097          	auipc	ra,0x0
 a26:	ee2080e7          	jalr	-286(ra) # 904 <putc>
 a2a:	a019                	j	a30 <vprintf+0x60>
    } else if(state == '%'){
 a2c:	01498f63          	beq	s3,s4,a4a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 a30:	0485                	addi	s1,s1,1
 a32:	fff4c903          	lbu	s2,-1(s1)
 a36:	14090d63          	beqz	s2,b90 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 a3a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 a3e:	fe0997e3          	bnez	s3,a2c <vprintf+0x5c>
      if(c == '%'){
 a42:	fd479ee3          	bne	a5,s4,a1e <vprintf+0x4e>
        state = '%';
 a46:	89be                	mv	s3,a5
 a48:	b7e5                	j	a30 <vprintf+0x60>
      if(c == 'd'){
 a4a:	05878063          	beq	a5,s8,a8a <vprintf+0xba>
      } else if(c == 'l') {
 a4e:	05978c63          	beq	a5,s9,aa6 <vprintf+0xd6>
      } else if(c == 'x') {
 a52:	07a78863          	beq	a5,s10,ac2 <vprintf+0xf2>
      } else if(c == 'p') {
 a56:	09b78463          	beq	a5,s11,ade <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 a5a:	07300713          	li	a4,115
 a5e:	0ce78663          	beq	a5,a4,b2a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 a62:	06300713          	li	a4,99
 a66:	0ee78e63          	beq	a5,a4,b62 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 a6a:	11478863          	beq	a5,s4,b7a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a6e:	85d2                	mv	a1,s4
 a70:	8556                	mv	a0,s5
 a72:	00000097          	auipc	ra,0x0
 a76:	e92080e7          	jalr	-366(ra) # 904 <putc>
        putc(fd, c);
 a7a:	85ca                	mv	a1,s2
 a7c:	8556                	mv	a0,s5
 a7e:	00000097          	auipc	ra,0x0
 a82:	e86080e7          	jalr	-378(ra) # 904 <putc>
      }
      state = 0;
 a86:	4981                	li	s3,0
 a88:	b765                	j	a30 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 a8a:	008b0913          	addi	s2,s6,8
 a8e:	4685                	li	a3,1
 a90:	4629                	li	a2,10
 a92:	000b2583          	lw	a1,0(s6)
 a96:	8556                	mv	a0,s5
 a98:	00000097          	auipc	ra,0x0
 a9c:	e8e080e7          	jalr	-370(ra) # 926 <printint>
 aa0:	8b4a                	mv	s6,s2
      state = 0;
 aa2:	4981                	li	s3,0
 aa4:	b771                	j	a30 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 aa6:	008b0913          	addi	s2,s6,8
 aaa:	4681                	li	a3,0
 aac:	4629                	li	a2,10
 aae:	000b2583          	lw	a1,0(s6)
 ab2:	8556                	mv	a0,s5
 ab4:	00000097          	auipc	ra,0x0
 ab8:	e72080e7          	jalr	-398(ra) # 926 <printint>
 abc:	8b4a                	mv	s6,s2
      state = 0;
 abe:	4981                	li	s3,0
 ac0:	bf85                	j	a30 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 ac2:	008b0913          	addi	s2,s6,8
 ac6:	4681                	li	a3,0
 ac8:	4641                	li	a2,16
 aca:	000b2583          	lw	a1,0(s6)
 ace:	8556                	mv	a0,s5
 ad0:	00000097          	auipc	ra,0x0
 ad4:	e56080e7          	jalr	-426(ra) # 926 <printint>
 ad8:	8b4a                	mv	s6,s2
      state = 0;
 ada:	4981                	li	s3,0
 adc:	bf91                	j	a30 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 ade:	008b0793          	addi	a5,s6,8
 ae2:	f8f43423          	sd	a5,-120(s0)
 ae6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 aea:	03000593          	li	a1,48
 aee:	8556                	mv	a0,s5
 af0:	00000097          	auipc	ra,0x0
 af4:	e14080e7          	jalr	-492(ra) # 904 <putc>
  putc(fd, 'x');
 af8:	85ea                	mv	a1,s10
 afa:	8556                	mv	a0,s5
 afc:	00000097          	auipc	ra,0x0
 b00:	e08080e7          	jalr	-504(ra) # 904 <putc>
 b04:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b06:	03c9d793          	srli	a5,s3,0x3c
 b0a:	97de                	add	a5,a5,s7
 b0c:	0007c583          	lbu	a1,0(a5)
 b10:	8556                	mv	a0,s5
 b12:	00000097          	auipc	ra,0x0
 b16:	df2080e7          	jalr	-526(ra) # 904 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b1a:	0992                	slli	s3,s3,0x4
 b1c:	397d                	addiw	s2,s2,-1
 b1e:	fe0914e3          	bnez	s2,b06 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 b22:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 b26:	4981                	li	s3,0
 b28:	b721                	j	a30 <vprintf+0x60>
        s = va_arg(ap, char*);
 b2a:	008b0993          	addi	s3,s6,8
 b2e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 b32:	02090163          	beqz	s2,b54 <vprintf+0x184>
        while(*s != 0){
 b36:	00094583          	lbu	a1,0(s2)
 b3a:	c9a1                	beqz	a1,b8a <vprintf+0x1ba>
          putc(fd, *s);
 b3c:	8556                	mv	a0,s5
 b3e:	00000097          	auipc	ra,0x0
 b42:	dc6080e7          	jalr	-570(ra) # 904 <putc>
          s++;
 b46:	0905                	addi	s2,s2,1
        while(*s != 0){
 b48:	00094583          	lbu	a1,0(s2)
 b4c:	f9e5                	bnez	a1,b3c <vprintf+0x16c>
        s = va_arg(ap, char*);
 b4e:	8b4e                	mv	s6,s3
      state = 0;
 b50:	4981                	li	s3,0
 b52:	bdf9                	j	a30 <vprintf+0x60>
          s = "(null)";
 b54:	00000917          	auipc	s2,0x0
 b58:	39490913          	addi	s2,s2,916 # ee8 <malloc+0x24e>
        while(*s != 0){
 b5c:	02800593          	li	a1,40
 b60:	bff1                	j	b3c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 b62:	008b0913          	addi	s2,s6,8
 b66:	000b4583          	lbu	a1,0(s6)
 b6a:	8556                	mv	a0,s5
 b6c:	00000097          	auipc	ra,0x0
 b70:	d98080e7          	jalr	-616(ra) # 904 <putc>
 b74:	8b4a                	mv	s6,s2
      state = 0;
 b76:	4981                	li	s3,0
 b78:	bd65                	j	a30 <vprintf+0x60>
        putc(fd, c);
 b7a:	85d2                	mv	a1,s4
 b7c:	8556                	mv	a0,s5
 b7e:	00000097          	auipc	ra,0x0
 b82:	d86080e7          	jalr	-634(ra) # 904 <putc>
      state = 0;
 b86:	4981                	li	s3,0
 b88:	b565                	j	a30 <vprintf+0x60>
        s = va_arg(ap, char*);
 b8a:	8b4e                	mv	s6,s3
      state = 0;
 b8c:	4981                	li	s3,0
 b8e:	b54d                	j	a30 <vprintf+0x60>
    }
  }
}
 b90:	70e6                	ld	ra,120(sp)
 b92:	7446                	ld	s0,112(sp)
 b94:	74a6                	ld	s1,104(sp)
 b96:	7906                	ld	s2,96(sp)
 b98:	69e6                	ld	s3,88(sp)
 b9a:	6a46                	ld	s4,80(sp)
 b9c:	6aa6                	ld	s5,72(sp)
 b9e:	6b06                	ld	s6,64(sp)
 ba0:	7be2                	ld	s7,56(sp)
 ba2:	7c42                	ld	s8,48(sp)
 ba4:	7ca2                	ld	s9,40(sp)
 ba6:	7d02                	ld	s10,32(sp)
 ba8:	6de2                	ld	s11,24(sp)
 baa:	6109                	addi	sp,sp,128
 bac:	8082                	ret

0000000000000bae <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 bae:	715d                	addi	sp,sp,-80
 bb0:	ec06                	sd	ra,24(sp)
 bb2:	e822                	sd	s0,16(sp)
 bb4:	1000                	addi	s0,sp,32
 bb6:	e010                	sd	a2,0(s0)
 bb8:	e414                	sd	a3,8(s0)
 bba:	e818                	sd	a4,16(s0)
 bbc:	ec1c                	sd	a5,24(s0)
 bbe:	03043023          	sd	a6,32(s0)
 bc2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 bc6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 bca:	8622                	mv	a2,s0
 bcc:	00000097          	auipc	ra,0x0
 bd0:	e04080e7          	jalr	-508(ra) # 9d0 <vprintf>
}
 bd4:	60e2                	ld	ra,24(sp)
 bd6:	6442                	ld	s0,16(sp)
 bd8:	6161                	addi	sp,sp,80
 bda:	8082                	ret

0000000000000bdc <printf>:

void
printf(const char *fmt, ...)
{
 bdc:	711d                	addi	sp,sp,-96
 bde:	ec06                	sd	ra,24(sp)
 be0:	e822                	sd	s0,16(sp)
 be2:	1000                	addi	s0,sp,32
 be4:	e40c                	sd	a1,8(s0)
 be6:	e810                	sd	a2,16(s0)
 be8:	ec14                	sd	a3,24(s0)
 bea:	f018                	sd	a4,32(s0)
 bec:	f41c                	sd	a5,40(s0)
 bee:	03043823          	sd	a6,48(s0)
 bf2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 bf6:	00840613          	addi	a2,s0,8
 bfa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 bfe:	85aa                	mv	a1,a0
 c00:	4505                	li	a0,1
 c02:	00000097          	auipc	ra,0x0
 c06:	dce080e7          	jalr	-562(ra) # 9d0 <vprintf>
}
 c0a:	60e2                	ld	ra,24(sp)
 c0c:	6442                	ld	s0,16(sp)
 c0e:	6125                	addi	sp,sp,96
 c10:	8082                	ret

0000000000000c12 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c12:	1141                	addi	sp,sp,-16
 c14:	e422                	sd	s0,8(sp)
 c16:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c18:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c1c:	00000797          	auipc	a5,0x0
 c20:	3ec7b783          	ld	a5,1004(a5) # 1008 <freep>
 c24:	a805                	j	c54 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c26:	4618                	lw	a4,8(a2)
 c28:	9db9                	addw	a1,a1,a4
 c2a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c2e:	6398                	ld	a4,0(a5)
 c30:	6318                	ld	a4,0(a4)
 c32:	fee53823          	sd	a4,-16(a0)
 c36:	a091                	j	c7a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c38:	ff852703          	lw	a4,-8(a0)
 c3c:	9e39                	addw	a2,a2,a4
 c3e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 c40:	ff053703          	ld	a4,-16(a0)
 c44:	e398                	sd	a4,0(a5)
 c46:	a099                	j	c8c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c48:	6398                	ld	a4,0(a5)
 c4a:	00e7e463          	bltu	a5,a4,c52 <free+0x40>
 c4e:	00e6ea63          	bltu	a3,a4,c62 <free+0x50>
{
 c52:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c54:	fed7fae3          	bgeu	a5,a3,c48 <free+0x36>
 c58:	6398                	ld	a4,0(a5)
 c5a:	00e6e463          	bltu	a3,a4,c62 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c5e:	fee7eae3          	bltu	a5,a4,c52 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 c62:	ff852583          	lw	a1,-8(a0)
 c66:	6390                	ld	a2,0(a5)
 c68:	02059813          	slli	a6,a1,0x20
 c6c:	01c85713          	srli	a4,a6,0x1c
 c70:	9736                	add	a4,a4,a3
 c72:	fae60ae3          	beq	a2,a4,c26 <free+0x14>
    bp->s.ptr = p->s.ptr;
 c76:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c7a:	4790                	lw	a2,8(a5)
 c7c:	02061593          	slli	a1,a2,0x20
 c80:	01c5d713          	srli	a4,a1,0x1c
 c84:	973e                	add	a4,a4,a5
 c86:	fae689e3          	beq	a3,a4,c38 <free+0x26>
  } else
    p->s.ptr = bp;
 c8a:	e394                	sd	a3,0(a5)
  freep = p;
 c8c:	00000717          	auipc	a4,0x0
 c90:	36f73e23          	sd	a5,892(a4) # 1008 <freep>
}
 c94:	6422                	ld	s0,8(sp)
 c96:	0141                	addi	sp,sp,16
 c98:	8082                	ret

0000000000000c9a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c9a:	7139                	addi	sp,sp,-64
 c9c:	fc06                	sd	ra,56(sp)
 c9e:	f822                	sd	s0,48(sp)
 ca0:	f426                	sd	s1,40(sp)
 ca2:	f04a                	sd	s2,32(sp)
 ca4:	ec4e                	sd	s3,24(sp)
 ca6:	e852                	sd	s4,16(sp)
 ca8:	e456                	sd	s5,8(sp)
 caa:	e05a                	sd	s6,0(sp)
 cac:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cae:	02051493          	slli	s1,a0,0x20
 cb2:	9081                	srli	s1,s1,0x20
 cb4:	04bd                	addi	s1,s1,15
 cb6:	8091                	srli	s1,s1,0x4
 cb8:	0014899b          	addiw	s3,s1,1
 cbc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 cbe:	00000517          	auipc	a0,0x0
 cc2:	34a53503          	ld	a0,842(a0) # 1008 <freep>
 cc6:	c515                	beqz	a0,cf2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cc8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cca:	4798                	lw	a4,8(a5)
 ccc:	02977f63          	bgeu	a4,s1,d0a <malloc+0x70>
 cd0:	8a4e                	mv	s4,s3
 cd2:	0009871b          	sext.w	a4,s3
 cd6:	6685                	lui	a3,0x1
 cd8:	00d77363          	bgeu	a4,a3,cde <malloc+0x44>
 cdc:	6a05                	lui	s4,0x1
 cde:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ce2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ce6:	00000917          	auipc	s2,0x0
 cea:	32290913          	addi	s2,s2,802 # 1008 <freep>
  if(p == (char*)-1)
 cee:	5afd                	li	s5,-1
 cf0:	a895                	j	d64 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 cf2:	00004797          	auipc	a5,0x4
 cf6:	31e78793          	addi	a5,a5,798 # 5010 <base>
 cfa:	00000717          	auipc	a4,0x0
 cfe:	30f73723          	sd	a5,782(a4) # 1008 <freep>
 d02:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 d04:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 d08:	b7e1                	j	cd0 <malloc+0x36>
      if(p->s.size == nunits)
 d0a:	02e48c63          	beq	s1,a4,d42 <malloc+0xa8>
        p->s.size -= nunits;
 d0e:	4137073b          	subw	a4,a4,s3
 d12:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d14:	02071693          	slli	a3,a4,0x20
 d18:	01c6d713          	srli	a4,a3,0x1c
 d1c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d1e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d22:	00000717          	auipc	a4,0x0
 d26:	2ea73323          	sd	a0,742(a4) # 1008 <freep>
      return (void*)(p + 1);
 d2a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 d2e:	70e2                	ld	ra,56(sp)
 d30:	7442                	ld	s0,48(sp)
 d32:	74a2                	ld	s1,40(sp)
 d34:	7902                	ld	s2,32(sp)
 d36:	69e2                	ld	s3,24(sp)
 d38:	6a42                	ld	s4,16(sp)
 d3a:	6aa2                	ld	s5,8(sp)
 d3c:	6b02                	ld	s6,0(sp)
 d3e:	6121                	addi	sp,sp,64
 d40:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 d42:	6398                	ld	a4,0(a5)
 d44:	e118                	sd	a4,0(a0)
 d46:	bff1                	j	d22 <malloc+0x88>
  hp->s.size = nu;
 d48:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d4c:	0541                	addi	a0,a0,16
 d4e:	00000097          	auipc	ra,0x0
 d52:	ec4080e7          	jalr	-316(ra) # c12 <free>
  return freep;
 d56:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d5a:	d971                	beqz	a0,d2e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d5c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d5e:	4798                	lw	a4,8(a5)
 d60:	fa9775e3          	bgeu	a4,s1,d0a <malloc+0x70>
    if(p == freep)
 d64:	00093703          	ld	a4,0(s2)
 d68:	853e                	mv	a0,a5
 d6a:	fef719e3          	bne	a4,a5,d5c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 d6e:	8552                	mv	a0,s4
 d70:	00000097          	auipc	ra,0x0
 d74:	b7c080e7          	jalr	-1156(ra) # 8ec <sbrk>
  if(p == (char*)-1)
 d78:	fd5518e3          	bne	a0,s5,d48 <malloc+0xae>
        return 0;
 d7c:	4501                	li	a0,0
 d7e:	bf45                	j	d2e <malloc+0x94>
