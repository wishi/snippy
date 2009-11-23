package Hardware;

import Scheduler.SchedulerIF;
import Scheduler.Event;
import MemoryManagement.ProcessManager;
import MainBoot.BootLoader;
import MainBoot.SysLogger;
import java.util.*;

public class CPU extends Thread {

  private int timer;
  private RegisterSet regSet;
  private MMU mmu;
  private IO io;
  private SchedulerIF scheduler;
  private ProcessManager processManager;
  private int blocked = 0;
  private Random random = new Random();

  /** Creates a new instance of CPU */
  public CPU(MMU mmu) {
    this.mmu = mmu;
    regSet = new RegisterSet();
    mmu.setRegisterSet(regSet);
    io = new IO();
  }

  public void setScheduler(SchedulerIF scheduler) {
    this.scheduler = scheduler;
  }

  public void setProcessManager(ProcessManager processManager) {
    this.processManager = processManager;
  }

  public void operate() throws BootLoader.ShutdownException {
    while (true) {
      int numInstructions = 9;// + random.nextInt(3);
      if (executeTimeslice(numInstructions) != blocked) {
        scheduler.timesliceOver();
      }
    }
  }

  public void saveRegisters(RegisterSet regSet) {
    // Die CPU gewährt keinen Zugriff auf ihre Register. Es wird zwar dieselbe
    // Klasse verwendet wie im PCB, die Inhalte werden aber kopiert.
    regSet.setBase(this.regSet.getBase());
    regSet.setLimit(this.regSet.getLimit());
    regSet.setProgramCounter(this.regSet.getProgramCounter());
    regSet.setRegister1(this.regSet.getRegister1());
    regSet.setRegister2(this.regSet.getRegister2());
    regSet.setConsole(this.regSet.getConsole());
  }

  public void restoreRegisters(RegisterSet regSet) {
    // Die CPU gewährt keinen Zugriff auf ihre Register. Es wird zwar dieselbe
    // Klasse verwendet wie im PCB, die Inhalte werden aber kopiert.
    this.regSet.setBase(regSet.getBase());
    this.regSet.setLimit(regSet.getLimit());
    this.regSet.setProgramCounter(regSet.getProgramCounter());
    this.regSet.setRegister1(regSet.getRegister1());
    this.regSet.setRegister2(regSet.getRegister2());
    this.regSet.setConsole(regSet.getConsole());
  }

  private int executeTimeslice(int numInstructions) throws BootLoader.ShutdownException {
    for (int i = 0; i < numInstructions; i++) {
      int pc = regSet.getProgramCounter();
      if (pc > -1) { // Unschön, könnte auch die Folge eines Programmierfehlers sein!
        String instruction;
        try {
          instruction = mmu.getMemoryCell(regSet.getProgramCounter());
        } catch (MMU.AccessViolation ex) {
          // Beende den laufenden Prozess
          scheduler.endProcess();
          return blocked;
        }
        SysLogger.writeLog(0, "CPU.executeTimeslice: pc: " + regSet.getProgramCounter() + ", command: " + instruction);
        if (executeCommand(instruction) == blocked) {
          return blocked;
        }
      } else {
        // "Run" the idle process
        try {
          sleep(20);
        } catch (InterruptedException ex) {
          ex.printStackTrace();
        }
      }
      // Nachschauen, ob ein Interrupt vorliegt, und ggf. behandeln
      Event event = io.getNextEvent();
      if (event != null && event.getType() == Event.read) {
        SysLogger.writeLog(0, "CPU.executeTimeslice: interrupt for event " + event.toString());
        mmu.setAbsoluteAddress(event.getAddress(), event.getContent());
        scheduler.unblock(event);
      }
    }
    return blocked + 1;
  }

  private String getRegister(String num) {
    if (num.equals("1")) {
      return regSet.getRegister1();
    } else {
      return regSet.getRegister2();
    }
  }

  private void setRegister(String num, double value) {
    if (value == Math.floor(value)) {
      setRegister(num, Integer.toString((int) value));
    } else {
      setRegister(num, Double.toString(value));
    }
  }

  private void setRegister(String num, int value) {
    setRegister(num, Integer.toString(value));
  }

  private void setRegister(String num, String value) {
    if (num.equals("1")) {
      regSet.setRegister1(value);
    } else {
      regSet.setRegister2(value);
    }
  }

  private void mathOpRegister(String num, String op, String value) {
    mathOpRegister(num, op, Double.parseDouble(value));
  }

  private void mathOpRegister(String num, String op, double value) {
    System.out.println("DEBUG: " + num + " " + op + " " + value);
    double arg1;
    double arg2 = value;
    double result = 0;
    arg1 = Double.parseDouble(getRegister(num));
    if (op.equals("add")) {
      result = arg1 + arg2;
    } else if (op.equals("sub")) {
      result = arg1 - arg2;
    } else if (op.equals("mul")) {
      result = arg1 * arg2;
    } else if (op.equals("div")) {
      result = arg1 / arg2;
    }
    System.out.println("DEBUG: " + num + " " + result);
    setRegister(num, result);
  }

  private int executeCommand(String instruction) throws BootLoader.ShutdownException {
    regSet.setProgramCounter(regSet.getProgramCounter() + 1);
    String[] cmd = instruction.split("\\s+");
    if (cmd.length > 0) {
      //--------- Arithmetik ----------
      // inc
      if (cmd[0].equals("inc")) {
        mathOpRegister(cmd[1], "add", 1);
      } else if (cmd[0].equals("dec")) {
        mathOpRegister(cmd[1], "sub", 1);
      } else if (cmd[0].equals("add") || cmd[0].equals("sub") || cmd[0].equals("mul") || cmd[0].equals("div")) {
        if (cmd[2].startsWith("#")) {
          mathOpRegister(cmd[1], cmd[0], cmd[2].substring(1));
        } else {
          mathOpRegister(cmd[1], cmd[0], getRegister(cmd[2]));
        }
      } else if (cmd[0].equals("rand")) {
        int lb = Integer.parseInt(cmd[1]);
        int ub = Integer.parseInt(cmd[2]);
        int r = lb + random.nextInt(ub - lb + 1);
        setRegister("1", r);

      //--------- Register, Speicher ----------
      } else if (cmd[0].equals("store")) {
        try {
          if (cmd[1].startsWith("#")) {
            mmu.setMemoryCell(cmd[2], cmd[1].substring(1));
          } else {
            mmu.setMemoryCell(cmd[2], getRegister(cmd[1]));
          }
        } catch (MMU.AccessViolation ex) {
          io.write(regSet.getConsole(), "\nACCESS VIOLATION\n");
          scheduler.endProcess();
          return blocked;
        }

      } else if (cmd[0].equals("load")) {
        if (cmd[2].startsWith("#")) {
          setRegister(cmd[1], cmd[2].substring(1));
        } else {
          try {
            setRegister(cmd[1], mmu.getMemoryCell(cmd[2]));
          } catch (MMU.AccessViolation ex) {
            io.write(regSet.getConsole(), "\nACCESS VIOLATION\n");
            scheduler.endProcess();
            return blocked;
          }
        }

      //--------- Sprünge ----------
      } else if (cmd[0].equals("jmp")) {
        regSet.setProgramCounter(Integer.parseInt(cmd[1]));

      } else if (cmd[0].equals("jeq")) {
        if (getRegister("1").equals(getRegister("2"))) {
          regSet.setProgramCounter(Integer.parseInt(cmd[1]));
        }

      } else if (cmd[0].equals("jne")) {
        if (!getRegister("1").equals(getRegister("2"))) {
          regSet.setProgramCounter(Integer.parseInt(cmd[1]));
        }

      } else if (cmd[0].equals("jlt")) {
        if (Double.parseDouble(getRegister("1")) < Double.parseDouble(getRegister("2"))) {
          regSet.setProgramCounter(Integer.parseInt(cmd[1]));
        }

      } else if (cmd[0].equals("jgt")) {
        if (Double.parseDouble(getRegister("1")) > Double.parseDouble(getRegister("2"))) {
          regSet.setProgramCounter(Integer.parseInt(cmd[1]));
        }

      //--------- Systemaufrufe für Prozesssteuerung ----------
      } else if (cmd[0].equals("create_process")) {
        String address;
        if (cmd[1].startsWith("[")) {
          // create_process [<address>]
          // Indirekte Adressierung
          cmd[1] = cmd[1].substring(1, cmd[1].length() - 1);
          try {
            String indAddress = mmu.getMemoryCell(cmd[1]);
            address = mmu.getMemoryCell(indAddress);
          } catch (MMU.AccessViolation ex) {
            io.write(regSet.getConsole(), "\nACCESS VIOLATION\n");
            scheduler.endProcess();
            return blocked;
          }
        } else {
          try {
            // create_process <address>
            // Die Adresse gibt die Speicherzelle an, in der der Dateiname steht
            address = mmu.getMemoryCell(cmd[1]);
          } catch (MMU.AccessViolation ex) {
            io.write(regSet.getConsole(), "\nACCESS VIOLATION\n");
            scheduler.endProcess();
            return blocked;
          }
        }
        int pid = processManager.createProcess(address);
        setRegister("1", pid);
      // Schreibt die PID des laufenden Prozesses in das angegebene Register

      } else if (cmd[0].equals("get_pid")) {
        setRegister(cmd[1], scheduler.getRunningPid());
      // wait <pid>

      } else if (cmd[0].equals("wait")) {
        // Ein wait-Event mit der id PID wird erstellt.
        Event event;
        if (cmd[1].startsWith("#")) {
          event = new Event(Event.wait, Integer.parseInt(cmd[1].substring(1)));
        } else {
          event = new Event(Event.wait, Integer.parseInt(getRegister(cmd[1])));
        }
        // Der Aufrufer wird blockiert
        scheduler.block(event);
        return blocked; // Etwas hölzern. Eine Execption wäre wohl ganz angebracht.
//      } else if( cmd[0].equals("kill") ) {
      //TBD
      // quit

      } else if (cmd[0].equals("quit")) {
        if (scheduler.getRunningPid() == 1) {
          // Der init-Prozess endet. Das System wird heruntergefahren
          throw new BootLoader.ShutdownException();
        }
        scheduler.endProcess();
        return blocked;

      //--------- Systemaufrufe für Ein/Ausgabe ----------
      // create_console
      } else if (cmd[0].equals("create_console")) {
        if (regSet.getConsole() != null) {
          // Der Prozess hatte schon eine Konsole
          regSet.getConsole().decRefcount();
        }
        regSet.setConsole(io.createConsole("Prozess " + scheduler.getRunningPid()));

      } else if (cmd[0].equals("read")) {
        // read <DMA address>
        // Die Adresse gibt an, wohin die empfangene Eingabe geschrieben wird.
        Event event;
        try {
          event = new Event(Event.read, scheduler.getRunningPid(), mmu.resolveAddress(cmd[1]));
        } catch (MMU.AccessViolation ex) {
          io.write(regSet.getConsole(), "\nACCESS VIOLATION\n");
          scheduler.endProcess();
          return blocked;
        }
        event.setConsole(regSet.getConsole());
        // Der Gerätetreiber wird informiert
        io.read(event);
        // Der Aufrufer wird blockiert
        scheduler.block(event);
        return blocked; // Etwas hölzern. Eine Execption wäre wohl ganz angebracht.
      // read_console <DMA address>
      // write

      } else if (cmd[0].equals("write_reg")) {
        io.write(regSet.getConsole(), getRegister(cmd[1]));

      } else if (cmd[0].equals("write_mem")) {
        try {
          io.write(regSet.getConsole(), mmu.getMemoryCell(cmd[1]));
        } catch (MMU.AccessViolation ex) {
          io.write(regSet.getConsole(), "\nACCESS VIOLATION\n");
          scheduler.endProcess();
          return blocked;
        }

      } else if (cmd[0].equals("write_val")) {
        io.write(regSet.getConsole(), cmd[1].replaceAll("\\u005c0020", " ")); // Geht "\u0020" auch anders?

      } else if (cmd[0].equals("write_nl")) {
        io.writeln(regSet.getConsole());

      //--------- Ungültige Instruktion ----------
      } else {
        SysLogger.writeLog(0, "CPU.executeCommand: Syntax Error");
        if (scheduler.getRunningPid() == 1) {
          // Der init-Prozess endet. Das System wird heruntergefahren
          throw new BootLoader.ShutdownException();
        }
        scheduler.endProcess();
        return blocked;
      }
    }
    return blocked + 1;
  }
}

