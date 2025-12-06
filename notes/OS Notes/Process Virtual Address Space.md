
### Title: **Process Address Space**

- Each process (A and B here) has its own **virtual address space**.
    
- Virtual memory makes it look like each process has the same layout of memory (from address `0` to `MAXVA`).
    
- The OS and hardware (through page tables) translate these virtual addresses into **physical memory** addresses.
    

---

### Key Points from the Slide:

1. **Same Layout for All Processes**
    
    - Both Process A and Process B have memory organized into:
        
        - **Text (instructions)** – program code, usually read-only.
            
        - **Data** – global variables, static data.
            
        - **Stack** – grows/shrinks dynamically, used for function calls and local variables.
            
        - **Heap** – dynamically allocated memory (`malloc`, `new`, etc.).
            
        - **Trapframe and trampoline** – special regions near the top of address space used for handling system calls and traps (kernel-related).
            
    
    Despite looking identical, the actual physical memory behind these is **different for each process**.
    

---

2. **Trampoline & Trapframe (at top of memory)**
    
    - **Trapframe**: space to save registers and state when a trap (like system call or interrupt) occurs.
        
    - **Trampoline**: small code snippet that helps transition between **user mode** and **kernel mode** safely.
        

---

3. **Page Tables (on the side)**
    
    - Each process has its **own page table** that maps its virtual memory to physical memory.
        
    - Example:
        
        - Process A’s virtual address `0x1000` might map to physical address `0x3000`.
            
        - Process B’s virtual address `0x1000` could map to a completely different physical address `0x7000`.
            
    - This ensures **isolation**: one process cannot access another’s memory directly.
        

---

4. **Isolation & Protection**
    
    - Even though both processes have the same virtual address ranges (`0 → MAXVA`), they don’t interfere because of page tables.
        
    - This is why you can run multiple programs at once without their memory colliding.


### Advantages of Virtual Address Mapping

### **1. Isolation (private address space)**

- **What it means**:  
    Each process thinks it owns the whole memory space (`0 → MAXVA`). In reality, the OS and hardware ensure that one process cannot peek into or modify another process’s memory.
    
- **Why it matters**:
    
    - Protects sensitive data (passwords, keys, etc.) in one process from being read by another.
        
    - Prevents crashes in one program from corrupting another.
        
    - Fundamental for security (malware cannot directly read/write another program’s memory).
        
- **Example**:  
    If Process A has an array at virtual address `0x1000`, Process B could also have something at `0x1000` — but these map to **different physical locations**, so they never clash.
    

---

### **2. Relocatable**

- **What it means**:  
    Since every process sees the same logical memory layout, the program doesn’t care about where in physical memory it is actually stored.
    
- **Why it matters**:
    
    - The OS can load a process anywhere in physical memory without changing the program’s code.
        
    - Simplifies programming: developers don’t need to hardcode memory addresses.
        
    - Enables swapping and dynamic memory allocation easily.
        
- **Example**:  
    Imagine you download a program compiled to run at address `0x0 → 0x2000`. Virtual memory makes it run fine even if those physical locations are already occupied by another process — it just maps them elsewhere.
    

---

### **3. Size (larger than physical memory)**

- **What it means**:  
    Virtual memory allows a process’s address space to be much larger than the actual RAM, by using **paging + disk (swap space)**.
    
- **Why it matters**:
    
    - A process can use more memory than what is physically available.
        
    - Only actively used portions of memory need to stay in RAM; the rest can live on disk.
        
    - Makes large applications (databases, browsers, simulations) feasible on machines with limited RAM.
        
- **Example**:  
    Suppose your system has 8 GB of RAM, but a process needs 20 GB of memory. Virtual memory lets the OS keep frequently used parts in RAM and the rest in disk, so the process still sees a continuous 20 GB space.



### 1. **User Space Stack**

- **Location**: Part of the process’s virtual address space (see left diagram).
    
- **Usage**:
    
    - Used when executing **user-level code** (your C, Python, Java program, etc.).
        
    - Holds function call frames, return addresses, local variables, parameters.
        
- **Scope**:
    
    - Only accessible by the process itself while in **user mode**.
        
    - Kernel does **not** trust this stack because it can be corrupted by buggy or malicious code.
        

---

### 2. **Kernel Space Stack**

- **Location**: Inside the **kernel address space**, separate from the user stack (see right diagram).
    
- **Usage**:
    
    - Used when the process enters **kernel mode** (via a system call, interrupt, or exception).
        
    - Holds kernel function calls, local variables, and context while executing on behalf of the process.
        
- **Scope**:
    
    - Not visible to user programs.
        
    - Ensures the kernel runs safely even if the user stack is corrupted.
        

---

### 3. **Why Two Stacks?**

- If the kernel shared the user stack:
    
    - A **buffer overflow attack** in user space could overwrite kernel control data, leading to privilege escalation.
        
    - Kernel execution would crash if user stack were corrupted.
        
- By having a **separate kernel stack**, the kernel operates on safe memory **completely isolated** from user code.
    

---

### 4. **Advantage (Highlighted in Slide)**

- **Kernel remains safe and functional even if the user stack is corrupted.**
    
- Example:
    
    - A hacker tries a buffer overflow on the user stack.
        
    - They can overwrite return addresses in **user space**, but they cannot touch the kernel’s private stack.
        
    - This prevents kernel compromise.
        

---
### 🔹 Fields

#### **1. `struct spinlock lock;`**

- Every process structure is shared across different parts of the kernel (scheduler, exit handler, etc.).
    
- To avoid races (e.g., two CPUs modifying the same process state at once), we need a lock.
    
- This lock must be held before modifying most fields of the `proc`.
    

---

#### **2. `enum procstate state;`**

- Current **state** of the process: `UNUSED`, `SLEEPING`, `RUNNABLE`, `RUNNING`, `ZOMBIE`.
    
- The scheduler depends on this to know whether a process can be chosen to run.

#### **3. `void *chan;`**

- Channel the process is **sleeping on** (a wait queue, like waiting for I/O or a condition).
    
- When another process wakes it up, the kernel checks if `p->chan == that chan`

- 🔹 How it’s used

1. **Sleeping**
    
    - Suppose a process is waiting for disk I/O to finish.
        
    - Kernel code will do:
        
        `p->chan = buf;   // buf is the buffer it's waiting for p->state = SLEEPING;`
        
    - Now the scheduler will not run this process until it’s woken up.
        
2. **Waking up**
    
    - When the disk driver finishes filling `buf`, it calls:
        
        `wakeup(buf);`
        
    - Inside `wakeup()`, the kernel loops over processes:
        
        `if (p->state == SLEEPING && p->chan == buf)     p->state = RUNNABLE;`
        
    - Only the processes sleeping on **that exact channel** are made runnable again.

#### **4. `int killed;`**

- Indicates if the process has been marked for termination.
    
- Even if a process is sleeping, the kernel can set `killed=1` so when it wakes up, it exits.
    

---

#### **5. `int xstate;`**

- Exit status of the process (what it returns via `exit()` call).
    
- Stored so the parent can later read it using `wait()`.
    

---

#### **6. `int pid;`**

- Process ID (unique number per process).
    
- Needed to identify processes (for syscalls like `kill(pid)`, debugging, process tables).
    

---

#### **7. `struct proc *parent;`**

- Pointer to the parent process.
    
- Needed for implementing **process hierarchy** and for `wait()`, where a parent reaps the exit status of its children.

#### **8. `uint64 kstack;`**

- Virtual address of the **kernel stack** for this process.
    
- Every process has its own kernel stack (discussed earlier), needed when the process runs kernel code (syscalls, traps).
    

---

#### **9. `uint64 sz;`**

- Size of the process’s **user memory** in bytes.
    
- Used for memory allocation (`sbrk()`), loading programs, and protecting against out-of-bounds access.
    

---

#### **10. `pagetable_t pagetable;`**

- Page table for the process’s **user address space**.
    
- Maps user virtual addresses (`0 → MAXVA`) to physical memory pages.
    
- Each process has its own independent page table to provide **isolation**.
    

---

#### **11. `struct trapframe *trapframe;`**

- Holds saved CPU registers during a trap/interrupt/syscall.
    
- Used when the kernel wants to resume user code after handling the trap.
    
- This is where the **trampoline code** stores/restores user registers.
    

---

#### **12. `struct context context;`**

- Stores kernel-only registers (like `ra`, `sp`, `s0-s11`) when switching between processes (`swtch()`).
    
- Needed by the scheduler to resume the process later.
    
- Contrast: `trapframe` is for **user → kernel traps**, `context` is for **kernel → kernel context switches**.
    

---

#### **13. `struct file *ofile[NOFILE];`**

- Array of pointers to open files.
    
- Needed for syscalls like `read`, `write`, `close`.
    
- Implements **per-process file descriptor table**.
    

---

#### **14. `struct inode *cwd;`**

- Pointer to the process’s **current working directory**.
    
- Needed for relative pathnames in syscalls (`open("foo.txt")` means `<cwd>/foo.txt`).
    

---

#### **15. `char name[16];`**

- Name of the process (for debugging/diagnostics, `ps`-like output).
    
- Not strictly necessary for execution, but very useful for system monitoring.


## Process States

### The Diagram (middle part)

This shows how a process moves between states:

1. **UNUSED**
    
    - Means the process slot is free (not assigned).
        
    - Example: Think of it as an empty seat in a classroom. No process is sitting there.
        
2. **RUNNABLE**
    
    - Process is ready to run, just waiting for CPU time.
        
    - Example: Students raising hands, waiting for the teacher to call them.
        
3. **RUNNING**
    
    - Process is currently running on the CPU.
        
    - Example: The student the teacher is currently listening to.
        
4. **SLEEPING**
    
    - Process is waiting (blocked) for some event like I/O (disk, network, keyboard, etc.).
        
    - Example: A student waiting for someone to bring them a book before continuing.
        
5. **ZOMBIE**
    
    - Process finished execution, but still has an entry in the process table (so parent can check exit status).
        
    - Example: A student finished the exam but hasn’t submitted their paper yet.
        

---

### The Flow

- **UNUSED → RUNNABLE**: A new process is created.
    
- **RUNNABLE → RUNNING**: Scheduler gives CPU to the process.
    
- **RUNNING → RUNNABLE**: CPU time is up, goes back to waiting.
    
- **RUNNING → SLEEPING**: Process requests I/O, blocks until I/O finishes.
    
- **SLEEPING → RUNNABLE**: I/O is done, ready again.
    
- Later you’ll learn: **RUNNING → ZOMBIE** when a process finishes.
    

---

### Bottom Explanation (colored text)

- **UNUSED** → slot free
    
- **RUNNABLE** → ready to run
    
- **RUNNING** → currently executing
    
- **SLEEPING** → waiting for I/O
    
- **ZOMBIE** → dead process waiting to be cleaned up



## When the scheduler runs (triggers)

1. **Timer interrupt** (periodic): the CPU generates an interrupt (every ~100 ms on the slide). The interrupt handler runs in kernel mode and eventually invokes the scheduler if a switch is needed. This implements time-sharing / preemption.
    
2. **Process blocks**: if the running process blocks on I/O (e.g., `read()` waiting for disk), it voluntarily yields the CPU and becomes `SLEEPING`. The scheduler runs to pick another.
    
3. **Process exits**: the process finishes; the scheduler picks someone else.
    
4. **Explicit yield**: a process can call `yield()` to give up CPU voluntarily (common in teaching OSes).
    

---

## What the scheduler does (high level)

1. Stop current execution (via interrupt or syscall).
    
2. Save the running process’s CPU context (registers, program counter) into its **process control block (PCB)**.
    
3. Change the process’s state:
    
    - If it still can run: `RUNNING` → `RUNNABLE` (if preempted).
        
    - If it blocked: `RUNNING` → `SLEEPING`.
        
    - If it exited: `RUNNING` → `ZOMBIE`.
        
4. Choose a **runnable** process from the ready queue.
    
5. Update that process’s state: `RUNNABLE` → `RUNNING`.
    
6. Restore that process’s saved context and resume it (context switch).
    

---

## Context switch (what is saved/restored)

- **Saved**: general-purpose registers, program counter, stack pointer, CPU flags. Often the kernel saves user registers into a `trapframe` and kernel scheduling registers into a `context` structure.
    
- **Restored**: the chosen process’s registers and program counter so it continues executing where it left off.
    
- **Also**: Kernel must change the active page table / address space if switching between processes.
    

Context switches are not free — they cost time (cache misses, TLB flushes, instructions to save/restore), so schedulers try to balance fairness/responsiveness vs overhead.

---

## The ready queue — data structure choices

- **Simple queue (Round Robin)**: FIFO queue; each process gets a fixed time slice (quantum). After its quantum expires it goes to the back of the queue.
    
    - Good for fairness and simplicity.
        
- **Multiple queues or priority queues**: processes are placed into buckets by priority. The scheduler picks highest-priority runnable process first.
    
- **Per-CPU run queues** (on SMP systems): each CPU has its own ready queue; sometimes a load balancer moves tasks between CPUs.
    

Which one is used depends on the OS design and policy.

---

## Time slice (quantum) tradeoffs

- **Short quantum** → more responsive interactive system, but more context switch overhead.
    
- **Long quantum** → less overhead, better throughput for CPU-bound jobs, but less responsiveness.  
    Slide’s “100 ms” is an example time-slice/timer frequency — modern OSes often use much smaller quanta.
    

---

## Example timeline (concrete)

1. Process A is running.
    
2. Timer interrupt fires (every 100 ms). CPU transfers control to interrupt handler in kernel.
    
3. Kernel increments accounting, checks if A used up quantum → decides to preempt.
    
4. Kernel saves A’s registers into A’s PCB, sets `A.state = RUNNABLE`.
    
5. Scheduler picks process B from ready queue, sets `B.state = RUNNING`.
    
6. Kernel restores B’s registers and switches to B’s stack/context → B resumes on CPU.
    
7. Later, B may block on I/O (set `B.state = SLEEPING`) and the scheduler will pick the next runnable process.



