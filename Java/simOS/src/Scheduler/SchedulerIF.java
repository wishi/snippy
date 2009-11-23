package Scheduler;
import MemoryManagement.PCB;


public interface SchedulerIF {
        public int getRunningPid();
	public void timesliceOver();	
	public void endProcess();
	public void addProcess(PCB pcb);
	public void unblock(Event e);
	public void block (Event e);
}
