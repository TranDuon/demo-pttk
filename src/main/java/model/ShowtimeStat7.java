package model;

/** Lớp ShowtimeStat7 trong biểu đồ lớp thiết kế CineMan. */
public class ShowtimeStat7 extends Showtime7 {
    private int ticketCount;
    private double revenue;

    public int getTicketCount() {
        return ticketCount;
    }

    public void setTicketCount(int ticketCount) {
        this.ticketCount = ticketCount;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }
}
