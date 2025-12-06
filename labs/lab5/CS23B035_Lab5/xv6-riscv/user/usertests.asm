
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	c24080e7          	jalr	-988(ra) # 5c34 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	c12080e7          	jalr	-1006(ra) # 5c34 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	0f250513          	addi	a0,a0,242 # 6130 <malloc+0x106>
      46:	00006097          	auipc	ra,0x6
      4a:	f26080e7          	jalr	-218(ra) # 5f6c <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	ba4080e7          	jalr	-1116(ra) # 5bf4 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	addi	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	addi	a3,a3,-1000 # cc78 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	0d050513          	addi	a0,a0,208 # 6150 <malloc+0x126>
      88:	00006097          	auipc	ra,0x6
      8c:	ee4080e7          	jalr	-284(ra) # 5f6c <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b62080e7          	jalr	-1182(ra) # 5bf4 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	0c050513          	addi	a0,a0,192 # 6168 <malloc+0x13e>
      b0:	00006097          	auipc	ra,0x6
      b4:	b84080e7          	jalr	-1148(ra) # 5c34 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b60080e7          	jalr	-1184(ra) # 5c1c <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	0c250513          	addi	a0,a0,194 # 6188 <malloc+0x15e>
      ce:	00006097          	auipc	ra,0x6
      d2:	b66080e7          	jalr	-1178(ra) # 5c34 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	08a50513          	addi	a0,a0,138 # 6170 <malloc+0x146>
      ee:	00006097          	auipc	ra,0x6
      f2:	e7e080e7          	jalr	-386(ra) # 5f6c <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	afc080e7          	jalr	-1284(ra) # 5bf4 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	09650513          	addi	a0,a0,150 # 6198 <malloc+0x16e>
     10a:	00006097          	auipc	ra,0x6
     10e:	e62080e7          	jalr	-414(ra) # 5f6c <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	ae0080e7          	jalr	-1312(ra) # 5bf4 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	09450513          	addi	a0,a0,148 # 61c0 <malloc+0x196>
     134:	00006097          	auipc	ra,0x6
     138:	b10080e7          	jalr	-1264(ra) # 5c44 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	08050513          	addi	a0,a0,128 # 61c0 <malloc+0x196>
     148:	00006097          	auipc	ra,0x6
     14c:	aec080e7          	jalr	-1300(ra) # 5c34 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	07c58593          	addi	a1,a1,124 # 61d0 <malloc+0x1a6>
     15c:	00006097          	auipc	ra,0x6
     160:	ab8080e7          	jalr	-1352(ra) # 5c14 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	05850513          	addi	a0,a0,88 # 61c0 <malloc+0x196>
     170:	00006097          	auipc	ra,0x6
     174:	ac4080e7          	jalr	-1340(ra) # 5c34 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	05c58593          	addi	a1,a1,92 # 61d8 <malloc+0x1ae>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a8e080e7          	jalr	-1394(ra) # 5c14 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	02c50513          	addi	a0,a0,44 # 61c0 <malloc+0x196>
     19c:	00006097          	auipc	ra,0x6
     1a0:	aa8080e7          	jalr	-1368(ra) # 5c44 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a76080e7          	jalr	-1418(ra) # 5c1c <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a6c080e7          	jalr	-1428(ra) # 5c1c <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	01650513          	addi	a0,a0,22 # 61e0 <malloc+0x1b6>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	d9a080e7          	jalr	-614(ra) # 5f6c <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	a18080e7          	jalr	-1512(ra) # 5bf4 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	a24080e7          	jalr	-1500(ra) # 5c34 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	a04080e7          	jalr	-1532(ra) # 5c1c <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	9fe080e7          	jalr	-1538(ra) # 5c44 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f8c50513          	addi	a0,a0,-116 # 6208 <malloc+0x1de>
     284:	00006097          	auipc	ra,0x6
     288:	9c0080e7          	jalr	-1600(ra) # 5c44 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f78a8a93          	addi	s5,s5,-136 # 6208 <malloc+0x1de>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	addi	s4,s4,-1568 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourteen+0x19d>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	988080e7          	jalr	-1656(ra) # 5c34 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	956080e7          	jalr	-1706(ra) # 5c14 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	942080e7          	jalr	-1726(ra) # 5c14 <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	93c080e7          	jalr	-1732(ra) # 5c1c <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	95a080e7          	jalr	-1702(ra) # 5c44 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	f0650513          	addi	a0,a0,-250 # 6218 <malloc+0x1ee>
     31a:	00006097          	auipc	ra,0x6
     31e:	c52080e7          	jalr	-942(ra) # 5f6c <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	8d0080e7          	jalr	-1840(ra) # 5bf4 <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	f0250513          	addi	a0,a0,-254 # 6238 <malloc+0x20e>
     33e:	00006097          	auipc	ra,0x6
     342:	c2e080e7          	jalr	-978(ra) # 5f6c <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00006097          	auipc	ra,0x6
     34c:	8ac080e7          	jalr	-1876(ra) # 5bf4 <exit>

0000000000000350 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     350:	7179                	addi	sp,sp,-48
     352:	f406                	sd	ra,40(sp)
     354:	f022                	sd	s0,32(sp)
     356:	ec26                	sd	s1,24(sp)
     358:	e84a                	sd	s2,16(sp)
     35a:	e44e                	sd	s3,8(sp)
     35c:	e052                	sd	s4,0(sp)
     35e:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     360:	00006517          	auipc	a0,0x6
     364:	ef050513          	addi	a0,a0,-272 # 6250 <malloc+0x226>
     368:	00006097          	auipc	ra,0x6
     36c:	8dc080e7          	jalr	-1828(ra) # 5c44 <unlink>
     370:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     374:	00006997          	auipc	s3,0x6
     378:	edc98993          	addi	s3,s3,-292 # 6250 <malloc+0x226>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37c:	5a7d                	li	s4,-1
     37e:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     382:	20100593          	li	a1,513
     386:	854e                	mv	a0,s3
     388:	00006097          	auipc	ra,0x6
     38c:	8ac080e7          	jalr	-1876(ra) # 5c34 <open>
     390:	84aa                	mv	s1,a0
    if(fd < 0){
     392:	06054b63          	bltz	a0,408 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     396:	4605                	li	a2,1
     398:	85d2                	mv	a1,s4
     39a:	00006097          	auipc	ra,0x6
     39e:	87a080e7          	jalr	-1926(ra) # 5c14 <write>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00006097          	auipc	ra,0x6
     3a8:	878080e7          	jalr	-1928(ra) # 5c1c <close>
    unlink("junk");
     3ac:	854e                	mv	a0,s3
     3ae:	00006097          	auipc	ra,0x6
     3b2:	896080e7          	jalr	-1898(ra) # 5c44 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b6:	397d                	addiw	s2,s2,-1
     3b8:	fc0915e3          	bnez	s2,382 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3bc:	20100593          	li	a1,513
     3c0:	00006517          	auipc	a0,0x6
     3c4:	e9050513          	addi	a0,a0,-368 # 6250 <malloc+0x226>
     3c8:	00006097          	auipc	ra,0x6
     3cc:	86c080e7          	jalr	-1940(ra) # 5c34 <open>
     3d0:	84aa                	mv	s1,a0
  if(fd < 0){
     3d2:	04054863          	bltz	a0,422 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d6:	4605                	li	a2,1
     3d8:	00006597          	auipc	a1,0x6
     3dc:	e0058593          	addi	a1,a1,-512 # 61d8 <malloc+0x1ae>
     3e0:	00006097          	auipc	ra,0x6
     3e4:	834080e7          	jalr	-1996(ra) # 5c14 <write>
     3e8:	4785                	li	a5,1
     3ea:	04f50963          	beq	a0,a5,43c <badwrite+0xec>
    printf("write failed\n");
     3ee:	00006517          	auipc	a0,0x6
     3f2:	e8250513          	addi	a0,a0,-382 # 6270 <malloc+0x246>
     3f6:	00006097          	auipc	ra,0x6
     3fa:	b76080e7          	jalr	-1162(ra) # 5f6c <printf>
    exit(1);
     3fe:	4505                	li	a0,1
     400:	00005097          	auipc	ra,0x5
     404:	7f4080e7          	jalr	2036(ra) # 5bf4 <exit>
      printf("open junk failed\n");
     408:	00006517          	auipc	a0,0x6
     40c:	e5050513          	addi	a0,a0,-432 # 6258 <malloc+0x22e>
     410:	00006097          	auipc	ra,0x6
     414:	b5c080e7          	jalr	-1188(ra) # 5f6c <printf>
      exit(1);
     418:	4505                	li	a0,1
     41a:	00005097          	auipc	ra,0x5
     41e:	7da080e7          	jalr	2010(ra) # 5bf4 <exit>
    printf("open junk failed\n");
     422:	00006517          	auipc	a0,0x6
     426:	e3650513          	addi	a0,a0,-458 # 6258 <malloc+0x22e>
     42a:	00006097          	auipc	ra,0x6
     42e:	b42080e7          	jalr	-1214(ra) # 5f6c <printf>
    exit(1);
     432:	4505                	li	a0,1
     434:	00005097          	auipc	ra,0x5
     438:	7c0080e7          	jalr	1984(ra) # 5bf4 <exit>
  }
  close(fd);
     43c:	8526                	mv	a0,s1
     43e:	00005097          	auipc	ra,0x5
     442:	7de080e7          	jalr	2014(ra) # 5c1c <close>
  unlink("junk");
     446:	00006517          	auipc	a0,0x6
     44a:	e0a50513          	addi	a0,a0,-502 # 6250 <malloc+0x226>
     44e:	00005097          	auipc	ra,0x5
     452:	7f6080e7          	jalr	2038(ra) # 5c44 <unlink>

  exit(0);
     456:	4501                	li	a0,0
     458:	00005097          	auipc	ra,0x5
     45c:	79c080e7          	jalr	1948(ra) # 5bf4 <exit>

0000000000000460 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     460:	715d                	addi	sp,sp,-80
     462:	e486                	sd	ra,72(sp)
     464:	e0a2                	sd	s0,64(sp)
     466:	fc26                	sd	s1,56(sp)
     468:	f84a                	sd	s2,48(sp)
     46a:	f44e                	sd	s3,40(sp)
     46c:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46e:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     470:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     474:	40000993          	li	s3,1024
    name[0] = 'z';
     478:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47c:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     480:	41f4d79b          	sraiw	a5,s1,0x1f
     484:	01b7d71b          	srliw	a4,a5,0x1b
     488:	009707bb          	addw	a5,a4,s1
     48c:	4057d69b          	sraiw	a3,a5,0x5
     490:	0306869b          	addiw	a3,a3,48
     494:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     498:	8bfd                	andi	a5,a5,31
     49a:	9f99                	subw	a5,a5,a4
     49c:	0307879b          	addiw	a5,a5,48
     4a0:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a4:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a8:	fb040513          	addi	a0,s0,-80
     4ac:	00005097          	auipc	ra,0x5
     4b0:	798080e7          	jalr	1944(ra) # 5c44 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b4:	60200593          	li	a1,1538
     4b8:	fb040513          	addi	a0,s0,-80
     4bc:	00005097          	auipc	ra,0x5
     4c0:	778080e7          	jalr	1912(ra) # 5c34 <open>
    if(fd < 0){
     4c4:	00054963          	bltz	a0,4d6 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c8:	00005097          	auipc	ra,0x5
     4cc:	754080e7          	jalr	1876(ra) # 5c1c <close>
  for(int i = 0; i < nzz; i++){
     4d0:	2485                	addiw	s1,s1,1
     4d2:	fb3493e3          	bne	s1,s3,478 <outofinodes+0x18>
     4d6:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d8:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4dc:	40000993          	li	s3,1024
    name[0] = 'z';
     4e0:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e4:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e8:	41f4d79b          	sraiw	a5,s1,0x1f
     4ec:	01b7d71b          	srliw	a4,a5,0x1b
     4f0:	009707bb          	addw	a5,a4,s1
     4f4:	4057d69b          	sraiw	a3,a5,0x5
     4f8:	0306869b          	addiw	a3,a3,48
     4fc:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     500:	8bfd                	andi	a5,a5,31
     502:	9f99                	subw	a5,a5,a4
     504:	0307879b          	addiw	a5,a5,48
     508:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50c:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     510:	fb040513          	addi	a0,s0,-80
     514:	00005097          	auipc	ra,0x5
     518:	730080e7          	jalr	1840(ra) # 5c44 <unlink>
  for(int i = 0; i < nzz; i++){
     51c:	2485                	addiw	s1,s1,1
     51e:	fd3491e3          	bne	s1,s3,4e0 <outofinodes+0x80>
  }
}
     522:	60a6                	ld	ra,72(sp)
     524:	6406                	ld	s0,64(sp)
     526:	74e2                	ld	s1,56(sp)
     528:	7942                	ld	s2,48(sp)
     52a:	79a2                	ld	s3,40(sp)
     52c:	6161                	addi	sp,sp,80
     52e:	8082                	ret

0000000000000530 <copyin>:
{
     530:	715d                	addi	sp,sp,-80
     532:	e486                	sd	ra,72(sp)
     534:	e0a2                	sd	s0,64(sp)
     536:	fc26                	sd	s1,56(sp)
     538:	f84a                	sd	s2,48(sp)
     53a:	f44e                	sd	s3,40(sp)
     53c:	f052                	sd	s4,32(sp)
     53e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     540:	4785                	li	a5,1
     542:	07fe                	slli	a5,a5,0x1f
     544:	fcf43023          	sd	a5,-64(s0)
     548:	57fd                	li	a5,-1
     54a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     552:	00006a17          	auipc	s4,0x6
     556:	d2ea0a13          	addi	s4,s4,-722 # 6280 <malloc+0x256>
    uint64 addr = addrs[ai];
     55a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55e:	20100593          	li	a1,513
     562:	8552                	mv	a0,s4
     564:	00005097          	auipc	ra,0x5
     568:	6d0080e7          	jalr	1744(ra) # 5c34 <open>
     56c:	84aa                	mv	s1,a0
    if(fd < 0){
     56e:	08054863          	bltz	a0,5fe <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     572:	6609                	lui	a2,0x2
     574:	85ce                	mv	a1,s3
     576:	00005097          	auipc	ra,0x5
     57a:	69e080e7          	jalr	1694(ra) # 5c14 <write>
    if(n >= 0){
     57e:	08055d63          	bgez	a0,618 <copyin+0xe8>
    close(fd);
     582:	8526                	mv	a0,s1
     584:	00005097          	auipc	ra,0x5
     588:	698080e7          	jalr	1688(ra) # 5c1c <close>
    unlink("copyin1");
     58c:	8552                	mv	a0,s4
     58e:	00005097          	auipc	ra,0x5
     592:	6b6080e7          	jalr	1718(ra) # 5c44 <unlink>
    n = write(1, (char*)addr, 8192);
     596:	6609                	lui	a2,0x2
     598:	85ce                	mv	a1,s3
     59a:	4505                	li	a0,1
     59c:	00005097          	auipc	ra,0x5
     5a0:	678080e7          	jalr	1656(ra) # 5c14 <write>
    if(n > 0){
     5a4:	08a04963          	bgtz	a0,636 <copyin+0x106>
    if(pipe(fds) < 0){
     5a8:	fb840513          	addi	a0,s0,-72
     5ac:	00005097          	auipc	ra,0x5
     5b0:	658080e7          	jalr	1624(ra) # 5c04 <pipe>
     5b4:	0a054063          	bltz	a0,654 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b8:	6609                	lui	a2,0x2
     5ba:	85ce                	mv	a1,s3
     5bc:	fbc42503          	lw	a0,-68(s0)
     5c0:	00005097          	auipc	ra,0x5
     5c4:	654080e7          	jalr	1620(ra) # 5c14 <write>
    if(n > 0){
     5c8:	0aa04363          	bgtz	a0,66e <copyin+0x13e>
    close(fds[0]);
     5cc:	fb842503          	lw	a0,-72(s0)
     5d0:	00005097          	auipc	ra,0x5
     5d4:	64c080e7          	jalr	1612(ra) # 5c1c <close>
    close(fds[1]);
     5d8:	fbc42503          	lw	a0,-68(s0)
     5dc:	00005097          	auipc	ra,0x5
     5e0:	640080e7          	jalr	1600(ra) # 5c1c <close>
  for(int ai = 0; ai < 2; ai++){
     5e4:	0921                	addi	s2,s2,8
     5e6:	fd040793          	addi	a5,s0,-48
     5ea:	f6f918e3          	bne	s2,a5,55a <copyin+0x2a>
}
     5ee:	60a6                	ld	ra,72(sp)
     5f0:	6406                	ld	s0,64(sp)
     5f2:	74e2                	ld	s1,56(sp)
     5f4:	7942                	ld	s2,48(sp)
     5f6:	79a2                	ld	s3,40(sp)
     5f8:	7a02                	ld	s4,32(sp)
     5fa:	6161                	addi	sp,sp,80
     5fc:	8082                	ret
      printf("open(copyin1) failed\n");
     5fe:	00006517          	auipc	a0,0x6
     602:	c8a50513          	addi	a0,a0,-886 # 6288 <malloc+0x25e>
     606:	00006097          	auipc	ra,0x6
     60a:	966080e7          	jalr	-1690(ra) # 5f6c <printf>
      exit(1);
     60e:	4505                	li	a0,1
     610:	00005097          	auipc	ra,0x5
     614:	5e4080e7          	jalr	1508(ra) # 5bf4 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     618:	862a                	mv	a2,a0
     61a:	85ce                	mv	a1,s3
     61c:	00006517          	auipc	a0,0x6
     620:	c8450513          	addi	a0,a0,-892 # 62a0 <malloc+0x276>
     624:	00006097          	auipc	ra,0x6
     628:	948080e7          	jalr	-1720(ra) # 5f6c <printf>
      exit(1);
     62c:	4505                	li	a0,1
     62e:	00005097          	auipc	ra,0x5
     632:	5c6080e7          	jalr	1478(ra) # 5bf4 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     636:	862a                	mv	a2,a0
     638:	85ce                	mv	a1,s3
     63a:	00006517          	auipc	a0,0x6
     63e:	c9650513          	addi	a0,a0,-874 # 62d0 <malloc+0x2a6>
     642:	00006097          	auipc	ra,0x6
     646:	92a080e7          	jalr	-1750(ra) # 5f6c <printf>
      exit(1);
     64a:	4505                	li	a0,1
     64c:	00005097          	auipc	ra,0x5
     650:	5a8080e7          	jalr	1448(ra) # 5bf4 <exit>
      printf("pipe() failed\n");
     654:	00006517          	auipc	a0,0x6
     658:	cac50513          	addi	a0,a0,-852 # 6300 <malloc+0x2d6>
     65c:	00006097          	auipc	ra,0x6
     660:	910080e7          	jalr	-1776(ra) # 5f6c <printf>
      exit(1);
     664:	4505                	li	a0,1
     666:	00005097          	auipc	ra,0x5
     66a:	58e080e7          	jalr	1422(ra) # 5bf4 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66e:	862a                	mv	a2,a0
     670:	85ce                	mv	a1,s3
     672:	00006517          	auipc	a0,0x6
     676:	c9e50513          	addi	a0,a0,-866 # 6310 <malloc+0x2e6>
     67a:	00006097          	auipc	ra,0x6
     67e:	8f2080e7          	jalr	-1806(ra) # 5f6c <printf>
      exit(1);
     682:	4505                	li	a0,1
     684:	00005097          	auipc	ra,0x5
     688:	570080e7          	jalr	1392(ra) # 5bf4 <exit>

000000000000068c <copyout>:
{
     68c:	711d                	addi	sp,sp,-96
     68e:	ec86                	sd	ra,88(sp)
     690:	e8a2                	sd	s0,80(sp)
     692:	e4a6                	sd	s1,72(sp)
     694:	e0ca                	sd	s2,64(sp)
     696:	fc4e                	sd	s3,56(sp)
     698:	f852                	sd	s4,48(sp)
     69a:	f456                	sd	s5,40(sp)
     69c:	f05a                	sd	s6,32(sp)
     69e:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0LL, 0x80000000LL, 0xffffffffffffffff };
     6a0:	fa043423          	sd	zero,-88(s0)
     6a4:	4785                	li	a5,1
     6a6:	07fe                	slli	a5,a5,0x1f
     6a8:	faf43823          	sd	a5,-80(s0)
     6ac:	57fd                	li	a5,-1
     6ae:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6b2:	fa840913          	addi	s2,s0,-88
     6b6:	fb840b13          	addi	s6,s0,-72
    int fd = open("README", 0);
     6ba:	00006a17          	auipc	s4,0x6
     6be:	c86a0a13          	addi	s4,s4,-890 # 6340 <malloc+0x316>
    n = write(fds[1], "x", 1);
     6c2:	00006a97          	auipc	s5,0x6
     6c6:	b16a8a93          	addi	s5,s5,-1258 # 61d8 <malloc+0x1ae>
    uint64 addr = addrs[ai];
     6ca:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6ce:	4581                	li	a1,0
     6d0:	8552                	mv	a0,s4
     6d2:	00005097          	auipc	ra,0x5
     6d6:	562080e7          	jalr	1378(ra) # 5c34 <open>
     6da:	84aa                	mv	s1,a0
    if(fd < 0){
     6dc:	08054563          	bltz	a0,766 <copyout+0xda>
    int n = read(fd, (void*)addr, 8192);
     6e0:	6609                	lui	a2,0x2
     6e2:	85ce                	mv	a1,s3
     6e4:	00005097          	auipc	ra,0x5
     6e8:	528080e7          	jalr	1320(ra) # 5c0c <read>
    if(n > 0){
     6ec:	08a04a63          	bgtz	a0,780 <copyout+0xf4>
    close(fd);
     6f0:	8526                	mv	a0,s1
     6f2:	00005097          	auipc	ra,0x5
     6f6:	52a080e7          	jalr	1322(ra) # 5c1c <close>
    if(pipe(fds) < 0){
     6fa:	fa040513          	addi	a0,s0,-96
     6fe:	00005097          	auipc	ra,0x5
     702:	506080e7          	jalr	1286(ra) # 5c04 <pipe>
     706:	08054c63          	bltz	a0,79e <copyout+0x112>
    n = write(fds[1], "x", 1);
     70a:	4605                	li	a2,1
     70c:	85d6                	mv	a1,s5
     70e:	fa442503          	lw	a0,-92(s0)
     712:	00005097          	auipc	ra,0x5
     716:	502080e7          	jalr	1282(ra) # 5c14 <write>
    if(n != 1){
     71a:	4785                	li	a5,1
     71c:	08f51e63          	bne	a0,a5,7b8 <copyout+0x12c>
    n = read(fds[0], (void*)addr, 8192);
     720:	6609                	lui	a2,0x2
     722:	85ce                	mv	a1,s3
     724:	fa042503          	lw	a0,-96(s0)
     728:	00005097          	auipc	ra,0x5
     72c:	4e4080e7          	jalr	1252(ra) # 5c0c <read>
    if(n > 0){
     730:	0aa04163          	bgtz	a0,7d2 <copyout+0x146>
    close(fds[0]);
     734:	fa042503          	lw	a0,-96(s0)
     738:	00005097          	auipc	ra,0x5
     73c:	4e4080e7          	jalr	1252(ra) # 5c1c <close>
    close(fds[1]);
     740:	fa442503          	lw	a0,-92(s0)
     744:	00005097          	auipc	ra,0x5
     748:	4d8080e7          	jalr	1240(ra) # 5c1c <close>
  for(int ai = 0; ai < 2; ai++){
     74c:	0921                	addi	s2,s2,8
     74e:	f7691ee3          	bne	s2,s6,6ca <copyout+0x3e>
}
     752:	60e6                	ld	ra,88(sp)
     754:	6446                	ld	s0,80(sp)
     756:	64a6                	ld	s1,72(sp)
     758:	6906                	ld	s2,64(sp)
     75a:	79e2                	ld	s3,56(sp)
     75c:	7a42                	ld	s4,48(sp)
     75e:	7aa2                	ld	s5,40(sp)
     760:	7b02                	ld	s6,32(sp)
     762:	6125                	addi	sp,sp,96
     764:	8082                	ret
      printf("open(README) failed\n");
     766:	00006517          	auipc	a0,0x6
     76a:	be250513          	addi	a0,a0,-1054 # 6348 <malloc+0x31e>
     76e:	00005097          	auipc	ra,0x5
     772:	7fe080e7          	jalr	2046(ra) # 5f6c <printf>
      exit(1);
     776:	4505                	li	a0,1
     778:	00005097          	auipc	ra,0x5
     77c:	47c080e7          	jalr	1148(ra) # 5bf4 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     780:	862a                	mv	a2,a0
     782:	85ce                	mv	a1,s3
     784:	00006517          	auipc	a0,0x6
     788:	bdc50513          	addi	a0,a0,-1060 # 6360 <malloc+0x336>
     78c:	00005097          	auipc	ra,0x5
     790:	7e0080e7          	jalr	2016(ra) # 5f6c <printf>
      exit(1);
     794:	4505                	li	a0,1
     796:	00005097          	auipc	ra,0x5
     79a:	45e080e7          	jalr	1118(ra) # 5bf4 <exit>
      printf("pipe() failed\n");
     79e:	00006517          	auipc	a0,0x6
     7a2:	b6250513          	addi	a0,a0,-1182 # 6300 <malloc+0x2d6>
     7a6:	00005097          	auipc	ra,0x5
     7aa:	7c6080e7          	jalr	1990(ra) # 5f6c <printf>
      exit(1);
     7ae:	4505                	li	a0,1
     7b0:	00005097          	auipc	ra,0x5
     7b4:	444080e7          	jalr	1092(ra) # 5bf4 <exit>
      printf("pipe write failed\n");
     7b8:	00006517          	auipc	a0,0x6
     7bc:	bd850513          	addi	a0,a0,-1064 # 6390 <malloc+0x366>
     7c0:	00005097          	auipc	ra,0x5
     7c4:	7ac080e7          	jalr	1964(ra) # 5f6c <printf>
      exit(1);
     7c8:	4505                	li	a0,1
     7ca:	00005097          	auipc	ra,0x5
     7ce:	42a080e7          	jalr	1066(ra) # 5bf4 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7d2:	862a                	mv	a2,a0
     7d4:	85ce                	mv	a1,s3
     7d6:	00006517          	auipc	a0,0x6
     7da:	bd250513          	addi	a0,a0,-1070 # 63a8 <malloc+0x37e>
     7de:	00005097          	auipc	ra,0x5
     7e2:	78e080e7          	jalr	1934(ra) # 5f6c <printf>
      exit(1);
     7e6:	4505                	li	a0,1
     7e8:	00005097          	auipc	ra,0x5
     7ec:	40c080e7          	jalr	1036(ra) # 5bf4 <exit>

00000000000007f0 <truncate1>:
{
     7f0:	711d                	addi	sp,sp,-96
     7f2:	ec86                	sd	ra,88(sp)
     7f4:	e8a2                	sd	s0,80(sp)
     7f6:	e4a6                	sd	s1,72(sp)
     7f8:	e0ca                	sd	s2,64(sp)
     7fa:	fc4e                	sd	s3,56(sp)
     7fc:	f852                	sd	s4,48(sp)
     7fe:	f456                	sd	s5,40(sp)
     800:	1080                	addi	s0,sp,96
     802:	8aaa                	mv	s5,a0
  unlink("truncfile");
     804:	00006517          	auipc	a0,0x6
     808:	9bc50513          	addi	a0,a0,-1604 # 61c0 <malloc+0x196>
     80c:	00005097          	auipc	ra,0x5
     810:	438080e7          	jalr	1080(ra) # 5c44 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     814:	60100593          	li	a1,1537
     818:	00006517          	auipc	a0,0x6
     81c:	9a850513          	addi	a0,a0,-1624 # 61c0 <malloc+0x196>
     820:	00005097          	auipc	ra,0x5
     824:	414080e7          	jalr	1044(ra) # 5c34 <open>
     828:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     82a:	4611                	li	a2,4
     82c:	00006597          	auipc	a1,0x6
     830:	9a458593          	addi	a1,a1,-1628 # 61d0 <malloc+0x1a6>
     834:	00005097          	auipc	ra,0x5
     838:	3e0080e7          	jalr	992(ra) # 5c14 <write>
  close(fd1);
     83c:	8526                	mv	a0,s1
     83e:	00005097          	auipc	ra,0x5
     842:	3de080e7          	jalr	990(ra) # 5c1c <close>
  int fd2 = open("truncfile", O_RDONLY);
     846:	4581                	li	a1,0
     848:	00006517          	auipc	a0,0x6
     84c:	97850513          	addi	a0,a0,-1672 # 61c0 <malloc+0x196>
     850:	00005097          	auipc	ra,0x5
     854:	3e4080e7          	jalr	996(ra) # 5c34 <open>
     858:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     85a:	02000613          	li	a2,32
     85e:	fa040593          	addi	a1,s0,-96
     862:	00005097          	auipc	ra,0x5
     866:	3aa080e7          	jalr	938(ra) # 5c0c <read>
  if(n != 4){
     86a:	4791                	li	a5,4
     86c:	0cf51e63          	bne	a0,a5,948 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     870:	40100593          	li	a1,1025
     874:	00006517          	auipc	a0,0x6
     878:	94c50513          	addi	a0,a0,-1716 # 61c0 <malloc+0x196>
     87c:	00005097          	auipc	ra,0x5
     880:	3b8080e7          	jalr	952(ra) # 5c34 <open>
     884:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     886:	4581                	li	a1,0
     888:	00006517          	auipc	a0,0x6
     88c:	93850513          	addi	a0,a0,-1736 # 61c0 <malloc+0x196>
     890:	00005097          	auipc	ra,0x5
     894:	3a4080e7          	jalr	932(ra) # 5c34 <open>
     898:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     89a:	02000613          	li	a2,32
     89e:	fa040593          	addi	a1,s0,-96
     8a2:	00005097          	auipc	ra,0x5
     8a6:	36a080e7          	jalr	874(ra) # 5c0c <read>
     8aa:	8a2a                	mv	s4,a0
  if(n != 0){
     8ac:	ed4d                	bnez	a0,966 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8ae:	02000613          	li	a2,32
     8b2:	fa040593          	addi	a1,s0,-96
     8b6:	8526                	mv	a0,s1
     8b8:	00005097          	auipc	ra,0x5
     8bc:	354080e7          	jalr	852(ra) # 5c0c <read>
     8c0:	8a2a                	mv	s4,a0
  if(n != 0){
     8c2:	e971                	bnez	a0,996 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8c4:	4619                	li	a2,6
     8c6:	00006597          	auipc	a1,0x6
     8ca:	b7258593          	addi	a1,a1,-1166 # 6438 <malloc+0x40e>
     8ce:	854e                	mv	a0,s3
     8d0:	00005097          	auipc	ra,0x5
     8d4:	344080e7          	jalr	836(ra) # 5c14 <write>
  n = read(fd3, buf, sizeof(buf));
     8d8:	02000613          	li	a2,32
     8dc:	fa040593          	addi	a1,s0,-96
     8e0:	854a                	mv	a0,s2
     8e2:	00005097          	auipc	ra,0x5
     8e6:	32a080e7          	jalr	810(ra) # 5c0c <read>
  if(n != 6){
     8ea:	4799                	li	a5,6
     8ec:	0cf51d63          	bne	a0,a5,9c6 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8f0:	02000613          	li	a2,32
     8f4:	fa040593          	addi	a1,s0,-96
     8f8:	8526                	mv	a0,s1
     8fa:	00005097          	auipc	ra,0x5
     8fe:	312080e7          	jalr	786(ra) # 5c0c <read>
  if(n != 2){
     902:	4789                	li	a5,2
     904:	0ef51063          	bne	a0,a5,9e4 <truncate1+0x1f4>
  unlink("truncfile");
     908:	00006517          	auipc	a0,0x6
     90c:	8b850513          	addi	a0,a0,-1864 # 61c0 <malloc+0x196>
     910:	00005097          	auipc	ra,0x5
     914:	334080e7          	jalr	820(ra) # 5c44 <unlink>
  close(fd1);
     918:	854e                	mv	a0,s3
     91a:	00005097          	auipc	ra,0x5
     91e:	302080e7          	jalr	770(ra) # 5c1c <close>
  close(fd2);
     922:	8526                	mv	a0,s1
     924:	00005097          	auipc	ra,0x5
     928:	2f8080e7          	jalr	760(ra) # 5c1c <close>
  close(fd3);
     92c:	854a                	mv	a0,s2
     92e:	00005097          	auipc	ra,0x5
     932:	2ee080e7          	jalr	750(ra) # 5c1c <close>
}
     936:	60e6                	ld	ra,88(sp)
     938:	6446                	ld	s0,80(sp)
     93a:	64a6                	ld	s1,72(sp)
     93c:	6906                	ld	s2,64(sp)
     93e:	79e2                	ld	s3,56(sp)
     940:	7a42                	ld	s4,48(sp)
     942:	7aa2                	ld	s5,40(sp)
     944:	6125                	addi	sp,sp,96
     946:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     948:	862a                	mv	a2,a0
     94a:	85d6                	mv	a1,s5
     94c:	00006517          	auipc	a0,0x6
     950:	a8c50513          	addi	a0,a0,-1396 # 63d8 <malloc+0x3ae>
     954:	00005097          	auipc	ra,0x5
     958:	618080e7          	jalr	1560(ra) # 5f6c <printf>
    exit(1);
     95c:	4505                	li	a0,1
     95e:	00005097          	auipc	ra,0x5
     962:	296080e7          	jalr	662(ra) # 5bf4 <exit>
    printf("aaa fd3=%d\n", fd3);
     966:	85ca                	mv	a1,s2
     968:	00006517          	auipc	a0,0x6
     96c:	a9050513          	addi	a0,a0,-1392 # 63f8 <malloc+0x3ce>
     970:	00005097          	auipc	ra,0x5
     974:	5fc080e7          	jalr	1532(ra) # 5f6c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     978:	8652                	mv	a2,s4
     97a:	85d6                	mv	a1,s5
     97c:	00006517          	auipc	a0,0x6
     980:	a8c50513          	addi	a0,a0,-1396 # 6408 <malloc+0x3de>
     984:	00005097          	auipc	ra,0x5
     988:	5e8080e7          	jalr	1512(ra) # 5f6c <printf>
    exit(1);
     98c:	4505                	li	a0,1
     98e:	00005097          	auipc	ra,0x5
     992:	266080e7          	jalr	614(ra) # 5bf4 <exit>
    printf("bbb fd2=%d\n", fd2);
     996:	85a6                	mv	a1,s1
     998:	00006517          	auipc	a0,0x6
     99c:	a9050513          	addi	a0,a0,-1392 # 6428 <malloc+0x3fe>
     9a0:	00005097          	auipc	ra,0x5
     9a4:	5cc080e7          	jalr	1484(ra) # 5f6c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9a8:	8652                	mv	a2,s4
     9aa:	85d6                	mv	a1,s5
     9ac:	00006517          	auipc	a0,0x6
     9b0:	a5c50513          	addi	a0,a0,-1444 # 6408 <malloc+0x3de>
     9b4:	00005097          	auipc	ra,0x5
     9b8:	5b8080e7          	jalr	1464(ra) # 5f6c <printf>
    exit(1);
     9bc:	4505                	li	a0,1
     9be:	00005097          	auipc	ra,0x5
     9c2:	236080e7          	jalr	566(ra) # 5bf4 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9c6:	862a                	mv	a2,a0
     9c8:	85d6                	mv	a1,s5
     9ca:	00006517          	auipc	a0,0x6
     9ce:	a7650513          	addi	a0,a0,-1418 # 6440 <malloc+0x416>
     9d2:	00005097          	auipc	ra,0x5
     9d6:	59a080e7          	jalr	1434(ra) # 5f6c <printf>
    exit(1);
     9da:	4505                	li	a0,1
     9dc:	00005097          	auipc	ra,0x5
     9e0:	218080e7          	jalr	536(ra) # 5bf4 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9e4:	862a                	mv	a2,a0
     9e6:	85d6                	mv	a1,s5
     9e8:	00006517          	auipc	a0,0x6
     9ec:	a7850513          	addi	a0,a0,-1416 # 6460 <malloc+0x436>
     9f0:	00005097          	auipc	ra,0x5
     9f4:	57c080e7          	jalr	1404(ra) # 5f6c <printf>
    exit(1);
     9f8:	4505                	li	a0,1
     9fa:	00005097          	auipc	ra,0x5
     9fe:	1fa080e7          	jalr	506(ra) # 5bf4 <exit>

0000000000000a02 <writetest>:
{
     a02:	7139                	addi	sp,sp,-64
     a04:	fc06                	sd	ra,56(sp)
     a06:	f822                	sd	s0,48(sp)
     a08:	f426                	sd	s1,40(sp)
     a0a:	f04a                	sd	s2,32(sp)
     a0c:	ec4e                	sd	s3,24(sp)
     a0e:	e852                	sd	s4,16(sp)
     a10:	e456                	sd	s5,8(sp)
     a12:	e05a                	sd	s6,0(sp)
     a14:	0080                	addi	s0,sp,64
     a16:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a18:	20200593          	li	a1,514
     a1c:	00006517          	auipc	a0,0x6
     a20:	a6450513          	addi	a0,a0,-1436 # 6480 <malloc+0x456>
     a24:	00005097          	auipc	ra,0x5
     a28:	210080e7          	jalr	528(ra) # 5c34 <open>
  if(fd < 0){
     a2c:	0a054d63          	bltz	a0,ae6 <writetest+0xe4>
     a30:	892a                	mv	s2,a0
     a32:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a34:	00006997          	auipc	s3,0x6
     a38:	a7498993          	addi	s3,s3,-1420 # 64a8 <malloc+0x47e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a3c:	00006a97          	auipc	s5,0x6
     a40:	aa4a8a93          	addi	s5,s5,-1372 # 64e0 <malloc+0x4b6>
  for(i = 0; i < N; i++){
     a44:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a48:	4629                	li	a2,10
     a4a:	85ce                	mv	a1,s3
     a4c:	854a                	mv	a0,s2
     a4e:	00005097          	auipc	ra,0x5
     a52:	1c6080e7          	jalr	454(ra) # 5c14 <write>
     a56:	47a9                	li	a5,10
     a58:	0af51563          	bne	a0,a5,b02 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a5c:	4629                	li	a2,10
     a5e:	85d6                	mv	a1,s5
     a60:	854a                	mv	a0,s2
     a62:	00005097          	auipc	ra,0x5
     a66:	1b2080e7          	jalr	434(ra) # 5c14 <write>
     a6a:	47a9                	li	a5,10
     a6c:	0af51a63          	bne	a0,a5,b20 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a70:	2485                	addiw	s1,s1,1
     a72:	fd449be3          	bne	s1,s4,a48 <writetest+0x46>
  close(fd);
     a76:	854a                	mv	a0,s2
     a78:	00005097          	auipc	ra,0x5
     a7c:	1a4080e7          	jalr	420(ra) # 5c1c <close>
  fd = open("small", O_RDONLY);
     a80:	4581                	li	a1,0
     a82:	00006517          	auipc	a0,0x6
     a86:	9fe50513          	addi	a0,a0,-1538 # 6480 <malloc+0x456>
     a8a:	00005097          	auipc	ra,0x5
     a8e:	1aa080e7          	jalr	426(ra) # 5c34 <open>
     a92:	84aa                	mv	s1,a0
  if(fd < 0){
     a94:	0a054563          	bltz	a0,b3e <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a98:	7d000613          	li	a2,2000
     a9c:	0000c597          	auipc	a1,0xc
     aa0:	1dc58593          	addi	a1,a1,476 # cc78 <buf>
     aa4:	00005097          	auipc	ra,0x5
     aa8:	168080e7          	jalr	360(ra) # 5c0c <read>
  if(i != N*SZ*2){
     aac:	7d000793          	li	a5,2000
     ab0:	0af51563          	bne	a0,a5,b5a <writetest+0x158>
  close(fd);
     ab4:	8526                	mv	a0,s1
     ab6:	00005097          	auipc	ra,0x5
     aba:	166080e7          	jalr	358(ra) # 5c1c <close>
  if(unlink("small") < 0){
     abe:	00006517          	auipc	a0,0x6
     ac2:	9c250513          	addi	a0,a0,-1598 # 6480 <malloc+0x456>
     ac6:	00005097          	auipc	ra,0x5
     aca:	17e080e7          	jalr	382(ra) # 5c44 <unlink>
     ace:	0a054463          	bltz	a0,b76 <writetest+0x174>
}
     ad2:	70e2                	ld	ra,56(sp)
     ad4:	7442                	ld	s0,48(sp)
     ad6:	74a2                	ld	s1,40(sp)
     ad8:	7902                	ld	s2,32(sp)
     ada:	69e2                	ld	s3,24(sp)
     adc:	6a42                	ld	s4,16(sp)
     ade:	6aa2                	ld	s5,8(sp)
     ae0:	6b02                	ld	s6,0(sp)
     ae2:	6121                	addi	sp,sp,64
     ae4:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     ae6:	85da                	mv	a1,s6
     ae8:	00006517          	auipc	a0,0x6
     aec:	9a050513          	addi	a0,a0,-1632 # 6488 <malloc+0x45e>
     af0:	00005097          	auipc	ra,0x5
     af4:	47c080e7          	jalr	1148(ra) # 5f6c <printf>
    exit(1);
     af8:	4505                	li	a0,1
     afa:	00005097          	auipc	ra,0x5
     afe:	0fa080e7          	jalr	250(ra) # 5bf4 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     b02:	8626                	mv	a2,s1
     b04:	85da                	mv	a1,s6
     b06:	00006517          	auipc	a0,0x6
     b0a:	9b250513          	addi	a0,a0,-1614 # 64b8 <malloc+0x48e>
     b0e:	00005097          	auipc	ra,0x5
     b12:	45e080e7          	jalr	1118(ra) # 5f6c <printf>
      exit(1);
     b16:	4505                	li	a0,1
     b18:	00005097          	auipc	ra,0x5
     b1c:	0dc080e7          	jalr	220(ra) # 5bf4 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b20:	8626                	mv	a2,s1
     b22:	85da                	mv	a1,s6
     b24:	00006517          	auipc	a0,0x6
     b28:	9cc50513          	addi	a0,a0,-1588 # 64f0 <malloc+0x4c6>
     b2c:	00005097          	auipc	ra,0x5
     b30:	440080e7          	jalr	1088(ra) # 5f6c <printf>
      exit(1);
     b34:	4505                	li	a0,1
     b36:	00005097          	auipc	ra,0x5
     b3a:	0be080e7          	jalr	190(ra) # 5bf4 <exit>
    printf("%s: error: open small failed!\n", s);
     b3e:	85da                	mv	a1,s6
     b40:	00006517          	auipc	a0,0x6
     b44:	9d850513          	addi	a0,a0,-1576 # 6518 <malloc+0x4ee>
     b48:	00005097          	auipc	ra,0x5
     b4c:	424080e7          	jalr	1060(ra) # 5f6c <printf>
    exit(1);
     b50:	4505                	li	a0,1
     b52:	00005097          	auipc	ra,0x5
     b56:	0a2080e7          	jalr	162(ra) # 5bf4 <exit>
    printf("%s: read failed\n", s);
     b5a:	85da                	mv	a1,s6
     b5c:	00006517          	auipc	a0,0x6
     b60:	9dc50513          	addi	a0,a0,-1572 # 6538 <malloc+0x50e>
     b64:	00005097          	auipc	ra,0x5
     b68:	408080e7          	jalr	1032(ra) # 5f6c <printf>
    exit(1);
     b6c:	4505                	li	a0,1
     b6e:	00005097          	auipc	ra,0x5
     b72:	086080e7          	jalr	134(ra) # 5bf4 <exit>
    printf("%s: unlink small failed\n", s);
     b76:	85da                	mv	a1,s6
     b78:	00006517          	auipc	a0,0x6
     b7c:	9d850513          	addi	a0,a0,-1576 # 6550 <malloc+0x526>
     b80:	00005097          	auipc	ra,0x5
     b84:	3ec080e7          	jalr	1004(ra) # 5f6c <printf>
    exit(1);
     b88:	4505                	li	a0,1
     b8a:	00005097          	auipc	ra,0x5
     b8e:	06a080e7          	jalr	106(ra) # 5bf4 <exit>

0000000000000b92 <writebig>:
{
     b92:	7139                	addi	sp,sp,-64
     b94:	fc06                	sd	ra,56(sp)
     b96:	f822                	sd	s0,48(sp)
     b98:	f426                	sd	s1,40(sp)
     b9a:	f04a                	sd	s2,32(sp)
     b9c:	ec4e                	sd	s3,24(sp)
     b9e:	e852                	sd	s4,16(sp)
     ba0:	e456                	sd	s5,8(sp)
     ba2:	0080                	addi	s0,sp,64
     ba4:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     ba6:	20200593          	li	a1,514
     baa:	00006517          	auipc	a0,0x6
     bae:	9c650513          	addi	a0,a0,-1594 # 6570 <malloc+0x546>
     bb2:	00005097          	auipc	ra,0x5
     bb6:	082080e7          	jalr	130(ra) # 5c34 <open>
     bba:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bbc:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bbe:	0000c917          	auipc	s2,0xc
     bc2:	0ba90913          	addi	s2,s2,186 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     bc6:	10c00a13          	li	s4,268
  if(fd < 0){
     bca:	06054c63          	bltz	a0,c42 <writebig+0xb0>
    ((int*)buf)[0] = i;
     bce:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bd2:	40000613          	li	a2,1024
     bd6:	85ca                	mv	a1,s2
     bd8:	854e                	mv	a0,s3
     bda:	00005097          	auipc	ra,0x5
     bde:	03a080e7          	jalr	58(ra) # 5c14 <write>
     be2:	40000793          	li	a5,1024
     be6:	06f51c63          	bne	a0,a5,c5e <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     bea:	2485                	addiw	s1,s1,1
     bec:	ff4491e3          	bne	s1,s4,bce <writebig+0x3c>
  close(fd);
     bf0:	854e                	mv	a0,s3
     bf2:	00005097          	auipc	ra,0x5
     bf6:	02a080e7          	jalr	42(ra) # 5c1c <close>
  fd = open("big", O_RDONLY);
     bfa:	4581                	li	a1,0
     bfc:	00006517          	auipc	a0,0x6
     c00:	97450513          	addi	a0,a0,-1676 # 6570 <malloc+0x546>
     c04:	00005097          	auipc	ra,0x5
     c08:	030080e7          	jalr	48(ra) # 5c34 <open>
     c0c:	89aa                	mv	s3,a0
  n = 0;
     c0e:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c10:	0000c917          	auipc	s2,0xc
     c14:	06890913          	addi	s2,s2,104 # cc78 <buf>
  if(fd < 0){
     c18:	06054263          	bltz	a0,c7c <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c1c:	40000613          	li	a2,1024
     c20:	85ca                	mv	a1,s2
     c22:	854e                	mv	a0,s3
     c24:	00005097          	auipc	ra,0x5
     c28:	fe8080e7          	jalr	-24(ra) # 5c0c <read>
    if(i == 0){
     c2c:	c535                	beqz	a0,c98 <writebig+0x106>
    } else if(i != BSIZE){
     c2e:	40000793          	li	a5,1024
     c32:	0af51f63          	bne	a0,a5,cf0 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c36:	00092683          	lw	a3,0(s2)
     c3a:	0c969a63          	bne	a3,s1,d0e <writebig+0x17c>
    n++;
     c3e:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c40:	bff1                	j	c1c <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c42:	85d6                	mv	a1,s5
     c44:	00006517          	auipc	a0,0x6
     c48:	93450513          	addi	a0,a0,-1740 # 6578 <malloc+0x54e>
     c4c:	00005097          	auipc	ra,0x5
     c50:	320080e7          	jalr	800(ra) # 5f6c <printf>
    exit(1);
     c54:	4505                	li	a0,1
     c56:	00005097          	auipc	ra,0x5
     c5a:	f9e080e7          	jalr	-98(ra) # 5bf4 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c5e:	8626                	mv	a2,s1
     c60:	85d6                	mv	a1,s5
     c62:	00006517          	auipc	a0,0x6
     c66:	93650513          	addi	a0,a0,-1738 # 6598 <malloc+0x56e>
     c6a:	00005097          	auipc	ra,0x5
     c6e:	302080e7          	jalr	770(ra) # 5f6c <printf>
      exit(1);
     c72:	4505                	li	a0,1
     c74:	00005097          	auipc	ra,0x5
     c78:	f80080e7          	jalr	-128(ra) # 5bf4 <exit>
    printf("%s: error: open big failed!\n", s);
     c7c:	85d6                	mv	a1,s5
     c7e:	00006517          	auipc	a0,0x6
     c82:	94250513          	addi	a0,a0,-1726 # 65c0 <malloc+0x596>
     c86:	00005097          	auipc	ra,0x5
     c8a:	2e6080e7          	jalr	742(ra) # 5f6c <printf>
    exit(1);
     c8e:	4505                	li	a0,1
     c90:	00005097          	auipc	ra,0x5
     c94:	f64080e7          	jalr	-156(ra) # 5bf4 <exit>
      if(n == MAXFILE - 1){
     c98:	10b00793          	li	a5,267
     c9c:	02f48a63          	beq	s1,a5,cd0 <writebig+0x13e>
  close(fd);
     ca0:	854e                	mv	a0,s3
     ca2:	00005097          	auipc	ra,0x5
     ca6:	f7a080e7          	jalr	-134(ra) # 5c1c <close>
  if(unlink("big") < 0){
     caa:	00006517          	auipc	a0,0x6
     cae:	8c650513          	addi	a0,a0,-1850 # 6570 <malloc+0x546>
     cb2:	00005097          	auipc	ra,0x5
     cb6:	f92080e7          	jalr	-110(ra) # 5c44 <unlink>
     cba:	06054963          	bltz	a0,d2c <writebig+0x19a>
}
     cbe:	70e2                	ld	ra,56(sp)
     cc0:	7442                	ld	s0,48(sp)
     cc2:	74a2                	ld	s1,40(sp)
     cc4:	7902                	ld	s2,32(sp)
     cc6:	69e2                	ld	s3,24(sp)
     cc8:	6a42                	ld	s4,16(sp)
     cca:	6aa2                	ld	s5,8(sp)
     ccc:	6121                	addi	sp,sp,64
     cce:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cd0:	10b00613          	li	a2,267
     cd4:	85d6                	mv	a1,s5
     cd6:	00006517          	auipc	a0,0x6
     cda:	90a50513          	addi	a0,a0,-1782 # 65e0 <malloc+0x5b6>
     cde:	00005097          	auipc	ra,0x5
     ce2:	28e080e7          	jalr	654(ra) # 5f6c <printf>
        exit(1);
     ce6:	4505                	li	a0,1
     ce8:	00005097          	auipc	ra,0x5
     cec:	f0c080e7          	jalr	-244(ra) # 5bf4 <exit>
      printf("%s: read failed %d\n", s, i);
     cf0:	862a                	mv	a2,a0
     cf2:	85d6                	mv	a1,s5
     cf4:	00006517          	auipc	a0,0x6
     cf8:	91450513          	addi	a0,a0,-1772 # 6608 <malloc+0x5de>
     cfc:	00005097          	auipc	ra,0x5
     d00:	270080e7          	jalr	624(ra) # 5f6c <printf>
      exit(1);
     d04:	4505                	li	a0,1
     d06:	00005097          	auipc	ra,0x5
     d0a:	eee080e7          	jalr	-274(ra) # 5bf4 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d0e:	8626                	mv	a2,s1
     d10:	85d6                	mv	a1,s5
     d12:	00006517          	auipc	a0,0x6
     d16:	90e50513          	addi	a0,a0,-1778 # 6620 <malloc+0x5f6>
     d1a:	00005097          	auipc	ra,0x5
     d1e:	252080e7          	jalr	594(ra) # 5f6c <printf>
      exit(1);
     d22:	4505                	li	a0,1
     d24:	00005097          	auipc	ra,0x5
     d28:	ed0080e7          	jalr	-304(ra) # 5bf4 <exit>
    printf("%s: unlink big failed\n", s);
     d2c:	85d6                	mv	a1,s5
     d2e:	00006517          	auipc	a0,0x6
     d32:	91a50513          	addi	a0,a0,-1766 # 6648 <malloc+0x61e>
     d36:	00005097          	auipc	ra,0x5
     d3a:	236080e7          	jalr	566(ra) # 5f6c <printf>
    exit(1);
     d3e:	4505                	li	a0,1
     d40:	00005097          	auipc	ra,0x5
     d44:	eb4080e7          	jalr	-332(ra) # 5bf4 <exit>

0000000000000d48 <unlinkread>:
{
     d48:	7179                	addi	sp,sp,-48
     d4a:	f406                	sd	ra,40(sp)
     d4c:	f022                	sd	s0,32(sp)
     d4e:	ec26                	sd	s1,24(sp)
     d50:	e84a                	sd	s2,16(sp)
     d52:	e44e                	sd	s3,8(sp)
     d54:	1800                	addi	s0,sp,48
     d56:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d58:	20200593          	li	a1,514
     d5c:	00006517          	auipc	a0,0x6
     d60:	90450513          	addi	a0,a0,-1788 # 6660 <malloc+0x636>
     d64:	00005097          	auipc	ra,0x5
     d68:	ed0080e7          	jalr	-304(ra) # 5c34 <open>
  if(fd < 0){
     d6c:	0e054563          	bltz	a0,e56 <unlinkread+0x10e>
     d70:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d72:	4615                	li	a2,5
     d74:	00006597          	auipc	a1,0x6
     d78:	91c58593          	addi	a1,a1,-1764 # 6690 <malloc+0x666>
     d7c:	00005097          	auipc	ra,0x5
     d80:	e98080e7          	jalr	-360(ra) # 5c14 <write>
  close(fd);
     d84:	8526                	mv	a0,s1
     d86:	00005097          	auipc	ra,0x5
     d8a:	e96080e7          	jalr	-362(ra) # 5c1c <close>
  fd = open("unlinkread", O_RDWR);
     d8e:	4589                	li	a1,2
     d90:	00006517          	auipc	a0,0x6
     d94:	8d050513          	addi	a0,a0,-1840 # 6660 <malloc+0x636>
     d98:	00005097          	auipc	ra,0x5
     d9c:	e9c080e7          	jalr	-356(ra) # 5c34 <open>
     da0:	84aa                	mv	s1,a0
  if(fd < 0){
     da2:	0c054863          	bltz	a0,e72 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     da6:	00006517          	auipc	a0,0x6
     daa:	8ba50513          	addi	a0,a0,-1862 # 6660 <malloc+0x636>
     dae:	00005097          	auipc	ra,0x5
     db2:	e96080e7          	jalr	-362(ra) # 5c44 <unlink>
     db6:	ed61                	bnez	a0,e8e <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     db8:	20200593          	li	a1,514
     dbc:	00006517          	auipc	a0,0x6
     dc0:	8a450513          	addi	a0,a0,-1884 # 6660 <malloc+0x636>
     dc4:	00005097          	auipc	ra,0x5
     dc8:	e70080e7          	jalr	-400(ra) # 5c34 <open>
     dcc:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dce:	460d                	li	a2,3
     dd0:	00006597          	auipc	a1,0x6
     dd4:	90858593          	addi	a1,a1,-1784 # 66d8 <malloc+0x6ae>
     dd8:	00005097          	auipc	ra,0x5
     ddc:	e3c080e7          	jalr	-452(ra) # 5c14 <write>
  close(fd1);
     de0:	854a                	mv	a0,s2
     de2:	00005097          	auipc	ra,0x5
     de6:	e3a080e7          	jalr	-454(ra) # 5c1c <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dea:	660d                	lui	a2,0x3
     dec:	0000c597          	auipc	a1,0xc
     df0:	e8c58593          	addi	a1,a1,-372 # cc78 <buf>
     df4:	8526                	mv	a0,s1
     df6:	00005097          	auipc	ra,0x5
     dfa:	e16080e7          	jalr	-490(ra) # 5c0c <read>
     dfe:	4795                	li	a5,5
     e00:	0af51563          	bne	a0,a5,eaa <unlinkread+0x162>
  if(buf[0] != 'h'){
     e04:	0000c717          	auipc	a4,0xc
     e08:	e7474703          	lbu	a4,-396(a4) # cc78 <buf>
     e0c:	06800793          	li	a5,104
     e10:	0af71b63          	bne	a4,a5,ec6 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e14:	4629                	li	a2,10
     e16:	0000c597          	auipc	a1,0xc
     e1a:	e6258593          	addi	a1,a1,-414 # cc78 <buf>
     e1e:	8526                	mv	a0,s1
     e20:	00005097          	auipc	ra,0x5
     e24:	df4080e7          	jalr	-524(ra) # 5c14 <write>
     e28:	47a9                	li	a5,10
     e2a:	0af51c63          	bne	a0,a5,ee2 <unlinkread+0x19a>
  close(fd);
     e2e:	8526                	mv	a0,s1
     e30:	00005097          	auipc	ra,0x5
     e34:	dec080e7          	jalr	-532(ra) # 5c1c <close>
  unlink("unlinkread");
     e38:	00006517          	auipc	a0,0x6
     e3c:	82850513          	addi	a0,a0,-2008 # 6660 <malloc+0x636>
     e40:	00005097          	auipc	ra,0x5
     e44:	e04080e7          	jalr	-508(ra) # 5c44 <unlink>
}
     e48:	70a2                	ld	ra,40(sp)
     e4a:	7402                	ld	s0,32(sp)
     e4c:	64e2                	ld	s1,24(sp)
     e4e:	6942                	ld	s2,16(sp)
     e50:	69a2                	ld	s3,8(sp)
     e52:	6145                	addi	sp,sp,48
     e54:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e56:	85ce                	mv	a1,s3
     e58:	00006517          	auipc	a0,0x6
     e5c:	81850513          	addi	a0,a0,-2024 # 6670 <malloc+0x646>
     e60:	00005097          	auipc	ra,0x5
     e64:	10c080e7          	jalr	268(ra) # 5f6c <printf>
    exit(1);
     e68:	4505                	li	a0,1
     e6a:	00005097          	auipc	ra,0x5
     e6e:	d8a080e7          	jalr	-630(ra) # 5bf4 <exit>
    printf("%s: open unlinkread failed\n", s);
     e72:	85ce                	mv	a1,s3
     e74:	00006517          	auipc	a0,0x6
     e78:	82450513          	addi	a0,a0,-2012 # 6698 <malloc+0x66e>
     e7c:	00005097          	auipc	ra,0x5
     e80:	0f0080e7          	jalr	240(ra) # 5f6c <printf>
    exit(1);
     e84:	4505                	li	a0,1
     e86:	00005097          	auipc	ra,0x5
     e8a:	d6e080e7          	jalr	-658(ra) # 5bf4 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e8e:	85ce                	mv	a1,s3
     e90:	00006517          	auipc	a0,0x6
     e94:	82850513          	addi	a0,a0,-2008 # 66b8 <malloc+0x68e>
     e98:	00005097          	auipc	ra,0x5
     e9c:	0d4080e7          	jalr	212(ra) # 5f6c <printf>
    exit(1);
     ea0:	4505                	li	a0,1
     ea2:	00005097          	auipc	ra,0x5
     ea6:	d52080e7          	jalr	-686(ra) # 5bf4 <exit>
    printf("%s: unlinkread read failed", s);
     eaa:	85ce                	mv	a1,s3
     eac:	00006517          	auipc	a0,0x6
     eb0:	83450513          	addi	a0,a0,-1996 # 66e0 <malloc+0x6b6>
     eb4:	00005097          	auipc	ra,0x5
     eb8:	0b8080e7          	jalr	184(ra) # 5f6c <printf>
    exit(1);
     ebc:	4505                	li	a0,1
     ebe:	00005097          	auipc	ra,0x5
     ec2:	d36080e7          	jalr	-714(ra) # 5bf4 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ec6:	85ce                	mv	a1,s3
     ec8:	00006517          	auipc	a0,0x6
     ecc:	83850513          	addi	a0,a0,-1992 # 6700 <malloc+0x6d6>
     ed0:	00005097          	auipc	ra,0x5
     ed4:	09c080e7          	jalr	156(ra) # 5f6c <printf>
    exit(1);
     ed8:	4505                	li	a0,1
     eda:	00005097          	auipc	ra,0x5
     ede:	d1a080e7          	jalr	-742(ra) # 5bf4 <exit>
    printf("%s: unlinkread write failed\n", s);
     ee2:	85ce                	mv	a1,s3
     ee4:	00006517          	auipc	a0,0x6
     ee8:	83c50513          	addi	a0,a0,-1988 # 6720 <malloc+0x6f6>
     eec:	00005097          	auipc	ra,0x5
     ef0:	080080e7          	jalr	128(ra) # 5f6c <printf>
    exit(1);
     ef4:	4505                	li	a0,1
     ef6:	00005097          	auipc	ra,0x5
     efa:	cfe080e7          	jalr	-770(ra) # 5bf4 <exit>

0000000000000efe <linktest>:
{
     efe:	1101                	addi	sp,sp,-32
     f00:	ec06                	sd	ra,24(sp)
     f02:	e822                	sd	s0,16(sp)
     f04:	e426                	sd	s1,8(sp)
     f06:	e04a                	sd	s2,0(sp)
     f08:	1000                	addi	s0,sp,32
     f0a:	892a                	mv	s2,a0
  unlink("lf1");
     f0c:	00006517          	auipc	a0,0x6
     f10:	83450513          	addi	a0,a0,-1996 # 6740 <malloc+0x716>
     f14:	00005097          	auipc	ra,0x5
     f18:	d30080e7          	jalr	-720(ra) # 5c44 <unlink>
  unlink("lf2");
     f1c:	00006517          	auipc	a0,0x6
     f20:	82c50513          	addi	a0,a0,-2004 # 6748 <malloc+0x71e>
     f24:	00005097          	auipc	ra,0x5
     f28:	d20080e7          	jalr	-736(ra) # 5c44 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f2c:	20200593          	li	a1,514
     f30:	00006517          	auipc	a0,0x6
     f34:	81050513          	addi	a0,a0,-2032 # 6740 <malloc+0x716>
     f38:	00005097          	auipc	ra,0x5
     f3c:	cfc080e7          	jalr	-772(ra) # 5c34 <open>
  if(fd < 0){
     f40:	10054763          	bltz	a0,104e <linktest+0x150>
     f44:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f46:	4615                	li	a2,5
     f48:	00005597          	auipc	a1,0x5
     f4c:	74858593          	addi	a1,a1,1864 # 6690 <malloc+0x666>
     f50:	00005097          	auipc	ra,0x5
     f54:	cc4080e7          	jalr	-828(ra) # 5c14 <write>
     f58:	4795                	li	a5,5
     f5a:	10f51863          	bne	a0,a5,106a <linktest+0x16c>
  close(fd);
     f5e:	8526                	mv	a0,s1
     f60:	00005097          	auipc	ra,0x5
     f64:	cbc080e7          	jalr	-836(ra) # 5c1c <close>
  if(link("lf1", "lf2") < 0){
     f68:	00005597          	auipc	a1,0x5
     f6c:	7e058593          	addi	a1,a1,2016 # 6748 <malloc+0x71e>
     f70:	00005517          	auipc	a0,0x5
     f74:	7d050513          	addi	a0,a0,2000 # 6740 <malloc+0x716>
     f78:	00005097          	auipc	ra,0x5
     f7c:	cdc080e7          	jalr	-804(ra) # 5c54 <link>
     f80:	10054363          	bltz	a0,1086 <linktest+0x188>
  unlink("lf1");
     f84:	00005517          	auipc	a0,0x5
     f88:	7bc50513          	addi	a0,a0,1980 # 6740 <malloc+0x716>
     f8c:	00005097          	auipc	ra,0x5
     f90:	cb8080e7          	jalr	-840(ra) # 5c44 <unlink>
  if(open("lf1", 0) >= 0){
     f94:	4581                	li	a1,0
     f96:	00005517          	auipc	a0,0x5
     f9a:	7aa50513          	addi	a0,a0,1962 # 6740 <malloc+0x716>
     f9e:	00005097          	auipc	ra,0x5
     fa2:	c96080e7          	jalr	-874(ra) # 5c34 <open>
     fa6:	0e055e63          	bgez	a0,10a2 <linktest+0x1a4>
  fd = open("lf2", 0);
     faa:	4581                	li	a1,0
     fac:	00005517          	auipc	a0,0x5
     fb0:	79c50513          	addi	a0,a0,1948 # 6748 <malloc+0x71e>
     fb4:	00005097          	auipc	ra,0x5
     fb8:	c80080e7          	jalr	-896(ra) # 5c34 <open>
     fbc:	84aa                	mv	s1,a0
  if(fd < 0){
     fbe:	10054063          	bltz	a0,10be <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fc2:	660d                	lui	a2,0x3
     fc4:	0000c597          	auipc	a1,0xc
     fc8:	cb458593          	addi	a1,a1,-844 # cc78 <buf>
     fcc:	00005097          	auipc	ra,0x5
     fd0:	c40080e7          	jalr	-960(ra) # 5c0c <read>
     fd4:	4795                	li	a5,5
     fd6:	10f51263          	bne	a0,a5,10da <linktest+0x1dc>
  close(fd);
     fda:	8526                	mv	a0,s1
     fdc:	00005097          	auipc	ra,0x5
     fe0:	c40080e7          	jalr	-960(ra) # 5c1c <close>
  if(link("lf2", "lf2") >= 0){
     fe4:	00005597          	auipc	a1,0x5
     fe8:	76458593          	addi	a1,a1,1892 # 6748 <malloc+0x71e>
     fec:	852e                	mv	a0,a1
     fee:	00005097          	auipc	ra,0x5
     ff2:	c66080e7          	jalr	-922(ra) # 5c54 <link>
     ff6:	10055063          	bgez	a0,10f6 <linktest+0x1f8>
  unlink("lf2");
     ffa:	00005517          	auipc	a0,0x5
     ffe:	74e50513          	addi	a0,a0,1870 # 6748 <malloc+0x71e>
    1002:	00005097          	auipc	ra,0x5
    1006:	c42080e7          	jalr	-958(ra) # 5c44 <unlink>
  if(link("lf2", "lf1") >= 0){
    100a:	00005597          	auipc	a1,0x5
    100e:	73658593          	addi	a1,a1,1846 # 6740 <malloc+0x716>
    1012:	00005517          	auipc	a0,0x5
    1016:	73650513          	addi	a0,a0,1846 # 6748 <malloc+0x71e>
    101a:	00005097          	auipc	ra,0x5
    101e:	c3a080e7          	jalr	-966(ra) # 5c54 <link>
    1022:	0e055863          	bgez	a0,1112 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    1026:	00005597          	auipc	a1,0x5
    102a:	71a58593          	addi	a1,a1,1818 # 6740 <malloc+0x716>
    102e:	00006517          	auipc	a0,0x6
    1032:	82250513          	addi	a0,a0,-2014 # 6850 <malloc+0x826>
    1036:	00005097          	auipc	ra,0x5
    103a:	c1e080e7          	jalr	-994(ra) # 5c54 <link>
    103e:	0e055863          	bgez	a0,112e <linktest+0x230>
}
    1042:	60e2                	ld	ra,24(sp)
    1044:	6442                	ld	s0,16(sp)
    1046:	64a2                	ld	s1,8(sp)
    1048:	6902                	ld	s2,0(sp)
    104a:	6105                	addi	sp,sp,32
    104c:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    104e:	85ca                	mv	a1,s2
    1050:	00005517          	auipc	a0,0x5
    1054:	70050513          	addi	a0,a0,1792 # 6750 <malloc+0x726>
    1058:	00005097          	auipc	ra,0x5
    105c:	f14080e7          	jalr	-236(ra) # 5f6c <printf>
    exit(1);
    1060:	4505                	li	a0,1
    1062:	00005097          	auipc	ra,0x5
    1066:	b92080e7          	jalr	-1134(ra) # 5bf4 <exit>
    printf("%s: write lf1 failed\n", s);
    106a:	85ca                	mv	a1,s2
    106c:	00005517          	auipc	a0,0x5
    1070:	6fc50513          	addi	a0,a0,1788 # 6768 <malloc+0x73e>
    1074:	00005097          	auipc	ra,0x5
    1078:	ef8080e7          	jalr	-264(ra) # 5f6c <printf>
    exit(1);
    107c:	4505                	li	a0,1
    107e:	00005097          	auipc	ra,0x5
    1082:	b76080e7          	jalr	-1162(ra) # 5bf4 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    1086:	85ca                	mv	a1,s2
    1088:	00005517          	auipc	a0,0x5
    108c:	6f850513          	addi	a0,a0,1784 # 6780 <malloc+0x756>
    1090:	00005097          	auipc	ra,0x5
    1094:	edc080e7          	jalr	-292(ra) # 5f6c <printf>
    exit(1);
    1098:	4505                	li	a0,1
    109a:	00005097          	auipc	ra,0x5
    109e:	b5a080e7          	jalr	-1190(ra) # 5bf4 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    10a2:	85ca                	mv	a1,s2
    10a4:	00005517          	auipc	a0,0x5
    10a8:	6fc50513          	addi	a0,a0,1788 # 67a0 <malloc+0x776>
    10ac:	00005097          	auipc	ra,0x5
    10b0:	ec0080e7          	jalr	-320(ra) # 5f6c <printf>
    exit(1);
    10b4:	4505                	li	a0,1
    10b6:	00005097          	auipc	ra,0x5
    10ba:	b3e080e7          	jalr	-1218(ra) # 5bf4 <exit>
    printf("%s: open lf2 failed\n", s);
    10be:	85ca                	mv	a1,s2
    10c0:	00005517          	auipc	a0,0x5
    10c4:	71050513          	addi	a0,a0,1808 # 67d0 <malloc+0x7a6>
    10c8:	00005097          	auipc	ra,0x5
    10cc:	ea4080e7          	jalr	-348(ra) # 5f6c <printf>
    exit(1);
    10d0:	4505                	li	a0,1
    10d2:	00005097          	auipc	ra,0x5
    10d6:	b22080e7          	jalr	-1246(ra) # 5bf4 <exit>
    printf("%s: read lf2 failed\n", s);
    10da:	85ca                	mv	a1,s2
    10dc:	00005517          	auipc	a0,0x5
    10e0:	70c50513          	addi	a0,a0,1804 # 67e8 <malloc+0x7be>
    10e4:	00005097          	auipc	ra,0x5
    10e8:	e88080e7          	jalr	-376(ra) # 5f6c <printf>
    exit(1);
    10ec:	4505                	li	a0,1
    10ee:	00005097          	auipc	ra,0x5
    10f2:	b06080e7          	jalr	-1274(ra) # 5bf4 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10f6:	85ca                	mv	a1,s2
    10f8:	00005517          	auipc	a0,0x5
    10fc:	70850513          	addi	a0,a0,1800 # 6800 <malloc+0x7d6>
    1100:	00005097          	auipc	ra,0x5
    1104:	e6c080e7          	jalr	-404(ra) # 5f6c <printf>
    exit(1);
    1108:	4505                	li	a0,1
    110a:	00005097          	auipc	ra,0x5
    110e:	aea080e7          	jalr	-1302(ra) # 5bf4 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1112:	85ca                	mv	a1,s2
    1114:	00005517          	auipc	a0,0x5
    1118:	71450513          	addi	a0,a0,1812 # 6828 <malloc+0x7fe>
    111c:	00005097          	auipc	ra,0x5
    1120:	e50080e7          	jalr	-432(ra) # 5f6c <printf>
    exit(1);
    1124:	4505                	li	a0,1
    1126:	00005097          	auipc	ra,0x5
    112a:	ace080e7          	jalr	-1330(ra) # 5bf4 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    112e:	85ca                	mv	a1,s2
    1130:	00005517          	auipc	a0,0x5
    1134:	72850513          	addi	a0,a0,1832 # 6858 <malloc+0x82e>
    1138:	00005097          	auipc	ra,0x5
    113c:	e34080e7          	jalr	-460(ra) # 5f6c <printf>
    exit(1);
    1140:	4505                	li	a0,1
    1142:	00005097          	auipc	ra,0x5
    1146:	ab2080e7          	jalr	-1358(ra) # 5bf4 <exit>

000000000000114a <validatetest>:
{
    114a:	7139                	addi	sp,sp,-64
    114c:	fc06                	sd	ra,56(sp)
    114e:	f822                	sd	s0,48(sp)
    1150:	f426                	sd	s1,40(sp)
    1152:	f04a                	sd	s2,32(sp)
    1154:	ec4e                	sd	s3,24(sp)
    1156:	e852                	sd	s4,16(sp)
    1158:	e456                	sd	s5,8(sp)
    115a:	e05a                	sd	s6,0(sp)
    115c:	0080                	addi	s0,sp,64
    115e:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1160:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1162:	00005997          	auipc	s3,0x5
    1166:	71698993          	addi	s3,s3,1814 # 6878 <malloc+0x84e>
    116a:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    116c:	6a85                	lui	s5,0x1
    116e:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1172:	85a6                	mv	a1,s1
    1174:	854e                	mv	a0,s3
    1176:	00005097          	auipc	ra,0x5
    117a:	ade080e7          	jalr	-1314(ra) # 5c54 <link>
    117e:	01251f63          	bne	a0,s2,119c <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1182:	94d6                	add	s1,s1,s5
    1184:	ff4497e3          	bne	s1,s4,1172 <validatetest+0x28>
}
    1188:	70e2                	ld	ra,56(sp)
    118a:	7442                	ld	s0,48(sp)
    118c:	74a2                	ld	s1,40(sp)
    118e:	7902                	ld	s2,32(sp)
    1190:	69e2                	ld	s3,24(sp)
    1192:	6a42                	ld	s4,16(sp)
    1194:	6aa2                	ld	s5,8(sp)
    1196:	6b02                	ld	s6,0(sp)
    1198:	6121                	addi	sp,sp,64
    119a:	8082                	ret
      printf("%s: link should not succeed\n", s);
    119c:	85da                	mv	a1,s6
    119e:	00005517          	auipc	a0,0x5
    11a2:	6ea50513          	addi	a0,a0,1770 # 6888 <malloc+0x85e>
    11a6:	00005097          	auipc	ra,0x5
    11aa:	dc6080e7          	jalr	-570(ra) # 5f6c <printf>
      exit(1);
    11ae:	4505                	li	a0,1
    11b0:	00005097          	auipc	ra,0x5
    11b4:	a44080e7          	jalr	-1468(ra) # 5bf4 <exit>

00000000000011b8 <bigdir>:
{
    11b8:	715d                	addi	sp,sp,-80
    11ba:	e486                	sd	ra,72(sp)
    11bc:	e0a2                	sd	s0,64(sp)
    11be:	fc26                	sd	s1,56(sp)
    11c0:	f84a                	sd	s2,48(sp)
    11c2:	f44e                	sd	s3,40(sp)
    11c4:	f052                	sd	s4,32(sp)
    11c6:	ec56                	sd	s5,24(sp)
    11c8:	e85a                	sd	s6,16(sp)
    11ca:	0880                	addi	s0,sp,80
    11cc:	89aa                	mv	s3,a0
  unlink("bd");
    11ce:	00005517          	auipc	a0,0x5
    11d2:	6da50513          	addi	a0,a0,1754 # 68a8 <malloc+0x87e>
    11d6:	00005097          	auipc	ra,0x5
    11da:	a6e080e7          	jalr	-1426(ra) # 5c44 <unlink>
  fd = open("bd", O_CREATE);
    11de:	20000593          	li	a1,512
    11e2:	00005517          	auipc	a0,0x5
    11e6:	6c650513          	addi	a0,a0,1734 # 68a8 <malloc+0x87e>
    11ea:	00005097          	auipc	ra,0x5
    11ee:	a4a080e7          	jalr	-1462(ra) # 5c34 <open>
  if(fd < 0){
    11f2:	0c054963          	bltz	a0,12c4 <bigdir+0x10c>
  close(fd);
    11f6:	00005097          	auipc	ra,0x5
    11fa:	a26080e7          	jalr	-1498(ra) # 5c1c <close>
  for(i = 0; i < N; i++){
    11fe:	4901                	li	s2,0
    name[0] = 'x';
    1200:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    1204:	00005a17          	auipc	s4,0x5
    1208:	6a4a0a13          	addi	s4,s4,1700 # 68a8 <malloc+0x87e>
  for(i = 0; i < N; i++){
    120c:	1f400b13          	li	s6,500
    name[0] = 'x';
    1210:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    1214:	41f9579b          	sraiw	a5,s2,0x1f
    1218:	01a7d71b          	srliw	a4,a5,0x1a
    121c:	012707bb          	addw	a5,a4,s2
    1220:	4067d69b          	sraiw	a3,a5,0x6
    1224:	0306869b          	addiw	a3,a3,48
    1228:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    122c:	03f7f793          	andi	a5,a5,63
    1230:	9f99                	subw	a5,a5,a4
    1232:	0307879b          	addiw	a5,a5,48
    1236:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    123a:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    123e:	fb040593          	addi	a1,s0,-80
    1242:	8552                	mv	a0,s4
    1244:	00005097          	auipc	ra,0x5
    1248:	a10080e7          	jalr	-1520(ra) # 5c54 <link>
    124c:	84aa                	mv	s1,a0
    124e:	e949                	bnez	a0,12e0 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1250:	2905                	addiw	s2,s2,1
    1252:	fb691fe3          	bne	s2,s6,1210 <bigdir+0x58>
  unlink("bd");
    1256:	00005517          	auipc	a0,0x5
    125a:	65250513          	addi	a0,a0,1618 # 68a8 <malloc+0x87e>
    125e:	00005097          	auipc	ra,0x5
    1262:	9e6080e7          	jalr	-1562(ra) # 5c44 <unlink>
    name[0] = 'x';
    1266:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    126a:	1f400a13          	li	s4,500
    name[0] = 'x';
    126e:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1272:	41f4d79b          	sraiw	a5,s1,0x1f
    1276:	01a7d71b          	srliw	a4,a5,0x1a
    127a:	009707bb          	addw	a5,a4,s1
    127e:	4067d69b          	sraiw	a3,a5,0x6
    1282:	0306869b          	addiw	a3,a3,48
    1286:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    128a:	03f7f793          	andi	a5,a5,63
    128e:	9f99                	subw	a5,a5,a4
    1290:	0307879b          	addiw	a5,a5,48
    1294:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1298:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    129c:	fb040513          	addi	a0,s0,-80
    12a0:	00005097          	auipc	ra,0x5
    12a4:	9a4080e7          	jalr	-1628(ra) # 5c44 <unlink>
    12a8:	ed21                	bnez	a0,1300 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12aa:	2485                	addiw	s1,s1,1
    12ac:	fd4491e3          	bne	s1,s4,126e <bigdir+0xb6>
}
    12b0:	60a6                	ld	ra,72(sp)
    12b2:	6406                	ld	s0,64(sp)
    12b4:	74e2                	ld	s1,56(sp)
    12b6:	7942                	ld	s2,48(sp)
    12b8:	79a2                	ld	s3,40(sp)
    12ba:	7a02                	ld	s4,32(sp)
    12bc:	6ae2                	ld	s5,24(sp)
    12be:	6b42                	ld	s6,16(sp)
    12c0:	6161                	addi	sp,sp,80
    12c2:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12c4:	85ce                	mv	a1,s3
    12c6:	00005517          	auipc	a0,0x5
    12ca:	5ea50513          	addi	a0,a0,1514 # 68b0 <malloc+0x886>
    12ce:	00005097          	auipc	ra,0x5
    12d2:	c9e080e7          	jalr	-866(ra) # 5f6c <printf>
    exit(1);
    12d6:	4505                	li	a0,1
    12d8:	00005097          	auipc	ra,0x5
    12dc:	91c080e7          	jalr	-1764(ra) # 5bf4 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12e0:	fb040613          	addi	a2,s0,-80
    12e4:	85ce                	mv	a1,s3
    12e6:	00005517          	auipc	a0,0x5
    12ea:	5ea50513          	addi	a0,a0,1514 # 68d0 <malloc+0x8a6>
    12ee:	00005097          	auipc	ra,0x5
    12f2:	c7e080e7          	jalr	-898(ra) # 5f6c <printf>
      exit(1);
    12f6:	4505                	li	a0,1
    12f8:	00005097          	auipc	ra,0x5
    12fc:	8fc080e7          	jalr	-1796(ra) # 5bf4 <exit>
      printf("%s: bigdir unlink failed", s);
    1300:	85ce                	mv	a1,s3
    1302:	00005517          	auipc	a0,0x5
    1306:	5ee50513          	addi	a0,a0,1518 # 68f0 <malloc+0x8c6>
    130a:	00005097          	auipc	ra,0x5
    130e:	c62080e7          	jalr	-926(ra) # 5f6c <printf>
      exit(1);
    1312:	4505                	li	a0,1
    1314:	00005097          	auipc	ra,0x5
    1318:	8e0080e7          	jalr	-1824(ra) # 5bf4 <exit>

000000000000131c <pgbug>:
{
    131c:	7179                	addi	sp,sp,-48
    131e:	f406                	sd	ra,40(sp)
    1320:	f022                	sd	s0,32(sp)
    1322:	ec26                	sd	s1,24(sp)
    1324:	1800                	addi	s0,sp,48
  argv[0] = 0;
    1326:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    132a:	00008497          	auipc	s1,0x8
    132e:	cd648493          	addi	s1,s1,-810 # 9000 <big>
    1332:	fd840593          	addi	a1,s0,-40
    1336:	6088                	ld	a0,0(s1)
    1338:	00005097          	auipc	ra,0x5
    133c:	8f4080e7          	jalr	-1804(ra) # 5c2c <exec>
  pipe(big);
    1340:	6088                	ld	a0,0(s1)
    1342:	00005097          	auipc	ra,0x5
    1346:	8c2080e7          	jalr	-1854(ra) # 5c04 <pipe>
  exit(0);
    134a:	4501                	li	a0,0
    134c:	00005097          	auipc	ra,0x5
    1350:	8a8080e7          	jalr	-1880(ra) # 5bf4 <exit>

0000000000001354 <badarg>:
{
    1354:	7139                	addi	sp,sp,-64
    1356:	fc06                	sd	ra,56(sp)
    1358:	f822                	sd	s0,48(sp)
    135a:	f426                	sd	s1,40(sp)
    135c:	f04a                	sd	s2,32(sp)
    135e:	ec4e                	sd	s3,24(sp)
    1360:	0080                	addi	s0,sp,64
    1362:	64b1                	lui	s1,0xc
    1364:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1368:	597d                	li	s2,-1
    136a:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    136e:	00005997          	auipc	s3,0x5
    1372:	dfa98993          	addi	s3,s3,-518 # 6168 <malloc+0x13e>
    argv[0] = (char*)0xffffffff;
    1376:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    137a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    137e:	fc040593          	addi	a1,s0,-64
    1382:	854e                	mv	a0,s3
    1384:	00005097          	auipc	ra,0x5
    1388:	8a8080e7          	jalr	-1880(ra) # 5c2c <exec>
  for(int i = 0; i < 50000; i++){
    138c:	34fd                	addiw	s1,s1,-1
    138e:	f4e5                	bnez	s1,1376 <badarg+0x22>
  exit(0);
    1390:	4501                	li	a0,0
    1392:	00005097          	auipc	ra,0x5
    1396:	862080e7          	jalr	-1950(ra) # 5bf4 <exit>

000000000000139a <copyinstr2>:
{
    139a:	7155                	addi	sp,sp,-208
    139c:	e586                	sd	ra,200(sp)
    139e:	e1a2                	sd	s0,192(sp)
    13a0:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    13a2:	f6840793          	addi	a5,s0,-152
    13a6:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13aa:	07800713          	li	a4,120
    13ae:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13b2:	0785                	addi	a5,a5,1
    13b4:	fed79de3          	bne	a5,a3,13ae <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13b8:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13bc:	f6840513          	addi	a0,s0,-152
    13c0:	00005097          	auipc	ra,0x5
    13c4:	884080e7          	jalr	-1916(ra) # 5c44 <unlink>
  if(ret != -1){
    13c8:	57fd                	li	a5,-1
    13ca:	0ef51063          	bne	a0,a5,14aa <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13ce:	20100593          	li	a1,513
    13d2:	f6840513          	addi	a0,s0,-152
    13d6:	00005097          	auipc	ra,0x5
    13da:	85e080e7          	jalr	-1954(ra) # 5c34 <open>
  if(fd != -1){
    13de:	57fd                	li	a5,-1
    13e0:	0ef51563          	bne	a0,a5,14ca <copyinstr2+0x130>
  ret = link(b, b);
    13e4:	f6840593          	addi	a1,s0,-152
    13e8:	852e                	mv	a0,a1
    13ea:	00005097          	auipc	ra,0x5
    13ee:	86a080e7          	jalr	-1942(ra) # 5c54 <link>
  if(ret != -1){
    13f2:	57fd                	li	a5,-1
    13f4:	0ef51b63          	bne	a0,a5,14ea <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13f8:	00006797          	auipc	a5,0x6
    13fc:	75078793          	addi	a5,a5,1872 # 7b48 <malloc+0x1b1e>
    1400:	f4f43c23          	sd	a5,-168(s0)
    1404:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1408:	f5840593          	addi	a1,s0,-168
    140c:	f6840513          	addi	a0,s0,-152
    1410:	00005097          	auipc	ra,0x5
    1414:	81c080e7          	jalr	-2020(ra) # 5c2c <exec>
  if(ret != -1){
    1418:	57fd                	li	a5,-1
    141a:	0ef51963          	bne	a0,a5,150c <copyinstr2+0x172>
  int pid = fork();
    141e:	00004097          	auipc	ra,0x4
    1422:	7ce080e7          	jalr	1998(ra) # 5bec <fork>
  if(pid < 0){
    1426:	10054363          	bltz	a0,152c <copyinstr2+0x192>
  if(pid == 0){
    142a:	12051463          	bnez	a0,1552 <copyinstr2+0x1b8>
    142e:	00008797          	auipc	a5,0x8
    1432:	13278793          	addi	a5,a5,306 # 9560 <big.0>
    1436:	00009697          	auipc	a3,0x9
    143a:	12a68693          	addi	a3,a3,298 # a560 <big.0+0x1000>
      big[i] = 'x';
    143e:	07800713          	li	a4,120
    1442:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1446:	0785                	addi	a5,a5,1
    1448:	fed79de3          	bne	a5,a3,1442 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    144c:	00009797          	auipc	a5,0x9
    1450:	10078a23          	sb	zero,276(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    1454:	00007797          	auipc	a5,0x7
    1458:	11478793          	addi	a5,a5,276 # 8568 <malloc+0x253e>
    145c:	6390                	ld	a2,0(a5)
    145e:	6794                	ld	a3,8(a5)
    1460:	6b98                	ld	a4,16(a5)
    1462:	6f9c                	ld	a5,24(a5)
    1464:	f2c43823          	sd	a2,-208(s0)
    1468:	f2d43c23          	sd	a3,-200(s0)
    146c:	f4e43023          	sd	a4,-192(s0)
    1470:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1474:	f3040593          	addi	a1,s0,-208
    1478:	00005517          	auipc	a0,0x5
    147c:	cf050513          	addi	a0,a0,-784 # 6168 <malloc+0x13e>
    1480:	00004097          	auipc	ra,0x4
    1484:	7ac080e7          	jalr	1964(ra) # 5c2c <exec>
    if(ret != -1){
    1488:	57fd                	li	a5,-1
    148a:	0af50e63          	beq	a0,a5,1546 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    148e:	55fd                	li	a1,-1
    1490:	00005517          	auipc	a0,0x5
    1494:	50850513          	addi	a0,a0,1288 # 6998 <malloc+0x96e>
    1498:	00005097          	auipc	ra,0x5
    149c:	ad4080e7          	jalr	-1324(ra) # 5f6c <printf>
      exit(1);
    14a0:	4505                	li	a0,1
    14a2:	00004097          	auipc	ra,0x4
    14a6:	752080e7          	jalr	1874(ra) # 5bf4 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14aa:	862a                	mv	a2,a0
    14ac:	f6840593          	addi	a1,s0,-152
    14b0:	00005517          	auipc	a0,0x5
    14b4:	46050513          	addi	a0,a0,1120 # 6910 <malloc+0x8e6>
    14b8:	00005097          	auipc	ra,0x5
    14bc:	ab4080e7          	jalr	-1356(ra) # 5f6c <printf>
    exit(1);
    14c0:	4505                	li	a0,1
    14c2:	00004097          	auipc	ra,0x4
    14c6:	732080e7          	jalr	1842(ra) # 5bf4 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14ca:	862a                	mv	a2,a0
    14cc:	f6840593          	addi	a1,s0,-152
    14d0:	00005517          	auipc	a0,0x5
    14d4:	46050513          	addi	a0,a0,1120 # 6930 <malloc+0x906>
    14d8:	00005097          	auipc	ra,0x5
    14dc:	a94080e7          	jalr	-1388(ra) # 5f6c <printf>
    exit(1);
    14e0:	4505                	li	a0,1
    14e2:	00004097          	auipc	ra,0x4
    14e6:	712080e7          	jalr	1810(ra) # 5bf4 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14ea:	86aa                	mv	a3,a0
    14ec:	f6840613          	addi	a2,s0,-152
    14f0:	85b2                	mv	a1,a2
    14f2:	00005517          	auipc	a0,0x5
    14f6:	45e50513          	addi	a0,a0,1118 # 6950 <malloc+0x926>
    14fa:	00005097          	auipc	ra,0x5
    14fe:	a72080e7          	jalr	-1422(ra) # 5f6c <printf>
    exit(1);
    1502:	4505                	li	a0,1
    1504:	00004097          	auipc	ra,0x4
    1508:	6f0080e7          	jalr	1776(ra) # 5bf4 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    150c:	567d                	li	a2,-1
    150e:	f6840593          	addi	a1,s0,-152
    1512:	00005517          	auipc	a0,0x5
    1516:	46650513          	addi	a0,a0,1126 # 6978 <malloc+0x94e>
    151a:	00005097          	auipc	ra,0x5
    151e:	a52080e7          	jalr	-1454(ra) # 5f6c <printf>
    exit(1);
    1522:	4505                	li	a0,1
    1524:	00004097          	auipc	ra,0x4
    1528:	6d0080e7          	jalr	1744(ra) # 5bf4 <exit>
    printf("fork failed\n");
    152c:	00006517          	auipc	a0,0x6
    1530:	8cc50513          	addi	a0,a0,-1844 # 6df8 <malloc+0xdce>
    1534:	00005097          	auipc	ra,0x5
    1538:	a38080e7          	jalr	-1480(ra) # 5f6c <printf>
    exit(1);
    153c:	4505                	li	a0,1
    153e:	00004097          	auipc	ra,0x4
    1542:	6b6080e7          	jalr	1718(ra) # 5bf4 <exit>
    exit(747); // OK
    1546:	2eb00513          	li	a0,747
    154a:	00004097          	auipc	ra,0x4
    154e:	6aa080e7          	jalr	1706(ra) # 5bf4 <exit>
  int st = 0;
    1552:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1556:	f5440513          	addi	a0,s0,-172
    155a:	00004097          	auipc	ra,0x4
    155e:	6a2080e7          	jalr	1698(ra) # 5bfc <wait>
  if(st != 747){
    1562:	f5442703          	lw	a4,-172(s0)
    1566:	2eb00793          	li	a5,747
    156a:	00f71663          	bne	a4,a5,1576 <copyinstr2+0x1dc>
}
    156e:	60ae                	ld	ra,200(sp)
    1570:	640e                	ld	s0,192(sp)
    1572:	6169                	addi	sp,sp,208
    1574:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1576:	00005517          	auipc	a0,0x5
    157a:	44a50513          	addi	a0,a0,1098 # 69c0 <malloc+0x996>
    157e:	00005097          	auipc	ra,0x5
    1582:	9ee080e7          	jalr	-1554(ra) # 5f6c <printf>
    exit(1);
    1586:	4505                	li	a0,1
    1588:	00004097          	auipc	ra,0x4
    158c:	66c080e7          	jalr	1644(ra) # 5bf4 <exit>

0000000000001590 <truncate3>:
{
    1590:	7159                	addi	sp,sp,-112
    1592:	f486                	sd	ra,104(sp)
    1594:	f0a2                	sd	s0,96(sp)
    1596:	eca6                	sd	s1,88(sp)
    1598:	e8ca                	sd	s2,80(sp)
    159a:	e4ce                	sd	s3,72(sp)
    159c:	e0d2                	sd	s4,64(sp)
    159e:	fc56                	sd	s5,56(sp)
    15a0:	1880                	addi	s0,sp,112
    15a2:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    15a4:	60100593          	li	a1,1537
    15a8:	00005517          	auipc	a0,0x5
    15ac:	c1850513          	addi	a0,a0,-1000 # 61c0 <malloc+0x196>
    15b0:	00004097          	auipc	ra,0x4
    15b4:	684080e7          	jalr	1668(ra) # 5c34 <open>
    15b8:	00004097          	auipc	ra,0x4
    15bc:	664080e7          	jalr	1636(ra) # 5c1c <close>
  pid = fork();
    15c0:	00004097          	auipc	ra,0x4
    15c4:	62c080e7          	jalr	1580(ra) # 5bec <fork>
  if(pid < 0){
    15c8:	08054063          	bltz	a0,1648 <truncate3+0xb8>
  if(pid == 0){
    15cc:	e969                	bnez	a0,169e <truncate3+0x10e>
    15ce:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15d2:	00005a17          	auipc	s4,0x5
    15d6:	beea0a13          	addi	s4,s4,-1042 # 61c0 <malloc+0x196>
      int n = write(fd, "1234567890", 10);
    15da:	00005a97          	auipc	s5,0x5
    15de:	446a8a93          	addi	s5,s5,1094 # 6a20 <malloc+0x9f6>
      int fd = open("truncfile", O_WRONLY);
    15e2:	4585                	li	a1,1
    15e4:	8552                	mv	a0,s4
    15e6:	00004097          	auipc	ra,0x4
    15ea:	64e080e7          	jalr	1614(ra) # 5c34 <open>
    15ee:	84aa                	mv	s1,a0
      if(fd < 0){
    15f0:	06054a63          	bltz	a0,1664 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15f4:	4629                	li	a2,10
    15f6:	85d6                	mv	a1,s5
    15f8:	00004097          	auipc	ra,0x4
    15fc:	61c080e7          	jalr	1564(ra) # 5c14 <write>
      if(n != 10){
    1600:	47a9                	li	a5,10
    1602:	06f51f63          	bne	a0,a5,1680 <truncate3+0xf0>
      close(fd);
    1606:	8526                	mv	a0,s1
    1608:	00004097          	auipc	ra,0x4
    160c:	614080e7          	jalr	1556(ra) # 5c1c <close>
      fd = open("truncfile", O_RDONLY);
    1610:	4581                	li	a1,0
    1612:	8552                	mv	a0,s4
    1614:	00004097          	auipc	ra,0x4
    1618:	620080e7          	jalr	1568(ra) # 5c34 <open>
    161c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    161e:	02000613          	li	a2,32
    1622:	f9840593          	addi	a1,s0,-104
    1626:	00004097          	auipc	ra,0x4
    162a:	5e6080e7          	jalr	1510(ra) # 5c0c <read>
      close(fd);
    162e:	8526                	mv	a0,s1
    1630:	00004097          	auipc	ra,0x4
    1634:	5ec080e7          	jalr	1516(ra) # 5c1c <close>
    for(int i = 0; i < 100; i++){
    1638:	39fd                	addiw	s3,s3,-1
    163a:	fa0994e3          	bnez	s3,15e2 <truncate3+0x52>
    exit(0);
    163e:	4501                	li	a0,0
    1640:	00004097          	auipc	ra,0x4
    1644:	5b4080e7          	jalr	1460(ra) # 5bf4 <exit>
    printf("%s: fork failed\n", s);
    1648:	85ca                	mv	a1,s2
    164a:	00005517          	auipc	a0,0x5
    164e:	3a650513          	addi	a0,a0,934 # 69f0 <malloc+0x9c6>
    1652:	00005097          	auipc	ra,0x5
    1656:	91a080e7          	jalr	-1766(ra) # 5f6c <printf>
    exit(1);
    165a:	4505                	li	a0,1
    165c:	00004097          	auipc	ra,0x4
    1660:	598080e7          	jalr	1432(ra) # 5bf4 <exit>
        printf("%s: open failed\n", s);
    1664:	85ca                	mv	a1,s2
    1666:	00005517          	auipc	a0,0x5
    166a:	3a250513          	addi	a0,a0,930 # 6a08 <malloc+0x9de>
    166e:	00005097          	auipc	ra,0x5
    1672:	8fe080e7          	jalr	-1794(ra) # 5f6c <printf>
        exit(1);
    1676:	4505                	li	a0,1
    1678:	00004097          	auipc	ra,0x4
    167c:	57c080e7          	jalr	1404(ra) # 5bf4 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1680:	862a                	mv	a2,a0
    1682:	85ca                	mv	a1,s2
    1684:	00005517          	auipc	a0,0x5
    1688:	3ac50513          	addi	a0,a0,940 # 6a30 <malloc+0xa06>
    168c:	00005097          	auipc	ra,0x5
    1690:	8e0080e7          	jalr	-1824(ra) # 5f6c <printf>
        exit(1);
    1694:	4505                	li	a0,1
    1696:	00004097          	auipc	ra,0x4
    169a:	55e080e7          	jalr	1374(ra) # 5bf4 <exit>
    169e:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16a2:	00005a17          	auipc	s4,0x5
    16a6:	b1ea0a13          	addi	s4,s4,-1250 # 61c0 <malloc+0x196>
    int n = write(fd, "xxx", 3);
    16aa:	00005a97          	auipc	s5,0x5
    16ae:	3a6a8a93          	addi	s5,s5,934 # 6a50 <malloc+0xa26>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16b2:	60100593          	li	a1,1537
    16b6:	8552                	mv	a0,s4
    16b8:	00004097          	auipc	ra,0x4
    16bc:	57c080e7          	jalr	1404(ra) # 5c34 <open>
    16c0:	84aa                	mv	s1,a0
    if(fd < 0){
    16c2:	04054763          	bltz	a0,1710 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16c6:	460d                	li	a2,3
    16c8:	85d6                	mv	a1,s5
    16ca:	00004097          	auipc	ra,0x4
    16ce:	54a080e7          	jalr	1354(ra) # 5c14 <write>
    if(n != 3){
    16d2:	478d                	li	a5,3
    16d4:	04f51c63          	bne	a0,a5,172c <truncate3+0x19c>
    close(fd);
    16d8:	8526                	mv	a0,s1
    16da:	00004097          	auipc	ra,0x4
    16de:	542080e7          	jalr	1346(ra) # 5c1c <close>
  for(int i = 0; i < 150; i++){
    16e2:	39fd                	addiw	s3,s3,-1
    16e4:	fc0997e3          	bnez	s3,16b2 <truncate3+0x122>
  wait(&xstatus);
    16e8:	fbc40513          	addi	a0,s0,-68
    16ec:	00004097          	auipc	ra,0x4
    16f0:	510080e7          	jalr	1296(ra) # 5bfc <wait>
  unlink("truncfile");
    16f4:	00005517          	auipc	a0,0x5
    16f8:	acc50513          	addi	a0,a0,-1332 # 61c0 <malloc+0x196>
    16fc:	00004097          	auipc	ra,0x4
    1700:	548080e7          	jalr	1352(ra) # 5c44 <unlink>
  exit(xstatus);
    1704:	fbc42503          	lw	a0,-68(s0)
    1708:	00004097          	auipc	ra,0x4
    170c:	4ec080e7          	jalr	1260(ra) # 5bf4 <exit>
      printf("%s: open failed\n", s);
    1710:	85ca                	mv	a1,s2
    1712:	00005517          	auipc	a0,0x5
    1716:	2f650513          	addi	a0,a0,758 # 6a08 <malloc+0x9de>
    171a:	00005097          	auipc	ra,0x5
    171e:	852080e7          	jalr	-1966(ra) # 5f6c <printf>
      exit(1);
    1722:	4505                	li	a0,1
    1724:	00004097          	auipc	ra,0x4
    1728:	4d0080e7          	jalr	1232(ra) # 5bf4 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    172c:	862a                	mv	a2,a0
    172e:	85ca                	mv	a1,s2
    1730:	00005517          	auipc	a0,0x5
    1734:	32850513          	addi	a0,a0,808 # 6a58 <malloc+0xa2e>
    1738:	00005097          	auipc	ra,0x5
    173c:	834080e7          	jalr	-1996(ra) # 5f6c <printf>
      exit(1);
    1740:	4505                	li	a0,1
    1742:	00004097          	auipc	ra,0x4
    1746:	4b2080e7          	jalr	1202(ra) # 5bf4 <exit>

000000000000174a <exectest>:
{
    174a:	715d                	addi	sp,sp,-80
    174c:	e486                	sd	ra,72(sp)
    174e:	e0a2                	sd	s0,64(sp)
    1750:	fc26                	sd	s1,56(sp)
    1752:	f84a                	sd	s2,48(sp)
    1754:	0880                	addi	s0,sp,80
    1756:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1758:	00005797          	auipc	a5,0x5
    175c:	a1078793          	addi	a5,a5,-1520 # 6168 <malloc+0x13e>
    1760:	fcf43023          	sd	a5,-64(s0)
    1764:	00005797          	auipc	a5,0x5
    1768:	31478793          	addi	a5,a5,788 # 6a78 <malloc+0xa4e>
    176c:	fcf43423          	sd	a5,-56(s0)
    1770:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1774:	00005517          	auipc	a0,0x5
    1778:	30c50513          	addi	a0,a0,780 # 6a80 <malloc+0xa56>
    177c:	00004097          	auipc	ra,0x4
    1780:	4c8080e7          	jalr	1224(ra) # 5c44 <unlink>
  pid = fork();
    1784:	00004097          	auipc	ra,0x4
    1788:	468080e7          	jalr	1128(ra) # 5bec <fork>
  if(pid < 0) {
    178c:	04054663          	bltz	a0,17d8 <exectest+0x8e>
    1790:	84aa                	mv	s1,a0
  if(pid == 0) {
    1792:	e959                	bnez	a0,1828 <exectest+0xde>
    close(1);
    1794:	4505                	li	a0,1
    1796:	00004097          	auipc	ra,0x4
    179a:	486080e7          	jalr	1158(ra) # 5c1c <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    179e:	20100593          	li	a1,513
    17a2:	00005517          	auipc	a0,0x5
    17a6:	2de50513          	addi	a0,a0,734 # 6a80 <malloc+0xa56>
    17aa:	00004097          	auipc	ra,0x4
    17ae:	48a080e7          	jalr	1162(ra) # 5c34 <open>
    if(fd < 0) {
    17b2:	04054163          	bltz	a0,17f4 <exectest+0xaa>
    if(fd != 1) {
    17b6:	4785                	li	a5,1
    17b8:	04f50c63          	beq	a0,a5,1810 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17bc:	85ca                	mv	a1,s2
    17be:	00005517          	auipc	a0,0x5
    17c2:	2e250513          	addi	a0,a0,738 # 6aa0 <malloc+0xa76>
    17c6:	00004097          	auipc	ra,0x4
    17ca:	7a6080e7          	jalr	1958(ra) # 5f6c <printf>
      exit(1);
    17ce:	4505                	li	a0,1
    17d0:	00004097          	auipc	ra,0x4
    17d4:	424080e7          	jalr	1060(ra) # 5bf4 <exit>
     printf("%s: fork failed\n", s);
    17d8:	85ca                	mv	a1,s2
    17da:	00005517          	auipc	a0,0x5
    17de:	21650513          	addi	a0,a0,534 # 69f0 <malloc+0x9c6>
    17e2:	00004097          	auipc	ra,0x4
    17e6:	78a080e7          	jalr	1930(ra) # 5f6c <printf>
     exit(1);
    17ea:	4505                	li	a0,1
    17ec:	00004097          	auipc	ra,0x4
    17f0:	408080e7          	jalr	1032(ra) # 5bf4 <exit>
      printf("%s: create failed\n", s);
    17f4:	85ca                	mv	a1,s2
    17f6:	00005517          	auipc	a0,0x5
    17fa:	29250513          	addi	a0,a0,658 # 6a88 <malloc+0xa5e>
    17fe:	00004097          	auipc	ra,0x4
    1802:	76e080e7          	jalr	1902(ra) # 5f6c <printf>
      exit(1);
    1806:	4505                	li	a0,1
    1808:	00004097          	auipc	ra,0x4
    180c:	3ec080e7          	jalr	1004(ra) # 5bf4 <exit>
    if(exec("echo", echoargv) < 0){
    1810:	fc040593          	addi	a1,s0,-64
    1814:	00005517          	auipc	a0,0x5
    1818:	95450513          	addi	a0,a0,-1708 # 6168 <malloc+0x13e>
    181c:	00004097          	auipc	ra,0x4
    1820:	410080e7          	jalr	1040(ra) # 5c2c <exec>
    1824:	02054163          	bltz	a0,1846 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1828:	fdc40513          	addi	a0,s0,-36
    182c:	00004097          	auipc	ra,0x4
    1830:	3d0080e7          	jalr	976(ra) # 5bfc <wait>
    1834:	02951763          	bne	a0,s1,1862 <exectest+0x118>
  if(xstatus != 0)
    1838:	fdc42503          	lw	a0,-36(s0)
    183c:	cd0d                	beqz	a0,1876 <exectest+0x12c>
    exit(xstatus);
    183e:	00004097          	auipc	ra,0x4
    1842:	3b6080e7          	jalr	950(ra) # 5bf4 <exit>
      printf("%s: exec echo failed\n", s);
    1846:	85ca                	mv	a1,s2
    1848:	00005517          	auipc	a0,0x5
    184c:	26850513          	addi	a0,a0,616 # 6ab0 <malloc+0xa86>
    1850:	00004097          	auipc	ra,0x4
    1854:	71c080e7          	jalr	1820(ra) # 5f6c <printf>
      exit(1);
    1858:	4505                	li	a0,1
    185a:	00004097          	auipc	ra,0x4
    185e:	39a080e7          	jalr	922(ra) # 5bf4 <exit>
    printf("%s: wait failed!\n", s);
    1862:	85ca                	mv	a1,s2
    1864:	00005517          	auipc	a0,0x5
    1868:	26450513          	addi	a0,a0,612 # 6ac8 <malloc+0xa9e>
    186c:	00004097          	auipc	ra,0x4
    1870:	700080e7          	jalr	1792(ra) # 5f6c <printf>
    1874:	b7d1                	j	1838 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1876:	4581                	li	a1,0
    1878:	00005517          	auipc	a0,0x5
    187c:	20850513          	addi	a0,a0,520 # 6a80 <malloc+0xa56>
    1880:	00004097          	auipc	ra,0x4
    1884:	3b4080e7          	jalr	948(ra) # 5c34 <open>
  if(fd < 0) {
    1888:	02054a63          	bltz	a0,18bc <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    188c:	4609                	li	a2,2
    188e:	fb840593          	addi	a1,s0,-72
    1892:	00004097          	auipc	ra,0x4
    1896:	37a080e7          	jalr	890(ra) # 5c0c <read>
    189a:	4789                	li	a5,2
    189c:	02f50e63          	beq	a0,a5,18d8 <exectest+0x18e>
    printf("%s: read failed\n", s);
    18a0:	85ca                	mv	a1,s2
    18a2:	00005517          	auipc	a0,0x5
    18a6:	c9650513          	addi	a0,a0,-874 # 6538 <malloc+0x50e>
    18aa:	00004097          	auipc	ra,0x4
    18ae:	6c2080e7          	jalr	1730(ra) # 5f6c <printf>
    exit(1);
    18b2:	4505                	li	a0,1
    18b4:	00004097          	auipc	ra,0x4
    18b8:	340080e7          	jalr	832(ra) # 5bf4 <exit>
    printf("%s: open failed\n", s);
    18bc:	85ca                	mv	a1,s2
    18be:	00005517          	auipc	a0,0x5
    18c2:	14a50513          	addi	a0,a0,330 # 6a08 <malloc+0x9de>
    18c6:	00004097          	auipc	ra,0x4
    18ca:	6a6080e7          	jalr	1702(ra) # 5f6c <printf>
    exit(1);
    18ce:	4505                	li	a0,1
    18d0:	00004097          	auipc	ra,0x4
    18d4:	324080e7          	jalr	804(ra) # 5bf4 <exit>
  unlink("echo-ok");
    18d8:	00005517          	auipc	a0,0x5
    18dc:	1a850513          	addi	a0,a0,424 # 6a80 <malloc+0xa56>
    18e0:	00004097          	auipc	ra,0x4
    18e4:	364080e7          	jalr	868(ra) # 5c44 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18e8:	fb844703          	lbu	a4,-72(s0)
    18ec:	04f00793          	li	a5,79
    18f0:	00f71863          	bne	a4,a5,1900 <exectest+0x1b6>
    18f4:	fb944703          	lbu	a4,-71(s0)
    18f8:	04b00793          	li	a5,75
    18fc:	02f70063          	beq	a4,a5,191c <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1900:	85ca                	mv	a1,s2
    1902:	00005517          	auipc	a0,0x5
    1906:	1de50513          	addi	a0,a0,478 # 6ae0 <malloc+0xab6>
    190a:	00004097          	auipc	ra,0x4
    190e:	662080e7          	jalr	1634(ra) # 5f6c <printf>
    exit(1);
    1912:	4505                	li	a0,1
    1914:	00004097          	auipc	ra,0x4
    1918:	2e0080e7          	jalr	736(ra) # 5bf4 <exit>
    exit(0);
    191c:	4501                	li	a0,0
    191e:	00004097          	auipc	ra,0x4
    1922:	2d6080e7          	jalr	726(ra) # 5bf4 <exit>

0000000000001926 <pipe1>:
{
    1926:	711d                	addi	sp,sp,-96
    1928:	ec86                	sd	ra,88(sp)
    192a:	e8a2                	sd	s0,80(sp)
    192c:	e4a6                	sd	s1,72(sp)
    192e:	e0ca                	sd	s2,64(sp)
    1930:	fc4e                	sd	s3,56(sp)
    1932:	f852                	sd	s4,48(sp)
    1934:	f456                	sd	s5,40(sp)
    1936:	f05a                	sd	s6,32(sp)
    1938:	ec5e                	sd	s7,24(sp)
    193a:	1080                	addi	s0,sp,96
    193c:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    193e:	fa840513          	addi	a0,s0,-88
    1942:	00004097          	auipc	ra,0x4
    1946:	2c2080e7          	jalr	706(ra) # 5c04 <pipe>
    194a:	ed25                	bnez	a0,19c2 <pipe1+0x9c>
    194c:	84aa                	mv	s1,a0
  pid = fork();
    194e:	00004097          	auipc	ra,0x4
    1952:	29e080e7          	jalr	670(ra) # 5bec <fork>
    1956:	8a2a                	mv	s4,a0
  if(pid == 0){
    1958:	c159                	beqz	a0,19de <pipe1+0xb8>
  } else if(pid > 0){
    195a:	16a05e63          	blez	a0,1ad6 <pipe1+0x1b0>
    close(fds[1]);
    195e:	fac42503          	lw	a0,-84(s0)
    1962:	00004097          	auipc	ra,0x4
    1966:	2ba080e7          	jalr	698(ra) # 5c1c <close>
    total = 0;
    196a:	8a26                	mv	s4,s1
    cc = 1;
    196c:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    196e:	0000ba97          	auipc	s5,0xb
    1972:	30aa8a93          	addi	s5,s5,778 # cc78 <buf>
      if(cc > sizeof(buf))
    1976:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1978:	864e                	mv	a2,s3
    197a:	85d6                	mv	a1,s5
    197c:	fa842503          	lw	a0,-88(s0)
    1980:	00004097          	auipc	ra,0x4
    1984:	28c080e7          	jalr	652(ra) # 5c0c <read>
    1988:	10a05263          	blez	a0,1a8c <pipe1+0x166>
      for(i = 0; i < n; i++){
    198c:	0000b717          	auipc	a4,0xb
    1990:	2ec70713          	addi	a4,a4,748 # cc78 <buf>
    1994:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1998:	00074683          	lbu	a3,0(a4)
    199c:	0ff4f793          	zext.b	a5,s1
    19a0:	2485                	addiw	s1,s1,1
    19a2:	0cf69163          	bne	a3,a5,1a64 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    19a6:	0705                	addi	a4,a4,1
    19a8:	fec498e3          	bne	s1,a2,1998 <pipe1+0x72>
      total += n;
    19ac:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19b0:	0019979b          	slliw	a5,s3,0x1
    19b4:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    19b8:	013b7363          	bgeu	s6,s3,19be <pipe1+0x98>
        cc = sizeof(buf);
    19bc:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    19be:	84b2                	mv	s1,a2
    19c0:	bf65                	j	1978 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    19c2:	85ca                	mv	a1,s2
    19c4:	00005517          	auipc	a0,0x5
    19c8:	13450513          	addi	a0,a0,308 # 6af8 <malloc+0xace>
    19cc:	00004097          	auipc	ra,0x4
    19d0:	5a0080e7          	jalr	1440(ra) # 5f6c <printf>
    exit(1);
    19d4:	4505                	li	a0,1
    19d6:	00004097          	auipc	ra,0x4
    19da:	21e080e7          	jalr	542(ra) # 5bf4 <exit>
    close(fds[0]);
    19de:	fa842503          	lw	a0,-88(s0)
    19e2:	00004097          	auipc	ra,0x4
    19e6:	23a080e7          	jalr	570(ra) # 5c1c <close>
    for(n = 0; n < N; n++){
    19ea:	0000bb17          	auipc	s6,0xb
    19ee:	28eb0b13          	addi	s6,s6,654 # cc78 <buf>
    19f2:	416004bb          	negw	s1,s6
    19f6:	0ff4f493          	zext.b	s1,s1
    19fa:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    19fe:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1a00:	6a85                	lui	s5,0x1
    1a02:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x93>
{
    1a06:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a08:	0097873b          	addw	a4,a5,s1
    1a0c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a10:	0785                	addi	a5,a5,1
    1a12:	fef99be3          	bne	s3,a5,1a08 <pipe1+0xe2>
        buf[i] = seq++;
    1a16:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a1a:	40900613          	li	a2,1033
    1a1e:	85de                	mv	a1,s7
    1a20:	fac42503          	lw	a0,-84(s0)
    1a24:	00004097          	auipc	ra,0x4
    1a28:	1f0080e7          	jalr	496(ra) # 5c14 <write>
    1a2c:	40900793          	li	a5,1033
    1a30:	00f51c63          	bne	a0,a5,1a48 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1a34:	24a5                	addiw	s1,s1,9
    1a36:	0ff4f493          	zext.b	s1,s1
    1a3a:	fd5a16e3          	bne	s4,s5,1a06 <pipe1+0xe0>
    exit(0);
    1a3e:	4501                	li	a0,0
    1a40:	00004097          	auipc	ra,0x4
    1a44:	1b4080e7          	jalr	436(ra) # 5bf4 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a48:	85ca                	mv	a1,s2
    1a4a:	00005517          	auipc	a0,0x5
    1a4e:	0c650513          	addi	a0,a0,198 # 6b10 <malloc+0xae6>
    1a52:	00004097          	auipc	ra,0x4
    1a56:	51a080e7          	jalr	1306(ra) # 5f6c <printf>
        exit(1);
    1a5a:	4505                	li	a0,1
    1a5c:	00004097          	auipc	ra,0x4
    1a60:	198080e7          	jalr	408(ra) # 5bf4 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a64:	85ca                	mv	a1,s2
    1a66:	00005517          	auipc	a0,0x5
    1a6a:	0c250513          	addi	a0,a0,194 # 6b28 <malloc+0xafe>
    1a6e:	00004097          	auipc	ra,0x4
    1a72:	4fe080e7          	jalr	1278(ra) # 5f6c <printf>
}
    1a76:	60e6                	ld	ra,88(sp)
    1a78:	6446                	ld	s0,80(sp)
    1a7a:	64a6                	ld	s1,72(sp)
    1a7c:	6906                	ld	s2,64(sp)
    1a7e:	79e2                	ld	s3,56(sp)
    1a80:	7a42                	ld	s4,48(sp)
    1a82:	7aa2                	ld	s5,40(sp)
    1a84:	7b02                	ld	s6,32(sp)
    1a86:	6be2                	ld	s7,24(sp)
    1a88:	6125                	addi	sp,sp,96
    1a8a:	8082                	ret
    if(total != N * SZ){
    1a8c:	6785                	lui	a5,0x1
    1a8e:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x93>
    1a92:	02fa0063          	beq	s4,a5,1ab2 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1a96:	85d2                	mv	a1,s4
    1a98:	00005517          	auipc	a0,0x5
    1a9c:	0a850513          	addi	a0,a0,168 # 6b40 <malloc+0xb16>
    1aa0:	00004097          	auipc	ra,0x4
    1aa4:	4cc080e7          	jalr	1228(ra) # 5f6c <printf>
      exit(1);
    1aa8:	4505                	li	a0,1
    1aaa:	00004097          	auipc	ra,0x4
    1aae:	14a080e7          	jalr	330(ra) # 5bf4 <exit>
    close(fds[0]);
    1ab2:	fa842503          	lw	a0,-88(s0)
    1ab6:	00004097          	auipc	ra,0x4
    1aba:	166080e7          	jalr	358(ra) # 5c1c <close>
    wait(&xstatus);
    1abe:	fa440513          	addi	a0,s0,-92
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	13a080e7          	jalr	314(ra) # 5bfc <wait>
    exit(xstatus);
    1aca:	fa442503          	lw	a0,-92(s0)
    1ace:	00004097          	auipc	ra,0x4
    1ad2:	126080e7          	jalr	294(ra) # 5bf4 <exit>
    printf("%s: fork() failed\n", s);
    1ad6:	85ca                	mv	a1,s2
    1ad8:	00005517          	auipc	a0,0x5
    1adc:	08850513          	addi	a0,a0,136 # 6b60 <malloc+0xb36>
    1ae0:	00004097          	auipc	ra,0x4
    1ae4:	48c080e7          	jalr	1164(ra) # 5f6c <printf>
    exit(1);
    1ae8:	4505                	li	a0,1
    1aea:	00004097          	auipc	ra,0x4
    1aee:	10a080e7          	jalr	266(ra) # 5bf4 <exit>

0000000000001af2 <exitwait>:
{
    1af2:	7139                	addi	sp,sp,-64
    1af4:	fc06                	sd	ra,56(sp)
    1af6:	f822                	sd	s0,48(sp)
    1af8:	f426                	sd	s1,40(sp)
    1afa:	f04a                	sd	s2,32(sp)
    1afc:	ec4e                	sd	s3,24(sp)
    1afe:	e852                	sd	s4,16(sp)
    1b00:	0080                	addi	s0,sp,64
    1b02:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1b04:	4901                	li	s2,0
    1b06:	06400993          	li	s3,100
    pid = fork();
    1b0a:	00004097          	auipc	ra,0x4
    1b0e:	0e2080e7          	jalr	226(ra) # 5bec <fork>
    1b12:	84aa                	mv	s1,a0
    if(pid < 0){
    1b14:	02054a63          	bltz	a0,1b48 <exitwait+0x56>
    if(pid){
    1b18:	c151                	beqz	a0,1b9c <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b1a:	fcc40513          	addi	a0,s0,-52
    1b1e:	00004097          	auipc	ra,0x4
    1b22:	0de080e7          	jalr	222(ra) # 5bfc <wait>
    1b26:	02951f63          	bne	a0,s1,1b64 <exitwait+0x72>
      if(i != xstate) {
    1b2a:	fcc42783          	lw	a5,-52(s0)
    1b2e:	05279963          	bne	a5,s2,1b80 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b32:	2905                	addiw	s2,s2,1
    1b34:	fd391be3          	bne	s2,s3,1b0a <exitwait+0x18>
}
    1b38:	70e2                	ld	ra,56(sp)
    1b3a:	7442                	ld	s0,48(sp)
    1b3c:	74a2                	ld	s1,40(sp)
    1b3e:	7902                	ld	s2,32(sp)
    1b40:	69e2                	ld	s3,24(sp)
    1b42:	6a42                	ld	s4,16(sp)
    1b44:	6121                	addi	sp,sp,64
    1b46:	8082                	ret
      printf("%s: fork failed\n", s);
    1b48:	85d2                	mv	a1,s4
    1b4a:	00005517          	auipc	a0,0x5
    1b4e:	ea650513          	addi	a0,a0,-346 # 69f0 <malloc+0x9c6>
    1b52:	00004097          	auipc	ra,0x4
    1b56:	41a080e7          	jalr	1050(ra) # 5f6c <printf>
      exit(1);
    1b5a:	4505                	li	a0,1
    1b5c:	00004097          	auipc	ra,0x4
    1b60:	098080e7          	jalr	152(ra) # 5bf4 <exit>
        printf("%s: wait wrong pid\n", s);
    1b64:	85d2                	mv	a1,s4
    1b66:	00005517          	auipc	a0,0x5
    1b6a:	01250513          	addi	a0,a0,18 # 6b78 <malloc+0xb4e>
    1b6e:	00004097          	auipc	ra,0x4
    1b72:	3fe080e7          	jalr	1022(ra) # 5f6c <printf>
        exit(1);
    1b76:	4505                	li	a0,1
    1b78:	00004097          	auipc	ra,0x4
    1b7c:	07c080e7          	jalr	124(ra) # 5bf4 <exit>
        printf("%s: wait wrong exit status\n", s);
    1b80:	85d2                	mv	a1,s4
    1b82:	00005517          	auipc	a0,0x5
    1b86:	00e50513          	addi	a0,a0,14 # 6b90 <malloc+0xb66>
    1b8a:	00004097          	auipc	ra,0x4
    1b8e:	3e2080e7          	jalr	994(ra) # 5f6c <printf>
        exit(1);
    1b92:	4505                	li	a0,1
    1b94:	00004097          	auipc	ra,0x4
    1b98:	060080e7          	jalr	96(ra) # 5bf4 <exit>
      exit(i);
    1b9c:	854a                	mv	a0,s2
    1b9e:	00004097          	auipc	ra,0x4
    1ba2:	056080e7          	jalr	86(ra) # 5bf4 <exit>

0000000000001ba6 <twochildren>:
{
    1ba6:	1101                	addi	sp,sp,-32
    1ba8:	ec06                	sd	ra,24(sp)
    1baa:	e822                	sd	s0,16(sp)
    1bac:	e426                	sd	s1,8(sp)
    1bae:	e04a                	sd	s2,0(sp)
    1bb0:	1000                	addi	s0,sp,32
    1bb2:	892a                	mv	s2,a0
    1bb4:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bb8:	00004097          	auipc	ra,0x4
    1bbc:	034080e7          	jalr	52(ra) # 5bec <fork>
    if(pid1 < 0){
    1bc0:	02054c63          	bltz	a0,1bf8 <twochildren+0x52>
    if(pid1 == 0){
    1bc4:	c921                	beqz	a0,1c14 <twochildren+0x6e>
      int pid2 = fork();
    1bc6:	00004097          	auipc	ra,0x4
    1bca:	026080e7          	jalr	38(ra) # 5bec <fork>
      if(pid2 < 0){
    1bce:	04054763          	bltz	a0,1c1c <twochildren+0x76>
      if(pid2 == 0){
    1bd2:	c13d                	beqz	a0,1c38 <twochildren+0x92>
        wait(0);
    1bd4:	4501                	li	a0,0
    1bd6:	00004097          	auipc	ra,0x4
    1bda:	026080e7          	jalr	38(ra) # 5bfc <wait>
        wait(0);
    1bde:	4501                	li	a0,0
    1be0:	00004097          	auipc	ra,0x4
    1be4:	01c080e7          	jalr	28(ra) # 5bfc <wait>
  for(int i = 0; i < 1000; i++){
    1be8:	34fd                	addiw	s1,s1,-1
    1bea:	f4f9                	bnez	s1,1bb8 <twochildren+0x12>
}
    1bec:	60e2                	ld	ra,24(sp)
    1bee:	6442                	ld	s0,16(sp)
    1bf0:	64a2                	ld	s1,8(sp)
    1bf2:	6902                	ld	s2,0(sp)
    1bf4:	6105                	addi	sp,sp,32
    1bf6:	8082                	ret
      printf("%s: fork failed\n", s);
    1bf8:	85ca                	mv	a1,s2
    1bfa:	00005517          	auipc	a0,0x5
    1bfe:	df650513          	addi	a0,a0,-522 # 69f0 <malloc+0x9c6>
    1c02:	00004097          	auipc	ra,0x4
    1c06:	36a080e7          	jalr	874(ra) # 5f6c <printf>
      exit(1);
    1c0a:	4505                	li	a0,1
    1c0c:	00004097          	auipc	ra,0x4
    1c10:	fe8080e7          	jalr	-24(ra) # 5bf4 <exit>
      exit(0);
    1c14:	00004097          	auipc	ra,0x4
    1c18:	fe0080e7          	jalr	-32(ra) # 5bf4 <exit>
        printf("%s: fork failed\n", s);
    1c1c:	85ca                	mv	a1,s2
    1c1e:	00005517          	auipc	a0,0x5
    1c22:	dd250513          	addi	a0,a0,-558 # 69f0 <malloc+0x9c6>
    1c26:	00004097          	auipc	ra,0x4
    1c2a:	346080e7          	jalr	838(ra) # 5f6c <printf>
        exit(1);
    1c2e:	4505                	li	a0,1
    1c30:	00004097          	auipc	ra,0x4
    1c34:	fc4080e7          	jalr	-60(ra) # 5bf4 <exit>
        exit(0);
    1c38:	00004097          	auipc	ra,0x4
    1c3c:	fbc080e7          	jalr	-68(ra) # 5bf4 <exit>

0000000000001c40 <forkfork>:
{
    1c40:	7179                	addi	sp,sp,-48
    1c42:	f406                	sd	ra,40(sp)
    1c44:	f022                	sd	s0,32(sp)
    1c46:	ec26                	sd	s1,24(sp)
    1c48:	1800                	addi	s0,sp,48
    1c4a:	84aa                	mv	s1,a0
    int pid = fork();
    1c4c:	00004097          	auipc	ra,0x4
    1c50:	fa0080e7          	jalr	-96(ra) # 5bec <fork>
    if(pid < 0){
    1c54:	04054163          	bltz	a0,1c96 <forkfork+0x56>
    if(pid == 0){
    1c58:	cd29                	beqz	a0,1cb2 <forkfork+0x72>
    int pid = fork();
    1c5a:	00004097          	auipc	ra,0x4
    1c5e:	f92080e7          	jalr	-110(ra) # 5bec <fork>
    if(pid < 0){
    1c62:	02054a63          	bltz	a0,1c96 <forkfork+0x56>
    if(pid == 0){
    1c66:	c531                	beqz	a0,1cb2 <forkfork+0x72>
    wait(&xstatus);
    1c68:	fdc40513          	addi	a0,s0,-36
    1c6c:	00004097          	auipc	ra,0x4
    1c70:	f90080e7          	jalr	-112(ra) # 5bfc <wait>
    if(xstatus != 0) {
    1c74:	fdc42783          	lw	a5,-36(s0)
    1c78:	ebbd                	bnez	a5,1cee <forkfork+0xae>
    wait(&xstatus);
    1c7a:	fdc40513          	addi	a0,s0,-36
    1c7e:	00004097          	auipc	ra,0x4
    1c82:	f7e080e7          	jalr	-130(ra) # 5bfc <wait>
    if(xstatus != 0) {
    1c86:	fdc42783          	lw	a5,-36(s0)
    1c8a:	e3b5                	bnez	a5,1cee <forkfork+0xae>
}
    1c8c:	70a2                	ld	ra,40(sp)
    1c8e:	7402                	ld	s0,32(sp)
    1c90:	64e2                	ld	s1,24(sp)
    1c92:	6145                	addi	sp,sp,48
    1c94:	8082                	ret
      printf("%s: fork failed", s);
    1c96:	85a6                	mv	a1,s1
    1c98:	00005517          	auipc	a0,0x5
    1c9c:	f1850513          	addi	a0,a0,-232 # 6bb0 <malloc+0xb86>
    1ca0:	00004097          	auipc	ra,0x4
    1ca4:	2cc080e7          	jalr	716(ra) # 5f6c <printf>
      exit(1);
    1ca8:	4505                	li	a0,1
    1caa:	00004097          	auipc	ra,0x4
    1cae:	f4a080e7          	jalr	-182(ra) # 5bf4 <exit>
{
    1cb2:	0c800493          	li	s1,200
        int pid1 = fork();
    1cb6:	00004097          	auipc	ra,0x4
    1cba:	f36080e7          	jalr	-202(ra) # 5bec <fork>
        if(pid1 < 0){
    1cbe:	00054f63          	bltz	a0,1cdc <forkfork+0x9c>
        if(pid1 == 0){
    1cc2:	c115                	beqz	a0,1ce6 <forkfork+0xa6>
        wait(0);
    1cc4:	4501                	li	a0,0
    1cc6:	00004097          	auipc	ra,0x4
    1cca:	f36080e7          	jalr	-202(ra) # 5bfc <wait>
      for(int j = 0; j < 200; j++){
    1cce:	34fd                	addiw	s1,s1,-1
    1cd0:	f0fd                	bnez	s1,1cb6 <forkfork+0x76>
      exit(0);
    1cd2:	4501                	li	a0,0
    1cd4:	00004097          	auipc	ra,0x4
    1cd8:	f20080e7          	jalr	-224(ra) # 5bf4 <exit>
          exit(1);
    1cdc:	4505                	li	a0,1
    1cde:	00004097          	auipc	ra,0x4
    1ce2:	f16080e7          	jalr	-234(ra) # 5bf4 <exit>
          exit(0);
    1ce6:	00004097          	auipc	ra,0x4
    1cea:	f0e080e7          	jalr	-242(ra) # 5bf4 <exit>
      printf("%s: fork in child failed", s);
    1cee:	85a6                	mv	a1,s1
    1cf0:	00005517          	auipc	a0,0x5
    1cf4:	ed050513          	addi	a0,a0,-304 # 6bc0 <malloc+0xb96>
    1cf8:	00004097          	auipc	ra,0x4
    1cfc:	274080e7          	jalr	628(ra) # 5f6c <printf>
      exit(1);
    1d00:	4505                	li	a0,1
    1d02:	00004097          	auipc	ra,0x4
    1d06:	ef2080e7          	jalr	-270(ra) # 5bf4 <exit>

0000000000001d0a <reparent2>:
{
    1d0a:	1101                	addi	sp,sp,-32
    1d0c:	ec06                	sd	ra,24(sp)
    1d0e:	e822                	sd	s0,16(sp)
    1d10:	e426                	sd	s1,8(sp)
    1d12:	1000                	addi	s0,sp,32
    1d14:	32000493          	li	s1,800
    int pid1 = fork();
    1d18:	00004097          	auipc	ra,0x4
    1d1c:	ed4080e7          	jalr	-300(ra) # 5bec <fork>
    if(pid1 < 0){
    1d20:	00054f63          	bltz	a0,1d3e <reparent2+0x34>
    if(pid1 == 0){
    1d24:	c915                	beqz	a0,1d58 <reparent2+0x4e>
    wait(0);
    1d26:	4501                	li	a0,0
    1d28:	00004097          	auipc	ra,0x4
    1d2c:	ed4080e7          	jalr	-300(ra) # 5bfc <wait>
  for(int i = 0; i < 800; i++){
    1d30:	34fd                	addiw	s1,s1,-1
    1d32:	f0fd                	bnez	s1,1d18 <reparent2+0xe>
  exit(0);
    1d34:	4501                	li	a0,0
    1d36:	00004097          	auipc	ra,0x4
    1d3a:	ebe080e7          	jalr	-322(ra) # 5bf4 <exit>
      printf("fork failed\n");
    1d3e:	00005517          	auipc	a0,0x5
    1d42:	0ba50513          	addi	a0,a0,186 # 6df8 <malloc+0xdce>
    1d46:	00004097          	auipc	ra,0x4
    1d4a:	226080e7          	jalr	550(ra) # 5f6c <printf>
      exit(1);
    1d4e:	4505                	li	a0,1
    1d50:	00004097          	auipc	ra,0x4
    1d54:	ea4080e7          	jalr	-348(ra) # 5bf4 <exit>
      fork();
    1d58:	00004097          	auipc	ra,0x4
    1d5c:	e94080e7          	jalr	-364(ra) # 5bec <fork>
      fork();
    1d60:	00004097          	auipc	ra,0x4
    1d64:	e8c080e7          	jalr	-372(ra) # 5bec <fork>
      exit(0);
    1d68:	4501                	li	a0,0
    1d6a:	00004097          	auipc	ra,0x4
    1d6e:	e8a080e7          	jalr	-374(ra) # 5bf4 <exit>

0000000000001d72 <createdelete>:
{
    1d72:	7175                	addi	sp,sp,-144
    1d74:	e506                	sd	ra,136(sp)
    1d76:	e122                	sd	s0,128(sp)
    1d78:	fca6                	sd	s1,120(sp)
    1d7a:	f8ca                	sd	s2,112(sp)
    1d7c:	f4ce                	sd	s3,104(sp)
    1d7e:	f0d2                	sd	s4,96(sp)
    1d80:	ecd6                	sd	s5,88(sp)
    1d82:	e8da                	sd	s6,80(sp)
    1d84:	e4de                	sd	s7,72(sp)
    1d86:	e0e2                	sd	s8,64(sp)
    1d88:	fc66                	sd	s9,56(sp)
    1d8a:	0900                	addi	s0,sp,144
    1d8c:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1d8e:	4901                	li	s2,0
    1d90:	4991                	li	s3,4
    pid = fork();
    1d92:	00004097          	auipc	ra,0x4
    1d96:	e5a080e7          	jalr	-422(ra) # 5bec <fork>
    1d9a:	84aa                	mv	s1,a0
    if(pid < 0){
    1d9c:	02054f63          	bltz	a0,1dda <createdelete+0x68>
    if(pid == 0){
    1da0:	c939                	beqz	a0,1df6 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1da2:	2905                	addiw	s2,s2,1
    1da4:	ff3917e3          	bne	s2,s3,1d92 <createdelete+0x20>
    1da8:	4491                	li	s1,4
    wait(&xstatus);
    1daa:	f7c40513          	addi	a0,s0,-132
    1dae:	00004097          	auipc	ra,0x4
    1db2:	e4e080e7          	jalr	-434(ra) # 5bfc <wait>
    if(xstatus != 0)
    1db6:	f7c42903          	lw	s2,-132(s0)
    1dba:	0e091263          	bnez	s2,1e9e <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1dbe:	34fd                	addiw	s1,s1,-1
    1dc0:	f4ed                	bnez	s1,1daa <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1dc2:	f8040123          	sb	zero,-126(s0)
    1dc6:	03000993          	li	s3,48
    1dca:	5a7d                	li	s4,-1
    1dcc:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1dd0:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1dd2:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1dd4:	07400a93          	li	s5,116
    1dd8:	a29d                	j	1f3e <createdelete+0x1cc>
      printf("fork failed\n", s);
    1dda:	85e6                	mv	a1,s9
    1ddc:	00005517          	auipc	a0,0x5
    1de0:	01c50513          	addi	a0,a0,28 # 6df8 <malloc+0xdce>
    1de4:	00004097          	auipc	ra,0x4
    1de8:	188080e7          	jalr	392(ra) # 5f6c <printf>
      exit(1);
    1dec:	4505                	li	a0,1
    1dee:	00004097          	auipc	ra,0x4
    1df2:	e06080e7          	jalr	-506(ra) # 5bf4 <exit>
      name[0] = 'p' + pi;
    1df6:	0709091b          	addiw	s2,s2,112
    1dfa:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1dfe:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1e02:	4951                	li	s2,20
    1e04:	a015                	j	1e28 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e06:	85e6                	mv	a1,s9
    1e08:	00005517          	auipc	a0,0x5
    1e0c:	c8050513          	addi	a0,a0,-896 # 6a88 <malloc+0xa5e>
    1e10:	00004097          	auipc	ra,0x4
    1e14:	15c080e7          	jalr	348(ra) # 5f6c <printf>
          exit(1);
    1e18:	4505                	li	a0,1
    1e1a:	00004097          	auipc	ra,0x4
    1e1e:	dda080e7          	jalr	-550(ra) # 5bf4 <exit>
      for(i = 0; i < N; i++){
    1e22:	2485                	addiw	s1,s1,1
    1e24:	07248863          	beq	s1,s2,1e94 <createdelete+0x122>
        name[1] = '0' + i;
    1e28:	0304879b          	addiw	a5,s1,48
    1e2c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e30:	20200593          	li	a1,514
    1e34:	f8040513          	addi	a0,s0,-128
    1e38:	00004097          	auipc	ra,0x4
    1e3c:	dfc080e7          	jalr	-516(ra) # 5c34 <open>
        if(fd < 0){
    1e40:	fc0543e3          	bltz	a0,1e06 <createdelete+0x94>
        close(fd);
    1e44:	00004097          	auipc	ra,0x4
    1e48:	dd8080e7          	jalr	-552(ra) # 5c1c <close>
        if(i > 0 && (i % 2 ) == 0){
    1e4c:	fc905be3          	blez	s1,1e22 <createdelete+0xb0>
    1e50:	0014f793          	andi	a5,s1,1
    1e54:	f7f9                	bnez	a5,1e22 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e56:	01f4d79b          	srliw	a5,s1,0x1f
    1e5a:	9fa5                	addw	a5,a5,s1
    1e5c:	4017d79b          	sraiw	a5,a5,0x1
    1e60:	0307879b          	addiw	a5,a5,48
    1e64:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e68:	f8040513          	addi	a0,s0,-128
    1e6c:	00004097          	auipc	ra,0x4
    1e70:	dd8080e7          	jalr	-552(ra) # 5c44 <unlink>
    1e74:	fa0557e3          	bgez	a0,1e22 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e78:	85e6                	mv	a1,s9
    1e7a:	00005517          	auipc	a0,0x5
    1e7e:	d6650513          	addi	a0,a0,-666 # 6be0 <malloc+0xbb6>
    1e82:	00004097          	auipc	ra,0x4
    1e86:	0ea080e7          	jalr	234(ra) # 5f6c <printf>
            exit(1);
    1e8a:	4505                	li	a0,1
    1e8c:	00004097          	auipc	ra,0x4
    1e90:	d68080e7          	jalr	-664(ra) # 5bf4 <exit>
      exit(0);
    1e94:	4501                	li	a0,0
    1e96:	00004097          	auipc	ra,0x4
    1e9a:	d5e080e7          	jalr	-674(ra) # 5bf4 <exit>
      exit(1);
    1e9e:	4505                	li	a0,1
    1ea0:	00004097          	auipc	ra,0x4
    1ea4:	d54080e7          	jalr	-684(ra) # 5bf4 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ea8:	f8040613          	addi	a2,s0,-128
    1eac:	85e6                	mv	a1,s9
    1eae:	00005517          	auipc	a0,0x5
    1eb2:	d4a50513          	addi	a0,a0,-694 # 6bf8 <malloc+0xbce>
    1eb6:	00004097          	auipc	ra,0x4
    1eba:	0b6080e7          	jalr	182(ra) # 5f6c <printf>
        exit(1);
    1ebe:	4505                	li	a0,1
    1ec0:	00004097          	auipc	ra,0x4
    1ec4:	d34080e7          	jalr	-716(ra) # 5bf4 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ec8:	054b7163          	bgeu	s6,s4,1f0a <createdelete+0x198>
      if(fd >= 0)
    1ecc:	02055a63          	bgez	a0,1f00 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ed0:	2485                	addiw	s1,s1,1
    1ed2:	0ff4f493          	zext.b	s1,s1
    1ed6:	05548c63          	beq	s1,s5,1f2e <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1eda:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1ede:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1ee2:	4581                	li	a1,0
    1ee4:	f8040513          	addi	a0,s0,-128
    1ee8:	00004097          	auipc	ra,0x4
    1eec:	d4c080e7          	jalr	-692(ra) # 5c34 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1ef0:	00090463          	beqz	s2,1ef8 <createdelete+0x186>
    1ef4:	fd2bdae3          	bge	s7,s2,1ec8 <createdelete+0x156>
    1ef8:	fa0548e3          	bltz	a0,1ea8 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1efc:	014b7963          	bgeu	s6,s4,1f0e <createdelete+0x19c>
        close(fd);
    1f00:	00004097          	auipc	ra,0x4
    1f04:	d1c080e7          	jalr	-740(ra) # 5c1c <close>
    1f08:	b7e1                	j	1ed0 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f0a:	fc0543e3          	bltz	a0,1ed0 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f0e:	f8040613          	addi	a2,s0,-128
    1f12:	85e6                	mv	a1,s9
    1f14:	00005517          	auipc	a0,0x5
    1f18:	d0c50513          	addi	a0,a0,-756 # 6c20 <malloc+0xbf6>
    1f1c:	00004097          	auipc	ra,0x4
    1f20:	050080e7          	jalr	80(ra) # 5f6c <printf>
        exit(1);
    1f24:	4505                	li	a0,1
    1f26:	00004097          	auipc	ra,0x4
    1f2a:	cce080e7          	jalr	-818(ra) # 5bf4 <exit>
  for(i = 0; i < N; i++){
    1f2e:	2905                	addiw	s2,s2,1
    1f30:	2a05                	addiw	s4,s4,1
    1f32:	2985                	addiw	s3,s3,1
    1f34:	0ff9f993          	zext.b	s3,s3
    1f38:	47d1                	li	a5,20
    1f3a:	02f90a63          	beq	s2,a5,1f6e <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1f3e:	84e2                	mv	s1,s8
    1f40:	bf69                	j	1eda <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f42:	2905                	addiw	s2,s2,1
    1f44:	0ff97913          	zext.b	s2,s2
    1f48:	2985                	addiw	s3,s3,1
    1f4a:	0ff9f993          	zext.b	s3,s3
    1f4e:	03490863          	beq	s2,s4,1f7e <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f52:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f54:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f58:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f5c:	f8040513          	addi	a0,s0,-128
    1f60:	00004097          	auipc	ra,0x4
    1f64:	ce4080e7          	jalr	-796(ra) # 5c44 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f68:	34fd                	addiw	s1,s1,-1
    1f6a:	f4ed                	bnez	s1,1f54 <createdelete+0x1e2>
    1f6c:	bfd9                	j	1f42 <createdelete+0x1d0>
    1f6e:	03000993          	li	s3,48
    1f72:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f76:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f78:	08400a13          	li	s4,132
    1f7c:	bfd9                	j	1f52 <createdelete+0x1e0>
}
    1f7e:	60aa                	ld	ra,136(sp)
    1f80:	640a                	ld	s0,128(sp)
    1f82:	74e6                	ld	s1,120(sp)
    1f84:	7946                	ld	s2,112(sp)
    1f86:	79a6                	ld	s3,104(sp)
    1f88:	7a06                	ld	s4,96(sp)
    1f8a:	6ae6                	ld	s5,88(sp)
    1f8c:	6b46                	ld	s6,80(sp)
    1f8e:	6ba6                	ld	s7,72(sp)
    1f90:	6c06                	ld	s8,64(sp)
    1f92:	7ce2                	ld	s9,56(sp)
    1f94:	6149                	addi	sp,sp,144
    1f96:	8082                	ret

0000000000001f98 <linkunlink>:
{
    1f98:	711d                	addi	sp,sp,-96
    1f9a:	ec86                	sd	ra,88(sp)
    1f9c:	e8a2                	sd	s0,80(sp)
    1f9e:	e4a6                	sd	s1,72(sp)
    1fa0:	e0ca                	sd	s2,64(sp)
    1fa2:	fc4e                	sd	s3,56(sp)
    1fa4:	f852                	sd	s4,48(sp)
    1fa6:	f456                	sd	s5,40(sp)
    1fa8:	f05a                	sd	s6,32(sp)
    1faa:	ec5e                	sd	s7,24(sp)
    1fac:	e862                	sd	s8,16(sp)
    1fae:	e466                	sd	s9,8(sp)
    1fb0:	1080                	addi	s0,sp,96
    1fb2:	84aa                	mv	s1,a0
  unlink("x");
    1fb4:	00004517          	auipc	a0,0x4
    1fb8:	22450513          	addi	a0,a0,548 # 61d8 <malloc+0x1ae>
    1fbc:	00004097          	auipc	ra,0x4
    1fc0:	c88080e7          	jalr	-888(ra) # 5c44 <unlink>
  pid = fork();
    1fc4:	00004097          	auipc	ra,0x4
    1fc8:	c28080e7          	jalr	-984(ra) # 5bec <fork>
  if(pid < 0){
    1fcc:	02054b63          	bltz	a0,2002 <linkunlink+0x6a>
    1fd0:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fd2:	4c85                	li	s9,1
    1fd4:	e119                	bnez	a0,1fda <linkunlink+0x42>
    1fd6:	06100c93          	li	s9,97
    1fda:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fde:	41c659b7          	lui	s3,0x41c65
    1fe2:	e6d9899b          	addiw	s3,s3,-403
    1fe6:	690d                	lui	s2,0x3
    1fe8:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1fec:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1fee:	4b05                	li	s6,1
      unlink("x");
    1ff0:	00004a97          	auipc	s5,0x4
    1ff4:	1e8a8a93          	addi	s5,s5,488 # 61d8 <malloc+0x1ae>
      link("cat", "x");
    1ff8:	00005b97          	auipc	s7,0x5
    1ffc:	c50b8b93          	addi	s7,s7,-944 # 6c48 <malloc+0xc1e>
    2000:	a825                	j	2038 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    2002:	85a6                	mv	a1,s1
    2004:	00005517          	auipc	a0,0x5
    2008:	9ec50513          	addi	a0,a0,-1556 # 69f0 <malloc+0x9c6>
    200c:	00004097          	auipc	ra,0x4
    2010:	f60080e7          	jalr	-160(ra) # 5f6c <printf>
    exit(1);
    2014:	4505                	li	a0,1
    2016:	00004097          	auipc	ra,0x4
    201a:	bde080e7          	jalr	-1058(ra) # 5bf4 <exit>
      close(open("x", O_RDWR | O_CREATE));
    201e:	20200593          	li	a1,514
    2022:	8556                	mv	a0,s5
    2024:	00004097          	auipc	ra,0x4
    2028:	c10080e7          	jalr	-1008(ra) # 5c34 <open>
    202c:	00004097          	auipc	ra,0x4
    2030:	bf0080e7          	jalr	-1040(ra) # 5c1c <close>
  for(i = 0; i < 100; i++){
    2034:	34fd                	addiw	s1,s1,-1
    2036:	c88d                	beqz	s1,2068 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    2038:	033c87bb          	mulw	a5,s9,s3
    203c:	012787bb          	addw	a5,a5,s2
    2040:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    2044:	0347f7bb          	remuw	a5,a5,s4
    2048:	dbf9                	beqz	a5,201e <linkunlink+0x86>
    } else if((x % 3) == 1){
    204a:	01678863          	beq	a5,s6,205a <linkunlink+0xc2>
      unlink("x");
    204e:	8556                	mv	a0,s5
    2050:	00004097          	auipc	ra,0x4
    2054:	bf4080e7          	jalr	-1036(ra) # 5c44 <unlink>
    2058:	bff1                	j	2034 <linkunlink+0x9c>
      link("cat", "x");
    205a:	85d6                	mv	a1,s5
    205c:	855e                	mv	a0,s7
    205e:	00004097          	auipc	ra,0x4
    2062:	bf6080e7          	jalr	-1034(ra) # 5c54 <link>
    2066:	b7f9                	j	2034 <linkunlink+0x9c>
  if(pid)
    2068:	020c0463          	beqz	s8,2090 <linkunlink+0xf8>
    wait(0);
    206c:	4501                	li	a0,0
    206e:	00004097          	auipc	ra,0x4
    2072:	b8e080e7          	jalr	-1138(ra) # 5bfc <wait>
}
    2076:	60e6                	ld	ra,88(sp)
    2078:	6446                	ld	s0,80(sp)
    207a:	64a6                	ld	s1,72(sp)
    207c:	6906                	ld	s2,64(sp)
    207e:	79e2                	ld	s3,56(sp)
    2080:	7a42                	ld	s4,48(sp)
    2082:	7aa2                	ld	s5,40(sp)
    2084:	7b02                	ld	s6,32(sp)
    2086:	6be2                	ld	s7,24(sp)
    2088:	6c42                	ld	s8,16(sp)
    208a:	6ca2                	ld	s9,8(sp)
    208c:	6125                	addi	sp,sp,96
    208e:	8082                	ret
    exit(0);
    2090:	4501                	li	a0,0
    2092:	00004097          	auipc	ra,0x4
    2096:	b62080e7          	jalr	-1182(ra) # 5bf4 <exit>

000000000000209a <forktest>:
{
    209a:	7179                	addi	sp,sp,-48
    209c:	f406                	sd	ra,40(sp)
    209e:	f022                	sd	s0,32(sp)
    20a0:	ec26                	sd	s1,24(sp)
    20a2:	e84a                	sd	s2,16(sp)
    20a4:	e44e                	sd	s3,8(sp)
    20a6:	1800                	addi	s0,sp,48
    20a8:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20aa:	4481                	li	s1,0
    20ac:	3e800913          	li	s2,1000
    pid = fork();
    20b0:	00004097          	auipc	ra,0x4
    20b4:	b3c080e7          	jalr	-1220(ra) # 5bec <fork>
    if(pid < 0)
    20b8:	02054863          	bltz	a0,20e8 <forktest+0x4e>
    if(pid == 0)
    20bc:	c115                	beqz	a0,20e0 <forktest+0x46>
  for(n=0; n<N; n++){
    20be:	2485                	addiw	s1,s1,1
    20c0:	ff2498e3          	bne	s1,s2,20b0 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20c4:	85ce                	mv	a1,s3
    20c6:	00005517          	auipc	a0,0x5
    20ca:	ba250513          	addi	a0,a0,-1118 # 6c68 <malloc+0xc3e>
    20ce:	00004097          	auipc	ra,0x4
    20d2:	e9e080e7          	jalr	-354(ra) # 5f6c <printf>
    exit(1);
    20d6:	4505                	li	a0,1
    20d8:	00004097          	auipc	ra,0x4
    20dc:	b1c080e7          	jalr	-1252(ra) # 5bf4 <exit>
      exit(0);
    20e0:	00004097          	auipc	ra,0x4
    20e4:	b14080e7          	jalr	-1260(ra) # 5bf4 <exit>
  if (n == 0) {
    20e8:	cc9d                	beqz	s1,2126 <forktest+0x8c>
  if(n == N){
    20ea:	3e800793          	li	a5,1000
    20ee:	fcf48be3          	beq	s1,a5,20c4 <forktest+0x2a>
  for(; n > 0; n--){
    20f2:	00905b63          	blez	s1,2108 <forktest+0x6e>
    if(wait(0) < 0){
    20f6:	4501                	li	a0,0
    20f8:	00004097          	auipc	ra,0x4
    20fc:	b04080e7          	jalr	-1276(ra) # 5bfc <wait>
    2100:	04054163          	bltz	a0,2142 <forktest+0xa8>
  for(; n > 0; n--){
    2104:	34fd                	addiw	s1,s1,-1
    2106:	f8e5                	bnez	s1,20f6 <forktest+0x5c>
  if(wait(0) != -1){
    2108:	4501                	li	a0,0
    210a:	00004097          	auipc	ra,0x4
    210e:	af2080e7          	jalr	-1294(ra) # 5bfc <wait>
    2112:	57fd                	li	a5,-1
    2114:	04f51563          	bne	a0,a5,215e <forktest+0xc4>
}
    2118:	70a2                	ld	ra,40(sp)
    211a:	7402                	ld	s0,32(sp)
    211c:	64e2                	ld	s1,24(sp)
    211e:	6942                	ld	s2,16(sp)
    2120:	69a2                	ld	s3,8(sp)
    2122:	6145                	addi	sp,sp,48
    2124:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2126:	85ce                	mv	a1,s3
    2128:	00005517          	auipc	a0,0x5
    212c:	b2850513          	addi	a0,a0,-1240 # 6c50 <malloc+0xc26>
    2130:	00004097          	auipc	ra,0x4
    2134:	e3c080e7          	jalr	-452(ra) # 5f6c <printf>
    exit(1);
    2138:	4505                	li	a0,1
    213a:	00004097          	auipc	ra,0x4
    213e:	aba080e7          	jalr	-1350(ra) # 5bf4 <exit>
      printf("%s: wait stopped early\n", s);
    2142:	85ce                	mv	a1,s3
    2144:	00005517          	auipc	a0,0x5
    2148:	b4c50513          	addi	a0,a0,-1204 # 6c90 <malloc+0xc66>
    214c:	00004097          	auipc	ra,0x4
    2150:	e20080e7          	jalr	-480(ra) # 5f6c <printf>
      exit(1);
    2154:	4505                	li	a0,1
    2156:	00004097          	auipc	ra,0x4
    215a:	a9e080e7          	jalr	-1378(ra) # 5bf4 <exit>
    printf("%s: wait got too many\n", s);
    215e:	85ce                	mv	a1,s3
    2160:	00005517          	auipc	a0,0x5
    2164:	b4850513          	addi	a0,a0,-1208 # 6ca8 <malloc+0xc7e>
    2168:	00004097          	auipc	ra,0x4
    216c:	e04080e7          	jalr	-508(ra) # 5f6c <printf>
    exit(1);
    2170:	4505                	li	a0,1
    2172:	00004097          	auipc	ra,0x4
    2176:	a82080e7          	jalr	-1406(ra) # 5bf4 <exit>

000000000000217a <kernmem>:
{
    217a:	715d                	addi	sp,sp,-80
    217c:	e486                	sd	ra,72(sp)
    217e:	e0a2                	sd	s0,64(sp)
    2180:	fc26                	sd	s1,56(sp)
    2182:	f84a                	sd	s2,48(sp)
    2184:	f44e                	sd	s3,40(sp)
    2186:	f052                	sd	s4,32(sp)
    2188:	ec56                	sd	s5,24(sp)
    218a:	0880                	addi	s0,sp,80
    218c:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    218e:	4485                	li	s1,1
    2190:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    2192:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2194:	69b1                	lui	s3,0xc
    2196:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    219a:	1003d937          	lui	s2,0x1003d
    219e:	090e                	slli	s2,s2,0x3
    21a0:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    21a4:	00004097          	auipc	ra,0x4
    21a8:	a48080e7          	jalr	-1464(ra) # 5bec <fork>
    if(pid < 0){
    21ac:	02054963          	bltz	a0,21de <kernmem+0x64>
    if(pid == 0){
    21b0:	c529                	beqz	a0,21fa <kernmem+0x80>
    wait(&xstatus);
    21b2:	fbc40513          	addi	a0,s0,-68
    21b6:	00004097          	auipc	ra,0x4
    21ba:	a46080e7          	jalr	-1466(ra) # 5bfc <wait>
    if(xstatus != -1)  // did kernel kill child?
    21be:	fbc42783          	lw	a5,-68(s0)
    21c2:	05579d63          	bne	a5,s5,221c <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21c6:	94ce                	add	s1,s1,s3
    21c8:	fd249ee3          	bne	s1,s2,21a4 <kernmem+0x2a>
}
    21cc:	60a6                	ld	ra,72(sp)
    21ce:	6406                	ld	s0,64(sp)
    21d0:	74e2                	ld	s1,56(sp)
    21d2:	7942                	ld	s2,48(sp)
    21d4:	79a2                	ld	s3,40(sp)
    21d6:	7a02                	ld	s4,32(sp)
    21d8:	6ae2                	ld	s5,24(sp)
    21da:	6161                	addi	sp,sp,80
    21dc:	8082                	ret
      printf("%s: fork failed\n", s);
    21de:	85d2                	mv	a1,s4
    21e0:	00005517          	auipc	a0,0x5
    21e4:	81050513          	addi	a0,a0,-2032 # 69f0 <malloc+0x9c6>
    21e8:	00004097          	auipc	ra,0x4
    21ec:	d84080e7          	jalr	-636(ra) # 5f6c <printf>
      exit(1);
    21f0:	4505                	li	a0,1
    21f2:	00004097          	auipc	ra,0x4
    21f6:	a02080e7          	jalr	-1534(ra) # 5bf4 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    21fa:	0004c683          	lbu	a3,0(s1)
    21fe:	8626                	mv	a2,s1
    2200:	85d2                	mv	a1,s4
    2202:	00005517          	auipc	a0,0x5
    2206:	abe50513          	addi	a0,a0,-1346 # 6cc0 <malloc+0xc96>
    220a:	00004097          	auipc	ra,0x4
    220e:	d62080e7          	jalr	-670(ra) # 5f6c <printf>
      exit(1);
    2212:	4505                	li	a0,1
    2214:	00004097          	auipc	ra,0x4
    2218:	9e0080e7          	jalr	-1568(ra) # 5bf4 <exit>
      exit(1);
    221c:	4505                	li	a0,1
    221e:	00004097          	auipc	ra,0x4
    2222:	9d6080e7          	jalr	-1578(ra) # 5bf4 <exit>

0000000000002226 <MAXVAplus>:
{
    2226:	7179                	addi	sp,sp,-48
    2228:	f406                	sd	ra,40(sp)
    222a:	f022                	sd	s0,32(sp)
    222c:	ec26                	sd	s1,24(sp)
    222e:	e84a                	sd	s2,16(sp)
    2230:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    2232:	4785                	li	a5,1
    2234:	179a                	slli	a5,a5,0x26
    2236:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    223a:	fd843783          	ld	a5,-40(s0)
    223e:	cf85                	beqz	a5,2276 <MAXVAplus+0x50>
    2240:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    2242:	54fd                	li	s1,-1
    pid = fork();
    2244:	00004097          	auipc	ra,0x4
    2248:	9a8080e7          	jalr	-1624(ra) # 5bec <fork>
    if(pid < 0){
    224c:	02054b63          	bltz	a0,2282 <MAXVAplus+0x5c>
    if(pid == 0){
    2250:	c539                	beqz	a0,229e <MAXVAplus+0x78>
    wait(&xstatus);
    2252:	fd440513          	addi	a0,s0,-44
    2256:	00004097          	auipc	ra,0x4
    225a:	9a6080e7          	jalr	-1626(ra) # 5bfc <wait>
    if(xstatus != -1)  // did kernel kill child?
    225e:	fd442783          	lw	a5,-44(s0)
    2262:	06979463          	bne	a5,s1,22ca <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2266:	fd843783          	ld	a5,-40(s0)
    226a:	0786                	slli	a5,a5,0x1
    226c:	fcf43c23          	sd	a5,-40(s0)
    2270:	fd843783          	ld	a5,-40(s0)
    2274:	fbe1                	bnez	a5,2244 <MAXVAplus+0x1e>
}
    2276:	70a2                	ld	ra,40(sp)
    2278:	7402                	ld	s0,32(sp)
    227a:	64e2                	ld	s1,24(sp)
    227c:	6942                	ld	s2,16(sp)
    227e:	6145                	addi	sp,sp,48
    2280:	8082                	ret
      printf("%s: fork failed\n", s);
    2282:	85ca                	mv	a1,s2
    2284:	00004517          	auipc	a0,0x4
    2288:	76c50513          	addi	a0,a0,1900 # 69f0 <malloc+0x9c6>
    228c:	00004097          	auipc	ra,0x4
    2290:	ce0080e7          	jalr	-800(ra) # 5f6c <printf>
      exit(1);
    2294:	4505                	li	a0,1
    2296:	00004097          	auipc	ra,0x4
    229a:	95e080e7          	jalr	-1698(ra) # 5bf4 <exit>
      *(char*)a = 99;
    229e:	fd843783          	ld	a5,-40(s0)
    22a2:	06300713          	li	a4,99
    22a6:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22aa:	fd843603          	ld	a2,-40(s0)
    22ae:	85ca                	mv	a1,s2
    22b0:	00005517          	auipc	a0,0x5
    22b4:	a3050513          	addi	a0,a0,-1488 # 6ce0 <malloc+0xcb6>
    22b8:	00004097          	auipc	ra,0x4
    22bc:	cb4080e7          	jalr	-844(ra) # 5f6c <printf>
      exit(1);
    22c0:	4505                	li	a0,1
    22c2:	00004097          	auipc	ra,0x4
    22c6:	932080e7          	jalr	-1742(ra) # 5bf4 <exit>
      exit(1);
    22ca:	4505                	li	a0,1
    22cc:	00004097          	auipc	ra,0x4
    22d0:	928080e7          	jalr	-1752(ra) # 5bf4 <exit>

00000000000022d4 <bigargtest>:
{
    22d4:	7179                	addi	sp,sp,-48
    22d6:	f406                	sd	ra,40(sp)
    22d8:	f022                	sd	s0,32(sp)
    22da:	ec26                	sd	s1,24(sp)
    22dc:	1800                	addi	s0,sp,48
    22de:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22e0:	00005517          	auipc	a0,0x5
    22e4:	a1850513          	addi	a0,a0,-1512 # 6cf8 <malloc+0xcce>
    22e8:	00004097          	auipc	ra,0x4
    22ec:	95c080e7          	jalr	-1700(ra) # 5c44 <unlink>
  pid = fork();
    22f0:	00004097          	auipc	ra,0x4
    22f4:	8fc080e7          	jalr	-1796(ra) # 5bec <fork>
  if(pid == 0){
    22f8:	c121                	beqz	a0,2338 <bigargtest+0x64>
  } else if(pid < 0){
    22fa:	0a054063          	bltz	a0,239a <bigargtest+0xc6>
  wait(&xstatus);
    22fe:	fdc40513          	addi	a0,s0,-36
    2302:	00004097          	auipc	ra,0x4
    2306:	8fa080e7          	jalr	-1798(ra) # 5bfc <wait>
  if(xstatus != 0)
    230a:	fdc42503          	lw	a0,-36(s0)
    230e:	e545                	bnez	a0,23b6 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2310:	4581                	li	a1,0
    2312:	00005517          	auipc	a0,0x5
    2316:	9e650513          	addi	a0,a0,-1562 # 6cf8 <malloc+0xcce>
    231a:	00004097          	auipc	ra,0x4
    231e:	91a080e7          	jalr	-1766(ra) # 5c34 <open>
  if(fd < 0){
    2322:	08054e63          	bltz	a0,23be <bigargtest+0xea>
  close(fd);
    2326:	00004097          	auipc	ra,0x4
    232a:	8f6080e7          	jalr	-1802(ra) # 5c1c <close>
}
    232e:	70a2                	ld	ra,40(sp)
    2330:	7402                	ld	s0,32(sp)
    2332:	64e2                	ld	s1,24(sp)
    2334:	6145                	addi	sp,sp,48
    2336:	8082                	ret
    2338:	00007797          	auipc	a5,0x7
    233c:	12878793          	addi	a5,a5,296 # 9460 <args.1>
    2340:	00007697          	auipc	a3,0x7
    2344:	21868693          	addi	a3,a3,536 # 9558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2348:	00005717          	auipc	a4,0x5
    234c:	9c070713          	addi	a4,a4,-1600 # 6d08 <malloc+0xcde>
    2350:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2352:	07a1                	addi	a5,a5,8
    2354:	fed79ee3          	bne	a5,a3,2350 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2358:	00007597          	auipc	a1,0x7
    235c:	10858593          	addi	a1,a1,264 # 9460 <args.1>
    2360:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2364:	00004517          	auipc	a0,0x4
    2368:	e0450513          	addi	a0,a0,-508 # 6168 <malloc+0x13e>
    236c:	00004097          	auipc	ra,0x4
    2370:	8c0080e7          	jalr	-1856(ra) # 5c2c <exec>
    fd = open("bigarg-ok", O_CREATE);
    2374:	20000593          	li	a1,512
    2378:	00005517          	auipc	a0,0x5
    237c:	98050513          	addi	a0,a0,-1664 # 6cf8 <malloc+0xcce>
    2380:	00004097          	auipc	ra,0x4
    2384:	8b4080e7          	jalr	-1868(ra) # 5c34 <open>
    close(fd);
    2388:	00004097          	auipc	ra,0x4
    238c:	894080e7          	jalr	-1900(ra) # 5c1c <close>
    exit(0);
    2390:	4501                	li	a0,0
    2392:	00004097          	auipc	ra,0x4
    2396:	862080e7          	jalr	-1950(ra) # 5bf4 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    239a:	85a6                	mv	a1,s1
    239c:	00005517          	auipc	a0,0x5
    23a0:	a4c50513          	addi	a0,a0,-1460 # 6de8 <malloc+0xdbe>
    23a4:	00004097          	auipc	ra,0x4
    23a8:	bc8080e7          	jalr	-1080(ra) # 5f6c <printf>
    exit(1);
    23ac:	4505                	li	a0,1
    23ae:	00004097          	auipc	ra,0x4
    23b2:	846080e7          	jalr	-1978(ra) # 5bf4 <exit>
    exit(xstatus);
    23b6:	00004097          	auipc	ra,0x4
    23ba:	83e080e7          	jalr	-1986(ra) # 5bf4 <exit>
    printf("%s: bigarg test failed!\n", s);
    23be:	85a6                	mv	a1,s1
    23c0:	00005517          	auipc	a0,0x5
    23c4:	a4850513          	addi	a0,a0,-1464 # 6e08 <malloc+0xdde>
    23c8:	00004097          	auipc	ra,0x4
    23cc:	ba4080e7          	jalr	-1116(ra) # 5f6c <printf>
    exit(1);
    23d0:	4505                	li	a0,1
    23d2:	00004097          	auipc	ra,0x4
    23d6:	822080e7          	jalr	-2014(ra) # 5bf4 <exit>

00000000000023da <stacktest>:
{
    23da:	7179                	addi	sp,sp,-48
    23dc:	f406                	sd	ra,40(sp)
    23de:	f022                	sd	s0,32(sp)
    23e0:	ec26                	sd	s1,24(sp)
    23e2:	1800                	addi	s0,sp,48
    23e4:	84aa                	mv	s1,a0
  pid = fork();
    23e6:	00004097          	auipc	ra,0x4
    23ea:	806080e7          	jalr	-2042(ra) # 5bec <fork>
  if(pid == 0) {
    23ee:	c115                	beqz	a0,2412 <stacktest+0x38>
  } else if(pid < 0){
    23f0:	04054463          	bltz	a0,2438 <stacktest+0x5e>
  wait(&xstatus);
    23f4:	fdc40513          	addi	a0,s0,-36
    23f8:	00004097          	auipc	ra,0x4
    23fc:	804080e7          	jalr	-2044(ra) # 5bfc <wait>
  if(xstatus == -1)  // kernel killed child?
    2400:	fdc42503          	lw	a0,-36(s0)
    2404:	57fd                	li	a5,-1
    2406:	04f50763          	beq	a0,a5,2454 <stacktest+0x7a>
    exit(xstatus);
    240a:	00003097          	auipc	ra,0x3
    240e:	7ea080e7          	jalr	2026(ra) # 5bf4 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2412:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2414:	77fd                	lui	a5,0xfffff
    2416:	97ba                	add	a5,a5,a4
    2418:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    241c:	85a6                	mv	a1,s1
    241e:	00005517          	auipc	a0,0x5
    2422:	a0a50513          	addi	a0,a0,-1526 # 6e28 <malloc+0xdfe>
    2426:	00004097          	auipc	ra,0x4
    242a:	b46080e7          	jalr	-1210(ra) # 5f6c <printf>
    exit(1);
    242e:	4505                	li	a0,1
    2430:	00003097          	auipc	ra,0x3
    2434:	7c4080e7          	jalr	1988(ra) # 5bf4 <exit>
    printf("%s: fork failed\n", s);
    2438:	85a6                	mv	a1,s1
    243a:	00004517          	auipc	a0,0x4
    243e:	5b650513          	addi	a0,a0,1462 # 69f0 <malloc+0x9c6>
    2442:	00004097          	auipc	ra,0x4
    2446:	b2a080e7          	jalr	-1238(ra) # 5f6c <printf>
    exit(1);
    244a:	4505                	li	a0,1
    244c:	00003097          	auipc	ra,0x3
    2450:	7a8080e7          	jalr	1960(ra) # 5bf4 <exit>
    exit(0);
    2454:	4501                	li	a0,0
    2456:	00003097          	auipc	ra,0x3
    245a:	79e080e7          	jalr	1950(ra) # 5bf4 <exit>

000000000000245e <textwrite>:
{
    245e:	7179                	addi	sp,sp,-48
    2460:	f406                	sd	ra,40(sp)
    2462:	f022                	sd	s0,32(sp)
    2464:	ec26                	sd	s1,24(sp)
    2466:	1800                	addi	s0,sp,48
    2468:	84aa                	mv	s1,a0
  pid = fork();
    246a:	00003097          	auipc	ra,0x3
    246e:	782080e7          	jalr	1922(ra) # 5bec <fork>
  if(pid == 0) {
    2472:	c115                	beqz	a0,2496 <textwrite+0x38>
  } else if(pid < 0){
    2474:	02054963          	bltz	a0,24a6 <textwrite+0x48>
  wait(&xstatus);
    2478:	fdc40513          	addi	a0,s0,-36
    247c:	00003097          	auipc	ra,0x3
    2480:	780080e7          	jalr	1920(ra) # 5bfc <wait>
  if(xstatus == -1)  // kernel killed child?
    2484:	fdc42503          	lw	a0,-36(s0)
    2488:	57fd                	li	a5,-1
    248a:	02f50c63          	beq	a0,a5,24c2 <textwrite+0x64>
    exit(xstatus);
    248e:	00003097          	auipc	ra,0x3
    2492:	766080e7          	jalr	1894(ra) # 5bf4 <exit>
    *addr = 10;
    2496:	47a9                	li	a5,10
    2498:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    249c:	4505                	li	a0,1
    249e:	00003097          	auipc	ra,0x3
    24a2:	756080e7          	jalr	1878(ra) # 5bf4 <exit>
    printf("%s: fork failed\n", s);
    24a6:	85a6                	mv	a1,s1
    24a8:	00004517          	auipc	a0,0x4
    24ac:	54850513          	addi	a0,a0,1352 # 69f0 <malloc+0x9c6>
    24b0:	00004097          	auipc	ra,0x4
    24b4:	abc080e7          	jalr	-1348(ra) # 5f6c <printf>
    exit(1);
    24b8:	4505                	li	a0,1
    24ba:	00003097          	auipc	ra,0x3
    24be:	73a080e7          	jalr	1850(ra) # 5bf4 <exit>
    exit(0);
    24c2:	4501                	li	a0,0
    24c4:	00003097          	auipc	ra,0x3
    24c8:	730080e7          	jalr	1840(ra) # 5bf4 <exit>

00000000000024cc <manywrites>:
{
    24cc:	711d                	addi	sp,sp,-96
    24ce:	ec86                	sd	ra,88(sp)
    24d0:	e8a2                	sd	s0,80(sp)
    24d2:	e4a6                	sd	s1,72(sp)
    24d4:	e0ca                	sd	s2,64(sp)
    24d6:	fc4e                	sd	s3,56(sp)
    24d8:	f852                	sd	s4,48(sp)
    24da:	f456                	sd	s5,40(sp)
    24dc:	f05a                	sd	s6,32(sp)
    24de:	ec5e                	sd	s7,24(sp)
    24e0:	1080                	addi	s0,sp,96
    24e2:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    24e4:	4981                	li	s3,0
    24e6:	4911                	li	s2,4
    int pid = fork();
    24e8:	00003097          	auipc	ra,0x3
    24ec:	704080e7          	jalr	1796(ra) # 5bec <fork>
    24f0:	84aa                	mv	s1,a0
    if(pid < 0){
    24f2:	02054963          	bltz	a0,2524 <manywrites+0x58>
    if(pid == 0){
    24f6:	c521                	beqz	a0,253e <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    24f8:	2985                	addiw	s3,s3,1
    24fa:	ff2997e3          	bne	s3,s2,24e8 <manywrites+0x1c>
    24fe:	4491                	li	s1,4
    int st = 0;
    2500:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2504:	fa840513          	addi	a0,s0,-88
    2508:	00003097          	auipc	ra,0x3
    250c:	6f4080e7          	jalr	1780(ra) # 5bfc <wait>
    if(st != 0)
    2510:	fa842503          	lw	a0,-88(s0)
    2514:	ed6d                	bnez	a0,260e <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    2516:	34fd                	addiw	s1,s1,-1
    2518:	f4e5                	bnez	s1,2500 <manywrites+0x34>
  exit(0);
    251a:	4501                	li	a0,0
    251c:	00003097          	auipc	ra,0x3
    2520:	6d8080e7          	jalr	1752(ra) # 5bf4 <exit>
      printf("fork failed\n");
    2524:	00005517          	auipc	a0,0x5
    2528:	8d450513          	addi	a0,a0,-1836 # 6df8 <malloc+0xdce>
    252c:	00004097          	auipc	ra,0x4
    2530:	a40080e7          	jalr	-1472(ra) # 5f6c <printf>
      exit(1);
    2534:	4505                	li	a0,1
    2536:	00003097          	auipc	ra,0x3
    253a:	6be080e7          	jalr	1726(ra) # 5bf4 <exit>
      name[0] = 'b';
    253e:	06200793          	li	a5,98
    2542:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2546:	0619879b          	addiw	a5,s3,97
    254a:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    254e:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    2552:	fa840513          	addi	a0,s0,-88
    2556:	00003097          	auipc	ra,0x3
    255a:	6ee080e7          	jalr	1774(ra) # 5c44 <unlink>
    255e:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    2560:	0000ab17          	auipc	s6,0xa
    2564:	718b0b13          	addi	s6,s6,1816 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2568:	8a26                	mv	s4,s1
    256a:	0209ce63          	bltz	s3,25a6 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    256e:	20200593          	li	a1,514
    2572:	fa840513          	addi	a0,s0,-88
    2576:	00003097          	auipc	ra,0x3
    257a:	6be080e7          	jalr	1726(ra) # 5c34 <open>
    257e:	892a                	mv	s2,a0
          if(fd < 0){
    2580:	04054763          	bltz	a0,25ce <manywrites+0x102>
          int cc = write(fd, buf, sz);
    2584:	660d                	lui	a2,0x3
    2586:	85da                	mv	a1,s6
    2588:	00003097          	auipc	ra,0x3
    258c:	68c080e7          	jalr	1676(ra) # 5c14 <write>
          if(cc != sz){
    2590:	678d                	lui	a5,0x3
    2592:	04f51e63          	bne	a0,a5,25ee <manywrites+0x122>
          close(fd);
    2596:	854a                	mv	a0,s2
    2598:	00003097          	auipc	ra,0x3
    259c:	684080e7          	jalr	1668(ra) # 5c1c <close>
        for(int i = 0; i < ci+1; i++){
    25a0:	2a05                	addiw	s4,s4,1
    25a2:	fd49d6e3          	bge	s3,s4,256e <manywrites+0xa2>
        unlink(name);
    25a6:	fa840513          	addi	a0,s0,-88
    25aa:	00003097          	auipc	ra,0x3
    25ae:	69a080e7          	jalr	1690(ra) # 5c44 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25b2:	3bfd                	addiw	s7,s7,-1
    25b4:	fa0b9ae3          	bnez	s7,2568 <manywrites+0x9c>
      unlink(name);
    25b8:	fa840513          	addi	a0,s0,-88
    25bc:	00003097          	auipc	ra,0x3
    25c0:	688080e7          	jalr	1672(ra) # 5c44 <unlink>
      exit(0);
    25c4:	4501                	li	a0,0
    25c6:	00003097          	auipc	ra,0x3
    25ca:	62e080e7          	jalr	1582(ra) # 5bf4 <exit>
            printf("%s: cannot create %s\n", s, name);
    25ce:	fa840613          	addi	a2,s0,-88
    25d2:	85d6                	mv	a1,s5
    25d4:	00005517          	auipc	a0,0x5
    25d8:	87c50513          	addi	a0,a0,-1924 # 6e50 <malloc+0xe26>
    25dc:	00004097          	auipc	ra,0x4
    25e0:	990080e7          	jalr	-1648(ra) # 5f6c <printf>
            exit(1);
    25e4:	4505                	li	a0,1
    25e6:	00003097          	auipc	ra,0x3
    25ea:	60e080e7          	jalr	1550(ra) # 5bf4 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25ee:	86aa                	mv	a3,a0
    25f0:	660d                	lui	a2,0x3
    25f2:	85d6                	mv	a1,s5
    25f4:	00004517          	auipc	a0,0x4
    25f8:	c4450513          	addi	a0,a0,-956 # 6238 <malloc+0x20e>
    25fc:	00004097          	auipc	ra,0x4
    2600:	970080e7          	jalr	-1680(ra) # 5f6c <printf>
            exit(1);
    2604:	4505                	li	a0,1
    2606:	00003097          	auipc	ra,0x3
    260a:	5ee080e7          	jalr	1518(ra) # 5bf4 <exit>
      exit(st);
    260e:	00003097          	auipc	ra,0x3
    2612:	5e6080e7          	jalr	1510(ra) # 5bf4 <exit>

0000000000002616 <copyinstr3>:
{
    2616:	7179                	addi	sp,sp,-48
    2618:	f406                	sd	ra,40(sp)
    261a:	f022                	sd	s0,32(sp)
    261c:	ec26                	sd	s1,24(sp)
    261e:	1800                	addi	s0,sp,48
  sbrk(8192);
    2620:	6509                	lui	a0,0x2
    2622:	00003097          	auipc	ra,0x3
    2626:	65a080e7          	jalr	1626(ra) # 5c7c <sbrk>
  uint64 top = (uint64) sbrk(0);
    262a:	4501                	li	a0,0
    262c:	00003097          	auipc	ra,0x3
    2630:	650080e7          	jalr	1616(ra) # 5c7c <sbrk>
  if((top % PGSIZE) != 0){
    2634:	03451793          	slli	a5,a0,0x34
    2638:	e3c9                	bnez	a5,26ba <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    263a:	4501                	li	a0,0
    263c:	00003097          	auipc	ra,0x3
    2640:	640080e7          	jalr	1600(ra) # 5c7c <sbrk>
  if(top % PGSIZE){
    2644:	03451793          	slli	a5,a0,0x34
    2648:	e3d9                	bnez	a5,26ce <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    264a:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x67>
  *b = 'x';
    264e:	07800793          	li	a5,120
    2652:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2656:	8526                	mv	a0,s1
    2658:	00003097          	auipc	ra,0x3
    265c:	5ec080e7          	jalr	1516(ra) # 5c44 <unlink>
  if(ret != -1){
    2660:	57fd                	li	a5,-1
    2662:	08f51363          	bne	a0,a5,26e8 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2666:	20100593          	li	a1,513
    266a:	8526                	mv	a0,s1
    266c:	00003097          	auipc	ra,0x3
    2670:	5c8080e7          	jalr	1480(ra) # 5c34 <open>
  if(fd != -1){
    2674:	57fd                	li	a5,-1
    2676:	08f51863          	bne	a0,a5,2706 <copyinstr3+0xf0>
  ret = link(b, b);
    267a:	85a6                	mv	a1,s1
    267c:	8526                	mv	a0,s1
    267e:	00003097          	auipc	ra,0x3
    2682:	5d6080e7          	jalr	1494(ra) # 5c54 <link>
  if(ret != -1){
    2686:	57fd                	li	a5,-1
    2688:	08f51e63          	bne	a0,a5,2724 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    268c:	00005797          	auipc	a5,0x5
    2690:	4bc78793          	addi	a5,a5,1212 # 7b48 <malloc+0x1b1e>
    2694:	fcf43823          	sd	a5,-48(s0)
    2698:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    269c:	fd040593          	addi	a1,s0,-48
    26a0:	8526                	mv	a0,s1
    26a2:	00003097          	auipc	ra,0x3
    26a6:	58a080e7          	jalr	1418(ra) # 5c2c <exec>
  if(ret != -1){
    26aa:	57fd                	li	a5,-1
    26ac:	08f51c63          	bne	a0,a5,2744 <copyinstr3+0x12e>
}
    26b0:	70a2                	ld	ra,40(sp)
    26b2:	7402                	ld	s0,32(sp)
    26b4:	64e2                	ld	s1,24(sp)
    26b6:	6145                	addi	sp,sp,48
    26b8:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26ba:	0347d513          	srli	a0,a5,0x34
    26be:	6785                	lui	a5,0x1
    26c0:	40a7853b          	subw	a0,a5,a0
    26c4:	00003097          	auipc	ra,0x3
    26c8:	5b8080e7          	jalr	1464(ra) # 5c7c <sbrk>
    26cc:	b7bd                	j	263a <copyinstr3+0x24>
    printf("oops\n");
    26ce:	00004517          	auipc	a0,0x4
    26d2:	79a50513          	addi	a0,a0,1946 # 6e68 <malloc+0xe3e>
    26d6:	00004097          	auipc	ra,0x4
    26da:	896080e7          	jalr	-1898(ra) # 5f6c <printf>
    exit(1);
    26de:	4505                	li	a0,1
    26e0:	00003097          	auipc	ra,0x3
    26e4:	514080e7          	jalr	1300(ra) # 5bf4 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26e8:	862a                	mv	a2,a0
    26ea:	85a6                	mv	a1,s1
    26ec:	00004517          	auipc	a0,0x4
    26f0:	22450513          	addi	a0,a0,548 # 6910 <malloc+0x8e6>
    26f4:	00004097          	auipc	ra,0x4
    26f8:	878080e7          	jalr	-1928(ra) # 5f6c <printf>
    exit(1);
    26fc:	4505                	li	a0,1
    26fe:	00003097          	auipc	ra,0x3
    2702:	4f6080e7          	jalr	1270(ra) # 5bf4 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2706:	862a                	mv	a2,a0
    2708:	85a6                	mv	a1,s1
    270a:	00004517          	auipc	a0,0x4
    270e:	22650513          	addi	a0,a0,550 # 6930 <malloc+0x906>
    2712:	00004097          	auipc	ra,0x4
    2716:	85a080e7          	jalr	-1958(ra) # 5f6c <printf>
    exit(1);
    271a:	4505                	li	a0,1
    271c:	00003097          	auipc	ra,0x3
    2720:	4d8080e7          	jalr	1240(ra) # 5bf4 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2724:	86aa                	mv	a3,a0
    2726:	8626                	mv	a2,s1
    2728:	85a6                	mv	a1,s1
    272a:	00004517          	auipc	a0,0x4
    272e:	22650513          	addi	a0,a0,550 # 6950 <malloc+0x926>
    2732:	00004097          	auipc	ra,0x4
    2736:	83a080e7          	jalr	-1990(ra) # 5f6c <printf>
    exit(1);
    273a:	4505                	li	a0,1
    273c:	00003097          	auipc	ra,0x3
    2740:	4b8080e7          	jalr	1208(ra) # 5bf4 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2744:	567d                	li	a2,-1
    2746:	85a6                	mv	a1,s1
    2748:	00004517          	auipc	a0,0x4
    274c:	23050513          	addi	a0,a0,560 # 6978 <malloc+0x94e>
    2750:	00004097          	auipc	ra,0x4
    2754:	81c080e7          	jalr	-2020(ra) # 5f6c <printf>
    exit(1);
    2758:	4505                	li	a0,1
    275a:	00003097          	auipc	ra,0x3
    275e:	49a080e7          	jalr	1178(ra) # 5bf4 <exit>

0000000000002762 <rwsbrk>:
{
    2762:	1101                	addi	sp,sp,-32
    2764:	ec06                	sd	ra,24(sp)
    2766:	e822                	sd	s0,16(sp)
    2768:	e426                	sd	s1,8(sp)
    276a:	e04a                	sd	s2,0(sp)
    276c:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    276e:	6509                	lui	a0,0x2
    2770:	00003097          	auipc	ra,0x3
    2774:	50c080e7          	jalr	1292(ra) # 5c7c <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2778:	57fd                	li	a5,-1
    277a:	06f50363          	beq	a0,a5,27e0 <rwsbrk+0x7e>
    277e:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2780:	7579                	lui	a0,0xffffe
    2782:	00003097          	auipc	ra,0x3
    2786:	4fa080e7          	jalr	1274(ra) # 5c7c <sbrk>
    278a:	57fd                	li	a5,-1
    278c:	06f50763          	beq	a0,a5,27fa <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2790:	20100593          	li	a1,513
    2794:	00004517          	auipc	a0,0x4
    2798:	71450513          	addi	a0,a0,1812 # 6ea8 <malloc+0xe7e>
    279c:	00003097          	auipc	ra,0x3
    27a0:	498080e7          	jalr	1176(ra) # 5c34 <open>
    27a4:	892a                	mv	s2,a0
  if(fd < 0){
    27a6:	06054763          	bltz	a0,2814 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    27aa:	6505                	lui	a0,0x1
    27ac:	94aa                	add	s1,s1,a0
    27ae:	40000613          	li	a2,1024
    27b2:	85a6                	mv	a1,s1
    27b4:	854a                	mv	a0,s2
    27b6:	00003097          	auipc	ra,0x3
    27ba:	45e080e7          	jalr	1118(ra) # 5c14 <write>
    27be:	862a                	mv	a2,a0
  if(n >= 0){
    27c0:	06054763          	bltz	a0,282e <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    27c4:	85a6                	mv	a1,s1
    27c6:	00004517          	auipc	a0,0x4
    27ca:	70250513          	addi	a0,a0,1794 # 6ec8 <malloc+0xe9e>
    27ce:	00003097          	auipc	ra,0x3
    27d2:	79e080e7          	jalr	1950(ra) # 5f6c <printf>
    exit(1);
    27d6:	4505                	li	a0,1
    27d8:	00003097          	auipc	ra,0x3
    27dc:	41c080e7          	jalr	1052(ra) # 5bf4 <exit>
    printf("sbrk(rwsbrk) failed\n");
    27e0:	00004517          	auipc	a0,0x4
    27e4:	69050513          	addi	a0,a0,1680 # 6e70 <malloc+0xe46>
    27e8:	00003097          	auipc	ra,0x3
    27ec:	784080e7          	jalr	1924(ra) # 5f6c <printf>
    exit(1);
    27f0:	4505                	li	a0,1
    27f2:	00003097          	auipc	ra,0x3
    27f6:	402080e7          	jalr	1026(ra) # 5bf4 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    27fa:	00004517          	auipc	a0,0x4
    27fe:	68e50513          	addi	a0,a0,1678 # 6e88 <malloc+0xe5e>
    2802:	00003097          	auipc	ra,0x3
    2806:	76a080e7          	jalr	1898(ra) # 5f6c <printf>
    exit(1);
    280a:	4505                	li	a0,1
    280c:	00003097          	auipc	ra,0x3
    2810:	3e8080e7          	jalr	1000(ra) # 5bf4 <exit>
    printf("open(rwsbrk) failed\n");
    2814:	00004517          	auipc	a0,0x4
    2818:	69c50513          	addi	a0,a0,1692 # 6eb0 <malloc+0xe86>
    281c:	00003097          	auipc	ra,0x3
    2820:	750080e7          	jalr	1872(ra) # 5f6c <printf>
    exit(1);
    2824:	4505                	li	a0,1
    2826:	00003097          	auipc	ra,0x3
    282a:	3ce080e7          	jalr	974(ra) # 5bf4 <exit>
  close(fd);
    282e:	854a                	mv	a0,s2
    2830:	00003097          	auipc	ra,0x3
    2834:	3ec080e7          	jalr	1004(ra) # 5c1c <close>
  unlink("rwsbrk");
    2838:	00004517          	auipc	a0,0x4
    283c:	67050513          	addi	a0,a0,1648 # 6ea8 <malloc+0xe7e>
    2840:	00003097          	auipc	ra,0x3
    2844:	404080e7          	jalr	1028(ra) # 5c44 <unlink>
  fd = open("README", O_RDONLY);
    2848:	4581                	li	a1,0
    284a:	00004517          	auipc	a0,0x4
    284e:	af650513          	addi	a0,a0,-1290 # 6340 <malloc+0x316>
    2852:	00003097          	auipc	ra,0x3
    2856:	3e2080e7          	jalr	994(ra) # 5c34 <open>
    285a:	892a                	mv	s2,a0
  if(fd < 0){
    285c:	02054963          	bltz	a0,288e <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    2860:	4629                	li	a2,10
    2862:	85a6                	mv	a1,s1
    2864:	00003097          	auipc	ra,0x3
    2868:	3a8080e7          	jalr	936(ra) # 5c0c <read>
    286c:	862a                	mv	a2,a0
  if(n >= 0){
    286e:	02054d63          	bltz	a0,28a8 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2872:	85a6                	mv	a1,s1
    2874:	00004517          	auipc	a0,0x4
    2878:	68450513          	addi	a0,a0,1668 # 6ef8 <malloc+0xece>
    287c:	00003097          	auipc	ra,0x3
    2880:	6f0080e7          	jalr	1776(ra) # 5f6c <printf>
    exit(1);
    2884:	4505                	li	a0,1
    2886:	00003097          	auipc	ra,0x3
    288a:	36e080e7          	jalr	878(ra) # 5bf4 <exit>
    printf("open(rwsbrk) failed\n");
    288e:	00004517          	auipc	a0,0x4
    2892:	62250513          	addi	a0,a0,1570 # 6eb0 <malloc+0xe86>
    2896:	00003097          	auipc	ra,0x3
    289a:	6d6080e7          	jalr	1750(ra) # 5f6c <printf>
    exit(1);
    289e:	4505                	li	a0,1
    28a0:	00003097          	auipc	ra,0x3
    28a4:	354080e7          	jalr	852(ra) # 5bf4 <exit>
  close(fd);
    28a8:	854a                	mv	a0,s2
    28aa:	00003097          	auipc	ra,0x3
    28ae:	372080e7          	jalr	882(ra) # 5c1c <close>
  exit(0);
    28b2:	4501                	li	a0,0
    28b4:	00003097          	auipc	ra,0x3
    28b8:	340080e7          	jalr	832(ra) # 5bf4 <exit>

00000000000028bc <sbrkbasic>:
{
    28bc:	7139                	addi	sp,sp,-64
    28be:	fc06                	sd	ra,56(sp)
    28c0:	f822                	sd	s0,48(sp)
    28c2:	f426                	sd	s1,40(sp)
    28c4:	f04a                	sd	s2,32(sp)
    28c6:	ec4e                	sd	s3,24(sp)
    28c8:	e852                	sd	s4,16(sp)
    28ca:	0080                	addi	s0,sp,64
    28cc:	8a2a                	mv	s4,a0
  pid = fork();
    28ce:	00003097          	auipc	ra,0x3
    28d2:	31e080e7          	jalr	798(ra) # 5bec <fork>
  if(pid < 0){
    28d6:	02054c63          	bltz	a0,290e <sbrkbasic+0x52>
  if(pid == 0){
    28da:	ed21                	bnez	a0,2932 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    28dc:	40000537          	lui	a0,0x40000
    28e0:	00003097          	auipc	ra,0x3
    28e4:	39c080e7          	jalr	924(ra) # 5c7c <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    28e8:	57fd                	li	a5,-1
    28ea:	02f50f63          	beq	a0,a5,2928 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28ee:	400007b7          	lui	a5,0x40000
    28f2:	97aa                	add	a5,a5,a0
      *b = 99;
    28f4:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    28f8:	6705                	lui	a4,0x1
      *b = 99;
    28fa:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28fe:	953a                	add	a0,a0,a4
    2900:	fef51de3          	bne	a0,a5,28fa <sbrkbasic+0x3e>
    exit(1);
    2904:	4505                	li	a0,1
    2906:	00003097          	auipc	ra,0x3
    290a:	2ee080e7          	jalr	750(ra) # 5bf4 <exit>
    printf("fork failed in sbrkbasic\n");
    290e:	00004517          	auipc	a0,0x4
    2912:	61250513          	addi	a0,a0,1554 # 6f20 <malloc+0xef6>
    2916:	00003097          	auipc	ra,0x3
    291a:	656080e7          	jalr	1622(ra) # 5f6c <printf>
    exit(1);
    291e:	4505                	li	a0,1
    2920:	00003097          	auipc	ra,0x3
    2924:	2d4080e7          	jalr	724(ra) # 5bf4 <exit>
      exit(0);
    2928:	4501                	li	a0,0
    292a:	00003097          	auipc	ra,0x3
    292e:	2ca080e7          	jalr	714(ra) # 5bf4 <exit>
  wait(&xstatus);
    2932:	fcc40513          	addi	a0,s0,-52
    2936:	00003097          	auipc	ra,0x3
    293a:	2c6080e7          	jalr	710(ra) # 5bfc <wait>
  if(xstatus == 1){
    293e:	fcc42703          	lw	a4,-52(s0)
    2942:	4785                	li	a5,1
    2944:	00f70d63          	beq	a4,a5,295e <sbrkbasic+0xa2>
  a = sbrk(0);
    2948:	4501                	li	a0,0
    294a:	00003097          	auipc	ra,0x3
    294e:	332080e7          	jalr	818(ra) # 5c7c <sbrk>
    2952:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2954:	4901                	li	s2,0
    2956:	6985                	lui	s3,0x1
    2958:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x34>
    295c:	a005                	j	297c <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    295e:	85d2                	mv	a1,s4
    2960:	00004517          	auipc	a0,0x4
    2964:	5e050513          	addi	a0,a0,1504 # 6f40 <malloc+0xf16>
    2968:	00003097          	auipc	ra,0x3
    296c:	604080e7          	jalr	1540(ra) # 5f6c <printf>
    exit(1);
    2970:	4505                	li	a0,1
    2972:	00003097          	auipc	ra,0x3
    2976:	282080e7          	jalr	642(ra) # 5bf4 <exit>
    a = b + 1;
    297a:	84be                	mv	s1,a5
    b = sbrk(1);
    297c:	4505                	li	a0,1
    297e:	00003097          	auipc	ra,0x3
    2982:	2fe080e7          	jalr	766(ra) # 5c7c <sbrk>
    if(b != a){
    2986:	04951c63          	bne	a0,s1,29de <sbrkbasic+0x122>
    *b = 1;
    298a:	4785                	li	a5,1
    298c:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2990:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2994:	2905                	addiw	s2,s2,1
    2996:	ff3912e3          	bne	s2,s3,297a <sbrkbasic+0xbe>
  pid = fork();
    299a:	00003097          	auipc	ra,0x3
    299e:	252080e7          	jalr	594(ra) # 5bec <fork>
    29a2:	892a                	mv	s2,a0
  if(pid < 0){
    29a4:	04054e63          	bltz	a0,2a00 <sbrkbasic+0x144>
  c = sbrk(1);
    29a8:	4505                	li	a0,1
    29aa:	00003097          	auipc	ra,0x3
    29ae:	2d2080e7          	jalr	722(ra) # 5c7c <sbrk>
  c = sbrk(1);
    29b2:	4505                	li	a0,1
    29b4:	00003097          	auipc	ra,0x3
    29b8:	2c8080e7          	jalr	712(ra) # 5c7c <sbrk>
  if(c != a + 1){
    29bc:	0489                	addi	s1,s1,2
    29be:	04a48f63          	beq	s1,a0,2a1c <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    29c2:	85d2                	mv	a1,s4
    29c4:	00004517          	auipc	a0,0x4
    29c8:	5dc50513          	addi	a0,a0,1500 # 6fa0 <malloc+0xf76>
    29cc:	00003097          	auipc	ra,0x3
    29d0:	5a0080e7          	jalr	1440(ra) # 5f6c <printf>
    exit(1);
    29d4:	4505                	li	a0,1
    29d6:	00003097          	auipc	ra,0x3
    29da:	21e080e7          	jalr	542(ra) # 5bf4 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29de:	872a                	mv	a4,a0
    29e0:	86a6                	mv	a3,s1
    29e2:	864a                	mv	a2,s2
    29e4:	85d2                	mv	a1,s4
    29e6:	00004517          	auipc	a0,0x4
    29ea:	57a50513          	addi	a0,a0,1402 # 6f60 <malloc+0xf36>
    29ee:	00003097          	auipc	ra,0x3
    29f2:	57e080e7          	jalr	1406(ra) # 5f6c <printf>
      exit(1);
    29f6:	4505                	li	a0,1
    29f8:	00003097          	auipc	ra,0x3
    29fc:	1fc080e7          	jalr	508(ra) # 5bf4 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2a00:	85d2                	mv	a1,s4
    2a02:	00004517          	auipc	a0,0x4
    2a06:	57e50513          	addi	a0,a0,1406 # 6f80 <malloc+0xf56>
    2a0a:	00003097          	auipc	ra,0x3
    2a0e:	562080e7          	jalr	1378(ra) # 5f6c <printf>
    exit(1);
    2a12:	4505                	li	a0,1
    2a14:	00003097          	auipc	ra,0x3
    2a18:	1e0080e7          	jalr	480(ra) # 5bf4 <exit>
  if(pid == 0)
    2a1c:	00091763          	bnez	s2,2a2a <sbrkbasic+0x16e>
    exit(0);
    2a20:	4501                	li	a0,0
    2a22:	00003097          	auipc	ra,0x3
    2a26:	1d2080e7          	jalr	466(ra) # 5bf4 <exit>
  wait(&xstatus);
    2a2a:	fcc40513          	addi	a0,s0,-52
    2a2e:	00003097          	auipc	ra,0x3
    2a32:	1ce080e7          	jalr	462(ra) # 5bfc <wait>
  exit(xstatus);
    2a36:	fcc42503          	lw	a0,-52(s0)
    2a3a:	00003097          	auipc	ra,0x3
    2a3e:	1ba080e7          	jalr	442(ra) # 5bf4 <exit>

0000000000002a42 <sbrkmuch>:
{
    2a42:	7179                	addi	sp,sp,-48
    2a44:	f406                	sd	ra,40(sp)
    2a46:	f022                	sd	s0,32(sp)
    2a48:	ec26                	sd	s1,24(sp)
    2a4a:	e84a                	sd	s2,16(sp)
    2a4c:	e44e                	sd	s3,8(sp)
    2a4e:	e052                	sd	s4,0(sp)
    2a50:	1800                	addi	s0,sp,48
    2a52:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a54:	4501                	li	a0,0
    2a56:	00003097          	auipc	ra,0x3
    2a5a:	226080e7          	jalr	550(ra) # 5c7c <sbrk>
    2a5e:	892a                	mv	s2,a0
  a = sbrk(0);
    2a60:	4501                	li	a0,0
    2a62:	00003097          	auipc	ra,0x3
    2a66:	21a080e7          	jalr	538(ra) # 5c7c <sbrk>
    2a6a:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a6c:	06400537          	lui	a0,0x6400
    2a70:	9d05                	subw	a0,a0,s1
    2a72:	00003097          	auipc	ra,0x3
    2a76:	20a080e7          	jalr	522(ra) # 5c7c <sbrk>
  if (p != a) {
    2a7a:	0ca49863          	bne	s1,a0,2b4a <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a7e:	4501                	li	a0,0
    2a80:	00003097          	auipc	ra,0x3
    2a84:	1fc080e7          	jalr	508(ra) # 5c7c <sbrk>
    2a88:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2a8a:	00a4f963          	bgeu	s1,a0,2a9c <sbrkmuch+0x5a>
    *pp = 1;
    2a8e:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2a90:	6705                	lui	a4,0x1
    *pp = 1;
    2a92:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2a96:	94ba                	add	s1,s1,a4
    2a98:	fef4ede3          	bltu	s1,a5,2a92 <sbrkmuch+0x50>
  *lastaddr = 99;
    2a9c:	064007b7          	lui	a5,0x6400
    2aa0:	06300713          	li	a4,99
    2aa4:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2aa8:	4501                	li	a0,0
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	1d2080e7          	jalr	466(ra) # 5c7c <sbrk>
    2ab2:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2ab4:	757d                	lui	a0,0xfffff
    2ab6:	00003097          	auipc	ra,0x3
    2aba:	1c6080e7          	jalr	454(ra) # 5c7c <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2abe:	57fd                	li	a5,-1
    2ac0:	0af50363          	beq	a0,a5,2b66 <sbrkmuch+0x124>
  c = sbrk(0);
    2ac4:	4501                	li	a0,0
    2ac6:	00003097          	auipc	ra,0x3
    2aca:	1b6080e7          	jalr	438(ra) # 5c7c <sbrk>
  if(c != a - PGSIZE){
    2ace:	77fd                	lui	a5,0xfffff
    2ad0:	97a6                	add	a5,a5,s1
    2ad2:	0af51863          	bne	a0,a5,2b82 <sbrkmuch+0x140>
  a = sbrk(0);
    2ad6:	4501                	li	a0,0
    2ad8:	00003097          	auipc	ra,0x3
    2adc:	1a4080e7          	jalr	420(ra) # 5c7c <sbrk>
    2ae0:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2ae2:	6505                	lui	a0,0x1
    2ae4:	00003097          	auipc	ra,0x3
    2ae8:	198080e7          	jalr	408(ra) # 5c7c <sbrk>
    2aec:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2aee:	0aa49a63          	bne	s1,a0,2ba2 <sbrkmuch+0x160>
    2af2:	4501                	li	a0,0
    2af4:	00003097          	auipc	ra,0x3
    2af8:	188080e7          	jalr	392(ra) # 5c7c <sbrk>
    2afc:	6785                	lui	a5,0x1
    2afe:	97a6                	add	a5,a5,s1
    2b00:	0af51163          	bne	a0,a5,2ba2 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2b04:	064007b7          	lui	a5,0x6400
    2b08:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2b0c:	06300793          	li	a5,99
    2b10:	0af70963          	beq	a4,a5,2bc2 <sbrkmuch+0x180>
  a = sbrk(0);
    2b14:	4501                	li	a0,0
    2b16:	00003097          	auipc	ra,0x3
    2b1a:	166080e7          	jalr	358(ra) # 5c7c <sbrk>
    2b1e:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b20:	4501                	li	a0,0
    2b22:	00003097          	auipc	ra,0x3
    2b26:	15a080e7          	jalr	346(ra) # 5c7c <sbrk>
    2b2a:	40a9053b          	subw	a0,s2,a0
    2b2e:	00003097          	auipc	ra,0x3
    2b32:	14e080e7          	jalr	334(ra) # 5c7c <sbrk>
  if(c != a){
    2b36:	0aa49463          	bne	s1,a0,2bde <sbrkmuch+0x19c>
}
    2b3a:	70a2                	ld	ra,40(sp)
    2b3c:	7402                	ld	s0,32(sp)
    2b3e:	64e2                	ld	s1,24(sp)
    2b40:	6942                	ld	s2,16(sp)
    2b42:	69a2                	ld	s3,8(sp)
    2b44:	6a02                	ld	s4,0(sp)
    2b46:	6145                	addi	sp,sp,48
    2b48:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b4a:	85ce                	mv	a1,s3
    2b4c:	00004517          	auipc	a0,0x4
    2b50:	47450513          	addi	a0,a0,1140 # 6fc0 <malloc+0xf96>
    2b54:	00003097          	auipc	ra,0x3
    2b58:	418080e7          	jalr	1048(ra) # 5f6c <printf>
    exit(1);
    2b5c:	4505                	li	a0,1
    2b5e:	00003097          	auipc	ra,0x3
    2b62:	096080e7          	jalr	150(ra) # 5bf4 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b66:	85ce                	mv	a1,s3
    2b68:	00004517          	auipc	a0,0x4
    2b6c:	4a050513          	addi	a0,a0,1184 # 7008 <malloc+0xfde>
    2b70:	00003097          	auipc	ra,0x3
    2b74:	3fc080e7          	jalr	1020(ra) # 5f6c <printf>
    exit(1);
    2b78:	4505                	li	a0,1
    2b7a:	00003097          	auipc	ra,0x3
    2b7e:	07a080e7          	jalr	122(ra) # 5bf4 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b82:	86aa                	mv	a3,a0
    2b84:	8626                	mv	a2,s1
    2b86:	85ce                	mv	a1,s3
    2b88:	00004517          	auipc	a0,0x4
    2b8c:	4a050513          	addi	a0,a0,1184 # 7028 <malloc+0xffe>
    2b90:	00003097          	auipc	ra,0x3
    2b94:	3dc080e7          	jalr	988(ra) # 5f6c <printf>
    exit(1);
    2b98:	4505                	li	a0,1
    2b9a:	00003097          	auipc	ra,0x3
    2b9e:	05a080e7          	jalr	90(ra) # 5bf4 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2ba2:	86d2                	mv	a3,s4
    2ba4:	8626                	mv	a2,s1
    2ba6:	85ce                	mv	a1,s3
    2ba8:	00004517          	auipc	a0,0x4
    2bac:	4c050513          	addi	a0,a0,1216 # 7068 <malloc+0x103e>
    2bb0:	00003097          	auipc	ra,0x3
    2bb4:	3bc080e7          	jalr	956(ra) # 5f6c <printf>
    exit(1);
    2bb8:	4505                	li	a0,1
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	03a080e7          	jalr	58(ra) # 5bf4 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2bc2:	85ce                	mv	a1,s3
    2bc4:	00004517          	auipc	a0,0x4
    2bc8:	4d450513          	addi	a0,a0,1236 # 7098 <malloc+0x106e>
    2bcc:	00003097          	auipc	ra,0x3
    2bd0:	3a0080e7          	jalr	928(ra) # 5f6c <printf>
    exit(1);
    2bd4:	4505                	li	a0,1
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	01e080e7          	jalr	30(ra) # 5bf4 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2bde:	86aa                	mv	a3,a0
    2be0:	8626                	mv	a2,s1
    2be2:	85ce                	mv	a1,s3
    2be4:	00004517          	auipc	a0,0x4
    2be8:	4ec50513          	addi	a0,a0,1260 # 70d0 <malloc+0x10a6>
    2bec:	00003097          	auipc	ra,0x3
    2bf0:	380080e7          	jalr	896(ra) # 5f6c <printf>
    exit(1);
    2bf4:	4505                	li	a0,1
    2bf6:	00003097          	auipc	ra,0x3
    2bfa:	ffe080e7          	jalr	-2(ra) # 5bf4 <exit>

0000000000002bfe <sbrkarg>:
{
    2bfe:	7179                	addi	sp,sp,-48
    2c00:	f406                	sd	ra,40(sp)
    2c02:	f022                	sd	s0,32(sp)
    2c04:	ec26                	sd	s1,24(sp)
    2c06:	e84a                	sd	s2,16(sp)
    2c08:	e44e                	sd	s3,8(sp)
    2c0a:	1800                	addi	s0,sp,48
    2c0c:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c0e:	6505                	lui	a0,0x1
    2c10:	00003097          	auipc	ra,0x3
    2c14:	06c080e7          	jalr	108(ra) # 5c7c <sbrk>
    2c18:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2c1a:	20100593          	li	a1,513
    2c1e:	00004517          	auipc	a0,0x4
    2c22:	4da50513          	addi	a0,a0,1242 # 70f8 <malloc+0x10ce>
    2c26:	00003097          	auipc	ra,0x3
    2c2a:	00e080e7          	jalr	14(ra) # 5c34 <open>
    2c2e:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c30:	00004517          	auipc	a0,0x4
    2c34:	4c850513          	addi	a0,a0,1224 # 70f8 <malloc+0x10ce>
    2c38:	00003097          	auipc	ra,0x3
    2c3c:	00c080e7          	jalr	12(ra) # 5c44 <unlink>
  if(fd < 0)  {
    2c40:	0404c163          	bltz	s1,2c82 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c44:	6605                	lui	a2,0x1
    2c46:	85ca                	mv	a1,s2
    2c48:	8526                	mv	a0,s1
    2c4a:	00003097          	auipc	ra,0x3
    2c4e:	fca080e7          	jalr	-54(ra) # 5c14 <write>
    2c52:	04054663          	bltz	a0,2c9e <sbrkarg+0xa0>
  close(fd);
    2c56:	8526                	mv	a0,s1
    2c58:	00003097          	auipc	ra,0x3
    2c5c:	fc4080e7          	jalr	-60(ra) # 5c1c <close>
  a = sbrk(PGSIZE);
    2c60:	6505                	lui	a0,0x1
    2c62:	00003097          	auipc	ra,0x3
    2c66:	01a080e7          	jalr	26(ra) # 5c7c <sbrk>
  if(pipe((int *) a) != 0){
    2c6a:	00003097          	auipc	ra,0x3
    2c6e:	f9a080e7          	jalr	-102(ra) # 5c04 <pipe>
    2c72:	e521                	bnez	a0,2cba <sbrkarg+0xbc>
}
    2c74:	70a2                	ld	ra,40(sp)
    2c76:	7402                	ld	s0,32(sp)
    2c78:	64e2                	ld	s1,24(sp)
    2c7a:	6942                	ld	s2,16(sp)
    2c7c:	69a2                	ld	s3,8(sp)
    2c7e:	6145                	addi	sp,sp,48
    2c80:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c82:	85ce                	mv	a1,s3
    2c84:	00004517          	auipc	a0,0x4
    2c88:	47c50513          	addi	a0,a0,1148 # 7100 <malloc+0x10d6>
    2c8c:	00003097          	auipc	ra,0x3
    2c90:	2e0080e7          	jalr	736(ra) # 5f6c <printf>
    exit(1);
    2c94:	4505                	li	a0,1
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	f5e080e7          	jalr	-162(ra) # 5bf4 <exit>
    printf("%s: write sbrk failed\n", s);
    2c9e:	85ce                	mv	a1,s3
    2ca0:	00004517          	auipc	a0,0x4
    2ca4:	47850513          	addi	a0,a0,1144 # 7118 <malloc+0x10ee>
    2ca8:	00003097          	auipc	ra,0x3
    2cac:	2c4080e7          	jalr	708(ra) # 5f6c <printf>
    exit(1);
    2cb0:	4505                	li	a0,1
    2cb2:	00003097          	auipc	ra,0x3
    2cb6:	f42080e7          	jalr	-190(ra) # 5bf4 <exit>
    printf("%s: pipe() failed\n", s);
    2cba:	85ce                	mv	a1,s3
    2cbc:	00004517          	auipc	a0,0x4
    2cc0:	e3c50513          	addi	a0,a0,-452 # 6af8 <malloc+0xace>
    2cc4:	00003097          	auipc	ra,0x3
    2cc8:	2a8080e7          	jalr	680(ra) # 5f6c <printf>
    exit(1);
    2ccc:	4505                	li	a0,1
    2cce:	00003097          	auipc	ra,0x3
    2cd2:	f26080e7          	jalr	-218(ra) # 5bf4 <exit>

0000000000002cd6 <argptest>:
{
    2cd6:	1101                	addi	sp,sp,-32
    2cd8:	ec06                	sd	ra,24(sp)
    2cda:	e822                	sd	s0,16(sp)
    2cdc:	e426                	sd	s1,8(sp)
    2cde:	e04a                	sd	s2,0(sp)
    2ce0:	1000                	addi	s0,sp,32
    2ce2:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2ce4:	4581                	li	a1,0
    2ce6:	00004517          	auipc	a0,0x4
    2cea:	44a50513          	addi	a0,a0,1098 # 7130 <malloc+0x1106>
    2cee:	00003097          	auipc	ra,0x3
    2cf2:	f46080e7          	jalr	-186(ra) # 5c34 <open>
  if (fd < 0) {
    2cf6:	02054b63          	bltz	a0,2d2c <argptest+0x56>
    2cfa:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2cfc:	4501                	li	a0,0
    2cfe:	00003097          	auipc	ra,0x3
    2d02:	f7e080e7          	jalr	-130(ra) # 5c7c <sbrk>
    2d06:	567d                	li	a2,-1
    2d08:	fff50593          	addi	a1,a0,-1
    2d0c:	8526                	mv	a0,s1
    2d0e:	00003097          	auipc	ra,0x3
    2d12:	efe080e7          	jalr	-258(ra) # 5c0c <read>
  close(fd);
    2d16:	8526                	mv	a0,s1
    2d18:	00003097          	auipc	ra,0x3
    2d1c:	f04080e7          	jalr	-252(ra) # 5c1c <close>
}
    2d20:	60e2                	ld	ra,24(sp)
    2d22:	6442                	ld	s0,16(sp)
    2d24:	64a2                	ld	s1,8(sp)
    2d26:	6902                	ld	s2,0(sp)
    2d28:	6105                	addi	sp,sp,32
    2d2a:	8082                	ret
    printf("%s: open failed\n", s);
    2d2c:	85ca                	mv	a1,s2
    2d2e:	00004517          	auipc	a0,0x4
    2d32:	cda50513          	addi	a0,a0,-806 # 6a08 <malloc+0x9de>
    2d36:	00003097          	auipc	ra,0x3
    2d3a:	236080e7          	jalr	566(ra) # 5f6c <printf>
    exit(1);
    2d3e:	4505                	li	a0,1
    2d40:	00003097          	auipc	ra,0x3
    2d44:	eb4080e7          	jalr	-332(ra) # 5bf4 <exit>

0000000000002d48 <sbrkbugs>:
{
    2d48:	1141                	addi	sp,sp,-16
    2d4a:	e406                	sd	ra,8(sp)
    2d4c:	e022                	sd	s0,0(sp)
    2d4e:	0800                	addi	s0,sp,16
  int pid = fork();
    2d50:	00003097          	auipc	ra,0x3
    2d54:	e9c080e7          	jalr	-356(ra) # 5bec <fork>
  if(pid < 0){
    2d58:	02054263          	bltz	a0,2d7c <sbrkbugs+0x34>
  if(pid == 0){
    2d5c:	ed0d                	bnez	a0,2d96 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2d5e:	00003097          	auipc	ra,0x3
    2d62:	f1e080e7          	jalr	-226(ra) # 5c7c <sbrk>
    sbrk(-sz);
    2d66:	40a0053b          	negw	a0,a0
    2d6a:	00003097          	auipc	ra,0x3
    2d6e:	f12080e7          	jalr	-238(ra) # 5c7c <sbrk>
    exit(0);
    2d72:	4501                	li	a0,0
    2d74:	00003097          	auipc	ra,0x3
    2d78:	e80080e7          	jalr	-384(ra) # 5bf4 <exit>
    printf("fork failed\n");
    2d7c:	00004517          	auipc	a0,0x4
    2d80:	07c50513          	addi	a0,a0,124 # 6df8 <malloc+0xdce>
    2d84:	00003097          	auipc	ra,0x3
    2d88:	1e8080e7          	jalr	488(ra) # 5f6c <printf>
    exit(1);
    2d8c:	4505                	li	a0,1
    2d8e:	00003097          	auipc	ra,0x3
    2d92:	e66080e7          	jalr	-410(ra) # 5bf4 <exit>
  wait(0);
    2d96:	4501                	li	a0,0
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	e64080e7          	jalr	-412(ra) # 5bfc <wait>
  pid = fork();
    2da0:	00003097          	auipc	ra,0x3
    2da4:	e4c080e7          	jalr	-436(ra) # 5bec <fork>
  if(pid < 0){
    2da8:	02054563          	bltz	a0,2dd2 <sbrkbugs+0x8a>
  if(pid == 0){
    2dac:	e121                	bnez	a0,2dec <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2dae:	00003097          	auipc	ra,0x3
    2db2:	ece080e7          	jalr	-306(ra) # 5c7c <sbrk>
    sbrk(-(sz - 3500));
    2db6:	6785                	lui	a5,0x1
    2db8:	dac7879b          	addiw	a5,a5,-596
    2dbc:	40a7853b          	subw	a0,a5,a0
    2dc0:	00003097          	auipc	ra,0x3
    2dc4:	ebc080e7          	jalr	-324(ra) # 5c7c <sbrk>
    exit(0);
    2dc8:	4501                	li	a0,0
    2dca:	00003097          	auipc	ra,0x3
    2dce:	e2a080e7          	jalr	-470(ra) # 5bf4 <exit>
    printf("fork failed\n");
    2dd2:	00004517          	auipc	a0,0x4
    2dd6:	02650513          	addi	a0,a0,38 # 6df8 <malloc+0xdce>
    2dda:	00003097          	auipc	ra,0x3
    2dde:	192080e7          	jalr	402(ra) # 5f6c <printf>
    exit(1);
    2de2:	4505                	li	a0,1
    2de4:	00003097          	auipc	ra,0x3
    2de8:	e10080e7          	jalr	-496(ra) # 5bf4 <exit>
  wait(0);
    2dec:	4501                	li	a0,0
    2dee:	00003097          	auipc	ra,0x3
    2df2:	e0e080e7          	jalr	-498(ra) # 5bfc <wait>
  pid = fork();
    2df6:	00003097          	auipc	ra,0x3
    2dfa:	df6080e7          	jalr	-522(ra) # 5bec <fork>
  if(pid < 0){
    2dfe:	02054a63          	bltz	a0,2e32 <sbrkbugs+0xea>
  if(pid == 0){
    2e02:	e529                	bnez	a0,2e4c <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2e04:	00003097          	auipc	ra,0x3
    2e08:	e78080e7          	jalr	-392(ra) # 5c7c <sbrk>
    2e0c:	67ad                	lui	a5,0xb
    2e0e:	8007879b          	addiw	a5,a5,-2048
    2e12:	40a7853b          	subw	a0,a5,a0
    2e16:	00003097          	auipc	ra,0x3
    2e1a:	e66080e7          	jalr	-410(ra) # 5c7c <sbrk>
    sbrk(-10);
    2e1e:	5559                	li	a0,-10
    2e20:	00003097          	auipc	ra,0x3
    2e24:	e5c080e7          	jalr	-420(ra) # 5c7c <sbrk>
    exit(0);
    2e28:	4501                	li	a0,0
    2e2a:	00003097          	auipc	ra,0x3
    2e2e:	dca080e7          	jalr	-566(ra) # 5bf4 <exit>
    printf("fork failed\n");
    2e32:	00004517          	auipc	a0,0x4
    2e36:	fc650513          	addi	a0,a0,-58 # 6df8 <malloc+0xdce>
    2e3a:	00003097          	auipc	ra,0x3
    2e3e:	132080e7          	jalr	306(ra) # 5f6c <printf>
    exit(1);
    2e42:	4505                	li	a0,1
    2e44:	00003097          	auipc	ra,0x3
    2e48:	db0080e7          	jalr	-592(ra) # 5bf4 <exit>
  wait(0);
    2e4c:	4501                	li	a0,0
    2e4e:	00003097          	auipc	ra,0x3
    2e52:	dae080e7          	jalr	-594(ra) # 5bfc <wait>
  exit(0);
    2e56:	4501                	li	a0,0
    2e58:	00003097          	auipc	ra,0x3
    2e5c:	d9c080e7          	jalr	-612(ra) # 5bf4 <exit>

0000000000002e60 <sbrklast>:
{
    2e60:	7179                	addi	sp,sp,-48
    2e62:	f406                	sd	ra,40(sp)
    2e64:	f022                	sd	s0,32(sp)
    2e66:	ec26                	sd	s1,24(sp)
    2e68:	e84a                	sd	s2,16(sp)
    2e6a:	e44e                	sd	s3,8(sp)
    2e6c:	e052                	sd	s4,0(sp)
    2e6e:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2e70:	4501                	li	a0,0
    2e72:	00003097          	auipc	ra,0x3
    2e76:	e0a080e7          	jalr	-502(ra) # 5c7c <sbrk>
  if((top % 4096) != 0)
    2e7a:	03451793          	slli	a5,a0,0x34
    2e7e:	ebd9                	bnez	a5,2f14 <sbrklast+0xb4>
  sbrk(4096);
    2e80:	6505                	lui	a0,0x1
    2e82:	00003097          	auipc	ra,0x3
    2e86:	dfa080e7          	jalr	-518(ra) # 5c7c <sbrk>
  sbrk(10);
    2e8a:	4529                	li	a0,10
    2e8c:	00003097          	auipc	ra,0x3
    2e90:	df0080e7          	jalr	-528(ra) # 5c7c <sbrk>
  sbrk(-20);
    2e94:	5531                	li	a0,-20
    2e96:	00003097          	auipc	ra,0x3
    2e9a:	de6080e7          	jalr	-538(ra) # 5c7c <sbrk>
  top = (uint64) sbrk(0);
    2e9e:	4501                	li	a0,0
    2ea0:	00003097          	auipc	ra,0x3
    2ea4:	ddc080e7          	jalr	-548(ra) # 5c7c <sbrk>
    2ea8:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2eaa:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xc2>
  p[0] = 'x';
    2eae:	07800a13          	li	s4,120
    2eb2:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2eb6:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2eba:	20200593          	li	a1,514
    2ebe:	854a                	mv	a0,s2
    2ec0:	00003097          	auipc	ra,0x3
    2ec4:	d74080e7          	jalr	-652(ra) # 5c34 <open>
    2ec8:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2eca:	4605                	li	a2,1
    2ecc:	85ca                	mv	a1,s2
    2ece:	00003097          	auipc	ra,0x3
    2ed2:	d46080e7          	jalr	-698(ra) # 5c14 <write>
  close(fd);
    2ed6:	854e                	mv	a0,s3
    2ed8:	00003097          	auipc	ra,0x3
    2edc:	d44080e7          	jalr	-700(ra) # 5c1c <close>
  fd = open(p, O_RDWR);
    2ee0:	4589                	li	a1,2
    2ee2:	854a                	mv	a0,s2
    2ee4:	00003097          	auipc	ra,0x3
    2ee8:	d50080e7          	jalr	-688(ra) # 5c34 <open>
  p[0] = '\0';
    2eec:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2ef0:	4605                	li	a2,1
    2ef2:	85ca                	mv	a1,s2
    2ef4:	00003097          	auipc	ra,0x3
    2ef8:	d18080e7          	jalr	-744(ra) # 5c0c <read>
  if(p[0] != 'x')
    2efc:	fc04c783          	lbu	a5,-64(s1)
    2f00:	03479463          	bne	a5,s4,2f28 <sbrklast+0xc8>
}
    2f04:	70a2                	ld	ra,40(sp)
    2f06:	7402                	ld	s0,32(sp)
    2f08:	64e2                	ld	s1,24(sp)
    2f0a:	6942                	ld	s2,16(sp)
    2f0c:	69a2                	ld	s3,8(sp)
    2f0e:	6a02                	ld	s4,0(sp)
    2f10:	6145                	addi	sp,sp,48
    2f12:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f14:	0347d513          	srli	a0,a5,0x34
    2f18:	6785                	lui	a5,0x1
    2f1a:	40a7853b          	subw	a0,a5,a0
    2f1e:	00003097          	auipc	ra,0x3
    2f22:	d5e080e7          	jalr	-674(ra) # 5c7c <sbrk>
    2f26:	bfa9                	j	2e80 <sbrklast+0x20>
    exit(1);
    2f28:	4505                	li	a0,1
    2f2a:	00003097          	auipc	ra,0x3
    2f2e:	cca080e7          	jalr	-822(ra) # 5bf4 <exit>

0000000000002f32 <sbrk8000>:
{
    2f32:	1141                	addi	sp,sp,-16
    2f34:	e406                	sd	ra,8(sp)
    2f36:	e022                	sd	s0,0(sp)
    2f38:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2f3a:	80000537          	lui	a0,0x80000
    2f3e:	0511                	addi	a0,a0,4
    2f40:	00003097          	auipc	ra,0x3
    2f44:	d3c080e7          	jalr	-708(ra) # 5c7c <sbrk>
  volatile char *top = sbrk(0);
    2f48:	4501                	li	a0,0
    2f4a:	00003097          	auipc	ra,0x3
    2f4e:	d32080e7          	jalr	-718(ra) # 5c7c <sbrk>
  *(top-1) = *(top-1) + 1;
    2f52:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <base+0xffffffff7fff0387>
    2f56:	0785                	addi	a5,a5,1
    2f58:	0ff7f793          	zext.b	a5,a5
    2f5c:	fef50fa3          	sb	a5,-1(a0)
}
    2f60:	60a2                	ld	ra,8(sp)
    2f62:	6402                	ld	s0,0(sp)
    2f64:	0141                	addi	sp,sp,16
    2f66:	8082                	ret

0000000000002f68 <execout>:
{
    2f68:	715d                	addi	sp,sp,-80
    2f6a:	e486                	sd	ra,72(sp)
    2f6c:	e0a2                	sd	s0,64(sp)
    2f6e:	fc26                	sd	s1,56(sp)
    2f70:	f84a                	sd	s2,48(sp)
    2f72:	f44e                	sd	s3,40(sp)
    2f74:	f052                	sd	s4,32(sp)
    2f76:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2f78:	4901                	li	s2,0
    2f7a:	49bd                	li	s3,15
    int pid = fork();
    2f7c:	00003097          	auipc	ra,0x3
    2f80:	c70080e7          	jalr	-912(ra) # 5bec <fork>
    2f84:	84aa                	mv	s1,a0
    if(pid < 0){
    2f86:	02054063          	bltz	a0,2fa6 <execout+0x3e>
    } else if(pid == 0){
    2f8a:	c91d                	beqz	a0,2fc0 <execout+0x58>
      wait((int*)0);
    2f8c:	4501                	li	a0,0
    2f8e:	00003097          	auipc	ra,0x3
    2f92:	c6e080e7          	jalr	-914(ra) # 5bfc <wait>
  for(int avail = 0; avail < 15; avail++){
    2f96:	2905                	addiw	s2,s2,1
    2f98:	ff3912e3          	bne	s2,s3,2f7c <execout+0x14>
  exit(0);
    2f9c:	4501                	li	a0,0
    2f9e:	00003097          	auipc	ra,0x3
    2fa2:	c56080e7          	jalr	-938(ra) # 5bf4 <exit>
      printf("fork failed\n");
    2fa6:	00004517          	auipc	a0,0x4
    2faa:	e5250513          	addi	a0,a0,-430 # 6df8 <malloc+0xdce>
    2fae:	00003097          	auipc	ra,0x3
    2fb2:	fbe080e7          	jalr	-66(ra) # 5f6c <printf>
      exit(1);
    2fb6:	4505                	li	a0,1
    2fb8:	00003097          	auipc	ra,0x3
    2fbc:	c3c080e7          	jalr	-964(ra) # 5bf4 <exit>
        if(a == 0xffffffffffffffffLL)
    2fc0:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2fc2:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2fc4:	6505                	lui	a0,0x1
    2fc6:	00003097          	auipc	ra,0x3
    2fca:	cb6080e7          	jalr	-842(ra) # 5c7c <sbrk>
        if(a == 0xffffffffffffffffLL)
    2fce:	01350763          	beq	a0,s3,2fdc <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2fd2:	6785                	lui	a5,0x1
    2fd4:	953e                	add	a0,a0,a5
    2fd6:	ff450fa3          	sb	s4,-1(a0) # fff <linktest+0x101>
      while(1){
    2fda:	b7ed                	j	2fc4 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2fdc:	01205a63          	blez	s2,2ff0 <execout+0x88>
        sbrk(-4096);
    2fe0:	757d                	lui	a0,0xfffff
    2fe2:	00003097          	auipc	ra,0x3
    2fe6:	c9a080e7          	jalr	-870(ra) # 5c7c <sbrk>
      for(int i = 0; i < avail; i++)
    2fea:	2485                	addiw	s1,s1,1
    2fec:	ff249ae3          	bne	s1,s2,2fe0 <execout+0x78>
      close(1);
    2ff0:	4505                	li	a0,1
    2ff2:	00003097          	auipc	ra,0x3
    2ff6:	c2a080e7          	jalr	-982(ra) # 5c1c <close>
      char *args[] = { "echo", "x", 0 };
    2ffa:	00003517          	auipc	a0,0x3
    2ffe:	16e50513          	addi	a0,a0,366 # 6168 <malloc+0x13e>
    3002:	faa43c23          	sd	a0,-72(s0)
    3006:	00003797          	auipc	a5,0x3
    300a:	1d278793          	addi	a5,a5,466 # 61d8 <malloc+0x1ae>
    300e:	fcf43023          	sd	a5,-64(s0)
    3012:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    3016:	fb840593          	addi	a1,s0,-72
    301a:	00003097          	auipc	ra,0x3
    301e:	c12080e7          	jalr	-1006(ra) # 5c2c <exec>
      exit(0);
    3022:	4501                	li	a0,0
    3024:	00003097          	auipc	ra,0x3
    3028:	bd0080e7          	jalr	-1072(ra) # 5bf4 <exit>

000000000000302c <fourteen>:
{
    302c:	1101                	addi	sp,sp,-32
    302e:	ec06                	sd	ra,24(sp)
    3030:	e822                	sd	s0,16(sp)
    3032:	e426                	sd	s1,8(sp)
    3034:	1000                	addi	s0,sp,32
    3036:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3038:	00004517          	auipc	a0,0x4
    303c:	2d050513          	addi	a0,a0,720 # 7308 <malloc+0x12de>
    3040:	00003097          	auipc	ra,0x3
    3044:	c1c080e7          	jalr	-996(ra) # 5c5c <mkdir>
    3048:	e165                	bnez	a0,3128 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    304a:	00004517          	auipc	a0,0x4
    304e:	11650513          	addi	a0,a0,278 # 7160 <malloc+0x1136>
    3052:	00003097          	auipc	ra,0x3
    3056:	c0a080e7          	jalr	-1014(ra) # 5c5c <mkdir>
    305a:	e56d                	bnez	a0,3144 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    305c:	20000593          	li	a1,512
    3060:	00004517          	auipc	a0,0x4
    3064:	15850513          	addi	a0,a0,344 # 71b8 <malloc+0x118e>
    3068:	00003097          	auipc	ra,0x3
    306c:	bcc080e7          	jalr	-1076(ra) # 5c34 <open>
  if(fd < 0){
    3070:	0e054863          	bltz	a0,3160 <fourteen+0x134>
  close(fd);
    3074:	00003097          	auipc	ra,0x3
    3078:	ba8080e7          	jalr	-1112(ra) # 5c1c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    307c:	4581                	li	a1,0
    307e:	00004517          	auipc	a0,0x4
    3082:	1b250513          	addi	a0,a0,434 # 7230 <malloc+0x1206>
    3086:	00003097          	auipc	ra,0x3
    308a:	bae080e7          	jalr	-1106(ra) # 5c34 <open>
  if(fd < 0){
    308e:	0e054763          	bltz	a0,317c <fourteen+0x150>
  close(fd);
    3092:	00003097          	auipc	ra,0x3
    3096:	b8a080e7          	jalr	-1142(ra) # 5c1c <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    309a:	00004517          	auipc	a0,0x4
    309e:	20650513          	addi	a0,a0,518 # 72a0 <malloc+0x1276>
    30a2:	00003097          	auipc	ra,0x3
    30a6:	bba080e7          	jalr	-1094(ra) # 5c5c <mkdir>
    30aa:	c57d                	beqz	a0,3198 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    30ac:	00004517          	auipc	a0,0x4
    30b0:	24c50513          	addi	a0,a0,588 # 72f8 <malloc+0x12ce>
    30b4:	00003097          	auipc	ra,0x3
    30b8:	ba8080e7          	jalr	-1112(ra) # 5c5c <mkdir>
    30bc:	cd65                	beqz	a0,31b4 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    30be:	00004517          	auipc	a0,0x4
    30c2:	23a50513          	addi	a0,a0,570 # 72f8 <malloc+0x12ce>
    30c6:	00003097          	auipc	ra,0x3
    30ca:	b7e080e7          	jalr	-1154(ra) # 5c44 <unlink>
  unlink("12345678901234/12345678901234");
    30ce:	00004517          	auipc	a0,0x4
    30d2:	1d250513          	addi	a0,a0,466 # 72a0 <malloc+0x1276>
    30d6:	00003097          	auipc	ra,0x3
    30da:	b6e080e7          	jalr	-1170(ra) # 5c44 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    30de:	00004517          	auipc	a0,0x4
    30e2:	15250513          	addi	a0,a0,338 # 7230 <malloc+0x1206>
    30e6:	00003097          	auipc	ra,0x3
    30ea:	b5e080e7          	jalr	-1186(ra) # 5c44 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    30ee:	00004517          	auipc	a0,0x4
    30f2:	0ca50513          	addi	a0,a0,202 # 71b8 <malloc+0x118e>
    30f6:	00003097          	auipc	ra,0x3
    30fa:	b4e080e7          	jalr	-1202(ra) # 5c44 <unlink>
  unlink("12345678901234/123456789012345");
    30fe:	00004517          	auipc	a0,0x4
    3102:	06250513          	addi	a0,a0,98 # 7160 <malloc+0x1136>
    3106:	00003097          	auipc	ra,0x3
    310a:	b3e080e7          	jalr	-1218(ra) # 5c44 <unlink>
  unlink("12345678901234");
    310e:	00004517          	auipc	a0,0x4
    3112:	1fa50513          	addi	a0,a0,506 # 7308 <malloc+0x12de>
    3116:	00003097          	auipc	ra,0x3
    311a:	b2e080e7          	jalr	-1234(ra) # 5c44 <unlink>
}
    311e:	60e2                	ld	ra,24(sp)
    3120:	6442                	ld	s0,16(sp)
    3122:	64a2                	ld	s1,8(sp)
    3124:	6105                	addi	sp,sp,32
    3126:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3128:	85a6                	mv	a1,s1
    312a:	00004517          	auipc	a0,0x4
    312e:	00e50513          	addi	a0,a0,14 # 7138 <malloc+0x110e>
    3132:	00003097          	auipc	ra,0x3
    3136:	e3a080e7          	jalr	-454(ra) # 5f6c <printf>
    exit(1);
    313a:	4505                	li	a0,1
    313c:	00003097          	auipc	ra,0x3
    3140:	ab8080e7          	jalr	-1352(ra) # 5bf4 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    3144:	85a6                	mv	a1,s1
    3146:	00004517          	auipc	a0,0x4
    314a:	03a50513          	addi	a0,a0,58 # 7180 <malloc+0x1156>
    314e:	00003097          	auipc	ra,0x3
    3152:	e1e080e7          	jalr	-482(ra) # 5f6c <printf>
    exit(1);
    3156:	4505                	li	a0,1
    3158:	00003097          	auipc	ra,0x3
    315c:	a9c080e7          	jalr	-1380(ra) # 5bf4 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3160:	85a6                	mv	a1,s1
    3162:	00004517          	auipc	a0,0x4
    3166:	08650513          	addi	a0,a0,134 # 71e8 <malloc+0x11be>
    316a:	00003097          	auipc	ra,0x3
    316e:	e02080e7          	jalr	-510(ra) # 5f6c <printf>
    exit(1);
    3172:	4505                	li	a0,1
    3174:	00003097          	auipc	ra,0x3
    3178:	a80080e7          	jalr	-1408(ra) # 5bf4 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    317c:	85a6                	mv	a1,s1
    317e:	00004517          	auipc	a0,0x4
    3182:	0e250513          	addi	a0,a0,226 # 7260 <malloc+0x1236>
    3186:	00003097          	auipc	ra,0x3
    318a:	de6080e7          	jalr	-538(ra) # 5f6c <printf>
    exit(1);
    318e:	4505                	li	a0,1
    3190:	00003097          	auipc	ra,0x3
    3194:	a64080e7          	jalr	-1436(ra) # 5bf4 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3198:	85a6                	mv	a1,s1
    319a:	00004517          	auipc	a0,0x4
    319e:	12650513          	addi	a0,a0,294 # 72c0 <malloc+0x1296>
    31a2:	00003097          	auipc	ra,0x3
    31a6:	dca080e7          	jalr	-566(ra) # 5f6c <printf>
    exit(1);
    31aa:	4505                	li	a0,1
    31ac:	00003097          	auipc	ra,0x3
    31b0:	a48080e7          	jalr	-1464(ra) # 5bf4 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31b4:	85a6                	mv	a1,s1
    31b6:	00004517          	auipc	a0,0x4
    31ba:	16250513          	addi	a0,a0,354 # 7318 <malloc+0x12ee>
    31be:	00003097          	auipc	ra,0x3
    31c2:	dae080e7          	jalr	-594(ra) # 5f6c <printf>
    exit(1);
    31c6:	4505                	li	a0,1
    31c8:	00003097          	auipc	ra,0x3
    31cc:	a2c080e7          	jalr	-1492(ra) # 5bf4 <exit>

00000000000031d0 <diskfull>:
{
    31d0:	b8010113          	addi	sp,sp,-1152
    31d4:	46113c23          	sd	ra,1144(sp)
    31d8:	46813823          	sd	s0,1136(sp)
    31dc:	46913423          	sd	s1,1128(sp)
    31e0:	47213023          	sd	s2,1120(sp)
    31e4:	45313c23          	sd	s3,1112(sp)
    31e8:	45413823          	sd	s4,1104(sp)
    31ec:	45513423          	sd	s5,1096(sp)
    31f0:	45613023          	sd	s6,1088(sp)
    31f4:	43713c23          	sd	s7,1080(sp)
    31f8:	43813823          	sd	s8,1072(sp)
    31fc:	43913423          	sd	s9,1064(sp)
    3200:	48010413          	addi	s0,sp,1152
    3204:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    3206:	00004517          	auipc	a0,0x4
    320a:	14a50513          	addi	a0,a0,330 # 7350 <malloc+0x1326>
    320e:	00003097          	auipc	ra,0x3
    3212:	a36080e7          	jalr	-1482(ra) # 5c44 <unlink>
    3216:	03000993          	li	s3,48
    name[0] = 'b';
    321a:	06200b13          	li	s6,98
    name[1] = 'i';
    321e:	06900a93          	li	s5,105
    name[2] = 'g';
    3222:	06700a13          	li	s4,103
    3226:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    322a:	07f00c13          	li	s8,127
    322e:	a269                	j	33b8 <diskfull+0x1e8>
      printf("%s: could not create file %s\n", s, name);
    3230:	b8040613          	addi	a2,s0,-1152
    3234:	85e6                	mv	a1,s9
    3236:	00004517          	auipc	a0,0x4
    323a:	12a50513          	addi	a0,a0,298 # 7360 <malloc+0x1336>
    323e:	00003097          	auipc	ra,0x3
    3242:	d2e080e7          	jalr	-722(ra) # 5f6c <printf>
      break;
    3246:	a819                	j	325c <diskfull+0x8c>
        close(fd);
    3248:	854a                	mv	a0,s2
    324a:	00003097          	auipc	ra,0x3
    324e:	9d2080e7          	jalr	-1582(ra) # 5c1c <close>
    close(fd);
    3252:	854a                	mv	a0,s2
    3254:	00003097          	auipc	ra,0x3
    3258:	9c8080e7          	jalr	-1592(ra) # 5c1c <close>
  for(int i = 0; i < nzz; i++){
    325c:	4481                	li	s1,0
    name[0] = 'z';
    325e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3262:	08000993          	li	s3,128
    name[0] = 'z';
    3266:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    326a:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    326e:	41f4d79b          	sraiw	a5,s1,0x1f
    3272:	01b7d71b          	srliw	a4,a5,0x1b
    3276:	009707bb          	addw	a5,a4,s1
    327a:	4057d69b          	sraiw	a3,a5,0x5
    327e:	0306869b          	addiw	a3,a3,48
    3282:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    3286:	8bfd                	andi	a5,a5,31
    3288:	9f99                	subw	a5,a5,a4
    328a:	0307879b          	addiw	a5,a5,48
    328e:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    3292:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3296:	ba040513          	addi	a0,s0,-1120
    329a:	00003097          	auipc	ra,0x3
    329e:	9aa080e7          	jalr	-1622(ra) # 5c44 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    32a2:	60200593          	li	a1,1538
    32a6:	ba040513          	addi	a0,s0,-1120
    32aa:	00003097          	auipc	ra,0x3
    32ae:	98a080e7          	jalr	-1654(ra) # 5c34 <open>
    if(fd < 0)
    32b2:	00054963          	bltz	a0,32c4 <diskfull+0xf4>
    close(fd);
    32b6:	00003097          	auipc	ra,0x3
    32ba:	966080e7          	jalr	-1690(ra) # 5c1c <close>
  for(int i = 0; i < nzz; i++){
    32be:	2485                	addiw	s1,s1,1
    32c0:	fb3493e3          	bne	s1,s3,3266 <diskfull+0x96>
  if(mkdir("diskfulldir") == 0)
    32c4:	00004517          	auipc	a0,0x4
    32c8:	08c50513          	addi	a0,a0,140 # 7350 <malloc+0x1326>
    32cc:	00003097          	auipc	ra,0x3
    32d0:	990080e7          	jalr	-1648(ra) # 5c5c <mkdir>
    32d4:	12050e63          	beqz	a0,3410 <diskfull+0x240>
  unlink("diskfulldir");
    32d8:	00004517          	auipc	a0,0x4
    32dc:	07850513          	addi	a0,a0,120 # 7350 <malloc+0x1326>
    32e0:	00003097          	auipc	ra,0x3
    32e4:	964080e7          	jalr	-1692(ra) # 5c44 <unlink>
  for(int i = 0; i < nzz; i++){
    32e8:	4481                	li	s1,0
    name[0] = 'z';
    32ea:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32ee:	08000993          	li	s3,128
    name[0] = 'z';
    32f2:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    32f6:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    32fa:	41f4d79b          	sraiw	a5,s1,0x1f
    32fe:	01b7d71b          	srliw	a4,a5,0x1b
    3302:	009707bb          	addw	a5,a4,s1
    3306:	4057d69b          	sraiw	a3,a5,0x5
    330a:	0306869b          	addiw	a3,a3,48
    330e:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    3312:	8bfd                	andi	a5,a5,31
    3314:	9f99                	subw	a5,a5,a4
    3316:	0307879b          	addiw	a5,a5,48
    331a:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    331e:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3322:	ba040513          	addi	a0,s0,-1120
    3326:	00003097          	auipc	ra,0x3
    332a:	91e080e7          	jalr	-1762(ra) # 5c44 <unlink>
  for(int i = 0; i < nzz; i++){
    332e:	2485                	addiw	s1,s1,1
    3330:	fd3491e3          	bne	s1,s3,32f2 <diskfull+0x122>
    3334:	03000493          	li	s1,48
    name[0] = 'b';
    3338:	06200a93          	li	s5,98
    name[1] = 'i';
    333c:	06900a13          	li	s4,105
    name[2] = 'g';
    3340:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    3344:	07f00913          	li	s2,127
    name[0] = 'b';
    3348:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    334c:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    3350:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    3354:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    3358:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    335c:	ba040513          	addi	a0,s0,-1120
    3360:	00003097          	auipc	ra,0x3
    3364:	8e4080e7          	jalr	-1820(ra) # 5c44 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    3368:	2485                	addiw	s1,s1,1
    336a:	0ff4f493          	zext.b	s1,s1
    336e:	fd249de3          	bne	s1,s2,3348 <diskfull+0x178>
}
    3372:	47813083          	ld	ra,1144(sp)
    3376:	47013403          	ld	s0,1136(sp)
    337a:	46813483          	ld	s1,1128(sp)
    337e:	46013903          	ld	s2,1120(sp)
    3382:	45813983          	ld	s3,1112(sp)
    3386:	45013a03          	ld	s4,1104(sp)
    338a:	44813a83          	ld	s5,1096(sp)
    338e:	44013b03          	ld	s6,1088(sp)
    3392:	43813b83          	ld	s7,1080(sp)
    3396:	43013c03          	ld	s8,1072(sp)
    339a:	42813c83          	ld	s9,1064(sp)
    339e:	48010113          	addi	sp,sp,1152
    33a2:	8082                	ret
    close(fd);
    33a4:	854a                	mv	a0,s2
    33a6:	00003097          	auipc	ra,0x3
    33aa:	876080e7          	jalr	-1930(ra) # 5c1c <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    33ae:	2985                	addiw	s3,s3,1
    33b0:	0ff9f993          	zext.b	s3,s3
    33b4:	eb8984e3          	beq	s3,s8,325c <diskfull+0x8c>
    name[0] = 'b';
    33b8:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    33bc:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    33c0:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    33c4:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    33c8:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    33cc:	b8040513          	addi	a0,s0,-1152
    33d0:	00003097          	auipc	ra,0x3
    33d4:	874080e7          	jalr	-1932(ra) # 5c44 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33d8:	60200593          	li	a1,1538
    33dc:	b8040513          	addi	a0,s0,-1152
    33e0:	00003097          	auipc	ra,0x3
    33e4:	854080e7          	jalr	-1964(ra) # 5c34 <open>
    33e8:	892a                	mv	s2,a0
    if(fd < 0){
    33ea:	e40543e3          	bltz	a0,3230 <diskfull+0x60>
    33ee:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    33f0:	40000613          	li	a2,1024
    33f4:	ba040593          	addi	a1,s0,-1120
    33f8:	854a                	mv	a0,s2
    33fa:	00003097          	auipc	ra,0x3
    33fe:	81a080e7          	jalr	-2022(ra) # 5c14 <write>
    3402:	40000793          	li	a5,1024
    3406:	e4f511e3          	bne	a0,a5,3248 <diskfull+0x78>
    for(int i = 0; i < MAXFILE; i++){
    340a:	34fd                	addiw	s1,s1,-1
    340c:	f0f5                	bnez	s1,33f0 <diskfull+0x220>
    340e:	bf59                	j	33a4 <diskfull+0x1d4>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3410:	00004517          	auipc	a0,0x4
    3414:	f7050513          	addi	a0,a0,-144 # 7380 <malloc+0x1356>
    3418:	00003097          	auipc	ra,0x3
    341c:	b54080e7          	jalr	-1196(ra) # 5f6c <printf>
    3420:	bd65                	j	32d8 <diskfull+0x108>

0000000000003422 <iputtest>:
{
    3422:	1101                	addi	sp,sp,-32
    3424:	ec06                	sd	ra,24(sp)
    3426:	e822                	sd	s0,16(sp)
    3428:	e426                	sd	s1,8(sp)
    342a:	1000                	addi	s0,sp,32
    342c:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    342e:	00004517          	auipc	a0,0x4
    3432:	f8250513          	addi	a0,a0,-126 # 73b0 <malloc+0x1386>
    3436:	00003097          	auipc	ra,0x3
    343a:	826080e7          	jalr	-2010(ra) # 5c5c <mkdir>
    343e:	04054563          	bltz	a0,3488 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    3442:	00004517          	auipc	a0,0x4
    3446:	f6e50513          	addi	a0,a0,-146 # 73b0 <malloc+0x1386>
    344a:	00003097          	auipc	ra,0x3
    344e:	81a080e7          	jalr	-2022(ra) # 5c64 <chdir>
    3452:	04054963          	bltz	a0,34a4 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    3456:	00004517          	auipc	a0,0x4
    345a:	f9a50513          	addi	a0,a0,-102 # 73f0 <malloc+0x13c6>
    345e:	00002097          	auipc	ra,0x2
    3462:	7e6080e7          	jalr	2022(ra) # 5c44 <unlink>
    3466:	04054d63          	bltz	a0,34c0 <iputtest+0x9e>
  if(chdir("/") < 0){
    346a:	00004517          	auipc	a0,0x4
    346e:	fb650513          	addi	a0,a0,-74 # 7420 <malloc+0x13f6>
    3472:	00002097          	auipc	ra,0x2
    3476:	7f2080e7          	jalr	2034(ra) # 5c64 <chdir>
    347a:	06054163          	bltz	a0,34dc <iputtest+0xba>
}
    347e:	60e2                	ld	ra,24(sp)
    3480:	6442                	ld	s0,16(sp)
    3482:	64a2                	ld	s1,8(sp)
    3484:	6105                	addi	sp,sp,32
    3486:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3488:	85a6                	mv	a1,s1
    348a:	00004517          	auipc	a0,0x4
    348e:	f2e50513          	addi	a0,a0,-210 # 73b8 <malloc+0x138e>
    3492:	00003097          	auipc	ra,0x3
    3496:	ada080e7          	jalr	-1318(ra) # 5f6c <printf>
    exit(1);
    349a:	4505                	li	a0,1
    349c:	00002097          	auipc	ra,0x2
    34a0:	758080e7          	jalr	1880(ra) # 5bf4 <exit>
    printf("%s: chdir iputdir failed\n", s);
    34a4:	85a6                	mv	a1,s1
    34a6:	00004517          	auipc	a0,0x4
    34aa:	f2a50513          	addi	a0,a0,-214 # 73d0 <malloc+0x13a6>
    34ae:	00003097          	auipc	ra,0x3
    34b2:	abe080e7          	jalr	-1346(ra) # 5f6c <printf>
    exit(1);
    34b6:	4505                	li	a0,1
    34b8:	00002097          	auipc	ra,0x2
    34bc:	73c080e7          	jalr	1852(ra) # 5bf4 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    34c0:	85a6                	mv	a1,s1
    34c2:	00004517          	auipc	a0,0x4
    34c6:	f3e50513          	addi	a0,a0,-194 # 7400 <malloc+0x13d6>
    34ca:	00003097          	auipc	ra,0x3
    34ce:	aa2080e7          	jalr	-1374(ra) # 5f6c <printf>
    exit(1);
    34d2:	4505                	li	a0,1
    34d4:	00002097          	auipc	ra,0x2
    34d8:	720080e7          	jalr	1824(ra) # 5bf4 <exit>
    printf("%s: chdir / failed\n", s);
    34dc:	85a6                	mv	a1,s1
    34de:	00004517          	auipc	a0,0x4
    34e2:	f4a50513          	addi	a0,a0,-182 # 7428 <malloc+0x13fe>
    34e6:	00003097          	auipc	ra,0x3
    34ea:	a86080e7          	jalr	-1402(ra) # 5f6c <printf>
    exit(1);
    34ee:	4505                	li	a0,1
    34f0:	00002097          	auipc	ra,0x2
    34f4:	704080e7          	jalr	1796(ra) # 5bf4 <exit>

00000000000034f8 <exitiputtest>:
{
    34f8:	7179                	addi	sp,sp,-48
    34fa:	f406                	sd	ra,40(sp)
    34fc:	f022                	sd	s0,32(sp)
    34fe:	ec26                	sd	s1,24(sp)
    3500:	1800                	addi	s0,sp,48
    3502:	84aa                	mv	s1,a0
  pid = fork();
    3504:	00002097          	auipc	ra,0x2
    3508:	6e8080e7          	jalr	1768(ra) # 5bec <fork>
  if(pid < 0){
    350c:	04054663          	bltz	a0,3558 <exitiputtest+0x60>
  if(pid == 0){
    3510:	ed45                	bnez	a0,35c8 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    3512:	00004517          	auipc	a0,0x4
    3516:	e9e50513          	addi	a0,a0,-354 # 73b0 <malloc+0x1386>
    351a:	00002097          	auipc	ra,0x2
    351e:	742080e7          	jalr	1858(ra) # 5c5c <mkdir>
    3522:	04054963          	bltz	a0,3574 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    3526:	00004517          	auipc	a0,0x4
    352a:	e8a50513          	addi	a0,a0,-374 # 73b0 <malloc+0x1386>
    352e:	00002097          	auipc	ra,0x2
    3532:	736080e7          	jalr	1846(ra) # 5c64 <chdir>
    3536:	04054d63          	bltz	a0,3590 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    353a:	00004517          	auipc	a0,0x4
    353e:	eb650513          	addi	a0,a0,-330 # 73f0 <malloc+0x13c6>
    3542:	00002097          	auipc	ra,0x2
    3546:	702080e7          	jalr	1794(ra) # 5c44 <unlink>
    354a:	06054163          	bltz	a0,35ac <exitiputtest+0xb4>
    exit(0);
    354e:	4501                	li	a0,0
    3550:	00002097          	auipc	ra,0x2
    3554:	6a4080e7          	jalr	1700(ra) # 5bf4 <exit>
    printf("%s: fork failed\n", s);
    3558:	85a6                	mv	a1,s1
    355a:	00003517          	auipc	a0,0x3
    355e:	49650513          	addi	a0,a0,1174 # 69f0 <malloc+0x9c6>
    3562:	00003097          	auipc	ra,0x3
    3566:	a0a080e7          	jalr	-1526(ra) # 5f6c <printf>
    exit(1);
    356a:	4505                	li	a0,1
    356c:	00002097          	auipc	ra,0x2
    3570:	688080e7          	jalr	1672(ra) # 5bf4 <exit>
      printf("%s: mkdir failed\n", s);
    3574:	85a6                	mv	a1,s1
    3576:	00004517          	auipc	a0,0x4
    357a:	e4250513          	addi	a0,a0,-446 # 73b8 <malloc+0x138e>
    357e:	00003097          	auipc	ra,0x3
    3582:	9ee080e7          	jalr	-1554(ra) # 5f6c <printf>
      exit(1);
    3586:	4505                	li	a0,1
    3588:	00002097          	auipc	ra,0x2
    358c:	66c080e7          	jalr	1644(ra) # 5bf4 <exit>
      printf("%s: child chdir failed\n", s);
    3590:	85a6                	mv	a1,s1
    3592:	00004517          	auipc	a0,0x4
    3596:	eae50513          	addi	a0,a0,-338 # 7440 <malloc+0x1416>
    359a:	00003097          	auipc	ra,0x3
    359e:	9d2080e7          	jalr	-1582(ra) # 5f6c <printf>
      exit(1);
    35a2:	4505                	li	a0,1
    35a4:	00002097          	auipc	ra,0x2
    35a8:	650080e7          	jalr	1616(ra) # 5bf4 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    35ac:	85a6                	mv	a1,s1
    35ae:	00004517          	auipc	a0,0x4
    35b2:	e5250513          	addi	a0,a0,-430 # 7400 <malloc+0x13d6>
    35b6:	00003097          	auipc	ra,0x3
    35ba:	9b6080e7          	jalr	-1610(ra) # 5f6c <printf>
      exit(1);
    35be:	4505                	li	a0,1
    35c0:	00002097          	auipc	ra,0x2
    35c4:	634080e7          	jalr	1588(ra) # 5bf4 <exit>
  wait(&xstatus);
    35c8:	fdc40513          	addi	a0,s0,-36
    35cc:	00002097          	auipc	ra,0x2
    35d0:	630080e7          	jalr	1584(ra) # 5bfc <wait>
  exit(xstatus);
    35d4:	fdc42503          	lw	a0,-36(s0)
    35d8:	00002097          	auipc	ra,0x2
    35dc:	61c080e7          	jalr	1564(ra) # 5bf4 <exit>

00000000000035e0 <dirtest>:
{
    35e0:	1101                	addi	sp,sp,-32
    35e2:	ec06                	sd	ra,24(sp)
    35e4:	e822                	sd	s0,16(sp)
    35e6:	e426                	sd	s1,8(sp)
    35e8:	1000                	addi	s0,sp,32
    35ea:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    35ec:	00004517          	auipc	a0,0x4
    35f0:	e6c50513          	addi	a0,a0,-404 # 7458 <malloc+0x142e>
    35f4:	00002097          	auipc	ra,0x2
    35f8:	668080e7          	jalr	1640(ra) # 5c5c <mkdir>
    35fc:	04054563          	bltz	a0,3646 <dirtest+0x66>
  if(chdir("dir0") < 0){
    3600:	00004517          	auipc	a0,0x4
    3604:	e5850513          	addi	a0,a0,-424 # 7458 <malloc+0x142e>
    3608:	00002097          	auipc	ra,0x2
    360c:	65c080e7          	jalr	1628(ra) # 5c64 <chdir>
    3610:	04054963          	bltz	a0,3662 <dirtest+0x82>
  if(chdir("..") < 0){
    3614:	00004517          	auipc	a0,0x4
    3618:	e6450513          	addi	a0,a0,-412 # 7478 <malloc+0x144e>
    361c:	00002097          	auipc	ra,0x2
    3620:	648080e7          	jalr	1608(ra) # 5c64 <chdir>
    3624:	04054d63          	bltz	a0,367e <dirtest+0x9e>
  if(unlink("dir0") < 0){
    3628:	00004517          	auipc	a0,0x4
    362c:	e3050513          	addi	a0,a0,-464 # 7458 <malloc+0x142e>
    3630:	00002097          	auipc	ra,0x2
    3634:	614080e7          	jalr	1556(ra) # 5c44 <unlink>
    3638:	06054163          	bltz	a0,369a <dirtest+0xba>
}
    363c:	60e2                	ld	ra,24(sp)
    363e:	6442                	ld	s0,16(sp)
    3640:	64a2                	ld	s1,8(sp)
    3642:	6105                	addi	sp,sp,32
    3644:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3646:	85a6                	mv	a1,s1
    3648:	00004517          	auipc	a0,0x4
    364c:	d7050513          	addi	a0,a0,-656 # 73b8 <malloc+0x138e>
    3650:	00003097          	auipc	ra,0x3
    3654:	91c080e7          	jalr	-1764(ra) # 5f6c <printf>
    exit(1);
    3658:	4505                	li	a0,1
    365a:	00002097          	auipc	ra,0x2
    365e:	59a080e7          	jalr	1434(ra) # 5bf4 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3662:	85a6                	mv	a1,s1
    3664:	00004517          	auipc	a0,0x4
    3668:	dfc50513          	addi	a0,a0,-516 # 7460 <malloc+0x1436>
    366c:	00003097          	auipc	ra,0x3
    3670:	900080e7          	jalr	-1792(ra) # 5f6c <printf>
    exit(1);
    3674:	4505                	li	a0,1
    3676:	00002097          	auipc	ra,0x2
    367a:	57e080e7          	jalr	1406(ra) # 5bf4 <exit>
    printf("%s: chdir .. failed\n", s);
    367e:	85a6                	mv	a1,s1
    3680:	00004517          	auipc	a0,0x4
    3684:	e0050513          	addi	a0,a0,-512 # 7480 <malloc+0x1456>
    3688:	00003097          	auipc	ra,0x3
    368c:	8e4080e7          	jalr	-1820(ra) # 5f6c <printf>
    exit(1);
    3690:	4505                	li	a0,1
    3692:	00002097          	auipc	ra,0x2
    3696:	562080e7          	jalr	1378(ra) # 5bf4 <exit>
    printf("%s: unlink dir0 failed\n", s);
    369a:	85a6                	mv	a1,s1
    369c:	00004517          	auipc	a0,0x4
    36a0:	dfc50513          	addi	a0,a0,-516 # 7498 <malloc+0x146e>
    36a4:	00003097          	auipc	ra,0x3
    36a8:	8c8080e7          	jalr	-1848(ra) # 5f6c <printf>
    exit(1);
    36ac:	4505                	li	a0,1
    36ae:	00002097          	auipc	ra,0x2
    36b2:	546080e7          	jalr	1350(ra) # 5bf4 <exit>

00000000000036b6 <subdir>:
{
    36b6:	1101                	addi	sp,sp,-32
    36b8:	ec06                	sd	ra,24(sp)
    36ba:	e822                	sd	s0,16(sp)
    36bc:	e426                	sd	s1,8(sp)
    36be:	e04a                	sd	s2,0(sp)
    36c0:	1000                	addi	s0,sp,32
    36c2:	892a                	mv	s2,a0
  unlink("ff");
    36c4:	00004517          	auipc	a0,0x4
    36c8:	f1c50513          	addi	a0,a0,-228 # 75e0 <malloc+0x15b6>
    36cc:	00002097          	auipc	ra,0x2
    36d0:	578080e7          	jalr	1400(ra) # 5c44 <unlink>
  if(mkdir("dd") != 0){
    36d4:	00004517          	auipc	a0,0x4
    36d8:	ddc50513          	addi	a0,a0,-548 # 74b0 <malloc+0x1486>
    36dc:	00002097          	auipc	ra,0x2
    36e0:	580080e7          	jalr	1408(ra) # 5c5c <mkdir>
    36e4:	38051663          	bnez	a0,3a70 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36e8:	20200593          	li	a1,514
    36ec:	00004517          	auipc	a0,0x4
    36f0:	de450513          	addi	a0,a0,-540 # 74d0 <malloc+0x14a6>
    36f4:	00002097          	auipc	ra,0x2
    36f8:	540080e7          	jalr	1344(ra) # 5c34 <open>
    36fc:	84aa                	mv	s1,a0
  if(fd < 0){
    36fe:	38054763          	bltz	a0,3a8c <subdir+0x3d6>
  write(fd, "ff", 2);
    3702:	4609                	li	a2,2
    3704:	00004597          	auipc	a1,0x4
    3708:	edc58593          	addi	a1,a1,-292 # 75e0 <malloc+0x15b6>
    370c:	00002097          	auipc	ra,0x2
    3710:	508080e7          	jalr	1288(ra) # 5c14 <write>
  close(fd);
    3714:	8526                	mv	a0,s1
    3716:	00002097          	auipc	ra,0x2
    371a:	506080e7          	jalr	1286(ra) # 5c1c <close>
  if(unlink("dd") >= 0){
    371e:	00004517          	auipc	a0,0x4
    3722:	d9250513          	addi	a0,a0,-622 # 74b0 <malloc+0x1486>
    3726:	00002097          	auipc	ra,0x2
    372a:	51e080e7          	jalr	1310(ra) # 5c44 <unlink>
    372e:	36055d63          	bgez	a0,3aa8 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    3732:	00004517          	auipc	a0,0x4
    3736:	df650513          	addi	a0,a0,-522 # 7528 <malloc+0x14fe>
    373a:	00002097          	auipc	ra,0x2
    373e:	522080e7          	jalr	1314(ra) # 5c5c <mkdir>
    3742:	38051163          	bnez	a0,3ac4 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3746:	20200593          	li	a1,514
    374a:	00004517          	auipc	a0,0x4
    374e:	e0650513          	addi	a0,a0,-506 # 7550 <malloc+0x1526>
    3752:	00002097          	auipc	ra,0x2
    3756:	4e2080e7          	jalr	1250(ra) # 5c34 <open>
    375a:	84aa                	mv	s1,a0
  if(fd < 0){
    375c:	38054263          	bltz	a0,3ae0 <subdir+0x42a>
  write(fd, "FF", 2);
    3760:	4609                	li	a2,2
    3762:	00004597          	auipc	a1,0x4
    3766:	e1e58593          	addi	a1,a1,-482 # 7580 <malloc+0x1556>
    376a:	00002097          	auipc	ra,0x2
    376e:	4aa080e7          	jalr	1194(ra) # 5c14 <write>
  close(fd);
    3772:	8526                	mv	a0,s1
    3774:	00002097          	auipc	ra,0x2
    3778:	4a8080e7          	jalr	1192(ra) # 5c1c <close>
  fd = open("dd/dd/../ff", 0);
    377c:	4581                	li	a1,0
    377e:	00004517          	auipc	a0,0x4
    3782:	e0a50513          	addi	a0,a0,-502 # 7588 <malloc+0x155e>
    3786:	00002097          	auipc	ra,0x2
    378a:	4ae080e7          	jalr	1198(ra) # 5c34 <open>
    378e:	84aa                	mv	s1,a0
  if(fd < 0){
    3790:	36054663          	bltz	a0,3afc <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3794:	660d                	lui	a2,0x3
    3796:	00009597          	auipc	a1,0x9
    379a:	4e258593          	addi	a1,a1,1250 # cc78 <buf>
    379e:	00002097          	auipc	ra,0x2
    37a2:	46e080e7          	jalr	1134(ra) # 5c0c <read>
  if(cc != 2 || buf[0] != 'f'){
    37a6:	4789                	li	a5,2
    37a8:	36f51863          	bne	a0,a5,3b18 <subdir+0x462>
    37ac:	00009717          	auipc	a4,0x9
    37b0:	4cc74703          	lbu	a4,1228(a4) # cc78 <buf>
    37b4:	06600793          	li	a5,102
    37b8:	36f71063          	bne	a4,a5,3b18 <subdir+0x462>
  close(fd);
    37bc:	8526                	mv	a0,s1
    37be:	00002097          	auipc	ra,0x2
    37c2:	45e080e7          	jalr	1118(ra) # 5c1c <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    37c6:	00004597          	auipc	a1,0x4
    37ca:	e1258593          	addi	a1,a1,-494 # 75d8 <malloc+0x15ae>
    37ce:	00004517          	auipc	a0,0x4
    37d2:	d8250513          	addi	a0,a0,-638 # 7550 <malloc+0x1526>
    37d6:	00002097          	auipc	ra,0x2
    37da:	47e080e7          	jalr	1150(ra) # 5c54 <link>
    37de:	34051b63          	bnez	a0,3b34 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    37e2:	00004517          	auipc	a0,0x4
    37e6:	d6e50513          	addi	a0,a0,-658 # 7550 <malloc+0x1526>
    37ea:	00002097          	auipc	ra,0x2
    37ee:	45a080e7          	jalr	1114(ra) # 5c44 <unlink>
    37f2:	34051f63          	bnez	a0,3b50 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    37f6:	4581                	li	a1,0
    37f8:	00004517          	auipc	a0,0x4
    37fc:	d5850513          	addi	a0,a0,-680 # 7550 <malloc+0x1526>
    3800:	00002097          	auipc	ra,0x2
    3804:	434080e7          	jalr	1076(ra) # 5c34 <open>
    3808:	36055263          	bgez	a0,3b6c <subdir+0x4b6>
  if(chdir("dd") != 0){
    380c:	00004517          	auipc	a0,0x4
    3810:	ca450513          	addi	a0,a0,-860 # 74b0 <malloc+0x1486>
    3814:	00002097          	auipc	ra,0x2
    3818:	450080e7          	jalr	1104(ra) # 5c64 <chdir>
    381c:	36051663          	bnez	a0,3b88 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3820:	00004517          	auipc	a0,0x4
    3824:	e5050513          	addi	a0,a0,-432 # 7670 <malloc+0x1646>
    3828:	00002097          	auipc	ra,0x2
    382c:	43c080e7          	jalr	1084(ra) # 5c64 <chdir>
    3830:	36051a63          	bnez	a0,3ba4 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3834:	00004517          	auipc	a0,0x4
    3838:	e6c50513          	addi	a0,a0,-404 # 76a0 <malloc+0x1676>
    383c:	00002097          	auipc	ra,0x2
    3840:	428080e7          	jalr	1064(ra) # 5c64 <chdir>
    3844:	36051e63          	bnez	a0,3bc0 <subdir+0x50a>
  if(chdir("./..") != 0){
    3848:	00004517          	auipc	a0,0x4
    384c:	e8850513          	addi	a0,a0,-376 # 76d0 <malloc+0x16a6>
    3850:	00002097          	auipc	ra,0x2
    3854:	414080e7          	jalr	1044(ra) # 5c64 <chdir>
    3858:	38051263          	bnez	a0,3bdc <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    385c:	4581                	li	a1,0
    385e:	00004517          	auipc	a0,0x4
    3862:	d7a50513          	addi	a0,a0,-646 # 75d8 <malloc+0x15ae>
    3866:	00002097          	auipc	ra,0x2
    386a:	3ce080e7          	jalr	974(ra) # 5c34 <open>
    386e:	84aa                	mv	s1,a0
  if(fd < 0){
    3870:	38054463          	bltz	a0,3bf8 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3874:	660d                	lui	a2,0x3
    3876:	00009597          	auipc	a1,0x9
    387a:	40258593          	addi	a1,a1,1026 # cc78 <buf>
    387e:	00002097          	auipc	ra,0x2
    3882:	38e080e7          	jalr	910(ra) # 5c0c <read>
    3886:	4789                	li	a5,2
    3888:	38f51663          	bne	a0,a5,3c14 <subdir+0x55e>
  close(fd);
    388c:	8526                	mv	a0,s1
    388e:	00002097          	auipc	ra,0x2
    3892:	38e080e7          	jalr	910(ra) # 5c1c <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3896:	4581                	li	a1,0
    3898:	00004517          	auipc	a0,0x4
    389c:	cb850513          	addi	a0,a0,-840 # 7550 <malloc+0x1526>
    38a0:	00002097          	auipc	ra,0x2
    38a4:	394080e7          	jalr	916(ra) # 5c34 <open>
    38a8:	38055463          	bgez	a0,3c30 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    38ac:	20200593          	li	a1,514
    38b0:	00004517          	auipc	a0,0x4
    38b4:	eb050513          	addi	a0,a0,-336 # 7760 <malloc+0x1736>
    38b8:	00002097          	auipc	ra,0x2
    38bc:	37c080e7          	jalr	892(ra) # 5c34 <open>
    38c0:	38055663          	bgez	a0,3c4c <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    38c4:	20200593          	li	a1,514
    38c8:	00004517          	auipc	a0,0x4
    38cc:	ec850513          	addi	a0,a0,-312 # 7790 <malloc+0x1766>
    38d0:	00002097          	auipc	ra,0x2
    38d4:	364080e7          	jalr	868(ra) # 5c34 <open>
    38d8:	38055863          	bgez	a0,3c68 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    38dc:	20000593          	li	a1,512
    38e0:	00004517          	auipc	a0,0x4
    38e4:	bd050513          	addi	a0,a0,-1072 # 74b0 <malloc+0x1486>
    38e8:	00002097          	auipc	ra,0x2
    38ec:	34c080e7          	jalr	844(ra) # 5c34 <open>
    38f0:	38055a63          	bgez	a0,3c84 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    38f4:	4589                	li	a1,2
    38f6:	00004517          	auipc	a0,0x4
    38fa:	bba50513          	addi	a0,a0,-1094 # 74b0 <malloc+0x1486>
    38fe:	00002097          	auipc	ra,0x2
    3902:	336080e7          	jalr	822(ra) # 5c34 <open>
    3906:	38055d63          	bgez	a0,3ca0 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    390a:	4585                	li	a1,1
    390c:	00004517          	auipc	a0,0x4
    3910:	ba450513          	addi	a0,a0,-1116 # 74b0 <malloc+0x1486>
    3914:	00002097          	auipc	ra,0x2
    3918:	320080e7          	jalr	800(ra) # 5c34 <open>
    391c:	3a055063          	bgez	a0,3cbc <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3920:	00004597          	auipc	a1,0x4
    3924:	f0058593          	addi	a1,a1,-256 # 7820 <malloc+0x17f6>
    3928:	00004517          	auipc	a0,0x4
    392c:	e3850513          	addi	a0,a0,-456 # 7760 <malloc+0x1736>
    3930:	00002097          	auipc	ra,0x2
    3934:	324080e7          	jalr	804(ra) # 5c54 <link>
    3938:	3a050063          	beqz	a0,3cd8 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    393c:	00004597          	auipc	a1,0x4
    3940:	ee458593          	addi	a1,a1,-284 # 7820 <malloc+0x17f6>
    3944:	00004517          	auipc	a0,0x4
    3948:	e4c50513          	addi	a0,a0,-436 # 7790 <malloc+0x1766>
    394c:	00002097          	auipc	ra,0x2
    3950:	308080e7          	jalr	776(ra) # 5c54 <link>
    3954:	3a050063          	beqz	a0,3cf4 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3958:	00004597          	auipc	a1,0x4
    395c:	c8058593          	addi	a1,a1,-896 # 75d8 <malloc+0x15ae>
    3960:	00004517          	auipc	a0,0x4
    3964:	b7050513          	addi	a0,a0,-1168 # 74d0 <malloc+0x14a6>
    3968:	00002097          	auipc	ra,0x2
    396c:	2ec080e7          	jalr	748(ra) # 5c54 <link>
    3970:	3a050063          	beqz	a0,3d10 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3974:	00004517          	auipc	a0,0x4
    3978:	dec50513          	addi	a0,a0,-532 # 7760 <malloc+0x1736>
    397c:	00002097          	auipc	ra,0x2
    3980:	2e0080e7          	jalr	736(ra) # 5c5c <mkdir>
    3984:	3a050463          	beqz	a0,3d2c <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3988:	00004517          	auipc	a0,0x4
    398c:	e0850513          	addi	a0,a0,-504 # 7790 <malloc+0x1766>
    3990:	00002097          	auipc	ra,0x2
    3994:	2cc080e7          	jalr	716(ra) # 5c5c <mkdir>
    3998:	3a050863          	beqz	a0,3d48 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    399c:	00004517          	auipc	a0,0x4
    39a0:	c3c50513          	addi	a0,a0,-964 # 75d8 <malloc+0x15ae>
    39a4:	00002097          	auipc	ra,0x2
    39a8:	2b8080e7          	jalr	696(ra) # 5c5c <mkdir>
    39ac:	3a050c63          	beqz	a0,3d64 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    39b0:	00004517          	auipc	a0,0x4
    39b4:	de050513          	addi	a0,a0,-544 # 7790 <malloc+0x1766>
    39b8:	00002097          	auipc	ra,0x2
    39bc:	28c080e7          	jalr	652(ra) # 5c44 <unlink>
    39c0:	3c050063          	beqz	a0,3d80 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    39c4:	00004517          	auipc	a0,0x4
    39c8:	d9c50513          	addi	a0,a0,-612 # 7760 <malloc+0x1736>
    39cc:	00002097          	auipc	ra,0x2
    39d0:	278080e7          	jalr	632(ra) # 5c44 <unlink>
    39d4:	3c050463          	beqz	a0,3d9c <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    39d8:	00004517          	auipc	a0,0x4
    39dc:	af850513          	addi	a0,a0,-1288 # 74d0 <malloc+0x14a6>
    39e0:	00002097          	auipc	ra,0x2
    39e4:	284080e7          	jalr	644(ra) # 5c64 <chdir>
    39e8:	3c050863          	beqz	a0,3db8 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    39ec:	00004517          	auipc	a0,0x4
    39f0:	f8450513          	addi	a0,a0,-124 # 7970 <malloc+0x1946>
    39f4:	00002097          	auipc	ra,0x2
    39f8:	270080e7          	jalr	624(ra) # 5c64 <chdir>
    39fc:	3c050c63          	beqz	a0,3dd4 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3a00:	00004517          	auipc	a0,0x4
    3a04:	bd850513          	addi	a0,a0,-1064 # 75d8 <malloc+0x15ae>
    3a08:	00002097          	auipc	ra,0x2
    3a0c:	23c080e7          	jalr	572(ra) # 5c44 <unlink>
    3a10:	3e051063          	bnez	a0,3df0 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3a14:	00004517          	auipc	a0,0x4
    3a18:	abc50513          	addi	a0,a0,-1348 # 74d0 <malloc+0x14a6>
    3a1c:	00002097          	auipc	ra,0x2
    3a20:	228080e7          	jalr	552(ra) # 5c44 <unlink>
    3a24:	3e051463          	bnez	a0,3e0c <subdir+0x756>
  if(unlink("dd") == 0){
    3a28:	00004517          	auipc	a0,0x4
    3a2c:	a8850513          	addi	a0,a0,-1400 # 74b0 <malloc+0x1486>
    3a30:	00002097          	auipc	ra,0x2
    3a34:	214080e7          	jalr	532(ra) # 5c44 <unlink>
    3a38:	3e050863          	beqz	a0,3e28 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a3c:	00004517          	auipc	a0,0x4
    3a40:	fa450513          	addi	a0,a0,-92 # 79e0 <malloc+0x19b6>
    3a44:	00002097          	auipc	ra,0x2
    3a48:	200080e7          	jalr	512(ra) # 5c44 <unlink>
    3a4c:	3e054c63          	bltz	a0,3e44 <subdir+0x78e>
  if(unlink("dd") < 0){
    3a50:	00004517          	auipc	a0,0x4
    3a54:	a6050513          	addi	a0,a0,-1440 # 74b0 <malloc+0x1486>
    3a58:	00002097          	auipc	ra,0x2
    3a5c:	1ec080e7          	jalr	492(ra) # 5c44 <unlink>
    3a60:	40054063          	bltz	a0,3e60 <subdir+0x7aa>
}
    3a64:	60e2                	ld	ra,24(sp)
    3a66:	6442                	ld	s0,16(sp)
    3a68:	64a2                	ld	s1,8(sp)
    3a6a:	6902                	ld	s2,0(sp)
    3a6c:	6105                	addi	sp,sp,32
    3a6e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a70:	85ca                	mv	a1,s2
    3a72:	00004517          	auipc	a0,0x4
    3a76:	a4650513          	addi	a0,a0,-1466 # 74b8 <malloc+0x148e>
    3a7a:	00002097          	auipc	ra,0x2
    3a7e:	4f2080e7          	jalr	1266(ra) # 5f6c <printf>
    exit(1);
    3a82:	4505                	li	a0,1
    3a84:	00002097          	auipc	ra,0x2
    3a88:	170080e7          	jalr	368(ra) # 5bf4 <exit>
    printf("%s: create dd/ff failed\n", s);
    3a8c:	85ca                	mv	a1,s2
    3a8e:	00004517          	auipc	a0,0x4
    3a92:	a4a50513          	addi	a0,a0,-1462 # 74d8 <malloc+0x14ae>
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	4d6080e7          	jalr	1238(ra) # 5f6c <printf>
    exit(1);
    3a9e:	4505                	li	a0,1
    3aa0:	00002097          	auipc	ra,0x2
    3aa4:	154080e7          	jalr	340(ra) # 5bf4 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3aa8:	85ca                	mv	a1,s2
    3aaa:	00004517          	auipc	a0,0x4
    3aae:	a4e50513          	addi	a0,a0,-1458 # 74f8 <malloc+0x14ce>
    3ab2:	00002097          	auipc	ra,0x2
    3ab6:	4ba080e7          	jalr	1210(ra) # 5f6c <printf>
    exit(1);
    3aba:	4505                	li	a0,1
    3abc:	00002097          	auipc	ra,0x2
    3ac0:	138080e7          	jalr	312(ra) # 5bf4 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3ac4:	85ca                	mv	a1,s2
    3ac6:	00004517          	auipc	a0,0x4
    3aca:	a6a50513          	addi	a0,a0,-1430 # 7530 <malloc+0x1506>
    3ace:	00002097          	auipc	ra,0x2
    3ad2:	49e080e7          	jalr	1182(ra) # 5f6c <printf>
    exit(1);
    3ad6:	4505                	li	a0,1
    3ad8:	00002097          	auipc	ra,0x2
    3adc:	11c080e7          	jalr	284(ra) # 5bf4 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3ae0:	85ca                	mv	a1,s2
    3ae2:	00004517          	auipc	a0,0x4
    3ae6:	a7e50513          	addi	a0,a0,-1410 # 7560 <malloc+0x1536>
    3aea:	00002097          	auipc	ra,0x2
    3aee:	482080e7          	jalr	1154(ra) # 5f6c <printf>
    exit(1);
    3af2:	4505                	li	a0,1
    3af4:	00002097          	auipc	ra,0x2
    3af8:	100080e7          	jalr	256(ra) # 5bf4 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3afc:	85ca                	mv	a1,s2
    3afe:	00004517          	auipc	a0,0x4
    3b02:	a9a50513          	addi	a0,a0,-1382 # 7598 <malloc+0x156e>
    3b06:	00002097          	auipc	ra,0x2
    3b0a:	466080e7          	jalr	1126(ra) # 5f6c <printf>
    exit(1);
    3b0e:	4505                	li	a0,1
    3b10:	00002097          	auipc	ra,0x2
    3b14:	0e4080e7          	jalr	228(ra) # 5bf4 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3b18:	85ca                	mv	a1,s2
    3b1a:	00004517          	auipc	a0,0x4
    3b1e:	a9e50513          	addi	a0,a0,-1378 # 75b8 <malloc+0x158e>
    3b22:	00002097          	auipc	ra,0x2
    3b26:	44a080e7          	jalr	1098(ra) # 5f6c <printf>
    exit(1);
    3b2a:	4505                	li	a0,1
    3b2c:	00002097          	auipc	ra,0x2
    3b30:	0c8080e7          	jalr	200(ra) # 5bf4 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b34:	85ca                	mv	a1,s2
    3b36:	00004517          	auipc	a0,0x4
    3b3a:	ab250513          	addi	a0,a0,-1358 # 75e8 <malloc+0x15be>
    3b3e:	00002097          	auipc	ra,0x2
    3b42:	42e080e7          	jalr	1070(ra) # 5f6c <printf>
    exit(1);
    3b46:	4505                	li	a0,1
    3b48:	00002097          	auipc	ra,0x2
    3b4c:	0ac080e7          	jalr	172(ra) # 5bf4 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b50:	85ca                	mv	a1,s2
    3b52:	00004517          	auipc	a0,0x4
    3b56:	abe50513          	addi	a0,a0,-1346 # 7610 <malloc+0x15e6>
    3b5a:	00002097          	auipc	ra,0x2
    3b5e:	412080e7          	jalr	1042(ra) # 5f6c <printf>
    exit(1);
    3b62:	4505                	li	a0,1
    3b64:	00002097          	auipc	ra,0x2
    3b68:	090080e7          	jalr	144(ra) # 5bf4 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b6c:	85ca                	mv	a1,s2
    3b6e:	00004517          	auipc	a0,0x4
    3b72:	ac250513          	addi	a0,a0,-1342 # 7630 <malloc+0x1606>
    3b76:	00002097          	auipc	ra,0x2
    3b7a:	3f6080e7          	jalr	1014(ra) # 5f6c <printf>
    exit(1);
    3b7e:	4505                	li	a0,1
    3b80:	00002097          	auipc	ra,0x2
    3b84:	074080e7          	jalr	116(ra) # 5bf4 <exit>
    printf("%s: chdir dd failed\n", s);
    3b88:	85ca                	mv	a1,s2
    3b8a:	00004517          	auipc	a0,0x4
    3b8e:	ace50513          	addi	a0,a0,-1330 # 7658 <malloc+0x162e>
    3b92:	00002097          	auipc	ra,0x2
    3b96:	3da080e7          	jalr	986(ra) # 5f6c <printf>
    exit(1);
    3b9a:	4505                	li	a0,1
    3b9c:	00002097          	auipc	ra,0x2
    3ba0:	058080e7          	jalr	88(ra) # 5bf4 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3ba4:	85ca                	mv	a1,s2
    3ba6:	00004517          	auipc	a0,0x4
    3baa:	ada50513          	addi	a0,a0,-1318 # 7680 <malloc+0x1656>
    3bae:	00002097          	auipc	ra,0x2
    3bb2:	3be080e7          	jalr	958(ra) # 5f6c <printf>
    exit(1);
    3bb6:	4505                	li	a0,1
    3bb8:	00002097          	auipc	ra,0x2
    3bbc:	03c080e7          	jalr	60(ra) # 5bf4 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3bc0:	85ca                	mv	a1,s2
    3bc2:	00004517          	auipc	a0,0x4
    3bc6:	aee50513          	addi	a0,a0,-1298 # 76b0 <malloc+0x1686>
    3bca:	00002097          	auipc	ra,0x2
    3bce:	3a2080e7          	jalr	930(ra) # 5f6c <printf>
    exit(1);
    3bd2:	4505                	li	a0,1
    3bd4:	00002097          	auipc	ra,0x2
    3bd8:	020080e7          	jalr	32(ra) # 5bf4 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3bdc:	85ca                	mv	a1,s2
    3bde:	00004517          	auipc	a0,0x4
    3be2:	afa50513          	addi	a0,a0,-1286 # 76d8 <malloc+0x16ae>
    3be6:	00002097          	auipc	ra,0x2
    3bea:	386080e7          	jalr	902(ra) # 5f6c <printf>
    exit(1);
    3bee:	4505                	li	a0,1
    3bf0:	00002097          	auipc	ra,0x2
    3bf4:	004080e7          	jalr	4(ra) # 5bf4 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3bf8:	85ca                	mv	a1,s2
    3bfa:	00004517          	auipc	a0,0x4
    3bfe:	af650513          	addi	a0,a0,-1290 # 76f0 <malloc+0x16c6>
    3c02:	00002097          	auipc	ra,0x2
    3c06:	36a080e7          	jalr	874(ra) # 5f6c <printf>
    exit(1);
    3c0a:	4505                	li	a0,1
    3c0c:	00002097          	auipc	ra,0x2
    3c10:	fe8080e7          	jalr	-24(ra) # 5bf4 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3c14:	85ca                	mv	a1,s2
    3c16:	00004517          	auipc	a0,0x4
    3c1a:	afa50513          	addi	a0,a0,-1286 # 7710 <malloc+0x16e6>
    3c1e:	00002097          	auipc	ra,0x2
    3c22:	34e080e7          	jalr	846(ra) # 5f6c <printf>
    exit(1);
    3c26:	4505                	li	a0,1
    3c28:	00002097          	auipc	ra,0x2
    3c2c:	fcc080e7          	jalr	-52(ra) # 5bf4 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c30:	85ca                	mv	a1,s2
    3c32:	00004517          	auipc	a0,0x4
    3c36:	afe50513          	addi	a0,a0,-1282 # 7730 <malloc+0x1706>
    3c3a:	00002097          	auipc	ra,0x2
    3c3e:	332080e7          	jalr	818(ra) # 5f6c <printf>
    exit(1);
    3c42:	4505                	li	a0,1
    3c44:	00002097          	auipc	ra,0x2
    3c48:	fb0080e7          	jalr	-80(ra) # 5bf4 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c4c:	85ca                	mv	a1,s2
    3c4e:	00004517          	auipc	a0,0x4
    3c52:	b2250513          	addi	a0,a0,-1246 # 7770 <malloc+0x1746>
    3c56:	00002097          	auipc	ra,0x2
    3c5a:	316080e7          	jalr	790(ra) # 5f6c <printf>
    exit(1);
    3c5e:	4505                	li	a0,1
    3c60:	00002097          	auipc	ra,0x2
    3c64:	f94080e7          	jalr	-108(ra) # 5bf4 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c68:	85ca                	mv	a1,s2
    3c6a:	00004517          	auipc	a0,0x4
    3c6e:	b3650513          	addi	a0,a0,-1226 # 77a0 <malloc+0x1776>
    3c72:	00002097          	auipc	ra,0x2
    3c76:	2fa080e7          	jalr	762(ra) # 5f6c <printf>
    exit(1);
    3c7a:	4505                	li	a0,1
    3c7c:	00002097          	auipc	ra,0x2
    3c80:	f78080e7          	jalr	-136(ra) # 5bf4 <exit>
    printf("%s: create dd succeeded!\n", s);
    3c84:	85ca                	mv	a1,s2
    3c86:	00004517          	auipc	a0,0x4
    3c8a:	b3a50513          	addi	a0,a0,-1222 # 77c0 <malloc+0x1796>
    3c8e:	00002097          	auipc	ra,0x2
    3c92:	2de080e7          	jalr	734(ra) # 5f6c <printf>
    exit(1);
    3c96:	4505                	li	a0,1
    3c98:	00002097          	auipc	ra,0x2
    3c9c:	f5c080e7          	jalr	-164(ra) # 5bf4 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3ca0:	85ca                	mv	a1,s2
    3ca2:	00004517          	auipc	a0,0x4
    3ca6:	b3e50513          	addi	a0,a0,-1218 # 77e0 <malloc+0x17b6>
    3caa:	00002097          	auipc	ra,0x2
    3cae:	2c2080e7          	jalr	706(ra) # 5f6c <printf>
    exit(1);
    3cb2:	4505                	li	a0,1
    3cb4:	00002097          	auipc	ra,0x2
    3cb8:	f40080e7          	jalr	-192(ra) # 5bf4 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3cbc:	85ca                	mv	a1,s2
    3cbe:	00004517          	auipc	a0,0x4
    3cc2:	b4250513          	addi	a0,a0,-1214 # 7800 <malloc+0x17d6>
    3cc6:	00002097          	auipc	ra,0x2
    3cca:	2a6080e7          	jalr	678(ra) # 5f6c <printf>
    exit(1);
    3cce:	4505                	li	a0,1
    3cd0:	00002097          	auipc	ra,0x2
    3cd4:	f24080e7          	jalr	-220(ra) # 5bf4 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3cd8:	85ca                	mv	a1,s2
    3cda:	00004517          	auipc	a0,0x4
    3cde:	b5650513          	addi	a0,a0,-1194 # 7830 <malloc+0x1806>
    3ce2:	00002097          	auipc	ra,0x2
    3ce6:	28a080e7          	jalr	650(ra) # 5f6c <printf>
    exit(1);
    3cea:	4505                	li	a0,1
    3cec:	00002097          	auipc	ra,0x2
    3cf0:	f08080e7          	jalr	-248(ra) # 5bf4 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cf4:	85ca                	mv	a1,s2
    3cf6:	00004517          	auipc	a0,0x4
    3cfa:	b6250513          	addi	a0,a0,-1182 # 7858 <malloc+0x182e>
    3cfe:	00002097          	auipc	ra,0x2
    3d02:	26e080e7          	jalr	622(ra) # 5f6c <printf>
    exit(1);
    3d06:	4505                	li	a0,1
    3d08:	00002097          	auipc	ra,0x2
    3d0c:	eec080e7          	jalr	-276(ra) # 5bf4 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3d10:	85ca                	mv	a1,s2
    3d12:	00004517          	auipc	a0,0x4
    3d16:	b6e50513          	addi	a0,a0,-1170 # 7880 <malloc+0x1856>
    3d1a:	00002097          	auipc	ra,0x2
    3d1e:	252080e7          	jalr	594(ra) # 5f6c <printf>
    exit(1);
    3d22:	4505                	li	a0,1
    3d24:	00002097          	auipc	ra,0x2
    3d28:	ed0080e7          	jalr	-304(ra) # 5bf4 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d2c:	85ca                	mv	a1,s2
    3d2e:	00004517          	auipc	a0,0x4
    3d32:	b7a50513          	addi	a0,a0,-1158 # 78a8 <malloc+0x187e>
    3d36:	00002097          	auipc	ra,0x2
    3d3a:	236080e7          	jalr	566(ra) # 5f6c <printf>
    exit(1);
    3d3e:	4505                	li	a0,1
    3d40:	00002097          	auipc	ra,0x2
    3d44:	eb4080e7          	jalr	-332(ra) # 5bf4 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d48:	85ca                	mv	a1,s2
    3d4a:	00004517          	auipc	a0,0x4
    3d4e:	b7e50513          	addi	a0,a0,-1154 # 78c8 <malloc+0x189e>
    3d52:	00002097          	auipc	ra,0x2
    3d56:	21a080e7          	jalr	538(ra) # 5f6c <printf>
    exit(1);
    3d5a:	4505                	li	a0,1
    3d5c:	00002097          	auipc	ra,0x2
    3d60:	e98080e7          	jalr	-360(ra) # 5bf4 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d64:	85ca                	mv	a1,s2
    3d66:	00004517          	auipc	a0,0x4
    3d6a:	b8250513          	addi	a0,a0,-1150 # 78e8 <malloc+0x18be>
    3d6e:	00002097          	auipc	ra,0x2
    3d72:	1fe080e7          	jalr	510(ra) # 5f6c <printf>
    exit(1);
    3d76:	4505                	li	a0,1
    3d78:	00002097          	auipc	ra,0x2
    3d7c:	e7c080e7          	jalr	-388(ra) # 5bf4 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d80:	85ca                	mv	a1,s2
    3d82:	00004517          	auipc	a0,0x4
    3d86:	b8e50513          	addi	a0,a0,-1138 # 7910 <malloc+0x18e6>
    3d8a:	00002097          	auipc	ra,0x2
    3d8e:	1e2080e7          	jalr	482(ra) # 5f6c <printf>
    exit(1);
    3d92:	4505                	li	a0,1
    3d94:	00002097          	auipc	ra,0x2
    3d98:	e60080e7          	jalr	-416(ra) # 5bf4 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d9c:	85ca                	mv	a1,s2
    3d9e:	00004517          	auipc	a0,0x4
    3da2:	b9250513          	addi	a0,a0,-1134 # 7930 <malloc+0x1906>
    3da6:	00002097          	auipc	ra,0x2
    3daa:	1c6080e7          	jalr	454(ra) # 5f6c <printf>
    exit(1);
    3dae:	4505                	li	a0,1
    3db0:	00002097          	auipc	ra,0x2
    3db4:	e44080e7          	jalr	-444(ra) # 5bf4 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3db8:	85ca                	mv	a1,s2
    3dba:	00004517          	auipc	a0,0x4
    3dbe:	b9650513          	addi	a0,a0,-1130 # 7950 <malloc+0x1926>
    3dc2:	00002097          	auipc	ra,0x2
    3dc6:	1aa080e7          	jalr	426(ra) # 5f6c <printf>
    exit(1);
    3dca:	4505                	li	a0,1
    3dcc:	00002097          	auipc	ra,0x2
    3dd0:	e28080e7          	jalr	-472(ra) # 5bf4 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3dd4:	85ca                	mv	a1,s2
    3dd6:	00004517          	auipc	a0,0x4
    3dda:	ba250513          	addi	a0,a0,-1118 # 7978 <malloc+0x194e>
    3dde:	00002097          	auipc	ra,0x2
    3de2:	18e080e7          	jalr	398(ra) # 5f6c <printf>
    exit(1);
    3de6:	4505                	li	a0,1
    3de8:	00002097          	auipc	ra,0x2
    3dec:	e0c080e7          	jalr	-500(ra) # 5bf4 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3df0:	85ca                	mv	a1,s2
    3df2:	00004517          	auipc	a0,0x4
    3df6:	81e50513          	addi	a0,a0,-2018 # 7610 <malloc+0x15e6>
    3dfa:	00002097          	auipc	ra,0x2
    3dfe:	172080e7          	jalr	370(ra) # 5f6c <printf>
    exit(1);
    3e02:	4505                	li	a0,1
    3e04:	00002097          	auipc	ra,0x2
    3e08:	df0080e7          	jalr	-528(ra) # 5bf4 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3e0c:	85ca                	mv	a1,s2
    3e0e:	00004517          	auipc	a0,0x4
    3e12:	b8a50513          	addi	a0,a0,-1142 # 7998 <malloc+0x196e>
    3e16:	00002097          	auipc	ra,0x2
    3e1a:	156080e7          	jalr	342(ra) # 5f6c <printf>
    exit(1);
    3e1e:	4505                	li	a0,1
    3e20:	00002097          	auipc	ra,0x2
    3e24:	dd4080e7          	jalr	-556(ra) # 5bf4 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e28:	85ca                	mv	a1,s2
    3e2a:	00004517          	auipc	a0,0x4
    3e2e:	b8e50513          	addi	a0,a0,-1138 # 79b8 <malloc+0x198e>
    3e32:	00002097          	auipc	ra,0x2
    3e36:	13a080e7          	jalr	314(ra) # 5f6c <printf>
    exit(1);
    3e3a:	4505                	li	a0,1
    3e3c:	00002097          	auipc	ra,0x2
    3e40:	db8080e7          	jalr	-584(ra) # 5bf4 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e44:	85ca                	mv	a1,s2
    3e46:	00004517          	auipc	a0,0x4
    3e4a:	ba250513          	addi	a0,a0,-1118 # 79e8 <malloc+0x19be>
    3e4e:	00002097          	auipc	ra,0x2
    3e52:	11e080e7          	jalr	286(ra) # 5f6c <printf>
    exit(1);
    3e56:	4505                	li	a0,1
    3e58:	00002097          	auipc	ra,0x2
    3e5c:	d9c080e7          	jalr	-612(ra) # 5bf4 <exit>
    printf("%s: unlink dd failed\n", s);
    3e60:	85ca                	mv	a1,s2
    3e62:	00004517          	auipc	a0,0x4
    3e66:	ba650513          	addi	a0,a0,-1114 # 7a08 <malloc+0x19de>
    3e6a:	00002097          	auipc	ra,0x2
    3e6e:	102080e7          	jalr	258(ra) # 5f6c <printf>
    exit(1);
    3e72:	4505                	li	a0,1
    3e74:	00002097          	auipc	ra,0x2
    3e78:	d80080e7          	jalr	-640(ra) # 5bf4 <exit>

0000000000003e7c <rmdot>:
{
    3e7c:	1101                	addi	sp,sp,-32
    3e7e:	ec06                	sd	ra,24(sp)
    3e80:	e822                	sd	s0,16(sp)
    3e82:	e426                	sd	s1,8(sp)
    3e84:	1000                	addi	s0,sp,32
    3e86:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3e88:	00004517          	auipc	a0,0x4
    3e8c:	b9850513          	addi	a0,a0,-1128 # 7a20 <malloc+0x19f6>
    3e90:	00002097          	auipc	ra,0x2
    3e94:	dcc080e7          	jalr	-564(ra) # 5c5c <mkdir>
    3e98:	e549                	bnez	a0,3f22 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3e9a:	00004517          	auipc	a0,0x4
    3e9e:	b8650513          	addi	a0,a0,-1146 # 7a20 <malloc+0x19f6>
    3ea2:	00002097          	auipc	ra,0x2
    3ea6:	dc2080e7          	jalr	-574(ra) # 5c64 <chdir>
    3eaa:	e951                	bnez	a0,3f3e <rmdot+0xc2>
  if(unlink(".") == 0){
    3eac:	00003517          	auipc	a0,0x3
    3eb0:	9a450513          	addi	a0,a0,-1628 # 6850 <malloc+0x826>
    3eb4:	00002097          	auipc	ra,0x2
    3eb8:	d90080e7          	jalr	-624(ra) # 5c44 <unlink>
    3ebc:	cd59                	beqz	a0,3f5a <rmdot+0xde>
  if(unlink("..") == 0){
    3ebe:	00003517          	auipc	a0,0x3
    3ec2:	5ba50513          	addi	a0,a0,1466 # 7478 <malloc+0x144e>
    3ec6:	00002097          	auipc	ra,0x2
    3eca:	d7e080e7          	jalr	-642(ra) # 5c44 <unlink>
    3ece:	c545                	beqz	a0,3f76 <rmdot+0xfa>
  if(chdir("/") != 0){
    3ed0:	00003517          	auipc	a0,0x3
    3ed4:	55050513          	addi	a0,a0,1360 # 7420 <malloc+0x13f6>
    3ed8:	00002097          	auipc	ra,0x2
    3edc:	d8c080e7          	jalr	-628(ra) # 5c64 <chdir>
    3ee0:	e94d                	bnez	a0,3f92 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3ee2:	00004517          	auipc	a0,0x4
    3ee6:	ba650513          	addi	a0,a0,-1114 # 7a88 <malloc+0x1a5e>
    3eea:	00002097          	auipc	ra,0x2
    3eee:	d5a080e7          	jalr	-678(ra) # 5c44 <unlink>
    3ef2:	cd55                	beqz	a0,3fae <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3ef4:	00004517          	auipc	a0,0x4
    3ef8:	bbc50513          	addi	a0,a0,-1092 # 7ab0 <malloc+0x1a86>
    3efc:	00002097          	auipc	ra,0x2
    3f00:	d48080e7          	jalr	-696(ra) # 5c44 <unlink>
    3f04:	c179                	beqz	a0,3fca <rmdot+0x14e>
  if(unlink("dots") != 0){
    3f06:	00004517          	auipc	a0,0x4
    3f0a:	b1a50513          	addi	a0,a0,-1254 # 7a20 <malloc+0x19f6>
    3f0e:	00002097          	auipc	ra,0x2
    3f12:	d36080e7          	jalr	-714(ra) # 5c44 <unlink>
    3f16:	e961                	bnez	a0,3fe6 <rmdot+0x16a>
}
    3f18:	60e2                	ld	ra,24(sp)
    3f1a:	6442                	ld	s0,16(sp)
    3f1c:	64a2                	ld	s1,8(sp)
    3f1e:	6105                	addi	sp,sp,32
    3f20:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f22:	85a6                	mv	a1,s1
    3f24:	00004517          	auipc	a0,0x4
    3f28:	b0450513          	addi	a0,a0,-1276 # 7a28 <malloc+0x19fe>
    3f2c:	00002097          	auipc	ra,0x2
    3f30:	040080e7          	jalr	64(ra) # 5f6c <printf>
    exit(1);
    3f34:	4505                	li	a0,1
    3f36:	00002097          	auipc	ra,0x2
    3f3a:	cbe080e7          	jalr	-834(ra) # 5bf4 <exit>
    printf("%s: chdir dots failed\n", s);
    3f3e:	85a6                	mv	a1,s1
    3f40:	00004517          	auipc	a0,0x4
    3f44:	b0050513          	addi	a0,a0,-1280 # 7a40 <malloc+0x1a16>
    3f48:	00002097          	auipc	ra,0x2
    3f4c:	024080e7          	jalr	36(ra) # 5f6c <printf>
    exit(1);
    3f50:	4505                	li	a0,1
    3f52:	00002097          	auipc	ra,0x2
    3f56:	ca2080e7          	jalr	-862(ra) # 5bf4 <exit>
    printf("%s: rm . worked!\n", s);
    3f5a:	85a6                	mv	a1,s1
    3f5c:	00004517          	auipc	a0,0x4
    3f60:	afc50513          	addi	a0,a0,-1284 # 7a58 <malloc+0x1a2e>
    3f64:	00002097          	auipc	ra,0x2
    3f68:	008080e7          	jalr	8(ra) # 5f6c <printf>
    exit(1);
    3f6c:	4505                	li	a0,1
    3f6e:	00002097          	auipc	ra,0x2
    3f72:	c86080e7          	jalr	-890(ra) # 5bf4 <exit>
    printf("%s: rm .. worked!\n", s);
    3f76:	85a6                	mv	a1,s1
    3f78:	00004517          	auipc	a0,0x4
    3f7c:	af850513          	addi	a0,a0,-1288 # 7a70 <malloc+0x1a46>
    3f80:	00002097          	auipc	ra,0x2
    3f84:	fec080e7          	jalr	-20(ra) # 5f6c <printf>
    exit(1);
    3f88:	4505                	li	a0,1
    3f8a:	00002097          	auipc	ra,0x2
    3f8e:	c6a080e7          	jalr	-918(ra) # 5bf4 <exit>
    printf("%s: chdir / failed\n", s);
    3f92:	85a6                	mv	a1,s1
    3f94:	00003517          	auipc	a0,0x3
    3f98:	49450513          	addi	a0,a0,1172 # 7428 <malloc+0x13fe>
    3f9c:	00002097          	auipc	ra,0x2
    3fa0:	fd0080e7          	jalr	-48(ra) # 5f6c <printf>
    exit(1);
    3fa4:	4505                	li	a0,1
    3fa6:	00002097          	auipc	ra,0x2
    3faa:	c4e080e7          	jalr	-946(ra) # 5bf4 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3fae:	85a6                	mv	a1,s1
    3fb0:	00004517          	auipc	a0,0x4
    3fb4:	ae050513          	addi	a0,a0,-1312 # 7a90 <malloc+0x1a66>
    3fb8:	00002097          	auipc	ra,0x2
    3fbc:	fb4080e7          	jalr	-76(ra) # 5f6c <printf>
    exit(1);
    3fc0:	4505                	li	a0,1
    3fc2:	00002097          	auipc	ra,0x2
    3fc6:	c32080e7          	jalr	-974(ra) # 5bf4 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3fca:	85a6                	mv	a1,s1
    3fcc:	00004517          	auipc	a0,0x4
    3fd0:	aec50513          	addi	a0,a0,-1300 # 7ab8 <malloc+0x1a8e>
    3fd4:	00002097          	auipc	ra,0x2
    3fd8:	f98080e7          	jalr	-104(ra) # 5f6c <printf>
    exit(1);
    3fdc:	4505                	li	a0,1
    3fde:	00002097          	auipc	ra,0x2
    3fe2:	c16080e7          	jalr	-1002(ra) # 5bf4 <exit>
    printf("%s: unlink dots failed!\n", s);
    3fe6:	85a6                	mv	a1,s1
    3fe8:	00004517          	auipc	a0,0x4
    3fec:	af050513          	addi	a0,a0,-1296 # 7ad8 <malloc+0x1aae>
    3ff0:	00002097          	auipc	ra,0x2
    3ff4:	f7c080e7          	jalr	-132(ra) # 5f6c <printf>
    exit(1);
    3ff8:	4505                	li	a0,1
    3ffa:	00002097          	auipc	ra,0x2
    3ffe:	bfa080e7          	jalr	-1030(ra) # 5bf4 <exit>

0000000000004002 <dirfile>:
{
    4002:	1101                	addi	sp,sp,-32
    4004:	ec06                	sd	ra,24(sp)
    4006:	e822                	sd	s0,16(sp)
    4008:	e426                	sd	s1,8(sp)
    400a:	e04a                	sd	s2,0(sp)
    400c:	1000                	addi	s0,sp,32
    400e:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4010:	20000593          	li	a1,512
    4014:	00004517          	auipc	a0,0x4
    4018:	ae450513          	addi	a0,a0,-1308 # 7af8 <malloc+0x1ace>
    401c:	00002097          	auipc	ra,0x2
    4020:	c18080e7          	jalr	-1000(ra) # 5c34 <open>
  if(fd < 0){
    4024:	0e054d63          	bltz	a0,411e <dirfile+0x11c>
  close(fd);
    4028:	00002097          	auipc	ra,0x2
    402c:	bf4080e7          	jalr	-1036(ra) # 5c1c <close>
  if(chdir("dirfile") == 0){
    4030:	00004517          	auipc	a0,0x4
    4034:	ac850513          	addi	a0,a0,-1336 # 7af8 <malloc+0x1ace>
    4038:	00002097          	auipc	ra,0x2
    403c:	c2c080e7          	jalr	-980(ra) # 5c64 <chdir>
    4040:	cd6d                	beqz	a0,413a <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    4042:	4581                	li	a1,0
    4044:	00004517          	auipc	a0,0x4
    4048:	afc50513          	addi	a0,a0,-1284 # 7b40 <malloc+0x1b16>
    404c:	00002097          	auipc	ra,0x2
    4050:	be8080e7          	jalr	-1048(ra) # 5c34 <open>
  if(fd >= 0){
    4054:	10055163          	bgez	a0,4156 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    4058:	20000593          	li	a1,512
    405c:	00004517          	auipc	a0,0x4
    4060:	ae450513          	addi	a0,a0,-1308 # 7b40 <malloc+0x1b16>
    4064:	00002097          	auipc	ra,0x2
    4068:	bd0080e7          	jalr	-1072(ra) # 5c34 <open>
  if(fd >= 0){
    406c:	10055363          	bgez	a0,4172 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    4070:	00004517          	auipc	a0,0x4
    4074:	ad050513          	addi	a0,a0,-1328 # 7b40 <malloc+0x1b16>
    4078:	00002097          	auipc	ra,0x2
    407c:	be4080e7          	jalr	-1052(ra) # 5c5c <mkdir>
    4080:	10050763          	beqz	a0,418e <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    4084:	00004517          	auipc	a0,0x4
    4088:	abc50513          	addi	a0,a0,-1348 # 7b40 <malloc+0x1b16>
    408c:	00002097          	auipc	ra,0x2
    4090:	bb8080e7          	jalr	-1096(ra) # 5c44 <unlink>
    4094:	10050b63          	beqz	a0,41aa <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    4098:	00004597          	auipc	a1,0x4
    409c:	aa858593          	addi	a1,a1,-1368 # 7b40 <malloc+0x1b16>
    40a0:	00002517          	auipc	a0,0x2
    40a4:	2a050513          	addi	a0,a0,672 # 6340 <malloc+0x316>
    40a8:	00002097          	auipc	ra,0x2
    40ac:	bac080e7          	jalr	-1108(ra) # 5c54 <link>
    40b0:	10050b63          	beqz	a0,41c6 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    40b4:	00004517          	auipc	a0,0x4
    40b8:	a4450513          	addi	a0,a0,-1468 # 7af8 <malloc+0x1ace>
    40bc:	00002097          	auipc	ra,0x2
    40c0:	b88080e7          	jalr	-1144(ra) # 5c44 <unlink>
    40c4:	10051f63          	bnez	a0,41e2 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    40c8:	4589                	li	a1,2
    40ca:	00002517          	auipc	a0,0x2
    40ce:	78650513          	addi	a0,a0,1926 # 6850 <malloc+0x826>
    40d2:	00002097          	auipc	ra,0x2
    40d6:	b62080e7          	jalr	-1182(ra) # 5c34 <open>
  if(fd >= 0){
    40da:	12055263          	bgez	a0,41fe <dirfile+0x1fc>
  fd = open(".", 0);
    40de:	4581                	li	a1,0
    40e0:	00002517          	auipc	a0,0x2
    40e4:	77050513          	addi	a0,a0,1904 # 6850 <malloc+0x826>
    40e8:	00002097          	auipc	ra,0x2
    40ec:	b4c080e7          	jalr	-1204(ra) # 5c34 <open>
    40f0:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    40f2:	4605                	li	a2,1
    40f4:	00002597          	auipc	a1,0x2
    40f8:	0e458593          	addi	a1,a1,228 # 61d8 <malloc+0x1ae>
    40fc:	00002097          	auipc	ra,0x2
    4100:	b18080e7          	jalr	-1256(ra) # 5c14 <write>
    4104:	10a04b63          	bgtz	a0,421a <dirfile+0x218>
  close(fd);
    4108:	8526                	mv	a0,s1
    410a:	00002097          	auipc	ra,0x2
    410e:	b12080e7          	jalr	-1262(ra) # 5c1c <close>
}
    4112:	60e2                	ld	ra,24(sp)
    4114:	6442                	ld	s0,16(sp)
    4116:	64a2                	ld	s1,8(sp)
    4118:	6902                	ld	s2,0(sp)
    411a:	6105                	addi	sp,sp,32
    411c:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    411e:	85ca                	mv	a1,s2
    4120:	00004517          	auipc	a0,0x4
    4124:	9e050513          	addi	a0,a0,-1568 # 7b00 <malloc+0x1ad6>
    4128:	00002097          	auipc	ra,0x2
    412c:	e44080e7          	jalr	-444(ra) # 5f6c <printf>
    exit(1);
    4130:	4505                	li	a0,1
    4132:	00002097          	auipc	ra,0x2
    4136:	ac2080e7          	jalr	-1342(ra) # 5bf4 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    413a:	85ca                	mv	a1,s2
    413c:	00004517          	auipc	a0,0x4
    4140:	9e450513          	addi	a0,a0,-1564 # 7b20 <malloc+0x1af6>
    4144:	00002097          	auipc	ra,0x2
    4148:	e28080e7          	jalr	-472(ra) # 5f6c <printf>
    exit(1);
    414c:	4505                	li	a0,1
    414e:	00002097          	auipc	ra,0x2
    4152:	aa6080e7          	jalr	-1370(ra) # 5bf4 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4156:	85ca                	mv	a1,s2
    4158:	00004517          	auipc	a0,0x4
    415c:	9f850513          	addi	a0,a0,-1544 # 7b50 <malloc+0x1b26>
    4160:	00002097          	auipc	ra,0x2
    4164:	e0c080e7          	jalr	-500(ra) # 5f6c <printf>
    exit(1);
    4168:	4505                	li	a0,1
    416a:	00002097          	auipc	ra,0x2
    416e:	a8a080e7          	jalr	-1398(ra) # 5bf4 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4172:	85ca                	mv	a1,s2
    4174:	00004517          	auipc	a0,0x4
    4178:	9dc50513          	addi	a0,a0,-1572 # 7b50 <malloc+0x1b26>
    417c:	00002097          	auipc	ra,0x2
    4180:	df0080e7          	jalr	-528(ra) # 5f6c <printf>
    exit(1);
    4184:	4505                	li	a0,1
    4186:	00002097          	auipc	ra,0x2
    418a:	a6e080e7          	jalr	-1426(ra) # 5bf4 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    418e:	85ca                	mv	a1,s2
    4190:	00004517          	auipc	a0,0x4
    4194:	9e850513          	addi	a0,a0,-1560 # 7b78 <malloc+0x1b4e>
    4198:	00002097          	auipc	ra,0x2
    419c:	dd4080e7          	jalr	-556(ra) # 5f6c <printf>
    exit(1);
    41a0:	4505                	li	a0,1
    41a2:	00002097          	auipc	ra,0x2
    41a6:	a52080e7          	jalr	-1454(ra) # 5bf4 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    41aa:	85ca                	mv	a1,s2
    41ac:	00004517          	auipc	a0,0x4
    41b0:	9f450513          	addi	a0,a0,-1548 # 7ba0 <malloc+0x1b76>
    41b4:	00002097          	auipc	ra,0x2
    41b8:	db8080e7          	jalr	-584(ra) # 5f6c <printf>
    exit(1);
    41bc:	4505                	li	a0,1
    41be:	00002097          	auipc	ra,0x2
    41c2:	a36080e7          	jalr	-1482(ra) # 5bf4 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    41c6:	85ca                	mv	a1,s2
    41c8:	00004517          	auipc	a0,0x4
    41cc:	a0050513          	addi	a0,a0,-1536 # 7bc8 <malloc+0x1b9e>
    41d0:	00002097          	auipc	ra,0x2
    41d4:	d9c080e7          	jalr	-612(ra) # 5f6c <printf>
    exit(1);
    41d8:	4505                	li	a0,1
    41da:	00002097          	auipc	ra,0x2
    41de:	a1a080e7          	jalr	-1510(ra) # 5bf4 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41e2:	85ca                	mv	a1,s2
    41e4:	00004517          	auipc	a0,0x4
    41e8:	a0c50513          	addi	a0,a0,-1524 # 7bf0 <malloc+0x1bc6>
    41ec:	00002097          	auipc	ra,0x2
    41f0:	d80080e7          	jalr	-640(ra) # 5f6c <printf>
    exit(1);
    41f4:	4505                	li	a0,1
    41f6:	00002097          	auipc	ra,0x2
    41fa:	9fe080e7          	jalr	-1538(ra) # 5bf4 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    41fe:	85ca                	mv	a1,s2
    4200:	00004517          	auipc	a0,0x4
    4204:	a1050513          	addi	a0,a0,-1520 # 7c10 <malloc+0x1be6>
    4208:	00002097          	auipc	ra,0x2
    420c:	d64080e7          	jalr	-668(ra) # 5f6c <printf>
    exit(1);
    4210:	4505                	li	a0,1
    4212:	00002097          	auipc	ra,0x2
    4216:	9e2080e7          	jalr	-1566(ra) # 5bf4 <exit>
    printf("%s: write . succeeded!\n", s);
    421a:	85ca                	mv	a1,s2
    421c:	00004517          	auipc	a0,0x4
    4220:	a1c50513          	addi	a0,a0,-1508 # 7c38 <malloc+0x1c0e>
    4224:	00002097          	auipc	ra,0x2
    4228:	d48080e7          	jalr	-696(ra) # 5f6c <printf>
    exit(1);
    422c:	4505                	li	a0,1
    422e:	00002097          	auipc	ra,0x2
    4232:	9c6080e7          	jalr	-1594(ra) # 5bf4 <exit>

0000000000004236 <iref>:
{
    4236:	7139                	addi	sp,sp,-64
    4238:	fc06                	sd	ra,56(sp)
    423a:	f822                	sd	s0,48(sp)
    423c:	f426                	sd	s1,40(sp)
    423e:	f04a                	sd	s2,32(sp)
    4240:	ec4e                	sd	s3,24(sp)
    4242:	e852                	sd	s4,16(sp)
    4244:	e456                	sd	s5,8(sp)
    4246:	e05a                	sd	s6,0(sp)
    4248:	0080                	addi	s0,sp,64
    424a:	8b2a                	mv	s6,a0
    424c:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4250:	00004a17          	auipc	s4,0x4
    4254:	a00a0a13          	addi	s4,s4,-1536 # 7c50 <malloc+0x1c26>
    mkdir("");
    4258:	00003497          	auipc	s1,0x3
    425c:	50048493          	addi	s1,s1,1280 # 7758 <malloc+0x172e>
    link("README", "");
    4260:	00002a97          	auipc	s5,0x2
    4264:	0e0a8a93          	addi	s5,s5,224 # 6340 <malloc+0x316>
    fd = open("xx", O_CREATE);
    4268:	00004997          	auipc	s3,0x4
    426c:	8e098993          	addi	s3,s3,-1824 # 7b48 <malloc+0x1b1e>
    4270:	a891                	j	42c4 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    4272:	85da                	mv	a1,s6
    4274:	00004517          	auipc	a0,0x4
    4278:	9e450513          	addi	a0,a0,-1564 # 7c58 <malloc+0x1c2e>
    427c:	00002097          	auipc	ra,0x2
    4280:	cf0080e7          	jalr	-784(ra) # 5f6c <printf>
      exit(1);
    4284:	4505                	li	a0,1
    4286:	00002097          	auipc	ra,0x2
    428a:	96e080e7          	jalr	-1682(ra) # 5bf4 <exit>
      printf("%s: chdir irefd failed\n", s);
    428e:	85da                	mv	a1,s6
    4290:	00004517          	auipc	a0,0x4
    4294:	9e050513          	addi	a0,a0,-1568 # 7c70 <malloc+0x1c46>
    4298:	00002097          	auipc	ra,0x2
    429c:	cd4080e7          	jalr	-812(ra) # 5f6c <printf>
      exit(1);
    42a0:	4505                	li	a0,1
    42a2:	00002097          	auipc	ra,0x2
    42a6:	952080e7          	jalr	-1710(ra) # 5bf4 <exit>
      close(fd);
    42aa:	00002097          	auipc	ra,0x2
    42ae:	972080e7          	jalr	-1678(ra) # 5c1c <close>
    42b2:	a889                	j	4304 <iref+0xce>
    unlink("xx");
    42b4:	854e                	mv	a0,s3
    42b6:	00002097          	auipc	ra,0x2
    42ba:	98e080e7          	jalr	-1650(ra) # 5c44 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    42be:	397d                	addiw	s2,s2,-1
    42c0:	06090063          	beqz	s2,4320 <iref+0xea>
    if(mkdir("irefd") != 0){
    42c4:	8552                	mv	a0,s4
    42c6:	00002097          	auipc	ra,0x2
    42ca:	996080e7          	jalr	-1642(ra) # 5c5c <mkdir>
    42ce:	f155                	bnez	a0,4272 <iref+0x3c>
    if(chdir("irefd") != 0){
    42d0:	8552                	mv	a0,s4
    42d2:	00002097          	auipc	ra,0x2
    42d6:	992080e7          	jalr	-1646(ra) # 5c64 <chdir>
    42da:	f955                	bnez	a0,428e <iref+0x58>
    mkdir("");
    42dc:	8526                	mv	a0,s1
    42de:	00002097          	auipc	ra,0x2
    42e2:	97e080e7          	jalr	-1666(ra) # 5c5c <mkdir>
    link("README", "");
    42e6:	85a6                	mv	a1,s1
    42e8:	8556                	mv	a0,s5
    42ea:	00002097          	auipc	ra,0x2
    42ee:	96a080e7          	jalr	-1686(ra) # 5c54 <link>
    fd = open("", O_CREATE);
    42f2:	20000593          	li	a1,512
    42f6:	8526                	mv	a0,s1
    42f8:	00002097          	auipc	ra,0x2
    42fc:	93c080e7          	jalr	-1732(ra) # 5c34 <open>
    if(fd >= 0)
    4300:	fa0555e3          	bgez	a0,42aa <iref+0x74>
    fd = open("xx", O_CREATE);
    4304:	20000593          	li	a1,512
    4308:	854e                	mv	a0,s3
    430a:	00002097          	auipc	ra,0x2
    430e:	92a080e7          	jalr	-1750(ra) # 5c34 <open>
    if(fd >= 0)
    4312:	fa0541e3          	bltz	a0,42b4 <iref+0x7e>
      close(fd);
    4316:	00002097          	auipc	ra,0x2
    431a:	906080e7          	jalr	-1786(ra) # 5c1c <close>
    431e:	bf59                	j	42b4 <iref+0x7e>
    4320:	03300493          	li	s1,51
    chdir("..");
    4324:	00003997          	auipc	s3,0x3
    4328:	15498993          	addi	s3,s3,340 # 7478 <malloc+0x144e>
    unlink("irefd");
    432c:	00004917          	auipc	s2,0x4
    4330:	92490913          	addi	s2,s2,-1756 # 7c50 <malloc+0x1c26>
    chdir("..");
    4334:	854e                	mv	a0,s3
    4336:	00002097          	auipc	ra,0x2
    433a:	92e080e7          	jalr	-1746(ra) # 5c64 <chdir>
    unlink("irefd");
    433e:	854a                	mv	a0,s2
    4340:	00002097          	auipc	ra,0x2
    4344:	904080e7          	jalr	-1788(ra) # 5c44 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4348:	34fd                	addiw	s1,s1,-1
    434a:	f4ed                	bnez	s1,4334 <iref+0xfe>
  chdir("/");
    434c:	00003517          	auipc	a0,0x3
    4350:	0d450513          	addi	a0,a0,212 # 7420 <malloc+0x13f6>
    4354:	00002097          	auipc	ra,0x2
    4358:	910080e7          	jalr	-1776(ra) # 5c64 <chdir>
}
    435c:	70e2                	ld	ra,56(sp)
    435e:	7442                	ld	s0,48(sp)
    4360:	74a2                	ld	s1,40(sp)
    4362:	7902                	ld	s2,32(sp)
    4364:	69e2                	ld	s3,24(sp)
    4366:	6a42                	ld	s4,16(sp)
    4368:	6aa2                	ld	s5,8(sp)
    436a:	6b02                	ld	s6,0(sp)
    436c:	6121                	addi	sp,sp,64
    436e:	8082                	ret

0000000000004370 <openiputtest>:
{
    4370:	7179                	addi	sp,sp,-48
    4372:	f406                	sd	ra,40(sp)
    4374:	f022                	sd	s0,32(sp)
    4376:	ec26                	sd	s1,24(sp)
    4378:	1800                	addi	s0,sp,48
    437a:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    437c:	00004517          	auipc	a0,0x4
    4380:	90c50513          	addi	a0,a0,-1780 # 7c88 <malloc+0x1c5e>
    4384:	00002097          	auipc	ra,0x2
    4388:	8d8080e7          	jalr	-1832(ra) # 5c5c <mkdir>
    438c:	04054263          	bltz	a0,43d0 <openiputtest+0x60>
  pid = fork();
    4390:	00002097          	auipc	ra,0x2
    4394:	85c080e7          	jalr	-1956(ra) # 5bec <fork>
  if(pid < 0){
    4398:	04054a63          	bltz	a0,43ec <openiputtest+0x7c>
  if(pid == 0){
    439c:	e93d                	bnez	a0,4412 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    439e:	4589                	li	a1,2
    43a0:	00004517          	auipc	a0,0x4
    43a4:	8e850513          	addi	a0,a0,-1816 # 7c88 <malloc+0x1c5e>
    43a8:	00002097          	auipc	ra,0x2
    43ac:	88c080e7          	jalr	-1908(ra) # 5c34 <open>
    if(fd >= 0){
    43b0:	04054c63          	bltz	a0,4408 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    43b4:	85a6                	mv	a1,s1
    43b6:	00004517          	auipc	a0,0x4
    43ba:	8f250513          	addi	a0,a0,-1806 # 7ca8 <malloc+0x1c7e>
    43be:	00002097          	auipc	ra,0x2
    43c2:	bae080e7          	jalr	-1106(ra) # 5f6c <printf>
      exit(1);
    43c6:	4505                	li	a0,1
    43c8:	00002097          	auipc	ra,0x2
    43cc:	82c080e7          	jalr	-2004(ra) # 5bf4 <exit>
    printf("%s: mkdir oidir failed\n", s);
    43d0:	85a6                	mv	a1,s1
    43d2:	00004517          	auipc	a0,0x4
    43d6:	8be50513          	addi	a0,a0,-1858 # 7c90 <malloc+0x1c66>
    43da:	00002097          	auipc	ra,0x2
    43de:	b92080e7          	jalr	-1134(ra) # 5f6c <printf>
    exit(1);
    43e2:	4505                	li	a0,1
    43e4:	00002097          	auipc	ra,0x2
    43e8:	810080e7          	jalr	-2032(ra) # 5bf4 <exit>
    printf("%s: fork failed\n", s);
    43ec:	85a6                	mv	a1,s1
    43ee:	00002517          	auipc	a0,0x2
    43f2:	60250513          	addi	a0,a0,1538 # 69f0 <malloc+0x9c6>
    43f6:	00002097          	auipc	ra,0x2
    43fa:	b76080e7          	jalr	-1162(ra) # 5f6c <printf>
    exit(1);
    43fe:	4505                	li	a0,1
    4400:	00001097          	auipc	ra,0x1
    4404:	7f4080e7          	jalr	2036(ra) # 5bf4 <exit>
    exit(0);
    4408:	4501                	li	a0,0
    440a:	00001097          	auipc	ra,0x1
    440e:	7ea080e7          	jalr	2026(ra) # 5bf4 <exit>
  sleep(1);
    4412:	4505                	li	a0,1
    4414:	00002097          	auipc	ra,0x2
    4418:	870080e7          	jalr	-1936(ra) # 5c84 <sleep>
  if(unlink("oidir") != 0){
    441c:	00004517          	auipc	a0,0x4
    4420:	86c50513          	addi	a0,a0,-1940 # 7c88 <malloc+0x1c5e>
    4424:	00002097          	auipc	ra,0x2
    4428:	820080e7          	jalr	-2016(ra) # 5c44 <unlink>
    442c:	cd19                	beqz	a0,444a <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    442e:	85a6                	mv	a1,s1
    4430:	00002517          	auipc	a0,0x2
    4434:	7b050513          	addi	a0,a0,1968 # 6be0 <malloc+0xbb6>
    4438:	00002097          	auipc	ra,0x2
    443c:	b34080e7          	jalr	-1228(ra) # 5f6c <printf>
    exit(1);
    4440:	4505                	li	a0,1
    4442:	00001097          	auipc	ra,0x1
    4446:	7b2080e7          	jalr	1970(ra) # 5bf4 <exit>
  wait(&xstatus);
    444a:	fdc40513          	addi	a0,s0,-36
    444e:	00001097          	auipc	ra,0x1
    4452:	7ae080e7          	jalr	1966(ra) # 5bfc <wait>
  exit(xstatus);
    4456:	fdc42503          	lw	a0,-36(s0)
    445a:	00001097          	auipc	ra,0x1
    445e:	79a080e7          	jalr	1946(ra) # 5bf4 <exit>

0000000000004462 <forkforkfork>:
{
    4462:	1101                	addi	sp,sp,-32
    4464:	ec06                	sd	ra,24(sp)
    4466:	e822                	sd	s0,16(sp)
    4468:	e426                	sd	s1,8(sp)
    446a:	1000                	addi	s0,sp,32
    446c:	84aa                	mv	s1,a0
  unlink("stopforking");
    446e:	00004517          	auipc	a0,0x4
    4472:	86250513          	addi	a0,a0,-1950 # 7cd0 <malloc+0x1ca6>
    4476:	00001097          	auipc	ra,0x1
    447a:	7ce080e7          	jalr	1998(ra) # 5c44 <unlink>
  int pid = fork();
    447e:	00001097          	auipc	ra,0x1
    4482:	76e080e7          	jalr	1902(ra) # 5bec <fork>
  if(pid < 0){
    4486:	04054563          	bltz	a0,44d0 <forkforkfork+0x6e>
  if(pid == 0){
    448a:	c12d                	beqz	a0,44ec <forkforkfork+0x8a>
  sleep(20); // two seconds
    448c:	4551                	li	a0,20
    448e:	00001097          	auipc	ra,0x1
    4492:	7f6080e7          	jalr	2038(ra) # 5c84 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4496:	20200593          	li	a1,514
    449a:	00004517          	auipc	a0,0x4
    449e:	83650513          	addi	a0,a0,-1994 # 7cd0 <malloc+0x1ca6>
    44a2:	00001097          	auipc	ra,0x1
    44a6:	792080e7          	jalr	1938(ra) # 5c34 <open>
    44aa:	00001097          	auipc	ra,0x1
    44ae:	772080e7          	jalr	1906(ra) # 5c1c <close>
  wait(0);
    44b2:	4501                	li	a0,0
    44b4:	00001097          	auipc	ra,0x1
    44b8:	748080e7          	jalr	1864(ra) # 5bfc <wait>
  sleep(10); // one second
    44bc:	4529                	li	a0,10
    44be:	00001097          	auipc	ra,0x1
    44c2:	7c6080e7          	jalr	1990(ra) # 5c84 <sleep>
}
    44c6:	60e2                	ld	ra,24(sp)
    44c8:	6442                	ld	s0,16(sp)
    44ca:	64a2                	ld	s1,8(sp)
    44cc:	6105                	addi	sp,sp,32
    44ce:	8082                	ret
    printf("%s: fork failed", s);
    44d0:	85a6                	mv	a1,s1
    44d2:	00002517          	auipc	a0,0x2
    44d6:	6de50513          	addi	a0,a0,1758 # 6bb0 <malloc+0xb86>
    44da:	00002097          	auipc	ra,0x2
    44de:	a92080e7          	jalr	-1390(ra) # 5f6c <printf>
    exit(1);
    44e2:	4505                	li	a0,1
    44e4:	00001097          	auipc	ra,0x1
    44e8:	710080e7          	jalr	1808(ra) # 5bf4 <exit>
      int fd = open("stopforking", 0);
    44ec:	00003497          	auipc	s1,0x3
    44f0:	7e448493          	addi	s1,s1,2020 # 7cd0 <malloc+0x1ca6>
    44f4:	4581                	li	a1,0
    44f6:	8526                	mv	a0,s1
    44f8:	00001097          	auipc	ra,0x1
    44fc:	73c080e7          	jalr	1852(ra) # 5c34 <open>
      if(fd >= 0){
    4500:	02055463          	bgez	a0,4528 <forkforkfork+0xc6>
      if(fork() < 0){
    4504:	00001097          	auipc	ra,0x1
    4508:	6e8080e7          	jalr	1768(ra) # 5bec <fork>
    450c:	fe0554e3          	bgez	a0,44f4 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    4510:	20200593          	li	a1,514
    4514:	8526                	mv	a0,s1
    4516:	00001097          	auipc	ra,0x1
    451a:	71e080e7          	jalr	1822(ra) # 5c34 <open>
    451e:	00001097          	auipc	ra,0x1
    4522:	6fe080e7          	jalr	1790(ra) # 5c1c <close>
    4526:	b7f9                	j	44f4 <forkforkfork+0x92>
        exit(0);
    4528:	4501                	li	a0,0
    452a:	00001097          	auipc	ra,0x1
    452e:	6ca080e7          	jalr	1738(ra) # 5bf4 <exit>

0000000000004532 <killstatus>:
{
    4532:	7139                	addi	sp,sp,-64
    4534:	fc06                	sd	ra,56(sp)
    4536:	f822                	sd	s0,48(sp)
    4538:	f426                	sd	s1,40(sp)
    453a:	f04a                	sd	s2,32(sp)
    453c:	ec4e                	sd	s3,24(sp)
    453e:	e852                	sd	s4,16(sp)
    4540:	0080                	addi	s0,sp,64
    4542:	8a2a                	mv	s4,a0
    4544:	06400913          	li	s2,100
    if(xst != -1) {
    4548:	59fd                	li	s3,-1
    int pid1 = fork();
    454a:	00001097          	auipc	ra,0x1
    454e:	6a2080e7          	jalr	1698(ra) # 5bec <fork>
    4552:	84aa                	mv	s1,a0
    if(pid1 < 0){
    4554:	02054f63          	bltz	a0,4592 <killstatus+0x60>
    if(pid1 == 0){
    4558:	c939                	beqz	a0,45ae <killstatus+0x7c>
    sleep(1);
    455a:	4505                	li	a0,1
    455c:	00001097          	auipc	ra,0x1
    4560:	728080e7          	jalr	1832(ra) # 5c84 <sleep>
    kill(pid1);
    4564:	8526                	mv	a0,s1
    4566:	00001097          	auipc	ra,0x1
    456a:	6be080e7          	jalr	1726(ra) # 5c24 <kill>
    wait(&xst);
    456e:	fcc40513          	addi	a0,s0,-52
    4572:	00001097          	auipc	ra,0x1
    4576:	68a080e7          	jalr	1674(ra) # 5bfc <wait>
    if(xst != -1) {
    457a:	fcc42783          	lw	a5,-52(s0)
    457e:	03379d63          	bne	a5,s3,45b8 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    4582:	397d                	addiw	s2,s2,-1
    4584:	fc0913e3          	bnez	s2,454a <killstatus+0x18>
  exit(0);
    4588:	4501                	li	a0,0
    458a:	00001097          	auipc	ra,0x1
    458e:	66a080e7          	jalr	1642(ra) # 5bf4 <exit>
      printf("%s: fork failed\n", s);
    4592:	85d2                	mv	a1,s4
    4594:	00002517          	auipc	a0,0x2
    4598:	45c50513          	addi	a0,a0,1116 # 69f0 <malloc+0x9c6>
    459c:	00002097          	auipc	ra,0x2
    45a0:	9d0080e7          	jalr	-1584(ra) # 5f6c <printf>
      exit(1);
    45a4:	4505                	li	a0,1
    45a6:	00001097          	auipc	ra,0x1
    45aa:	64e080e7          	jalr	1614(ra) # 5bf4 <exit>
        getpid();
    45ae:	00001097          	auipc	ra,0x1
    45b2:	6c6080e7          	jalr	1734(ra) # 5c74 <getpid>
      while(1) {
    45b6:	bfe5                	j	45ae <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    45b8:	85d2                	mv	a1,s4
    45ba:	00003517          	auipc	a0,0x3
    45be:	72650513          	addi	a0,a0,1830 # 7ce0 <malloc+0x1cb6>
    45c2:	00002097          	auipc	ra,0x2
    45c6:	9aa080e7          	jalr	-1622(ra) # 5f6c <printf>
       exit(1);
    45ca:	4505                	li	a0,1
    45cc:	00001097          	auipc	ra,0x1
    45d0:	628080e7          	jalr	1576(ra) # 5bf4 <exit>

00000000000045d4 <preempt>:
{
    45d4:	7139                	addi	sp,sp,-64
    45d6:	fc06                	sd	ra,56(sp)
    45d8:	f822                	sd	s0,48(sp)
    45da:	f426                	sd	s1,40(sp)
    45dc:	f04a                	sd	s2,32(sp)
    45de:	ec4e                	sd	s3,24(sp)
    45e0:	e852                	sd	s4,16(sp)
    45e2:	0080                	addi	s0,sp,64
    45e4:	892a                	mv	s2,a0
  pid1 = fork();
    45e6:	00001097          	auipc	ra,0x1
    45ea:	606080e7          	jalr	1542(ra) # 5bec <fork>
  if(pid1 < 0) {
    45ee:	00054563          	bltz	a0,45f8 <preempt+0x24>
    45f2:	84aa                	mv	s1,a0
  if(pid1 == 0)
    45f4:	e105                	bnez	a0,4614 <preempt+0x40>
    for(;;)
    45f6:	a001                	j	45f6 <preempt+0x22>
    printf("%s: fork failed", s);
    45f8:	85ca                	mv	a1,s2
    45fa:	00002517          	auipc	a0,0x2
    45fe:	5b650513          	addi	a0,a0,1462 # 6bb0 <malloc+0xb86>
    4602:	00002097          	auipc	ra,0x2
    4606:	96a080e7          	jalr	-1686(ra) # 5f6c <printf>
    exit(1);
    460a:	4505                	li	a0,1
    460c:	00001097          	auipc	ra,0x1
    4610:	5e8080e7          	jalr	1512(ra) # 5bf4 <exit>
  pid2 = fork();
    4614:	00001097          	auipc	ra,0x1
    4618:	5d8080e7          	jalr	1496(ra) # 5bec <fork>
    461c:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    461e:	00054463          	bltz	a0,4626 <preempt+0x52>
  if(pid2 == 0)
    4622:	e105                	bnez	a0,4642 <preempt+0x6e>
    for(;;)
    4624:	a001                	j	4624 <preempt+0x50>
    printf("%s: fork failed\n", s);
    4626:	85ca                	mv	a1,s2
    4628:	00002517          	auipc	a0,0x2
    462c:	3c850513          	addi	a0,a0,968 # 69f0 <malloc+0x9c6>
    4630:	00002097          	auipc	ra,0x2
    4634:	93c080e7          	jalr	-1732(ra) # 5f6c <printf>
    exit(1);
    4638:	4505                	li	a0,1
    463a:	00001097          	auipc	ra,0x1
    463e:	5ba080e7          	jalr	1466(ra) # 5bf4 <exit>
  pipe(pfds);
    4642:	fc840513          	addi	a0,s0,-56
    4646:	00001097          	auipc	ra,0x1
    464a:	5be080e7          	jalr	1470(ra) # 5c04 <pipe>
  pid3 = fork();
    464e:	00001097          	auipc	ra,0x1
    4652:	59e080e7          	jalr	1438(ra) # 5bec <fork>
    4656:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4658:	02054e63          	bltz	a0,4694 <preempt+0xc0>
  if(pid3 == 0){
    465c:	e525                	bnez	a0,46c4 <preempt+0xf0>
    close(pfds[0]);
    465e:	fc842503          	lw	a0,-56(s0)
    4662:	00001097          	auipc	ra,0x1
    4666:	5ba080e7          	jalr	1466(ra) # 5c1c <close>
    if(write(pfds[1], "x", 1) != 1)
    466a:	4605                	li	a2,1
    466c:	00002597          	auipc	a1,0x2
    4670:	b6c58593          	addi	a1,a1,-1172 # 61d8 <malloc+0x1ae>
    4674:	fcc42503          	lw	a0,-52(s0)
    4678:	00001097          	auipc	ra,0x1
    467c:	59c080e7          	jalr	1436(ra) # 5c14 <write>
    4680:	4785                	li	a5,1
    4682:	02f51763          	bne	a0,a5,46b0 <preempt+0xdc>
    close(pfds[1]);
    4686:	fcc42503          	lw	a0,-52(s0)
    468a:	00001097          	auipc	ra,0x1
    468e:	592080e7          	jalr	1426(ra) # 5c1c <close>
    for(;;)
    4692:	a001                	j	4692 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4694:	85ca                	mv	a1,s2
    4696:	00002517          	auipc	a0,0x2
    469a:	35a50513          	addi	a0,a0,858 # 69f0 <malloc+0x9c6>
    469e:	00002097          	auipc	ra,0x2
    46a2:	8ce080e7          	jalr	-1842(ra) # 5f6c <printf>
     exit(1);
    46a6:	4505                	li	a0,1
    46a8:	00001097          	auipc	ra,0x1
    46ac:	54c080e7          	jalr	1356(ra) # 5bf4 <exit>
      printf("%s: preempt write error", s);
    46b0:	85ca                	mv	a1,s2
    46b2:	00003517          	auipc	a0,0x3
    46b6:	64e50513          	addi	a0,a0,1614 # 7d00 <malloc+0x1cd6>
    46ba:	00002097          	auipc	ra,0x2
    46be:	8b2080e7          	jalr	-1870(ra) # 5f6c <printf>
    46c2:	b7d1                	j	4686 <preempt+0xb2>
  close(pfds[1]);
    46c4:	fcc42503          	lw	a0,-52(s0)
    46c8:	00001097          	auipc	ra,0x1
    46cc:	554080e7          	jalr	1364(ra) # 5c1c <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    46d0:	660d                	lui	a2,0x3
    46d2:	00008597          	auipc	a1,0x8
    46d6:	5a658593          	addi	a1,a1,1446 # cc78 <buf>
    46da:	fc842503          	lw	a0,-56(s0)
    46de:	00001097          	auipc	ra,0x1
    46e2:	52e080e7          	jalr	1326(ra) # 5c0c <read>
    46e6:	4785                	li	a5,1
    46e8:	02f50363          	beq	a0,a5,470e <preempt+0x13a>
    printf("%s: preempt read error", s);
    46ec:	85ca                	mv	a1,s2
    46ee:	00003517          	auipc	a0,0x3
    46f2:	62a50513          	addi	a0,a0,1578 # 7d18 <malloc+0x1cee>
    46f6:	00002097          	auipc	ra,0x2
    46fa:	876080e7          	jalr	-1930(ra) # 5f6c <printf>
}
    46fe:	70e2                	ld	ra,56(sp)
    4700:	7442                	ld	s0,48(sp)
    4702:	74a2                	ld	s1,40(sp)
    4704:	7902                	ld	s2,32(sp)
    4706:	69e2                	ld	s3,24(sp)
    4708:	6a42                	ld	s4,16(sp)
    470a:	6121                	addi	sp,sp,64
    470c:	8082                	ret
  close(pfds[0]);
    470e:	fc842503          	lw	a0,-56(s0)
    4712:	00001097          	auipc	ra,0x1
    4716:	50a080e7          	jalr	1290(ra) # 5c1c <close>
  printf("kill... ");
    471a:	00003517          	auipc	a0,0x3
    471e:	61650513          	addi	a0,a0,1558 # 7d30 <malloc+0x1d06>
    4722:	00002097          	auipc	ra,0x2
    4726:	84a080e7          	jalr	-1974(ra) # 5f6c <printf>
  kill(pid1);
    472a:	8526                	mv	a0,s1
    472c:	00001097          	auipc	ra,0x1
    4730:	4f8080e7          	jalr	1272(ra) # 5c24 <kill>
  kill(pid2);
    4734:	854e                	mv	a0,s3
    4736:	00001097          	auipc	ra,0x1
    473a:	4ee080e7          	jalr	1262(ra) # 5c24 <kill>
  kill(pid3);
    473e:	8552                	mv	a0,s4
    4740:	00001097          	auipc	ra,0x1
    4744:	4e4080e7          	jalr	1252(ra) # 5c24 <kill>
  printf("wait... ");
    4748:	00003517          	auipc	a0,0x3
    474c:	5f850513          	addi	a0,a0,1528 # 7d40 <malloc+0x1d16>
    4750:	00002097          	auipc	ra,0x2
    4754:	81c080e7          	jalr	-2020(ra) # 5f6c <printf>
  wait(0);
    4758:	4501                	li	a0,0
    475a:	00001097          	auipc	ra,0x1
    475e:	4a2080e7          	jalr	1186(ra) # 5bfc <wait>
  wait(0);
    4762:	4501                	li	a0,0
    4764:	00001097          	auipc	ra,0x1
    4768:	498080e7          	jalr	1176(ra) # 5bfc <wait>
  wait(0);
    476c:	4501                	li	a0,0
    476e:	00001097          	auipc	ra,0x1
    4772:	48e080e7          	jalr	1166(ra) # 5bfc <wait>
    4776:	b761                	j	46fe <preempt+0x12a>

0000000000004778 <reparent>:
{
    4778:	7179                	addi	sp,sp,-48
    477a:	f406                	sd	ra,40(sp)
    477c:	f022                	sd	s0,32(sp)
    477e:	ec26                	sd	s1,24(sp)
    4780:	e84a                	sd	s2,16(sp)
    4782:	e44e                	sd	s3,8(sp)
    4784:	e052                	sd	s4,0(sp)
    4786:	1800                	addi	s0,sp,48
    4788:	89aa                	mv	s3,a0
  int master_pid = getpid();
    478a:	00001097          	auipc	ra,0x1
    478e:	4ea080e7          	jalr	1258(ra) # 5c74 <getpid>
    4792:	8a2a                	mv	s4,a0
    4794:	0c800913          	li	s2,200
    int pid = fork();
    4798:	00001097          	auipc	ra,0x1
    479c:	454080e7          	jalr	1108(ra) # 5bec <fork>
    47a0:	84aa                	mv	s1,a0
    if(pid < 0){
    47a2:	02054263          	bltz	a0,47c6 <reparent+0x4e>
    if(pid){
    47a6:	cd21                	beqz	a0,47fe <reparent+0x86>
      if(wait(0) != pid){
    47a8:	4501                	li	a0,0
    47aa:	00001097          	auipc	ra,0x1
    47ae:	452080e7          	jalr	1106(ra) # 5bfc <wait>
    47b2:	02951863          	bne	a0,s1,47e2 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    47b6:	397d                	addiw	s2,s2,-1
    47b8:	fe0910e3          	bnez	s2,4798 <reparent+0x20>
  exit(0);
    47bc:	4501                	li	a0,0
    47be:	00001097          	auipc	ra,0x1
    47c2:	436080e7          	jalr	1078(ra) # 5bf4 <exit>
      printf("%s: fork failed\n", s);
    47c6:	85ce                	mv	a1,s3
    47c8:	00002517          	auipc	a0,0x2
    47cc:	22850513          	addi	a0,a0,552 # 69f0 <malloc+0x9c6>
    47d0:	00001097          	auipc	ra,0x1
    47d4:	79c080e7          	jalr	1948(ra) # 5f6c <printf>
      exit(1);
    47d8:	4505                	li	a0,1
    47da:	00001097          	auipc	ra,0x1
    47de:	41a080e7          	jalr	1050(ra) # 5bf4 <exit>
        printf("%s: wait wrong pid\n", s);
    47e2:	85ce                	mv	a1,s3
    47e4:	00002517          	auipc	a0,0x2
    47e8:	39450513          	addi	a0,a0,916 # 6b78 <malloc+0xb4e>
    47ec:	00001097          	auipc	ra,0x1
    47f0:	780080e7          	jalr	1920(ra) # 5f6c <printf>
        exit(1);
    47f4:	4505                	li	a0,1
    47f6:	00001097          	auipc	ra,0x1
    47fa:	3fe080e7          	jalr	1022(ra) # 5bf4 <exit>
      int pid2 = fork();
    47fe:	00001097          	auipc	ra,0x1
    4802:	3ee080e7          	jalr	1006(ra) # 5bec <fork>
      if(pid2 < 0){
    4806:	00054763          	bltz	a0,4814 <reparent+0x9c>
      exit(0);
    480a:	4501                	li	a0,0
    480c:	00001097          	auipc	ra,0x1
    4810:	3e8080e7          	jalr	1000(ra) # 5bf4 <exit>
        kill(master_pid);
    4814:	8552                	mv	a0,s4
    4816:	00001097          	auipc	ra,0x1
    481a:	40e080e7          	jalr	1038(ra) # 5c24 <kill>
        exit(1);
    481e:	4505                	li	a0,1
    4820:	00001097          	auipc	ra,0x1
    4824:	3d4080e7          	jalr	980(ra) # 5bf4 <exit>

0000000000004828 <sbrkfail>:
{
    4828:	7119                	addi	sp,sp,-128
    482a:	fc86                	sd	ra,120(sp)
    482c:	f8a2                	sd	s0,112(sp)
    482e:	f4a6                	sd	s1,104(sp)
    4830:	f0ca                	sd	s2,96(sp)
    4832:	ecce                	sd	s3,88(sp)
    4834:	e8d2                	sd	s4,80(sp)
    4836:	e4d6                	sd	s5,72(sp)
    4838:	0100                	addi	s0,sp,128
    483a:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    483c:	fb040513          	addi	a0,s0,-80
    4840:	00001097          	auipc	ra,0x1
    4844:	3c4080e7          	jalr	964(ra) # 5c04 <pipe>
    4848:	e901                	bnez	a0,4858 <sbrkfail+0x30>
    484a:	f8040493          	addi	s1,s0,-128
    484e:	fa840993          	addi	s3,s0,-88
    4852:	8926                	mv	s2,s1
    if(pids[i] != -1)
    4854:	5a7d                	li	s4,-1
    4856:	a085                	j	48b6 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4858:	85d6                	mv	a1,s5
    485a:	00002517          	auipc	a0,0x2
    485e:	29e50513          	addi	a0,a0,670 # 6af8 <malloc+0xace>
    4862:	00001097          	auipc	ra,0x1
    4866:	70a080e7          	jalr	1802(ra) # 5f6c <printf>
    exit(1);
    486a:	4505                	li	a0,1
    486c:	00001097          	auipc	ra,0x1
    4870:	388080e7          	jalr	904(ra) # 5bf4 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4874:	00001097          	auipc	ra,0x1
    4878:	408080e7          	jalr	1032(ra) # 5c7c <sbrk>
    487c:	064007b7          	lui	a5,0x6400
    4880:	40a7853b          	subw	a0,a5,a0
    4884:	00001097          	auipc	ra,0x1
    4888:	3f8080e7          	jalr	1016(ra) # 5c7c <sbrk>
      write(fds[1], "x", 1);
    488c:	4605                	li	a2,1
    488e:	00002597          	auipc	a1,0x2
    4892:	94a58593          	addi	a1,a1,-1718 # 61d8 <malloc+0x1ae>
    4896:	fb442503          	lw	a0,-76(s0)
    489a:	00001097          	auipc	ra,0x1
    489e:	37a080e7          	jalr	890(ra) # 5c14 <write>
      for(;;) sleep(1000);
    48a2:	3e800513          	li	a0,1000
    48a6:	00001097          	auipc	ra,0x1
    48aa:	3de080e7          	jalr	990(ra) # 5c84 <sleep>
    48ae:	bfd5                	j	48a2 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48b0:	0911                	addi	s2,s2,4
    48b2:	03390563          	beq	s2,s3,48dc <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    48b6:	00001097          	auipc	ra,0x1
    48ba:	336080e7          	jalr	822(ra) # 5bec <fork>
    48be:	00a92023          	sw	a0,0(s2)
    48c2:	d94d                	beqz	a0,4874 <sbrkfail+0x4c>
    if(pids[i] != -1)
    48c4:	ff4506e3          	beq	a0,s4,48b0 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    48c8:	4605                	li	a2,1
    48ca:	faf40593          	addi	a1,s0,-81
    48ce:	fb042503          	lw	a0,-80(s0)
    48d2:	00001097          	auipc	ra,0x1
    48d6:	33a080e7          	jalr	826(ra) # 5c0c <read>
    48da:	bfd9                	j	48b0 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    48dc:	6505                	lui	a0,0x1
    48de:	00001097          	auipc	ra,0x1
    48e2:	39e080e7          	jalr	926(ra) # 5c7c <sbrk>
    48e6:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    48e8:	597d                	li	s2,-1
    48ea:	a021                	j	48f2 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48ec:	0491                	addi	s1,s1,4
    48ee:	01348f63          	beq	s1,s3,490c <sbrkfail+0xe4>
    if(pids[i] == -1)
    48f2:	4088                	lw	a0,0(s1)
    48f4:	ff250ce3          	beq	a0,s2,48ec <sbrkfail+0xc4>
    kill(pids[i]);
    48f8:	00001097          	auipc	ra,0x1
    48fc:	32c080e7          	jalr	812(ra) # 5c24 <kill>
    wait(0);
    4900:	4501                	li	a0,0
    4902:	00001097          	auipc	ra,0x1
    4906:	2fa080e7          	jalr	762(ra) # 5bfc <wait>
    490a:	b7cd                	j	48ec <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    490c:	57fd                	li	a5,-1
    490e:	04fa0163          	beq	s4,a5,4950 <sbrkfail+0x128>
  pid = fork();
    4912:	00001097          	auipc	ra,0x1
    4916:	2da080e7          	jalr	730(ra) # 5bec <fork>
    491a:	84aa                	mv	s1,a0
  if(pid < 0){
    491c:	04054863          	bltz	a0,496c <sbrkfail+0x144>
  if(pid == 0){
    4920:	c525                	beqz	a0,4988 <sbrkfail+0x160>
  wait(&xstatus);
    4922:	fbc40513          	addi	a0,s0,-68
    4926:	00001097          	auipc	ra,0x1
    492a:	2d6080e7          	jalr	726(ra) # 5bfc <wait>
  if(xstatus != -1 && xstatus != 2)
    492e:	fbc42783          	lw	a5,-68(s0)
    4932:	577d                	li	a4,-1
    4934:	00e78563          	beq	a5,a4,493e <sbrkfail+0x116>
    4938:	4709                	li	a4,2
    493a:	08e79d63          	bne	a5,a4,49d4 <sbrkfail+0x1ac>
}
    493e:	70e6                	ld	ra,120(sp)
    4940:	7446                	ld	s0,112(sp)
    4942:	74a6                	ld	s1,104(sp)
    4944:	7906                	ld	s2,96(sp)
    4946:	69e6                	ld	s3,88(sp)
    4948:	6a46                	ld	s4,80(sp)
    494a:	6aa6                	ld	s5,72(sp)
    494c:	6109                	addi	sp,sp,128
    494e:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4950:	85d6                	mv	a1,s5
    4952:	00003517          	auipc	a0,0x3
    4956:	3fe50513          	addi	a0,a0,1022 # 7d50 <malloc+0x1d26>
    495a:	00001097          	auipc	ra,0x1
    495e:	612080e7          	jalr	1554(ra) # 5f6c <printf>
    exit(1);
    4962:	4505                	li	a0,1
    4964:	00001097          	auipc	ra,0x1
    4968:	290080e7          	jalr	656(ra) # 5bf4 <exit>
    printf("%s: fork failed\n", s);
    496c:	85d6                	mv	a1,s5
    496e:	00002517          	auipc	a0,0x2
    4972:	08250513          	addi	a0,a0,130 # 69f0 <malloc+0x9c6>
    4976:	00001097          	auipc	ra,0x1
    497a:	5f6080e7          	jalr	1526(ra) # 5f6c <printf>
    exit(1);
    497e:	4505                	li	a0,1
    4980:	00001097          	auipc	ra,0x1
    4984:	274080e7          	jalr	628(ra) # 5bf4 <exit>
    a = sbrk(0);
    4988:	4501                	li	a0,0
    498a:	00001097          	auipc	ra,0x1
    498e:	2f2080e7          	jalr	754(ra) # 5c7c <sbrk>
    4992:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4994:	3e800537          	lui	a0,0x3e800
    4998:	00001097          	auipc	ra,0x1
    499c:	2e4080e7          	jalr	740(ra) # 5c7c <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49a0:	87ca                	mv	a5,s2
    49a2:	3e800737          	lui	a4,0x3e800
    49a6:	993a                	add	s2,s2,a4
    49a8:	6705                	lui	a4,0x1
      n += *(a+i);
    49aa:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    49ae:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49b0:	97ba                	add	a5,a5,a4
    49b2:	ff279ce3          	bne	a5,s2,49aa <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    49b6:	8626                	mv	a2,s1
    49b8:	85d6                	mv	a1,s5
    49ba:	00003517          	auipc	a0,0x3
    49be:	3b650513          	addi	a0,a0,950 # 7d70 <malloc+0x1d46>
    49c2:	00001097          	auipc	ra,0x1
    49c6:	5aa080e7          	jalr	1450(ra) # 5f6c <printf>
    exit(1);
    49ca:	4505                	li	a0,1
    49cc:	00001097          	auipc	ra,0x1
    49d0:	228080e7          	jalr	552(ra) # 5bf4 <exit>
    exit(1);
    49d4:	4505                	li	a0,1
    49d6:	00001097          	auipc	ra,0x1
    49da:	21e080e7          	jalr	542(ra) # 5bf4 <exit>

00000000000049de <mem>:
{
    49de:	7139                	addi	sp,sp,-64
    49e0:	fc06                	sd	ra,56(sp)
    49e2:	f822                	sd	s0,48(sp)
    49e4:	f426                	sd	s1,40(sp)
    49e6:	f04a                	sd	s2,32(sp)
    49e8:	ec4e                	sd	s3,24(sp)
    49ea:	0080                	addi	s0,sp,64
    49ec:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    49ee:	00001097          	auipc	ra,0x1
    49f2:	1fe080e7          	jalr	510(ra) # 5bec <fork>
    m1 = 0;
    49f6:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    49f8:	6909                	lui	s2,0x2
    49fa:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0xfb>
  if((pid = fork()) == 0){
    49fe:	c115                	beqz	a0,4a22 <mem+0x44>
    wait(&xstatus);
    4a00:	fcc40513          	addi	a0,s0,-52
    4a04:	00001097          	auipc	ra,0x1
    4a08:	1f8080e7          	jalr	504(ra) # 5bfc <wait>
    if(xstatus == -1){
    4a0c:	fcc42503          	lw	a0,-52(s0)
    4a10:	57fd                	li	a5,-1
    4a12:	06f50363          	beq	a0,a5,4a78 <mem+0x9a>
    exit(xstatus);
    4a16:	00001097          	auipc	ra,0x1
    4a1a:	1de080e7          	jalr	478(ra) # 5bf4 <exit>
      *(char**)m2 = m1;
    4a1e:	e104                	sd	s1,0(a0)
      m1 = m2;
    4a20:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4a22:	854a                	mv	a0,s2
    4a24:	00001097          	auipc	ra,0x1
    4a28:	606080e7          	jalr	1542(ra) # 602a <malloc>
    4a2c:	f96d                	bnez	a0,4a1e <mem+0x40>
    while(m1){
    4a2e:	c881                	beqz	s1,4a3e <mem+0x60>
      m2 = *(char**)m1;
    4a30:	8526                	mv	a0,s1
    4a32:	6084                	ld	s1,0(s1)
      free(m1);
    4a34:	00001097          	auipc	ra,0x1
    4a38:	56e080e7          	jalr	1390(ra) # 5fa2 <free>
    while(m1){
    4a3c:	f8f5                	bnez	s1,4a30 <mem+0x52>
    m1 = malloc(1024*20);
    4a3e:	6515                	lui	a0,0x5
    4a40:	00001097          	auipc	ra,0x1
    4a44:	5ea080e7          	jalr	1514(ra) # 602a <malloc>
    if(m1 == 0){
    4a48:	c911                	beqz	a0,4a5c <mem+0x7e>
    free(m1);
    4a4a:	00001097          	auipc	ra,0x1
    4a4e:	558080e7          	jalr	1368(ra) # 5fa2 <free>
    exit(0);
    4a52:	4501                	li	a0,0
    4a54:	00001097          	auipc	ra,0x1
    4a58:	1a0080e7          	jalr	416(ra) # 5bf4 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a5c:	85ce                	mv	a1,s3
    4a5e:	00003517          	auipc	a0,0x3
    4a62:	34250513          	addi	a0,a0,834 # 7da0 <malloc+0x1d76>
    4a66:	00001097          	auipc	ra,0x1
    4a6a:	506080e7          	jalr	1286(ra) # 5f6c <printf>
      exit(1);
    4a6e:	4505                	li	a0,1
    4a70:	00001097          	auipc	ra,0x1
    4a74:	184080e7          	jalr	388(ra) # 5bf4 <exit>
      exit(0);
    4a78:	4501                	li	a0,0
    4a7a:	00001097          	auipc	ra,0x1
    4a7e:	17a080e7          	jalr	378(ra) # 5bf4 <exit>

0000000000004a82 <sharedfd>:
{
    4a82:	7159                	addi	sp,sp,-112
    4a84:	f486                	sd	ra,104(sp)
    4a86:	f0a2                	sd	s0,96(sp)
    4a88:	eca6                	sd	s1,88(sp)
    4a8a:	e8ca                	sd	s2,80(sp)
    4a8c:	e4ce                	sd	s3,72(sp)
    4a8e:	e0d2                	sd	s4,64(sp)
    4a90:	fc56                	sd	s5,56(sp)
    4a92:	f85a                	sd	s6,48(sp)
    4a94:	f45e                	sd	s7,40(sp)
    4a96:	1880                	addi	s0,sp,112
    4a98:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a9a:	00003517          	auipc	a0,0x3
    4a9e:	32650513          	addi	a0,a0,806 # 7dc0 <malloc+0x1d96>
    4aa2:	00001097          	auipc	ra,0x1
    4aa6:	1a2080e7          	jalr	418(ra) # 5c44 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4aaa:	20200593          	li	a1,514
    4aae:	00003517          	auipc	a0,0x3
    4ab2:	31250513          	addi	a0,a0,786 # 7dc0 <malloc+0x1d96>
    4ab6:	00001097          	auipc	ra,0x1
    4aba:	17e080e7          	jalr	382(ra) # 5c34 <open>
  if(fd < 0){
    4abe:	04054a63          	bltz	a0,4b12 <sharedfd+0x90>
    4ac2:	892a                	mv	s2,a0
  pid = fork();
    4ac4:	00001097          	auipc	ra,0x1
    4ac8:	128080e7          	jalr	296(ra) # 5bec <fork>
    4acc:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4ace:	06300593          	li	a1,99
    4ad2:	c119                	beqz	a0,4ad8 <sharedfd+0x56>
    4ad4:	07000593          	li	a1,112
    4ad8:	4629                	li	a2,10
    4ada:	fa040513          	addi	a0,s0,-96
    4ade:	00001097          	auipc	ra,0x1
    4ae2:	f1a080e7          	jalr	-230(ra) # 59f8 <memset>
    4ae6:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4aea:	4629                	li	a2,10
    4aec:	fa040593          	addi	a1,s0,-96
    4af0:	854a                	mv	a0,s2
    4af2:	00001097          	auipc	ra,0x1
    4af6:	122080e7          	jalr	290(ra) # 5c14 <write>
    4afa:	47a9                	li	a5,10
    4afc:	02f51963          	bne	a0,a5,4b2e <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4b00:	34fd                	addiw	s1,s1,-1
    4b02:	f4e5                	bnez	s1,4aea <sharedfd+0x68>
  if(pid == 0) {
    4b04:	04099363          	bnez	s3,4b4a <sharedfd+0xc8>
    exit(0);
    4b08:	4501                	li	a0,0
    4b0a:	00001097          	auipc	ra,0x1
    4b0e:	0ea080e7          	jalr	234(ra) # 5bf4 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4b12:	85d2                	mv	a1,s4
    4b14:	00003517          	auipc	a0,0x3
    4b18:	2bc50513          	addi	a0,a0,700 # 7dd0 <malloc+0x1da6>
    4b1c:	00001097          	auipc	ra,0x1
    4b20:	450080e7          	jalr	1104(ra) # 5f6c <printf>
    exit(1);
    4b24:	4505                	li	a0,1
    4b26:	00001097          	auipc	ra,0x1
    4b2a:	0ce080e7          	jalr	206(ra) # 5bf4 <exit>
      printf("%s: write sharedfd failed\n", s);
    4b2e:	85d2                	mv	a1,s4
    4b30:	00003517          	auipc	a0,0x3
    4b34:	2c850513          	addi	a0,a0,712 # 7df8 <malloc+0x1dce>
    4b38:	00001097          	auipc	ra,0x1
    4b3c:	434080e7          	jalr	1076(ra) # 5f6c <printf>
      exit(1);
    4b40:	4505                	li	a0,1
    4b42:	00001097          	auipc	ra,0x1
    4b46:	0b2080e7          	jalr	178(ra) # 5bf4 <exit>
    wait(&xstatus);
    4b4a:	f9c40513          	addi	a0,s0,-100
    4b4e:	00001097          	auipc	ra,0x1
    4b52:	0ae080e7          	jalr	174(ra) # 5bfc <wait>
    if(xstatus != 0)
    4b56:	f9c42983          	lw	s3,-100(s0)
    4b5a:	00098763          	beqz	s3,4b68 <sharedfd+0xe6>
      exit(xstatus);
    4b5e:	854e                	mv	a0,s3
    4b60:	00001097          	auipc	ra,0x1
    4b64:	094080e7          	jalr	148(ra) # 5bf4 <exit>
  close(fd);
    4b68:	854a                	mv	a0,s2
    4b6a:	00001097          	auipc	ra,0x1
    4b6e:	0b2080e7          	jalr	178(ra) # 5c1c <close>
  fd = open("sharedfd", 0);
    4b72:	4581                	li	a1,0
    4b74:	00003517          	auipc	a0,0x3
    4b78:	24c50513          	addi	a0,a0,588 # 7dc0 <malloc+0x1d96>
    4b7c:	00001097          	auipc	ra,0x1
    4b80:	0b8080e7          	jalr	184(ra) # 5c34 <open>
    4b84:	8baa                	mv	s7,a0
  nc = np = 0;
    4b86:	8ace                	mv	s5,s3
  if(fd < 0){
    4b88:	02054563          	bltz	a0,4bb2 <sharedfd+0x130>
    4b8c:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4b90:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4b94:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4b98:	4629                	li	a2,10
    4b9a:	fa040593          	addi	a1,s0,-96
    4b9e:	855e                	mv	a0,s7
    4ba0:	00001097          	auipc	ra,0x1
    4ba4:	06c080e7          	jalr	108(ra) # 5c0c <read>
    4ba8:	02a05f63          	blez	a0,4be6 <sharedfd+0x164>
    4bac:	fa040793          	addi	a5,s0,-96
    4bb0:	a01d                	j	4bd6 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4bb2:	85d2                	mv	a1,s4
    4bb4:	00003517          	auipc	a0,0x3
    4bb8:	26450513          	addi	a0,a0,612 # 7e18 <malloc+0x1dee>
    4bbc:	00001097          	auipc	ra,0x1
    4bc0:	3b0080e7          	jalr	944(ra) # 5f6c <printf>
    exit(1);
    4bc4:	4505                	li	a0,1
    4bc6:	00001097          	auipc	ra,0x1
    4bca:	02e080e7          	jalr	46(ra) # 5bf4 <exit>
        nc++;
    4bce:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4bd0:	0785                	addi	a5,a5,1
    4bd2:	fd2783e3          	beq	a5,s2,4b98 <sharedfd+0x116>
      if(buf[i] == 'c')
    4bd6:	0007c703          	lbu	a4,0(a5)
    4bda:	fe970ae3          	beq	a4,s1,4bce <sharedfd+0x14c>
      if(buf[i] == 'p')
    4bde:	ff6719e3          	bne	a4,s6,4bd0 <sharedfd+0x14e>
        np++;
    4be2:	2a85                	addiw	s5,s5,1
    4be4:	b7f5                	j	4bd0 <sharedfd+0x14e>
  close(fd);
    4be6:	855e                	mv	a0,s7
    4be8:	00001097          	auipc	ra,0x1
    4bec:	034080e7          	jalr	52(ra) # 5c1c <close>
  unlink("sharedfd");
    4bf0:	00003517          	auipc	a0,0x3
    4bf4:	1d050513          	addi	a0,a0,464 # 7dc0 <malloc+0x1d96>
    4bf8:	00001097          	auipc	ra,0x1
    4bfc:	04c080e7          	jalr	76(ra) # 5c44 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4c00:	6789                	lui	a5,0x2
    4c02:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0xfa>
    4c06:	00f99763          	bne	s3,a5,4c14 <sharedfd+0x192>
    4c0a:	6789                	lui	a5,0x2
    4c0c:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0xfa>
    4c10:	02fa8063          	beq	s5,a5,4c30 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4c14:	85d2                	mv	a1,s4
    4c16:	00003517          	auipc	a0,0x3
    4c1a:	22a50513          	addi	a0,a0,554 # 7e40 <malloc+0x1e16>
    4c1e:	00001097          	auipc	ra,0x1
    4c22:	34e080e7          	jalr	846(ra) # 5f6c <printf>
    exit(1);
    4c26:	4505                	li	a0,1
    4c28:	00001097          	auipc	ra,0x1
    4c2c:	fcc080e7          	jalr	-52(ra) # 5bf4 <exit>
    exit(0);
    4c30:	4501                	li	a0,0
    4c32:	00001097          	auipc	ra,0x1
    4c36:	fc2080e7          	jalr	-62(ra) # 5bf4 <exit>

0000000000004c3a <fourfiles>:
{
    4c3a:	7171                	addi	sp,sp,-176
    4c3c:	f506                	sd	ra,168(sp)
    4c3e:	f122                	sd	s0,160(sp)
    4c40:	ed26                	sd	s1,152(sp)
    4c42:	e94a                	sd	s2,144(sp)
    4c44:	e54e                	sd	s3,136(sp)
    4c46:	e152                	sd	s4,128(sp)
    4c48:	fcd6                	sd	s5,120(sp)
    4c4a:	f8da                	sd	s6,112(sp)
    4c4c:	f4de                	sd	s7,104(sp)
    4c4e:	f0e2                	sd	s8,96(sp)
    4c50:	ece6                	sd	s9,88(sp)
    4c52:	e8ea                	sd	s10,80(sp)
    4c54:	e4ee                	sd	s11,72(sp)
    4c56:	1900                	addi	s0,sp,176
    4c58:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c5c:	00001797          	auipc	a5,0x1
    4c60:	4b478793          	addi	a5,a5,1204 # 6110 <malloc+0xe6>
    4c64:	f6f43823          	sd	a5,-144(s0)
    4c68:	00001797          	auipc	a5,0x1
    4c6c:	4b078793          	addi	a5,a5,1200 # 6118 <malloc+0xee>
    4c70:	f6f43c23          	sd	a5,-136(s0)
    4c74:	00001797          	auipc	a5,0x1
    4c78:	4ac78793          	addi	a5,a5,1196 # 6120 <malloc+0xf6>
    4c7c:	f8f43023          	sd	a5,-128(s0)
    4c80:	00001797          	auipc	a5,0x1
    4c84:	4a878793          	addi	a5,a5,1192 # 6128 <malloc+0xfe>
    4c88:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4c8c:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c90:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    4c92:	4481                	li	s1,0
    4c94:	4a11                	li	s4,4
    fname = names[pi];
    4c96:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c9a:	854e                	mv	a0,s3
    4c9c:	00001097          	auipc	ra,0x1
    4ca0:	fa8080e7          	jalr	-88(ra) # 5c44 <unlink>
    pid = fork();
    4ca4:	00001097          	auipc	ra,0x1
    4ca8:	f48080e7          	jalr	-184(ra) # 5bec <fork>
    if(pid < 0){
    4cac:	04054463          	bltz	a0,4cf4 <fourfiles+0xba>
    if(pid == 0){
    4cb0:	c12d                	beqz	a0,4d12 <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    4cb2:	2485                	addiw	s1,s1,1
    4cb4:	0921                	addi	s2,s2,8
    4cb6:	ff4490e3          	bne	s1,s4,4c96 <fourfiles+0x5c>
    4cba:	4491                	li	s1,4
    wait(&xstatus);
    4cbc:	f6c40513          	addi	a0,s0,-148
    4cc0:	00001097          	auipc	ra,0x1
    4cc4:	f3c080e7          	jalr	-196(ra) # 5bfc <wait>
    if(xstatus != 0)
    4cc8:	f6c42b03          	lw	s6,-148(s0)
    4ccc:	0c0b1e63          	bnez	s6,4da8 <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    4cd0:	34fd                	addiw	s1,s1,-1
    4cd2:	f4ed                	bnez	s1,4cbc <fourfiles+0x82>
    4cd4:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cd8:	00008a17          	auipc	s4,0x8
    4cdc:	fa0a0a13          	addi	s4,s4,-96 # cc78 <buf>
    4ce0:	00008a97          	auipc	s5,0x8
    4ce4:	f99a8a93          	addi	s5,s5,-103 # cc79 <buf+0x1>
    if(total != N*SZ){
    4ce8:	6d85                	lui	s11,0x1
    4cea:	770d8d93          	addi	s11,s11,1904 # 1770 <exectest+0x26>
  for(i = 0; i < NCHILD; i++){
    4cee:	03400d13          	li	s10,52
    4cf2:	aa1d                	j	4e28 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    4cf4:	f5843583          	ld	a1,-168(s0)
    4cf8:	00002517          	auipc	a0,0x2
    4cfc:	10050513          	addi	a0,a0,256 # 6df8 <malloc+0xdce>
    4d00:	00001097          	auipc	ra,0x1
    4d04:	26c080e7          	jalr	620(ra) # 5f6c <printf>
      exit(1);
    4d08:	4505                	li	a0,1
    4d0a:	00001097          	auipc	ra,0x1
    4d0e:	eea080e7          	jalr	-278(ra) # 5bf4 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4d12:	20200593          	li	a1,514
    4d16:	854e                	mv	a0,s3
    4d18:	00001097          	auipc	ra,0x1
    4d1c:	f1c080e7          	jalr	-228(ra) # 5c34 <open>
    4d20:	892a                	mv	s2,a0
      if(fd < 0){
    4d22:	04054763          	bltz	a0,4d70 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    4d26:	1f400613          	li	a2,500
    4d2a:	0304859b          	addiw	a1,s1,48
    4d2e:	00008517          	auipc	a0,0x8
    4d32:	f4a50513          	addi	a0,a0,-182 # cc78 <buf>
    4d36:	00001097          	auipc	ra,0x1
    4d3a:	cc2080e7          	jalr	-830(ra) # 59f8 <memset>
    4d3e:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d40:	00008997          	auipc	s3,0x8
    4d44:	f3898993          	addi	s3,s3,-200 # cc78 <buf>
    4d48:	1f400613          	li	a2,500
    4d4c:	85ce                	mv	a1,s3
    4d4e:	854a                	mv	a0,s2
    4d50:	00001097          	auipc	ra,0x1
    4d54:	ec4080e7          	jalr	-316(ra) # 5c14 <write>
    4d58:	85aa                	mv	a1,a0
    4d5a:	1f400793          	li	a5,500
    4d5e:	02f51863          	bne	a0,a5,4d8e <fourfiles+0x154>
      for(i = 0; i < N; i++){
    4d62:	34fd                	addiw	s1,s1,-1
    4d64:	f0f5                	bnez	s1,4d48 <fourfiles+0x10e>
      exit(0);
    4d66:	4501                	li	a0,0
    4d68:	00001097          	auipc	ra,0x1
    4d6c:	e8c080e7          	jalr	-372(ra) # 5bf4 <exit>
        printf("create failed\n", s);
    4d70:	f5843583          	ld	a1,-168(s0)
    4d74:	00003517          	auipc	a0,0x3
    4d78:	0e450513          	addi	a0,a0,228 # 7e58 <malloc+0x1e2e>
    4d7c:	00001097          	auipc	ra,0x1
    4d80:	1f0080e7          	jalr	496(ra) # 5f6c <printf>
        exit(1);
    4d84:	4505                	li	a0,1
    4d86:	00001097          	auipc	ra,0x1
    4d8a:	e6e080e7          	jalr	-402(ra) # 5bf4 <exit>
          printf("write failed %d\n", n);
    4d8e:	00003517          	auipc	a0,0x3
    4d92:	0da50513          	addi	a0,a0,218 # 7e68 <malloc+0x1e3e>
    4d96:	00001097          	auipc	ra,0x1
    4d9a:	1d6080e7          	jalr	470(ra) # 5f6c <printf>
          exit(1);
    4d9e:	4505                	li	a0,1
    4da0:	00001097          	auipc	ra,0x1
    4da4:	e54080e7          	jalr	-428(ra) # 5bf4 <exit>
      exit(xstatus);
    4da8:	855a                	mv	a0,s6
    4daa:	00001097          	auipc	ra,0x1
    4dae:	e4a080e7          	jalr	-438(ra) # 5bf4 <exit>
          printf("wrong char\n", s);
    4db2:	f5843583          	ld	a1,-168(s0)
    4db6:	00003517          	auipc	a0,0x3
    4dba:	0ca50513          	addi	a0,a0,202 # 7e80 <malloc+0x1e56>
    4dbe:	00001097          	auipc	ra,0x1
    4dc2:	1ae080e7          	jalr	430(ra) # 5f6c <printf>
          exit(1);
    4dc6:	4505                	li	a0,1
    4dc8:	00001097          	auipc	ra,0x1
    4dcc:	e2c080e7          	jalr	-468(ra) # 5bf4 <exit>
      total += n;
    4dd0:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4dd4:	660d                	lui	a2,0x3
    4dd6:	85d2                	mv	a1,s4
    4dd8:	854e                	mv	a0,s3
    4dda:	00001097          	auipc	ra,0x1
    4dde:	e32080e7          	jalr	-462(ra) # 5c0c <read>
    4de2:	02a05363          	blez	a0,4e08 <fourfiles+0x1ce>
    4de6:	00008797          	auipc	a5,0x8
    4dea:	e9278793          	addi	a5,a5,-366 # cc78 <buf>
    4dee:	fff5069b          	addiw	a3,a0,-1
    4df2:	1682                	slli	a3,a3,0x20
    4df4:	9281                	srli	a3,a3,0x20
    4df6:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4df8:	0007c703          	lbu	a4,0(a5)
    4dfc:	fa971be3          	bne	a4,s1,4db2 <fourfiles+0x178>
      for(j = 0; j < n; j++){
    4e00:	0785                	addi	a5,a5,1
    4e02:	fed79be3          	bne	a5,a3,4df8 <fourfiles+0x1be>
    4e06:	b7e9                	j	4dd0 <fourfiles+0x196>
    close(fd);
    4e08:	854e                	mv	a0,s3
    4e0a:	00001097          	auipc	ra,0x1
    4e0e:	e12080e7          	jalr	-494(ra) # 5c1c <close>
    if(total != N*SZ){
    4e12:	03b91863          	bne	s2,s11,4e42 <fourfiles+0x208>
    unlink(fname);
    4e16:	8566                	mv	a0,s9
    4e18:	00001097          	auipc	ra,0x1
    4e1c:	e2c080e7          	jalr	-468(ra) # 5c44 <unlink>
  for(i = 0; i < NCHILD; i++){
    4e20:	0c21                	addi	s8,s8,8
    4e22:	2b85                	addiw	s7,s7,1
    4e24:	03ab8d63          	beq	s7,s10,4e5e <fourfiles+0x224>
    fname = names[i];
    4e28:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    4e2c:	4581                	li	a1,0
    4e2e:	8566                	mv	a0,s9
    4e30:	00001097          	auipc	ra,0x1
    4e34:	e04080e7          	jalr	-508(ra) # 5c34 <open>
    4e38:	89aa                	mv	s3,a0
    total = 0;
    4e3a:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    4e3c:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e40:	bf51                	j	4dd4 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4e42:	85ca                	mv	a1,s2
    4e44:	00003517          	auipc	a0,0x3
    4e48:	04c50513          	addi	a0,a0,76 # 7e90 <malloc+0x1e66>
    4e4c:	00001097          	auipc	ra,0x1
    4e50:	120080e7          	jalr	288(ra) # 5f6c <printf>
      exit(1);
    4e54:	4505                	li	a0,1
    4e56:	00001097          	auipc	ra,0x1
    4e5a:	d9e080e7          	jalr	-610(ra) # 5bf4 <exit>
}
    4e5e:	70aa                	ld	ra,168(sp)
    4e60:	740a                	ld	s0,160(sp)
    4e62:	64ea                	ld	s1,152(sp)
    4e64:	694a                	ld	s2,144(sp)
    4e66:	69aa                	ld	s3,136(sp)
    4e68:	6a0a                	ld	s4,128(sp)
    4e6a:	7ae6                	ld	s5,120(sp)
    4e6c:	7b46                	ld	s6,112(sp)
    4e6e:	7ba6                	ld	s7,104(sp)
    4e70:	7c06                	ld	s8,96(sp)
    4e72:	6ce6                	ld	s9,88(sp)
    4e74:	6d46                	ld	s10,80(sp)
    4e76:	6da6                	ld	s11,72(sp)
    4e78:	614d                	addi	sp,sp,176
    4e7a:	8082                	ret

0000000000004e7c <concreate>:
{
    4e7c:	7135                	addi	sp,sp,-160
    4e7e:	ed06                	sd	ra,152(sp)
    4e80:	e922                	sd	s0,144(sp)
    4e82:	e526                	sd	s1,136(sp)
    4e84:	e14a                	sd	s2,128(sp)
    4e86:	fcce                	sd	s3,120(sp)
    4e88:	f8d2                	sd	s4,112(sp)
    4e8a:	f4d6                	sd	s5,104(sp)
    4e8c:	f0da                	sd	s6,96(sp)
    4e8e:	ecde                	sd	s7,88(sp)
    4e90:	1100                	addi	s0,sp,160
    4e92:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e94:	04300793          	li	a5,67
    4e98:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e9c:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4ea0:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4ea2:	4b0d                	li	s6,3
    4ea4:	4a85                	li	s5,1
      link("C0", file);
    4ea6:	00003b97          	auipc	s7,0x3
    4eaa:	002b8b93          	addi	s7,s7,2 # 7ea8 <malloc+0x1e7e>
  for(i = 0; i < N; i++){
    4eae:	02800a13          	li	s4,40
    4eb2:	acc1                	j	5182 <concreate+0x306>
      link("C0", file);
    4eb4:	fa840593          	addi	a1,s0,-88
    4eb8:	855e                	mv	a0,s7
    4eba:	00001097          	auipc	ra,0x1
    4ebe:	d9a080e7          	jalr	-614(ra) # 5c54 <link>
    if(pid == 0) {
    4ec2:	a45d                	j	5168 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4ec4:	4795                	li	a5,5
    4ec6:	02f9693b          	remw	s2,s2,a5
    4eca:	4785                	li	a5,1
    4ecc:	02f90b63          	beq	s2,a5,4f02 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4ed0:	20200593          	li	a1,514
    4ed4:	fa840513          	addi	a0,s0,-88
    4ed8:	00001097          	auipc	ra,0x1
    4edc:	d5c080e7          	jalr	-676(ra) # 5c34 <open>
      if(fd < 0){
    4ee0:	26055b63          	bgez	a0,5156 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4ee4:	fa840593          	addi	a1,s0,-88
    4ee8:	00003517          	auipc	a0,0x3
    4eec:	fc850513          	addi	a0,a0,-56 # 7eb0 <malloc+0x1e86>
    4ef0:	00001097          	auipc	ra,0x1
    4ef4:	07c080e7          	jalr	124(ra) # 5f6c <printf>
        exit(1);
    4ef8:	4505                	li	a0,1
    4efa:	00001097          	auipc	ra,0x1
    4efe:	cfa080e7          	jalr	-774(ra) # 5bf4 <exit>
      link("C0", file);
    4f02:	fa840593          	addi	a1,s0,-88
    4f06:	00003517          	auipc	a0,0x3
    4f0a:	fa250513          	addi	a0,a0,-94 # 7ea8 <malloc+0x1e7e>
    4f0e:	00001097          	auipc	ra,0x1
    4f12:	d46080e7          	jalr	-698(ra) # 5c54 <link>
      exit(0);
    4f16:	4501                	li	a0,0
    4f18:	00001097          	auipc	ra,0x1
    4f1c:	cdc080e7          	jalr	-804(ra) # 5bf4 <exit>
        exit(1);
    4f20:	4505                	li	a0,1
    4f22:	00001097          	auipc	ra,0x1
    4f26:	cd2080e7          	jalr	-814(ra) # 5bf4 <exit>
  memset(fa, 0, sizeof(fa));
    4f2a:	02800613          	li	a2,40
    4f2e:	4581                	li	a1,0
    4f30:	f8040513          	addi	a0,s0,-128
    4f34:	00001097          	auipc	ra,0x1
    4f38:	ac4080e7          	jalr	-1340(ra) # 59f8 <memset>
  fd = open(".", 0);
    4f3c:	4581                	li	a1,0
    4f3e:	00002517          	auipc	a0,0x2
    4f42:	91250513          	addi	a0,a0,-1774 # 6850 <malloc+0x826>
    4f46:	00001097          	auipc	ra,0x1
    4f4a:	cee080e7          	jalr	-786(ra) # 5c34 <open>
    4f4e:	892a                	mv	s2,a0
  n = 0;
    4f50:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f52:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f56:	02700b13          	li	s6,39
      fa[i] = 1;
    4f5a:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f5c:	4641                	li	a2,16
    4f5e:	f7040593          	addi	a1,s0,-144
    4f62:	854a                	mv	a0,s2
    4f64:	00001097          	auipc	ra,0x1
    4f68:	ca8080e7          	jalr	-856(ra) # 5c0c <read>
    4f6c:	08a05163          	blez	a0,4fee <concreate+0x172>
    if(de.inum == 0)
    4f70:	f7045783          	lhu	a5,-144(s0)
    4f74:	d7e5                	beqz	a5,4f5c <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f76:	f7244783          	lbu	a5,-142(s0)
    4f7a:	ff4791e3          	bne	a5,s4,4f5c <concreate+0xe0>
    4f7e:	f7444783          	lbu	a5,-140(s0)
    4f82:	ffe9                	bnez	a5,4f5c <concreate+0xe0>
      i = de.name[1] - '0';
    4f84:	f7344783          	lbu	a5,-141(s0)
    4f88:	fd07879b          	addiw	a5,a5,-48
    4f8c:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4f90:	00eb6f63          	bltu	s6,a4,4fae <concreate+0x132>
      if(fa[i]){
    4f94:	fb040793          	addi	a5,s0,-80
    4f98:	97ba                	add	a5,a5,a4
    4f9a:	fd07c783          	lbu	a5,-48(a5)
    4f9e:	eb85                	bnez	a5,4fce <concreate+0x152>
      fa[i] = 1;
    4fa0:	fb040793          	addi	a5,s0,-80
    4fa4:	973e                	add	a4,a4,a5
    4fa6:	fd770823          	sb	s7,-48(a4) # fd0 <linktest+0xd2>
      n++;
    4faa:	2a85                	addiw	s5,s5,1
    4fac:	bf45                	j	4f5c <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4fae:	f7240613          	addi	a2,s0,-142
    4fb2:	85ce                	mv	a1,s3
    4fb4:	00003517          	auipc	a0,0x3
    4fb8:	f1c50513          	addi	a0,a0,-228 # 7ed0 <malloc+0x1ea6>
    4fbc:	00001097          	auipc	ra,0x1
    4fc0:	fb0080e7          	jalr	-80(ra) # 5f6c <printf>
        exit(1);
    4fc4:	4505                	li	a0,1
    4fc6:	00001097          	auipc	ra,0x1
    4fca:	c2e080e7          	jalr	-978(ra) # 5bf4 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4fce:	f7240613          	addi	a2,s0,-142
    4fd2:	85ce                	mv	a1,s3
    4fd4:	00003517          	auipc	a0,0x3
    4fd8:	f1c50513          	addi	a0,a0,-228 # 7ef0 <malloc+0x1ec6>
    4fdc:	00001097          	auipc	ra,0x1
    4fe0:	f90080e7          	jalr	-112(ra) # 5f6c <printf>
        exit(1);
    4fe4:	4505                	li	a0,1
    4fe6:	00001097          	auipc	ra,0x1
    4fea:	c0e080e7          	jalr	-1010(ra) # 5bf4 <exit>
  close(fd);
    4fee:	854a                	mv	a0,s2
    4ff0:	00001097          	auipc	ra,0x1
    4ff4:	c2c080e7          	jalr	-980(ra) # 5c1c <close>
  if(n != N){
    4ff8:	02800793          	li	a5,40
    4ffc:	00fa9763          	bne	s5,a5,500a <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    5000:	4a8d                	li	s5,3
    5002:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    5004:	02800a13          	li	s4,40
    5008:	a8c9                	j	50da <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    500a:	85ce                	mv	a1,s3
    500c:	00003517          	auipc	a0,0x3
    5010:	f0c50513          	addi	a0,a0,-244 # 7f18 <malloc+0x1eee>
    5014:	00001097          	auipc	ra,0x1
    5018:	f58080e7          	jalr	-168(ra) # 5f6c <printf>
    exit(1);
    501c:	4505                	li	a0,1
    501e:	00001097          	auipc	ra,0x1
    5022:	bd6080e7          	jalr	-1066(ra) # 5bf4 <exit>
      printf("%s: fork failed\n", s);
    5026:	85ce                	mv	a1,s3
    5028:	00002517          	auipc	a0,0x2
    502c:	9c850513          	addi	a0,a0,-1592 # 69f0 <malloc+0x9c6>
    5030:	00001097          	auipc	ra,0x1
    5034:	f3c080e7          	jalr	-196(ra) # 5f6c <printf>
      exit(1);
    5038:	4505                	li	a0,1
    503a:	00001097          	auipc	ra,0x1
    503e:	bba080e7          	jalr	-1094(ra) # 5bf4 <exit>
      close(open(file, 0));
    5042:	4581                	li	a1,0
    5044:	fa840513          	addi	a0,s0,-88
    5048:	00001097          	auipc	ra,0x1
    504c:	bec080e7          	jalr	-1044(ra) # 5c34 <open>
    5050:	00001097          	auipc	ra,0x1
    5054:	bcc080e7          	jalr	-1076(ra) # 5c1c <close>
      close(open(file, 0));
    5058:	4581                	li	a1,0
    505a:	fa840513          	addi	a0,s0,-88
    505e:	00001097          	auipc	ra,0x1
    5062:	bd6080e7          	jalr	-1066(ra) # 5c34 <open>
    5066:	00001097          	auipc	ra,0x1
    506a:	bb6080e7          	jalr	-1098(ra) # 5c1c <close>
      close(open(file, 0));
    506e:	4581                	li	a1,0
    5070:	fa840513          	addi	a0,s0,-88
    5074:	00001097          	auipc	ra,0x1
    5078:	bc0080e7          	jalr	-1088(ra) # 5c34 <open>
    507c:	00001097          	auipc	ra,0x1
    5080:	ba0080e7          	jalr	-1120(ra) # 5c1c <close>
      close(open(file, 0));
    5084:	4581                	li	a1,0
    5086:	fa840513          	addi	a0,s0,-88
    508a:	00001097          	auipc	ra,0x1
    508e:	baa080e7          	jalr	-1110(ra) # 5c34 <open>
    5092:	00001097          	auipc	ra,0x1
    5096:	b8a080e7          	jalr	-1142(ra) # 5c1c <close>
      close(open(file, 0));
    509a:	4581                	li	a1,0
    509c:	fa840513          	addi	a0,s0,-88
    50a0:	00001097          	auipc	ra,0x1
    50a4:	b94080e7          	jalr	-1132(ra) # 5c34 <open>
    50a8:	00001097          	auipc	ra,0x1
    50ac:	b74080e7          	jalr	-1164(ra) # 5c1c <close>
      close(open(file, 0));
    50b0:	4581                	li	a1,0
    50b2:	fa840513          	addi	a0,s0,-88
    50b6:	00001097          	auipc	ra,0x1
    50ba:	b7e080e7          	jalr	-1154(ra) # 5c34 <open>
    50be:	00001097          	auipc	ra,0x1
    50c2:	b5e080e7          	jalr	-1186(ra) # 5c1c <close>
    if(pid == 0)
    50c6:	08090363          	beqz	s2,514c <concreate+0x2d0>
      wait(0);
    50ca:	4501                	li	a0,0
    50cc:	00001097          	auipc	ra,0x1
    50d0:	b30080e7          	jalr	-1232(ra) # 5bfc <wait>
  for(i = 0; i < N; i++){
    50d4:	2485                	addiw	s1,s1,1
    50d6:	0f448563          	beq	s1,s4,51c0 <concreate+0x344>
    file[1] = '0' + i;
    50da:	0304879b          	addiw	a5,s1,48
    50de:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50e2:	00001097          	auipc	ra,0x1
    50e6:	b0a080e7          	jalr	-1270(ra) # 5bec <fork>
    50ea:	892a                	mv	s2,a0
    if(pid < 0){
    50ec:	f2054de3          	bltz	a0,5026 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    50f0:	0354e73b          	remw	a4,s1,s5
    50f4:	00a767b3          	or	a5,a4,a0
    50f8:	2781                	sext.w	a5,a5
    50fa:	d7a1                	beqz	a5,5042 <concreate+0x1c6>
    50fc:	01671363          	bne	a4,s6,5102 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    5100:	f129                	bnez	a0,5042 <concreate+0x1c6>
      unlink(file);
    5102:	fa840513          	addi	a0,s0,-88
    5106:	00001097          	auipc	ra,0x1
    510a:	b3e080e7          	jalr	-1218(ra) # 5c44 <unlink>
      unlink(file);
    510e:	fa840513          	addi	a0,s0,-88
    5112:	00001097          	auipc	ra,0x1
    5116:	b32080e7          	jalr	-1230(ra) # 5c44 <unlink>
      unlink(file);
    511a:	fa840513          	addi	a0,s0,-88
    511e:	00001097          	auipc	ra,0x1
    5122:	b26080e7          	jalr	-1242(ra) # 5c44 <unlink>
      unlink(file);
    5126:	fa840513          	addi	a0,s0,-88
    512a:	00001097          	auipc	ra,0x1
    512e:	b1a080e7          	jalr	-1254(ra) # 5c44 <unlink>
      unlink(file);
    5132:	fa840513          	addi	a0,s0,-88
    5136:	00001097          	auipc	ra,0x1
    513a:	b0e080e7          	jalr	-1266(ra) # 5c44 <unlink>
      unlink(file);
    513e:	fa840513          	addi	a0,s0,-88
    5142:	00001097          	auipc	ra,0x1
    5146:	b02080e7          	jalr	-1278(ra) # 5c44 <unlink>
    514a:	bfb5                	j	50c6 <concreate+0x24a>
      exit(0);
    514c:	4501                	li	a0,0
    514e:	00001097          	auipc	ra,0x1
    5152:	aa6080e7          	jalr	-1370(ra) # 5bf4 <exit>
      close(fd);
    5156:	00001097          	auipc	ra,0x1
    515a:	ac6080e7          	jalr	-1338(ra) # 5c1c <close>
    if(pid == 0) {
    515e:	bb65                	j	4f16 <concreate+0x9a>
      close(fd);
    5160:	00001097          	auipc	ra,0x1
    5164:	abc080e7          	jalr	-1348(ra) # 5c1c <close>
      wait(&xstatus);
    5168:	f6c40513          	addi	a0,s0,-148
    516c:	00001097          	auipc	ra,0x1
    5170:	a90080e7          	jalr	-1392(ra) # 5bfc <wait>
      if(xstatus != 0)
    5174:	f6c42483          	lw	s1,-148(s0)
    5178:	da0494e3          	bnez	s1,4f20 <concreate+0xa4>
  for(i = 0; i < N; i++){
    517c:	2905                	addiw	s2,s2,1
    517e:	db4906e3          	beq	s2,s4,4f2a <concreate+0xae>
    file[1] = '0' + i;
    5182:	0309079b          	addiw	a5,s2,48
    5186:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    518a:	fa840513          	addi	a0,s0,-88
    518e:	00001097          	auipc	ra,0x1
    5192:	ab6080e7          	jalr	-1354(ra) # 5c44 <unlink>
    pid = fork();
    5196:	00001097          	auipc	ra,0x1
    519a:	a56080e7          	jalr	-1450(ra) # 5bec <fork>
    if(pid && (i % 3) == 1){
    519e:	d20503e3          	beqz	a0,4ec4 <concreate+0x48>
    51a2:	036967bb          	remw	a5,s2,s6
    51a6:	d15787e3          	beq	a5,s5,4eb4 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    51aa:	20200593          	li	a1,514
    51ae:	fa840513          	addi	a0,s0,-88
    51b2:	00001097          	auipc	ra,0x1
    51b6:	a82080e7          	jalr	-1406(ra) # 5c34 <open>
      if(fd < 0){
    51ba:	fa0553e3          	bgez	a0,5160 <concreate+0x2e4>
    51be:	b31d                	j	4ee4 <concreate+0x68>
}
    51c0:	60ea                	ld	ra,152(sp)
    51c2:	644a                	ld	s0,144(sp)
    51c4:	64aa                	ld	s1,136(sp)
    51c6:	690a                	ld	s2,128(sp)
    51c8:	79e6                	ld	s3,120(sp)
    51ca:	7a46                	ld	s4,112(sp)
    51cc:	7aa6                	ld	s5,104(sp)
    51ce:	7b06                	ld	s6,96(sp)
    51d0:	6be6                	ld	s7,88(sp)
    51d2:	610d                	addi	sp,sp,160
    51d4:	8082                	ret

00000000000051d6 <bigfile>:
{
    51d6:	7139                	addi	sp,sp,-64
    51d8:	fc06                	sd	ra,56(sp)
    51da:	f822                	sd	s0,48(sp)
    51dc:	f426                	sd	s1,40(sp)
    51de:	f04a                	sd	s2,32(sp)
    51e0:	ec4e                	sd	s3,24(sp)
    51e2:	e852                	sd	s4,16(sp)
    51e4:	e456                	sd	s5,8(sp)
    51e6:	0080                	addi	s0,sp,64
    51e8:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51ea:	00003517          	auipc	a0,0x3
    51ee:	d6650513          	addi	a0,a0,-666 # 7f50 <malloc+0x1f26>
    51f2:	00001097          	auipc	ra,0x1
    51f6:	a52080e7          	jalr	-1454(ra) # 5c44 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51fa:	20200593          	li	a1,514
    51fe:	00003517          	auipc	a0,0x3
    5202:	d5250513          	addi	a0,a0,-686 # 7f50 <malloc+0x1f26>
    5206:	00001097          	auipc	ra,0x1
    520a:	a2e080e7          	jalr	-1490(ra) # 5c34 <open>
    520e:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    5210:	4481                	li	s1,0
    memset(buf, i, SZ);
    5212:	00008917          	auipc	s2,0x8
    5216:	a6690913          	addi	s2,s2,-1434 # cc78 <buf>
  for(i = 0; i < N; i++){
    521a:	4a51                	li	s4,20
  if(fd < 0){
    521c:	0a054063          	bltz	a0,52bc <bigfile+0xe6>
    memset(buf, i, SZ);
    5220:	25800613          	li	a2,600
    5224:	85a6                	mv	a1,s1
    5226:	854a                	mv	a0,s2
    5228:	00000097          	auipc	ra,0x0
    522c:	7d0080e7          	jalr	2000(ra) # 59f8 <memset>
    if(write(fd, buf, SZ) != SZ){
    5230:	25800613          	li	a2,600
    5234:	85ca                	mv	a1,s2
    5236:	854e                	mv	a0,s3
    5238:	00001097          	auipc	ra,0x1
    523c:	9dc080e7          	jalr	-1572(ra) # 5c14 <write>
    5240:	25800793          	li	a5,600
    5244:	08f51a63          	bne	a0,a5,52d8 <bigfile+0x102>
  for(i = 0; i < N; i++){
    5248:	2485                	addiw	s1,s1,1
    524a:	fd449be3          	bne	s1,s4,5220 <bigfile+0x4a>
  close(fd);
    524e:	854e                	mv	a0,s3
    5250:	00001097          	auipc	ra,0x1
    5254:	9cc080e7          	jalr	-1588(ra) # 5c1c <close>
  fd = open("bigfile.dat", 0);
    5258:	4581                	li	a1,0
    525a:	00003517          	auipc	a0,0x3
    525e:	cf650513          	addi	a0,a0,-778 # 7f50 <malloc+0x1f26>
    5262:	00001097          	auipc	ra,0x1
    5266:	9d2080e7          	jalr	-1582(ra) # 5c34 <open>
    526a:	8a2a                	mv	s4,a0
  total = 0;
    526c:	4981                	li	s3,0
  for(i = 0; ; i++){
    526e:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5270:	00008917          	auipc	s2,0x8
    5274:	a0890913          	addi	s2,s2,-1528 # cc78 <buf>
  if(fd < 0){
    5278:	06054e63          	bltz	a0,52f4 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    527c:	12c00613          	li	a2,300
    5280:	85ca                	mv	a1,s2
    5282:	8552                	mv	a0,s4
    5284:	00001097          	auipc	ra,0x1
    5288:	988080e7          	jalr	-1656(ra) # 5c0c <read>
    if(cc < 0){
    528c:	08054263          	bltz	a0,5310 <bigfile+0x13a>
    if(cc == 0)
    5290:	c971                	beqz	a0,5364 <bigfile+0x18e>
    if(cc != SZ/2){
    5292:	12c00793          	li	a5,300
    5296:	08f51b63          	bne	a0,a5,532c <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    529a:	01f4d79b          	srliw	a5,s1,0x1f
    529e:	9fa5                	addw	a5,a5,s1
    52a0:	4017d79b          	sraiw	a5,a5,0x1
    52a4:	00094703          	lbu	a4,0(s2)
    52a8:	0af71063          	bne	a4,a5,5348 <bigfile+0x172>
    52ac:	12b94703          	lbu	a4,299(s2)
    52b0:	08f71c63          	bne	a4,a5,5348 <bigfile+0x172>
    total += cc;
    52b4:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    52b8:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    52ba:	b7c9                	j	527c <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    52bc:	85d6                	mv	a1,s5
    52be:	00003517          	auipc	a0,0x3
    52c2:	ca250513          	addi	a0,a0,-862 # 7f60 <malloc+0x1f36>
    52c6:	00001097          	auipc	ra,0x1
    52ca:	ca6080e7          	jalr	-858(ra) # 5f6c <printf>
    exit(1);
    52ce:	4505                	li	a0,1
    52d0:	00001097          	auipc	ra,0x1
    52d4:	924080e7          	jalr	-1756(ra) # 5bf4 <exit>
      printf("%s: write bigfile failed\n", s);
    52d8:	85d6                	mv	a1,s5
    52da:	00003517          	auipc	a0,0x3
    52de:	ca650513          	addi	a0,a0,-858 # 7f80 <malloc+0x1f56>
    52e2:	00001097          	auipc	ra,0x1
    52e6:	c8a080e7          	jalr	-886(ra) # 5f6c <printf>
      exit(1);
    52ea:	4505                	li	a0,1
    52ec:	00001097          	auipc	ra,0x1
    52f0:	908080e7          	jalr	-1784(ra) # 5bf4 <exit>
    printf("%s: cannot open bigfile\n", s);
    52f4:	85d6                	mv	a1,s5
    52f6:	00003517          	auipc	a0,0x3
    52fa:	caa50513          	addi	a0,a0,-854 # 7fa0 <malloc+0x1f76>
    52fe:	00001097          	auipc	ra,0x1
    5302:	c6e080e7          	jalr	-914(ra) # 5f6c <printf>
    exit(1);
    5306:	4505                	li	a0,1
    5308:	00001097          	auipc	ra,0x1
    530c:	8ec080e7          	jalr	-1812(ra) # 5bf4 <exit>
      printf("%s: read bigfile failed\n", s);
    5310:	85d6                	mv	a1,s5
    5312:	00003517          	auipc	a0,0x3
    5316:	cae50513          	addi	a0,a0,-850 # 7fc0 <malloc+0x1f96>
    531a:	00001097          	auipc	ra,0x1
    531e:	c52080e7          	jalr	-942(ra) # 5f6c <printf>
      exit(1);
    5322:	4505                	li	a0,1
    5324:	00001097          	auipc	ra,0x1
    5328:	8d0080e7          	jalr	-1840(ra) # 5bf4 <exit>
      printf("%s: short read bigfile\n", s);
    532c:	85d6                	mv	a1,s5
    532e:	00003517          	auipc	a0,0x3
    5332:	cb250513          	addi	a0,a0,-846 # 7fe0 <malloc+0x1fb6>
    5336:	00001097          	auipc	ra,0x1
    533a:	c36080e7          	jalr	-970(ra) # 5f6c <printf>
      exit(1);
    533e:	4505                	li	a0,1
    5340:	00001097          	auipc	ra,0x1
    5344:	8b4080e7          	jalr	-1868(ra) # 5bf4 <exit>
      printf("%s: read bigfile wrong data\n", s);
    5348:	85d6                	mv	a1,s5
    534a:	00003517          	auipc	a0,0x3
    534e:	cae50513          	addi	a0,a0,-850 # 7ff8 <malloc+0x1fce>
    5352:	00001097          	auipc	ra,0x1
    5356:	c1a080e7          	jalr	-998(ra) # 5f6c <printf>
      exit(1);
    535a:	4505                	li	a0,1
    535c:	00001097          	auipc	ra,0x1
    5360:	898080e7          	jalr	-1896(ra) # 5bf4 <exit>
  close(fd);
    5364:	8552                	mv	a0,s4
    5366:	00001097          	auipc	ra,0x1
    536a:	8b6080e7          	jalr	-1866(ra) # 5c1c <close>
  if(total != N*SZ){
    536e:	678d                	lui	a5,0x3
    5370:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0x80>
    5374:	02f99363          	bne	s3,a5,539a <bigfile+0x1c4>
  unlink("bigfile.dat");
    5378:	00003517          	auipc	a0,0x3
    537c:	bd850513          	addi	a0,a0,-1064 # 7f50 <malloc+0x1f26>
    5380:	00001097          	auipc	ra,0x1
    5384:	8c4080e7          	jalr	-1852(ra) # 5c44 <unlink>
}
    5388:	70e2                	ld	ra,56(sp)
    538a:	7442                	ld	s0,48(sp)
    538c:	74a2                	ld	s1,40(sp)
    538e:	7902                	ld	s2,32(sp)
    5390:	69e2                	ld	s3,24(sp)
    5392:	6a42                	ld	s4,16(sp)
    5394:	6aa2                	ld	s5,8(sp)
    5396:	6121                	addi	sp,sp,64
    5398:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    539a:	85d6                	mv	a1,s5
    539c:	00003517          	auipc	a0,0x3
    53a0:	c7c50513          	addi	a0,a0,-900 # 8018 <malloc+0x1fee>
    53a4:	00001097          	auipc	ra,0x1
    53a8:	bc8080e7          	jalr	-1080(ra) # 5f6c <printf>
    exit(1);
    53ac:	4505                	li	a0,1
    53ae:	00001097          	auipc	ra,0x1
    53b2:	846080e7          	jalr	-1978(ra) # 5bf4 <exit>

00000000000053b6 <fsfull>:
{
    53b6:	7171                	addi	sp,sp,-176
    53b8:	f506                	sd	ra,168(sp)
    53ba:	f122                	sd	s0,160(sp)
    53bc:	ed26                	sd	s1,152(sp)
    53be:	e94a                	sd	s2,144(sp)
    53c0:	e54e                	sd	s3,136(sp)
    53c2:	e152                	sd	s4,128(sp)
    53c4:	fcd6                	sd	s5,120(sp)
    53c6:	f8da                	sd	s6,112(sp)
    53c8:	f4de                	sd	s7,104(sp)
    53ca:	f0e2                	sd	s8,96(sp)
    53cc:	ece6                	sd	s9,88(sp)
    53ce:	e8ea                	sd	s10,80(sp)
    53d0:	e4ee                	sd	s11,72(sp)
    53d2:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    53d4:	00003517          	auipc	a0,0x3
    53d8:	c6450513          	addi	a0,a0,-924 # 8038 <malloc+0x200e>
    53dc:	00001097          	auipc	ra,0x1
    53e0:	b90080e7          	jalr	-1136(ra) # 5f6c <printf>
  for(nfiles = 0; ; nfiles++){
    53e4:	4481                	li	s1,0
    name[0] = 'f';
    53e6:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53ea:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53ee:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    53f2:	4b29                	li	s6,10
    printf("writing %s\n", name);
    53f4:	00003c97          	auipc	s9,0x3
    53f8:	c54c8c93          	addi	s9,s9,-940 # 8048 <malloc+0x201e>
    int total = 0;
    53fc:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    53fe:	00008a17          	auipc	s4,0x8
    5402:	87aa0a13          	addi	s4,s4,-1926 # cc78 <buf>
    name[0] = 'f';
    5406:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    540a:	0384c7bb          	divw	a5,s1,s8
    540e:	0307879b          	addiw	a5,a5,48
    5412:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5416:	0384e7bb          	remw	a5,s1,s8
    541a:	0377c7bb          	divw	a5,a5,s7
    541e:	0307879b          	addiw	a5,a5,48
    5422:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5426:	0374e7bb          	remw	a5,s1,s7
    542a:	0367c7bb          	divw	a5,a5,s6
    542e:	0307879b          	addiw	a5,a5,48
    5432:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5436:	0364e7bb          	remw	a5,s1,s6
    543a:	0307879b          	addiw	a5,a5,48
    543e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5442:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    5446:	f5040593          	addi	a1,s0,-176
    544a:	8566                	mv	a0,s9
    544c:	00001097          	auipc	ra,0x1
    5450:	b20080e7          	jalr	-1248(ra) # 5f6c <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5454:	20200593          	li	a1,514
    5458:	f5040513          	addi	a0,s0,-176
    545c:	00000097          	auipc	ra,0x0
    5460:	7d8080e7          	jalr	2008(ra) # 5c34 <open>
    5464:	892a                	mv	s2,a0
    if(fd < 0){
    5466:	0a055663          	bgez	a0,5512 <fsfull+0x15c>
      printf("open %s failed\n", name);
    546a:	f5040593          	addi	a1,s0,-176
    546e:	00003517          	auipc	a0,0x3
    5472:	bea50513          	addi	a0,a0,-1046 # 8058 <malloc+0x202e>
    5476:	00001097          	auipc	ra,0x1
    547a:	af6080e7          	jalr	-1290(ra) # 5f6c <printf>
  while(nfiles >= 0){
    547e:	0604c363          	bltz	s1,54e4 <fsfull+0x12e>
    name[0] = 'f';
    5482:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5486:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    548a:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    548e:	4929                	li	s2,10
  while(nfiles >= 0){
    5490:	5afd                	li	s5,-1
    name[0] = 'f';
    5492:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5496:	0344c7bb          	divw	a5,s1,s4
    549a:	0307879b          	addiw	a5,a5,48
    549e:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    54a2:	0344e7bb          	remw	a5,s1,s4
    54a6:	0337c7bb          	divw	a5,a5,s3
    54aa:	0307879b          	addiw	a5,a5,48
    54ae:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    54b2:	0334e7bb          	remw	a5,s1,s3
    54b6:	0327c7bb          	divw	a5,a5,s2
    54ba:	0307879b          	addiw	a5,a5,48
    54be:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    54c2:	0324e7bb          	remw	a5,s1,s2
    54c6:	0307879b          	addiw	a5,a5,48
    54ca:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    54ce:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    54d2:	f5040513          	addi	a0,s0,-176
    54d6:	00000097          	auipc	ra,0x0
    54da:	76e080e7          	jalr	1902(ra) # 5c44 <unlink>
    nfiles--;
    54de:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    54e0:	fb5499e3          	bne	s1,s5,5492 <fsfull+0xdc>
  printf("fsfull test finished\n");
    54e4:	00003517          	auipc	a0,0x3
    54e8:	b9450513          	addi	a0,a0,-1132 # 8078 <malloc+0x204e>
    54ec:	00001097          	auipc	ra,0x1
    54f0:	a80080e7          	jalr	-1408(ra) # 5f6c <printf>
}
    54f4:	70aa                	ld	ra,168(sp)
    54f6:	740a                	ld	s0,160(sp)
    54f8:	64ea                	ld	s1,152(sp)
    54fa:	694a                	ld	s2,144(sp)
    54fc:	69aa                	ld	s3,136(sp)
    54fe:	6a0a                	ld	s4,128(sp)
    5500:	7ae6                	ld	s5,120(sp)
    5502:	7b46                	ld	s6,112(sp)
    5504:	7ba6                	ld	s7,104(sp)
    5506:	7c06                	ld	s8,96(sp)
    5508:	6ce6                	ld	s9,88(sp)
    550a:	6d46                	ld	s10,80(sp)
    550c:	6da6                	ld	s11,72(sp)
    550e:	614d                	addi	sp,sp,176
    5510:	8082                	ret
    int total = 0;
    5512:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    5514:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    5518:	40000613          	li	a2,1024
    551c:	85d2                	mv	a1,s4
    551e:	854a                	mv	a0,s2
    5520:	00000097          	auipc	ra,0x0
    5524:	6f4080e7          	jalr	1780(ra) # 5c14 <write>
      if(cc < BSIZE)
    5528:	00aad563          	bge	s5,a0,5532 <fsfull+0x17c>
      total += cc;
    552c:	00a989bb          	addw	s3,s3,a0
    while(1){
    5530:	b7e5                	j	5518 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    5532:	85ce                	mv	a1,s3
    5534:	00003517          	auipc	a0,0x3
    5538:	b3450513          	addi	a0,a0,-1228 # 8068 <malloc+0x203e>
    553c:	00001097          	auipc	ra,0x1
    5540:	a30080e7          	jalr	-1488(ra) # 5f6c <printf>
    close(fd);
    5544:	854a                	mv	a0,s2
    5546:	00000097          	auipc	ra,0x0
    554a:	6d6080e7          	jalr	1750(ra) # 5c1c <close>
    if(total == 0)
    554e:	f20988e3          	beqz	s3,547e <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    5552:	2485                	addiw	s1,s1,1
    5554:	bd4d                	j	5406 <fsfull+0x50>

0000000000005556 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5556:	7179                	addi	sp,sp,-48
    5558:	f406                	sd	ra,40(sp)
    555a:	f022                	sd	s0,32(sp)
    555c:	ec26                	sd	s1,24(sp)
    555e:	e84a                	sd	s2,16(sp)
    5560:	1800                	addi	s0,sp,48
    5562:	84aa                	mv	s1,a0
    5564:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5566:	00003517          	auipc	a0,0x3
    556a:	b2a50513          	addi	a0,a0,-1238 # 8090 <malloc+0x2066>
    556e:	00001097          	auipc	ra,0x1
    5572:	9fe080e7          	jalr	-1538(ra) # 5f6c <printf>
  if((pid = fork()) < 0) {
    5576:	00000097          	auipc	ra,0x0
    557a:	676080e7          	jalr	1654(ra) # 5bec <fork>
    557e:	02054e63          	bltz	a0,55ba <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5582:	c929                	beqz	a0,55d4 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5584:	fdc40513          	addi	a0,s0,-36
    5588:	00000097          	auipc	ra,0x0
    558c:	674080e7          	jalr	1652(ra) # 5bfc <wait>
    if(xstatus != 0) 
    5590:	fdc42783          	lw	a5,-36(s0)
    5594:	c7b9                	beqz	a5,55e2 <run+0x8c>
      printf("FAILED\n");
    5596:	00003517          	auipc	a0,0x3
    559a:	b2250513          	addi	a0,a0,-1246 # 80b8 <malloc+0x208e>
    559e:	00001097          	auipc	ra,0x1
    55a2:	9ce080e7          	jalr	-1586(ra) # 5f6c <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    55a6:	fdc42503          	lw	a0,-36(s0)
  }
}
    55aa:	00153513          	seqz	a0,a0
    55ae:	70a2                	ld	ra,40(sp)
    55b0:	7402                	ld	s0,32(sp)
    55b2:	64e2                	ld	s1,24(sp)
    55b4:	6942                	ld	s2,16(sp)
    55b6:	6145                	addi	sp,sp,48
    55b8:	8082                	ret
    printf("runtest: fork error\n");
    55ba:	00003517          	auipc	a0,0x3
    55be:	ae650513          	addi	a0,a0,-1306 # 80a0 <malloc+0x2076>
    55c2:	00001097          	auipc	ra,0x1
    55c6:	9aa080e7          	jalr	-1622(ra) # 5f6c <printf>
    exit(1);
    55ca:	4505                	li	a0,1
    55cc:	00000097          	auipc	ra,0x0
    55d0:	628080e7          	jalr	1576(ra) # 5bf4 <exit>
    f(s);
    55d4:	854a                	mv	a0,s2
    55d6:	9482                	jalr	s1
    exit(0);
    55d8:	4501                	li	a0,0
    55da:	00000097          	auipc	ra,0x0
    55de:	61a080e7          	jalr	1562(ra) # 5bf4 <exit>
      printf("OK\n");
    55e2:	00003517          	auipc	a0,0x3
    55e6:	ade50513          	addi	a0,a0,-1314 # 80c0 <malloc+0x2096>
    55ea:	00001097          	auipc	ra,0x1
    55ee:	982080e7          	jalr	-1662(ra) # 5f6c <printf>
    55f2:	bf55                	j	55a6 <run+0x50>

00000000000055f4 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    55f4:	7179                	addi	sp,sp,-48
    55f6:	f406                	sd	ra,40(sp)
    55f8:	f022                	sd	s0,32(sp)
    55fa:	ec26                	sd	s1,24(sp)
    55fc:	e84a                	sd	s2,16(sp)
    55fe:	e44e                	sd	s3,8(sp)
    5600:	e052                	sd	s4,0(sp)
    5602:	1800                	addi	s0,sp,48
    5604:	84aa                	mv	s1,a0
  for (struct test *t = tests; t->s != 0; t++) {
    5606:	6508                	ld	a0,8(a0)
    5608:	c931                	beqz	a0,565c <runtests+0x68>
    560a:	892e                	mv	s2,a1
    560c:	89b2                	mv	s3,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    560e:	4a09                	li	s4,2
    5610:	a021                	j	5618 <runtests+0x24>
  for (struct test *t = tests; t->s != 0; t++) {
    5612:	04c1                	addi	s1,s1,16
    5614:	6488                	ld	a0,8(s1)
    5616:	c91d                	beqz	a0,564c <runtests+0x58>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5618:	00090863          	beqz	s2,5628 <runtests+0x34>
    561c:	85ca                	mv	a1,s2
    561e:	00000097          	auipc	ra,0x0
    5622:	384080e7          	jalr	900(ra) # 59a2 <strcmp>
    5626:	f575                	bnez	a0,5612 <runtests+0x1e>
      if(!run(t->f, t->s)){
    5628:	648c                	ld	a1,8(s1)
    562a:	6088                	ld	a0,0(s1)
    562c:	00000097          	auipc	ra,0x0
    5630:	f2a080e7          	jalr	-214(ra) # 5556 <run>
    5634:	fd79                	bnez	a0,5612 <runtests+0x1e>
        if(continuous != 2){
    5636:	fd498ee3          	beq	s3,s4,5612 <runtests+0x1e>
          printf("SOME TESTS FAILED\n");
    563a:	00003517          	auipc	a0,0x3
    563e:	a8e50513          	addi	a0,a0,-1394 # 80c8 <malloc+0x209e>
    5642:	00001097          	auipc	ra,0x1
    5646:	92a080e7          	jalr	-1750(ra) # 5f6c <printf>
          return 1;
    564a:	4505                	li	a0,1
        }
      }
    }
  }
  return 0;
}
    564c:	70a2                	ld	ra,40(sp)
    564e:	7402                	ld	s0,32(sp)
    5650:	64e2                	ld	s1,24(sp)
    5652:	6942                	ld	s2,16(sp)
    5654:	69a2                	ld	s3,8(sp)
    5656:	6a02                	ld	s4,0(sp)
    5658:	6145                	addi	sp,sp,48
    565a:	8082                	ret
  return 0;
    565c:	4501                	li	a0,0
    565e:	b7fd                	j	564c <runtests+0x58>

0000000000005660 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5660:	7139                	addi	sp,sp,-64
    5662:	fc06                	sd	ra,56(sp)
    5664:	f822                	sd	s0,48(sp)
    5666:	f426                	sd	s1,40(sp)
    5668:	f04a                	sd	s2,32(sp)
    566a:	ec4e                	sd	s3,24(sp)
    566c:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    566e:	fc840513          	addi	a0,s0,-56
    5672:	00000097          	auipc	ra,0x0
    5676:	592080e7          	jalr	1426(ra) # 5c04 <pipe>
    567a:	06054763          	bltz	a0,56e8 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    567e:	00000097          	auipc	ra,0x0
    5682:	56e080e7          	jalr	1390(ra) # 5bec <fork>

  if(pid < 0){
    5686:	06054e63          	bltz	a0,5702 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    568a:	ed51                	bnez	a0,5726 <countfree+0xc6>
    close(fds[0]);
    568c:	fc842503          	lw	a0,-56(s0)
    5690:	00000097          	auipc	ra,0x0
    5694:	58c080e7          	jalr	1420(ra) # 5c1c <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5698:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    569a:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    569c:	00001997          	auipc	s3,0x1
    56a0:	b3c98993          	addi	s3,s3,-1220 # 61d8 <malloc+0x1ae>
      uint64 a = (uint64) sbrk(4096);
    56a4:	6505                	lui	a0,0x1
    56a6:	00000097          	auipc	ra,0x0
    56aa:	5d6080e7          	jalr	1494(ra) # 5c7c <sbrk>
      if(a == 0xffffffffffffffff){
    56ae:	07250763          	beq	a0,s2,571c <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    56b2:	6785                	lui	a5,0x1
    56b4:	953e                	add	a0,a0,a5
    56b6:	fe950fa3          	sb	s1,-1(a0) # fff <linktest+0x101>
      if(write(fds[1], "x", 1) != 1){
    56ba:	8626                	mv	a2,s1
    56bc:	85ce                	mv	a1,s3
    56be:	fcc42503          	lw	a0,-52(s0)
    56c2:	00000097          	auipc	ra,0x0
    56c6:	552080e7          	jalr	1362(ra) # 5c14 <write>
    56ca:	fc950de3          	beq	a0,s1,56a4 <countfree+0x44>
        printf("write() failed in countfree()\n");
    56ce:	00003517          	auipc	a0,0x3
    56d2:	a5250513          	addi	a0,a0,-1454 # 8120 <malloc+0x20f6>
    56d6:	00001097          	auipc	ra,0x1
    56da:	896080e7          	jalr	-1898(ra) # 5f6c <printf>
        exit(1);
    56de:	4505                	li	a0,1
    56e0:	00000097          	auipc	ra,0x0
    56e4:	514080e7          	jalr	1300(ra) # 5bf4 <exit>
    printf("pipe() failed in countfree()\n");
    56e8:	00003517          	auipc	a0,0x3
    56ec:	9f850513          	addi	a0,a0,-1544 # 80e0 <malloc+0x20b6>
    56f0:	00001097          	auipc	ra,0x1
    56f4:	87c080e7          	jalr	-1924(ra) # 5f6c <printf>
    exit(1);
    56f8:	4505                	li	a0,1
    56fa:	00000097          	auipc	ra,0x0
    56fe:	4fa080e7          	jalr	1274(ra) # 5bf4 <exit>
    printf("fork failed in countfree()\n");
    5702:	00003517          	auipc	a0,0x3
    5706:	9fe50513          	addi	a0,a0,-1538 # 8100 <malloc+0x20d6>
    570a:	00001097          	auipc	ra,0x1
    570e:	862080e7          	jalr	-1950(ra) # 5f6c <printf>
    exit(1);
    5712:	4505                	li	a0,1
    5714:	00000097          	auipc	ra,0x0
    5718:	4e0080e7          	jalr	1248(ra) # 5bf4 <exit>
      }
    }

    exit(0);
    571c:	4501                	li	a0,0
    571e:	00000097          	auipc	ra,0x0
    5722:	4d6080e7          	jalr	1238(ra) # 5bf4 <exit>
  }

  close(fds[1]);
    5726:	fcc42503          	lw	a0,-52(s0)
    572a:	00000097          	auipc	ra,0x0
    572e:	4f2080e7          	jalr	1266(ra) # 5c1c <close>

  int n = 0;
    5732:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5734:	4605                	li	a2,1
    5736:	fc740593          	addi	a1,s0,-57
    573a:	fc842503          	lw	a0,-56(s0)
    573e:	00000097          	auipc	ra,0x0
    5742:	4ce080e7          	jalr	1230(ra) # 5c0c <read>
    if(cc < 0){
    5746:	00054563          	bltz	a0,5750 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    574a:	c105                	beqz	a0,576a <countfree+0x10a>
      break;
    n += 1;
    574c:	2485                	addiw	s1,s1,1
  while(1){
    574e:	b7dd                	j	5734 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5750:	00003517          	auipc	a0,0x3
    5754:	9f050513          	addi	a0,a0,-1552 # 8140 <malloc+0x2116>
    5758:	00001097          	auipc	ra,0x1
    575c:	814080e7          	jalr	-2028(ra) # 5f6c <printf>
      exit(1);
    5760:	4505                	li	a0,1
    5762:	00000097          	auipc	ra,0x0
    5766:	492080e7          	jalr	1170(ra) # 5bf4 <exit>
  }

  close(fds[0]);
    576a:	fc842503          	lw	a0,-56(s0)
    576e:	00000097          	auipc	ra,0x0
    5772:	4ae080e7          	jalr	1198(ra) # 5c1c <close>
  wait((int*)0);
    5776:	4501                	li	a0,0
    5778:	00000097          	auipc	ra,0x0
    577c:	484080e7          	jalr	1156(ra) # 5bfc <wait>
  
  return n;
}
    5780:	8526                	mv	a0,s1
    5782:	70e2                	ld	ra,56(sp)
    5784:	7442                	ld	s0,48(sp)
    5786:	74a2                	ld	s1,40(sp)
    5788:	7902                	ld	s2,32(sp)
    578a:	69e2                	ld	s3,24(sp)
    578c:	6121                	addi	sp,sp,64
    578e:	8082                	ret

0000000000005790 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5790:	711d                	addi	sp,sp,-96
    5792:	ec86                	sd	ra,88(sp)
    5794:	e8a2                	sd	s0,80(sp)
    5796:	e4a6                	sd	s1,72(sp)
    5798:	e0ca                	sd	s2,64(sp)
    579a:	fc4e                	sd	s3,56(sp)
    579c:	f852                	sd	s4,48(sp)
    579e:	f456                	sd	s5,40(sp)
    57a0:	f05a                	sd	s6,32(sp)
    57a2:	ec5e                	sd	s7,24(sp)
    57a4:	e862                	sd	s8,16(sp)
    57a6:	e466                	sd	s9,8(sp)
    57a8:	e06a                	sd	s10,0(sp)
    57aa:	1080                	addi	s0,sp,96
    57ac:	8a2a                	mv	s4,a0
    57ae:	892e                	mv	s2,a1
    57b0:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    57b2:	00003b97          	auipc	s7,0x3
    57b6:	9aeb8b93          	addi	s7,s7,-1618 # 8160 <malloc+0x2136>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    57ba:	00004b17          	auipc	s6,0x4
    57be:	856b0b13          	addi	s6,s6,-1962 # 9010 <quicktests>
      if(continuous != 2) {
    57c2:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    57c4:	00003c97          	auipc	s9,0x3
    57c8:	9d4c8c93          	addi	s9,s9,-1580 # 8198 <malloc+0x216e>
      if (runtests(slowtests, justone, continuous)) {
    57cc:	00004c17          	auipc	s8,0x4
    57d0:	c14c0c13          	addi	s8,s8,-1004 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    57d4:	00003d17          	auipc	s10,0x3
    57d8:	9a4d0d13          	addi	s10,s10,-1628 # 8178 <malloc+0x214e>
    57dc:	a839                	j	57fa <drivetests+0x6a>
    57de:	856a                	mv	a0,s10
    57e0:	00000097          	auipc	ra,0x0
    57e4:	78c080e7          	jalr	1932(ra) # 5f6c <printf>
    57e8:	a089                	j	582a <drivetests+0x9a>
    if((free1 = countfree()) < free0) {
    57ea:	00000097          	auipc	ra,0x0
    57ee:	e76080e7          	jalr	-394(ra) # 5660 <countfree>
    57f2:	06954463          	blt	a0,s1,585a <drivetests+0xca>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    57f6:	08090163          	beqz	s2,5878 <drivetests+0xe8>
    printf("usertests starting\n");
    57fa:	855e                	mv	a0,s7
    57fc:	00000097          	auipc	ra,0x0
    5800:	770080e7          	jalr	1904(ra) # 5f6c <printf>
    int free0 = countfree();
    5804:	00000097          	auipc	ra,0x0
    5808:	e5c080e7          	jalr	-420(ra) # 5660 <countfree>
    580c:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    580e:	864a                	mv	a2,s2
    5810:	85ce                	mv	a1,s3
    5812:	855a                	mv	a0,s6
    5814:	00000097          	auipc	ra,0x0
    5818:	de0080e7          	jalr	-544(ra) # 55f4 <runtests>
    581c:	c119                	beqz	a0,5822 <drivetests+0x92>
      if(continuous != 2) {
    581e:	05591963          	bne	s2,s5,5870 <drivetests+0xe0>
    if(!quick) {
    5822:	fc0a14e3          	bnez	s4,57ea <drivetests+0x5a>
      if (justone == 0)
    5826:	fa098ce3          	beqz	s3,57de <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    582a:	864a                	mv	a2,s2
    582c:	85ce                	mv	a1,s3
    582e:	8562                	mv	a0,s8
    5830:	00000097          	auipc	ra,0x0
    5834:	dc4080e7          	jalr	-572(ra) # 55f4 <runtests>
    5838:	d94d                	beqz	a0,57ea <drivetests+0x5a>
        if(continuous != 2) {
    583a:	03591d63          	bne	s2,s5,5874 <drivetests+0xe4>
    if((free1 = countfree()) < free0) {
    583e:	00000097          	auipc	ra,0x0
    5842:	e22080e7          	jalr	-478(ra) # 5660 <countfree>
    5846:	fa9558e3          	bge	a0,s1,57f6 <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    584a:	8626                	mv	a2,s1
    584c:	85aa                	mv	a1,a0
    584e:	8566                	mv	a0,s9
    5850:	00000097          	auipc	ra,0x0
    5854:	71c080e7          	jalr	1820(ra) # 5f6c <printf>
      if(continuous != 2) {
    5858:	b74d                	j	57fa <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    585a:	8626                	mv	a2,s1
    585c:	85aa                	mv	a1,a0
    585e:	8566                	mv	a0,s9
    5860:	00000097          	auipc	ra,0x0
    5864:	70c080e7          	jalr	1804(ra) # 5f6c <printf>
      if(continuous != 2) {
    5868:	f95909e3          	beq	s2,s5,57fa <drivetests+0x6a>
        return 1;
    586c:	4505                	li	a0,1
    586e:	a031                	j	587a <drivetests+0xea>
        return 1;
    5870:	4505                	li	a0,1
    5872:	a021                	j	587a <drivetests+0xea>
          return 1;
    5874:	4505                	li	a0,1
    5876:	a011                	j	587a <drivetests+0xea>
  return 0;
    5878:	854a                	mv	a0,s2
}
    587a:	60e6                	ld	ra,88(sp)
    587c:	6446                	ld	s0,80(sp)
    587e:	64a6                	ld	s1,72(sp)
    5880:	6906                	ld	s2,64(sp)
    5882:	79e2                	ld	s3,56(sp)
    5884:	7a42                	ld	s4,48(sp)
    5886:	7aa2                	ld	s5,40(sp)
    5888:	7b02                	ld	s6,32(sp)
    588a:	6be2                	ld	s7,24(sp)
    588c:	6c42                	ld	s8,16(sp)
    588e:	6ca2                	ld	s9,8(sp)
    5890:	6d02                	ld	s10,0(sp)
    5892:	6125                	addi	sp,sp,96
    5894:	8082                	ret

0000000000005896 <main>:

int
main(int argc, char *argv[])
{
    5896:	1101                	addi	sp,sp,-32
    5898:	ec06                	sd	ra,24(sp)
    589a:	e822                	sd	s0,16(sp)
    589c:	e426                	sd	s1,8(sp)
    589e:	e04a                	sd	s2,0(sp)
    58a0:	1000                	addi	s0,sp,32
    58a2:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58a4:	4789                	li	a5,2
    58a6:	02f50363          	beq	a0,a5,58cc <main+0x36>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    58aa:	4785                	li	a5,1
    58ac:	06a7cd63          	blt	a5,a0,5926 <main+0x90>
  char *justone = 0;
    58b0:	4601                	li	a2,0
  int quick = 0;
    58b2:	4501                	li	a0,0
  int continuous = 0;
    58b4:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    58b6:	85a6                	mv	a1,s1
    58b8:	00000097          	auipc	ra,0x0
    58bc:	ed8080e7          	jalr	-296(ra) # 5790 <drivetests>
    58c0:	c949                	beqz	a0,5952 <main+0xbc>
    exit(1);
    58c2:	4505                	li	a0,1
    58c4:	00000097          	auipc	ra,0x0
    58c8:	330080e7          	jalr	816(ra) # 5bf4 <exit>
    58cc:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58ce:	00003597          	auipc	a1,0x3
    58d2:	8fa58593          	addi	a1,a1,-1798 # 81c8 <malloc+0x219e>
    58d6:	00893503          	ld	a0,8(s2)
    58da:	00000097          	auipc	ra,0x0
    58de:	0c8080e7          	jalr	200(ra) # 59a2 <strcmp>
    58e2:	cd39                	beqz	a0,5940 <main+0xaa>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    58e4:	00003597          	auipc	a1,0x3
    58e8:	93c58593          	addi	a1,a1,-1732 # 8220 <malloc+0x21f6>
    58ec:	00893503          	ld	a0,8(s2)
    58f0:	00000097          	auipc	ra,0x0
    58f4:	0b2080e7          	jalr	178(ra) # 59a2 <strcmp>
    58f8:	c931                	beqz	a0,594c <main+0xb6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    58fa:	00003597          	auipc	a1,0x3
    58fe:	91e58593          	addi	a1,a1,-1762 # 8218 <malloc+0x21ee>
    5902:	00893503          	ld	a0,8(s2)
    5906:	00000097          	auipc	ra,0x0
    590a:	09c080e7          	jalr	156(ra) # 59a2 <strcmp>
    590e:	cd0d                	beqz	a0,5948 <main+0xb2>
  } else if(argc == 2 && argv[1][0] != '-'){
    5910:	00893603          	ld	a2,8(s2)
    5914:	00064703          	lbu	a4,0(a2) # 3000 <execout+0x98>
    5918:	02d00793          	li	a5,45
    591c:	00f70563          	beq	a4,a5,5926 <main+0x90>
  int quick = 0;
    5920:	4501                	li	a0,0
  int continuous = 0;
    5922:	4481                	li	s1,0
    5924:	bf49                	j	58b6 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5926:	00003517          	auipc	a0,0x3
    592a:	8aa50513          	addi	a0,a0,-1878 # 81d0 <malloc+0x21a6>
    592e:	00000097          	auipc	ra,0x0
    5932:	63e080e7          	jalr	1598(ra) # 5f6c <printf>
    exit(1);
    5936:	4505                	li	a0,1
    5938:	00000097          	auipc	ra,0x0
    593c:	2bc080e7          	jalr	700(ra) # 5bf4 <exit>
  int continuous = 0;
    5940:	84aa                	mv	s1,a0
  char *justone = 0;
    5942:	4601                	li	a2,0
    quick = 1;
    5944:	4505                	li	a0,1
    5946:	bf85                	j	58b6 <main+0x20>
  char *justone = 0;
    5948:	4601                	li	a2,0
    594a:	b7b5                	j	58b6 <main+0x20>
    594c:	4601                	li	a2,0
    continuous = 1;
    594e:	4485                	li	s1,1
    5950:	b79d                	j	58b6 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5952:	00003517          	auipc	a0,0x3
    5956:	8ae50513          	addi	a0,a0,-1874 # 8200 <malloc+0x21d6>
    595a:	00000097          	auipc	ra,0x0
    595e:	612080e7          	jalr	1554(ra) # 5f6c <printf>
  exit(0);
    5962:	4501                	li	a0,0
    5964:	00000097          	auipc	ra,0x0
    5968:	290080e7          	jalr	656(ra) # 5bf4 <exit>

000000000000596c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    596c:	1141                	addi	sp,sp,-16
    596e:	e406                	sd	ra,8(sp)
    5970:	e022                	sd	s0,0(sp)
    5972:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5974:	00000097          	auipc	ra,0x0
    5978:	f22080e7          	jalr	-222(ra) # 5896 <main>
  exit(0);
    597c:	4501                	li	a0,0
    597e:	00000097          	auipc	ra,0x0
    5982:	276080e7          	jalr	630(ra) # 5bf4 <exit>

0000000000005986 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5986:	1141                	addi	sp,sp,-16
    5988:	e422                	sd	s0,8(sp)
    598a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    598c:	87aa                	mv	a5,a0
    598e:	0585                	addi	a1,a1,1
    5990:	0785                	addi	a5,a5,1
    5992:	fff5c703          	lbu	a4,-1(a1)
    5996:	fee78fa3          	sb	a4,-1(a5) # fff <linktest+0x101>
    599a:	fb75                	bnez	a4,598e <strcpy+0x8>
    ;
  return os;
}
    599c:	6422                	ld	s0,8(sp)
    599e:	0141                	addi	sp,sp,16
    59a0:	8082                	ret

00000000000059a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    59a2:	1141                	addi	sp,sp,-16
    59a4:	e422                	sd	s0,8(sp)
    59a6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    59a8:	00054783          	lbu	a5,0(a0)
    59ac:	cb91                	beqz	a5,59c0 <strcmp+0x1e>
    59ae:	0005c703          	lbu	a4,0(a1)
    59b2:	00f71763          	bne	a4,a5,59c0 <strcmp+0x1e>
    p++, q++;
    59b6:	0505                	addi	a0,a0,1
    59b8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    59ba:	00054783          	lbu	a5,0(a0)
    59be:	fbe5                	bnez	a5,59ae <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    59c0:	0005c503          	lbu	a0,0(a1)
}
    59c4:	40a7853b          	subw	a0,a5,a0
    59c8:	6422                	ld	s0,8(sp)
    59ca:	0141                	addi	sp,sp,16
    59cc:	8082                	ret

00000000000059ce <strlen>:

uint
strlen(const char *s)
{
    59ce:	1141                	addi	sp,sp,-16
    59d0:	e422                	sd	s0,8(sp)
    59d2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    59d4:	00054783          	lbu	a5,0(a0)
    59d8:	cf91                	beqz	a5,59f4 <strlen+0x26>
    59da:	0505                	addi	a0,a0,1
    59dc:	87aa                	mv	a5,a0
    59de:	4685                	li	a3,1
    59e0:	9e89                	subw	a3,a3,a0
    59e2:	00f6853b          	addw	a0,a3,a5
    59e6:	0785                	addi	a5,a5,1
    59e8:	fff7c703          	lbu	a4,-1(a5)
    59ec:	fb7d                	bnez	a4,59e2 <strlen+0x14>
    ;
  return n;
}
    59ee:	6422                	ld	s0,8(sp)
    59f0:	0141                	addi	sp,sp,16
    59f2:	8082                	ret
  for(n = 0; s[n]; n++)
    59f4:	4501                	li	a0,0
    59f6:	bfe5                	j	59ee <strlen+0x20>

00000000000059f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    59f8:	1141                	addi	sp,sp,-16
    59fa:	e422                	sd	s0,8(sp)
    59fc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    59fe:	ca19                	beqz	a2,5a14 <memset+0x1c>
    5a00:	87aa                	mv	a5,a0
    5a02:	1602                	slli	a2,a2,0x20
    5a04:	9201                	srli	a2,a2,0x20
    5a06:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5a0a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5a0e:	0785                	addi	a5,a5,1
    5a10:	fee79de3          	bne	a5,a4,5a0a <memset+0x12>
  }
  return dst;
}
    5a14:	6422                	ld	s0,8(sp)
    5a16:	0141                	addi	sp,sp,16
    5a18:	8082                	ret

0000000000005a1a <strchr>:

char*
strchr(const char *s, char c)
{
    5a1a:	1141                	addi	sp,sp,-16
    5a1c:	e422                	sd	s0,8(sp)
    5a1e:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5a20:	00054783          	lbu	a5,0(a0)
    5a24:	cb99                	beqz	a5,5a3a <strchr+0x20>
    if(*s == c)
    5a26:	00f58763          	beq	a1,a5,5a34 <strchr+0x1a>
  for(; *s; s++)
    5a2a:	0505                	addi	a0,a0,1
    5a2c:	00054783          	lbu	a5,0(a0)
    5a30:	fbfd                	bnez	a5,5a26 <strchr+0xc>
      return (char*)s;
  return 0;
    5a32:	4501                	li	a0,0
}
    5a34:	6422                	ld	s0,8(sp)
    5a36:	0141                	addi	sp,sp,16
    5a38:	8082                	ret
  return 0;
    5a3a:	4501                	li	a0,0
    5a3c:	bfe5                	j	5a34 <strchr+0x1a>

0000000000005a3e <gets>:

char*
gets(char *buf, int max)
{
    5a3e:	711d                	addi	sp,sp,-96
    5a40:	ec86                	sd	ra,88(sp)
    5a42:	e8a2                	sd	s0,80(sp)
    5a44:	e4a6                	sd	s1,72(sp)
    5a46:	e0ca                	sd	s2,64(sp)
    5a48:	fc4e                	sd	s3,56(sp)
    5a4a:	f852                	sd	s4,48(sp)
    5a4c:	f456                	sd	s5,40(sp)
    5a4e:	f05a                	sd	s6,32(sp)
    5a50:	ec5e                	sd	s7,24(sp)
    5a52:	1080                	addi	s0,sp,96
    5a54:	8baa                	mv	s7,a0
    5a56:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a58:	892a                	mv	s2,a0
    5a5a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a5c:	4aa9                	li	s5,10
    5a5e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a60:	89a6                	mv	s3,s1
    5a62:	2485                	addiw	s1,s1,1
    5a64:	0344d863          	bge	s1,s4,5a94 <gets+0x56>
    cc = read(0, &c, 1);
    5a68:	4605                	li	a2,1
    5a6a:	faf40593          	addi	a1,s0,-81
    5a6e:	4501                	li	a0,0
    5a70:	00000097          	auipc	ra,0x0
    5a74:	19c080e7          	jalr	412(ra) # 5c0c <read>
    if(cc < 1)
    5a78:	00a05e63          	blez	a0,5a94 <gets+0x56>
    buf[i++] = c;
    5a7c:	faf44783          	lbu	a5,-81(s0)
    5a80:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a84:	01578763          	beq	a5,s5,5a92 <gets+0x54>
    5a88:	0905                	addi	s2,s2,1
    5a8a:	fd679be3          	bne	a5,s6,5a60 <gets+0x22>
  for(i=0; i+1 < max; ){
    5a8e:	89a6                	mv	s3,s1
    5a90:	a011                	j	5a94 <gets+0x56>
    5a92:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a94:	99de                	add	s3,s3,s7
    5a96:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a9a:	855e                	mv	a0,s7
    5a9c:	60e6                	ld	ra,88(sp)
    5a9e:	6446                	ld	s0,80(sp)
    5aa0:	64a6                	ld	s1,72(sp)
    5aa2:	6906                	ld	s2,64(sp)
    5aa4:	79e2                	ld	s3,56(sp)
    5aa6:	7a42                	ld	s4,48(sp)
    5aa8:	7aa2                	ld	s5,40(sp)
    5aaa:	7b02                	ld	s6,32(sp)
    5aac:	6be2                	ld	s7,24(sp)
    5aae:	6125                	addi	sp,sp,96
    5ab0:	8082                	ret

0000000000005ab2 <stat>:

int
stat(const char *n, struct stat *st)
{
    5ab2:	1101                	addi	sp,sp,-32
    5ab4:	ec06                	sd	ra,24(sp)
    5ab6:	e822                	sd	s0,16(sp)
    5ab8:	e426                	sd	s1,8(sp)
    5aba:	e04a                	sd	s2,0(sp)
    5abc:	1000                	addi	s0,sp,32
    5abe:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5ac0:	4581                	li	a1,0
    5ac2:	00000097          	auipc	ra,0x0
    5ac6:	172080e7          	jalr	370(ra) # 5c34 <open>
  if(fd < 0)
    5aca:	02054563          	bltz	a0,5af4 <stat+0x42>
    5ace:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5ad0:	85ca                	mv	a1,s2
    5ad2:	00000097          	auipc	ra,0x0
    5ad6:	17a080e7          	jalr	378(ra) # 5c4c <fstat>
    5ada:	892a                	mv	s2,a0
  close(fd);
    5adc:	8526                	mv	a0,s1
    5ade:	00000097          	auipc	ra,0x0
    5ae2:	13e080e7          	jalr	318(ra) # 5c1c <close>
  return r;
}
    5ae6:	854a                	mv	a0,s2
    5ae8:	60e2                	ld	ra,24(sp)
    5aea:	6442                	ld	s0,16(sp)
    5aec:	64a2                	ld	s1,8(sp)
    5aee:	6902                	ld	s2,0(sp)
    5af0:	6105                	addi	sp,sp,32
    5af2:	8082                	ret
    return -1;
    5af4:	597d                	li	s2,-1
    5af6:	bfc5                	j	5ae6 <stat+0x34>

0000000000005af8 <atoi>:

int
atoi(const char *s)
{
    5af8:	1141                	addi	sp,sp,-16
    5afa:	e422                	sd	s0,8(sp)
    5afc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5afe:	00054603          	lbu	a2,0(a0)
    5b02:	fd06079b          	addiw	a5,a2,-48
    5b06:	0ff7f793          	zext.b	a5,a5
    5b0a:	4725                	li	a4,9
    5b0c:	02f76963          	bltu	a4,a5,5b3e <atoi+0x46>
    5b10:	86aa                	mv	a3,a0
  n = 0;
    5b12:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5b14:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5b16:	0685                	addi	a3,a3,1
    5b18:	0025179b          	slliw	a5,a0,0x2
    5b1c:	9fa9                	addw	a5,a5,a0
    5b1e:	0017979b          	slliw	a5,a5,0x1
    5b22:	9fb1                	addw	a5,a5,a2
    5b24:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5b28:	0006c603          	lbu	a2,0(a3)
    5b2c:	fd06071b          	addiw	a4,a2,-48
    5b30:	0ff77713          	zext.b	a4,a4
    5b34:	fee5f1e3          	bgeu	a1,a4,5b16 <atoi+0x1e>
  return n;
}
    5b38:	6422                	ld	s0,8(sp)
    5b3a:	0141                	addi	sp,sp,16
    5b3c:	8082                	ret
  n = 0;
    5b3e:	4501                	li	a0,0
    5b40:	bfe5                	j	5b38 <atoi+0x40>

0000000000005b42 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b42:	1141                	addi	sp,sp,-16
    5b44:	e422                	sd	s0,8(sp)
    5b46:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b48:	02b57463          	bgeu	a0,a1,5b70 <memmove+0x2e>
    while(n-- > 0)
    5b4c:	00c05f63          	blez	a2,5b6a <memmove+0x28>
    5b50:	1602                	slli	a2,a2,0x20
    5b52:	9201                	srli	a2,a2,0x20
    5b54:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b58:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b5a:	0585                	addi	a1,a1,1
    5b5c:	0705                	addi	a4,a4,1
    5b5e:	fff5c683          	lbu	a3,-1(a1)
    5b62:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b66:	fee79ae3          	bne	a5,a4,5b5a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b6a:	6422                	ld	s0,8(sp)
    5b6c:	0141                	addi	sp,sp,16
    5b6e:	8082                	ret
    dst += n;
    5b70:	00c50733          	add	a4,a0,a2
    src += n;
    5b74:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b76:	fec05ae3          	blez	a2,5b6a <memmove+0x28>
    5b7a:	fff6079b          	addiw	a5,a2,-1
    5b7e:	1782                	slli	a5,a5,0x20
    5b80:	9381                	srli	a5,a5,0x20
    5b82:	fff7c793          	not	a5,a5
    5b86:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b88:	15fd                	addi	a1,a1,-1
    5b8a:	177d                	addi	a4,a4,-1
    5b8c:	0005c683          	lbu	a3,0(a1)
    5b90:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b94:	fee79ae3          	bne	a5,a4,5b88 <memmove+0x46>
    5b98:	bfc9                	j	5b6a <memmove+0x28>

0000000000005b9a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b9a:	1141                	addi	sp,sp,-16
    5b9c:	e422                	sd	s0,8(sp)
    5b9e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5ba0:	ca05                	beqz	a2,5bd0 <memcmp+0x36>
    5ba2:	fff6069b          	addiw	a3,a2,-1
    5ba6:	1682                	slli	a3,a3,0x20
    5ba8:	9281                	srli	a3,a3,0x20
    5baa:	0685                	addi	a3,a3,1
    5bac:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5bae:	00054783          	lbu	a5,0(a0)
    5bb2:	0005c703          	lbu	a4,0(a1)
    5bb6:	00e79863          	bne	a5,a4,5bc6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5bba:	0505                	addi	a0,a0,1
    p2++;
    5bbc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5bbe:	fed518e3          	bne	a0,a3,5bae <memcmp+0x14>
  }
  return 0;
    5bc2:	4501                	li	a0,0
    5bc4:	a019                	j	5bca <memcmp+0x30>
      return *p1 - *p2;
    5bc6:	40e7853b          	subw	a0,a5,a4
}
    5bca:	6422                	ld	s0,8(sp)
    5bcc:	0141                	addi	sp,sp,16
    5bce:	8082                	ret
  return 0;
    5bd0:	4501                	li	a0,0
    5bd2:	bfe5                	j	5bca <memcmp+0x30>

0000000000005bd4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5bd4:	1141                	addi	sp,sp,-16
    5bd6:	e406                	sd	ra,8(sp)
    5bd8:	e022                	sd	s0,0(sp)
    5bda:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5bdc:	00000097          	auipc	ra,0x0
    5be0:	f66080e7          	jalr	-154(ra) # 5b42 <memmove>
}
    5be4:	60a2                	ld	ra,8(sp)
    5be6:	6402                	ld	s0,0(sp)
    5be8:	0141                	addi	sp,sp,16
    5bea:	8082                	ret

0000000000005bec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5bec:	4885                	li	a7,1
 ecall
    5bee:	00000073          	ecall
 ret
    5bf2:	8082                	ret

0000000000005bf4 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5bf4:	4889                	li	a7,2
 ecall
    5bf6:	00000073          	ecall
 ret
    5bfa:	8082                	ret

0000000000005bfc <wait>:
.global wait
wait:
 li a7, SYS_wait
    5bfc:	488d                	li	a7,3
 ecall
    5bfe:	00000073          	ecall
 ret
    5c02:	8082                	ret

0000000000005c04 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5c04:	4891                	li	a7,4
 ecall
    5c06:	00000073          	ecall
 ret
    5c0a:	8082                	ret

0000000000005c0c <read>:
.global read
read:
 li a7, SYS_read
    5c0c:	4895                	li	a7,5
 ecall
    5c0e:	00000073          	ecall
 ret
    5c12:	8082                	ret

0000000000005c14 <write>:
.global write
write:
 li a7, SYS_write
    5c14:	48c1                	li	a7,16
 ecall
    5c16:	00000073          	ecall
 ret
    5c1a:	8082                	ret

0000000000005c1c <close>:
.global close
close:
 li a7, SYS_close
    5c1c:	48d5                	li	a7,21
 ecall
    5c1e:	00000073          	ecall
 ret
    5c22:	8082                	ret

0000000000005c24 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5c24:	4899                	li	a7,6
 ecall
    5c26:	00000073          	ecall
 ret
    5c2a:	8082                	ret

0000000000005c2c <exec>:
.global exec
exec:
 li a7, SYS_exec
    5c2c:	489d                	li	a7,7
 ecall
    5c2e:	00000073          	ecall
 ret
    5c32:	8082                	ret

0000000000005c34 <open>:
.global open
open:
 li a7, SYS_open
    5c34:	48bd                	li	a7,15
 ecall
    5c36:	00000073          	ecall
 ret
    5c3a:	8082                	ret

0000000000005c3c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c3c:	48c5                	li	a7,17
 ecall
    5c3e:	00000073          	ecall
 ret
    5c42:	8082                	ret

0000000000005c44 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c44:	48c9                	li	a7,18
 ecall
    5c46:	00000073          	ecall
 ret
    5c4a:	8082                	ret

0000000000005c4c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c4c:	48a1                	li	a7,8
 ecall
    5c4e:	00000073          	ecall
 ret
    5c52:	8082                	ret

0000000000005c54 <link>:
.global link
link:
 li a7, SYS_link
    5c54:	48cd                	li	a7,19
 ecall
    5c56:	00000073          	ecall
 ret
    5c5a:	8082                	ret

0000000000005c5c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c5c:	48d1                	li	a7,20
 ecall
    5c5e:	00000073          	ecall
 ret
    5c62:	8082                	ret

0000000000005c64 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c64:	48a5                	li	a7,9
 ecall
    5c66:	00000073          	ecall
 ret
    5c6a:	8082                	ret

0000000000005c6c <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c6c:	48a9                	li	a7,10
 ecall
    5c6e:	00000073          	ecall
 ret
    5c72:	8082                	ret

0000000000005c74 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c74:	48ad                	li	a7,11
 ecall
    5c76:	00000073          	ecall
 ret
    5c7a:	8082                	ret

0000000000005c7c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c7c:	48b1                	li	a7,12
 ecall
    5c7e:	00000073          	ecall
 ret
    5c82:	8082                	ret

0000000000005c84 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c84:	48b5                	li	a7,13
 ecall
    5c86:	00000073          	ecall
 ret
    5c8a:	8082                	ret

0000000000005c8c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c8c:	48b9                	li	a7,14
 ecall
    5c8e:	00000073          	ecall
 ret
    5c92:	8082                	ret

0000000000005c94 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c94:	1101                	addi	sp,sp,-32
    5c96:	ec06                	sd	ra,24(sp)
    5c98:	e822                	sd	s0,16(sp)
    5c9a:	1000                	addi	s0,sp,32
    5c9c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5ca0:	4605                	li	a2,1
    5ca2:	fef40593          	addi	a1,s0,-17
    5ca6:	00000097          	auipc	ra,0x0
    5caa:	f6e080e7          	jalr	-146(ra) # 5c14 <write>
}
    5cae:	60e2                	ld	ra,24(sp)
    5cb0:	6442                	ld	s0,16(sp)
    5cb2:	6105                	addi	sp,sp,32
    5cb4:	8082                	ret

0000000000005cb6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5cb6:	7139                	addi	sp,sp,-64
    5cb8:	fc06                	sd	ra,56(sp)
    5cba:	f822                	sd	s0,48(sp)
    5cbc:	f426                	sd	s1,40(sp)
    5cbe:	f04a                	sd	s2,32(sp)
    5cc0:	ec4e                	sd	s3,24(sp)
    5cc2:	0080                	addi	s0,sp,64
    5cc4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5cc6:	c299                	beqz	a3,5ccc <printint+0x16>
    5cc8:	0805c863          	bltz	a1,5d58 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5ccc:	2581                	sext.w	a1,a1
  neg = 0;
    5cce:	4881                	li	a7,0
    5cd0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5cd4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5cd6:	2601                	sext.w	a2,a2
    5cd8:	00003517          	auipc	a0,0x3
    5cdc:	8b850513          	addi	a0,a0,-1864 # 8590 <digits>
    5ce0:	883a                	mv	a6,a4
    5ce2:	2705                	addiw	a4,a4,1
    5ce4:	02c5f7bb          	remuw	a5,a1,a2
    5ce8:	1782                	slli	a5,a5,0x20
    5cea:	9381                	srli	a5,a5,0x20
    5cec:	97aa                	add	a5,a5,a0
    5cee:	0007c783          	lbu	a5,0(a5)
    5cf2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5cf6:	0005879b          	sext.w	a5,a1
    5cfa:	02c5d5bb          	divuw	a1,a1,a2
    5cfe:	0685                	addi	a3,a3,1
    5d00:	fec7f0e3          	bgeu	a5,a2,5ce0 <printint+0x2a>
  if(neg)
    5d04:	00088b63          	beqz	a7,5d1a <printint+0x64>
    buf[i++] = '-';
    5d08:	fd040793          	addi	a5,s0,-48
    5d0c:	973e                	add	a4,a4,a5
    5d0e:	02d00793          	li	a5,45
    5d12:	fef70823          	sb	a5,-16(a4)
    5d16:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5d1a:	02e05863          	blez	a4,5d4a <printint+0x94>
    5d1e:	fc040793          	addi	a5,s0,-64
    5d22:	00e78933          	add	s2,a5,a4
    5d26:	fff78993          	addi	s3,a5,-1
    5d2a:	99ba                	add	s3,s3,a4
    5d2c:	377d                	addiw	a4,a4,-1
    5d2e:	1702                	slli	a4,a4,0x20
    5d30:	9301                	srli	a4,a4,0x20
    5d32:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d36:	fff94583          	lbu	a1,-1(s2)
    5d3a:	8526                	mv	a0,s1
    5d3c:	00000097          	auipc	ra,0x0
    5d40:	f58080e7          	jalr	-168(ra) # 5c94 <putc>
  while(--i >= 0)
    5d44:	197d                	addi	s2,s2,-1
    5d46:	ff3918e3          	bne	s2,s3,5d36 <printint+0x80>
}
    5d4a:	70e2                	ld	ra,56(sp)
    5d4c:	7442                	ld	s0,48(sp)
    5d4e:	74a2                	ld	s1,40(sp)
    5d50:	7902                	ld	s2,32(sp)
    5d52:	69e2                	ld	s3,24(sp)
    5d54:	6121                	addi	sp,sp,64
    5d56:	8082                	ret
    x = -xx;
    5d58:	40b005bb          	negw	a1,a1
    neg = 1;
    5d5c:	4885                	li	a7,1
    x = -xx;
    5d5e:	bf8d                	j	5cd0 <printint+0x1a>

0000000000005d60 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d60:	7119                	addi	sp,sp,-128
    5d62:	fc86                	sd	ra,120(sp)
    5d64:	f8a2                	sd	s0,112(sp)
    5d66:	f4a6                	sd	s1,104(sp)
    5d68:	f0ca                	sd	s2,96(sp)
    5d6a:	ecce                	sd	s3,88(sp)
    5d6c:	e8d2                	sd	s4,80(sp)
    5d6e:	e4d6                	sd	s5,72(sp)
    5d70:	e0da                	sd	s6,64(sp)
    5d72:	fc5e                	sd	s7,56(sp)
    5d74:	f862                	sd	s8,48(sp)
    5d76:	f466                	sd	s9,40(sp)
    5d78:	f06a                	sd	s10,32(sp)
    5d7a:	ec6e                	sd	s11,24(sp)
    5d7c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d7e:	0005c903          	lbu	s2,0(a1)
    5d82:	18090f63          	beqz	s2,5f20 <vprintf+0x1c0>
    5d86:	8aaa                	mv	s5,a0
    5d88:	8b32                	mv	s6,a2
    5d8a:	00158493          	addi	s1,a1,1
  state = 0;
    5d8e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d90:	02500a13          	li	s4,37
      if(c == 'd'){
    5d94:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5d98:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5d9c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5da0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5da4:	00002b97          	auipc	s7,0x2
    5da8:	7ecb8b93          	addi	s7,s7,2028 # 8590 <digits>
    5dac:	a839                	j	5dca <vprintf+0x6a>
        putc(fd, c);
    5dae:	85ca                	mv	a1,s2
    5db0:	8556                	mv	a0,s5
    5db2:	00000097          	auipc	ra,0x0
    5db6:	ee2080e7          	jalr	-286(ra) # 5c94 <putc>
    5dba:	a019                	j	5dc0 <vprintf+0x60>
    } else if(state == '%'){
    5dbc:	01498f63          	beq	s3,s4,5dda <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5dc0:	0485                	addi	s1,s1,1
    5dc2:	fff4c903          	lbu	s2,-1(s1)
    5dc6:	14090d63          	beqz	s2,5f20 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5dca:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5dce:	fe0997e3          	bnez	s3,5dbc <vprintf+0x5c>
      if(c == '%'){
    5dd2:	fd479ee3          	bne	a5,s4,5dae <vprintf+0x4e>
        state = '%';
    5dd6:	89be                	mv	s3,a5
    5dd8:	b7e5                	j	5dc0 <vprintf+0x60>
      if(c == 'd'){
    5dda:	05878063          	beq	a5,s8,5e1a <vprintf+0xba>
      } else if(c == 'l') {
    5dde:	05978c63          	beq	a5,s9,5e36 <vprintf+0xd6>
      } else if(c == 'x') {
    5de2:	07a78863          	beq	a5,s10,5e52 <vprintf+0xf2>
      } else if(c == 'p') {
    5de6:	09b78463          	beq	a5,s11,5e6e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5dea:	07300713          	li	a4,115
    5dee:	0ce78663          	beq	a5,a4,5eba <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5df2:	06300713          	li	a4,99
    5df6:	0ee78e63          	beq	a5,a4,5ef2 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5dfa:	11478863          	beq	a5,s4,5f0a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5dfe:	85d2                	mv	a1,s4
    5e00:	8556                	mv	a0,s5
    5e02:	00000097          	auipc	ra,0x0
    5e06:	e92080e7          	jalr	-366(ra) # 5c94 <putc>
        putc(fd, c);
    5e0a:	85ca                	mv	a1,s2
    5e0c:	8556                	mv	a0,s5
    5e0e:	00000097          	auipc	ra,0x0
    5e12:	e86080e7          	jalr	-378(ra) # 5c94 <putc>
      }
      state = 0;
    5e16:	4981                	li	s3,0
    5e18:	b765                	j	5dc0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5e1a:	008b0913          	addi	s2,s6,8
    5e1e:	4685                	li	a3,1
    5e20:	4629                	li	a2,10
    5e22:	000b2583          	lw	a1,0(s6)
    5e26:	8556                	mv	a0,s5
    5e28:	00000097          	auipc	ra,0x0
    5e2c:	e8e080e7          	jalr	-370(ra) # 5cb6 <printint>
    5e30:	8b4a                	mv	s6,s2
      state = 0;
    5e32:	4981                	li	s3,0
    5e34:	b771                	j	5dc0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e36:	008b0913          	addi	s2,s6,8
    5e3a:	4681                	li	a3,0
    5e3c:	4629                	li	a2,10
    5e3e:	000b2583          	lw	a1,0(s6)
    5e42:	8556                	mv	a0,s5
    5e44:	00000097          	auipc	ra,0x0
    5e48:	e72080e7          	jalr	-398(ra) # 5cb6 <printint>
    5e4c:	8b4a                	mv	s6,s2
      state = 0;
    5e4e:	4981                	li	s3,0
    5e50:	bf85                	j	5dc0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5e52:	008b0913          	addi	s2,s6,8
    5e56:	4681                	li	a3,0
    5e58:	4641                	li	a2,16
    5e5a:	000b2583          	lw	a1,0(s6)
    5e5e:	8556                	mv	a0,s5
    5e60:	00000097          	auipc	ra,0x0
    5e64:	e56080e7          	jalr	-426(ra) # 5cb6 <printint>
    5e68:	8b4a                	mv	s6,s2
      state = 0;
    5e6a:	4981                	li	s3,0
    5e6c:	bf91                	j	5dc0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5e6e:	008b0793          	addi	a5,s6,8
    5e72:	f8f43423          	sd	a5,-120(s0)
    5e76:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5e7a:	03000593          	li	a1,48
    5e7e:	8556                	mv	a0,s5
    5e80:	00000097          	auipc	ra,0x0
    5e84:	e14080e7          	jalr	-492(ra) # 5c94 <putc>
  putc(fd, 'x');
    5e88:	85ea                	mv	a1,s10
    5e8a:	8556                	mv	a0,s5
    5e8c:	00000097          	auipc	ra,0x0
    5e90:	e08080e7          	jalr	-504(ra) # 5c94 <putc>
    5e94:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e96:	03c9d793          	srli	a5,s3,0x3c
    5e9a:	97de                	add	a5,a5,s7
    5e9c:	0007c583          	lbu	a1,0(a5)
    5ea0:	8556                	mv	a0,s5
    5ea2:	00000097          	auipc	ra,0x0
    5ea6:	df2080e7          	jalr	-526(ra) # 5c94 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5eaa:	0992                	slli	s3,s3,0x4
    5eac:	397d                	addiw	s2,s2,-1
    5eae:	fe0914e3          	bnez	s2,5e96 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5eb2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5eb6:	4981                	li	s3,0
    5eb8:	b721                	j	5dc0 <vprintf+0x60>
        s = va_arg(ap, char*);
    5eba:	008b0993          	addi	s3,s6,8
    5ebe:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5ec2:	02090163          	beqz	s2,5ee4 <vprintf+0x184>
        while(*s != 0){
    5ec6:	00094583          	lbu	a1,0(s2)
    5eca:	c9a1                	beqz	a1,5f1a <vprintf+0x1ba>
          putc(fd, *s);
    5ecc:	8556                	mv	a0,s5
    5ece:	00000097          	auipc	ra,0x0
    5ed2:	dc6080e7          	jalr	-570(ra) # 5c94 <putc>
          s++;
    5ed6:	0905                	addi	s2,s2,1
        while(*s != 0){
    5ed8:	00094583          	lbu	a1,0(s2)
    5edc:	f9e5                	bnez	a1,5ecc <vprintf+0x16c>
        s = va_arg(ap, char*);
    5ede:	8b4e                	mv	s6,s3
      state = 0;
    5ee0:	4981                	li	s3,0
    5ee2:	bdf9                	j	5dc0 <vprintf+0x60>
          s = "(null)";
    5ee4:	00002917          	auipc	s2,0x2
    5ee8:	6a490913          	addi	s2,s2,1700 # 8588 <malloc+0x255e>
        while(*s != 0){
    5eec:	02800593          	li	a1,40
    5ef0:	bff1                	j	5ecc <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5ef2:	008b0913          	addi	s2,s6,8
    5ef6:	000b4583          	lbu	a1,0(s6)
    5efa:	8556                	mv	a0,s5
    5efc:	00000097          	auipc	ra,0x0
    5f00:	d98080e7          	jalr	-616(ra) # 5c94 <putc>
    5f04:	8b4a                	mv	s6,s2
      state = 0;
    5f06:	4981                	li	s3,0
    5f08:	bd65                	j	5dc0 <vprintf+0x60>
        putc(fd, c);
    5f0a:	85d2                	mv	a1,s4
    5f0c:	8556                	mv	a0,s5
    5f0e:	00000097          	auipc	ra,0x0
    5f12:	d86080e7          	jalr	-634(ra) # 5c94 <putc>
      state = 0;
    5f16:	4981                	li	s3,0
    5f18:	b565                	j	5dc0 <vprintf+0x60>
        s = va_arg(ap, char*);
    5f1a:	8b4e                	mv	s6,s3
      state = 0;
    5f1c:	4981                	li	s3,0
    5f1e:	b54d                	j	5dc0 <vprintf+0x60>
    }
  }
}
    5f20:	70e6                	ld	ra,120(sp)
    5f22:	7446                	ld	s0,112(sp)
    5f24:	74a6                	ld	s1,104(sp)
    5f26:	7906                	ld	s2,96(sp)
    5f28:	69e6                	ld	s3,88(sp)
    5f2a:	6a46                	ld	s4,80(sp)
    5f2c:	6aa6                	ld	s5,72(sp)
    5f2e:	6b06                	ld	s6,64(sp)
    5f30:	7be2                	ld	s7,56(sp)
    5f32:	7c42                	ld	s8,48(sp)
    5f34:	7ca2                	ld	s9,40(sp)
    5f36:	7d02                	ld	s10,32(sp)
    5f38:	6de2                	ld	s11,24(sp)
    5f3a:	6109                	addi	sp,sp,128
    5f3c:	8082                	ret

0000000000005f3e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f3e:	715d                	addi	sp,sp,-80
    5f40:	ec06                	sd	ra,24(sp)
    5f42:	e822                	sd	s0,16(sp)
    5f44:	1000                	addi	s0,sp,32
    5f46:	e010                	sd	a2,0(s0)
    5f48:	e414                	sd	a3,8(s0)
    5f4a:	e818                	sd	a4,16(s0)
    5f4c:	ec1c                	sd	a5,24(s0)
    5f4e:	03043023          	sd	a6,32(s0)
    5f52:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f56:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f5a:	8622                	mv	a2,s0
    5f5c:	00000097          	auipc	ra,0x0
    5f60:	e04080e7          	jalr	-508(ra) # 5d60 <vprintf>
}
    5f64:	60e2                	ld	ra,24(sp)
    5f66:	6442                	ld	s0,16(sp)
    5f68:	6161                	addi	sp,sp,80
    5f6a:	8082                	ret

0000000000005f6c <printf>:

void
printf(const char *fmt, ...)
{
    5f6c:	711d                	addi	sp,sp,-96
    5f6e:	ec06                	sd	ra,24(sp)
    5f70:	e822                	sd	s0,16(sp)
    5f72:	1000                	addi	s0,sp,32
    5f74:	e40c                	sd	a1,8(s0)
    5f76:	e810                	sd	a2,16(s0)
    5f78:	ec14                	sd	a3,24(s0)
    5f7a:	f018                	sd	a4,32(s0)
    5f7c:	f41c                	sd	a5,40(s0)
    5f7e:	03043823          	sd	a6,48(s0)
    5f82:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f86:	00840613          	addi	a2,s0,8
    5f8a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f8e:	85aa                	mv	a1,a0
    5f90:	4505                	li	a0,1
    5f92:	00000097          	auipc	ra,0x0
    5f96:	dce080e7          	jalr	-562(ra) # 5d60 <vprintf>
}
    5f9a:	60e2                	ld	ra,24(sp)
    5f9c:	6442                	ld	s0,16(sp)
    5f9e:	6125                	addi	sp,sp,96
    5fa0:	8082                	ret

0000000000005fa2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5fa2:	1141                	addi	sp,sp,-16
    5fa4:	e422                	sd	s0,8(sp)
    5fa6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5fa8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fac:	00003797          	auipc	a5,0x3
    5fb0:	4a47b783          	ld	a5,1188(a5) # 9450 <freep>
    5fb4:	a805                	j	5fe4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5fb6:	4618                	lw	a4,8(a2)
    5fb8:	9db9                	addw	a1,a1,a4
    5fba:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5fbe:	6398                	ld	a4,0(a5)
    5fc0:	6318                	ld	a4,0(a4)
    5fc2:	fee53823          	sd	a4,-16(a0)
    5fc6:	a091                	j	600a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5fc8:	ff852703          	lw	a4,-8(a0)
    5fcc:	9e39                	addw	a2,a2,a4
    5fce:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5fd0:	ff053703          	ld	a4,-16(a0)
    5fd4:	e398                	sd	a4,0(a5)
    5fd6:	a099                	j	601c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fd8:	6398                	ld	a4,0(a5)
    5fda:	00e7e463          	bltu	a5,a4,5fe2 <free+0x40>
    5fde:	00e6ea63          	bltu	a3,a4,5ff2 <free+0x50>
{
    5fe2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fe4:	fed7fae3          	bgeu	a5,a3,5fd8 <free+0x36>
    5fe8:	6398                	ld	a4,0(a5)
    5fea:	00e6e463          	bltu	a3,a4,5ff2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fee:	fee7eae3          	bltu	a5,a4,5fe2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5ff2:	ff852583          	lw	a1,-8(a0)
    5ff6:	6390                	ld	a2,0(a5)
    5ff8:	02059813          	slli	a6,a1,0x20
    5ffc:	01c85713          	srli	a4,a6,0x1c
    6000:	9736                	add	a4,a4,a3
    6002:	fae60ae3          	beq	a2,a4,5fb6 <free+0x14>
    bp->s.ptr = p->s.ptr;
    6006:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    600a:	4790                	lw	a2,8(a5)
    600c:	02061593          	slli	a1,a2,0x20
    6010:	01c5d713          	srli	a4,a1,0x1c
    6014:	973e                	add	a4,a4,a5
    6016:	fae689e3          	beq	a3,a4,5fc8 <free+0x26>
  } else
    p->s.ptr = bp;
    601a:	e394                	sd	a3,0(a5)
  freep = p;
    601c:	00003717          	auipc	a4,0x3
    6020:	42f73a23          	sd	a5,1076(a4) # 9450 <freep>
}
    6024:	6422                	ld	s0,8(sp)
    6026:	0141                	addi	sp,sp,16
    6028:	8082                	ret

000000000000602a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    602a:	7139                	addi	sp,sp,-64
    602c:	fc06                	sd	ra,56(sp)
    602e:	f822                	sd	s0,48(sp)
    6030:	f426                	sd	s1,40(sp)
    6032:	f04a                	sd	s2,32(sp)
    6034:	ec4e                	sd	s3,24(sp)
    6036:	e852                	sd	s4,16(sp)
    6038:	e456                	sd	s5,8(sp)
    603a:	e05a                	sd	s6,0(sp)
    603c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    603e:	02051493          	slli	s1,a0,0x20
    6042:	9081                	srli	s1,s1,0x20
    6044:	04bd                	addi	s1,s1,15
    6046:	8091                	srli	s1,s1,0x4
    6048:	0014899b          	addiw	s3,s1,1
    604c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    604e:	00003517          	auipc	a0,0x3
    6052:	40253503          	ld	a0,1026(a0) # 9450 <freep>
    6056:	c515                	beqz	a0,6082 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6058:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    605a:	4798                	lw	a4,8(a5)
    605c:	02977f63          	bgeu	a4,s1,609a <malloc+0x70>
    6060:	8a4e                	mv	s4,s3
    6062:	0009871b          	sext.w	a4,s3
    6066:	6685                	lui	a3,0x1
    6068:	00d77363          	bgeu	a4,a3,606e <malloc+0x44>
    606c:	6a05                	lui	s4,0x1
    606e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6072:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6076:	00003917          	auipc	s2,0x3
    607a:	3da90913          	addi	s2,s2,986 # 9450 <freep>
  if(p == (char*)-1)
    607e:	5afd                	li	s5,-1
    6080:	a895                	j	60f4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    6082:	0000a797          	auipc	a5,0xa
    6086:	bf678793          	addi	a5,a5,-1034 # fc78 <base>
    608a:	00003717          	auipc	a4,0x3
    608e:	3cf73323          	sd	a5,966(a4) # 9450 <freep>
    6092:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6094:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6098:	b7e1                	j	6060 <malloc+0x36>
      if(p->s.size == nunits)
    609a:	02e48c63          	beq	s1,a4,60d2 <malloc+0xa8>
        p->s.size -= nunits;
    609e:	4137073b          	subw	a4,a4,s3
    60a2:	c798                	sw	a4,8(a5)
        p += p->s.size;
    60a4:	02071693          	slli	a3,a4,0x20
    60a8:	01c6d713          	srli	a4,a3,0x1c
    60ac:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    60ae:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    60b2:	00003717          	auipc	a4,0x3
    60b6:	38a73f23          	sd	a0,926(a4) # 9450 <freep>
      return (void*)(p + 1);
    60ba:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    60be:	70e2                	ld	ra,56(sp)
    60c0:	7442                	ld	s0,48(sp)
    60c2:	74a2                	ld	s1,40(sp)
    60c4:	7902                	ld	s2,32(sp)
    60c6:	69e2                	ld	s3,24(sp)
    60c8:	6a42                	ld	s4,16(sp)
    60ca:	6aa2                	ld	s5,8(sp)
    60cc:	6b02                	ld	s6,0(sp)
    60ce:	6121                	addi	sp,sp,64
    60d0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    60d2:	6398                	ld	a4,0(a5)
    60d4:	e118                	sd	a4,0(a0)
    60d6:	bff1                	j	60b2 <malloc+0x88>
  hp->s.size = nu;
    60d8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    60dc:	0541                	addi	a0,a0,16
    60de:	00000097          	auipc	ra,0x0
    60e2:	ec4080e7          	jalr	-316(ra) # 5fa2 <free>
  return freep;
    60e6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    60ea:	d971                	beqz	a0,60be <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60ee:	4798                	lw	a4,8(a5)
    60f0:	fa9775e3          	bgeu	a4,s1,609a <malloc+0x70>
    if(p == freep)
    60f4:	00093703          	ld	a4,0(s2)
    60f8:	853e                	mv	a0,a5
    60fa:	fef719e3          	bne	a4,a5,60ec <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    60fe:	8552                	mv	a0,s4
    6100:	00000097          	auipc	ra,0x0
    6104:	b7c080e7          	jalr	-1156(ra) # 5c7c <sbrk>
  if(p == (char*)-1)
    6108:	fd5518e3          	bne	a0,s5,60d8 <malloc+0xae>
        return 0;
    610c:	4501                	li	a0,0
    610e:	bf45                	j	60be <malloc+0x94>
