package model;

import java.util.Date;
import java.sql.Time;

/** Lớp Showtime7 trong biểu đồ lớp thiết kế CineMan. */
public class Showtime7 {
    private int id;
    private Date showDate;
    private Time startTime;
    private double ticketPrice;
    private Movie7 movie;
    private Room7 room;
    private Manager7 manager;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getShowDate() {
        return showDate;
    }

    public void setShowDate(Date showDate) {
        this.showDate = showDate;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public double getTicketPrice() {
        return ticketPrice;
    }

    public void setTicketPrice(double ticketPrice) {
        this.ticketPrice = ticketPrice;
    }

    public Movie7 getMovie() {
        return movie;
    }

    public void setMovie(Movie7 movie) {
        this.movie = movie;
    }

    public Room7 getRoom() {
        return room;
    }

    public void setRoom(Room7 room) {
        this.room = room;
    }

    public Manager7 getManager() {
        return manager;
    }

    public void setManager(Manager7 manager) {
        this.manager = manager;
    }
}
