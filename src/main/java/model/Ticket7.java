package model;

/** Lớp Ticket7 trong biểu đồ lớp thiết kế CineMan. */
public class Ticket7 {
    private int id;
    private double price;
    private Seat7 seat;
    private Showtime7 showtime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Seat7 getSeat() {
        return seat;
    }

    public void setSeat(Seat7 seat) {
        this.seat = seat;
    }

    public Showtime7 getShowtime() {
        return showtime;
    }

    public void setShowtime(Showtime7 showtime) {
        this.showtime = showtime;
    }
}
