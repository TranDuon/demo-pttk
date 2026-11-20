package model;

/** Lớp MovieStat7 trong biểu đồ lớp thiết kế CineMan. */
public class MovieStat7 extends Movie7 {
    private int showtimeCount;
    private int ticketCount;
    private double totalRevenue;

    public int getShowtimeCount() {
        return showtimeCount;
    }

    public void setShowtimeCount(int showtimeCount) {
        this.showtimeCount = showtimeCount;
    }

    public int getTicketCount() {
        return ticketCount;
    }

    public void setTicketCount(int ticketCount) {
        this.ticketCount = ticketCount;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}
